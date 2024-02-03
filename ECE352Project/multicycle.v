// ---------------------------------------------------------------------
// Copyright (c) 2007 by University of Toronto ECE 243 development team 
// ---------------------------------------------------------------------
//
// Major Functions:	a simple processor which operates basic mathematical
//					operations as follow:
//					(1)loading, (2)storing, (3)adding, (4)subtracting,
//					(5)shifting, (6)oring, (7)branch if zero,
//					(8)branch if not zero, (9)branch if positive zero
//					 
// Input(s):		1. KEY0(reset): clear all values from registers,
//									reset flags condition, and reset
//									control FSM
//					2. KEY1(clock): manual clock controls FSM and all
//									synchronous components at every
//									positive clock edge
//
//
// Output(s):		1. HEX Display: display registers value K3 to K1
//									in hexadecimal format
//
//					** For more details, please refer to the document
//					   provided with this implementation
//
// ---------------------------------------------------------------------

module multicycle
(
SW, KEY, HEX0, HEX1, HEX2, HEX3,
HEX4, HEX5, LEDR
);

// ------------------------ PORT declaration ------------------------ //
input	[1:0] KEY;
input [4:0] SW;
output	[6:0] HEX0, HEX1, HEX2, HEX3;
output	[6:0] HEX4, HEX5;
output reg [17:0] LEDR;

// ------------------------- Registers/Wires ------------------------ //
wire	clock, reset;
wire	IRLoad, MDRLoad, MemRead, MemWrite, PCWrite, RegIn, AddrSel;
wire	ALU1, ALUOutWrite, FlagWrite, R1R2Load, R1Sel, RFWrite;
wire	[7:0] R2wire, PCwire, R1wire, RFout1wire, RFout2wire;
wire	[7:0] ALU1wire, ALU2wire, ALUwire, ALUOut, MDRwire, MEMwire;
wire	[7:0] IR, SE4wire, ZE5wire, ZE3wire, AddrWire, RegWire;
wire	[7:0] reg0, reg1, reg2, reg3;
wire	[7:0] constant;
wire	[2:0] ALUOp, ALU2;
wire	[1:0] R1_in;
wire	Nwire, Zwire;
wire	increment;
wire	[15:0] counter;
wire 	VRFWrite, VoutSel, R2sel, X1Load, X2Load;
wire	[31:0]vdataw, vdata1, vdata2, vreg0, vreg1, vreg2, vreg3, X1, X2;
wire	[7:0]ALUT0OUT, ALUT1OUT, ALUT2OUT, ALUT3OUT, T0_mux_res, T1_mux_res, T2_mux_res;
wire	[7:0]T3_mux_res, DataIn, ALUR2OUT, R2_In;
wire	[2:0]MemIn;
wire	T0Ld, T1Ld, T2Ld, T3Ld;
reg		N, Z;

// ------------------------ Input Assignment ------------------------ //
assign	clock = KEY[1];
assign	reset =  ~KEY[0]; // KEY is active high


mycounter	mycounter(.clock(clock),.reset(reset),.increment(increment),.counter(counter));

// ------------------- DE2 compatible HEX display ------------------- //
HEXs	HEX_display(
	.in0(reg0),.in1(reg1),.in2(reg2),.in3(reg3),.selH(SW[0]),
	.out0(HEX0),.out1(HEX1),.out2(HEX2),.out3(HEX3),
	.out4(HEX4),.out5(HEX5)
);
// ----------------- END DE2 compatible HEX display ----------------- //

/*
// ------------------- DE1 compatible HEX display ------------------- //
chooseHEXs	HEX_display(
	.in0(reg0),.in1(reg1),.in2(reg2),.in3(reg3),
	.out0(HEX0),.out1(HEX1),.select(SW[1:0])
);
// turn other HEX display off
assign HEX2 = 7'b1111111;
assign HEX3 = 7'b1111111;
assign HEX4 = 7'b1111111;
assign HEX5 = 7'b1111111;
assign HEX6 = 7'b1111111;
assign HEX7 = 7'b1111111;
// ----------------- END DE1 compatible HEX display ----------------- //
*/

