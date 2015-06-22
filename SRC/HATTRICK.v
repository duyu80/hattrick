//************************************************************************
//**                          Hattrick CPLD                             **
//**                          HATTRICK.v								**
//************************************************************************ 

//**********************      ChangeList      *****************************

`include "../SRC/hattrick_define.v"


module HATTRICK_TOP (
            // System
			input     SYSCLK,
			input     RESET_N,
			// I2C
			input     SCL,
			inout     SDA,
            // HDD insert
			input     HDD4_INSERT_L,HDD3_INSERT_L,HDD2_INSERT_L,HDD1_INSERT_L,
			          HDD8_INSERT_L,HDD7_INSERT_L,HDD6_INSERT_L,HDD5_INSERT_L,
					  HDD12_INSERT_L,HDD11_INSERT_L,HDD10_INSERT_L,HDD9_INSERT_L,
					                 HDD15_INSERT_L,HDD14_INSERT_L,HDD13_INSERT_L;
			// 5v power good
			input     P5V_GD_HDD4,P5V_GD_HDD3,P5V_GD_HDD2,P5V_GD_HDD1,
			          P5V_GD_HDD8,P5V_GD_HDD7,P5V_GD_HDD6,P5V_GD_HDD5,
					  P5V_GD_HDD12,P5V_GD_HDD11,P5V_GD_HDD10,P5V_GD_HDD9,
					               P5V_GD_HDD15,P5V_GD_HDD14,P5V_GD_HDD13;
			// 12v power good
			input     P12V_GD_HDD4,P12V_GD_HDD3,P12V_GD_HDD2,P12V_GD_HDD1,
			          P12V_GD_HDD8,P12V_GD_HDD7,P12V_GD_HDD6,P12V_GD_HDD5,
					  P12V_GD_HDD12,P12V_GD_HDD11,P12V_GD_HDD10,P12V_GD_HDD9,
					               P12V_GD_HDD15,P12V_GD_HDD14,P12V_GD_HDD13;
			// HDD power enable
			output    PWR_EN_HDD4_L,PWR_EN_HDD3_L,PWR_EN_HDD2_L,PWR_EN_HDD1_L,
			          PWR_EN_HDD8_L,PWR_EN_HDD7_L,PWR_EN_HDD6_L,PWR_EN_HDD5_L,
					  PWR_EN_HDD12_L,PWR_EN_HDD11_L,PWR_EN_HDD10_L,PWR_EN_HDD9_L,
					               PWR_EN_HDD15_L,PWR_EN_HDD14_L,PWR_EN_HDD13_L;
			// HDD health led
			output    HDD4_Health_LED,HDD3_Health_LED,HDD2_Health_LED,HDD1_Health_LED,
			          HDD8_Health_LED,HDD7_Health_LED,HDD6_Health_LED,HDD5_Health_LED,
					  HDD12_Health_LED,HDD11_Health_LED,HDD10_Health_LED,HDD9_Health_LED,
					                 HDD15_Health_LED,HDD14_Health_LED,HDD13_Health_LED;
			// HDD fault led
			output    HDD4_FAULT_LED,HDD3_FAULT_LED,HDD2_FAULT_LED,HDD1_FAULT_LED,
			          HDD8_FAULT_LED,HDD7_FAULT_LED,HDD6_FAULT_LED,HDD5_FAULT_LED,
					  HDD12_FAULT_LED,HDD11_FAULT_LED,HDD10_FAULT_LED,HDD9_FAULT_LED,
					                 HDD15_FAULT_LED,HDD14_FAULT_LED,HDD13_FAULT_LED;
            // MINI SAS
            input     A_MODPRESL,A_INTL,A_VACT_OC_L;
            output    A_VMAN_EN_L,A_VACT _EN_L;
			output    A_HEALTH_LED_L,A_FAULT_LED;
			input     B_MODPRESL,B_INTL,B_VACT_OC_L;
            output    B_VMAN_EN_L,B_VACT _EN_L;
			output    B_HEALTH_LED_L,B_FAULT_LED;
            // Enclosure led
			output    ENCLOSURE _HEALTH_LED_L;
			output    ENCLOSURE _FAULT_LED;
			// hardware revision
			input     Sideplane_REV_ID1,Sideplane_REV_ID0;
			// heart beat led
            output reg   HEART			
			);

//I2C wire
wire	[7:0]	I2C_DOUT;
wire	[15:0]	PORT_CS;
wire	[15:0]	OFFSET_SEL;    //This two signal port are used for GPIO port selection
wire			RD_WR;    //1 means I2C read operation, and 0 means I2C write operation
wire	[7:0]   DIN_0, DIN_1, DIN_2, DIN_3, DIN_4,  DIN_5, DIN_6, DIN_7, DIN_8, DIN_9, DIN_A, DIN_B, DIN_C, DIN_D, DIN_E, DIN_F;    //16 PORTs for GPIO PORTs
wire			WR_EN;    //This signal is for error code

//LED
wire    [7:0]	LED_REG0;
wire    [7:0]	LED_REG1;
wire    [7:0]	LED_REG2;
wire    [7:0]	LED_REG3;
wire    [7:0]	LED_REG4;
wire    [7:0]	LED_REG5;
wire    [7:0]	LED_REG6;
wire    [7:0]	LED_REG7;


//**************************************************************************
//**                          
//**  This instance is I2C MACHINE, CPLD use this I2C MACHINE to read/write
//**  data from/to GPIO                    
//**                          
//************************************************************************** 
I2C  I2C_INS  (
			   .SCL		   		    (SCL),
			   .SDA		   		    (SDA),
			   .I2C_ADDRESS		    (`I2C_ADDR),
			   .I2C_RESET_N		    (RESET_N),
			   .SYSCLK     			(SYSCLK),
			   .PORT_CS    		    (PORT_CS),
			   .OFFSET_SEL 		    (OFFSET_SEL),
			   .RD_WR      		    (RD_WR),
			   .DOUT       			(I2C_DOUT),
			   .DIN_0      			(DIN_0),                
			   .DIN_1      			(DIN_1), 		
			   .DIN_2      			(DIN_2), 		
			   .DIN_3      			(DIN_3), 		
			   .DIN_4      			(DIN_4), 		
			   .DIN_5      			(DIN_5), 		
			   .DIN_6      			(DIN_6), 		
			   .DIN_7      			(DIN_7),		    
			   .DIN_8      			(DIN_8), 		
			   .DIN_9      			(DIN_9), 		
			   .DIN_A      			(DIN_A), 		
			   .DIN_B      			(DIN_B), 		
			   .DIN_C      			(DIN_C), 		
			   .DIN_D      			(DIN_D), 		
			   .DIN_E      			(DIN_E), 		
			   .DIN_F      			(DIN_F)
			   );

