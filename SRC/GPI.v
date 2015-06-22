//************************************************************************
//**                          Hattrick      							**
//**                          GPI.v										**
//************************************************************************ 

//**********************      ChangeList      *****************************

`include "../SRC/hattrick_define.v"

module GPI (
                input	    		SYSCLK,		 	//System clock
                input	    		RESET_N,		//Reset signal
                            
                input	    		PORT_CS1,		//PORT select signal
                input	    [15:0]	OFFSET_SEL1,	//Address offset selection
                input	    		RD_WR1,			//I2C read/write signal, 1 means read, 0 means write
                input	    		PORT_CS2,		//PORT select signal
                input	    [15:0]	OFFSET_SEL2,	//Address offset selection
                input	    		RD_WR2,			//I2C read/write signal, 1 means read, 0 means write

                output reg	[7:0]	DOUT1,			//Output data when I2C read operation
                output reg	[7:0]	DOUT2,			//Output data when I2C read operation
                
                input       [7:0]   DIN0,DIN1,DIN2,DIN3,
				                    DIN4,DIN5,DIN6,DIN7,
									DIN8,DIN9,DIN10,DIN11,
									DIN12,DIN13,DIN14,DIN15
			);

//Output data when I2C read operation FOR I2C1
wire		[7:0]	DOUT_W1 =	({8{OFFSET_SEL1[0 ]}} & DIN0  )    |
                                ({8{OFFSET_SEL1[1 ]}} & DIN1  )    |
                                ({8{OFFSET_SEL1[2 ]}} & DIN2  )    |
                                ({8{OFFSET_SEL1[3 ]}} & DIN3  )    |
                                ({8{OFFSET_SEL1[4 ]}} & DIN4  )    |
								({8{OFFSET_SEL1[5 ]}} & DIN5  )    |
                                ({8{OFFSET_SEL1[6 ]}} & DIN6  )    |
                                ({8{OFFSET_SEL1[7 ]}} & DIN7  )    |
                                ({8{OFFSET_SEL1[8 ]}} & DIN8  )    |
                                ({8{OFFSET_SEL1[9 ]}} & DIN9  )    |
								({8{OFFSET_SEL1[10]}} & DIN10 )    |
                                ({8{OFFSET_SEL1[11]}} & DIN11 )    |
                                ({8{OFFSET_SEL1[12]}} & DIN12 )    |
                                ({8{OFFSET_SEL1[13]}} & DIN13 )    |
                                ({8{OFFSET_SEL1[14]}} & DIN14 )    |
								({8{OFFSET_SEL1[15]}} & DIN15 );

//Output data when I2C read operation FOR I2C2
wire		[7:0]	DOUT_W2 =	({8{OFFSET_SEL2[0 ]}} & DIN0  )    |
                                ({8{OFFSET_SEL2[1 ]}} & DIN1  )    |
                                ({8{OFFSET_SEL2[2 ]}} & DIN2  )    |
                                ({8{OFFSET_SEL2[3 ]}} & DIN3  )    |
                                ({8{OFFSET_SEL2[4 ]}} & DIN4  )    |
								({8{OFFSET_SEL2[5 ]}} & DIN5  )    |
                                ({8{OFFSET_SEL2[6 ]}} & DIN6  )    |
                                ({8{OFFSET_SEL2[7 ]}} & DIN7  )    |
                                ({8{OFFSET_SEL2[8 ]}} & DIN8  )    |
                                ({8{OFFSET_SEL2[9 ]}} & DIN9  )    |
								({8{OFFSET_SEL2[10]}} & DIN10 )    |
                                ({8{OFFSET_SEL2[11]}} & DIN11 )    |
                                ({8{OFFSET_SEL2[12]}} & DIN12 )    |
                                ({8{OFFSET_SEL2[13]}} & DIN13 )    |
                                ({8{OFFSET_SEL2[14]}} & DIN14 )    |
								({8{OFFSET_SEL2[15]}} & DIN15 );
                                
//READ
always@(posedge SYSCLK or negedge RESET_N)
	begin
		if(RESET_N == 1'b0)
			begin
				DOUT1 <= 8'h0;
			end
		else
			begin
				DOUT1 <= (PORT_CS1 & RD_WR1)? DOUT_W1 : DOUT1;
			end
	end

always@(posedge SYSCLK or negedge RESET_N)
	begin
		if(RESET_N == 1'b0)
			begin
				DOUT2 <= 8'h0;
			end
		else
			begin
				DOUT2 <= (PORT_CS2 & RD_WR2)? DOUT_W2 : DOUT2;
			end
	end

endmodule
