library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Common.all;

entity adder is
	port(win  : in  data_type(0 to 4, 0 to 4);
	     ws   : in std_logic;
	     data : out std_logic_vector(12 downto 0));

end entity adder;

architecture adder_arch of adder is
	type level1_type is array (0 to 11) of std_logic_vector(12 downto 0);
	signal level1       : level1_type := (others => "0000000000000");
	type level2_type is array (0 to 5) of std_logic_vector(12 downto 0);
	signal level2       : level2_type := (others => "0000000000000");
	type level3_type is array (0 to 3) of std_logic_vector(12 downto 0);
	signal level3       : level3_type := (others => "0000000000000");
	signal a, b         : std_logic_vector(12 downto 0);
	signal cout_notused : std_logic;
	type win_type is array (0 to 24) of std_logic_vector(12 downto 0);
	signal new_win      : win_type    := (others => "0000000000000");
begin
	new_win(0) <= "00000" & win(0, 0) when ws = '1' else (others => '0');
	new_win(1) <= "00000" & win(0, 1) when ws = '1' else (others => '0');
	new_win(2) <= "00000" & win(0, 2) when ws = '1' else (others => '0');
	new_win(3) <= "00000" & win(0, 3) when ws = '1' else (others => '0');
	new_win(4) <= "00000" & win(0, 4) when ws = '1' else (others => '0');
	new_win(5) <= "00000" & win(1, 0) when ws = '1' else (others => '0');
	new_win(6) <= "00000" & win(1, 1) when ws = '1' else (others => '0');
	new_win(7) <= "00000" & win(1, 2) when ws = '1' else (others => '0');
	new_win(8) <= "00000" & win(1, 3) when ws = '1' else (others => '0');
	new_win(9) <= "00000" & win(1, 4) when ws = '1' else (others => '0');
	new_win(10) <= "00000" & win(2, 0) when ws = '1' else (others => '0');
	new_win(11) <= "00000" & win(2, 1) when ws = '1' else (others => '0');
	new_win(12) <= "00000" & win(2, 2);
	new_win(13) <= "00000" & win(2, 3);
	new_win(14) <= "00000" & win(2, 4);
	new_win(15) <= "00000" & win(3, 0) when ws = '1' else (others => '0');
	new_win(16) <= "00000" & win(3, 1) when ws = '1' else (others => '0');
	new_win(17) <= "00000" & win(3, 2);
	new_win(18) <= "00000" & win(3, 3);
	new_win(19) <= "00000" & win(3, 4);
	new_win(20) <= "00000" & win(4, 0) when ws = '1' else (others => '0');
	new_win(21) <= "00000" & win(4, 1) when ws = '1' else (others => '0');
	new_win(22) <= "00000" & win(4, 2);
	new_win(23) <= "00000" & win(4, 3);
	new_win(24) <= "00000" & win(4, 4);
	
	level1_gen : for i in 0 to 11 generate
		level1_adder : entity work.nbitadder
			generic map(n => 13)
			port map(new_win(i), new_win(i + 12), '0', level1(i), cout_notused);
	end generate level1_gen;
	
	level2_gen : for i in 0 to 5 generate
		level2_adder : entity work.nbitadder
			generic map(n => 13)
			port map(level1(i), level1(i + 6), '0', level2(i), cout_notused);
	end generate level2_gen;
	
	level3_gen : for i in 0 to 2 generate
		level3_adder : entity work.nbitadder
			generic map(n => 13)
			port map(level2(i), level2(i + 3), '0', level3(i), cout_notused);
	end generate level3_gen;
	
	level3(3) <= new_win(24);
	
	level4_adder0 : entity work.nbitadder
		generic map(n => 13)
		port map(level3(0), level3(1), '0', a, cout_notused);
	level4_adder1 : entity work.nbitadder
		generic map(n => 13)
		port map(level3(2), level3(3), '0', b, cout_notused);
		
	data_adder : entity work.nbitadder
		generic map(n => 13)
		port map(a, b, '0', data, cout_notused);
		
end adder_arch;