FSM		Control(
	.reset(reset),.clock(clock),.N(N),.Z(Z),.instr(IR),
	.PCwrite(PCWrite),.AddrSel(AddrSel),.MemRead(MemRead),.MemWrite(MemWrite),
	.IRload(IRLoad),.R1Sel(R1Sel),.MDRload(MDRLoad),.R1R2Load(R1R2Load),
	.ALU1(ALU1),.ALUOutWrite(ALUOutWrite),.RFWrite(RFWrite),.RegIn(RegIn),
	.FlagWrite(FlagWrite),.ALU2(ALU2),.ALUop(ALUOp), .increment(increment),
	.VRFWrite(VRFWrite), .X1Load(X1Load), .X2Load(X2Load), .VoutSel(VoutSel),
	.T0Ld(T0Ld), .T1Ld(T1Ld), .T2Ld(T2Ld), .T3Ld(T3Ld), .MemIn(MemIn), .R2sel(R2sel)
);


ALU		ALU(
	.in1(ALU1wire),.in2(ALU2wire),.out(ALUwire),
	.ALUOp(ALUOp),.N(Nwire),.Z(Zwire)
);


// ---------------------------------------------------------//

memory	DataMem(
	.MemRead(MemRead),.wren(MemWrite),.clock(clock),
	.address(AddrWire),.data(DataIn),.q(MEMwire)
);





VRF		VRF_block(
	.clock(clock),.reset(reset),.VRFWrite(VRFWrite),
	.vdataw(vdataw),.vreg1(IR[7:6]),.vreg2(IR[5:4]),
	.vregw(IR[7:6]),.vdata1(vdata1),.vdata2(vdata2),
	.v0(vreg0),.v1(vreg1),.v2(vreg2),.v3(vreg3)
);

register_8bit	X11(
	.clock(clock),.aclr(reset),.enable(X1Load),
	.data(vdata1[31:24]),.q(X1[31:24])
);

register_8bit	X12(
	.clock(clock),.aclr(reset),.enable(X1Load),
	.data(vdata1[23:16]),.q(X1[23:16])
);

register_8bit	X13(
	.clock(clock),.aclr(reset),.enable(X1Load),
	.data(vdata1[15:8]),.q(X1[15:8])
);

register_8bit	X14(
	.clock(clock),.aclr(reset),.enable(X1Load),
	.data(vdata1[7:0]),.q(X1[7:0])
);

register_8bit	X21(
	.clock(clock),.aclr(reset),.enable(X2Load),
	.data(vdata2[31:24]),.q(X2[31:24])
);

register_8bit	X22(
	.clock(clock),.aclr(reset),.enable(X2Load),
	.data(vdata2[23:16]),.q(X2[23:16])
);

register_8bit	X23(
	.clock(clock),.aclr(reset),.enable(X2Load),
	.data(vdata2[15:8]),.q(X2[15:8])
);

register_8bit	X24(
	.clock(clock),.aclr(reset),.enable(X2Load),
	.data(vdata2[7:0]),.q(X2[7:0])
);

VALU	VALUT0(
	.in1(X1[31:24]),.in2(X2[31:24]),.out(ALUT0OUT)
);

VALU	VALUT1(
	.in1(X1[23:16]),.in2(X2[23:16]),.out(ALUT1OUT)
);

VALU	VALUT2(
	.in1(X1[15:8]),.in2(X2[15:8]),.out(ALUT2OUT)
);

VALU	VALUT3(
	.in1(X1[7:0]),.in2(X2[7:0]),.out(ALUT3OUT)
);

mux2to1_8bit 		T0(
	.data0x(ALUT0OUT),.data1x(MEMwire),
	.sel(VoutSel),.result(T0_mux_res)
);
mux2to1_8bit 		T1(
	.data0x(ALUT1OUT),.data1x(MEMwire),
	.sel(VoutSel),.result(T1_mux_res)
);
mux2to1_8bit 		T2(
	.data0x(ALUT2OUT),.data1x(MEMwire),
	.sel(VoutSel),.result(T2_mux_res)
);
mux2to1_8bit 		T3(
	.data0x(ALUT3OUT),.data1x(MEMwire),
	.sel(VoutSel),.result(T3_mux_res)
);
register_8bit	T0_final(
	.clock(clock),.aclr(reset),.enable(T0Ld),
	.data(T0_mux_res),.q(vdataw[31:24])
);
register_8bit	T1_final(
	.clock(clock),.aclr(reset),.enable(T1Ld),
	.data(T1_mux_res),.q(vdataw[23:16])
);
register_8bit	T2_final(
	.clock(clock),.aclr(reset),.enable(T2Ld),
	.data(T2_mux_res),.q(vdataw[15:8])
);
register_8bit	T3_final(
	.clock(clock),.aclr(reset),.enable(T3Ld),
	.data(T3_mux_res),.q(vdataw[7:0])
);
mux5to1_8bit 		MemInmux(
	.data0x(X1[31:24]),.data1x(X1[23:16]),.data2x(X1[15:8]),
	.data3x(X1[7:0]),.data4x(R1wire),.sel(MemIn),.result(DataIn)
);

