----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 11/24/2014 04:04:00 PM
-- Design Name:
-- Module Name: chan_delay - behavioral
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description: Channel delay
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity chan_delay is

generic (
	C_FAMILY        : string := "zynq";
	C_COUNTER_WIDTH : integer := 20;
	C_FIFO_DEPTH    : integer := 0; -- power of 2

	C_00_USE : integer range 0 to 1 := 0;
	C_01_USE : integer range 0 to 1 := 0;
	C_02_USE : integer range 0 to 1 := 0;
	C_03_USE : integer range 0 to 1 := 0;
	C_04_USE : integer range 0 to 1 := 0;
	C_05_USE : integer range 0 to 1 := 0;
	C_06_USE : integer range 0 to 1 := 0;
	C_07_USE : integer range 0 to 1 := 0;
	C_08_USE : integer range 0 to 1 := 0;
	C_09_USE : integer range 0 to 1 := 0;
	C_10_USE : integer range 0 to 1 := 0;

	C_00_WIDTH : integer := 1;
	C_01_WIDTH : integer := 1;
	C_02_WIDTH : integer := 1;
	C_03_WIDTH : integer := 1;
	C_04_WIDTH : integer := 1;
	C_05_WIDTH : integer := 1;
	C_06_WIDTH : integer := 1;
	C_07_WIDTH : integer := 1;
	C_08_WIDTH : integer := 1;
	C_09_WIDTH : integer := 1;
	C_10_WIDTH : integer := 1
);

port (
	dclk    : in  std_logic;
	dresetn : in  std_logic;

	delay   : in  std_logic_vector(C_COUNTER_WIDTH-1 downto 0);

	aclk    : in  std_logic;
	aresetn : in  std_logic;

	counter : in  std_logic_vector(C_COUNTER_WIDTH-1 downto 0);

	s_00 : in  std_logic_vector(C_00_WIDTH-1 downto 0) := (others => '0');
	s_01 : in  std_logic_vector(C_01_WIDTH-1 downto 0) := (others => '0');
	s_02 : in  std_logic_vector(C_02_WIDTH-1 downto 0) := (others => '0');
	s_03 : in  std_logic_vector(C_03_WIDTH-1 downto 0) := (others => '0');
	s_04 : in  std_logic_vector(C_04_WIDTH-1 downto 0) := (others => '0');
	s_05 : in  std_logic_vector(C_05_WIDTH-1 downto 0) := (others => '0');
	s_06 : in  std_logic_vector(C_06_WIDTH-1 downto 0) := (others => '0');
	s_07 : in  std_logic_vector(C_07_WIDTH-1 downto 0) := (others => '0');
	s_08 : in  std_logic_vector(C_08_WIDTH-1 downto 0) := (others => '0');
	s_09 : in  std_logic_vector(C_09_WIDTH-1 downto 0) := (others => '0');
	s_10 : in  std_logic_vector(C_10_WIDTH-1 downto 0) := (others => '0');
	s_valid : in  std_logic;
	s_ready : out std_logic;

	m_00 : out std_logic_vector(C_00_WIDTH-1 downto 0);
	m_01 : out std_logic_vector(C_01_WIDTH-1 downto 0);
	m_02 : out std_logic_vector(C_02_WIDTH-1 downto 0);
	m_03 : out std_logic_vector(C_03_WIDTH-1 downto 0);
	m_04 : out std_logic_vector(C_04_WIDTH-1 downto 0);
	m_05 : out std_logic_vector(C_05_WIDTH-1 downto 0);
	m_06 : out std_logic_vector(C_06_WIDTH-1 downto 0);
	m_07 : out std_logic_vector(C_07_WIDTH-1 downto 0);
	m_08 : out std_logic_vector(C_08_WIDTH-1 downto 0);
	m_09 : out std_logic_vector(C_09_WIDTH-1 downto 0);
	m_10 : out std_logic_vector(C_10_WIDTH-1 downto 0);
	m_valid : out std_logic;
	m_ready : in  std_logic
);

end chan_delay;

architecture behavioral of chan_delay is

COMPONENT chan_fifo
  PORT (
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    din : IN STD_LOGIC_VECTOR(28 DOWNTO 0);
    wr_en : IN STD_LOGIC;
    rd_en : IN STD_LOGIC;
    dout : OUT STD_LOGIC_VECTOR(28 DOWNTO 0);
    full : OUT STD_LOGIC;
    empty : OUT STD_LOGIC;
    valid : OUT STD_LOGIC;
    data_count : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
  );
