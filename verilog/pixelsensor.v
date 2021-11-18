module PxSensor(
    input logic RESET,
    input logic EXPOSE,
    input logic CLK, //Pixel sensor time unit for draining the reset voltage to the photogate transistor. 
    input logic RAMP,
    input logic READ,
    input logic ERASE,
    inout [7:0]DATA
);

//Declare voltages as real values. These are stored as 64bit quantities, and store the real values. Real values can be in decimal form or scientific form.
real vrst = 1.2;
parameter real vpx = 0.5;
real lsb = 1.2/255;


real cmpin;
logic cmp;
real adc;

logic[7:0] p_data;

//Reset pixel values
always @ (posedge ERASE) begin
    p_data = 0;
    adc = 0;
    cmp = 0;
    cmpin = vrst;
end

//Expose pixel - This drains the voltage at the input of the comparator to the pixel sensor transistor. Depending on the voltage at PG, this ill drain the voltage set by the rstvoltage.
always @ (posedge CLK) begin
    if (EXPOSE) begin
        cmpin = cmpin - vpx*lsb;
    end
    //This can be done one time for the positive edge of EXPOSE, but by doing this for each clock cycle it simulates the real analog circuit
end

//Compare value of comparator to pixel.
always @ (posedge RAMP) begin
    if(adc > cmpin) begin
        cmp <= 0;
    end
    else begin
        adc = adc + lsb;
        cmp <= 1;
    end
end

//Latch memory to current value.
always @* begin
    if(cmp) begin
       p_data <= DATA; 
    end
end

//Dont care value when read = 0

assign DATA = READ ? p_data : 8'bZ;

endmodule
//Read out memory data
