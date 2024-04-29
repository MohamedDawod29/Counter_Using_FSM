//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Mohamed Mabrouk Dawod
// 
// Create Date: 04/30/2024 
// Design Name: 
// Module Name: counter_FSM
// Project Name: counter using FSM
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module counter_FSM #(parameter n = 4)
			(clk,reset_n,up_dn,act,count,ovflw);
			
			input clk,reset_n,act,up_dn;
			output [n-1:0]count;
			output ovflw;
			
			reg [n-1:0] count;
			reg [n-1:0] current_state,next_state;
			
			localparam  idle = 0,count_up = 1,count_down = 2,overflow = 3;
			
			always @ (posedge clk ,negedge reset_n) begin
				if (~reset_n)
					current_state <= idle;
				else
					current_state <= next_state;
			end
			
			always @ (posedge clk ,negedge reset_n) begin
				if (~reset_n)
					count <= 0;
				else
					if (current_state == count_up)
						count <= count + 1 ;
					else if (current_state == count_down)
						count <= count - 1 ;
			end
			
			always @(*) begin
				case (current_state)
					idle: 
					begin
						if (act)
							if (up_dn)
								next_state = count_up;
							else
								next_state = count_down;
						else
							next_state = idle;
					end
					
					
					count_up:
					begin
						if (act)
							if (up_dn)
								if (count == (1 << n) - 1)
									next_state = overflow;
								else
									next_state = count_up;
							else
								if (count == 0)
									next_state = overflow;
								else
									next_state = count_down;
						else
							next_state = idle;
					end
					
					
					count_down:
					begin
						if (act)
							if (up_dn)
								if (count == (1 << n) - 1)
									next_state = overflow;
								else
									next_state = count_up;
							else
								if (count == 0)
									next_state = overflow;
								else
									next_state = count_down;
						else
							next_state = idle;
					end
					
						
					overflow:
					begin
						next_state = overflow;
					end
					
					
					default:
					begin
						next_state = 'bx;
					end
				endcase
			end
			
			assign ovflw = (current_state == overflow) ? 1 : 0 ;

endmodule
					
						
				