//************************************************************************
//**                          Hattrick CPLD 							**
//**                          hattrick_define.v 						**
//************************************************************************ 

//**********************      ChangeList      *****************************


`timescale 1ns/1ns

/************************************************************************
 *																		*
 * 							Globe Parameter								*
 *																		*
 ************************************************************************/
//`define	SIM
`ifdef SIM
`define	CLK_FRQ         32'd25000
`else
`define	CLK_FRQ         32'd25000000
`endif

`define CPLD_MAJ_VER    8'h00
`define CPLD_MIN_VER    8'h06
`define CHECKSUM        8'h0 - `CPLD_MAJ_VER - `CPLD_MIN_VER

`define	I2C_ADDR		7'h61		//8bit address is C2
`define I2C_CHECKSUM	1'b0        //0 means no checksum byte, 1 means one checksum byte after R/W

`define	FLT_DFT			8'b0001_0001
`define	PWR_DFT			8'hff
`define	PWR_EN			1'b0

//LED Blink Code
`define	LED_ON			4'b0000
`define	LED_OFF			4'b0001
`define	LED_ON_L		4'b0001
`define	LED_OFF_L		4'b0000
`define	BLK_1HZ			4'b0010
`define	PWM             4'b0010
`define	BLK_2HZ			4'b0011
`define	BLK_4HZ			4'b0100
`define	BLK_07S			4'b0101
`define	BLK_05S			4'b0110
`define	BLK_35S			4'b0111
`define	ON				1'b1
`define	OFF				1'b0
`define	ON_L			1'b0
`define	OFF_L			1'b1

`define FRQ_100K        32'd125
`define TIME_1S         32'd25000000
`define TIME_100MS      32'd2500000
`define SPINUP_DELAY    2