// HDD insert 00H
GPI    	GPI0_INST (
			.RESET_N		(RESET_N),
			.SYSCLK			(SYSCLK),
			
			.PORT_CS1		(PORT_CS[0]),
			.OFFSET_SEL1	(OFFSET_SEL),
			.DOUT1			(DIN),						
			.RD_WR1		    (RD_WR),
			
			.DIN0           ( HDD1_INSERT_L  ),
			.DIN1           ( HDD2_INSERT_L  ),
			.DIN2           ( HDD3_INSERT_L  ),
			.DIN3           ( HDD4_INSERT_L  ),
			.DIN4           ( HDD5_INSERT_L  ),			
			.DIN5           ( HDD6_INSERT_L  ),
			.DIN6           ( HDD7_INSERT_L  ),
			.DIN7           ( HDD8_INSERT_L  ),
			.DIN8           ( HDD9_INSERT_L  ),
			.DIN9           ( HDD10_INSERT_L ),
			.DIN10          ( HDD11_INSERT_L ),
			.DIN11          ( HDD12_INSERT_L ),
			.DIN12          ( HDD13_INSERT_L ),
			.DIN13          ( HDD14_INSERT_L ),
			.DIN14          ( HDD15_INSERT_L ),
			.DIN15          (                )
			);

// 5v power good 10H
GPI    	GPI1_INST (
			.RESET_N		(RESET_N),
			.SYSCLK			(SYSCLK),
			
			.PORT_CS1		(PORT_CS[1]),
			.OFFSET_SEL1	(OFFSET_SEL),
			.DOUT1			(DIN),						
			.RD_WR1		    (RD_WR),
			
			.DIN0           ( P5V_GD_HDD1 ),
			.DIN1           ( P5V_GD_HDD2 ),
			.DIN2           ( P5V_GD_HDD3 ),
			.DIN3           ( P5V_GD_HDD4 ),
			.DIN4           ( P5V_GD_HDD5 ),			
			.DIN5           ( P5V_GD_HDD6 ),
			.DIN6           ( P5V_GD_HDD7 ),
			.DIN7           ( P5V_GD_HDD8 ),
			.DIN8           ( P5V_GD_HDD9 ),
			.DIN9           ( P5V_GD_HDD10 ),
			.DIN10          ( P5V_GD_HDD11 ),
			.DIN11          ( P5V_GD_HDD12 ),
			.DIN12          ( P5V_GD_HDD13 ),
			.DIN13          ( P5V_GD_HDD14 ),
			.DIN14          ( P5V_GD_HDD15 ),
			.DIN15          (              )
			);

// 12v power good 20H
GPI    	GPI2_INST (
			.RESET_N		(RESET_N),
			.SYSCLK			(SYSCLK),
			
			.PORT_CS1		(PORT_CS[2]),
			.OFFSET_SEL1	(OFFSET_SEL),
			.DOUT1			(DIN),						
			.RD_WR1		    (RD_WR),
			
			.DIN0           ( P12V_GD_HDD1 ),
			.DIN1           ( P12V_GD_HDD2 ),
			.DIN2           ( P12V_GD_HDD3 ),
			.DIN3           ( P12V_GD_HDD4 ),
			.DIN4           ( P12V_GD_HDD5 ),			
			.DIN5           ( P12V_GD_HDD6 ),
			.DIN6           ( P12V_GD_HDD7 ),
			.DIN7           ( P12V_GD_HDD8 ),
			.DIN8           ( P12V_GD_HDD9 ),
			.DIN9           ( P12V_GD_HDD10 ),
			.DIN10          ( P12V_GD_HDD11 ),
			.DIN11          ( P12V_GD_HDD12 ),
			.DIN12          ( P12V_GD_HDD13 ),
			.DIN13          ( P12V_GD_HDD14 ),
			.DIN14          ( P12V_GD_HDD15 ),
			.DIN15          (              )
			);
			
