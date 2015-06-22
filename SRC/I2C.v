//************************************************************************
//**                          Hattrick      							**
//**                          I2C.v										**
//************************************************************************ 

//**********************      ChangeList      *****************************


//******      Statement        *******
//This I2C MACHINE will be use as I2C slave.Its data format of transmission is shown as below:
//Write transmission: including three byte --- slave address byte & location byte & data byte


`timescale 1ns/1ns

`include "../SRC/hattrick_define.v"

module I2C 
           (	SCL,SDA,I2C_RESET_N,SYSCLK,PORT_CS,OFFSET_SEL,DOUT,RD_WR,
            	DIN_0, DIN_1, DIN_2, DIN_3, DIN_4, DIN_5, DIN_6, DIN_7,
				DIN_8, DIN_9, DIN_A, DIN_B, DIN_C, DIN_D, DIN_E, DIN_F,
			   	I2C_ADDRESS
			   );

input    SCL;    //I2C clock
input    I2C_RESET_N;    //I2C machine reset signal
input    SYSCLK;     //I2C sample clock
input    [7:0]  DIN_0;                        // data in from port 0
input    [7:0]  DIN_1;                        // data in from port 1
input    [7:0]  DIN_2;                        // data in from port 2
input    [7:0]  DIN_3;                        // data in from port 3
input    [7:0]  DIN_4;                        // data in from port 4
input    [7:0]  DIN_5;                        // data in from port 5
input    [7:0]  DIN_6;                        // data in from port 6
input    [7:0]  DIN_7;                        // data in from port 7
input    [7:0]  DIN_8;                        // data in from port 8
input    [7:0]  DIN_9;                        // data in from port 9
input    [7:0]  DIN_A;                        // data in from port a
input    [7:0]  DIN_B;                        // data in from port b
input    [7:0]  DIN_C;                        // data in from port c
input    [7:0]  DIN_D;                        // data in from port d
input    [7:0]  DIN_E;                        // data in from port e
input    [7:0]  DIN_F;                        // data in from port f
input	[6:0]	I2C_ADDRESS;

output    RD_WR;     //I2C read/write signal, 1 is read, 0 is write
output    [7:0]	DOUT;    //I2C machine output port
output    [15:0]	PORT_CS,OFFSET_SEL;    //Register address selection

inout    SDA;    //I2C data

//TIMER overflow
wire    TIMER_OVFLOW;
reg    TIMER_CLR_N;
parameter    TIMER_1S  =  32'h4C4B40;     //1S on 5MHz clock
parameter    TIMER_5S  =  32'h17D7840;     //5S on 5MHz clock

//internal register
reg    [7:0]	STATE;    //Indicate I2C machine state
reg    START,STOP;          //if START=1, it means one I2C transmission start
reg    SCL_D1,SCL_D2,SCL_PCLK,SCL_NCLK,SCL_PCLKD1,SCL_PCLKD2,SCL_PCLKD3,
       SDA_D1,SDA_D2,SDA_PCLK,SDA_NCLK;    //for detect the edge of SCL&SDA
reg    SDA_OUT,SDA_OE;    //I2C SDA output and enable
reg    NEXT_STATE,NEXT_STATE_D1,NEXT_STATE_D2;    //for I2C machine register
reg    [3:0]  CNT;    //Bit counter
reg    CNT8,CNT9;         //set CNT8 when CNT=8, it means I2C machine has sampled 8-bits, sampling at rising edge of SCL
reg    RD_WR,ADD_OK;    //Read/Write signal, Address match
reg    [7:0]	LOC;    //Register location 
reg    WR_EN,WR_END1,WR_END2,RD_EN,RD_END1,RD_END2,RD_END3;    //Write and read enable
reg    [15:0]	PORT_CS,PORT_CSD1,PORT_CSD2;    //Port cs

reg    [7:0]    SHIFT_DIN;           //shift SDA data into this register
reg    [7:0]    REG_DIN;             //when PORT_CSD, latch the data from internal register,this data will put into SHIFT_DOUT.
reg    [7:0]    SHIFT_DOUT;          //if read,after LOC state,latch the data into this register,then shift data out through SDA.
reg    [7:0]	 DOUT;                //output data to other module,use PORT_CS & OFFSET_SEL
reg    [7:0]    CHECKSUM_IN;         //when write,receive this byte when DATA2, if it is same as DOUT 2'complement, then PORT_CS will be set, and DOUT will be output to GPIO.
reg    MASTER_RD_NACK;               //during read cycle, master should not generate ACK to slave after last byte
reg    I2C_NACK;                     //for SDA_OE