mux2to1_8bit 		R2_select_mux(
	.data0x(RFout2wire),.data1x(ALUR2OUT),
	.sel(R2sel),.result(R2_In)
);

register_8bit	R2(
	.clock(clock),.aclr(reset),.enable(R1R2Load),
	.data(R2_In),.q(R2wire)
);

ALUR2		ALUR2(
	.in1(R2wire),.out(ALUR2OUT)
);		
// ---------------------------------------------------------//



RF		RF_block(
	.clock(clock),.reset(reset),.RFWrite(RFWrite),
	.dataw(RegWire),.reg1(R1_in),.reg2(IR[5:4]),
	.regw(R1_in),.data1(RFout1wire),.data2(RFout2wire),
	.r0(reg0),.r1(reg1),.r2(reg2),.r3(reg3)
);

register_8bit	IR_reg(
	.clock(clock),.aclr(reset),.enable(IRLoad),
	.data(MEMwire),.q(IR)
);

register_8bit	MDR_reg(
	.clock(clock),.aclr(reset),.enable(MDRLoad),
	.data(MEMwire),.q(MDRwire)
);

register_8bit	PC(
	.clock(clock),.aclr(reset),.enable(PCWrite),
	.data(ALUwire),.q(PCwire)
);

register_8bit	R1(
	.clock(clock),.aclr(reset),.enable(R1R2Load),
	.data(RFout1wire),.q(R1wire)
);



register_8bit	ALUOut_reg(
	.clock(clock),.aclr(reset),.enable(ALUOutWrite),
	.data(ALUwire),.q(ALUOut)
);

mux2to1_2bit		R1Sel_mux(
	.data0x(IR[7:6]),.data1x(constant[1:0]),
	.sel(R1Sel),.result(R1_in)
);

mux2to1_8bit 		AddrSel_mux(
	.data0x(R2wire),.data1x(PCwire),
	.sel(AddrSel),.result(AddrWire)
);

mux2to1_8bit 		RegMux(
	.data0x(ALUOut),.data1x(MDRwire),
	.sel(RegIn),.result(RegWire)
);

mux2to1_8bit 		ALU1_mux(
	.data0x(PCwire),.data1x(R1wire),
	.sel(ALU1),.result(ALU1wire)
);

mux5to1_8bit 		ALU2_mux(
	.data0x(R2wire),.data1x(constant),.data2x(SE4wire),
	.data3x(ZE5wire),.data4x(ZE3wire),.sel(ALU2),.result(ALU2wire)
);

sExtend		SE4(.in(IR[7:4]),.out(SE4wire));
zExtend		ZE3(.in(IR[5:3]),.out(ZE3wire));
zExtend		ZE5(.in(IR[7:3]),.out(ZE5wire));
// define parameter for the data size to be extended
defparam	SE4.n = 4;
defparam	ZE3.n = 3;
defparam	ZE5.n = 5;

always@(posedge clock or posedge reset)
begin
if (reset)
	begin
	N <= 0;
	Z <= 0;
	end
else
if (FlagWrite)
	begin
	N <= Nwire;
	Z <= Zwire;
	end
end

// ------------------------ Assign Constant 1 ----------------------- //
assign	constant = 1;

	
// ------------------------- LEDs Indicator ------------------------- //
always @ (*)
begin

    case({SW[4],SW[3]})
    2'b00:
    begin
      LEDR[9] = 0;
      LEDR[8] = 0;
      LEDR[7] = PCWrite;
      LEDR[6] = AddrSel;
      LEDR[5] = MemRead;
      LEDR[4] = MemWrite;
      LEDR[3] = IRLoad;
      LEDR[2] = R1Sel;
      LEDR[1] = MDRLoad;
      LEDR[0] = R1R2Load;
    end

    2'b01:
    begin
      LEDR[9] = ALU1;
      LEDR[8:6] = ALU2[2:0];
      LEDR[5:3] = ALUOp[2:0];
      LEDR[2] = ALUOutWrite;
      LEDR[1] = RFWrite;
      LEDR[0] = RegIn;
    end

    2'b10:
    begin
      LEDR[9] = 0;
      LEDR[8] = 0;
      LEDR[7] = FlagWrite;
      LEDR[6:2] = constant[7:3];
      LEDR[1] = N;
      LEDR[0] = Z;
    end

    2'b11:
    begin
      LEDR[9:0] = 10'b0;
    end
  endcase
end
endmodule
