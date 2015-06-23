//************************************************************************
//**                          hattrick      							**
//**                          DELAY.v									**
//************************************************************************

//**********************      ChangeList      *****************************

`include "../SRC/hattrick_define.v"

module DELAY #
	         (
			   parameter    DELAY_TIME = 32'h17D7840    //1s delay at 25MHz
			 )
			 (
			   SYSCLK,RESET_N,
			   EN_IN,    //input signal, when this signal is set to 1, then begin to run timer
			   DISABLE_IN,    //input signal, when there is negedge on this signal, the run timer will up-count to DELAY_TIME, then OUT will be de-asserted.
			   OUT    //when the timer run to 0, then assert this signal. when the timer run to DELAY_TIME, then clear this signal
			 );

input    SYSCLK,RESET_N;
input    EN_IN,DISABLE_IN;

output    OUT;

reg    [15:0] CNT;
reg    EN_IN_D1,EN_IN_D2;
reg    DISABLE_IN_D1,DISABLE_IN_D2;
reg    TIMER_UP,TIMER_DOWN;
reg    OUT;

wire    EN_IN_P = ~EN_IN_D2 & EN_IN_D1;
wire    EN_IN_N = EN_IN_D2 & ~EN_IN_D1;

wire    DISABLE_IN_N = DISABLE_IN_D2 & ~DISABLE_IN_D1;

always@(posedge SYSCLK or negedge RESET_N)
	begin
		if(!RESET_N)
			begin
				EN_IN_D1 <= 1'b0;
				EN_IN_D2 <= 1'b0;
				DISABLE_IN_D1 <= 1'b0;
				DISABLE_IN_D2 <= 1'b0;
			end
		else 
			begin
				{EN_IN_D2,EN_IN_D1} <= {EN_IN_D1,EN_IN};
				{DISABLE_IN_D2,DISABLE_IN_D1} <= {DISABLE_IN_D1,DISABLE_IN};
			end			
	end

always@(posedge SYSCLK or negedge RESET_N)
	begin
		if(!RESET_N)
			begin
			  TIMER_UP <= 1'b0;
			  TIMER_DOWN <= 1'b0;
			end
		else if(EN_IN_N)
			begin
			  TIMER_UP <= 1'b0;
			  TIMER_DOWN <= 1'b0;
            end			  
		else if(DISABLE_IN_N)
			begin
			  TIMER_UP <= 1'b1;
			  TIMER_DOWN <= 1'b0;
			end
		else if(EN_IN_P)
			begin
			  TIMER_UP <= 1'b0;
			  TIMER_DOWN <= 1'b1;
            end			  
	end

always@(posedge SYSCLK or negedge RESET_N)
	begin
		if(!RESET_N)
			CNT[15:0] <= DELAY_TIME;
		else if(EN_IN_N)
			CNT[15:0] <= DELAY_TIME;
		else if(TIMER_UP)
			CNT[15:0] <= (CNT[15:0] == DELAY_TIME)? DELAY_TIME : (CNT[15:0] + 1'b1);
		else if(TIMER_DOWN)
			CNT[15:0] <= (CNT[15:0] == 16'h0)? 16'h0 : (CNT[15:0] - 1'b1);
        else
            CNT[15:0] <= CNT[15:0];
	end

always@(posedge SYSCLK or negedge RESET_N)
	begin
		if(!RESET_N)
			OUT <= 0;
	    else if(CNT[15:0] == 0)
			OUT <= 1;
		else if(CNT[15:0] == DELAY_TIME)
			OUT <= 0;
		else
			OUT <= OUT;
	end
			

endmodule
