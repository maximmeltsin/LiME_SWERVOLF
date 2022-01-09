**LiME (Logic-in-Memory Emulator) with RISCV**

**Files structure:**  
![](media/02ae2788bd70e28ea28eb805f546c6fb.png)

-   Vivado – HDL projects folder

    -   Lime_RISCV_v3 – main project

    -   LiME-SwerVolf – project for generating RISCV core

-   RISCV – software for RISCV MCU

-   Matlab – MATLAB GUI

-   Bitfile – compiled bitfile

**Running the system:**  
1) Connect JTAG (micro USB) cable between PC and ZC706 board

2) Connect UART (nimi USB) cable between PC and ZC706 board

3) Connect Ethernet cable between PC and ZC706 board

4) Define static IP address on PC Ethernet port connected to ZC706:

-   Go to Control Panel -\> Network and Sharing Center -\> Change adapter
    settings

-   Right click on adapter -\> Properties

    ![](media/a7857024e9a2b9887478ee4d7ca324c3.png)

-   Click on TCP/IPv4

-   Mark “Use the following IP address” and enter IP address = 192.168.1.1,
    Subnet Mask = 255.255.255.0

    ![](media/2f8810fc1db4a75f135b537d6e4c8025.png)

-   Press OK

5) Power on ZC706 board

6) Program ZC706 with bitfile:

-   Open Vivado Hardware Manager

-   Click Open Target -\> Auto Connect

    ![](media/9f1bcca115566f60b2162a4869c774e1.png)

-   Right click on FPGA icon -\> Program Device and provide bitfile from bitfile
    directory

    ![](media/19c4851ae3553952f9b2a27ee01ac956.png)

7) Run ZYNC processor:

-   Open LiME project in Xilinx SDK

-   Right click on LiME -\> Debug as -\> Launch on Hardware

    ![](media/e25f3ac67e00c4604fdd564460ae143d.png)

-   Press Play button  
    ![](media/9413a6b5bf7bd4f463e7901ac8f16923.png)

6) From MATLAB run LiME.mlapp GUI

7) Select setting for emulation on “Emulator config” tab

![](media/015e0808d5d248e9a8687a912b117cc9.png)

8) Select setting for testbench on “Testbench config” tab  
![](media/67cdaa8943b23f15933634790155b12b.png)

9) Press RUN button, wait for testbench to finish and observe the results

10) On Static tab you can see basic statistic of transactions on memory bus
during

![](media/d610ce7525a4ce8a6531186de42e5df8.png)  

11) Pressing “TRACE” button will open transactions log

**Building the project**

1.  Open project in Vivado by double click on \*.xpr file

2.  Press “Generate Bitstream” to compile the design

3.  Export generated hardware by File -\> Export -\> Export Hardware

    ![](media/9d6f19e34ea950bb9db26f69c48cf053.png)

4.  Launch SDK by clicking File -\> Launch SDK  
    ![](media/859b6740d8ff263e4916afd5abbf508a.png)
