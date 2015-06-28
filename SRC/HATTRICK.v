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
					                 HDD15_INSERT_L,HDD14_INSERT_L,HDD13_INSERT_L,
			// 5v power good
			input     P5V_GD_HDD4,P5V_GD_HDD3,P5V_GD_HDD2,P5V_GD_HDD1,
			          P5V_GD_HDD8,P5V_GD_HDD7,P5V_GD_HDD6,P5V_GD_HDD5,
					  P5V_GD_HDD12,P5V_GD_HDD11,P5V_GD_HDD10,P5V_GD_HDD9,
					               P5V_GD_HDD15,P5V_GD_HDD14,P5V_GD_HDD13,
			// 12v power good
			input     P12V_GD_HDD4,P12V_GD_HDD3,P12V_GD_HDD2,P12V_GD_HDD1,
			          P12V_GD_HDD8,P12V_GD_HDD7,P12V_GD_HDD6,P12V_GD_HDD5,
					  P12V_GD_HDD12,P12V_GD_HDD11,P12V_GD_HDD10,P12V_GD_HDD9,
					               P12V_GD_HDD15,P12V_GD_HDD14,P12V_GD_HDD13,
			// HDD power enable
			output    PWR_EN_HDD4_L,PWR_EN_HDD3_L,PWR_EN_HDD2_L,PWR_EN_HDD1_L,
			          PWR_EN_HDD8_L,PWR_EN_HDD7_L,PWR_EN_HDD6_L,PWR_EN_HDD5_L,
					  PWR_EN_HDD12_L,PWR_EN_HDD11_L,PWR_EN_HDD10_L,PWR_EN_HDD9_L,
					               PWR_EN_HDD15_L,PWR_EN_HDD14_L,PWR_EN_HDD13_L,
			// HDD health led
			output    HDD4_Health_LED,HDD3_Health_LED,HDD2_Health_LED,HDD1_Health_LED,
			          HDD8_Health_LED,HDD7_Health_LED,HDD6_Health_LED,HDD5_Health_LED,
					  HDD12_Health_LED,HDD11_Health_LED,HDD10_Health_LED,HDD9_Health_LED,
					                 HDD15_Health_LED,HDD14_Health_LED,HDD13_Health_LED,
			// HDD fault led
			output    HDD4_FAULT_LED,HDD3_FAULT_LED,HDD2_FAULT_LED,HDD1_FAULT_LED,
			          HDD8_FAULT_LED,HDD7_FAULT_LED,HDD6_FAULT_LED,HDD5_FAULT_LED,
					  HDD12_FAULT_LED,HDD11_FAULT_LED,HDD10_FAULT_LED,HDD9_FAULT_LED,
					                 HDD15_FAULT_LED,HDD14_FAULT_LED,HDD13_FAULT_LED,
            // MINI SAS
            input     A_MODPRESL,A_INTL,A_VACT_OC_L,
            output    A_VMAN_EN_L,A_VACT_EN_L,
			output    A_HEALTH_LED_L,A_FAULT_LED,
			input     B_MODPRESL,B_INTL,B_VACT_OC_L,
            output    B_VMAN_EN_L,B_VACT_EN_L,
			output    B_HEALTH_LED_L,B_FAULT_LED,
            // Enclosure led
			output    ENCLOSURE_HEALTH_LED_L,
			output    ENCLOSURE_FAULT_LED,
			// hardware revision
			input     Sideplane_REV_ID1,Sideplane_REV_ID0,
			// Interrupt
			output    I2C_ALERT_L,
			// heart beat led
            output    HEART			
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

