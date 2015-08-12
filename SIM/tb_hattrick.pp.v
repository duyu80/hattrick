`include "../SRC/hattrick_define.v"
`include "i2c_master_defines.v"

module tb_hattrick;

`define    WR_BYTE `I2C_CHECKSUM+2

wire	[7:0]		i;
reg			    clk;
reg			    rstn;
reg			    i2c_wr;
reg	[7:0]	    i2c_address;
reg	[7:0]	    i2c_wrdata1;
reg	[7:0]	    i2c_wrdata2;
reg	[7:0]	    i2c_wrdata3;
reg	[7:0]	    i2c_data_num;

reg [64*8-1:0]  test;

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
// Interrupt
wire      I2C_ALERT_L;
// Spin up
reg       spinup_done;

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

; for ($i=1; $i<16; $i++) {
                .HDD${i}_INSERT_L                ( HDD${i}_INSERT_L ),
; }

; for ($i=1; $i<16; $i++) {
                .P5V_GD_HDD${i}                  ( P5V_GD_HDD${i} ),
; }

; for ($i=1; $i<16; $i++) {
                .P12V_GD_HDD${i}                 ( P12V_GD_HDD${i} ),
; }

; for ($i=1; $i<16; $i++) {
                .PWR_EN_HDD${i}_L                ( PWR_EN_HDD${i}_L ),
; }

; for ($i=1; $i<16; $i++) {
                .HDD${i}_Health_LED              ( HDD${i}_Health_LED ),
; }

; for ($i=1; $i<16; $i++) {
                .HDD${i}_FAULT_LED               ( HDD${i}_FAULT_LED ),
; }
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
				.Sideplane_REV_ID1               ( Sideplane_REV_ID1      ),
				
				.I2C_ALERT_L                     ( I2C_ALERT_L )
				
				);

always	#20   clk       = ~clk;

	
initial
	begin
        #0
        clk          = 0;
        rstn         = 0;
        i2c_wr       = 1;
		test         = "Begin Test";
		spinup_done  = 0;
		
		{HDD15_INSERT_L,HDD14_INSERT_L,HDD13_INSERT_L,
		HDD12_INSERT_L,HDD11_INSERT_L,HDD10_INSERT_L,HDD9_INSERT_L,
		HDD8_INSERT_L,HDD7_INSERT_L,HDD6_INSERT_L,HDD5_INSERT_L,
		HDD4_INSERT_L,HDD3_INSERT_L,HDD2_INSERT_L,HDD1_INSERT_L} = 15'h80;

		{P5V_GD_HDD15,P5V_GD_HDD14,P5V_GD_HDD13,
		P5V_GD_HDD12,P5V_GD_HDD11,P5V_GD_HDD10,P5V_GD_HDD9,
		P5V_GD_HDD8,P5V_GD_HDD7,P5V_GD_HDD6,P5V_GD_HDD5,
		P5V_GD_HDD4,P5V_GD_HDD3,P5V_GD_HDD2,P5V_GD_HDD1} = 15'h0;
		  
        {P12V_GD_HDD15,P12V_GD_HDD14,P12V_GD_HDD13,
		P12V_GD_HDD12,P12V_GD_HDD11,P12V_GD_HDD10,P12V_GD_HDD9,
		P12V_GD_HDD8,P12V_GD_HDD7,P12V_GD_HDD6,P12V_GD_HDD5,
		P12V_GD_HDD4,P12V_GD_HDD3,P12V_GD_HDD2,P12V_GD_HDD1} = 15'h0;

		repeat (100) @(posedge clk);
		rstn = 1;
		
		@(negedge PWR_EN_HDD15_L)
		spinup_done  = 1;
		
        test = "HEADER_TEST";
		HEADER_TEST();
		repeat (1000) @(posedge clk);
		
		//LED_TEST
		test = "LED_TEST";
		LED_TEST();
		repeat (1000) @(posedge clk);
		
		// ****** Current design already remove interrupt, so delete this task ******
		//Interrupt and HDD insert and 5V/12V power good test
		//test = "INTERRUPT Insert power good test";
        //INTERRUPT_TEST();
		//repeat (1000) @(posedge clk);
		
		\$display("*************************************************************************");
		\$display("***********************     ALL TEST PASS!!!     ************************");
		\$display("*************************************************************************");
        \$stop;

	end

