`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:45:31 11/17/2015 
// Design Name: 
// Module Name:    SPI_interface 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module SPI_IF_accel( 
	input clk,
	input rst,
	input [6:0] mpu_address,		//from MPU9250.v
	input [7:0] mpu_wr_data,		//from MPU9250.v
	input mpu_rd_wr_sel,				//from MPU9250.v for select read or write 
	input start,						//start read/write
	output busy,					//don't be send new address or new data from MPU9250.v 
	output SPI_SS_a,						//sleve_select
	output SPI_CK_a,						//SCLK
	output SPI_DO_a,						//Master out Sleve in						
	input SPI_DI_a,						//Master in Slave out
	output [7:0] mpu_rd_data				//for mpu_read_data @MPU9250_controler
    );
	 
	 reg [7:0] mpu_rd_data_buff; 		//for read data baff from MPU
	 reg [7:0] SPIstate;
	 reg [11:0] counter;		//for SPI_SS
	 reg MPUclk;				//for SPI_SS.  don't stop reversal
	 reg  do_reg;				//SPI_DO 
	 reg  ss_reg;				//SPI_SS
	 reg  ck_reg;				//SPI_CK
	 reg busy_bf;				//=MPU_busy buff
	 reg [4:0] i;				//counter for mpu_address[i]
	 reg [4:0] j;				//counter for mpu_rd_data[j]
	
parameter SPI_HALF_CLK = 50; // 50 clks @ 100MHz to make SPI 1MHz
                         // Atlys/Zedboard 50clks = MPU 1clk 
parameter SPI_CLK = SPI_HALF_CLK*2;

wire halfCLKpassed = (counter == SPI_HALF_CLK-1);

// count 50 clks = SCLK generator
always@(posedge clk)
begin
	if(rst)
	begin
		counter <= 0;
		MPUclk <= 0;
	end
	else
	begin
		if(start==1) begin
			counter <= 0;		
			MPUclk <= 1;			
		end
		else if(halfCLKpassed)begin			
			counter <= 0;		
			MPUclk <= ~MPUclk;
			end
		else begin
			counter <= counter + 1;
		end
	end
end

//for state trans 
always @(posedge clk)
	begin
		if(rst)
		begin
			SPIstate = 0;
		end
		else
		begin		
			case(SPIstate)
				0:if(start == 1) SPIstate = 1;	//INIT
				1:SPIstate = 3;	//for SPI_SS = 0
				3:begin
					if(i==0 && mpu_rd_wr_sel == 1)SPIstate = 4;				//address set
					if(i==0 && mpu_rd_wr_sel == 0)SPIstate = 5;				//address set
				end
				4:if(j==0)SPIstate = 6;				//read or write data
				5:if(j==0)SPIstate = 6;
				6:if(halfCLKpassed)SPIstate = 7;				//HOLD		//FINISH and go to state0 
				7:SPIstate = 0;			//FINISH
			endcase
		end
	end
 
 
always @ (posedge clk)
begin 
	if(rst)
		begin
			do_reg = 0;
			ck_reg = 1;
			ss_reg = 1;
			busy_bf = 0;
			mpu_rd_data_buff = 0;
			i = 16;
			j = 17;
		end
	else
		case(SPIstate)
			0:begin					//INIT
				do_reg = 0;
				ss_reg = 1; 
				busy_bf = 0;
			   i = 16;
				j = 17;
			  end
			1:begin					//ready
					busy_bf = 1;
					ss_reg = 0;
					end
			3:begin					//send mpu_address[i] to MPU9250 with SPI
				if(halfCLKpassed)
				begin
					case (i)
						16:do_reg = mpu_rd_wr_sel;
						14:do_reg = mpu_address[6];
						12:do_reg = mpu_address[5];
						10:do_reg = mpu_address[4];
						8: do_reg = mpu_address[3];
						6: do_reg = mpu_address[2];
						4: do_reg = mpu_address[1];
						2: do_reg = mpu_address[0];
						0: do_reg = 0;
					endcase
					if(i!=0) i=i-1;
				end
			  end
			4:begin				//read SPI_DI from MPU9250 with SPI
				if(halfCLKpassed)
				begin
					case (j)
						16:mpu_rd_data_buff[7] = SPI_DI_a;
						14:mpu_rd_data_buff[6] = SPI_DI_a;
						12:mpu_rd_data_buff[5] = SPI_DI_a;
						10:mpu_rd_data_buff[4] = SPI_DI_a;
						8:mpu_rd_data_buff[3] = SPI_DI_a;
						6:mpu_rd_data_buff[2] = SPI_DI_a;
						4:mpu_rd_data_buff[1] = SPI_DI_a;
						2:mpu_rd_data_buff[0] = SPI_DI_a;						
					endcase
					if(j!=0) j=j-1;
				end
			end	

			5:begin				//write data 
				if(halfCLKpassed)
				begin
					case (j)
						16:do_reg = mpu_wr_data[7]; 
						14:do_reg = mpu_wr_data[6]; 
						12:do_reg = mpu_wr_data[5]; 
						10:do_reg = mpu_wr_data[4]; 
						8:do_reg = mpu_wr_data[3]; 
						6:do_reg = mpu_wr_data[2]; 
						4:do_reg = mpu_wr_data[1]; 
						2:do_reg = mpu_wr_data[0]; 
						0:do_reg = 0;
					endcase
					if(j!=0) j=j-1;
				end
			end
							  
			6:begin				//HOLD
				ck_reg =1;
				do_reg =0;
				ss_reg = 1;
			  end
			  
			7:begin		//FINISH
			end
			
		endcase
end


assign SPI_DO_a = do_reg;
assign SPI_CK_a = MPUclk | ss_reg;
assign SPI_SS_a = ss_reg;
assign busy = busy_bf | start;
assign mpu_rd_data = mpu_rd_data_buff;
endmodule
