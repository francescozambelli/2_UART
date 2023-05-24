library ieee;
use ieee.std_logic_1164.all;



entity top is

  port (

    CLK100MHZ    : in  std_logic;
    uart_txd_in  : in  std_logic;
    uart_rxd_out : out std_logic);

end entity top;

architecture str of top is
  signal clock          : std_logic;
  signal data_to_send   : std_logic_vector(7 downto 0);
  signal data_valid     : std_logic;
  signal busy           : std_logic;
  signal uart_tx        : std_logic;
  signal fir_data	   : std_logic_vector(7 downto 0);
  signal data_valid_fir : std_logic;

  component uart_transmitter is
    port (
      clock        : in  std_logic;
      data_to_send : in  std_logic_vector(7 downto 0);
      data_valid   : in  std_logic;
      busy         : out std_logic;
      uart_tx	     : out std_logic);
  end component uart_transmitter;

  component uart_receiver is
    port (
      clock         : in  std_logic;
      uart_rx       : in  std_logic;
      valid         : out std_logic;
      received_data : out std_logic_vector(7 downto 0));
  end component uart_receiver;

  component fir_my is
    port (
	 x                   : in  std_logic_vector(7 downto 0);
        valid_in            : in  std_logic;
        valid_out           : out std_logic;
        y                   : out std_logic_vector(7 downto 0));
  end component fir_my;

begin  -- architecture str

  uart_receiver_1 : uart_receiver

    port map (
      clock         => CLK100MHZ,
      uart_rx       => uart_txd_in,
      valid         => data_valid,
      received_data => data_to_send);

  fir_filter : fir_my
    port map (
	 x           => data_to_send,
        valid_in    => data_valid,
        valid_out   => data_valid_fir,
        y           => fir_data);


  uart_transmitter_1 : uart_transmitter
    port map (
      clock        => CLK100MHZ,
      data_to_send => fir_data,
      data_valid   => data_valid_fir,
      busy         => busy,
      uart_tx	     => uart_rxd_out);

end architecture str;

