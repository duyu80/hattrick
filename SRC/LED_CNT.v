//************************************************************************
//**                          Hattrick      							**
//**                          LED_CNT.v									**
//************************************************************************ 

//**********************      ChangeList      *****************************

`include "../SRC/hattrick_define.v"

module LED_CNT (
			SYSCLK,RESET_N,
			CLK_1HZ,CLK_2HZ,CLK_4HZ,
			CLK_4HZ_500MS,CLK_4HZ_3500MS,
			CLK_07S
			);

input		SYSCLK;
input		RESET_N;

output	reg		CLK_1HZ;
output	reg		CLK_2HZ;
output	reg		CLK_4HZ;
output	reg		CLK_4HZ_500MS;
output	reg		CLK_4HZ_3500MS;
output	reg		CLK_07S;

reg	[24:0]	CNT;
reg	[24:0]	CNT_500MS;
reg	[26:0]	CNT_3500MS;
reg	[26:0]	CNT_07S;

//1HZ 2HZ 4HZ wave output
always@(posedge SYSCLK or negedge RESET_N)
	begin
		if(RESET_N == 1'b0)
			begin
				CLK_1HZ <= `OFF;
				CLK_2HZ <= `OFF;
				CLK_4HZ <= `OFF;
				CNT <= 25'd0;
			end
		else
			begin
				CNT <= (CNT<`CLK_FRQ)? (CNT+1'b1) : 0;
				CLK_1HZ <= ((CNT == 0) | (CNT == `CLK_FRQ/2))? ~CLK_1HZ : CLK_1HZ;
				CLK_2HZ <= ((CNT == `CLK_FRQ/4) | (CNT == `CLK_FRQ/2) | (CNT == `CLK_FRQ*3/4) | (CNT == `CLK_FRQ))? ~CLK_2HZ : CLK_2HZ;
				CLK_4HZ <= ((CNT == `CLK_FRQ/8) | (CNT == `CLK_FRQ/4) | (CNT == `CLK_FRQ*3/8) | (CNT == `CLK_FRQ/2) | 
					(CNT == `CLK_FRQ*5/8) | (CNT == `CLK_FRQ*3/4) | (CNT == `CLK_FRQ*7/8) | (CNT == `CLK_FRQ))? ~CLK_4HZ : CLK_4HZ;
			end
	end
		
//4HZ 500MS AND 4HZ 3500MS
always@(posedge SYSCLK or negedge RESET_N)
	begin
		if(RESET_N == 1'b0)
			begin
				CLK_4HZ_500MS <= `OFF;
				CLK_4HZ_3500MS <= `OFF;
				CNT_500MS <= 25'd0;
				CNT_3500MS <= 27'd0;
			end
		else
			begin
				CLK_4HZ_500MS <= ((CNT_500MS == `CLK_FRQ/8) | (CNT_500MS == `CLK_FRQ/4) | (CNT_500MS == `CLK_FRQ*3/8)
					| (CNT_500MS == `CLK_FRQ/2) | (CNT_500MS == `CLK_FRQ*5/8))? ~CLK_4HZ_500MS : CLK_4HZ_500MS;
				CLK_4HZ_3500MS <= ((CNT_3500MS == `CLK_FRQ/8) | (CNT_3500MS == `CLK_FRQ/4) 
					| (CNT_3500MS == `CLK_FRQ*3/8) | (CNT_3500MS == `CLK_FRQ/2) | (CNT_3500MS == `CLK_FRQ*5/8))? ~CLK_4HZ_3500MS : CLK_4HZ_3500MS;
				CNT_500MS <=  (CNT_500MS <`CLK_FRQ)? (CNT_500MS+1'b1) : 0;
				CNT_3500MS <= (CNT_3500MS < `CLK_FRQ*4)? (CNT_3500MS+1'b1) : 0;
			end
	end

//0.7S repeat wave
always@(posedge SYSCLK or negedge RESET_N)
	begin
		if(RESET_N == 1'b0)
			begin
				CLK_07S <= `OFF;
				CNT_07S <= 27'd0;
			end
		else
			begin
				CLK_07S <= (CNT_07S ==(`CLK_FRQ/10*7))? ~CLK_07S : CLK_07S;
				//CLK_07S <= (CNT_07S ==27'd7350000)? ~CLK_07S : CLK_07S;
				CNT_07S <=  (CNT_07S <(`CLK_FRQ/10*7))? (CNT_07S+1'b1) : 0;
				//CNT_07S <=  (CNT_07S ==27'd7350000)? (CNT_07S+1'b1) : 0;
			end
	end

endmodule
