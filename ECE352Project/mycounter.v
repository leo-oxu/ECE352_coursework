module mycounter(clock,reset,increment,counter);

input clock,reset,increment;

output reg[15:0]counter;

always @(posedge clock)
	begin
		if (reset)
			counter = 0;
		else if (increment)
			counter = counter + 1;
	end

endmodule