//State machine parameter
parameter    		CASE_I2C_IDLE		=	8'b0000_0001,
             		CASE_I2C_ADD		=	8'b0000_0010,
			    	CASE_I2C_LOC		=	8'b0000_0100,
			    	CASE_I2C_DATA1		=	8'b0000_1000,
			    	CASE_I2C_DATA2		=	8'b0001_0000,
			    	CASE_I2C_END	   	=	8'b0010_0000,
			    	CASE_I2C_END_NOCHK  =	8'b0100_0000;
				
//parameter		I2C_ADDRESS		=	7'h57;
				
`define			I2C_IDLE	   		STATE[0]
`define			I2C_ADD			STATE[1]
`define			I2C_LOC			STATE[2]
`define			I2C_DATA1		STATE[3]
`define			I2C_DATA2		STATE[4]
`define			I2C_END			STATE[5]
`define			I2C_END_NOCHK	STATE[6]

//wire	  RESET_N = I2C_RESET_N & ~TIMER_OVFLOW;    //When I2C watchdog overflow, I2C machine will be reset
wire	  RESET_N = I2C_RESET_N;

//sampling rising or falling edge of SCL&SDA
wire    SCL_PCLK_W	=	 ~SCL_D2 & SCL_D1;      //rising edge of SCL
wire    SCL_NCLK_W	=	 SCL_D2 & ~SCL_D1;      //falling edge of SCL
wire    SDA_PCLK_W  =    ~SDA_D2 & SDA_D1;      //rising edge of SDA
wire    SDA_NCLK_W	=	 SDA_D2 & ~SDA_D1;      //falling edge of SDA

wire    CNT0_W = (CNT == 4'h0)? 1'b1 : 1'b0;    //First bit
wire    CNT7_W = (CNT == 4'h7)? 1'b1 : 1'b0;    //set CNT7_W
wire    CNT8_W = (CNT == 4'h8)? 1'b1 : 1'b0;    //set CNT8_W, when CNT=8, it means I2C machine has sampled 8-bits
wire    CNT9_W = (CNT == 4'h9)? 1'b1 : 1'b0;    //Last bit, acknowledge bit

wire    NEXT_STATE_W = (CNT9_W & SCL_NCLK_W)? 1'b1 : 1'b0;    //When this signal asserted, I2C machine will go to next state
wire    START_W = SCL & SDA_NCLK_W;    //A HIGH to LOW transition on the SDA line while SCL is high is start transition
wire    STOP_W = SCL & SDA_PCLK_W;    //A LOW to HIGH transition on the SDA line while SCL is high is stop transition
wire    I2C_CHECKSUM_SEL = `I2C_CHECKSUM;     //0 means no checksum byte, 1 means one checksum byte after R/W
//test0711
//wire    CHECKSUM_RESULT = (((LOC + DOUT + CHECKSUM_IN) == 8'h0) & I2C_CHECKSUM_SEL);
wire    CHECKSUM_RESULT = ((DOUT + CHECKSUM_IN) == 8'h0) & I2C_CHECKSUM_SEL;
//test0718
//wire    [7:0]    CHECKSUM_OUT = (8'h0 - REG_DIN);         //when read,upload this value to master on DATA2 transmission
wire    [7:0]    CHECKSUM_OUT = (`I2C_DATA1&CNT8)? (8'h0 - REG_DIN) : CHECKSUM_OUT;         //when read,upload this value to master on DATA2 transmission

//port and offset
wire [15:0] 	PORT_W   = {(LOC[7:4] == 4'hF), (LOC[7:4] == 4'hE), (LOC[7:4] == 4'hD), (LOC[7:4] == 4'hC),
			                (LOC[7:4] == 4'hB), (LOC[7:4] == 4'hA), (LOC[7:4] == 4'h9), (LOC[7:4] == 4'h8),
			                (LOC[7:4] == 4'h7), (LOC[7:4] == 4'h6), (LOC[7:4] == 4'h5), (LOC[7:4] == 4'h4),
			                (LOC[7:4] == 4'h3), (LOC[7:4] == 4'h2), (LOC[7:4] == 4'h1), (LOC[7:4] == 4'h0)};
   
wire [15:0] 	OFFSET_SEL = {(LOC[3:0] == 4'hF), (LOC[3:0] == 4'hE), (LOC[3:0] == 4'hD), (LOC[3:0] == 4'hC),
			                  (LOC[3:0] == 4'hB), (LOC[3:0] == 4'hA), (LOC[3:0] == 4'h9), (LOC[3:0] == 4'h8),
			                  (LOC[3:0] == 4'h7), (LOC[3:0] == 4'h6), (LOC[3:0] == 4'h5), (LOC[3:0] == 4'h4),
			                  (LOC[3:0] == 4'h3), (LOC[3:0] == 4'h2), (LOC[3:0] == 4'h1), (LOC[3:0] == 4'h0)};
				 

//I2C		    
assign SDA =  (SDA_OE)? SDA_OUT : 1'bz; 
//assign SDA =  (SDA_OE)? (SDA_OUT? 1'bz : 0) : 1'bz; 

//Log SCL and SDA state for positive&negative edge detection
always@(posedge SYSCLK or negedge RESET_N)
	begin
		if(RESET_N == 1'b0)
			begin
			  {SCL_D1,SCL_D2,SDA_D1,SDA_D2}	<=	4'b0;
			  SCL_PCLKD1 <= 1'b0;
			  SCL_PCLKD2 <= 1'b0;
			  SCL_PCLKD3 <= 1'b0;
			end
		else
			begin
			  {SCL_D2,SCL_D1} <= {SCL_D1,SCL};
			  {SDA_D2,SDA_D1} <= {SDA_D1,SDA};
			  SCL_NCLK <= SCL_NCLK_W;
			  SDA_NCLK <= SDA_NCLK_W;
			  {SCL_PCLKD3,SCL_PCLKD2,SCL_PCLKD1,SCL_PCLK} <= {SCL_PCLKD2,SCL_PCLKD1,SCL_PCLK,SCL_PCLK_W};
			  SDA_PCLK <= SDA_PCLK_W;			
			end
	end

//START & STOP,sampling start&stop signal  
always@(posedge SYSCLK or negedge RESET_N)
	 begin
		if(RESET_N == 1'b0)
			begin
				START <= 1'b0;
				STOP  <= 1'b0;
			end
		else
			begin
				START <= (SCL)? ((SDA_NCLK)? 1'b1 : 1'b0) : 1'b0;       //set START, SDA negedge at SCL = 1
				STOP  <= (SCL)? ((SDA_PCLK)? 1'b1 : 1'b0) : 1'b0;       //set STOP, SDA posedge at SCL = 1
			end			
	 end
	 

//CNT and NEXT_STATE
always@(posedge SYSCLK or negedge RESET_N)
	 begin
		if(RESET_N == 1'b0)
			begin
				CNT	<= 4'b0;
				CNT8 <= 1'b0;
				CNT9 <= 1'b0;
				NEXT_STATE <= 1'b0;
				NEXT_STATE_D1 <= 1'b0;
				NEXT_STATE_D2 <= 1'b0;
			end
		else
			begin
            CNT <= (START_W | NEXT_STATE_D2 | STOP_W)? 4'b0 : (((~`I2C_IDLE) & SCL_PCLK)? (CNT + 1'b1) : CNT);
				CNT8 <= CNT8_W;
				CNT9 <= CNT9_W;
				NEXT_STATE <= NEXT_STATE_W;
				NEXT_STATE_D1 <= NEXT_STATE;
				NEXT_STATE_D2 <= NEXT_STATE_D1;
			end
    end
    
//SHIFT_DIN,shift the data from SDA into SHIFT_DIN
always@(posedge SYSCLK or negedge RESET_N)
	 begin
		if(RESET_N == 1'b0)
			begin
				SHIFT_DIN <= 8'b0;
			end
		else
			begin
				SHIFT_DIN <= (`I2C_IDLE | `I2C_END)? 8'b0 : (SCL_PCLK? {SHIFT_DIN[6:0],SDA} : SHIFT_DIN);
			end
	 end
	 	
//RD_WR & ADD_OK,address state, in this state: 1.RD_WR will be set, read=1 write=0. 2.ADD_OK will be set
always@(posedge SYSCLK or negedge RESET_N)
	 begin
		if(RESET_N == 1'b0)
			begin
				RD_WR <= 1'b0;
				ADD_OK <= 1'b0;
			end
		else
			begin
				RD_WR <= STOP_W? 1'b0 : ((CNT8_W & `I2C_ADD) ? SHIFT_DIN[0] : RD_WR);
				ADD_OK <= (CNT8_W & `I2C_ADD)? ((SHIFT_DIN[7:1] == I2C_ADDRESS)? 1'b1 : 1'b0): ADD_OK;
			end
    end
    
//LOC,register location state
always@(posedge SYSCLK or negedge RESET_N)
	 begin
		if(RESET_N == 1'b0)
			begin
				LOC <= 8'h0;
			end
		else
			begin
				LOC <= (CNT8 & `I2C_LOC & SCL_NCLK & ~RD_WR)? SHIFT_DIN : ((CNT8 & `I2C_DATA1 & SCL_NCLK & RD_WR)? (LOC+1'b1) : LOC);         //latch the LOC when falling edge of SCL
			end
	 end
	 		
//receive data state, in this state, the data will be save in DOUT
always@(posedge SYSCLK or negedge RESET_N)
	 begin
		if(RESET_N == 1'b0)
			begin
				DOUT <= 8'b0;
				CHECKSUM_IN <= 8'b0;
			end
		else
			begin
				DOUT <= (CNT8 & `I2C_DATA1 & SCL_NCLK & ~RD_WR)? SHIFT_DIN : DOUT;      //latch the DOUT when falling edge of SCL
				CHECKSUM_IN <= (CNT8 & `I2C_DATA2 & SCL_NCLK & ~RD_WR)? SHIFT_DIN : CHECKSUM_IN;
			end
	 end
	 		
//RD_EN,WR_EN,PORT_CS,send the data to register,trigger the PORT_CS, POST_CS trigger by WR_EN&RD_EN
always@(posedge SYSCLK or negedge RESET_N)
	 begin
		if(RESET_N == 1'b0)
			begin
				{RD_END3,RD_END2,RD_END1,RD_EN} <= 4'b0;				
				{WR_END2,WR_END1,WR_EN} <= 3'b0;				
				{PORT_CSD2,PORT_CSD1,PORT_CS} <= 24'b0;				
			end
		else
			begin
				//test0711
				//RD_EN <= SCL_PCLKD2 & RD_WR & (`I2C_LOC | (`I2C_DATA1 & ~MASTER_RD_NACK) | `I2C_DATA2) & CNT9_W;   //Latch data at falling edge of 9th SCL
				RD_EN <= SCL_PCLKD2 & RD_WR & (`I2C_ADD | (`I2C_DATA1 & ~MASTER_RD_NACK) | `I2C_DATA2) & CNT9_W;   //Latch data at falling edge of 9th SCL
				//test0718
				WR_EN <= (CNT == 4'h1) & ~RD_WR & `I2C_END;
				//WR_EN <= (CNT == 4'h1) & ~RD_WR & `I2C_END | `I2C_END_NOCHK;
				//WR_EN <= (CNT == 4'h1) & ~RD_WR;
				PORT_CS <= I2C_CHECKSUM_SEL?({16{((WR_EN & CHECKSUM_RESULT)| RD_EN | `I2C_END_NOCHK)}} & PORT_W) : ({16{WR_EN | RD_EN}} & PORT_W);
				{RD_END3,RD_END2,RD_END1} <= {RD_END2,RD_END1,RD_EN};
				{WR_END2,WR_END1} <= {WR_END1,WR_EN};
				{PORT_CSD2,PORT_CSD1} <= {PORT_CSD1,PORT_CS};				
			end
     end

//SDA_OE
//When read operation, OE will active at date transition phase from bit0-bit7
//When write operation, OE will active at ninth bit transition phase for acknoledge
always@(posedge SYSCLK or negedge RESET_N)
	 begin
		if(RESET_N == 1'b0)
			begin
				SDA_OE <= 1'b0;
			end
		else
			begin
			   SDA_OE   <= (`I2C_IDLE | `I2C_END)? 1'b0 : (SCL_NCLK_W? ((CNT8_W & I2C_NACK) ? 1'b0 : (RD_WR ? ~(`I2C_IDLE | (~`I2C_ADD & CNT8_W) | `I2C_END | ((`I2C_DATA1 | `I2C_DATA2) & MASTER_RD_NACK)) : CNT8_W)) : SDA_OE);				 
			end
     end


//REG_DIN,Latch data at rising edge of 9th SCL, this register is for prepare data in read operation, this data is for output.
//always@(posedge SYSCLK or negedge RESET_N)
always@(negedge SYSCLK or negedge RESET_N)
	 begin
		if(RESET_N == 1'b0)
			begin				
				REG_DIN <= 8'b0;
			end
		else
			begin
			       REG_DIN <= RD_END2 ? (({8{PORT_CSD1[0]}} & DIN_0) | ({8{PORT_CSD1[8]}}  & DIN_8) | 
			       ({8{PORT_CSD1[1]}} & DIN_1) | ({8{PORT_CSD1[9]}}  & DIN_9) | 
			       ({8{PORT_CSD1[2]}} & DIN_2) | ({8{PORT_CSD1[10]}} & DIN_A) | 
			       ({8{PORT_CSD1[3]}} & DIN_3) | ({8{PORT_CSD1[11]}} & DIN_B) | 
			       ({8{PORT_CSD1[4]}} & DIN_4) | ({8{PORT_CSD1[12]}} & DIN_C) | 
			       ({8{PORT_CSD1[5]}} & DIN_5) | ({8{PORT_CSD1[13]}} & DIN_D) | 
			       ({8{PORT_CSD1[6]}} & DIN_6) | ({8{PORT_CSD1[14]}} & DIN_E) | 
			       ({8{PORT_CSD1[7]}} & DIN_7) | ({8{PORT_CSD1[15]}} & DIN_F)) :  REG_DIN;
			end
     end
     
//SDA_OUT and SHIFT_DOUT for read operate
always@(posedge SYSCLK or negedge RESET_N)
	 begin
		if(RESET_N == 1'b0)
			begin				
				SHIFT_DOUT <= 8'b0;
				SDA_OUT <= 1'b0;
			end
		else
			begin
			   SHIFT_DOUT <=  SCL_NCLK_W ? (CNT9_W ? (//test0711({8{`I2C_ADD}} & LOC)  
					                         //|  ({8{`I2C_LOC | `I2C_DATA1 | `I2C_DATA2 }} & REG_DIN)) :  {SHIFT_DOUT[6:0],1'b0}) : (`I2C_IDLE? 8'h0 : SHIFT_DOUT);
					                         //test0711
					                                //|  ({8{`I2C_LOC}} & REG_DIN)
					                                ({8{`I2C_ADD}} & REG_DIN)
					                                					|  ({8{`I2C_DATA1}} & REG_DIN)) :  {SHIFT_DOUT[6:0],1'b0}) : (`I2C_IDLE? 8'h0 : SHIFT_DOUT);
													 //Latch data in REG_DIN at falling edge of 9th SCL
			   SDA_OUT <= SCL_NCLK ? SHIFT_DOUT[7] : SDA_OUT;
			end
     end

//NACK
//during read cycle, master should not generate ACK to slave after last byte
always@(posedge SYSCLK or negedge RESET_N)
	 begin
		if(RESET_N == 1'b0)
			begin				
				I2C_NACK <= 0;
				MASTER_RD_NACK <= 0;
			end
		else
			begin				
				I2C_NACK <= SCL_PCLKD2 ? (`I2C_IDLE | (`I2C_ADD & ~ADD_OK )  | `I2C_END ) : I2C_NACK;         //FOR SDA_OE
				MASTER_RD_NACK <= (`I2C_LOC | `I2C_DATA1 | `I2C_DATA2 | RD_WR)? ((CNT9_W & SCL_PCLKD1)? SDA : MASTER_RD_NACK ) : MASTER_RD_NACK;  //Detect NACK when read
			end
	end

	
//I2C machine
always@(posedge SYSCLK or negedge RESET_N)
	 begin
		if(RESET_N == 1'b0)
			begin
				STATE <= CASE_I2C_IDLE;
			end
		else
			begin
				case(STATE)
					CASE_I2C_IDLE: 	 STATE <= START_W? CASE_I2C_ADD : CASE_I2C_IDLE;      //START
					//test0711
					//CASE_I2C_ADD: 	    STATE <= START_W? CASE_I2C_ADD : (STOP_W? CASE_I2C_IDLE : (NEXT_STATE_D2? (ADD_OK? CASE_I2C_LOC : CASE_I2C_IDLE) : CASE_I2C_ADD));
					CASE_I2C_ADD: 	    STATE <= START_W? CASE_I2C_ADD : (STOP_W? CASE_I2C_IDLE : (NEXT_STATE_D2? (ADD_OK? (RD_WR? CASE_I2C_DATA1 : CASE_I2C_LOC) : CASE_I2C_IDLE) : CASE_I2C_ADD));
					CASE_I2C_LOC: 	    STATE <= START_W? CASE_I2C_ADD : (STOP_W? CASE_I2C_IDLE : (NEXT_STATE_D2? (MASTER_RD_NACK? CASE_I2C_IDLE : CASE_I2C_DATA1) : CASE_I2C_LOC));
					//test0718
					//dy20150313
					//CASE_I2C_DATA1:    STATE <= START_W? CASE_I2C_ADD : (STOP_W? CASE_I2C_IDLE : (NEXT_STATE_D2? (I2C_CHECKSUM_SEL? CASE_I2C_DATA2 : CASE_I2C_END) : CASE_I2C_DATA1));
					//CASE_I2C_DATA1:    STATE <= START_W? CASE_I2C_ADD : (STOP_W? CASE_I2C_IDLE : CASE_I2C_DATA1);
					CASE_I2C_DATA1:    STATE <= START_W? CASE_I2C_ADD : (STOP_W? CASE_I2C_IDLE : ((NEXT_STATE_D2 && !RD_WR)? CASE_I2C_END : CASE_I2C_DATA1));
					
					//CASE_I2C_DATA1:    STATE <= START_W? CASE_I2C_ADD : (STOP_W? CASE_I2C_END : (NEXT_STATE_D2? (I2C_CHECKSUM_SEL? CASE_I2C_DATA2 : CASE_I2C_END) : CASE_I2C_DATA1));
					//CASE_I2C_DATA1:    STATE <= START_W? CASE_I2C_ADD : (STOP_W? CASE_I2C_IDLE : (NEXT_STATE_D2? (MASTER_RD_NACK? CASE_I2C_IDLE : CASE_I2C_END) : CASE_I2C_DATA1));
					//CASE_I2C_DATA1:  STATE <= (START_W)? CASE_I2C_ADD : ((STOP_W)? CASE_I2C_IDLE : (NEXT_STATE_D2? (MASTER_RD_NACK? CASE_I2C_IDLE :(FIFO_RD? CASE_I2C_DATA2 : (INFO_RD? CASE_I2C_DATA1 : CASE_I2C_END))) : CASE_I2C_DATA1));
					//test0718
					//CASE_I2C_DATA2:    STATE <= START_W? CASE_I2C_ADD : (STOP_W? CASE_I2C_IDLE : (NEXT_STATE_D2? CASE_I2C_END : CASE_I2C_DATA2));
					CASE_I2C_DATA2:    STATE <= START_W? CASE_I2C_ADD : (STOP_W? (RD_WR? CASE_I2C_IDLE : CASE_I2C_END_NOCHK) : (NEXT_STATE_D2? CASE_I2C_END : CASE_I2C_DATA2));
					//CASE_I2C_DATA2:    STATE <= (START_W)? CASE_I2C_ADD : ((STOP_W)? CASE_I2C_IDLE : ((NEXT_STATE_D2)? (MASTER_RD_NACK? CASE_I2C_IDLE : CASE_I2C_DATA1) : CASE_I2C_DATA2));
					CASE_I2C_END:      STATE <= (START_W)? CASE_I2C_ADD : ((STOP_W)? CASE_I2C_IDLE : ((NEXT_STATE_D2)? CASE_I2C_IDLE : CASE_I2C_END));					
					CASE_I2C_END_NOCHK: STATE <= CASE_I2C_IDLE;
					default:		       STATE <= CASE_I2C_IDLE;
				endcase
			end
     end

//TIMER overflow
//only when SDA_OE=1 and SDA_OUT=0, the timer begin to count
/*
always@(posedge SYSCLK or negedge RESET_N)
	begin
		if(RESET_N == 1'b0)
			TIMER_CLR_N <= 0;
		else		
			//TIMER_CLR_N <= (SDA_OE & ~SDA_OUT)? 1'b1 : 1'b0;
			TIMER_CLR_N <= SDA_OE? 1'b1 : 1'b0;
	end
	
TIMER_PULSE TIMER_INS (
				 .CLK_5MHZ	  (CLK_5MHZ),
				 .TIMER_CLR_N  (TIMER_CLR_N | TIMER_OVFLOW),
				 .TIMER_SET    (TIMER_1S),
				 .TIMER_OVFLOW (TIMER_OVFLOW)
				);
*/
endmodule 
