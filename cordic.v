module cordic(
	input 		clk,
	input			rst,
	input[7:0]	theta,
	input 		s_c,
	input 		start,
	output 		done,
	output[7:0]	value
    );

reg					done;
reg[7:0]				value;
reg[7:0] 			x;
reg[7:0] 			y;
reg signed[8:0]	z;
reg[5:0] 			count;

localparam	[1:0]	idle   	 = 2'b00,
						working	 = 2'b01;
						
reg[1:0]		state_reg;

always @(posedge clk,posedge rst)
begin
	if (rst) begin
		state_reg <= idle;
	end else begin	
	case (state_reg)
		idle: begin
					if (start) begin
						state_reg		 	<= working;
					end else begin
						state_reg 	 	<= idle;
					end
				end
		working: begin
					if (count==7) begin
						state_reg 		<= idle;
						done			 	<= 1'b1;
						
						if(~s_c) begin
						value				<= y;
						end else begin
						value				<= x;
						end
					
					end else begin
						state_reg 			<= working;
					end
				end
		default: begin
					state_reg <= idle;
					done		<= 0;
					value		<= 0;
				end
		endcase
		
	end
end

reg[7:0]	angle[20:0];
initial
begin
		angle[0] = 128;
		angle[1] = 76;
		angle[2] = 40;
		angle[3] = 20;
		angle[4] = 10;
		angle[5] = 5;
		angle[6] = 3;
		angle[7] = 1;
		angle[8] = 0;
end



always@(posedge clk, posedge rst)
begin
	if(rst) begin
		x		<= 155;
		y		<= 0;
		count	<= 0;
		z		<= {1'b0,theta};
	end else begin
		case(state_reg)
			idle:	begin
					x		<= 155;
					y		<= 0;
					count	<= 0;
					z		<= {1'b0,theta};
					end
			working:
					begin
					count	<= count+1;
					case(d)
						0: begin
							x	<= x - (y>>(count));
							y	<= y + (x>>(count));
							z	<= z - angle[count];
							end
						1: begin
							x	<= x + (y>>count);
							y	<= y - (x>>count);
							z	<= z + angle[count];
							end
						default: begin
							x	<= x;
							y	<= y;
							z	<= z;
							end
						endcase
					end
			default:
					begin
					x	<= 0;
					y	<= 0;
					z	<= 0;
					count <= 0;
					end
		endcase
	end
end
	 
wire d;
assign d = z[8];
	 


endmodule
