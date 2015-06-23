`include "../SRC/hattrick_define.v"
`include "i2c_master_defines.v"

module tb_hattrick;

wire	[7:0]		i;
reg			    clk;
reg			    rstn;
reg			    i2c_wr;
reg	[7:0]	    i2c_address;
reg	[7:0]	    i2c_wrdata1;
reg	[7:0]	    i2c_wrdata2;
reg	[7:0]	    i2c_wrdata3;
reg	[7:0]	    i2c_data_num;

reg [16*8-1:0]  test;

wire	[2:0]	adr;
wire	[7:0]	dat_o;
wire	[7:0]	dat0_i;
wire			cyc;
wire			stb;
wire			we;
wire			ack;

wire			scl;
wire			sda;

wire	[7:0]	porta;
wire	[7:0]	portb;
wire	[15:0]	PORT_CS;
wire	[15:0]	OFFSET_SEL;    //This two signal port are used for GPIO port selection
wire	[7:0]	I2C_DOUT;    //When write through I2C, the output data will through these two port to each GPIO port
wire			RD_WR;    //1 means I2C read operation, and 0 means I2C write operation
wire	[7:0]	DIN_0;

wire			i2c_busy;
wire	[7:0]	i2c_rddata1;
wire	[7:0]	i2c_rddata2;
wire	[7:0]	i2c_rddata3;

pullup p1(scl); // pullup scl line
pullup p2(sda); // pullup sda line

// HDD insert
reg       HDD4_INSERT_L,HDD3_INSERT_L,HDD2_INSERT_L,HDD1_INSERT_L,
		  HDD8_INSERT_L,HDD7_INSERT_L,HDD6_INSERT_L,HDD5_INSERT_L,
		  HDD12_INSERT_L,HDD11_INSERT_L,HDD10_INSERT_L,HDD9_INSERT_L,
						 HDD15_INSERT_L,HDD14_INSERT_L,HDD13_INSERT_L;
// 5v power good
reg       P5V_GD_HDD4,P5V_GD_HDD3,P5V_GD_HDD2,P5V_GD_HDD1,
		  P5V_GD_HDD8,P5V_GD_HDD7,P5V_GD_HDD6,P5V_GD_HDD5,
		  P5V_GD_HDD12,P5V_GD_HDD11,P5V_GD_HDD10,P5V_GD_HDD9,
					   P5V_GD_HDD15,P5V_GD_HDD14,P5V_GD_HDD13;
// 12v power good
reg       P12V_GD_HDD4,P12V_GD_HDD3,P12V_GD_HDD2,P12V_GD_HDD1,
		  P12V_GD_HDD8,P12V_GD_HDD7,P12V_GD_HDD6,P12V_GD_HDD5,
		  P12V_GD_HDD12,P12V_GD_HDD11,P12V_GD_HDD10,P12V_GD_HDD9,
					   P12V_GD_HDD15,P12V_GD_HDD14,P12V_GD_HDD13;
// HDD power enable
wire      PWR_EN_HDD4_L,PWR_EN_HDD3_L,PWR_EN_HDD2_L,PWR_EN_HDD1_L,
		  PWR_EN_HDD8_L,PWR_EN_HDD7_L,PWR_EN_HDD6_L,PWR_EN_HDD5_L,
		  PWR_EN_HDD12_L,PWR_EN_HDD11_L,PWR_EN_HDD10_L,PWR_EN_HDD9_L,
					   PWR_EN_HDD15_L,PWR_EN_HDD14_L,PWR_EN_HDD13_L;
// HDD health led
wire      HDD4_Health_LED,HDD3_Health_LED,HDD2_Health_LED,HDD1_Health_LED,
		  HDD8_Health_LED,HDD7_Health_LED,HDD6_Health_LED,HDD5_Health_LED,
		  HDD12_Health_LED,HDD11_Health_LED,HDD10_Health_LED,HDD9_Health_LED,
						 HDD15_Health_LED,HDD14_Health_LED,HDD13_Health_LED;
// HDD fault led
wire      HDD4_FAULT_LED,HDD3_FAULT_LED,HDD2_FAULT_LED,HDD1_FAULT_LED,
		  HDD8_FAULT_LED,HDD7_FAULT_LED,HDD6_FAULT_LED,HDD5_FAULT_LED,
		  HDD12_FAULT_LED,HDD11_FAULT_LED,HDD10_FAULT_LED,HDD9_FAULT_LED,
						 HDD15_FAULT_LED,HDD14_FAULT_LED,HDD13_FAULT_LED;
