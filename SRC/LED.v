//************************************************************************
//**                          Hattrick      							**
//**                          LED.v										**
//************************************************************************ 

//**********************      ChangeList      *****************************

`include "../SRC/hattrick_define.v"

module LED (
            input		SYSCLK,
            input		RESET_N,
            
            input		CLK_1HZ,
            input		CLK_2HZ,
            input		CLK_4HZ,
            input		CLK_4HZ_500MS,
            input		CLK_4HZ_3500MS,
            input		CLK_07S,
            
            input [7:0]	LED_REG0,
            input [7:0]	LED_REG1,
            input [7:0]	LED_REG2,
            input [7:0]	LED_REG3,
            input [7:0]	LED_REG4,
            input [7:0]	LED_REG5,
            input [7:0]	LED_REG6,
            input [7:0]	LED_REG7,
            
            output		LED0,
            output		LED1,
            output		LED2,
            output		LED3,
            output		LED4,
            output		LED5,
            output		LED6,
            output		LED7,
            
            output		LED8,
            output		LED9,
            output		LED10,
            output		LED11,
            output		LED12,
            output		LED13,
            output		LED14,
            output		LED15
		);

//LED0,LED1
assign		LED0 =  (LED_REG0[3:0] == `LED_OFF)? `OFF : ((LED_REG0[3:0] == `BLK_1HZ)? CLK_1HZ : ((LED_REG0[3:0] == `BLK_2HZ)? CLK_2HZ : 
				((LED_REG0[3:0] == `BLK_4HZ)? CLK_4HZ : ((LED_REG0[3:0] == `BLK_05S)? CLK_4HZ_500MS : ( (LED_REG0[3:0] == `BLK_35S)? CLK_4HZ_3500MS : 
					( (LED_REG0[3:0] == `LED_ON)? `ON : ((LED_REG0[3:0] == `BLK_07S)? CLK_07S : `OFF)))))));
assign		LED1 =  (LED_REG0[7:4] == `LED_OFF)? `OFF : ((LED_REG0[7:4] == `BLK_1HZ)? CLK_1HZ : ((LED_REG0[7:4] == `BLK_2HZ)? CLK_2HZ : 
				((LED_REG0[7:4] == `BLK_4HZ)? CLK_4HZ : ((LED_REG0[7:4] == `BLK_05S)? CLK_4HZ_500MS : ( (LED_REG0[7:4] == `BLK_35S)? CLK_4HZ_3500MS : 
					( (LED_REG0[7:4] == `LED_ON)? `ON : ((LED_REG0[7:4] == `BLK_07S)? CLK_07S : `OFF)))))));
//LED2,LED3
assign		LED2 =  (LED_REG1[3:0] == `LED_OFF)? `OFF : ((LED_REG1[3:0] == `BLK_1HZ)? CLK_1HZ : ((LED_REG1[3:0] == `BLK_2HZ)? CLK_2HZ : 
				((LED_REG1[3:0] == `BLK_4HZ)? CLK_4HZ : ((LED_REG1[3:0] == `BLK_05S)? CLK_4HZ_500MS : ( (LED_REG1[3:0] == `BLK_35S)? CLK_4HZ_3500MS : 
					( (LED_REG1[3:0] == `LED_ON)? `ON : ((LED_REG1[3:0] == `BLK_07S)? CLK_07S : `OFF)))))));
assign		LED3 =  (LED_REG1[7:4] == `LED_OFF)? `OFF : ((LED_REG1[7:4] == `BLK_1HZ)? CLK_1HZ : ((LED_REG1[7:4] == `BLK_2HZ)? CLK_2HZ : 
				((LED_REG1[7:4] == `BLK_4HZ)? CLK_4HZ : ((LED_REG1[7:4] == `BLK_05S)? CLK_4HZ_500MS : ( (LED_REG1[7:4] == `BLK_35S)? CLK_4HZ_3500MS : 
					( (LED_REG1[7:4] == `LED_ON)? `ON : ((LED_REG1[7:4] == `BLK_07S)? CLK_07S : `OFF)))))));
//LED4,LED5
assign		LED4 =  (LED_REG2[3:0] == `LED_OFF)? `OFF : ((LED_REG2[3:0] == `BLK_1HZ)? CLK_1HZ : ((LED_REG2[3:0] == `BLK_2HZ)? CLK_2HZ : 
				((LED_REG2[3:0] == `BLK_4HZ)? CLK_4HZ : ((LED_REG2[3:0] == `BLK_05S)? CLK_4HZ_500MS : ( (LED_REG2[3:0] == `BLK_35S)? CLK_4HZ_3500MS : 
					( (LED_REG2[3:0] == `LED_ON)? `ON : ((LED_REG2[3:0] == `BLK_07S)? CLK_07S : `OFF)))))));
