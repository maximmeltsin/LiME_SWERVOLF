/* -*- mode: C; tab-width: 2; indent-tabs-mode: nil; -*- */

/*
 * This code has been contributed by the DARPA HPCS program.  Contact
 * David Koester <dkoester@mitre.org> or Bob Lucas <rflucas@isi.edu>
 * if you have questions.
 *
 * GUPS (Giga UPdates per Second) is a measurement that profiles the memory
 * architecture of a system and is a measure of performance similar to MFLOPS.
 * The HPCS HPCchallenge RandomAccess benchmark is intended to exercise the
 * GUPS capability of a system, much like the LINPACK benchmark is intended to
 * exercise the MFLOPS capability of a computer.  In each case, we would
 * expect these benchmarks to achieve close to the "peak" capability of the
 * memory system. The extent of the similarities between RandomAccess and
 * LINPACK are limited to both benchmarks attempting to calculate a peak system
 * capability.
 *
 * GUPS is calculated by identifying the number of memory locations that can be
 * randomly updated in one second, divided by 1 billion (1e9). The term "randomly"
 * means that there is little relationship between one address to be updated and
 * the next, except that they occur in the space of one half the total system
 * memory.  An update is a read-modify-write operation on a table of 64-bit words.
 * An address is generated, the value at that address read from memory, modified
 * by an integer operation (add, and, or, xor) with a literal value, and that
 * new value is written back to memory.
 *
 * We are interested in knowing the GUPS performance of both entire systems and
 * system subcomponents --- e.g., the GUPS rating of a distributed memory
 * multiprocessor the GUPS rating of an SMP node, and the GUPS rating of a
 * single processor.  While there is typically a scaling of FLOPS with processor
 * count, a similar phenomenon may not always occur for GUPS.
 *
 * For additional information on the GUPS metric, the HPCchallenge RandomAccess
 * Benchmark,and the rules to run RandomAccess or modify it to optimize
 * performance -- see http://icl.cs.utk.edu/hpcc/
 *
 */

/*
 * This file contains the computational core of the single cpu version
 * of GUPS.  The inner loop should easily be vectorized by compilers
 * with such support.
 *
 * This core is used by both the single_cpu and star_single_cpu tests.
 */

#include "hpcc.h"
#include "RandomAccess.h"

#include "config.h"
#include "alloc.h"
#include "cache.h"
#include "monitor.h"
#include "ticks.h"
#include "clocks.h"

typedef index_t* index_p;
typedef table_t* table_p;
typedef uran_t*  uran_p;

tick_t start, finish;
tick_t t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, t10;
unsigned long long tsetup, treorg, toper, tcache;


#ifdef VECTOR

static void
RandomAccessUpdate_LCG(unsigned int logTableSize, size_t TableSize, table_p Table, nupdate_t nupdate)
{
	nupdate_t i;
	size_t j;
	uran_t ran[VECT_LEN]; /* current random numbers */

	tget(t2);
	for (j=0; j<VECT_LEN; j++)
		ran[j] = HPCC_starts_LCG((nupdate/VECT_LEN) * j);

	for (i=0; i<nupdate/VECT_LEN; i++) {
		for (j=0; j<VECT_LEN; j++) {
			ran[j] = LCG_MUL64 * ran[j] + LCG_ADD64;
			Table[ran[j] >> (sizeof(uran_t)*8 - logTableSize)] ^= ran[j];
		}
	}
	tget(t3);
	host::cache_flush(); /* flush all since Table size is half of memory */
	tget(t4);
	toper += tdiff(t3,t2);
	tcache += tdiff(t4,t3);
}

#else /* VECTOR */

/* Perform updates to main table -- scalar version */
static void
RandomAccessUpdate_LCG(unsigned int logTableSize, size_t TableSize, table_p Table, nupdate_t nupdate)
{
	nupdate_t i;
	uran_t ran;
	ran = 1;
	for (i=0; i<nupdate; i++) {
		ran = LCG_MUL64 * ran + LCG_ADD64;
		Table[ran >> (sizeof(uran_t)*8 - logTableSize)] ^= ran;
	}
}

#endif /* VECTOR */