`define IDLE            ('b1 << 0)
`define ACT_RECV        ('b1 << 1)
`define NULL_RECV1      ('b1 << 2)
`define NULL_RECV2      ('b1 << 3)
`define END             ('b1 << 4)

`define HDD_NUM         8'd15
 
/************************************************************************
 *																		*
 * 							PULI SPECIFIC								*
 *																		*
 ************************************************************************/
 
 `define ALL_ZERO   	8'h00 
 `define READ       		1'b0  
 `define READ       		1'b0  
 `define HIGH       		1'b1  
 `define WRITE      	1'b1  
 `define LOW        		1'b0  
 `define READ_STATUS	1'b0  
 `define READ_DATA	1'b0  
 

/************************************************************************
 *																		*
 * 							EFB REGISTER SET								*
 *																		*
 ************************************************************************/
`define I2C_SLV_addr 					7'b111_0100
 
`define MICO_EFB_I2C_CR						   8'h4a
`define MICO_EFB_I2C_CMDR					   8'h4b
`define MICO_EFB_I2C_BLOR					   8'h4c
`define MICO_EFB_I2C_BHIR					   8'h4d
`define MICO_EFB_I2C_TXDR					   8'h4e
`define MICO_EFB_I2C_SR						   8'h4f
`define MICO_EFB_I2C_GCDR					   8'h50
`define MICO_EFB_I2C_RXDR					   8'h51
`define MICO_EFB_I2C_IRQSR					   8'h52
`define MICO_EFB_I2C_IRQENR					   8'h53

`define MICO_EFB_SPI_CR0						   8'h54 
`define MICO_EFB_SPI_CR1						   8'h55 
`define MICO_EFB_SPI_CR2						   8'h56 
`define MICO_EFB_SPI_BR						   8'h57 
`define MICO_EFB_SPI_CSR						   8'h58 
`define MICO_EFB_SPI_TXDR					   8'h59 
`define MICO_EFB_SPI_SR						   8'h5a 
`define MICO_EFB_SPI_RXDR					   8'h5b 
`define MICO_EFB_SPI_IRQSR					   8'h5c 
`define MICO_EFB_SPI_IRQENR					   8'h5d 

`define MICO_EFB_TIMER_CR0					   8'h5E 
`define MICO_EFB_TIMER_CR1					   8'h5F 
`define MICO_EFB_TIMER_TOP_SET_LO			   8'h60 
`define MICO_EFB_TIMER_TOP_SET_HI			   8'h61 
`define MICO_EFB_TIMER_OCR_SET_LO			   8'h62 
`define MICO_EFB_TIMER_OCR_SET_HI			   8'h63 
`define MICO_EFB_TIMER_CR2					   8'h64 
`define MICO_EFB_TIMER_CNT_SR_LO			   8'h65 
`define MICO_EFB_TIMER_CNT_SR_HI				   8'h66 
`define MICO_EFB_TIMER_TOP_SR_LO			   8'h67 
`define MICO_EFB_TIMER_TOP_SR_HI				   8'h68 
`define MICO_EFB_TIMER_OCR_SR_LO			   8'h69 
`define MICO_EFB_TIMER_OCR_SR_HI			   8'h6A 
`define MICO_EFB_TIMER_ICR_SR_LO				   8'h6B 
`define MICO_EFB_TIMER_ICR_SR_HI				   8'h6C 
`define MICO_EFB_TIMER_SR					   8'h6D 
`define MICO_EFB_TIMER_IRQSR					   8'h6E 
`define MICO_EFB_TIMER_IRQENR				   8'h6F 


/************************************************************************
 *																		*
 * 		EFB I2C CONTROLLER PHYSICAL DEVICE SPECIFIC INFORMATION			*
 *																		*
 ************************************************************************/
// Control Register Bit Masks
`define MICO_EFB_I2C_CR_I2CEN					8'h80 
`define MICO_EFB_I2C_CR_GCEN				   	8'h40 
`define MICO_EFB_I2C_CR_WKUPEN			   		8'h20 
// Status Register Bit Masks
`define MICO_EFB_I2C_SR_TIP						8'h80 
`define MICO_EFB_I2C_SR_BUSY						8'h40 
`define MICO_EFB_I2C_SR_RARC					8'h20 
`define MICO_EFB_I2C_SR_SRW						8'h10 
`define MICO_EFB_I2C_SR_ARBL						8'h08 
`define MICO_EFB_I2C_SR_TRRDY					8'h04 
`define MICO_EFB_I2C_SR_TROE						8'h02 
`define MICO_EFB_I2C_SR_HGC						8'h01 
// Command Register Bit Masks 
`define MICO_EFB_I2C_CMDR_STA					8'h80 
`define MICO_EFB_I2C_CMDR_STO					8'h40 
`define MICO_EFB_I2C_CMDR_RD					8'h20 
`define MICO_EFB_I2C_CMDR_WR					8'h10 
`define MICO_EFB_I2C_CMDR_NACK					8'h08 
`define MICO_EFB_I2C_CMDR_CKSDIS				8'h04 

/************************************************************************
 *																		*
 * 						EFB I2C USER DEFINE								*
 *																		*
 ************************************************************************/
`define MICO_EFB_I2C_TRANSMISSION_DONE			8'h00 
`define MICO_EFB_I2C_TRANSMISSION_ONGOING		8'h80 
`define MICO_EFB_I2C_FREE						8'h00 
`define MICO_EFB_I2C_BUSY						8'h40 
`define MICO_EFB_I2C_ACK_NOT_RCVD				8'h20 
`define MICO_EFB_I2C_ACK_RCVD					8'h00 
`define MICO_EFB_I2C_ARB_LOST					8'h08 
`define MICO_EFB_I2C_ARB_NOT_LOST				8'h00 
`define MICO_EFB_I2C_DATA_READY					8'h04 

/************************************************************************
 *																		*
 * 						State Machine Variables								*
 *																		*
 ************************************************************************/
`define          state0		8'd00     
`define          state1		8'd01    
`define          state2		8'd02    
`define          state3		8'd03    
`define          state4             8'd04    
`define          state5		8'd05    
`define          state6		8'd06    
`define          state7		8'd07    
`define          state8		8'd08    
`define          state9		8'd09    
`define          state10		8'd10    
`define          state11		8'd11    
`define          state12		8'd12    
`define          state13		8'd13    
`define          state14		8'd14    
`define          state15		8'd15    
`define          state16		8'd16    
`define          state17		8'd17    
`define          state18		8'd18    
`define          state19		8'd19    
`define          state20		8'd20    
`define          state21		8'd21    
`define          state22		8'd22    
`define          state23		8'd23    
`define          state24		8'd24    
`define          state25		8'd25    
`define          state26		8'd26    
`define          state27		8'd27    
`define          state28		8'd28    
`define          state29		8'd29    
`define          state30		8'd30