//***************************	HDD Power Up Check	**************************
integer  to_counter;
reg      timeout;
always@( posedge clk or posedge rstn)
    begin
	    if(rstn && !spinup_done)
		    begin
			    timeout = 0;  to_counter = 0;
                while (PWR_EN_HDD1_L && !timeout) begin 
                    @(posedge clk); 
                    if (to_counter == (`CLK_FRQ * `SPINUP_DELAY + 10)) begin timeout = 1;  end
                    to_counter = to_counter+1; 
                end
                if (timeout) begin
                    \$display ("Timeout while waiting for HDD1 Power Up");
                    \$stop;
                end
				
				if(!PWR_EN_HDD1_L)
				begin
				    timeout = 0;  to_counter = 0;
                    while (PWR_EN_HDD2_L && !timeout) begin 
                        @(posedge clk); 
                        if (to_counter == (`CLK_FRQ * `SPINUP_DELAY + 10)) begin timeout = 1;  end
                        to_counter = to_counter+1; 
                    end
                    if (timeout) begin
                        \$display ("Timeout while waiting for HDD2 Power Up");
                        \$stop;
                    end
				end
				
				if(!PWR_EN_HDD2_L)
				begin
				    timeout = 0;  to_counter = 0;
                    while (PWR_EN_HDD3_L && !timeout) begin 
                        @(posedge clk); 
                        if (to_counter == (`CLK_FRQ * `SPINUP_DELAY + 10)) begin timeout = 1;  end
                        to_counter = to_counter+1; 
                    end
                    if (timeout) begin
                        \$display ("Timeout while waiting for HDD3 Power Up");
                        \$stop;
                    end
				end

				if(!PWR_EN_HDD3_L)
				begin
				    timeout = 0;  to_counter = 0;
                    while (PWR_EN_HDD4_L && !timeout) begin 
                        @(posedge clk); 
                        if (to_counter == (`CLK_FRQ * `SPINUP_DELAY + 10)) begin timeout = 1;  end
                        to_counter = to_counter+1; 
                    end
                    if (timeout) begin
                        \$display ("Timeout while waiting for HDD4 Power Up");
                        \$stop;
                    end
				end

				if(!PWR_EN_HDD4_L)
				begin
				    timeout = 0;  to_counter = 0;
                    while (PWR_EN_HDD5_L && !timeout) begin 
                        @(posedge clk); 
                        if (to_counter == (`CLK_FRQ * `SPINUP_DELAY + 10)) begin timeout = 1;  end
                        to_counter = to_counter+1; 
                    end
                    if (timeout) begin
                        \$display ("Timeout while waiting for HDD5 Power Up");
                        \$stop;
                    end
				end
				
				if(!PWR_EN_HDD14_L)
				begin
				    timeout = 0;  to_counter = 0;
                    while (PWR_EN_HDD15_L && !timeout) begin 
                        @(posedge clk); 
                        if (to_counter == (`CLK_FRQ * `SPINUP_DELAY + 10)) begin timeout = 1;  end
                        to_counter = to_counter+1; 
                    end
                    if (timeout) begin
                        \$display ("Timeout while waiting for HDD15 Power Up");
                        \$stop;
                    end
				end				
			end
	end


