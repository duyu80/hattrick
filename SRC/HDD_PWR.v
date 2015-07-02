//************************************************************************
//**                          Hattrick      							**
//**                          HDD_PWR.v									**
//************************************************************************ 

//**********************      ChangeList      *****************************

`include "../SRC/hattrick_define.v"

module HDD_PWR (
input		SYSCLK,
input		RESET_N,

input       CLK_1HZ,
// HDD power enable
input       PWR_EN_HDD4_L_I2C,PWR_EN_HDD3_L_I2C,PWR_EN_HDD2_L_I2C,PWR_EN_HDD1_L_I2C,
            PWR_EN_HDD8_L_I2C,PWR_EN_HDD7_L_I2C,PWR_EN_HDD6_L_I2C,PWR_EN_HDD5_L_I2C,
            PWR_EN_HDD12_L_I2C,PWR_EN_HDD11_L_I2C,PWR_EN_HDD10_L_I2C,PWR_EN_HDD9_L_I2C,
            PWR_EN_HDD15_L_I2C,PWR_EN_HDD14_L_I2C,PWR_EN_HDD13_L_I2C,
			
output      PWR_EN_HDD4_L,PWR_EN_HDD3_L,PWR_EN_HDD2_L,PWR_EN_HDD1_L,
            PWR_EN_HDD8_L,PWR_EN_HDD7_L,PWR_EN_HDD6_L,PWR_EN_HDD5_L,
            PWR_EN_HDD12_L,PWR_EN_HDD11_L,PWR_EN_HDD10_L,PWR_EN_HDD9_L,
            PWR_EN_HDD15_L,PWR_EN_HDD14_L,PWR_EN_HDD13_L
			
               );

reg	[4:0]	CNT;
reg         I2C_PWR_EN;

//CNT
always@(posedge CLK_1HZ or negedge RESET_N)
	begin
		if(RESET_N == 1'b0)
			begin
				CNT <= 5'h0;
				I2C_PWR_EN <= 0;
			end
		else
			begin
				CNT <= (CNT < 5'd16)? (CNT+1'b1) : CNT;
				I2C_PWR_EN <= (CNT < 5'd16)? 0 : 1'b1;
			end
	end

assign    	PWR_EN_HDD1_L  = I2C_PWR_EN? PWR_EN_HDD1_L_I2C	: ( CNT <= 1  ? 1 : 1'b0);
assign    	PWR_EN_HDD2_L  = I2C_PWR_EN? PWR_EN_HDD2_L_I2C	: ( CNT <= 2  ? 1 : 1'b0);
assign    	PWR_EN_HDD3_L  = I2C_PWR_EN? PWR_EN_HDD3_L_I2C	: ( CNT <= 3  ? 1 : 1'b0);
assign    	PWR_EN_HDD4_L  = I2C_PWR_EN? PWR_EN_HDD4_L_I2C	: ( CNT <= 4  ? 1 : 1'b0);
assign    	PWR_EN_HDD5_L  = I2C_PWR_EN? PWR_EN_HDD5_L_I2C	: ( CNT <= 5  ? 1 : 1'b0);
assign    	PWR_EN_HDD6_L  = I2C_PWR_EN? PWR_EN_HDD6_L_I2C	: ( CNT <= 6  ? 1 : 1'b0);
assign    	PWR_EN_HDD7_L  = I2C_PWR_EN? PWR_EN_HDD7_L_I2C	: ( CNT <= 7  ? 1 : 1'b0);
assign    	PWR_EN_HDD8_L  = I2C_PWR_EN? PWR_EN_HDD8_L_I2C	: ( CNT <= 8  ? 1 : 1'b0);
assign    	PWR_EN_HDD9_L  = I2C_PWR_EN? PWR_EN_HDD9_L_I2C	: ( CNT <= 9  ? 1 : 1'b0);
assign    	PWR_EN_HDD10_L = I2C_PWR_EN? PWR_EN_HDD10_L_I2C	: ( CNT <= 10 ? 1 : 1'b0);
assign    	PWR_EN_HDD11_L = I2C_PWR_EN? PWR_EN_HDD11_L_I2C	: ( CNT <= 11 ? 1 : 1'b0);
assign    	PWR_EN_HDD12_L = I2C_PWR_EN? PWR_EN_HDD12_L_I2C	: ( CNT <= 12 ? 1 : 1'b0);
assign    	PWR_EN_HDD13_L = I2C_PWR_EN? PWR_EN_HDD13_L_I2C	: ( CNT <= 13 ? 1 : 1'b0);
assign    	PWR_EN_HDD14_L = I2C_PWR_EN? PWR_EN_HDD14_L_I2C	: ( CNT <= 14 ? 1 : 1'b0);
assign    	PWR_EN_HDD15_L = I2C_PWR_EN? PWR_EN_HDD15_L_I2C	: ( CNT <= 15 ? 1 : 1'b0);


endmodule
