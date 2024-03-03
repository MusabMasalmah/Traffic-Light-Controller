module traffic_light(input clk,rst,go,output reg [1:0] Highway_1,Highway_2,Farm_1,Farm_2,output reg [4:0] state_counter);

parameter Green = 2'b00 , Yellow = 2'b01 , Red = 2'b10 , RedYellow = 2'b11	;     //parameters for traffic light colors
	
	
reg[6:0] counter = 0;	//the main counter and its for states time

always @(posedge clk or rst or go)
begin 
	if(rst || (counter == 107))		//if the rst = 1 or the states finished the counter = 0
	begin	
		counter = 0;  
		state_counter = 0;		   //the state counter is to put state number in it
	end	
		
	if(~go);
	
	else
	begin
		case(counter)				//case for the main counter and put the values to traffic light by find the delay in counter
			0: 
			begin	
				Highway_1 = Red;
				Highway_2 = Red;
				Farm_1 = Red;
				Farm_2 = Red;
				state_counter = 0;
			end
			1: 
			begin	
				Highway_1 = RedYellow;
				Highway_2 = RedYellow;
				state_counter = 2;
			end	
			3: 
			begin	
				Highway_1 = Green;
				Highway_2 = Green;
				state_counter = 2;
			end	
			33: 
			begin	
				Highway_2 = Yellow;
				state_counter = 3;
			end	
			35: 
			begin	
				Highway_2 = Red;
				state_counter = 4;
			end	
			45: 
			begin	
				Highway_1 = Yellow;
				state_counter = 5;
			end
			47: 
			begin	
				Highway_1 = Red;
				Highway_2 = Red; 
				state_counter = 6;
			end
			48: 
			begin	
				Farm_1 = RedYellow;
				Farm_2 = RedYellow;
				state_counter = 7;
			end	
			50: 
			begin	
				Farm_1 = Green;
				Farm_2 = Green;	 
				state_counter = 8;
			end
			65: 
			begin	
				Farm_2 = Yellow; 
				state_counter = 9;
			end
			67: 
			begin	
				Farm_2 = Red;	 
				state_counter = 10;
			end
			72: 
			begin	
				Farm_1 = Yellow;
				Farm_2 = RedYellow;
				state_counter = 11;
			end
			74: 
			begin	
				Farm_1 = Red;
				Farm_2 = Green;	  
				state_counter = 12;
			end
			84: 
			begin	
				Farm_2 = Yellow;  
				state_counter = 13;
			end
			86: 
			begin	
				Farm_2 = Red;	  
				state_counter = 14;
			end
			87: 
			begin	
				Highway_2 = RedYellow;
				state_counter = 15;
			end
			89: 
			begin	
				Highway_2 = Green;
				state_counter = 16;
			end
			104: 
			begin	
				Highway_2 = Yellow;
				state_counter = 17;
			end	
		endcase	
		counter = counter + 1;		    
	end	
	
end	
endmodule




module test_generator(output reg clk,rst,go);  //the generetor output is the input of traffic light. and it control the values
	initial begin		//the clk have a rise edge in every	10 time units
		clk = 0;	
		repeat(1500)
		#5 clk = ~clk;
	end	
	initial begin		//try to freez the system by set the values of go = 0 several times
		go = 1;	
		repeat(8)
		#200 go = ~go;
	end	
	initial begin		 //try to reset the system by set the values of rst = 1 several times
		rst = 0;
		#1700 rst = ~rst;
		#100 rst = ~rst;
	end	
	
endmodule






module analyser(input [1:0] Highway_1,Highway_2,Farm_1,Farm_2, input [4:0] state_counter,input rst); //analyser to check the errors		
	
parameter Green = 2'b00 , Yellow = 2'b01 , Red = 2'b10 , RedYellow = 2'b11	;

reg [4:0] check_counter = 0;   //this counter is for check if the state number come from traffic light module is correct or not

always @(state_counter or rst)
begin 
	
	if(state_counter == 0) check_counter = 0;	
	
	if (rst) check_counter = 0;
		
	else if(check_counter != state_counter)	$display("wrong move from state to another state at time = %0t.",$time); //if the state number is wrong, there is a wrong move	
		
	else
	begin
		case(state_counter)  	//case for the state to check if the output of traffic light equal the real values
			0: 
			begin	
				if(Highway_1 != Red || Highway_2 != Red || Farm_1 != Red || Farm_2 != Red)
					$display ("Erorr at state 0 at time = %0t.",$time);
			end
			1: 
			begin
				if(Highway_1 != RedYellow || Highway_2 != RedYellow)
					$display ("Erorr at state 1 at time = %0t.",$time);
			end	
			2: 
			begin	
				if(Highway_1 != Green || Highway_2 != Green)
					$display ("Erorr at state 2 at time = %0t.",$time);
			end	
			3: 
			begin	
				if(Highway_2 != Yellow)
					$display ("Erorr at state 3 at time = %0t.",$time);
			end	
			4: 
			begin
				if(Highway_2 != Red)
					$display ("Erorr at state 4 at time = %0t.",$time);
			end	
			5: 
			begin
				if(Highway_1 != Yellow)
					$display ("Erorr at state 5 at time = %0t.",$time);
			end
			6: 
			begin
				if(Highway_1 != Red || Highway_2 != Red)
					$display ("Erorr at state 6 at time = %0t.",$time);
			end
			7: 
			begin
				if(Farm_1 != RedYellow || Farm_2 != RedYellow)
					$display ("Erorr at state 7 at time = %0t.",$time);
			end	
			8: 
			begin
				if(Farm_1 != Green || Farm_2 != Green)
					$display ("Erorr at state 8 at time = %0t.",$time);
			end
			9: 
			begin
				if(Farm_2 != Yellow)
					$display ("Erorr at state 9 at time = %0t.",$time);
			end
			10: 
			begin
				if(Farm_2 != Red)
					$display ("Erorr at state 10 at time = %0t.",$time);
			end
			11: 
			begin
				if(Farm_1 != Yellow || Farm_2 != RedYellow)
					$display ("Erorr at state 11 at time = %0t.",$time);
			end
			12: 
			begin	
				if(Farm_1 != Red || Farm_2 != Green)
					$display ("Erorr at state 12 at time = %0t.",$time);
			end
			13: 
			begin
				if(Farm_2 != Yellow)
					$display ("Erorr at state 13 at time = %0t.",$time);
			end
			14: 
			begin
				if(Farm_2 != Red)
					$display ("Erorr at state 14 at time = %0t.",$time);
			end							  	
			15: 
			begin
				if(Highway_2 != RedYellow)
					$display ("Erorr at state 15 at time = %0t.",$time);
			end
			16: 
			begin
				if(Highway_2 != Green)
					$display ("Erorr at state 16 at time = %0t.",$time);
			end
			17: 
			begin
				if(Highway_2 != Yellow)
					$display ("Erorr at state 17 at time = %0t.",$time);
			end	
		endcase	
		check_counter = check_counter + 1;
	end	
	
end	
endmodule 	

module test_bench();   //a simple test bench 
	wire clk,rst,go;
	wire [1:0] Highway_1,Highway_2,Farm_1,Farm_2;
	wire [4:0] state_counter;
	
	test_generator TG(clk,rst,go);
	traffic_light TL(clk,rst,go,Highway_1,Highway_2,Farm_1,Farm_2,state_counter);
	analyser ANA(Highway_1,Highway_2,Farm_1,Farm_2,state_counter,rst);
	
endmodule	






