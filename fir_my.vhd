---------------------------------------------------------------------------------$
---------------------------------------------------------------------------------$
-----                           MY FIR FILTER                                ----$
---------------------------------------------------------------------------------$
---------------------------------------------------------------------------------$

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

---------------------------------------------------------------------------------$

entity fir_my is
    port (
	 x                   : in  std_logic_vector(7 downto 0);
        valid_in            : in  std_logic;
        reset               : in  std_logic;
        valid_out           : out std_logic;
        y                   : out std_logic_vector(7 downto 0));
end entity fir_my;

---------------------------------------------------------------------------------$

architecture ar_fir of fir_my is

    type prod_t      is array (0 to 4) of signed(11 downto 0);
    signal c0 : signed(3 downto 0):=to_signed(1, 4);
    signal c1 : signed(3 downto 0):=to_signed(-4, 4);
    signal c2 : signed(3 downto 0):=to_signed(7, 4);
    signal c3 : signed(3 downto 0):=to_signed(-4, 4);
    signal c4 : signed(3 downto 0):=to_signed(1, 4);
    signal x0  : signed(7 downto 0):=(others=>'0');
    signal x1  : signed(7 downto 0):=(others=>'0');
    signal x2  : signed(7 downto 0):=(others=>'0');
    signal x3  : signed(7 downto 0):=(others=>'0');
    signal x4  : signed(7 downto 0):=(others=>'0');
    signal add3 : signed(11+2  downto 0):=(others=>'0');
    signal prod : prod_t:=(others => (others => '0'));
begin
    
    main : process(valid_in,reset) is    
    begin
      if reset='1' then
            x0 <= (others=>'0');
            x1 <= (others=>'0');
            x2 <= (others=>'0');
            x3 <= (others=>'0');
            x4 <= (others=>'0');
      elsif falling_edge(valid_in) then
            x0 <= signed(x);
            x1 <= x0;
            x2 <= x1;
            x3 <= x2;
            x4 <= x3;
        end if;
        
    end process main;   

    multipl: process (x0,x1,x2,x3,x4) is
    begin
    if reset='1' then 
      prod <= (others => (others => '0'));
    else
      prod(0) <= x0*c0;
      prod(1) <= x1*c1;
      prod(2) <= x2*c2;
      prod(3) <= x3*c3;
      prod(4) <= x4*c4;
    end if;
    end process multipl;


    add: process (prod) is
      begin
	add3 <= resize(prod(0),14) + resize(prod(1),14) + resize(prod(2),14) + resize(prod(3),14) + resize(prod(4),14);   
      end process add;

    output: process (add3) is
    begin
      y <= std_logic_vector(add3(13) & add3(10 downto 4));
    end process output;
valid_out <= valid_in;

end architecture ar_fir;

