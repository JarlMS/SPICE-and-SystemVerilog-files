`timescale  1ns/1ps

module PxFSM(
    input logic rst,
    input logic clk,
    output logic expose,
    output logic erase,
    output logic read,
    output logic convert
);


//State durations in clock cycles
parameter integer c_erase = 5;
parameter integer c_expose = 255;
parameter integer c_convert = 255;
parameter integer c_read = 5;

parameter ERASE = 0, EXPOSE = 1, CONVERT = 2, READ = 3, IDLE = 4;

//We define one read cycle as 5 clock cycles
integer nRead = 0;
integer readReg = 0;
//Number of cell rows to be read
parameter integer nRows = 2;

logic convert_stop;
logic[2:0] state, next_state;
integer counter;

always @ (negedge clk) begin
    case(state)
        ERASE: begin
            erase <= 1;
            read <= 0;
            expose <= 0;
            convert <= 0;
        end
        EXPOSE: begin
            erase <= 0;
            read <= 0;
            expose <= 1;
            convert <= 0;
        end
        CONVERT: begin
            erase <= 0;
            read <= 0;
            expose <= 0;
            convert <= 1;
        end
        READ: begin
            erase <= 0;
            expose <= 0;
            convert <= 0;
            read <= 1;
        end
        IDLE: begin
            erase <= 0;
            read <= 0;
            expose <= 0;
            convert <= 0;
        end
    endcase
end

always @ (posedge clk or posedge rst)begin
    if(rst)begin
        state = IDLE;
        next_state = ERASE;
        counter = 0;
        convert = 0;
    end
    else begin
        case(state)
            ERASE: begin
                if(counter == c_erase) begin
					next_state <= EXPOSE;
                    state <= IDLE;
                end
            end
            EXPOSE: begin
                if(counter == c_expose) begin
                    next_state <= CONVERT;
                    state <= IDLE;
                end
            end
            CONVERT: begin
                if(counter == c_convert) begin
                    next_state <= READ;
                    state <= IDLE;
                end
            end
            READ: begin
                if(counter == nRows*c_read)begin
					next_state <= ERASE;
					state <= IDLE;
					readReg = 0;
					nRead = 0;
				end
				else begin
					if(counter == ((nRead+1)*c_read)+1)begin
						readReg = readReg + 1;
						nRead = nRead + 1;
					end
				end
            end
            IDLE: begin
                state <= next_state;
            end
        endcase
        if(state == IDLE) begin
			counter = 0;
		end
		else begin
			counter = counter + 1;
		end
    end
end

endmodule