//HEADER F0H
GPI    	GPIF_INST (
			.RESET_N		(RESET_N),
			.SYSCLK			(SYSCLK),
			
			.PORT_CS1		(PORT_CS[15]),
			.OFFSET_SEL1	(OFFSET_SEL),
			.DOUT1			(DIN_0),						
			.RD_WR1		    (RD_WR),
			
			.DIN0           ( `DEVICE_ID_MSB ),
			.DIN1           ( `DEVICE_ID_LSB ),
			.DIN2           ( `CPLD_MAJ_VER  ),
			.DIN3           (0),
			.DIN4           (0),
			.DIN5           (0),
			.DIN6           (0),
			.DIN7           (0),
			.DIN8           (0),
			.DIN9           (0),
			.DIN10          (0),
			.DIN11          (0),
			.DIN12          (0),
			.DIN13          (0),
			.DIN14          (0),
			.DIN15          (0)
			);




GPO_PROTECT #     (
            .GPO_DFT        (8'h00)
          )   
GPO2_INST (
			.RESET_N		(RESET_N),
			.SYSCLK			(SYSCLK),
			
			.PORT_CS1		(PORT_CS_1[2]),
			.PORT_CS1_ALL	(PORT_CS_1),
			.OFFSET_SEL1	(OFFSET_SEL_1),
			.DOUT1			(DIN_2_1),						
			.RD_WR1		    (RD_WR_1),
			.DIN1			(I2C_DOUT_1),
			
			.PORT_CS2		(PORT_CS_2[2]),
			.PORT_CS2_ALL	(PORT_CS_2),
			.OFFSET_SEL2	(OFFSET_SEL_2),
			.DOUT2			(DIN_2_2),						
			.RD_WR2		    (RD_WR_2),
			.DIN2			(I2C_DOUT_2),

			.DO0		    (DRV_PWR_EN0),
			.DO1		    (DRV_PWR_EN1),
			.DO2		    (DRV_PWR_EN2),
			.DO3		    (DRV_PWR_EN3),
			.DO4		    (DRV_PWR_EN4),
			.DO5		    (),
			.DO6		    (),
			.DO7		    (),
			.DO8		    (),
			.DO9		    (),
			.DO10		    (),
			.DO11		    (),
			.DO12		    (),
			.DO13		    (),
			.DO14		    (),
			.DO15		    ()
			);




//FAULT AMBER LED 40H 50H
wire    [7:0]  FLT_AMB_LED0;
wire    [7:0]  FLT_AMB_LED1;
wire    [7:0]  FLT_AMB_LED2;
wire    [7:0]  FLT_AMB_LED3;
wire    [7:0]  FLT_AMB_LED4;
wire    [7:0]  FLT_AMB_LED5;
wire    [7:0]  FLT_AMB_LED6;
wire    [7:0]  FLT_AMB_LED7;
wire    [7:0]  FLT_AMB_LED8;
wire    [7:0]  FLT_AMB_LED9;
wire    [7:0]  FLT_AMB_LED10;
wire    [7:0]  FLT_AMB_LED11;
wire    [7:0]  FLT_AMB_LED12;
wire    [7:0]  FLT_AMB_LED13;
wire    [7:0]  FLT_AMB_LED14;
wire    [7:0]  FLT_AMB_LED15;
wire    [7:0]  FLT_AMB_LED16;
wire    [7:0]  FLT_AMB_LED17;

GPO    GPO4_INST (
			.RESET_N		(RESET_N),
			.SYSCLK			(SYSCLK),
			
			.PORT_CS1		(PORT_CS_1[4]),
			.OFFSET_SEL1	(OFFSET_SEL_1),
			.DOUT1			(DIN_4_1),						
			.RD_WR1		    (RD_WR_1),
			.DIN1			(I2C_DOUT_1),
			
			.PORT_CS2		(PORT_CS_2[4]),
			.OFFSET_SEL2	(OFFSET_SEL_2),
			.DOUT2			(DIN_4_2),						
			.RD_WR2		    (RD_WR_2),
			.DIN2			(I2C_DOUT_2),

			.DO0		    (FLT_AMB_LED0 ),
			.DO1		    (FLT_AMB_LED1 ),
			.DO2		    (FLT_AMB_LED2 ),
			.DO3		    (FLT_AMB_LED3 ),
			.DO4		    (FLT_AMB_LED4 ),
			.DO5		    (FLT_AMB_LED5 ),
			.DO6		    (FLT_AMB_LED6 ),
			.DO7		    (FLT_AMB_LED7 ),
			.DO8		    (FLT_AMB_LED8 ),
			.DO9		    (FLT_AMB_LED9 ),
			.DO10		    (FLT_AMB_LED10),
			.DO11		    (FLT_AMB_LED11),
			.DO12		    (FLT_AMB_LED12),
			.DO13		    (FLT_AMB_LED13),
			.DO14		    (FLT_AMB_LED14),
			.DO15		    (FLT_AMB_LED15)
			);

GPO    GPO5_INST (
			.RESET_N		(RESET_N),
			.SYSCLK			(SYSCLK),
			
			.PORT_CS1		(PORT_CS_1[5]),
			.OFFSET_SEL1	(OFFSET_SEL_1),
			.DOUT1			(DIN_5_1),						
			.RD_WR1		    (RD_WR_1),
			.DIN1			(I2C_DOUT_1),
			
			.PORT_CS2		(PORT_CS_2[5]),
			.OFFSET_SEL2	(OFFSET_SEL_2),
			.DOUT2			(DIN_5_2),						
			.RD_WR2		    (RD_WR_2),
			.DIN2			(I2C_DOUT_2),

			.DO0		    (FLT_AMB_LED16 ),
			.DO1		    (FLT_AMB_LED17 ),
			.DO2		    (),
			.DO3		    (),
			.DO4		    (),
			.DO5		    (),
			.DO6		    (),
			.DO7		    (),
			.DO8		    (),
			.DO9		    (),
			.DO10		    (),
			.DO11		    (),
			.DO12		    (),
			.DO13		    (),
			.DO14		    (),
			.DO15		    ()
			);

//IFDET_BLUE_LED 60H 70H
wire    [7:0]  IFDET_BLUE_LED0;
wire    [7:0]  IFDET_BLUE_LED1;
wire    [7:0]  IFDET_BLUE_LED2;
wire    [7:0]  IFDET_BLUE_LED3;
wire    [7:0]  IFDET_BLUE_LED4;
wire    [7:0]  IFDET_BLUE_LED5;
wire    [7:0]  IFDET_BLUE_LED6;
wire    [7:0]  IFDET_BLUE_LED7;
wire    [7:0]  IFDET_BLUE_LED8;
wire    [7:0]  IFDET_BLUE_LED9;
wire    [7:0]  IFDET_BLUE_LED10;
wire    [7:0]  IFDET_BLUE_LED11;
wire    [7:0]  IFDET_BLUE_LED12;
wire    [7:0]  IFDET_BLUE_LED13;
wire    [7:0]  IFDET_BLUE_LED14;
wire    [7:0]  IFDET_BLUE_LED15;
wire    [7:0]  IFDET_BLUE_LED16;
wire    [7:0]  IFDET_BLUE_LED17;

GPO    GPO6_INST (
			.RESET_N		(RESET_N),
			.SYSCLK			(SYSCLK),
			
			.PORT_CS1		(PORT_CS_1[6]),
			.OFFSET_SEL1	(OFFSET_SEL_1),
			.DOUT1			(DIN_6_1),						
			.RD_WR1		    (RD_WR_1),
			.DIN1			(I2C_DOUT_1),
			
			.PORT_CS2		(PORT_CS_2[6]),
			.OFFSET_SEL2	(OFFSET_SEL_2),
			.DOUT2			(DIN_6_2),						
			.RD_WR2		    (RD_WR_2),
			.DIN2			(I2C_DOUT_2),

			.DO0		    (IFDET_BLUE_LED0 ),
			.DO1		    (IFDET_BLUE_LED1 ),
			.DO2		    (IFDET_BLUE_LED2 ),
			.DO3		    (IFDET_BLUE_LED3 ),
			.DO4		    (IFDET_BLUE_LED4 ),
			.DO5		    (IFDET_BLUE_LED5 ),
			.DO6		    (IFDET_BLUE_LED6 ),
			.DO7		    (IFDET_BLUE_LED7 ),
			.DO8		    (IFDET_BLUE_LED8 ),
			.DO9		    (IFDET_BLUE_LED9 ),
			.DO10		    (IFDET_BLUE_LED10),
			.DO11		    (IFDET_BLUE_LED11),
			.DO12		    (IFDET_BLUE_LED12),
			.DO13		    (IFDET_BLUE_LED13),
			.DO14		    (IFDET_BLUE_LED14),
			.DO15		    (IFDET_BLUE_LED15)
			);

GPO    GPO7_INST (
			.RESET_N		(RESET_N),
			.SYSCLK			(SYSCLK),
			
			.PORT_CS1		(PORT_CS_1[7]),
			.OFFSET_SEL1	(OFFSET_SEL_1),
			.DOUT1			(DIN_7_1),						
			.RD_WR1		    (RD_WR_1),
			.DIN1			(I2C_DOUT_1),
			
			.PORT_CS2		(PORT_CS_2[7]),
			.OFFSET_SEL2	(OFFSET_SEL_2),
			.DOUT2			(DIN_7_2),						
			.RD_WR2		    (RD_WR_2),
			.DIN2			(I2C_DOUT_2),

			.DO0		    (IFDET_BLUE_LED16 ),
			.DO1		    (IFDET_BLUE_LED17 ),
			.DO2		    (),
			.DO3		    (),
			.DO4		    (),
			.DO5		    (),
			.DO6		    (),
			.DO7		    (),
			.DO8		    (),
			.DO9		    (),
			.DO10		    (),
			.DO11		    (),
			.DO12		    (),
			.DO13		    (),
			.DO14		    (),
			.DO15		    ()
			);

//CANISTER_A_PCIE_CLK_ACT_L,CANISTER_B_PCIE_CLK_ACT_L 80H CPLD_SLOT_ID 81H
GPI    	GPI8_INST (
			.RESET_N		(RESET_N),
			.SYSCLK			(SYSCLK),
			
			.PORT_CS1		(PORT_CS_1[8]),
			.OFFSET_SEL1	(OFFSET_SEL_1),
			.DOUT1			(DIN_8_1),						
			.RD_WR1		    (RD_WR_1),
			
			.PORT_CS2		(PORT_CS_2[8]),
			.OFFSET_SEL2	(OFFSET_SEL_2),
			.DOUT2			(DIN_8_2),						
			.RD_WR2		    (RD_WR_2),
			
			.DIN0           (  { ~CANISTER_B_PCIE_CLK_ACT_L,~CANISTER_A_PCIE_CLK_ACT_L }  ),
			.DIN1           (  { 7'b0,CPLD_SLOT_ID                                   }  ),
			.DIN2           (  0                          ),
			.DIN3           (  0                          ),
			.DIN4           (  0                          ),			
			.DIN5           (  0                          ),
			.DIN6           (  0                          ),
			.DIN7           (  0                          ),
			.DIN8           (  0                          ),
			.DIN9           (  0                          ),
			.DIN10          (  0                          ),
			.DIN11          (  0                          ),
			.DIN12          (  0                          ),
			.DIN13          (  0                          ),
			.DIN14          (  0                          ),
			.DIN15          (  0                          )
			);

//BB_CPLD_ALT_L 90H
GPI    	GPI9_INST (
			.RESET_N		(RESET_N),
			.SYSCLK			(SYSCLK),
			
			.PORT_CS1		(PORT_CS_1[9]),
			.OFFSET_SEL1	(OFFSET_SEL_1),
			.DOUT1			(DIN_9_1),						
			.RD_WR1		    (RD_WR_1),
			
			.PORT_CS2		(PORT_CS_2[9]),
			.OFFSET_SEL2	(OFFSET_SEL_2),
			.DOUT2			(DIN_9_2),						
			.RD_WR2		    (RD_WR_2),
			
			.DIN0           ( {7'b0,BB_CPLD_ALT_L} ),
			.DIN1           (  0                   ),
			.DIN2           (  0                   ),
			.DIN3           (  0                   ),
			.DIN4           (  0                   ),			
			.DIN5           (  0                   ),
			.DIN6           (  0                   ),
			.DIN7           (  0                   ),
			.DIN8           (  0                   ),
			.DIN9           (  0                   ),
			.DIN10          (  0                   ),
			.DIN11          (  0                   ),
			.DIN12          (  0                   ),
			.DIN13          (  0                   ),
			.DIN14          (  0                   ),
			.DIN15          (  0                   )
			);

// A0H
GPO    GPOA_INST (
			.RESET_N		(RESET_N),
			.SYSCLK			(SYSCLK),
			
			.PORT_CS1		(PORT_CS_1[10]),
			.OFFSET_SEL1	(OFFSET_SEL_1),
			.DOUT1			(DIN_A_1),						
			.RD_WR1		    (RD_WR_1),
			.DIN1			(I2C_DOUT_1),
			
			.PORT_CS2		(PORT_CS_2[10]),
			.OFFSET_SEL2	(OFFSET_SEL_2),
			.DOUT2			(DIN_A_2),						
			.RD_WR2		    (RD_WR_2),
			.DIN2			(I2C_DOUT_2),

			.DO0		    ( STATUS_BOARD_PRSENT ),
			.DO1		    (                     ),
			.DO2		    (                     ),
			.DO3		    (                     ),
			.DO4		    (                     ),
			.DO5		    (                     ),
			.DO6		    (                     ),
			.DO7		    (                     ),
			.DO8		    (                     ),
			.DO9		    (                     ),
			.DO10		    (                     ),
			.DO11		    (                     ),
			.DO12		    (                     ),
			.DO13		    (                     ),
			.DO14		    (                     ),
			.DO15		    (                     )
			);
			
//LED CONTROL
LED_CNT	LED_CNT_INST (
			.SYSCLK				    (SYSCLK),
			.RESET_N			    (RESET_N),
			.CLK_1HZ			    (CLK_1HZ),
			.CLK_2HZ			    (CLK_2HZ),
			.CLK_4HZ			    (CLK_4HZ),
			.CLK_4HZ_500MS		    (CLK_4HZ_500MS),
			.CLK_4HZ_3500MS	        (CLK_4HZ_3500MS),
			.CLK_07S			    (CLK_07S)
			);

//Fault Amber LED
LED FLT_AMB_LED_INST0(
            .SYSCLK					(SYSCLK),
            .RESET_N				(RESET_N),
            .CLK_1HZ				(CLK_1HZ),
            .CLK_2HZ				(CLK_2HZ),
            .CLK_4HZ				(CLK_4HZ),
            .CLK_4HZ_500MS          (CLK_4HZ_500MS),
            .CLK_4HZ_3500MS         (CLK_4HZ_3500MS),
            .CLK_07S				(CLK_07S),
			
            .LED_REG0               (FLT_AMB_LED0),
            .LED_REG1               (FLT_AMB_LED1),
            .LED_REG2               (FLT_AMB_LED2),
            .LED_REG3               (FLT_AMB_LED3),
            .LED_REG4               (FLT_AMB_LED4),
            .LED_REG5               (FLT_AMB_LED5),
            .LED_REG6               (FLT_AMB_LED6),
            .LED_REG7               (FLT_AMB_LED7),
 
            .LED0                   (AMBER_DAT[0]),
            .LED1                   (AMBER_DAT[1]),
            .LED2                   (AMBER_DAT[2]),
            .LED3                   (AMBER_DAT[3]),
            .LED4                   (AMBER_DAT[4]),
            .LED5                   (AMBER_DAT[5]),
            .LED6                   (AMBER_DAT[6]),
            .LED7                   (AMBER_DAT[7]),
            .LED8                   (AMBER_DAT[8]),
            .LED9                   (AMBER_DAT[9]),
            .LED10                   (AMBER_DAT[10]),
            .LED11                   (AMBER_DAT[11]),
            .LED12                   (AMBER_DAT[12]),
            .LED13                   (AMBER_DAT[13]),
            .LED14                   (AMBER_DAT[14]),
            .LED15                  (AMBER_DAT[15])
		);

LED FLT_AMB_LED_INST1(
            .SYSCLK					(SYSCLK),
            .RESET_N				(RESET_N),
            .CLK_1HZ				(CLK_1HZ),
            .CLK_2HZ				(CLK_2HZ),
            .CLK_4HZ				(CLK_4HZ),
            .CLK_4HZ_500MS          (CLK_4HZ_500MS),
            .CLK_4HZ_3500MS         (CLK_4HZ_3500MS),
            .CLK_07S				(CLK_07S),

            .LED_REG0               (FLT_AMB_LED8),
            .LED_REG1               (FLT_AMB_LED9),
            .LED_REG2               (FLT_AMB_LED10),
            .LED_REG3               (FLT_AMB_LED11),
            .LED_REG4               (FLT_AMB_LED12),
            .LED_REG5               (FLT_AMB_LED13),
            .LED_REG6               (FLT_AMB_LED14),
            .LED_REG7               (FLT_AMB_LED15),
 
            .LED0                   (AMBER_DAT[16]),
            .LED1                   (AMBER_DAT[17]),
            .LED2                   (AMBER_DAT[18]),
            .LED3                   (AMBER_DAT[19]),
            .LED4                   (AMBER_DAT[20]),
            .LED5                   (AMBER_DAT[21]),
            .LED6                   (AMBER_DAT[22]),
            .LED7                   (AMBER_DAT[23]),
            .LED8                   (AMBER_DAT[24]),
            .LED9                   (AMBER_DAT[25]),
            .LED10                   (AMBER_DAT[26]),
            .LED11                   (AMBER_DAT[27]),
            .LED12                   (AMBER_DAT[28]),
            .LED13                   (AMBER_DAT[29]),
            .LED14                   (AMBER_DAT[30]),
            .LED15                  (AMBER_DAT[31])
		);

LED FLT_AMB_LED_INST2(
            .SYSCLK					(SYSCLK),
            .RESET_N				(RESET_N),
            .CLK_1HZ				(CLK_1HZ),
            .CLK_2HZ				(CLK_2HZ),
            .CLK_4HZ				(CLK_4HZ),
            .CLK_4HZ_500MS          (CLK_4HZ_500MS),
            .CLK_4HZ_3500MS         (CLK_4HZ_3500MS),
            .CLK_07S				(CLK_07S),

            .LED_REG0               (FLT_AMB_LED16),
            .LED_REG1               (FLT_AMB_LED17),
            .LED_REG2               (),
            .LED_REG3               (),
            .LED_REG4               (),
            .LED_REG5               (),
            .LED_REG6               (),
            .LED_REG7               (),
                                    
            .LED0                   (AMBER_DAT[32]),
            .LED1                   (AMBER_DAT[33]),
            .LED2                   (AMBER_DAT[34]),
            .LED3                   (AMBER_DAT[35]),
            .LED4                   (),
            .LED5                   (),
            .LED6                   (),
            .LED7                   (),
            .LED8                   (),
            .LED9                   (),
            .LED10                  (),
            .LED11                  (),
            .LED12                  (),
            .LED13                  (),
            .LED14                  (),
            .LED15                  ()
		);

//IFDEF BLUE LED
LED IFDET_BLUE_LED_INST0(
            .SYSCLK					(SYSCLK),
            .RESET_N				(RESET_N),
            .CLK_1HZ				(CLK_1HZ),
            .CLK_2HZ				(CLK_2HZ),
            .CLK_4HZ				(CLK_4HZ),
            .CLK_4HZ_500MS          (CLK_4HZ_500MS),
            .CLK_4HZ_3500MS         (CLK_4HZ_3500MS),
            .CLK_07S				(CLK_07S),
			
            .LED_REG0               (IFDET_BLUE_LED0),
            .LED_REG1               (IFDET_BLUE_LED1),
            .LED_REG2               (IFDET_BLUE_LED2),
            .LED_REG3               (IFDET_BLUE_LED3),
            .LED_REG4               (IFDET_BLUE_LED4),
            .LED_REG5               (IFDET_BLUE_LED5),
            .LED_REG6               (IFDET_BLUE_LED6),
            .LED_REG7               (IFDET_BLUE_LED7),
 
            .LED0                   (BLUE_DAT[0]),
            .LED1                   (BLUE_DAT[1]),
            .LED2                   (BLUE_DAT[2]),
            .LED3                   (BLUE_DAT[3]),
            .LED4                   (BLUE_DAT[4]),
            .LED5                   (BLUE_DAT[5]),
            .LED6                   (BLUE_DAT[6]),
            .LED7                   (BLUE_DAT[7]),
            .LED8                   (BLUE_DAT[8]),
            .LED9                   (BLUE_DAT[9]),
            .LED10                   (BLUE_DAT[10]),
            .LED11                   (BLUE_DAT[11]),
            .LED12                   (BLUE_DAT[12]),
            .LED13                   (BLUE_DAT[13]),
            .LED14                   (BLUE_DAT[14]),
            .LED15                  (BLUE_DAT[15])
		);

LED IFDET_BLUE_LED_INST1(
            .SYSCLK					(SYSCLK),
            .RESET_N				(RESET_N),
            .CLK_1HZ				(CLK_1HZ),
            .CLK_2HZ				(CLK_2HZ),
            .CLK_4HZ				(CLK_4HZ),
            .CLK_4HZ_500MS          (CLK_4HZ_500MS),
            .CLK_4HZ_3500MS         (CLK_4HZ_3500MS),
            .CLK_07S				(CLK_07S),

            .LED_REG0               (IFDET_BLUE_LED8),
            .LED_REG1               (IFDET_BLUE_LED9),
            .LED_REG2               (IFDET_BLUE_LED10),
            .LED_REG3               (IFDET_BLUE_LED11),
            .LED_REG4               (IFDET_BLUE_LED12),
            .LED_REG5               (IFDET_BLUE_LED13),
            .LED_REG6               (IFDET_BLUE_LED14),
            .LED_REG7               (IFDET_BLUE_LED15),
 
            .LED0                   (BLUE_DAT[16]),
            .LED1                   (BLUE_DAT[17]),
            .LED2                   (BLUE_DAT[18]),
            .LED3                   (BLUE_DAT[19]),
            .LED4                   (BLUE_DAT[20]),
            .LED5                   (BLUE_DAT[21]),
            .LED6                   (BLUE_DAT[22]),
            .LED7                   (BLUE_DAT[23]),
            .LED8                   (BLUE_DAT[24]),
            .LED9                   (BLUE_DAT[25]),
            .LED10                   (BLUE_DAT[26]),
            .LED11                   (BLUE_DAT[27]),
            .LED12                   (BLUE_DAT[28]),
            .LED13                   (BLUE_DAT[29]),
            .LED14                   (BLUE_DAT[30]),
            .LED15                  (BLUE_DAT[31])
		);

LED IFDET_BLUE_LED_INST2(
            .SYSCLK					(SYSCLK),
            .RESET_N				(RESET_N),
            .CLK_1HZ				(CLK_1HZ),
            .CLK_2HZ				(CLK_2HZ),
            .CLK_4HZ				(CLK_4HZ),
            .CLK_4HZ_500MS          (CLK_4HZ_500MS),
            .CLK_4HZ_3500MS         (CLK_4HZ_3500MS),
            .CLK_07S				(CLK_07S),

            .LED_REG0               (IFDET_BLUE_LED16),
            .LED_REG1               (IFDET_BLUE_LED17),
            .LED_REG2               (),
            .LED_REG3               (),
            .LED_REG4               (),
            .LED_REG5               (),
            .LED_REG6               (),
            .LED_REG7               (),
                                    
            .LED0                   (BLUE_DAT[32]),
            .LED1                   (BLUE_DAT[33]),
            .LED2                   (BLUE_DAT[34]),
            .LED3                   (BLUE_DAT[35]),
            .LED4                   (),
            .LED5                   (),
            .LED6                   (),
            .LED7                   (),
            .LED8                   (),
            .LED9                   (),
            .LED10                  (),
            .LED11                  (),
            .LED12                  (),
            .LED13                  (),
            .LED14                  (),
            .LED15                  ()
		);

//PRESENT LED CONTROL
PRSNT_LED_CTRL PRSNT_LED_CTRL_INST(
            .SYSCLK					(SYSCLK),
            .RESET_N				(RESET_N),
			// Driver present and amber LED inout
			.DRV0_PRSNT_AMBER_LED    (DRV0_PRSNT_AMBER_LED),
			.DRV1_PRSNT_AMBER_LED    (DRV1_PRSNT_AMBER_LED),
			.DRV2_PRSNT_AMBER_LED    (DRV2_PRSNT_AMBER_LED),
			.DRV3_PRSNT_AMBER_LED    (DRV3_PRSNT_AMBER_LED),
			.DRV4_PRSNT_AMBER_LED    (DRV4_PRSNT_AMBER_LED),
			.DRV5_PRSNT_AMBER_LED    (DRV5_PRSNT_AMBER_LED),
			.DRV6_PRSNT_AMBER_LED    (DRV6_PRSNT_AMBER_LED),
			.DRV7_PRSNT_AMBER_LED    (DRV7_PRSNT_AMBER_LED),
			.DRV8_PRSNT_AMBER_LED    (DRV8_PRSNT_AMBER_LED),
			.DRV9_PRSNT_AMBER_LED    (DRV9_PRSNT_AMBER_LED),
			.DRV10_PRSNT_AMBER_LED    (DRV10_PRSNT_AMBER_LED),
			.DRV11_PRSNT_AMBER_LED    (DRV11_PRSNT_AMBER_LED),
			.DRV12_PRSNT_AMBER_LED    (DRV12_PRSNT_AMBER_LED),
			.DRV13_PRSNT_AMBER_LED    (DRV13_PRSNT_AMBER_LED),
			.DRV14_PRSNT_AMBER_LED    (DRV14_PRSNT_AMBER_LED),
			.DRV15_PRSNT_AMBER_LED    (DRV15_PRSNT_AMBER_LED),
			.DRV16_PRSNT_AMBER_LED    (DRV16_PRSNT_AMBER_LED),
			.DRV17_PRSNT_AMBER_LED    (DRV17_PRSNT_AMBER_LED),
			.DRV18_PRSNT_AMBER_LED    (DRV18_PRSNT_AMBER_LED),
			.DRV19_PRSNT_AMBER_LED    (DRV19_PRSNT_AMBER_LED),
			.DRV20_PRSNT_AMBER_LED    (DRV20_PRSNT_AMBER_LED),
			.DRV21_PRSNT_AMBER_LED    (DRV21_PRSNT_AMBER_LED),
			.DRV22_PRSNT_AMBER_LED    (DRV22_PRSNT_AMBER_LED),
			.DRV23_PRSNT_AMBER_LED    (DRV23_PRSNT_AMBER_LED),
			.DRV24_PRSNT_AMBER_LED    (DRV24_PRSNT_AMBER_LED),
			.DRV25_PRSNT_AMBER_LED    (DRV25_PRSNT_AMBER_LED),
			.DRV26_PRSNT_AMBER_LED    (DRV26_PRSNT_AMBER_LED),
			.DRV27_PRSNT_AMBER_LED    (DRV27_PRSNT_AMBER_LED),
			.DRV28_PRSNT_AMBER_LED    (DRV28_PRSNT_AMBER_LED),
			.DRV29_PRSNT_AMBER_LED    (DRV29_PRSNT_AMBER_LED),
			.DRV30_PRSNT_AMBER_LED    (DRV30_PRSNT_AMBER_LED),
			.DRV31_PRSNT_AMBER_LED    (DRV31_PRSNT_AMBER_LED),
			.DRV32_PRSNT_AMBER_LED    (DRV32_PRSNT_AMBER_LED),
			.DRV33_PRSNT_AMBER_LED    (DRV33_PRSNT_AMBER_LED),
			.DRV34_PRSNT_AMBER_LED    (DRV34_PRSNT_AMBER_LED),
			.DRV35_PRSNT_AMBER_LED    (DRV35_PRSNT_AMBER_LED),
            // Driver identify and blue LED inout
			.DRV0_IFDET_BLUE_LED     (DRV0_IFDET_BLUE_LED),
			.DRV1_IFDET_BLUE_LED     (DRV1_IFDET_BLUE_LED),
			.DRV2_IFDET_BLUE_LED     (DRV2_IFDET_BLUE_LED),
			.DRV3_IFDET_BLUE_LED     (DRV3_IFDET_BLUE_LED),
			.DRV4_IFDET_BLUE_LED     (DRV4_IFDET_BLUE_LED),
			.DRV5_IFDET_BLUE_LED     (DRV5_IFDET_BLUE_LED),
			.DRV6_IFDET_BLUE_LED     (DRV6_IFDET_BLUE_LED),
			.DRV7_IFDET_BLUE_LED     (DRV7_IFDET_BLUE_LED),
			.DRV8_IFDET_BLUE_LED     (DRV8_IFDET_BLUE_LED),
			.DRV9_IFDET_BLUE_LED     (DRV9_IFDET_BLUE_LED),
			.DRV10_IFDET_BLUE_LED     (DRV10_IFDET_BLUE_LED),
			.DRV11_IFDET_BLUE_LED     (DRV11_IFDET_BLUE_LED),
			.DRV12_IFDET_BLUE_LED     (DRV12_IFDET_BLUE_LED),
			.DRV13_IFDET_BLUE_LED     (DRV13_IFDET_BLUE_LED),
			.DRV14_IFDET_BLUE_LED     (DRV14_IFDET_BLUE_LED),
			.DRV15_IFDET_BLUE_LED     (DRV15_IFDET_BLUE_LED),
			.DRV16_IFDET_BLUE_LED     (DRV16_IFDET_BLUE_LED),
			.DRV17_IFDET_BLUE_LED     (DRV17_IFDET_BLUE_LED),
			.DRV18_IFDET_BLUE_LED     (DRV18_IFDET_BLUE_LED),
			.DRV19_IFDET_BLUE_LED     (DRV19_IFDET_BLUE_LED),
			.DRV20_IFDET_BLUE_LED     (DRV20_IFDET_BLUE_LED),
			.DRV21_IFDET_BLUE_LED     (DRV21_IFDET_BLUE_LED),
			.DRV22_IFDET_BLUE_LED     (DRV22_IFDET_BLUE_LED),
			.DRV23_IFDET_BLUE_LED     (DRV23_IFDET_BLUE_LED),
			.DRV24_IFDET_BLUE_LED     (DRV24_IFDET_BLUE_LED),
			.DRV25_IFDET_BLUE_LED     (DRV25_IFDET_BLUE_LED),
			.DRV26_IFDET_BLUE_LED     (DRV26_IFDET_BLUE_LED),
			.DRV27_IFDET_BLUE_LED     (DRV27_IFDET_BLUE_LED),
			.DRV28_IFDET_BLUE_LED     (DRV28_IFDET_BLUE_LED),
			.DRV29_IFDET_BLUE_LED     (DRV29_IFDET_BLUE_LED),
			.DRV30_IFDET_BLUE_LED     (DRV30_IFDET_BLUE_LED),
			.DRV31_IFDET_BLUE_LED     (DRV31_IFDET_BLUE_LED),
			.DRV32_IFDET_BLUE_LED     (DRV32_IFDET_BLUE_LED),
			.DRV33_IFDET_BLUE_LED     (DRV33_IFDET_BLUE_LED),
			.DRV34_IFDET_BLUE_LED     (DRV34_IFDET_BLUE_LED),
			.DRV35_IFDET_BLUE_LED     (DRV35_IFDET_BLUE_LED),
            //input
            .AMBER_DAT                  (AMBER_DAT),
			.BLUE_DAT                   (BLUE_DAT),
			//output
			.PRSNT                      (PRSNT),
			.IDENT                      (IDENT)			
        );		

//PCIE RESET CONTROL
PCIE_RST_CTRL  PCIE_RST_CTRL (
            //POWER OK
            .DRV0_PWROK                  (DRV12_PWROK ),
            .DRV1_PWROK                  (DRV13_PWROK ),
            .DRV2_PWROK                  (DRV14_PWROK ),
            .DRV3_PWROK                  (DRV15_PWROK ),
            .DRV4_PWROK                  (DRV16_PWROK ),
            .DRV5_PWROK                  (DRV17_PWROK ),
            .DRV6_PWROK                  (DRV18_PWROK ),
            .DRV7_PWROK                  (DRV19_PWROK ),
            .DRV8_PWROK                  (DRV20_PWROK ),
            .DRV9_PWROK                  (DRV21_PWROK ),
            .DRV10_PWROK                  (DRV22_PWROK ),
            .DRV11_PWROK                  (DRV23_PWROK ),
            .DRV12_PWROK                  (DRV24_PWROK ),
            .DRV13_PWROK                  (DRV25_PWROK ),
            .DRV14_PWROK                  (DRV26_PWROK ),
            .DRV15_PWROK                  (DRV27_PWROK ),
            .DRV16_PWROK                  (DRV28_PWROK ),
            .DRV17_PWROK                  (DRV29_PWROK ),
            .DRV18_PWROK                  (DRV30_PWROK ),
            .DRV19_PWROK                  (DRV31_PWROK ),
            .DRV20_PWROK                  (DRV32_PWROK ),
            .DRV21_PWROK                  (DRV33_PWROK ),
            .DRV22_PWROK                  (DRV34_PWROK ),
            .DRV23_PWROK                  (DRV35_PWROK ),
            //RESET A
            .PE_RST_DRV0_A_L          ( PE_RST_DRV0_A_L ),
            .PE_RST_DRV1_A_L          ( PE_RST_DRV1_A_L ),
            .PE_RST_DRV2_A_L          ( PE_RST_DRV2_A_L ),
            .PE_RST_DRV3_A_L          ( PE_RST_DRV3_A_L ),
            .PE_RST_DRV4_A_L          ( PE_RST_DRV4_A_L ),
            .PE_RST_DRV5_A_L          ( PE_RST_DRV5_A_L ),
            .PE_RST_DRV6_A_L          ( PE_RST_DRV6_A_L ),
            .PE_RST_DRV7_A_L          ( PE_RST_DRV7_A_L ),
            .PE_RST_DRV8_A_L          ( PE_RST_DRV8_A_L ),
            .PE_RST_DRV9_A_L          ( PE_RST_DRV9_A_L ),
            .PE_RST_DRV10_A_L          ( PE_RST_DRV10_A_L ),
            .PE_RST_DRV11_A_L          ( PE_RST_DRV11_A_L ),
            .PE_RST_DRV12_A_L          ( PE_RST_DRV12_A_L ),
            .PE_RST_DRV13_A_L          ( PE_RST_DRV13_A_L ),
            .PE_RST_DRV14_A_L          ( PE_RST_DRV14_A_L ),
            .PE_RST_DRV15_A_L          ( PE_RST_DRV15_A_L ),
            .PE_RST_DRV16_A_L          ( PE_RST_DRV16_A_L ),
            .PE_RST_DRV17_A_L          ( PE_RST_DRV17_A_L ),
            .PE_RST_DRV18_A_L          ( PE_RST_DRV18_A_L ),
            .PE_RST_DRV19_A_L          ( PE_RST_DRV19_A_L ),
            .PE_RST_DRV20_A_L          ( PE_RST_DRV20_A_L ),
            .PE_RST_DRV21_A_L          ( PE_RST_DRV21_A_L ),
            .PE_RST_DRV22_A_L          ( PE_RST_DRV22_A_L ),
            .PE_RST_DRV23_A_L          ( PE_RST_DRV23_A_L ),
            //RESET B
            .PE_RST_DRV0_B_L          ( PE_RST_DRV0_B_L ),
            .PE_RST_DRV1_B_L          ( PE_RST_DRV1_B_L ),
            .PE_RST_DRV2_B_L          ( PE_RST_DRV2_B_L ),
            .PE_RST_DRV3_B_L          ( PE_RST_DRV3_B_L ),
            .PE_RST_DRV4_B_L          ( PE_RST_DRV4_B_L ),
            .PE_RST_DRV5_B_L          ( PE_RST_DRV5_B_L ),
            .PE_RST_DRV6_B_L          ( PE_RST_DRV6_B_L ),
            .PE_RST_DRV7_B_L          ( PE_RST_DRV7_B_L ),
            .PE_RST_DRV8_B_L          ( PE_RST_DRV8_B_L ),
            .PE_RST_DRV9_B_L          ( PE_RST_DRV9_B_L ),
            .PE_RST_DRV10_B_L          ( PE_RST_DRV10_B_L ),
            .PE_RST_DRV11_B_L          ( PE_RST_DRV11_B_L ),
            .PE_RST_DRV12_B_L          ( PE_RST_DRV12_B_L ),
            .PE_RST_DRV13_B_L          ( PE_RST_DRV13_B_L ),
            .PE_RST_DRV14_B_L          ( PE_RST_DRV14_B_L ),
            .PE_RST_DRV15_B_L          ( PE_RST_DRV15_B_L ),
            .PE_RST_DRV16_B_L          ( PE_RST_DRV16_B_L ),
            .PE_RST_DRV17_B_L          ( PE_RST_DRV17_B_L ),
            .PE_RST_DRV18_B_L          ( PE_RST_DRV18_B_L ),
            .PE_RST_DRV19_B_L          ( PE_RST_DRV19_B_L ),
            .PE_RST_DRV20_B_L          ( PE_RST_DRV20_B_L ),
            .PE_RST_DRV21_B_L          ( PE_RST_DRV21_B_L ),
            .PE_RST_DRV22_B_L          ( PE_RST_DRV22_B_L ),
            .PE_RST_DRV23_B_L          ( PE_RST_DRV23_B_L ),
            .SYSCLK					     (SYSCLK),
            .RESET_N				     (RESET_N)
);

//BB_SGPIO
BB_SGPIO  BB_SGPIO_INST (
            // Driver active led input
            .DRV0_ACT_LED                  ( DRV0_ACT_LED ),
            .DRV1_ACT_LED                  ( DRV1_ACT_LED ),
            .DRV2_ACT_LED                  ( DRV2_ACT_LED ),
            .DRV3_ACT_LED                  ( DRV3_ACT_LED ),
            .DRV4_ACT_LED                  ( DRV4_ACT_LED ),
            .DRV5_ACT_LED                  ( DRV5_ACT_LED ),
            .DRV6_ACT_LED                  ( DRV6_ACT_LED ),
            .DRV7_ACT_LED                  ( DRV7_ACT_LED ),
            .DRV8_ACT_LED                  ( DRV8_ACT_LED ),
            .DRV9_ACT_LED                  ( DRV9_ACT_LED ),
            .DRV10_ACT_LED                  ( DRV10_ACT_LED ),
            .DRV11_ACT_LED                  ( DRV11_ACT_LED ),
            .DRV12_ACT_LED                  ( DRV12_ACT_LED ),
            .DRV13_ACT_LED                  ( DRV13_ACT_LED ),
            .DRV14_ACT_LED                  ( DRV14_ACT_LED ),
            .DRV15_ACT_LED                  ( DRV15_ACT_LED ),
            .DRV16_ACT_LED                  ( DRV16_ACT_LED ),
            .DRV17_ACT_LED                  ( DRV17_ACT_LED ),
            .DRV18_ACT_LED                  ( DRV18_ACT_LED ),
            .DRV19_ACT_LED                  ( DRV19_ACT_LED ),
            .DRV20_ACT_LED                  ( DRV20_ACT_LED ),
            .DRV21_ACT_LED                  ( DRV21_ACT_LED ),
            .DRV22_ACT_LED                  ( DRV22_ACT_LED ),
            .DRV23_ACT_LED                  ( DRV23_ACT_LED ),
            .DRV24_ACT_LED                  ( DRV24_ACT_LED ),
            .DRV25_ACT_LED                  ( DRV25_ACT_LED ),
            .DRV26_ACT_LED                  ( DRV26_ACT_LED ),
            .DRV27_ACT_LED                  ( DRV27_ACT_LED ),
            .DRV28_ACT_LED                  ( DRV28_ACT_LED ),
            .DRV29_ACT_LED                  ( DRV29_ACT_LED ),
            .DRV30_ACT_LED                  ( DRV30_ACT_LED ),
            .DRV31_ACT_LED                  ( DRV31_ACT_LED ),
            .DRV32_ACT_LED                  ( DRV32_ACT_LED ),
            .DRV33_ACT_LED                  ( DRV33_ACT_LED ),
            .DRV34_ACT_LED                  ( DRV34_ACT_LED ),
            .DRV35_ACT_LED                  ( DRV35_ACT_LED ),
            .SGPIO_CK                         ( SGPIO_CK                      ),
            .SGPIO_LD                         ( SGPIO_LD                      ),
            .SGPIO_DATA                       ( SGPIO_DATA                    ),
            .SYSCLK					          ( SYSCLK                        ),
            .RESET_N				          ( RESET_N & STATUS_BOARD_PRSENT )
            );

//Heart Beat
reg    [31:0]  CNT;
always@(posedge SYSCLK or negedge RESET_N)
	begin
		if(RESET_N == 1'b0)
			begin
			    CNT                    <= 32'h0;
				HEART                  <= 1'b0;
			end
		else
		    begin
			    CNT                    <= (CNT < `TIME_1S)? (CNT + 32'd1) : 32'd0;
				HEART                  <= (CNT == `TIME_1S)? ~HEART : HEART;
			end
	end
			
endmodule