END COMPONENT;

signal fifo_valid : std_logic;
signal fifo_count : std_logic_vector(9 downto 0);
signal m_10_i : std_logic_vector(0 downto 0);

begin

	no_fifo: if (C_FIFO_DEPTH = 0) generate
	begin
		g_00: if (C_00_USE = 1) generate begin m_00 <= s_00; end generate;
		g_01: if (C_01_USE = 1) generate begin m_01 <= s_01; end generate;
		g_02: if (C_02_USE = 1) generate begin m_02 <= s_02; end generate;
		g_03: if (C_03_USE = 1) generate begin m_03 <= s_03; end generate;
		g_04: if (C_04_USE = 1) generate begin m_04 <= s_04; end generate;
		g_05: if (C_05_USE = 1) generate begin m_05 <= s_05; end generate;
		g_06: if (C_06_USE = 1) generate begin m_06 <= s_06; end generate;
		g_07: if (C_07_USE = 1) generate begin m_07 <= s_07; end generate;
		g_08: if (C_08_USE = 1) generate begin m_08 <= s_08; end generate;
		g_09: if (C_09_USE = 1) generate begin m_09 <= s_09; end generate;
		g_10: if (C_10_USE = 1) generate begin m_10 <= s_10; end generate;
		m_valid <= s_valid;
		s_ready <= m_ready;
	end generate;

	use_fifo: if (C_FIFO_DEPTH > 0) generate

    signal delay_i    : std_logic_vector(C_COUNTER_WIDTH-1 downto 0);
	signal delay_sync : std_logic_vector(C_COUNTER_WIDTH-1 downto 0);
	signal m_time : std_logic_vector(C_COUNTER_WIDTH-1 downto 0);
	signal m_valid_i : std_logic;
	signal s_fifo_enable_i : std_logic;

	-- FIFO signals

	constant C_FIFO_WIDTH : integer :=
		C_00_WIDTH*C_00_USE+
		C_01_WIDTH*C_01_USE+
		C_02_WIDTH*C_02_USE+
		C_03_WIDTH*C_03_USE+
		C_04_WIDTH*C_04_USE+
		C_05_WIDTH*C_05_USE+
		C_06_WIDTH*C_06_USE+
		C_07_WIDTH*C_07_USE+
		C_08_WIDTH*C_08_USE+
		C_09_WIDTH*C_09_USE+
		C_10_WIDTH*C_10_USE+
		C_COUNTER_WIDTH;

	alias  fifo_clk : std_logic is aclk;
	signal fifo_rst : std_logic;
	signal s_fifo_data   : std_logic_vector(C_FIFO_WIDTH-1 downto 0);
	signal s_fifo_enable : std_logic;
	signal s_fifo_full   : std_logic;
	signal m_fifo_data   : std_logic_vector(C_FIFO_WIDTH-1 downto 0);
	signal m_fifo_enable : std_logic;
	signal m_fifo_empty  : std_logic;

	procedure pack (
		signal w    : out std_logic_vector;
		signal s_00 : in  std_logic_vector;
		signal s_01 : in  std_logic_vector;
		signal s_02 : in  std_logic_vector;
		signal s_03 : in  std_logic_vector;
		signal s_04 : in  std_logic_vector;
		signal s_05 : in  std_logic_vector;
		signal s_06 : in  std_logic_vector;
		signal s_07 : in  std_logic_vector;
		signal s_08 : in  std_logic_vector;
		signal s_09 : in  std_logic_vector;
		signal s_10 : in  std_logic_vector
	) is
		variable lo : integer;
	begin
		lo := 0;
		if (C_00_USE = 1) then w(lo+s_00'length-1 downto lo) <= s_00; lo := lo + s_00'length; end if;
		if (C_01_USE = 1) then w(lo+s_01'length-1 downto lo) <= s_01; lo := lo + s_01'length; end if;
		if (C_02_USE = 1) then w(lo+s_02'length-1 downto lo) <= s_02; lo := lo + s_02'length; end if;
		if (C_03_USE = 1) then w(lo+s_03'length-1 downto lo) <= s_03; lo := lo + s_03'length; end if;
		if (C_04_USE = 1) then w(lo+s_04'length-1 downto lo) <= s_04; lo := lo + s_04'length; end if;
		if (C_05_USE = 1) then w(lo+s_05'length-1 downto lo) <= s_05; lo := lo + s_05'length; end if;
		if (C_06_USE = 1) then w(lo+s_06'length-1 downto lo) <= s_06; lo := lo + s_06'length; end if;
		if (C_07_USE = 1) then w(lo+s_07'length-1 downto lo) <= s_07; lo := lo + s_07'length; end if;
		if (C_08_USE = 1) then w(lo+s_08'length-1 downto lo) <= s_08; lo := lo + s_08'length; end if;
		if (C_09_USE = 1) then w(lo+s_09'length-1 downto lo) <= s_09; lo := lo + s_09'length; end if;
		if (C_10_USE = 1) then w(lo+s_10'length-1 downto lo) <= s_10; lo := lo + s_10'length; end if;
	end pack;

	procedure unpack (
		signal w    : in  std_logic_vector;
		signal m_00 : out std_logic_vector;
		signal m_01 : out std_logic_vector;
		signal m_02 : out std_logic_vector;
		signal m_03 : out std_logic_vector;
		signal m_04 : out std_logic_vector;
		signal m_05 : out std_logic_vector;
		signal m_06 : out std_logic_vector;
		signal m_07 : out std_logic_vector;
		signal m_08 : out std_logic_vector;
		signal m_09 : out std_logic_vector;
		signal m_10 : out std_logic_vector
	) is
		variable lo : integer;
	begin
		lo := 0;
		if (C_00_USE = 1) then m_00 <= w(lo+m_00'length-1 downto lo); lo := lo + m_00'length; end if;
		if (C_01_USE = 1) then m_01 <= w(lo+m_01'length-1 downto lo); lo := lo + m_01'length; end if;
		if (C_02_USE = 1) then m_02 <= w(lo+m_02'length-1 downto lo); lo := lo + m_02'length; end if;
		if (C_03_USE = 1) then m_03 <= w(lo+m_03'length-1 downto lo); lo := lo + m_03'length; end if;
		if (C_04_USE = 1) then m_04 <= w(lo+m_04'length-1 downto lo); lo := lo + m_04'length; end if;
		if (C_05_USE = 1) then m_05 <= w(lo+m_05'length-1 downto lo); lo := lo + m_05'length; end if;
		if (C_06_USE = 1) then m_06 <= w(lo+m_06'length-1 downto lo); lo := lo + m_06'length; end if;
		if (C_07_USE = 1) then m_07 <= w(lo+m_07'length-1 downto lo); lo := lo + m_07'length; end if;
		if (C_08_USE = 1) then m_08 <= w(lo+m_08'length-1 downto lo); lo := lo + m_08'length; end if;
		if (C_09_USE = 1) then m_09 <= w(lo+m_09'length-1 downto lo); lo := lo + m_09'length; end if;
		if (C_10_USE = 1) then m_10 <= w(lo+m_10'length-1 downto lo); lo := lo + m_10'length; end if;
	end unpack;

	begin
		fifo_rst <= not aresetn;

		m_valid <= m_valid_i;
		
		process(aclk)
		begin
			if (rising_edge(aclk)) then
				if unsigned(fifo_count) > unsigned(delay_sync) then
				    s_fifo_enable_i <= '0';
                else
                    s_fifo_enable_i <= '1';
                end if;
                
                if unsigned(fifo_count) < unsigned(delay_sync) then
                    m_fifo_enable <= '0';
                else
                    m_fifo_enable <= '1';
                end if;
			end if;
		end process;

		pack(
			s_fifo_data,
			s_00,s_01,s_02,s_03,s_04,s_05,s_06,s_07,s_08,s_09,s_10
		);

		s_ready <= not s_fifo_full;

		unpack(
			m_fifo_data,
			m_00,m_01,m_02,m_03,m_04,m_05,m_06,m_07,m_08,m_09,m_10_i
		);
        m_10 <= m_10_i;
		m_valid_i <= fifo_valid and m_10_i(0);
		s_fifo_enable <= s_fifo_enable_i or s_valid;

        chan_fifo_inst : chan_fifo
          PORT MAP (
            clk => fifo_clk,
            rst => fifo_rst,
            din => s_fifo_data,
            wr_en => s_fifo_enable,
            rd_en => m_fifo_enable,
            dout => m_fifo_data,
            full => s_fifo_full,
            empty => m_fifo_empty,
            valid => fifo_valid,
            data_count => fifo_count
          );
   
		-- clock domain crossing for registers
        process(aclk)
        begin
            if aclk'event and aclk = '1' then
                delay_i <= delay;
                delay_sync <= delay_i;
            end if;
        end process;

	end generate;

end behavioral;