// 00H -- HDD insert and 5V/12V power good
GPI    	GPI0_INST (
			.RESET_N		(RESET_N),
			.SYSCLK			(SYSCLK),
			
			.PORT_CS1		(PORT_CS[0]),
			.OFFSET_SEL1	(OFFSET_SEL),
			.DOUT1			(DIN_0),						
			.RD_WR1		    (RD_WR),
			
			.DIN0           ( {HDD8_INSERT_L,HDD7_INSERT_L,HDD6_INSERT_L,HDD5_INSERT_L,
                              HDD4_INSERT_L,HDD3_INSERT_L,HDD2_INSERT_L,HDD1_INSERT_L}       ),
			.DIN1           (          {1'b0,HDD15_INSERT_L,HDD14_INSERT_L,HDD13_INSERT_L,   
                              HDD12_INSERT_L,HDD11_INSERT_L,HDD10_INSERT_L,HDD9_INSERT_L}    ),
			.DIN2           ( {P5V_GD_HDD8,P5V_GD_HDD7,P5V_GD_HDD6,P5V_GD_HDD5,              
                              P5V_GD_HDD4,P5V_GD_HDD3,P5V_GD_HDD2,P5V_GD_HDD1}			    ),
			.DIN3           (        {1'b0,P5V_GD_HDD15,P5V_GD_HDD14,P5V_GD_HDD13,           
                              P5V_GD_HDD12,P5V_GD_HDD11,P5V_GD_HDD10,P5V_GD_HDD9}	        ),
			.DIN4           ( {P12V_GD_HDD8,P12V_GD_HDD7,P12V_GD_HDD6,P12V_GD_HDD5,              
                              P12V_GD_HDD4,P12V_GD_HDD3,P12V_GD_HDD2,P12V_GD_HDD1}			),			
			.DIN5           (        {1'b0,P12V_GD_HDD15,P12V_GD_HDD14,P12V_GD_HDD13,        
                              P12V_GD_HDD12,P12V_GD_HDD11,P12V_GD_HDD10,P12V_GD_HDD9}	    ),
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

// 10H --- HDD power enable
GPO     # (
            .GPO_DFT        (8'hff)
			)
GPO1_INST  (
			.RESET_N		(RESET_N),
			.SYSCLK			(SYSCLK),
			
			.PORT_CS1		(PORT_CS[1]),
			.OFFSET_SEL1	(OFFSET_SEL),
			.DOUT1			(DIN_1),						
			.RD_WR1		    (RD_WR),
			.DIN1			(I2C_DOUT),
			
			.DO0		    ( {PWR_EN_HDD8_L,PWR_EN_HDD7_L,PWR_EN_HDD6_L,PWR_EN_HDD5_L,
                              PWR_EN_HDD4_L,PWR_EN_HDD3_L,PWR_EN_HDD2_L,PWR_EN_HDD1_L}     ),
			.DO1		    (               {PWR_EN_HDD15_L,PWR_EN_HDD14_L,PWR_EN_HDD13_L,
                              PWR_EN_HDD12_L,PWR_EN_HDD11_L,PWR_EN_HDD10_L,PWR_EN_HDD9_L}  ),
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

// 20H --- HEALTH LED
wire    [7:0]  HEALTH_LED0;
wire    [7:0]  HEALTH_LED1;
wire    [7:0]  HEALTH_LED2;
wire    [7:0]  HEALTH_LED3;
wire    [7:0]  HEALTH_LED4;
wire    [7:0]  HEALTH_LED5;
wire    [7:0]  HEALTH_LED6;
wire    [7:0]  HEALTH_LED7;

GPO       # (
            .GPO_DFT        (8'h01)
			)  
GPO2_INST (
			.RESET_N		(RESET_N),
			.SYSCLK			(SYSCLK),
			
			.PORT_CS1		(PORT_CS[2]),
			.OFFSET_SEL1	(OFFSET_SEL),
			.DOUT1			(DIN_2),						
			.RD_WR1		    (RD_WR),
			.DIN1			(I2C_DOUT),

			.DO0		    ( HEALTH_LED0 ),
			.DO1		    ( HEALTH_LED1 ),
			.DO2		    ( HEALTH_LED2 ),
			.DO3		    ( HEALTH_LED3 ),
			.DO4		    ( HEALTH_LED4 ),
			.DO5		    ( HEALTH_LED5 ),
			.DO6		    ( HEALTH_LED6 ),
			.DO7		    ( HEALTH_LED7 ),
			.DO8		    (),
			.DO9		    (),
			.DO10		    (),
			.DO11		    (),
			.DO12		    (),
			.DO13		    (),
			.DO14		    (),
			.DO15		    ()
			);

// LED CONTROL
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

// HEALTH LED
LED HEALTH_LED_INST(
            .SYSCLK					(SYSCLK),
            .RESET_N				(RESET_N),
            .CLK_1HZ				(CLK_1HZ),
            .CLK_2HZ				(CLK_2HZ),
            .CLK_4HZ				(CLK_4HZ),
            .CLK_4HZ_500MS          (CLK_4HZ_500MS),
            .CLK_4HZ_3500MS         (CLK_4HZ_3500MS),
            .CLK_07S				(CLK_07S),
			
            .LED_REG0               ( HEALTH_LED0 ),
            .LED_REG1               ( HEALTH_LED1 ),
            .LED_REG2               ( HEALTH_LED2 ),
            .LED_REG3               ( HEALTH_LED3 ),
            .LED_REG4               ( HEALTH_LED4 ),
            .LED_REG5               ( HEALTH_LED5 ),
            .LED_REG6               ( HEALTH_LED6 ),
            .LED_REG7               ( HEALTH_LED7 ),
 
            .LED0                   ( HDD1_Health_LED ),
            .LED1                   ( HDD2_Health_LED ),
            .LED2                   ( HDD3_Health_LED ),
            .LED3                   ( HDD4_Health_LED ),
            .LED4                   ( HDD5_Health_LED ),
            .LED5                   ( HDD6_Health_LED ),
            .LED6                   ( HDD7_Health_LED ),
            .LED7                   ( HDD8_Health_LED ),
            .LED8                   ( HDD9_Health_LED ),
            .LED9                   ( HDD10_Health_LED ),
            .LED10                  ( HDD11_Health_LED ),
            .LED11                  ( HDD12_Health_LED ),
            .LED12                  ( HDD13_Health_LED ),
            .LED13                  ( HDD14_Health_LED ),
            .LED14                  ( HDD15_Health_LED ),
            .LED15                  (                  )
		);

// 30H --- FAULT LED
wire    [7:0]  FAULT_LED0;
wire    [7:0]  FAULT_LED1;
wire    [7:0]  FAULT_LED2;
wire    [7:0]  FAULT_LED3;
wire    [7:0]  FAULT_LED4;
wire    [7:0]  FAULT_LED5;
wire    [7:0]  FAULT_LED6;
wire    [7:0]  FAULT_LED7;

GPO         # (
            .GPO_DFT        (8'h01)
			)
GPO3_INST (
			.RESET_N		(RESET_N),
			.SYSCLK			(SYSCLK),
			
			.PORT_CS1		(PORT_CS[3]),
			.OFFSET_SEL1	(OFFSET_SEL),
			.DOUT1			(DIN_3),						
			.RD_WR1		    (RD_WR),
			.DIN1			(I2C_DOUT),

			.DO0		    ( FAULT_LED0 ),
			.DO1		    ( FAULT_LED1 ),
			.DO2		    ( FAULT_LED2 ),
			.DO3		    ( FAULT_LED3 ),
			.DO4		    ( FAULT_LED4 ),
			.DO5		    ( FAULT_LED5 ),
			.DO6		    ( FAULT_LED6 ),
			.DO7		    ( FAULT_LED7 ),
			.DO8		    (),
			.DO9		    (),
			.DO10		    (),
			.DO11		    (),
			.DO12		    (),
			.DO13		    (),
			.DO14		    (),
			.DO15		    ()
			);

// FAULT LED
LED FAULT_LED_INST(
            .SYSCLK					(SYSCLK),
            .RESET_N				(RESET_N),
            .CLK_1HZ				(CLK_1HZ),
            .CLK_2HZ				(CLK_2HZ),
            .CLK_4HZ				(CLK_4HZ),
            .CLK_4HZ_500MS          (CLK_4HZ_500MS),
            .CLK_4HZ_3500MS         (CLK_4HZ_3500MS),
            .CLK_07S				(CLK_07S),
			
            .LED_REG0               ( FAULT_LED0 ),
            .LED_REG1               ( FAULT_LED1 ),
            .LED_REG2               ( FAULT_LED2 ),
            .LED_REG3               ( FAULT_LED3 ),
            .LED_REG4               ( FAULT_LED4 ),
            .LED_REG5               ( FAULT_LED5 ),
            .LED_REG6               ( FAULT_LED6 ),
            .LED_REG7               ( FAULT_LED7 ),
 
            .LED0                   ( HDD1_FAULT_LED ),
            .LED1                   ( HDD2_FAULT_LED ),
            .LED2                   ( HDD3_FAULT_LED ),
            .LED3                   ( HDD4_FAULT_LED ),
            .LED4                   ( HDD5_FAULT_LED ),
            .LED5                   ( HDD6_FAULT_LED ),
            .LED6                   ( HDD7_FAULT_LED ),
            .LED7                   ( HDD8_FAULT_LED ),
            .LED8                   ( HDD9_FAULT_LED ),
            .LED9                   ( HDD10_FAULT_LED ),
            .LED10                  ( HDD11_FAULT_LED ),
            .LED11                  ( HDD12_FAULT_LED ),
            .LED12                  ( HDD13_FAULT_LED ),
            .LED13                  ( HDD14_FAULT_LED ),
            .LED14                  ( HDD15_FAULT_LED ),
            .LED15                  (                  )
		);

// 40H -- MINI SAS Insert/OC/INT
GPI    	GPI4_INST (
			.RESET_N		(RESET_N),
			.SYSCLK			(SYSCLK),
			
			.PORT_CS1		(PORT_CS[4]),
			.OFFSET_SEL1	(OFFSET_SEL),
			.DOUT1			(DIN_4),						
			.RD_WR1		    (RD_WR),
			
			.DIN0           ( {4'h0,B_VACT_OC_L,B_INTL,B_MODPRESL,A_VACT_OC_L,A_INTL,A_MODPRESL} ),
			.DIN1           (0),
			.DIN2           (0),
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

// 50H --- MINI SAS power enable
GPO     # (
            .GPO_DFT        (8'h00)
			)
GPO5_INST   (
			.RESET_N		(RESET_N),
			.SYSCLK			(SYSCLK),
			
			.PORT_CS1		(PORT_CS[5]),
			.OFFSET_SEL1	(OFFSET_SEL),
			.DOUT1			(DIN_5),						
			.RD_WR1		    (RD_WR),
			.DIN1			(I2C_DOUT),
			
			.DO0		    ( {B_VACT_EN_L,B_VMAN_EN_L,A_VACT_EN_L,A_VMAN_EN_L} ),
			.DO1		    (),
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

// 60H --- MINISAS LED
wire    [7:0]  MINISAS_LEDA;
wire    [7:0]  MINISAS_LEDB;
wire    [7:0]  ENCLOSURE_LED;

GPO         # (
            .GPO_DFT        (8'h01)
			)
GPO6_INST (
			.RESET_N		(RESET_N),
			.SYSCLK			(SYSCLK),
			
			.PORT_CS1		(PORT_CS[6]),
			.OFFSET_SEL1	(OFFSET_SEL),
			.DOUT1			(DIN_6),						
			.RD_WR1		    (RD_WR),
			.DIN1			(I2C_DOUT),

			.DO0		    ( MINISAS_LEDA ),
			.DO1		    ( MINISAS_LEDB ),
			.DO2		    ( ENCLOSURE_LED ),
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

// MINISAS LED
LED MINISAS_LED_INST(
            .SYSCLK					(SYSCLK),
            .RESET_N				(RESET_N),
            .CLK_1HZ				(CLK_1HZ),
            .CLK_2HZ				(CLK_2HZ),
            .CLK_4HZ				(CLK_4HZ),
            .CLK_4HZ_500MS          (CLK_4HZ_500MS),
            .CLK_4HZ_3500MS         (CLK_4HZ_3500MS),
            .CLK_07S				(CLK_07S),
			
            .LED_REG0               ( MINISAS_LEDA ),
            .LED_REG1               ( MINISAS_LEDB ),
            .LED_REG2               ( ENCLOSURE_LED ),
            .LED_REG3               (),
            .LED_REG4               (),
            .LED_REG5               (),
            .LED_REG6               (),
            .LED_REG7               (),
 
            .LED0                   ( A_HEALTH_LED_L ),
            .LED1                   ( A_FAULT_LED    ),
            .LED2                   ( B_HEALTH_LED_L ),
            .LED3                   ( B_FAULT_LED    ),
            .LED4                   ( ENCLOSURE_HEALTH_LED_L ),
            .LED5                   ( ENCLOSURE_FAULT_LED ),
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
/*
// 70H --- ENCLOSURE LED
wire    [7:0]  ENCLOSURE_LEDA;
wire    [7:0]  ENCLOSURE_LEDB;

GPO         # (
            .GPO_DFT        (8'h01)
			)
GPO7_INST (
			.RESET_N		(RESET_N),
			.SYSCLK			(SYSCLK),
			
			.PORT_CS1		(PORT_CS[7]),
			.OFFSET_SEL1	(OFFSET_SEL),
			.DOUT1			(DIN_7),						
			.RD_WR1		    (RD_WR),
			.DIN1			(I2C_DOUT),

			.DO0		    ( ENCLOSURE_LEDA ),
			.DO1		    ( ENCLOSURE_LEDB ),
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

// ENCLOSURE LED
LED ENCLOSURE_LED_INST(
            .SYSCLK					(SYSCLK),
            .RESET_N				(RESET_N),
            .CLK_1HZ				(CLK_1HZ),
            .CLK_2HZ				(CLK_2HZ),
            .CLK_4HZ				(CLK_4HZ),
            .CLK_4HZ_500MS          (CLK_4HZ_500MS),
            .CLK_4HZ_3500MS         (CLK_4HZ_3500MS),
            .CLK_07S				(CLK_07S),
			
            .LED_REG0               ( ENCLOSURE_LEDA ),
            .LED_REG1               ( ENCLOSURE_LEDB ),
            .LED_REG2               (),
            .LED_REG3               (),
            .LED_REG4               (),
            .LED_REG5               (),
            .LED_REG6               (),
            .LED_REG7               (),
 
            .LED0                   ( ENCLOSURE_HEALTH_LED_L ),
            .LED1                   ( ENCLOSURE_FAULT_LED    ),
            .LED2                   (),
            .LED3                   (),
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
*/
// 80H --- HW REVISION
GPI    	GPI8_INST (
			.RESET_N		(RESET_N),
			.SYSCLK			(SYSCLK),
			
			.PORT_CS1		(PORT_CS[8]),
			.OFFSET_SEL1	(OFFSET_SEL),
			.DOUT1			(DIN_8),						
			.RD_WR1		    (RD_WR),
			
			.DIN0           ( {6'h0,Sideplane_REV_ID1,Sideplane_REV_ID0} ),
			.DIN1           (0),
			.DIN2           (0),
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

// 90H --- INTERRUPT
INTERRUPT    INTERRUPT_INST (
			.RESET_N		(RESET_N),
			.SYSCLK			(SYSCLK),
			
			.PORT_CS1		(PORT_CS[9]),
			.OFFSET_SEL1	(OFFSET_SEL),
			.DOUT1			(DIN_9),						
			.RD_WR1		    (RD_WR),
			
			.DIN0           ( {HDD8_INSERT_L,HDD7_INSERT_L,HDD6_INSERT_L,HDD5_INSERT_L,
                              HDD4_INSERT_L,HDD3_INSERT_L,HDD2_INSERT_L,HDD1_INSERT_L}       ),
			.DIN1           (          {1'b0,HDD15_INSERT_L,HDD14_INSERT_L,HDD13_INSERT_L,   
                              HDD12_INSERT_L,HDD11_INSERT_L,HDD10_INSERT_L,HDD9_INSERT_L}    ),
			.DIN2           ( {P5V_GD_HDD8,P5V_GD_HDD7,P5V_GD_HDD6,P5V_GD_HDD5,              
                              P5V_GD_HDD4,P5V_GD_HDD3,P5V_GD_HDD2,P5V_GD_HDD1}			    ),
			.DIN3           (        {1'b0,P5V_GD_HDD15,P5V_GD_HDD14,P5V_GD_HDD13,           
                              P5V_GD_HDD12,P5V_GD_HDD11,P5V_GD_HDD10,P5V_GD_HDD9}	        ),
			.DIN4           ( {P12V_GD_HDD8,P12V_GD_HDD7,P12V_GD_HDD6,P12V_GD_HDD5,              
                              P12V_GD_HDD4,P12V_GD_HDD3,P12V_GD_HDD2,P12V_GD_HDD1}			),			
			.DIN5           (        {1'b0,P12V_GD_HDD15,P12V_GD_HDD14,P12V_GD_HDD13,        
                              P12V_GD_HDD12,P12V_GD_HDD11,P12V_GD_HDD10,P12V_GD_HDD9}	    ),
			.DIN6           (0),
			.DIN7           (0),
			.DIN8           (0),
			.DIN9           (0),
			.DIN10          (0),
			.DIN11          (0),
			.DIN12          (0),
			.DIN13          (0),
			.DIN14          (0),
			.DIN15          (0),
			
			.I2C_ALERT_L    (I2C_ALERT_L)
			);
			
// F0H --- HEADER
GPI    	GPIF_INST (
			.RESET_N		(RESET_N),
			.SYSCLK			(SYSCLK),
			
			.PORT_CS1		(PORT_CS[15]),
			.OFFSET_SEL1	(OFFSET_SEL),
			.DOUT1			(DIN_F),						
			.RD_WR1		    (RD_WR),
			
			.DIN0           ( `CPLD_MAJ_VER ),
			.DIN1           ( `CPLD_MIN_VER ),
			.DIN2           ( `CHECKSUM  ),
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

//Heart Beat
// reg    [31:0]  CNT;
// always@(posedge SYSCLK or negedge RESET_N)
	// begin
		// if(RESET_N == 1'b0)
			// begin
			    // CNT                    <= 32'h0;
				// HEART                  <= 1'b0;
			// end
		// else
		    // begin
			    // CNT                    <= (CNT < `TIME_1S)? (CNT + 32'd1) : 32'd0;
				// HEART                  <= (CNT == `TIME_1S)? ~HEART : HEART;
			// end
	// end
assign    HEART = CLK_1HZ;
			
endmodule
