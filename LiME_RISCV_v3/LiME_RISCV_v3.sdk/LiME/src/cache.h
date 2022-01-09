/*
 * cache.h
 *
 *  Created on: Sep 16, 2014
 *      Author: lloyd23
 */

#ifndef CACHE_H_
#define CACHE_H_

//------------------ Cache ------------------//
// cache management on host and accelerator

#define CACHE_BARRIER {host::cache_flush_invalidate();}
#define CACHE_DISPOSE(p,n) {host::cache_invalidate(p,n);}

#define CACHE_SEND_ALL
#define CACHE_RECV_ALL
#define CACHE_SEND(d,p,n)
#define CACHE_RECV(d,p,n)

#if defined(ZYNQ)
#include "xil_cache.h"
#include "xil_cache_l.h" // Xil_L1D*
#include "xpseudo_asm.h" // mtcp, dsb
#include "xreg_cortexa9.h" // XREG_CP15_*
namespace host {
inline void cache_flush(void) {Xil_DCacheFlush();}
inline void cache_flush(const void *ptr, size_t size) {Xil_DCacheFlushRange((unsigned int)ptr, (unsigned)size);}
inline void cache_flush_invalidate(void) {Xil_DCacheFlush();}
inline void cache_flush_invalidate(const void *ptr, size_t size) {Xil_DCacheFlushRange((unsigned int)ptr, (unsigned)size);}
inline void cache_invalidate(void) {Xil_DCacheInvalidate();}
inline void cache_invalidate(const void *ptr, size_t size) {Xil_DCacheInvalidateRange((unsigned int)ptr, (unsigned)size);}
} // namespace host

#else
namespace host {
inline void cache_flush(void) {}
inline void cache_flush(const void *ptr, size_t size) {}
inline void cache_flush_invalidate(void) {}
inline void cache_flush_invalidate(const void *ptr, size_t size) {}
inline void cache_invalidate(void) {}
inline void cache_invalidate(const void *ptr, size_t size) {}
} // namespace host

/* ARM CP15 operations with mcr instruction */
#define mtcp(reg,val)
/* Data Synchronization Barrier */
#define dsb()

/* flush & invalidate entire L1 data cache */
#define Xil_L1DCacheFlush()
/* invalidate range of L1 data cache */
#define Xil_L1DCacheInvalidateRange(addr, size)

#endif

#endif /* CACHE_H_ */
