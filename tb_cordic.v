`timescale 1ns / 1ps
module tb_cordic;

	// Inputs
	reg clk;
	reg rst;
	reg [7:0] theta;
	reg s_c;
	reg start;

	// Outputs
	wire done;
	wire[7:0] value;

	// Instantiate the Unit Under Test (UUT)
	cordic uut (
		.clk(clk), 
		.rst(rst), 
		.theta(theta), 
		.s_c(s_c), 
		.start(start), 
		.done(done), 
		.value(value)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		theta = 0;
		s_c = 0;
		start = 0;

		// Wait for reset to finish
		@(posedge clk);@(posedge clk);
		rst	= 0;
		theta	= 54;
		s_c	= 1;
		start = 1;
		
		@(posedge clk);
		start	= 0;
			while(~done) begin
					@(posedge clk);
			end
			
		repeat(5000)
		begin
			@(posedge clk);
		end
        

	end
      
	always
	begin
	#10	clk = ~clk;
	end
		
		
		
endmodule

