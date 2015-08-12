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
// HDD insert
input       HDD4_INSERT_L,HDD3_INSERT_L,HDD2_INSERT_L,HDD1_INSERT_L,
            HDD8_INSERT_L,HDD7_INSERT_L,HDD6_INSERT_L,HDD5_INSERT_L,
            HDD12_INSERT_L,HDD11_INSERT_L,HDD10_INSERT_L,HDD9_INSERT_L,
            HDD15_INSERT_L,HDD14_INSERT_L,HDD13_INSERT_L,
			
output      PWR_EN_HDD4_L,PWR_EN_HDD3_L,PWR_EN_HDD2_L,PWR_EN_HDD1_L,
            PWR_EN_HDD8_L,PWR_EN_HDD7_L,PWR_EN_HDD6_L,PWR_EN_HDD5_L,
            PWR_EN_HDD12_L,PWR_EN_HDD11_L,PWR_EN_HDD10_L,PWR_EN_HDD9_L,
            PWR_EN_HDD15_L,PWR_EN_HDD14_L,PWR_EN_HDD13_L
               );

reg	[7:0]	CNT;
reg         I2C_PWR_EN;

//CNT
always@(posedge CLK_1HZ or negedge RESET_N)
	begin
		if(RESET_N == 1'b0)
			begin
				CNT <= 8'h0;
				I2C_PWR_EN <= 0;
			end
		else
			begin
				CNT <= (CNT < (16 * `SPINUP_DELAY))? (CNT+1'b1) : CNT;
				I2C_PWR_EN <= (CNT < (16 * `SPINUP_DELAY))? 0 : 1'b1;
			end
	end

// assign    	PWR_EN_HDD1_L  = I2C_PWR_EN? PWR_EN_HDD1_L_I2C	: ( CNT <= 1  ? 1 : 1'b0);
// assign    	PWR_EN_HDD2_L  = I2C_PWR_EN? PWR_EN_HDD2_L_I2C	: ( CNT <= 2  ? 1 : 1'b0);
// assign    	PWR_EN_HDD3_L  = I2C_PWR_EN? PWR_EN_HDD3_L_I2C	: ( CNT <= 3  ? 1 : 1'b0);
// assign    	PWR_EN_HDD4_L  = I2C_PWR_EN? PWR_EN_HDD4_L_I2C	: ( CNT <= 4  ? 1 : 1'b0);
// assign    	PWR_EN_HDD5_L  = I2C_PWR_EN? PWR_EN_HDD5_L_I2C	: ( CNT <= 5  ? 1 : 1'b0);
// assign    	PWR_EN_HDD6_L  = I2C_PWR_EN? PWR_EN_HDD6_L_I2C	: ( CNT <= 6  ? 1 : 1'b0);
// assign    	PWR_EN_HDD7_L  = I2C_PWR_EN? PWR_EN_HDD7_L_I2C	: ( CNT <= 7  ? 1 : 1'b0);
// assign    	PWR_EN_HDD8_L  = I2C_PWR_EN? PWR_EN_HDD8_L_I2C	: ( CNT <= 8  ? 1 : 1'b0);
// assign    	PWR_EN_HDD9_L  = I2C_PWR_EN? PWR_EN_HDD9_L_I2C	: ( CNT <= 9  ? 1 : 1'b0);
// assign    	PWR_EN_HDD10_L = I2C_PWR_EN? PWR_EN_HDD10_L_I2C	: ( CNT <= 10 ? 1 : 1'b0);
// assign    	PWR_EN_HDD11_L = I2C_PWR_EN? PWR_EN_HDD11_L_I2C	: ( CNT <= 11 ? 1 : 1'b0);
// assign    	PWR_EN_HDD12_L = I2C_PWR_EN? PWR_EN_HDD12_L_I2C	: ( CNT <= 12 ? 1 : 1'b0);
// assign    	PWR_EN_HDD13_L = I2C_PWR_EN? PWR_EN_HDD13_L_I2C	: ( CNT <= 13 ? 1 : 1'b0);
// assign    	PWR_EN_HDD14_L = I2C_PWR_EN? PWR_EN_HDD14_L_I2C	: ( CNT <= 14 ? 1 : 1'b0);
// assign    	PWR_EN_HDD15_L = I2C_PWR_EN? PWR_EN_HDD15_L_I2C	: ( CNT <= 15 ? 1 : 1'b0);

assign    	PWR_EN_HDD1_L  = ( CNT <= 1  * `SPINUP_DELAY  ) ? 1'b1 : ( PWR_EN_HDD1_L_I2C  || HDD1_INSERT_L  );
assign    	PWR_EN_HDD2_L  = ( CNT <= 2  * `SPINUP_DELAY  ) ? 1'b1 : ( PWR_EN_HDD2_L_I2C  || HDD2_INSERT_L  );
assign    	PWR_EN_HDD3_L  = ( CNT <= 3  * `SPINUP_DELAY  ) ? 1'b1 : ( PWR_EN_HDD3_L_I2C  || HDD3_INSERT_L  );
assign    	PWR_EN_HDD4_L  = ( CNT <= 4  * `SPINUP_DELAY  ) ? 1'b1 : ( PWR_EN_HDD4_L_I2C  || HDD4_INSERT_L  );
assign    	PWR_EN_HDD5_L  = ( CNT <= 5  * `SPINUP_DELAY  ) ? 1'b1 : ( PWR_EN_HDD5_L_I2C  || HDD5_INSERT_L  );
assign    	PWR_EN_HDD6_L  = ( CNT <= 6  * `SPINUP_DELAY  ) ? 1'b1 : ( PWR_EN_HDD6_L_I2C  || HDD6_INSERT_L  );
assign    	PWR_EN_HDD7_L  = ( CNT <= 7  * `SPINUP_DELAY  ) ? 1'b1 : ( PWR_EN_HDD7_L_I2C  || HDD7_INSERT_L  );
assign    	PWR_EN_HDD8_L  = ( CNT <= 8  * `SPINUP_DELAY  ) ? 1'b1 : ( PWR_EN_HDD8_L_I2C  || HDD8_INSERT_L  );
assign    	PWR_EN_HDD9_L  = ( CNT <= 9  * `SPINUP_DELAY  ) ? 1'b1 : ( PWR_EN_HDD9_L_I2C  || HDD9_INSERT_L  );
assign    	PWR_EN_HDD10_L = ( CNT <= 10 * `SPINUP_DELAY  ) ? 1'b1 : ( PWR_EN_HDD10_L_I2C || HDD10_INSERT_L );
assign    	PWR_EN_HDD11_L = ( CNT <= 11 * `SPINUP_DELAY  ) ? 1'b1 : ( PWR_EN_HDD11_L_I2C || HDD11_INSERT_L );
assign    	PWR_EN_HDD12_L = ( CNT <= 12 * `SPINUP_DELAY  ) ? 1'b1 : ( PWR_EN_HDD12_L_I2C || HDD12_INSERT_L );
assign    	PWR_EN_HDD13_L = ( CNT <= 13 * `SPINUP_DELAY  ) ? 1'b1 : ( PWR_EN_HDD13_L_I2C || HDD13_INSERT_L );
assign    	PWR_EN_HDD14_L = ( CNT <= 14 * `SPINUP_DELAY  ) ? 1'b1 : ( PWR_EN_HDD14_L_I2C || HDD14_INSERT_L );
assign    	PWR_EN_HDD15_L = ( CNT <= 15 * `SPINUP_DELAY  ) ? 1'b1 : ( PWR_EN_HDD15_L_I2C || HDD15_INSERT_L );


endmodule