assign		LED5 =  (LED_REG2[7:4] == `LED_OFF)? `OFF : ((LED_REG2[7:4] == `BLK_1HZ)? CLK_1HZ : ((LED_REG2[7:4] == `BLK_2HZ)? CLK_2HZ : 
				((LED_REG2[7:4] == `BLK_4HZ)? CLK_4HZ : ((LED_REG2[7:4] == `BLK_05S)? CLK_4HZ_500MS : ( (LED_REG2[7:4] == `BLK_35S)? CLK_4HZ_3500MS : 
					( (LED_REG2[7:4] == `LED_ON)? `ON : ((LED_REG2[7:4] == `BLK_07S)? CLK_07S : `OFF)))))));
//LED6.LED7
assign		LED6 =  (LED_REG3[3:0] == `LED_OFF)? `OFF : ((LED_REG3[3:0] == `BLK_1HZ)? CLK_1HZ : ((LED_REG3[3:0] == `BLK_2HZ)? CLK_2HZ : 
				((LED_REG3[3:0] == `BLK_4HZ)? CLK_4HZ : ((LED_REG3[3:0] == `BLK_05S)? CLK_4HZ_500MS : ( (LED_REG3[3:0] == `BLK_35S)? CLK_4HZ_3500MS : 
					( (LED_REG3[3:0] == `LED_ON)? `ON : ((LED_REG3[3:0] == `BLK_07S)? CLK_07S : `OFF)))))));
assign		LED7 =  (LED_REG3[7:4] == `LED_OFF)? `OFF : ((LED_REG3[7:4] == `BLK_1HZ)? CLK_1HZ : ((LED_REG3[7:4] == `BLK_2HZ)? CLK_2HZ : 
				((LED_REG3[7:4] == `BLK_4HZ)? CLK_4HZ : ((LED_REG3[7:4] == `BLK_05S)? CLK_4HZ_500MS : ( (LED_REG3[7:4] == `BLK_35S)? CLK_4HZ_3500MS : 
					( (LED_REG3[7:4] == `LED_ON)? `ON : ((LED_REG3[7:4] == `BLK_07S)? CLK_07S : `OFF)))))));
//LED8,LED9
assign		LED8 =  (LED_REG4[3:0] == `LED_OFF)? `OFF : ((LED_REG4[3:0] == `BLK_1HZ)? CLK_1HZ : ((LED_REG4[3:0] == `BLK_2HZ)? CLK_2HZ : 
				((LED_REG4[3:0] == `BLK_4HZ)? CLK_4HZ : ((LED_REG4[3:0] == `BLK_05S)? CLK_4HZ_500MS : ( (LED_REG4[3:0] == `BLK_35S)? CLK_4HZ_3500MS : 
					( (LED_REG4[3:0] == `LED_ON)? `ON : ((LED_REG4[3:0] == `BLK_07S)? CLK_07S : `OFF)))))));
assign		LED9 =  (LED_REG4[7:4] == `LED_OFF)? `OFF : ((LED_REG4[7:4] == `BLK_1HZ)? CLK_1HZ : ((LED_REG4[7:4] == `BLK_2HZ)? CLK_2HZ : 
				((LED_REG4[7:4] == `BLK_4HZ)? CLK_4HZ : ((LED_REG4[7:4] == `BLK_05S)? CLK_4HZ_500MS : ( (LED_REG4[7:4] == `BLK_35S)? CLK_4HZ_3500MS : 
					( (LED_REG4[7:4] == `LED_ON)? `ON : ((LED_REG4[7:4] == `BLK_07S)? CLK_07S : `OFF)))))));
//LED10,LED11
assign		LED10 =  (LED_REG5[3:0] == `LED_OFF)? `OFF : ((LED_REG5[3:0] == `BLK_1HZ)? CLK_1HZ : ((LED_REG5[3:0] == `BLK_2HZ)? CLK_2HZ : 
				((LED_REG5[3:0] == `BLK_4HZ)? CLK_4HZ : ((LED_REG5[3:0] == `BLK_05S)? CLK_4HZ_500MS : ( (LED_REG5[3:0] == `BLK_35S)? CLK_4HZ_3500MS : 
					( (LED_REG5[3:0] == `LED_ON)? `ON : ((LED_REG5[3:0] == `BLK_07S)? CLK_07S : `OFF)))))));
