//************************************************************************
//**                          Hattrick      							**
//**                          INTERRUPT.v								**
//************************************************************************ 

//**********************      ChangeList      *****************************

`include "../SRC/hattrick_define.v"

module INTERRUPT (
                input	    		SYSCLK,		 	//System clock
                input	    		RESET_N,		//Reset signal
                            
                input	    		PORT_CS1,		//PORT select signal
                input	    [15:0]	OFFSET_SEL1,	//Address offset selection
                input	    		RD_WR1,			//I2C read/write signal, 1 means read, 0 means write

                output reg	[7:0]	DOUT1,			//Output data when I2C read operation
                
                input       [7:0]   DIN0,DIN1,DIN2,DIN3,
				                    DIN4,DIN5,DIN6,DIN7,
									DIN8,DIN9,DIN10,DIN11,
									DIN12,DIN13,DIN14,DIN15,
				
				output              I2C_ALERT_L
			);

reg                 INTERRUPT7,INTERRUPT6,INTERRUPT5,INTERRUPT4,
                    INTERRUPT3,INTERRUPT2,INTERRUPT1,INTERRUPT0;
			
//Output data when I2C read operation FOR I2C1
wire		[7:0]	DOUT_W1 =	({8{OFFSET_SEL1[0 ]}} & {INTERRUPT7,INTERRUPT6,INTERRUPT5,INTERRUPT4,
                                                         INTERRUPT3,INTERRUPT2,INTERRUPT1,INTERRUPT0}  )    |
                                ({8{OFFSET_SEL1[1 ]}} & 0 )    |
                                ({8{OFFSET_SEL1[2 ]}} & 0 )    |
                                ({8{OFFSET_SEL1[3 ]}} & 0 )    |
                                ({8{OFFSET_SEL1[4 ]}} & 0 )    |
								({8{OFFSET_SEL1[5 ]}} & 0 )    |
                                ({8{OFFSET_SEL1[6 ]}} & 0 )    |
                                ({8{OFFSET_SEL1[7 ]}} & 0 )    |
                                ({8{OFFSET_SEL1[8 ]}} & 0 )    |
                                ({8{OFFSET_SEL1[9 ]}} & 0 )    |
								({8{OFFSET_SEL1[10]}} & 0 )    |
                                ({8{OFFSET_SEL1[11]}} & 0 )    |
                                ({8{OFFSET_SEL1[12]}} & 0 )    |
                                ({8{OFFSET_SEL1[13]}} & 0 )    |
                                ({8{OFFSET_SEL1[14]}} & 0 )    |
								({8{OFFSET_SEL1[15]}} & 0 );

reg         [7:0]   DIN0_D,DIN1_D,DIN2_D,DIN3_D,
					DIN4_D,DIN5_D,DIN6_D,DIN7_D,
					DIN8_D,DIN9_D,DIN10_D,DIN11_D,
					DIN12_D,DIN13_D,DIN14_D,DIN15_D;

assign              I2C_ALERT_L = ~INTERRUPT2 & ~INTERRUPT1 & ~INTERRUPT0;
					
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

//Interrupt bit set and clear
always@(posedge SYSCLK or negedge RESET_N)
	begin
		if(RESET_N == 1'b0)
			begin
			    {INTERRUPT7,INTERRUPT6,INTERRUPT5,INTERRUPT4,
                 INTERRUPT3,INTERRUPT2,INTERRUPT1,INTERRUPT0} <= 8'h0;
				
                {DIN15_D,DIN14_D,DIN13_D,DIN12_D,
				 DIN11_D,DIN10_D,DIN9_D,DIN8_D,
				 DIN7_D,DIN6_D,DIN5_D,DIN4_D,
				 DIN3_D,DIN2_D,DIN1_D,DIN0_D} <= 16'h0;
			end
		else
		    begin
			    INTERRUPT0 <= (DIN0_D ^ DIN0) | (DIN1_D ^ DIN1) ? 1'b1 : (PORT_CS1 & RD_WR1? 1'b0 : INTERRUPT0);
				INTERRUPT1 <= (DIN2_D ^ DIN2) | (DIN3_D ^ DIN3) ? 1'b1 : (PORT_CS1 & RD_WR1? 1'b0 : INTERRUPT1);
				INTERRUPT2 <= (DIN4_D ^ DIN4) | (DIN5_D ^ DIN5) ? 1'b1 : (PORT_CS1 & RD_WR1? 1'b0 : INTERRUPT2);
				 
				{DIN15_D,DIN14_D,DIN13_D,DIN12_D,
				 DIN11_D,DIN10_D,DIN9_D,DIN8_D,
				 DIN7_D,DIN6_D,DIN5_D,DIN4_D,
				 DIN3_D,DIN2_D,DIN1_D,DIN0_D} <= {DIN15,DIN14,DIN13,DIN12,
				                                  DIN11,DIN10,DIN9,DIN8,
				                                  DIN7,DIN6,DIN5,DIN4,
				                                  DIN3,DIN2,DIN1,DIN0};
			end
	end

endmodule
