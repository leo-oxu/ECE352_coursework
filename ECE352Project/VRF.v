// ---------------------------------------------------------------------
// Copyright (c) 2007 by University of Toronto ECE 243 development team 
// ---------------------------------------------------------------------
//
// Major Functions:	Registers memory stores four 8-bits data
//					 
// Input(s):		1. reset: 	clear registers value to zero
//					2. clock: 	data written at positive clock edge
//					3. reg1:	indicate which register will be 
//					   			output through (output)data1
//					4. reg2:	indicate which register will be 
//								output through (output)data2
//					5. regw:	indicate which register will be 
//								overwritten with the data from
//								(input)dataw
//					6. dataw:	input data to be written into register
//					7. RFWrite:	write enable single, allow the data to
//								be written at the positive edge
//
// Output(s):		1. data1:	data output of the register (input)reg1
//					2. data2:	data output of the register (input)reg2
//					3. r0-r3:	data stored by register0 to register3
//
// ---------------------------------------------------------------------

module VRF
(
clock, vreg1, vreg2, vregw,
vdataw, VRFWrite, vdata1, vdata2,
v0, v1, v2, v3, reset
);

// ------------------------ PORT declaration ------------------------ //
input clock;
input [1:0] vreg1, vreg2, vregw;
input [31:0] vdataw;
input VRFWrite;
input reset;
output [31:0] vdata1, vdata2;
output [31:0] v0, v1, v2, v3;

// ------------------------- Registers/Wires ------------------------ //
reg [31:0] vk0, vk1, vk2, vk3;
reg [31:0] x1, x2;

// Asynchronously read data from two registers
always @(*)
begin
	case (vreg1)
		0: x1 = vk0;
		1: x1 = vk1;
		2: x1 = vk2;
		3: x1 = vk3;
	endcase
	case (vreg2)
		0: x2 = vk0;
		1: x2 = vk1;
		2: x2 = vk2;
		3: x2 = vk3;
	endcase
end

// Synchronously write data to the register file;
// also supports an asynchronous reset, which clears all registers
always @(posedge clock or posedge reset)
begin
	if (reset) begin
		vk0 = 0;
		vk1 = 0;
		vk2 = 0;
		vk3 = 0;
	end	else begin
		if (VRFWrite) begin
			case (vregw)
				0: vk0 = vdataw;
				1: vk1 = vdataw;
				2: vk2 = vdataw;
				3: vk3 = vdataw;
			endcase
		end
	end
end

// Assign temporary values to the outputs
assign vdata1 = x1;
assign vdata2 = x2;

assign v0 = vk0;
assign v1 = vk1;
assign v2 = vk2;
assign v3 = vk3;

endmodule