assign		LED11 =  (LED_REG5[7:4] == `LED_OFF)? `OFF : ((LED_REG5[7:4] == `BLK_1HZ)? CLK_1HZ : ((LED_REG5[7:4] == `BLK_2HZ)? CLK_2HZ : 
				((LED_REG5[7:4] == `BLK_4HZ)? CLK_4HZ : ((LED_REG5[7:4] == `BLK_05S)? CLK_4HZ_500MS : ( (LED_REG5[7:4] == `BLK_35S)? CLK_4HZ_3500MS : 
					( (LED_REG5[7:4] == `LED_ON)? `ON : ((LED_REG5[7:4] == `BLK_07S)? CLK_07S : `OFF)))))));
//LED12,LED13
assign		LED12 =  (LED_REG6[3:0] == `LED_OFF)? `OFF : ((LED_REG6[3:0] == `BLK_1HZ)? CLK_1HZ : ((LED_REG6[3:0] == `BLK_2HZ)? CLK_2HZ : 
				((LED_REG6[3:0] == `BLK_4HZ)? CLK_4HZ : ((LED_REG6[3:0] == `BLK_05S)? CLK_4HZ_500MS : ( (LED_REG6[3:0] == `BLK_35S)? CLK_4HZ_3500MS : 
					( (LED_REG6[3:0] == `LED_ON)? `ON : ((LED_REG6[3:0] == `BLK_07S)? CLK_07S : `OFF)))))));
assign		LED13 =  (LED_REG6[7:4] == `LED_OFF)? `OFF : ((LED_REG6[7:4] == `BLK_1HZ)? CLK_1HZ : ((LED_REG6[7:4] == `BLK_2HZ)? CLK_2HZ : 
				((LED_REG6[7:4] == `BLK_4HZ)? CLK_4HZ : ((LED_REG6[7:4] == `BLK_05S)? CLK_4HZ_500MS : ( (LED_REG6[7:4] == `BLK_35S)? CLK_4HZ_3500MS : 
					( (LED_REG6[7:4] == `LED_ON)? `ON : ((LED_REG6[7:4] == `BLK_07S)? CLK_07S : `OFF)))))));
//LED14,LED15
assign		LED14 =  (LED_REG7[3:0] == `LED_OFF)? `OFF : ((LED_REG7[3:0] == `BLK_1HZ)? CLK_1HZ : ((LED_REG7[3:0] == `BLK_2HZ)? CLK_2HZ : 
				((LED_REG7[3:0] == `BLK_4HZ)? CLK_4HZ : ((LED_REG7[3:0] == `BLK_05S)? CLK_4HZ_500MS : ( (LED_REG7[3:0] == `BLK_35S)? CLK_4HZ_3500MS : 
					( (LED_REG7[3:0] == `LED_ON)? `ON : ((LED_REG7[3:0] == `BLK_07S)? CLK_07S : `OFF)))))));
assign		LED15 =  (LED_REG7[7:4] == `LED_OFF)? `OFF : ((LED_REG7[7:4] == `BLK_1HZ)? CLK_1HZ : ((LED_REG7[7:4] == `BLK_2HZ)? CLK_2HZ : 
				((LED_REG7[7:4] == `BLK_4HZ)? CLK_4HZ : ((LED_REG7[7:4] == `BLK_05S)? CLK_4HZ_500MS : ( (LED_REG7[7:4] == `BLK_35S)? CLK_4HZ_3500MS : 
					( (LED_REG7[7:4] == `LED_ON)? `ON : ((LED_REG7[7:4] == `BLK_07S)? CLK_07S : `OFF)))))));
endmodule

