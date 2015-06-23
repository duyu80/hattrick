
`timescale 1ns/1ns
module wb_master (clk, rst, adr, din, dout, cyc, stb, we, sel, ack, err, rty,
				  i2c_wr,i2c_addr,i2c_wrdata1,i2c_wrdata2,i2c_wrdata3,i2c_data_num,i2c_busy,i2c_rddata1,i2c_rddata2,i2c_rddata3
				  );

parameter dwidth = 32;
parameter awidth = 32;
//parameter sadr = 8'b1100_0010;

input                  clk, rst;
output [awidth   -1:0]	adr;
input  [dwidth   -1:0]	din;
output [dwidth   -1:0]	dout;
output                 cyc, stb;
output       	        	we;
output [dwidth/8 -1:0] sel;
input		                ack, err, rty;
input						i2c_wr;
input  [7:0]				i2c_addr;
input  [7:0]				i2c_wrdata1;
input  [7:0]				i2c_wrdata2;
input  [7:0]				i2c_wrdata3;
input  [7:0]				i2c_data_num;
output						i2c_busy;
output [7:0]				i2c_rddata1;
output [7:0]				i2c_rddata2;
output [7:0]				i2c_rddata3;

////////////////////////////////////////////////////////////////////
//
// Local Wires
//

reg	[awidth   -1:0]	adr;
reg	[dwidth   -1:0]	dout;
reg		               cyc, stb;
reg		               we;
//reg [dwidth/8 -1:0] sel;

reg [dwidth   -1:0] q;

reg					i2c_wr_d;
reg	[7:0]			state;
reg					delay_en;
reg					i2c_busy;
reg	[7:0]			i2c_rddata1;
reg [7:0]			i2c_rddata2;
reg [7:0]			i2c_rddata3;

//State machine parameter
parameter    	CASE_IDLE	           =	8'b0000_0001,
				CASE_SET_PRER_LO	   =	8'b0000_0010,
			    CASE_SET_PRER_HI	   =	8'b0000_0100,
			    CASE_ENABLE_CORE	   =	8'b0000_1000,
			    CASE_SEND_ADDR         =	8'b0001_0000,
				CASE_SEND_ADDR_CR	   =    8'b0010_0000,
				CASE_READ_ADDR_SR      =    8'b0100_0000,
			    CASE_WRITE_DATA1  	   =	8'b1000_0000,
				CASE_SEND_DATA1_CR     =    8'b1000_0001,
				CASE_READ_WRDATA1_SR   =    8'b1000_0010,
				CASE_WRITE_DATA2  	   =	8'b1000_0100,
				CASE_SEND_DATA2_CR     =    8'b1000_1000,
				CASE_READ_WRDATA2_SR   =    8'b1001_0000,				
				CASE_WRITE_DATA3  	   =	8'b1010_0000,
				CASE_SEND_DATA3_CR     =    8'b1100_0000,
				CASE_READ_WRDATA3_SR   =    8'b1100_0001,				
				CASE_READ_DATA1_CR     =    8'b1100_0010,
				CASE_READ_RDDATA1_SR   =    8'b1100_0100,
				CASE_READ_DATA1        =    8'b1100_1000,
				CASE_READ_DATA2_CR     =    8'b1101_0000,
				CASE_READ_RDDATA2_SR   =    8'b1110_0000,
				CASE_READ_DATA2        =    8'b1110_0001,
				CASE_READ_DATA3_CR     =    8'b1101_0010,
				CASE_READ_RDDATA3_SR   =    8'b1110_0011,
				CASE_READ_DATA3        =    8'b1110_0100;
				

parameter PRER_LO = 3'b000;
parameter PRER_HI = 3'b001;
parameter CTR     = 3'b010;
parameter RXR     = 3'b011;
parameter TXR     = 3'b011;
parameter CR      = 3'b100;
parameter SR      = 3'b100;

parameter TXR_R   = 3'b101; // undocumented / reserved output
parameter CR_R    = 3'b110; // undocumented / reserved output

parameter RD      = 1'b1;
parameter WR      = 1'b0;
//parameter SADR    = 7'b0010_000;

//parameter		I2C_ADDRESS		=	7'h57;
				
`define			IDLE	    	state[0]
`define			SET_PRER_LO		state[1]
`define			SET_PRER_HI		state[2]
`define			ENABLE_CORE		state[3]
`define			SEND_ADDR		state[4]
`define			SEND_DATA		state[5]

////////////////////////////////////////////////////////////////////

wire				i2c_wr_p = i2c_wr & ~i2c_wr_d;
wire				i2c_wr_n = ~i2c_wr & i2c_wr_d;
wire				delay_out;

DELAY # 
            (
                .DELAY_TIME    (16'h10)
            )
delay_ins   (
                .SYSCLK        (clk),
				.RESET_N       (rst),
				.EN_IN         (delay_en),
				.DISABLE_IN    (0),
				.OUT           (delay_out)
            );

always@(posedge clk)
	if(!rst)
		begin
			i2c_wr_d <= 1'b0;
		end
	else
		begin
			i2c_wr_d <= i2c_wr;
		end


always@(posedge clk)
	if(!rst)
		begin
			delay_en <= 0;
			adr  <= {awidth{1'bx}};
			dout <= {dwidth{1'bx}};
			cyc  <= 1'b0;
			stb  <= 1'b0;
			we   <= 1'b0;
			state <= CASE_IDLE;
			i2c_busy <= 0;
			i2c_rddata1[7:0] <= 0;
			i2c_rddata2[7:0] <= 0;
			i2c_rddata3[7:0] <= 0;
		end
	else
		begin
			case(state)
				CASE_IDLE:	begin
								delay_en <= 0;
								adr  <= {awidth{1'bx}};
								dout <= {dwidth{1'bx}};
								cyc  <= 1'b0;
								stb  <= 1'b0;
								we   <= 1'b0;
								state <= i2c_wr_n? CASE_SET_PRER_LO : CASE_IDLE;
								i2c_busy <= 0;
								i2c_rddata1[7:0] <= i2c_rddata1[7:0];
								i2c_rddata2[7:0] <= i2c_rddata2[7:0];
								i2c_rddata3[7:0] <= i2c_rddata3[7:0];
							end
				CASE_SET_PRER_LO:	begin
										delay_en <= (delay_out & ack)? 0 : 1'b1;
										adr  <= (delay_out & ack)? {awidth{1'bx}} : PRER_LO;
										dout <= (delay_out & ack)? {dwidth{1'bx}} : 8'h64;		//i2c freq
										cyc  <= (delay_out & ack)? 1'b0 : 1'b1;
										stb  <= (delay_out & ack)? 1'b0 : 1'b1;
										we   <= (delay_out & ack)? 1'b0 : 1'b1;
										state <= (delay_out & ack)? CASE_SET_PRER_HI : state;
										i2c_busy <= 1'b1;
									end
				CASE_SET_PRER_HI:	begin
										delay_en <= (delay_out & ack)? 0 : 1'b1;
										adr  <= (delay_out & ack)? {awidth{1'bx}} : PRER_HI;
										dout <= (delay_out & ack)? {dwidth{1'bx}} : 8'h00;		//i2c freq
										cyc  <= (delay_out & ack)? 1'b0 : 1'b1;
										stb  <= (delay_out & ack)? 1'b0 : 1'b1;
										we   <= (delay_out & ack)? 1'b0 : 1'b1;
										state <= (delay_out & ack)? CASE_ENABLE_CORE : state;
									end
				CASE_ENABLE_CORE:	begin
										delay_en <= (delay_out & ack)? 0 : 1'b1;
										adr  <= (delay_out & ack)? {awidth{1'bx}} : CTR;
										dout <= (delay_out & ack)? {dwidth{1'bx}} : 8'h80;		// enable core
										cyc  <= (delay_out & ack)? 1'b0 : 1'b1;
										stb  <= (delay_out & ack)? 1'b0 : 1'b1;
										we   <= (delay_out & ack)? 1'b0 : 1'b1;
										state <= (delay_out & ack)? CASE_SEND_ADDR : state;
									end
				CASE_SEND_ADDR:		begin
										delay_en <= (delay_out & ack)? 0 : 1'b1;
										adr  <= (delay_out & ack)? {awidth{1'bx}} : TXR;
										dout <= (delay_out & ack)? {dwidth{1'bx}} : i2c_addr;		//send i2c address
										cyc  <= (delay_out & ack)? 1'b0 : 1'b1;
										stb  <= (delay_out & ack)? 1'b0 : 1'b1;
										we   <= (delay_out & ack)? 1'b0 : 1'b1;
										state <= (delay_out & ack)? CASE_SEND_ADDR_CR : state;
									end
				CASE_SEND_ADDR_CR:		begin
										delay_en <= (delay_out & ack)? 0 : 1'b1;
										adr  <= (delay_out & ack)? {awidth{1'bx}} : CR;
										dout <= (delay_out & ack)? {dwidth{1'bx}} : 8'h90; // set command (start, write)
										cyc  <= (delay_out & ack)? 1'b0 : 1'b1;
										stb  <= (delay_out & ack)? 1'b0 : 1'b1;
										we   <= (delay_out & ack)? 1'b0 : 1'b1;
										state <= (delay_out & ack)? CASE_READ_ADDR_SR : state;
									end
				CASE_READ_ADDR_SR:		begin
										delay_en <= (delay_out & ack & ~din[1])? 0 : 1'b1;
										adr  <= (delay_out & ack & ~din[1])? {awidth{1'bx}} : SR;
										cyc  <= (delay_out & ack & ~din[1])? 1'b0 : 1'b1;
										stb  <= (delay_out & ack & ~din[1])? 1'b0 : 1'b1;
										we   <= (delay_out & ack & ~din[1])? 1'b0 : 1'b0;
										state <= (delay_out & ack & ~din[1])? ((i2c_addr[0] == 0)?CASE_WRITE_DATA1 : CASE_READ_DATA1_CR) : state;
									end
				
				// write data1
				CASE_WRITE_DATA1:		begin
										delay_en <= (delay_out & ack)? 0 : 1'b1;
										adr  <= (delay_out & ack)? {awidth{1'bx}} : TXR;
										dout <= (delay_out & ack)? {dwidth{1'bx}} : i2c_wrdata1;		//send data1
										cyc  <= (delay_out & ack)? 1'b0 : 1'b1;
										stb  <= (delay_out & ack)? 1'b0 : 1'b1;
										we   <= (delay_out & ack)? 1'b0 : 1'b1;
										state <= (delay_out & ack)? CASE_SEND_DATA1_CR : state;
									end
				CASE_SEND_DATA1_CR:		begin
										delay_en <= (delay_out & ack)? 0 : 1'b1;
										adr  <= (delay_out & ack)? {awidth{1'bx}} : CR;
										dout <= (delay_out & ack)? {dwidth{1'bx}} : ((i2c_data_num==8'h1)? 8'h50 : 8'h10);    // set command (stop,write,ack) and (write,ack)
										cyc  <= (delay_out & ack)? 1'b0 : 1'b1;
										stb  <= (delay_out & ack)? 1'b0 : 1'b1;
										we   <= (delay_out & ack)? 1'b0 : 1'b1;
										state <= (delay_out & ack)? CASE_READ_WRDATA1_SR : state;
									    end
				CASE_READ_WRDATA1_SR:		begin
										delay_en <= (delay_out & ack & ~din[1])? 0 : 1'b1;
										adr  <= (delay_out & ack & ~din[1])? {awidth{1'bx}} : SR;
										cyc  <= (delay_out & ack & ~din[1])? 1'b0 : 1'b1;
										stb  <= (delay_out & ack & ~din[1])? 1'b0 : 1'b1;
										we   <= (delay_out & ack & ~din[1])? 1'b0 : 1'b0;
										state <= (delay_out & ack & ~din[1])? ((i2c_data_num==8'h1)? CASE_IDLE : CASE_WRITE_DATA2) : state;
									end
				// write data2
				CASE_WRITE_DATA2:		begin
										delay_en <= (delay_out & ack)? 0 : 1'b1;
										adr  <= (delay_out & ack)? {awidth{1'bx}} : TXR;
										dout <= (delay_out & ack)? {dwidth{1'bx}} : i2c_wrdata2;
										cyc  <= (delay_out & ack)? 1'b0 : 1'b1;
										stb  <= (delay_out & ack)? 1'b0 : 1'b1;
										we   <= (delay_out & ack)? 1'b0 : 1'b1;
										state <= (delay_out & ack)? CASE_SEND_DATA2_CR : state;
									end
				CASE_SEND_DATA2_CR:		begin
										delay_en <= (delay_out & ack)? 0 : 1'b1;
										adr  <= (delay_out & ack)? {awidth{1'bx}} : CR;
										dout <= (delay_out & ack)? {dwidth{1'bx}} : ((i2c_data_num==8'h2)? 8'h50 : 8'h10);    // set command (stop,write,ack) and (write,ack)
										cyc  <= (delay_out & ack)? 1'b0 : 1'b1;
										stb  <= (delay_out & ack)? 1'b0 : 1'b1;
										we   <= (delay_out & ack)? 1'b0 : 1'b1;
										state <= (delay_out & ack)? CASE_READ_WRDATA2_SR : state;
									    end
				CASE_READ_WRDATA2_SR:		begin
										delay_en <= (delay_out & ack & ~din[1])? 0 : 1'b1;
										adr  <= (delay_out & ack & ~din[1])? {awidth{1'bx}} : SR;
										cyc  <= (delay_out & ack & ~din[1])? 1'b0 : 1'b1;
										stb  <= (delay_out & ack & ~din[1])? 1'b0 : 1'b1;
										we   <= (delay_out & ack & ~din[1])? 1'b0 : 1'b0;
										state <= (delay_out & ack & ~din[1])? ((i2c_data_num==8'h2)? CASE_IDLE : CASE_WRITE_DATA3) : state;
									end
				// write data3
				CASE_WRITE_DATA3:		begin
										delay_en <= (delay_out & ack)? 0 : 1'b1;
										adr  <= (delay_out & ack)? {awidth{1'bx}} : TXR;
										dout <= (delay_out & ack)? {dwidth{1'bx}} : i2c_wrdata3;
										cyc  <= (delay_out & ack)? 1'b0 : 1'b1;
										stb  <= (delay_out & ack)? 1'b0 : 1'b1;
										we   <= (delay_out & ack)? 1'b0 : 1'b1;
										state <= (delay_out & ack)? CASE_SEND_DATA3_CR : state;
									end
				CASE_SEND_DATA3_CR:		begin
										delay_en <= (delay_out & ack)? 0 : 1'b1;
										adr  <= (delay_out & ack)? {awidth{1'bx}} : CR;
										dout <= (delay_out & ack)? {dwidth{1'bx}} : 8'h50;    // set command (stop,write,ack)
										cyc  <= (delay_out & ack)? 1'b0 : 1'b1;
										stb  <= (delay_out & ack)? 1'b0 : 1'b1;
										we   <= (delay_out & ack)? 1'b0 : 1'b1;
										state <= (delay_out & ack)? CASE_READ_WRDATA3_SR : state;
									    end
				CASE_READ_WRDATA3_SR:		begin
										delay_en <= (delay_out & ack & ~din[1])? 0 : 1'b1;
										adr  <= (delay_out & ack & ~din[1])? {awidth{1'bx}} : SR;
										cyc  <= (delay_out & ack & ~din[1])? 1'b0 : 1'b1;
										stb  <= (delay_out & ack & ~din[1])? 1'b0 : 1'b1;
										we   <= (delay_out & ack & ~din[1])? 1'b0 : 1'b0;
										state <= (delay_out & ack & ~din[1])? CASE_IDLE : state;
									end
				
				//read data1
				CASE_READ_DATA1_CR:		begin
										delay_en <= (delay_out & ack)? 0 : 1'b1;
										adr  <= (delay_out & ack)? {awidth{1'bx}} : CR;
										dout <= (delay_out & ack)? {dwidth{1'bx}} : ((i2c_data_num==8'h1)? 8'h68 : 8'h20);    // set command (stop,read, nack_read) and (read, ack_read)
										cyc  <= (delay_out & ack)? 1'b0 : 1'b1;
										stb  <= (delay_out & ack)? 1'b0 : 1'b1;
										we   <= (delay_out & ack)? 1'b0 : 1'b1;
										state <= (delay_out & ack)? CASE_READ_RDDATA1_SR : state;
									    end
				CASE_READ_RDDATA1_SR:		begin
										delay_en <= (delay_out & ack & ~din[1])? 0 : 1'b1;
										adr  <= (delay_out & ack & ~din[1])? {awidth{1'bx}} : SR;
										cyc  <= (delay_out & ack & ~din[1])? 1'b0 : 1'b1;
										stb  <= (delay_out & ack & ~din[1])? 1'b0 : 1'b1;
										we   <= (delay_out & ack & ~din[1])? 1'b0 : 1'b0;
										state <= (delay_out & ack & ~din[1])? CASE_READ_DATA1 : state;
									end
				CASE_READ_DATA1:		begin
										delay_en <= (delay_out & ack)? 0 : 1'b1;
										adr  <= (delay_out & ack)? {awidth{1'bx}} : RXR;
										cyc  <= (delay_out & ack)? 1'b0 : 1'b1;
										stb  <= (delay_out & ack)? 1'b0 : 1'b1;
										we   <= (delay_out & ack)? 1'b0 : 1'b0;										
										i2c_rddata1[7:0] <= (delay_out & ack)? din[7:0] : i2c_rddata1[7:0];    // read data1
										state <= (delay_out & ack)? ((i2c_data_num==8'h1)? CASE_IDLE : CASE_READ_DATA2_CR) : state;
									end
				
				//read data2
				CASE_READ_DATA2_CR:		begin
										delay_en <= (delay_out & ack)? 0 : 1'b1;
										adr  <= (delay_out & ack)? {awidth{1'bx}} : CR;
										dout <= (delay_out & ack)? {dwidth{1'bx}} : ((i2c_data_num==8'h2)? 8'h68 : 8'h20);    // set command (read, nack_read) and (read, ack_read)
										cyc  <= (delay_out & ack)? 1'b0 : 1'b1;
										stb  <= (delay_out & ack)? 1'b0 : 1'b1;
										we   <= (delay_out & ack)? 1'b0 : 1'b1;
										state <= (delay_out & ack)? CASE_READ_RDDATA2_SR : state;
									    end
				CASE_READ_RDDATA2_SR:		begin
										delay_en <= (delay_out & ack & ~din[1])? 0 : 1'b1;
										adr  <= (delay_out & ack & ~din[1])? {awidth{1'bx}} : SR;
										cyc  <= (delay_out & ack & ~din[1])? 1'b0 : 1'b1;
										stb  <= (delay_out & ack & ~din[1])? 1'b0 : 1'b1;
										we   <= (delay_out & ack & ~din[1])? 1'b0 : 1'b0;
										state <= (delay_out & ack & ~din[1])? CASE_READ_DATA2 : state;
									end
				CASE_READ_DATA2:		begin
										delay_en <= (delay_out & ack)? 0 : 1'b1;
										adr  <= (delay_out & ack)? {awidth{1'bx}} : RXR;
										cyc  <= (delay_out & ack)? 1'b0 : 1'b1;
										stb  <= (delay_out & ack)? 1'b0 : 1'b1;
										we   <= (delay_out & ack)? 1'b0 : 1'b0;										
										i2c_rddata2[7:0] <= (delay_out & ack)? din[7:0] : i2c_rddata2[7:0];    // read data2
										state <= (delay_out & ack)? ((i2c_data_num==8'h2)? CASE_IDLE : CASE_READ_DATA3_CR) : state;
									end

				//read data3
				CASE_READ_DATA3_CR:		begin
										delay_en <= (delay_out & ack)? 0 : 1'b1;
										adr  <= (delay_out & ack)? {awidth{1'bx}} : CR;
										dout <= (delay_out & ack)? {dwidth{1'bx}} : ((i2c_data_num==8'h3)? 8'h68 : 8'h20);    // set command (read, nack_read) and (read, ack_read)
										cyc  <= (delay_out & ack)? 1'b0 : 1'b1;
										stb  <= (delay_out & ack)? 1'b0 : 1'b1;
										we   <= (delay_out & ack)? 1'b0 : 1'b1;
										state <= (delay_out & ack)? CASE_READ_RDDATA3_SR : state;
									    end
				CASE_READ_RDDATA3_SR:		begin
										delay_en <= (delay_out & ack & ~din[1])? 0 : 1'b1;
										adr  <= (delay_out & ack & ~din[1])? {awidth{1'bx}} : SR;
										cyc  <= (delay_out & ack & ~din[1])? 1'b0 : 1'b1;
										stb  <= (delay_out & ack & ~din[1])? 1'b0 : 1'b1;
										we   <= (delay_out & ack & ~din[1])? 1'b0 : 1'b0;
										state <= (delay_out & ack & ~din[1])? CASE_READ_DATA3 : state;
									end
				CASE_READ_DATA3:		begin
										delay_en <= (delay_out & ack)? 0 : 1'b1;
										adr  <= (delay_out & ack)? {awidth{1'bx}} : RXR;
										cyc  <= (delay_out & ack)? 1'b0 : 1'b1;
										stb  <= (delay_out & ack)? 1'b0 : 1'b1;
										we   <= (delay_out & ack)? 1'b0 : 1'b0;										
										i2c_rddata3[7:0] <= (delay_out & ack)? din[7:0] : i2c_rddata3[7:0];    // read data2
										state <= (delay_out & ack)? ((i2c_data_num==8'h3)? CASE_IDLE : CASE_IDLE) : state;
									end
									
				default:			state <= CASE_IDLE;
				
			endcase
		end




endmodule