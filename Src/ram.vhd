library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram is
	port(
		clk     : in  std_logic;
		we      : in  std_logic;
		address,write_address : in  std_logic_vector(17 downto 0);
		datain  : in  std_logic_vector(7 downto 0);
		dataout : out std_logic_vector(39 downto 0));
end entity ram;

architecture ram_arch of ram is

	type ram_type is array (0 to 262143) of std_logic_vector(7 downto 0);
	signal ram : ram_type := (others => x"00");
begin
	process(clk) is
	begin
		if rising_edge(clk) then
			if we = '1' then
				ram(to_integer(unsigned(write_address))) <= datain;
			end if;
		end if;
	end process;
	dataout <= ram(to_integer(unsigned(address))) 
			& ram(to_integer(unsigned(address) + 1)) 
			& ram(to_integer(unsigned(address) + 2))
			& ram(to_integer(unsigned(address) + 3))
			& ram(to_integer(unsigned(address) + 4));
end ram_arch;
