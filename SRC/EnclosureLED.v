//************************************************************************
//**                          Hattrick      							**
//**                          EnclosureLED.v                            **
//************************************************************************ 

//**********************      ChangeList      *****************************

`include "../SRC/hattrick_define.v"

module EnclosureLED (
            input		SYSCLK,
            input		RESET_N,
            
            input [7:0]	LED_REG,
            
            output		EnclosureLED0,
            output		EnclosureLED1

		);

reg	[24:0]	CNT;
reg         CLK_EnclosureLED;

//EnclosureLED wave output
always@(posedge SYSCLK or negedge RESET_N)
	begin
		if(RESET_N == 1'b0)
			begin
                CNT <= 25'd0;
				CLK_EnclosureLED <= `OFF;
			end
		else
			begin
				CNT <= (CNT<`CLK_FRQ)? (CNT+1'b1) : 0;
				CLK_EnclosureLED <= (CNT == 0) || (CNT == (`CLK_FRQ*9/10))? ~CLK_EnclosureLED : CLK_EnclosureLED;
			end
	end
        
//LED0,LED1
assign		EnclosureLED0 =  LED_REG[3:0] == `PWM   ? CLK_EnclosureLED :
                             LED_REG[3:0] == `LED_ON? `ON              : `OFF;

assign		EnclosureLED1 =  LED_REG[7:4] == `PWM   ? CLK_EnclosureLED :
                             LED_REG[7:4] == `LED_ON? `ON              : `OFF;

endmodule