int
HPCC_RandomAccess_LCG(HPCC_Params *params, int doIO, double *GUPs, int *failure)
{
	nupdate_t nupdate;
	size_t t;
//	double cputime;               /* CPU time to update table */
	double realtime;              /* Real time to update table */
	double totalMem;
	table_p Table;
	size_t TableSize;
	unsigned int logTableSize;
	FILE *outFile = NULL;

	if (doIO) {
		if (params->outFname[0] == '\0')
			outFile = stdout;
		else
			outFile = fopen(params->outFname, "a");
		if (!outFile) {
			outFile = stderr;
			fprintf(outFile, "Cannot open output file.\n");
			return 1;
		}
	}

	/* calculate local memory per node for the update table */
	totalMem = params->HPLMaxProcMem;
	totalMem /= sizeof(table_t);

	/* calculate the size of update array (must be a power of 2) */
	for (totalMem *= 0.5, logTableSize = 0, TableSize = 1;
		totalMem >= 1.0;
		totalMem *= 0.5, logTableSize++, TableSize <<= 1)
		; /* EMPTY */

	Table = HPCC_XMALLOC(table_t, TableSize);
	if (!Table) {
		if (doIO) {
			fprintf(outFile, "Failed to allocate memory for the update table (" FSTRU64 ").\n", (u64Int)TableSize);
			if (params->outFname[0] != '\0') fclose(outFile);
		}
		return 1;
	}
	params->RandomAccess_LCG_N = (s64Int)TableSize;
	nupdate = (nupdate_t)TableSize * UPDATE_FACTOR;

	/* Print parameters for run */
	if (doIO) {
		//fprintf(outFile, "Main table addr   = %p\n", Table);
		//fprintf(outFile, "Main table size   = 2^%u = " FSTRU64 " words (%u bytes)\n", logTableSize, (u64Int)TableSize, (unsigned)sizeof(table_t));
		//fprintf(outFile, "Number of updates = " FSTRU64 "\n", (u64Int)nupdate);
	}

	/* Initialize main table */
	for (t=0; t<TableSize; t++) Table[t] = t;

	/* Begin timing here */
	tsetup = treorg = tcache = 0;
	CLOCKS_EMULATE
	CACHE_BARRIER
	TRACE_START
	STATS_START
	/* assume input data is in memory and not cached (flushed and invalidated) */
	tget(start);
//	cputime = -CPUSEC();
//	realtime = -RTSEC();

	RandomAccessUpdate_LCG(logTableSize, TableSize, Table, nupdate);

	/* End timed section */
	/* assume output data is in memory (flushed) */
	tget(finish);
	CACHE_BARRIER
	STATS_STOP
	TRACE_STOP
	CLOCKS_NORMAL
	toper = tdiff(finish,start)-tsetup-treorg-tcache;
	realtime = tesec(finish,start);
//	cputime += CPUSEC();
//	realtime += RTSEC();

	/* make sure no division by zero */
	*GUPs = (realtime > 0.0 ? 1.0 / realtime : -1.0);
	*GUPs *= 1e-9*nupdate;
	/* Print timing results */
	if (doIO) {
//		fprintf(outFile, "CPU time used  = %.6f seconds\n", cputime);
		fprintf(outFile, "Real time used = %.6f seconds\n", realtime);
		//fprintf(outFile, "%.9f Billion(10^9) Updates per second [GUP/s]\n", *GUPs);
		//fprintf(outFile, "Oper. time: %f sec\n", toper/(double)TICKS_ESEC);
		//fprintf(outFile, "Cache time: %f sec\n", tcache/(double)TICKS_ESEC);
		STATS_PRINT
	}

#if defined(VERIFY) && !defined(COUNT_DUP)
	/* Verification of results (in serial or "safe" mode; optional) */
	{
		nupdate_t i;
		size_t errors = 0;
		uran_t temp = 1;

		for (i=0; i<nupdate; i++) {
			temp = LCG_MUL64 * temp + LCG_ADD64;
			Table[temp >> (sizeof(uran_t)*8 - logTableSize)] ^= temp;
		}

		for (t=0; t<TableSize; t++)
			if (Table[t] != t)
				errors++;

		if (doIO) {
			//fprintf(outFile, "Found " FSTRU64 " errors in " FSTRU64 " locations (%s).\n",
			//		(u64Int)errors, (u64Int)TableSize, (errors <= 0.01*TableSize) ? "passed" : "failed");
		}
		if (errors <= 0.01*TableSize) *failure = 0;
		else *failure = 1;
	}
#endif

	HPCC_free(Table);

	if (doIO) {
		fflush(outFile);
		if (params->outFname[0] != '\0') fclose(outFile);
	}

	return 0;
}
