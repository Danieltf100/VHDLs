LIBRARY ieee;
USE ieee.std_logic_1164.all;

Entity main IS
		port(PinoSoma, PinoSub, PinoMod, AUX, Guarda, Devolve:IN STD_logic;
				a:IN STD_logic_Vector(3 downto 0);
				b:IN STD_logic_Vector(3 downto 0);
				R: buffer	STD_LOGIC_Vector (4 downto 0);
				RX,RY,RR,RM: buffer STD_Logic_Vector (7 downto 0));
end main;
Architecture Behavior of main is
		Signal opcao: STD_LOGIC_VECTOR(2 downto 0);
		Signal xy, Cout, Cin: STD_LOGIC_VECTOR(3 downto 0);
		Signal memoria: STD_LOGIC_VECTOR(7 downto 0);
begin
		process (PinoSoma, PinoSub, PinoMod, AUX)
		begin
			if PinoSoma   = '1' then opcao <= "001";
			elsif PinoSub = '1' then opcao <= "010";
			elsif PinoMod = '1' then opcao <= "011";
			elsif AUX     = '1' then opcao <= "100";
			elsif Guarda  = '1' then opcao <= "101";
			elsif Devolve = '1' then opcao <= "110";
			else opcao <= "000";
			end if;
			
			if opcao = "001" then 
			
					-- Soma:
			
					Cin(0) <= '0';
					R(1) <= a(0) xor b(0) xor Cin(0);
					Cout(0)<= (a(0) and b(0)) or (a(0) and Cin(0)) or (b(0) and Cin(0));
					
					Cin(1) <= Cout(0);
					R(2) <= a(1) xor b(1) xor Cin(1);
					Cout(1) <= (a(1) and b(1)) or (a(1) and Cin(1)) or (b(1) and Cin(1));
					
					Cin(2) <= Cout(1);
					R(3) <= a(2) xor b(2) xor Cin(2);
					Cout(2) <= (a(2) and b(2)) or (a(2) and Cin(2)) or (b(2) and Cin(2));
					
					Cin(3) <= Cout(2);
					R(4) <= a(3) xor b(3) xor Cin(3);
					Cout(3) <= (a(3) and b(3)) or (a(3) and Cin(3)) or (b(3) and Cin(3));
					R(0) <= Cout(3);
			
			
			end if;
			if opcao = "010" then
					
					-- Subtrai:
					
					Cin(0) <= '1';
					xy(0) <= b(0) xor Cin(0);
					xy(1) <= b(1) xor Cin(0);
					xy(2) <= b(2) xor Cin(0);
					xy(3) <= b(3) xor Cin(0);
					
					R(1) <= a(0) xor xy(0) xor Cin(0);
					Cout(0)<= (a(0) and xy(0)) or (a(0) and Cin(0)) or (xy(0) and Cin(0));
					
					Cin(1) <= Cout(0);
					R(2) <= a(1) xor xy(1) xor Cin(1);
					Cout(1) <= (a(1) and xy(1)) or (a(1) and Cin(1)) or (xy(1) and Cin(1));
					
					Cin(2) <= Cout(1);
					R(3) <= a(2) xor xy(2) xor Cin(2);
					Cout(2) <= (a(2) and xy(2)) or (a(2) and Cin(2)) or (xy(2) and Cin(2));
					
					Cin(3) <= Cout(2);
					R(4) <= a(3) xor xy(3) xor Cin(3);
					Cout(3) <= (a(3) and xy(3)) or (a(3) and Cin(3)) or (xy(3) and Cin(3));
					
					R(0) <= Cout(3) xor Cin(3);
					
			end if;		
			if opcao = "011" then
					
					-- Módulo:
					
					if    a = "0000" then R <= "00000";
					elsif a = "0001" then R <= "00010";
					elsif a = "0010" then R <= "00100";
					elsif a = "0011" then R <= "00110";
					elsif a = "0100" then R <= "01000";
					elsif a = "0101" then R <= "01010";
					elsif a = "0110" then R <= "01100";
					elsif a = "0111" then R <= "01110";
					elsif a = "1000" then R <= "11111";
					elsif a = "1001" then R <= "01110";
					elsif a = "1010" then R <= "01100";
					elsif a = "1011" then R <= "01010";
					elsif a = "1100" then R <= "01000";
					elsif a = "1101" then R <= "00110";
					elsif a = "1110" then R <= "00100";
					elsif a = "1111" then R <= "00010";
					end if;
					
			end if;
			if opcao = "100" then
			
					--AUX:
			
			end if;
			if opcao = "101" then
					
					-- Armazenar o resultado:	
					if Devolve = '0' then 
								memoria <= RR;
								RM <= "11111111";
					end if;
			end if;
			if opcao = "110" then
			
					-- Recupera o valor armazenado:
					RM <= memoria;
			end if;
			if opcao = "000" then
					R <= "00000";
					RM <= "11111111";
			end if;			
		end process;
		
		with a select
				RX <= "10000001" when "0000",--  0
						"11001111" when "0001",--  1
						"10010010" when "0010",--  2
						"10000110" when "0011",--  3
						"11001100" when "0100",--  4
						"10100100" when "0101",--  5
						"10100000" when "0110",--  6
						"10001111" when "0111",--  7
						"00000000" when "1000",-- -8
						"00001111" when "1001",-- -7
						"00100000" when "1010",-- -6
						"00100100" when "1011",-- -5
						"01001100" when "1100",-- -4
						"00000110" when "1101",-- -3
						"00010010" when "1110",-- -2
						"01001111" when "1111",-- -1
						"10110110" when others;
		with b select
				RY <= "10000001" when "0000",
						"11001111" when "0001",
						"10010010" when "0010",
						"10000110" when "0011",
						"11001100" when "0100",
						"10100100" when "0101",
						"10100000" when "0110",
						"10001111" when "0111",
						"00000000" when "1000",
						"00001111" when "1001",
						"00100000" when "1010",
						"00100100" when "1011",
						"01001100" when "1100",
						"00000110" when "1101",
						"00010010" when "1110",
						"01001111" when "1111",
						"10110110" when others;
		with R select
				RR <= "10000001" when "00000",
						"11001111" when "00010",
						"10010010" when "00100",
						"10000110" when "00110",
						"11001100" when "01000",
						"10100100" when "01010",
						"10100000" when "01100",
						"10001111" when "01110",
						"00000000" when "10000",
						"00001111" when "10010",
						"00100000" when "10100",
						"00100100" when "10110",
						"01001100" when "11000",
						"00000110" when "11010",
						"00010010" when "11100",
						"01001111" when "11110",
						"10110000" when others;
end Behavior;