// MINI SAS
reg       A_MODPRESL,A_INTL,A_VACT_OC_L;
wire      A_VMAN_EN_L,A_VACT_EN_L;
wire      A_HEALTH_LED_L,A_FAULT_LED;
reg       B_MODPRESL,B_INTL,B_VACT_OC_L;
wire      B_VMAN_EN_L,B_VACT_EN_L;
wire      B_HEALTH_LED_L,B_FAULT_LED;
// Enclosure led
wire      ENCLOSURE_HEALTH_LED_L;
wire      ENCLOSURE_FAULT_LED;
// hardware revision
reg       Sideplane_REV_ID1,Sideplane_REV_ID0;

wb_master #(8, 8) u0 (
		.clk(clk),
		.rst(rstn),
		.adr(adr),
		.din(dat0_i),
		.dout(dat_o),
		.cyc(cyc),
		.stb(stb),
		.we(we),
		.sel(),
		.ack(ack),
		.err(1'b0),
		.rty(1'b0),
		.i2c_wr(i2c_wr),
		.i2c_addr(i2c_address),
		.i2c_wrdata1( i2c_wrdata1),
		.i2c_wrdata2( i2c_wrdata2),
		.i2c_wrdata3( i2c_wrdata3),
		.i2c_data_num(i2c_data_num),
		.i2c_busy(i2c_busy),
		.i2c_rddata1(i2c_rddata1),
		.i2c_rddata2(i2c_rddata2),
		.i2c_rddata3(i2c_rddata3)
	);

i2c_master_wb_top u1 (

		// wishbone interface
		.wb_clk_i(clk),
		.wb_rst_i(1'b0),
		.arst_i(rstn),
		.wb_adr_i(adr[2:0]),
		.wb_dat_i(dat_o),
		.wb_dat_o(dat0_i),
		.wb_we_i(we),
		.wb_stb_i(stb),
		.wb_cyc_i(cyc),
		.wb_ack_o(ack),
		.wb_inta_o(),

		.scl(scl),
		.sda(sda)
	);


HATTRICK_TOP		HATTRICK_TOP_INST (
				.SYSCLK                         ( clk ),
				.RESET_N                        ( rstn),
				.SCL			                ( scl ),
				.SDA			                ( sda ),

                .HDD1_INSERT_L                ( HDD1_INSERT_L ),
                .HDD2_INSERT_L                ( HDD2_INSERT_L ),
                .HDD3_INSERT_L                ( HDD3_INSERT_L ),
                .HDD4_INSERT_L                ( HDD4_INSERT_L ),
                .HDD5_INSERT_L                ( HDD5_INSERT_L ),
                .HDD6_INSERT_L                ( HDD6_INSERT_L ),
                .HDD7_INSERT_L                ( HDD7_INSERT_L ),
                .HDD8_INSERT_L                ( HDD8_INSERT_L ),
                .HDD9_INSERT_L                ( HDD9_INSERT_L ),
                .HDD10_INSERT_L                ( HDD10_INSERT_L ),
                .HDD11_INSERT_L                ( HDD11_INSERT_L ),
                .HDD12_INSERT_L                ( HDD12_INSERT_L ),
                .HDD13_INSERT_L                ( HDD13_INSERT_L ),
                .HDD14_INSERT_L                ( HDD14_INSERT_L ),
                .HDD15_INSERT_L                ( HDD15_INSERT_L ),

                .P5V_GD_HDD1                  ( P5V_GD_HDD1 ),
                .P5V_GD_HDD2                  ( P5V_GD_HDD2 ),
                .P5V_GD_HDD3                  ( P5V_GD_HDD3 ),
                .P5V_GD_HDD4                  ( P5V_GD_HDD4 ),
                .P5V_GD_HDD5                  ( P5V_GD_HDD5 ),
                .P5V_GD_HDD6                  ( P5V_GD_HDD6 ),
                .P5V_GD_HDD7                  ( P5V_GD_HDD7 ),
                .P5V_GD_HDD8                  ( P5V_GD_HDD8 ),
                .P5V_GD_HDD9                  ( P5V_GD_HDD9 ),
                .P5V_GD_HDD10                  ( P5V_GD_HDD10 ),
                .P5V_GD_HDD11                  ( P5V_GD_HDD11 ),
                .P5V_GD_HDD12                  ( P5V_GD_HDD12 ),
                .P5V_GD_HDD13                  ( P5V_GD_HDD13 ),
                .P5V_GD_HDD14                  ( P5V_GD_HDD14 ),
                .P5V_GD_HDD15                  ( P5V_GD_HDD15 ),

                .P12V_GD_HDD1                 ( P12V_GD_HDD1 ),
                .P12V_GD_HDD2                 ( P12V_GD_HDD2 ),
                .P12V_GD_HDD3                 ( P12V_GD_HDD3 ),
                .P12V_GD_HDD4                 ( P12V_GD_HDD4 ),
                .P12V_GD_HDD5                 ( P12V_GD_HDD5 ),
                .P12V_GD_HDD6                 ( P12V_GD_HDD6 ),
                .P12V_GD_HDD7                 ( P12V_GD_HDD7 ),
                .P12V_GD_HDD8                 ( P12V_GD_HDD8 ),
                .P12V_GD_HDD9                 ( P12V_GD_HDD9 ),
                .P12V_GD_HDD10                 ( P12V_GD_HDD10 ),
                .P12V_GD_HDD11                 ( P12V_GD_HDD11 ),
                .P12V_GD_HDD12                 ( P12V_GD_HDD12 ),
                .P12V_GD_HDD13                 ( P12V_GD_HDD13 ),
                .P12V_GD_HDD14                 ( P12V_GD_HDD14 ),
                .P12V_GD_HDD15                 ( P12V_GD_HDD15 ),

                .PWR_EN_HDD1_L                ( PWR_EN_HDD1_L ),
                .PWR_EN_HDD2_L                ( PWR_EN_HDD2_L ),
                .PWR_EN_HDD3_L                ( PWR_EN_HDD3_L ),
                .PWR_EN_HDD4_L                ( PWR_EN_HDD4_L ),
                .PWR_EN_HDD5_L                ( PWR_EN_HDD5_L ),
                .PWR_EN_HDD6_L                ( PWR_EN_HDD6_L ),
                .PWR_EN_HDD7_L                ( PWR_EN_HDD7_L ),
                .PWR_EN_HDD8_L                ( PWR_EN_HDD8_L ),
                .PWR_EN_HDD9_L                ( PWR_EN_HDD9_L ),
                .PWR_EN_HDD10_L                ( PWR_EN_HDD10_L ),
                .PWR_EN_HDD11_L                ( PWR_EN_HDD11_L ),
                .PWR_EN_HDD12_L                ( PWR_EN_HDD12_L ),
                .PWR_EN_HDD13_L                ( PWR_EN_HDD13_L ),
                .PWR_EN_HDD14_L                ( PWR_EN_HDD14_L ),
                .PWR_EN_HDD15_L                ( PWR_EN_HDD15_L ),

                .HDD1_Health_LED              ( HDD1_Health_LED ),
                .HDD2_Health_LED              ( HDD2_Health_LED ),
                .HDD3_Health_LED              ( HDD3_Health_LED ),
                .HDD4_Health_LED              ( HDD4_Health_LED ),
                .HDD5_Health_LED              ( HDD5_Health_LED ),
                .HDD6_Health_LED              ( HDD6_Health_LED ),
                .HDD7_Health_LED              ( HDD7_Health_LED ),
                .HDD8_Health_LED              ( HDD8_Health_LED ),
                .HDD9_Health_LED              ( HDD9_Health_LED ),
                .HDD10_Health_LED              ( HDD10_Health_LED ),
                .HDD11_Health_LED              ( HDD11_Health_LED ),
                .HDD12_Health_LED              ( HDD12_Health_LED ),
                .HDD13_Health_LED              ( HDD13_Health_LED ),
                .HDD14_Health_LED              ( HDD14_Health_LED ),
                .HDD15_Health_LED              ( HDD15_Health_LED ),

                .HDD1_FAULT_LED               ( HDD1_FAULT_LED ),
                .HDD2_FAULT_LED               ( HDD2_FAULT_LED ),
                .HDD3_FAULT_LED               ( HDD3_FAULT_LED ),
                .HDD4_FAULT_LED               ( HDD4_FAULT_LED ),
                .HDD5_FAULT_LED               ( HDD5_FAULT_LED ),
                .HDD6_FAULT_LED               ( HDD6_FAULT_LED ),
                .HDD7_FAULT_LED               ( HDD7_FAULT_LED ),
                .HDD8_FAULT_LED               ( HDD8_FAULT_LED ),
                .HDD9_FAULT_LED               ( HDD9_FAULT_LED ),
                .HDD10_FAULT_LED               ( HDD10_FAULT_LED ),
                .HDD11_FAULT_LED               ( HDD11_FAULT_LED ),
                .HDD12_FAULT_LED               ( HDD12_FAULT_LED ),
                .HDD13_FAULT_LED               ( HDD13_FAULT_LED ),
                .HDD14_FAULT_LED               ( HDD14_FAULT_LED ),
                .HDD15_FAULT_LED               ( HDD15_FAULT_LED ),
                .A_MODPRESL                      ( A_MODPRESL     ),
				.A_INTL                          ( A_INTL         ),
				.A_VACT_OC_L                     ( A_VACT_OC_L    ),
				.A_VACT_EN_L                     ( A_VACT_EN_L    ),
				.A_VMAN_EN_L                     ( A_VMAN_EN_L    ),
				.A_FAULT_LED                     ( A_FAULT_LED    ),
				.A_HEALTH_LED_L                  ( A_HEALTH_LED_L ),
                .B_MODPRESL                      ( B_MODPRESL     ),
				.B_INTL                          ( B_INTL         ),
				.B_VACT_OC_L                     ( B_VACT_OC_L    ),
				.B_VACT_EN_L                     ( B_VACT_EN_L    ),
				.B_VMAN_EN_L                     ( B_VMAN_EN_L    ),
				.B_FAULT_LED                     ( B_FAULT_LED    ),
				.B_HEALTH_LED_L                  ( B_HEALTH_LED_L ),
				
				.ENCLOSURE_HEALTH_LED_L          ( ENCLOSURE_HEALTH_LED_L ),
				.ENCLOSURE_FAULT_LED             ( ENCLOSURE_FAULT_LED    ),
				.Sideplane_REV_ID0               ( Sideplane_REV_ID0      ),
				.Sideplane_REV_ID1               ( Sideplane_REV_ID1      )
				
				);

always	#20   clk       = ~clk;

	
initial
	begin
        #0
        clk          = 0;
        rstn         = 0;
        i2c_wr       = 1;
		test         = "Begin Test";

        repeat (1000) @(posedge clk);
		
		{HDD15_INSERT_L,HDD14_INSERT_L,HDD13_INSERT_L,
		HDD12_INSERT_L,HDD11_INSERT_L,HDD10_INSERT_L,HDD9_INSERT_L,
		HDD8_INSERT_L,HDD7_INSERT_L,HDD6_INSERT_L,HDD5_INSERT_L,
		HDD4_INSERT_L,HDD3_INSERT_L,HDD2_INSERT_L,HDD1_INSERT_L} = 15'h5123;

		{P5V_GD_HDD15,P5V_GD_HDD14,P5V_GD_HDD13,
		P5V_GD_HDD12,P5V_GD_HDD11,P5V_GD_HDD10,P5V_GD_HDD9,
		P5V_GD_HDD8,P5V_GD_HDD7,P5V_GD_HDD6,P5V_GD_HDD5,
		P5V_GD_HDD4,P5V_GD_HDD3,P5V_GD_HDD2,P5V_GD_HDD1} = 15'h7234;
		  
        {P12V_GD_HDD15,P12V_GD_HDD14,P12V_GD_HDD13,
		P12V_GD_HDD12,P12V_GD_HDD11,P12V_GD_HDD10,P12V_GD_HDD9,
		P12V_GD_HDD8,P12V_GD_HDD7,P12V_GD_HDD6,P12V_GD_HDD5,
		P12V_GD_HDD4,P12V_GD_HDD3,P12V_GD_HDD2,P12V_GD_HDD1} = 15'h5567;
		
		repeat (1000) @(posedge clk);
		
		rstn = 1;
		
        test = "HEADER_TEST";
		HEADER_TEST();
		repeat (1000) @(posedge clk);
		
		//LED_TEST
		// test = "LED_TEST";
		// LED_TEST();
		// repeat (1000) @(posedge clk);
		
		//PRESENT TEST
		// test = "PRESENT TEST";
		// PRESENT_TEST();
		// repeat (1000) @(posedge clk);
		
		$display("*************************************************************************");
		$display("***********************     ALL TEST PASS!!!     ************************");
		$display("*************************************************************************");
        $stop;

	end




//***************************	HEADER TEST TASK	**************************
task HEADER_TEST;
	begin
	    $display("*************************** HEADER test begin ***************************\n");
		
        $display("*********** Block Read HEADER ***********");
		wb_write(`I2C_ADDR,8'hF0,0,0,8'h1);
        wb_read(`I2C_ADDR,8'h3);
		$display("i2c_rddata1 is %x and i2c_rddata2 is %x and i2c_rddata3 is %x", i2c_rddata1,i2c_rddata2,i2c_rddata3);
		if((i2c_rddata1 == `CPLD_MAJ_VER) && (i2c_rddata2 == `CPLD_MIN_VER) && (i2c_rddata3 == `CHECKSUM))
		  $display("HEADER Block Read test pass\n");
		else
		  begin
		    $display("HEADER Block Read test fail");
			$stop;
		  end
		
		$display("*********** Read CPLD_MAJ_VER ***********");
		wb_write(`I2C_ADDR,8'hF0,0,0,8'h1);
        wb_read(`I2C_ADDR,8'h1);
		if(i2c_rddata1 == `CPLD_MAJ_VER)
		  $display("CPLD_MAJ_VER test pass\n");
		else
		  begin
		    $display("CPLD_MAJ_VER test fail");
			$stop;
		  end
		
		$display("*********** Read CPLD_MIN_VER ***********");
		wb_write(`I2C_ADDR,8'hF1,0,0,8'h1);
        wb_read(`I2C_ADDR,8'h1);
		if(i2c_rddata1 == `CPLD_MIN_VER)
		  $display("CPLD_MIN_VER test pass\n");
		else
		  begin
		    $display("CPLD_MIN_VER test fail");
			$stop;
		  end
		
		$display("*********** Read CHECKSUM ***********");
		wb_write(`I2C_ADDR,8'hF2,0,0,8'h1);
        wb_read(`I2C_ADDR,8'h1);
		if(i2c_rddata1 == `CHECKSUM)
		  $display("CHECKSUM test pass\n");
		else
		  begin
		    $display("CHECKSUM test fail");
			$stop;
		  end
		
		$display("*************************** HEADER test pass ***************************\n");
	end
endtask

//***************************	LED TEST TASK	**************************
task LED_TEST;
	begin
		$display("*************************** I2C LED test begin ***************************\n");
		wb_write(`I2C_ADDR,8'h50,{`LED_ON,`LED_OFF},8'h00,8'h2);
		wb_read(`I2C_ADDR,8'h1);
		
		if((tb_hattrick.HATTRICK_TOP_INST.FAULT_LED_INST.LED0 == `OFF) && (tb_hattrick.HATTRICK_TOP_INST.FAULT_LED_INST.LED1 == `ON))
			begin
				$display("LED TEST Pass, the HDD FLT LED data is %x\n", i2c_rddata1);
			end
		else
			begin
				$display("LED TEST Fail, the HDD FLT LED data is %x\n", i2c_rddata1);
				$stop;
			end
		
		$display("*************************** I2C LED test pass ***************************\n");
	end
endtask

//******************************	I2C TASK	******************************
task wb_write;
	input	[7:0]	i2c_addr;
	input	[7:0]	data1;
	input	[7:0]	data2;
	input	[7:0]	data3;
	input	[7:0]	data_num;
	begin
		//i2c_address = {`I2C_ADDR,1'b0};
		i2c_address = {i2c_addr,1'b0};
		i2c_wrdata1 = data1;
		i2c_wrdata2 = data2;
		i2c_wrdata3 = data3;
		i2c_data_num = data_num;
		@(posedge clk);
		i2c_wr = 0;
		@(posedge clk);
		i2c_wr = 1;
		
		@(negedge i2c_busy);
		
		if(data_num == 8'h1)
			$display("The I2C write %x", i2c_wrdata1);
		else if(data_num == 8'h2)
			$display("The I2C write %x and %x", i2c_wrdata1, i2c_wrdata2);
		else
			$display("The I2C write %x and %x and %x", i2c_wrdata1, i2c_wrdata2, i2c_wrdata3);
	end
endtask

task wb_read;
	input	[7:0]	i2c_addr;
	//output	[7:0]	data1;
	//output	[7:0]	data2;
	input	[7:0]	data_num;
	begin
		//i2c_address = {`I2C_ADDR,1'b1};
		i2c_address = {i2c_addr,1'b1};
		i2c_data_num = data_num;
		@(posedge clk);
		i2c_wr = 0;
		@(posedge clk);
		i2c_wr = 1;
		
		@(negedge i2c_busy);
		
		if(data_num == 8'h1)
			$display("The I2C received %x", i2c_rddata1);
		else
			$display("The I2C received %x and %x", i2c_rddata1, i2c_rddata2);
		//data1 = i2c_rddata1;
		//data2 = i2c_rddata2;
	end
endtask


endmodule