//***************************	HEADER TEST TASK	**************************
task HEADER_TEST;
	begin
	    \$display("*************************** HEADER test begin ***************************\\n");
		
        \$display("*********** Block Read HEADER ***********");
		wb_write(`I2C_ADDR,8'hF0,0,0,8'h1);
        wb_read(`I2C_ADDR,8'h3);
		\$display("i2c_rddata1 is %%x and i2c_rddata2 is %%x and i2c_rddata3 is %%x", i2c_rddata1,i2c_rddata2,i2c_rddata3);
		if((i2c_rddata1 == `CPLD_MAJ_VER) && (i2c_rddata2 == `CPLD_MIN_VER) && (i2c_rddata3 == `CHECKSUM))
		  \$display("HEADER Block Read test pass\\n");
		else
		  begin
		    \$display("HEADER Block Read test fail");
			\$stop;
		  end
		
		\$display("*********** Read CPLD_MAJ_VER ***********");
		wb_write(`I2C_ADDR,8'hF0,0,0,8'h1);
        wb_read(`I2C_ADDR,8'h1);
		if(i2c_rddata1 == `CPLD_MAJ_VER)
		  \$display("CPLD_MAJ_VER test pass\\n");
		else
		  begin
		    \$display("CPLD_MAJ_VER test fail");
			\$stop;
		  end
		
		\$display("*********** Read CPLD_MIN_VER ***********");
		wb_write(`I2C_ADDR,8'hF1,0,0,8'h1);
        wb_read(`I2C_ADDR,8'h1);
		if(i2c_rddata1 == `CPLD_MIN_VER)
		  \$display("CPLD_MIN_VER test pass\\n");
		else
		  begin
		    \$display("CPLD_MIN_VER test fail");
			\$stop;
		  end
		
		\$display("*********** Read CHECKSUM ***********");
		wb_write(`I2C_ADDR,8'hF2,0,0,8'h1);
        wb_read(`I2C_ADDR,8'h1);
		if(i2c_rddata1 == `CHECKSUM)
		  \$display("CHECKSUM test pass\\n");
		else
		  begin
		    \$display("CHECKSUM test fail");
			\$stop;
		  end
		
		\$display("*************************** HEADER test pass ***************************\\n");
	end
endtask

//***************************	LED TEST TASK	**************************
task LED_TEST;
	begin
		\$display("*************************** Health LED test begin ***************************\\n");
		test = "Health LED ON/OFF Test Write";
		wb_write(`I2C_ADDR,8'h20,{`LED_ON,`LED_OFF},0-{`LED_ON,`LED_OFF},`WR_BYTE);
		test = "Health LED ON/OFF Test Read";
		wb_read(`I2C_ADDR,8'h1);
		if((tb_hattrick.HATTRICK_TOP_INST.HEALTH_LED_INST.LED0 == `OFF) && (tb_hattrick.HATTRICK_TOP_INST.HEALTH_LED_INST.LED1 == `ON))
			begin
				\$display("Health LED ON/OFF TEST Pass, the Health LED set code is %%x\\n", i2c_rddata1);
			end
		else
			begin
				\$display("Health LED ON/OFF TEST Fail, the Health LED set code is %%x\\n", i2c_rddata1);
				\$stop;
			end
		
		test = "Health LED0 BLK_4HZ LED1 BLK_2HZ Test Write";
		wb_write(`I2C_ADDR,8'h20,{`BLK_2HZ,`BLK_4HZ},0 - {`BLK_2HZ,`BLK_4HZ},`WR_BYTE);
		test = "Health LED0 BLK_4HZ LED1 BLK_2HZ Test Read";
		wb_read(`I2C_ADDR,8'h1);
		
		@(posedge tb_hattrick.HATTRICK_TOP_INST.HEALTH_LED_INST.LED0);
		repeat (`CLK_FRQ/8+10) @(posedge clk);
		if(tb_hattrick.HATTRICK_TOP_INST.HEALTH_LED_INST.LED0 == `OFF)
			begin
				\$display("Health LED0 BLK_4HZ TEST Pass, the Health LED set code is %%x\\n", i2c_rddata1);
			end
		else
			begin
				\$display("Health LED0 BLK_4HZ TEST Fail, the Health LED set code is %%x\\n", i2c_rddata1);
				\$stop;
			end
		@(posedge tb_hattrick.HATTRICK_TOP_INST.HEALTH_LED_INST.LED1);
		repeat (`CLK_FRQ/4+10) @(posedge clk);
		if(tb_hattrick.HATTRICK_TOP_INST.HEALTH_LED_INST.LED1 == `OFF)
			begin
				\$display("Health LED1 BLK_2HZ TEST Pass, the Health LED set code is %%x\\n", i2c_rddata1);
			end
		else
			begin
				\$display("Health LED1 BLK_2HZ TEST Fail, the Health LED set code is %%x\\n", i2c_rddata1);
				\$stop;
			end

		\$display("*************************** Health LED test pass ***************************\\n");
		
		\$display("*************************** Fault LED test begin ***************************\\n");
		
		test = "Fault LED0 BLK_07S LED1 BLK_05S Test Write";
		wb_write(`I2C_ADDR,8'h30,{`BLK_05S,`BLK_07S},0 - {`BLK_05S,`BLK_07S},`WR_BYTE);
		test = "Fault LED0 BLK_07S LED1 BLK_05S Test Read";
		wb_read(`I2C_ADDR,8'h1);
		
		@(posedge tb_hattrick.HATTRICK_TOP_INST.FAULT_LED_INST.LED0);
		repeat (`CLK_FRQ*7/10+10) @(posedge clk);
		if(tb_hattrick.HATTRICK_TOP_INST.FAULT_LED_INST.LED0 == `OFF)
			begin
				\$display("Fault LED0 BLK_07S TEST Pass, the Fault LED set code is %%x\\n", i2c_rddata1);
			end
		else
			begin
				\$display("Fault LED0 BLK_07S TEST Fail, the Fault LED set code is %%x\\n", i2c_rddata1);
				\$stop;
			end
		@(posedge tb_hattrick.HATTRICK_TOP_INST.FAULT_LED_INST.LED1);
		@(posedge tb_hattrick.HATTRICK_TOP_INST.FAULT_LED_INST.LED1);
		@(posedge tb_hattrick.HATTRICK_TOP_INST.FAULT_LED_INST.LED1);
		repeat (`CLK_FRQ/2+10) @(posedge clk);
		if(tb_hattrick.HATTRICK_TOP_INST.FAULT_LED_INST.LED1 == `OFF)
			begin
				\$display("Fault LED1 BLK_05S TEST Pass, the Fault LED set code is %%x\\n", i2c_rddata1);
			end
		else
			begin
				\$display("Fault LED1 BLK_05S TEST Fail, the Fault LED set code is %%x\\n", i2c_rddata1);
				\$stop;
			end

		\$display("*************************** Fault LED test pass ***************************\\n");
		
		// \$display("*************************** MINISAS LED test begin ***************************\\n");
		
		// test = "MINISAS LED0 BLK_35S Test Write";
		// wb_write(`I2C_ADDR,8'h60,{`BLK_05S,`BLK_35S},0 - {`BLK_05S,`BLK_35S},`WR_BYTE);
		// test = "MINISAS LED0 BLK_35S LED1 BLK_05S Test Read";
		// wb_read(`I2C_ADDR,8'h1);
		
		// @(posedge tb_hattrick.HATTRICK_TOP_INST.MINISAS_LED_INST.LED1);
		// @(posedge tb_hattrick.HATTRICK_TOP_INST.MINISAS_LED_INST.LED1);
		// @(posedge tb_hattrick.HATTRICK_TOP_INST.MINISAS_LED_INST.LED1);
		// repeat (`CLK_FRQ*3.5+100) @(posedge clk);
		// if(tb_hattrick.HATTRICK_TOP_INST.MINISAS_LED_INST.LED0 == `OFF)
			// begin
				// \$display("MINISAS LED0 BLK_35S TEST Pass, the MINISAS LED set code is %%x\\n", i2c_rddata1);
			// end
		// else
			// begin
				// \$display("MINISAS LED0 BLK_35S TEST Fail, the MINISAS LED set code is %%x\\n", i2c_rddata1);
				// \$stop;
			// end
		
		// \$display("*************************** MINISAS LED test pass ***************************\\n");
		
		\$display("*************************** LED test pass ***************************\\n");
	end
endtask

//***************************	INTERRUPT TEST TASK	**************************
task INTERRUPT_TEST;
	begin
	    \$display("*************************** INTERRUPT test begin ***************************\\n");
		{HDD15_INSERT_L,HDD14_INSERT_L,HDD13_INSERT_L,
		HDD12_INSERT_L,HDD11_INSERT_L,HDD10_INSERT_L,HDD9_INSERT_L,
		HDD8_INSERT_L,HDD7_INSERT_L,HDD6_INSERT_L,HDD5_INSERT_L,
		HDD4_INSERT_L,HDD3_INSERT_L,HDD2_INSERT_L,HDD1_INSERT_L} = 16'h5123;

		{P5V_GD_HDD15,P5V_GD_HDD14,P5V_GD_HDD13,
		P5V_GD_HDD12,P5V_GD_HDD11,P5V_GD_HDD10,P5V_GD_HDD9,
		P5V_GD_HDD8,P5V_GD_HDD7,P5V_GD_HDD6,P5V_GD_HDD5,
		P5V_GD_HDD4,P5V_GD_HDD3,P5V_GD_HDD2,P5V_GD_HDD1} = 16'h7234;
		  
        {P12V_GD_HDD15,P12V_GD_HDD14,P12V_GD_HDD13,
		P12V_GD_HDD12,P12V_GD_HDD11,P12V_GD_HDD10,P12V_GD_HDD9,
		P12V_GD_HDD8,P12V_GD_HDD7,P12V_GD_HDD6,P12V_GD_HDD5,
		P12V_GD_HDD4,P12V_GD_HDD3,P12V_GD_HDD2,P12V_GD_HDD1} = 16'h5567;
		
		@(negedge tb_hattrick.HATTRICK_TOP_INST.I2C_ALERT_L);
		
        \$display("*********** Read INTERRUPT REG ***********");
		wb_write(`I2C_ADDR,8'h90,0,0,8'h1);
        wb_read(`I2C_ADDR,8'h1);
		\$display("Interrupt register is %%x", i2c_rddata1);
		if(i2c_rddata1 == 8'h7)
		  \$display("INTERRUPT Read test pass\\n");
		else
		  begin
		    \$display("INTERRUPT Read test fail");
			\$stop;
		  end
		
		if(tb_hattrick.HATTRICK_TOP_INST.I2C_ALERT_L)
		    \$display("*********** Read INTERRUPT REG Successfully ***********");
		
        \$display("*********** Block Read 00H -- HDD insert and 5V/12V power good ***********");
		wb_write(`I2C_ADDR,8'h00,0,0,8'h1);
        wb_read(`I2C_ADDR,8'h3);
		\$display("HDD INSERT is %%x and P5V_POWERGD is %%x and P12V_POWERGD is %%x", i2c_rddata1,i2c_rddata2,i2c_rddata3);
		if((i2c_rddata1 != 16'h23) && (i2c_rddata2 != 16'h51) && (i2c_rddata3 != 16'h34))
		  begin
		    \$display("HDD insert and 5V/12V power good Read test fail");
			\$stop;
		  end
		
		wb_read(`I2C_ADDR,8'h3);
		\$display("HDD INSERT is %%x and P5V_POWERGD is %%x and P12V_POWERGD is %%x", i2c_rddata1,i2c_rddata2,i2c_rddata3);
		if((i2c_rddata1 == 16'h72) && (i2c_rddata2 == 16'h67) && (i2c_rddata3 == 16'h55))
		  \$display("HDD insert and 5V/12V power good Read test pass\\n");
		else
		  begin
		    \$display("HDD insert and 5V/12V power good Read test fail");
			\$stop;
		  end

		\$display("*************************** INTERRUPT test pass ***************************\\n");
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
			\$display("The I2C write %%x", i2c_wrdata1);
		else if(data_num == 8'h2)
			\$display("The I2C write %%x and %%x", i2c_wrdata1, i2c_wrdata2);
		else
			\$display("The I2C write %%x and %%x and %%x", i2c_wrdata1, i2c_wrdata2, i2c_wrdata3);
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
			\$display("The I2C received %%x", i2c_rddata1);
		else if(data_num == 8'h2)
			\$display("The I2C received %%x and %%x", i2c_rddata1, i2c_rddata2);
		else if(data_num == 8'h3)
			\$display("The I2C received %%x and %%x and %%x", i2c_rddata1, i2c_rddata2, i2c_rddata3);
		//data1 = i2c_rddata1;
		//data2 = i2c_rddata2;
	end
endtask


endmodule

