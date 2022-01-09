/*
 * randa.c
 *
 *  Created on: Sep 12, 2014
 *      Author: lloyd23
 */

#include "hpcc.h"
#include "RandomAccess.h"

#include "config.h"
#include "alloc.h"
#include "cache.h"
#include "monitor.h"
#include "ticks.h"
#include "clocks.h"

#include "xil_types.h"
//#include "ff.h"
#include "xil_printf.h"
#include <xstatus.h>
#include "xil_cache.h"

//static FATFS  fatfs;

// UDP
#include "platform.h"
#include "platform_config.h"
#include "lwip/init.h"
#include "netif/xadapter.h"
#include "lwip/inet.h"
#include "lwip/udp.h"
#include "lwip/pbuf.h"
#include "udp_perf_server.h"
#include "lwip/priv/tcp_priv.h"
#define DEFAULT_IP_ADDRESS	"192.168.1.10"
#define DEFAULT_IP_MASK		"255.255.255.0"
#define DEFAULT_GW_ADDRESS	"192.168.1.1"
#define HOST_IP_ADDRESS	    "192.168.1.20"
#define HOST_PORT      	    5200
#define UDP_CONN_PORT 5001
struct netif server_netif;
struct netif *netif;
struct udp_pcb *pcb;
extern volatile int TcpFastTmrFlag;
extern volatile int TcpSlowTmrFlag;
ip_addr_t host_addr;
pbuf *p;

// For trace monitor
int last_addr;

// TODO: find a better place for these globals

#if defined(STATS) || defined(TRACE) 
XAxiPmon apm;
#endif // STATS || TRACE

static void udp_recv_perf_traffic(void *arg, struct udp_pcb *tpcb,
		struct pbuf *p, const ip_addr_t *addr, u16_t port)
{
	return;
}

int main()
{
	HPCC_Params params;

	/*FIL fil;
	FRESULT rc;
	TCHAR *Path = "0:/";
	rc = f_mount(0, &fatfs);
	rc = f_open (&fil, "asd.txt", FA_CREATE_NEW | FA_WRITE);
	rc = f_close(&fil);
	rc = f_mount(0, &fatfs);*/


	// Init UDP
	unsigned char mac_ethernet_address[] = {0x00, 0x0a, 0x35, 0x00, 0x01, 0x02};
	pbuf *p;
	netif = &server_netif;
	init_platform();
	lwip_init();
	xemac_add(netif, NULL, NULL, NULL, mac_ethernet_address, PLATFORM_EMAC_BASEADDR);
	netif_set_default(netif);
	platform_enable_interrupts();
	netif_set_up(netif);
	inet_aton(DEFAULT_IP_ADDRESS, &(netif->ip_addr));
	inet_aton(DEFAULT_IP_MASK, &(netif->netmask));
	inet_aton(DEFAULT_GW_ADDRESS, &(netif->gw));
	inet_aton(DEFAULT_GW_ADDRESS, &host_addr);
	pcb = udp_new();
	udp_bind(pcb, IP_ADDR_ANY, UDP_CONN_PORT);
	udp_recv(pcb, udp_recv_perf_traffic, NULL);
	p = pbuf_alloc(PBUF_TRANSPORT, 1518, PBUF_POOL);
	p->flags = 0x03;

	// Init PLL
	*((int *)(XPAR_CLK_WIZ_0_BASEADDR + 0x200)) = 0x00000001 | (20 << 8);


	while(1) {
		int val;
		int tb_size;
		char str[10];

		scanf("%s",str);

		if(!strcmp(str, "set_size")) {
			scanf("%d",&tb_size);
		}

		if(!strcmp(str, "set_wdelay")) {
			scanf("%d",&val);
			*((int *)XPAR_AXI_DELAY_0_BASEADDR + 2) = val;
		}

		if(!strcmp(str, "set_clkdiv")) {
			scanf("%d",&val);
			*((int *)(XPAR_CLK_WIZ_0_BASEADDR + 0x208)) = 0x0000000A | (val << 8);
			*((int *)(XPAR_CLK_WIZ_0_BASEADDR +  0x25C)) = 0x7;
			*((int *)(XPAR_CLK_WIZ_0_BASEADDR +  0x25C)) = 0x2;
			while((*((int *)(XPAR_CLK_WIZ_0_BASEADDR + 0x04)) & 0x1) == 0){;}
		}

		if(!strcmp(str, "start")) {

			MONITOR_INIT

			params.outFname[0] = '\0'; /* use stdout */
			//params.HPLMaxProcMem = (size_t)1 << 22; /* Size*/
			params.HPLMaxProcMem = tb_size;
			params.RunSingleRandomAccess_LCG = 1;

			/* -------------------------------------------------- */
			/*                 SingleRandomAccess LCG             */
			/* -------------------------------------------------- */

			if (params.RunSingleRandomAccess_LCG) {
				HPCC_RandomAccess_LCG(&params, 1, &params.Single_LCG_GUPs, &params.Failure);
			}

			if (params.RunSingleDGEMM) {
				//HPCC_TestDGEMM(&params, 1, &params.SingleDGEMMGflops, &params.DGEMM_N, &params.Failure);
			}

			for(int i = 0; i < 1; i++) {
				memcpy(p->payload, (void *)0x70000008, 1024);
				p->len = 1024;
				p->tot_len = 1024;
				udp_sendto(pcb, p, &host_addr, HOST_PORT);
			}
			//TRACE_CAP
		}
	}

	return 0;
}
