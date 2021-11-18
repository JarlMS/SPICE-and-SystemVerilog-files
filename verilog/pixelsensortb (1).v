//Testbench for a 2x2 pixel sensor
`timescale 1ns/1ps

module PxSensor_tb();

    logic clk = 0;
    logic rst = 0;
    parameter integer clk_period = 500;
    parameter integer sim_end = 2400*clk_period;
    parameter integer c_rst = 1500*clk_period;
    always #clk_period clk=~clk;

    parameter real vpx1 = 0.8;
    parameter real vpx2 = 0.5;
    parameter real vpx3 = 0.7;
    parameter real vpx4 = 0.9;

    wire logic anaClk;
    wire logic anaRamp;
    wire logic anaRst;
    
    
    assign anaRst = 1;

    wire erase, expose, read, convert;

    tri[7:0] pxData1;
    tri[7:0] pxData2;
    tri[7:0] pxData3;
    tri[7:0] pxData4;
    

    PxSensor #(.vpx(vpx1)) pixel1(anaRst, expose, anaClk, anaRamp, read, erase, pxData1);
    PxSensor #(.vpx(vpx2)) pixel2(anaRst, expose, anaClk, anaRamp, read, erase, pxData2);
    PxSensor #(.vpx(vpx3)) pixel3(anaRst, expose, anaClk, anaRamp, read, erase, pxData3);
    PxSensor #(.vpx(vpx4)) pixel4(anaRst, expose, anaClk, anaRamp, read, erase, pxData4);

	PxFSM #(.c_erase(5),.c_expose(255),.c_convert(255),.c_read(5),.nRows(2)) FSM(rst, clk, expose, erase, read, convert);

    logic[7:0] data1;
    logic[7:0] data2;
    logic[7:0] data3;
    logic[7:0] data4;

    assign anaRamp = convert ? clk : 0;

    assign anaClk = expose ? clk : 0;

    assign pxData1 = read ? 8'bZ: data1;
    assign pxData2 = read ? 8'bZ: data2;
    assign pxData3 = read ? 8'bZ: data3;
    assign pxData4 = read ? 8'bZ: data4;

    always @ (posedge clk or posedge rst) begin
        if(rst)begin
            data1 = 0;
            data2 = 0;
            data3 = 0;
            data4 = 0;
        end
        if(convert)begin
            data1 = data1 + 1;
            data2 = data2 + 1;
            data3 = data3 + 1;
            data4 = data4 + 1;
        end
        else begin
            data1 = 0;
            data2 = 0;
            data3 = 0;
            data4 = 0;           
        end
    end

    logic[7:0] pxDataOut1;
    logic[7:0] pxDataOut2;
    logic[7:0] pxDataOut3;
    logic[7:0] pxDataOut4;
    
    reg[31:0] outBus;

    always @ (posedge clk or posedge rst) begin
        if(rst)begin
            pxDataOut1 = 0;
            pxDataOut2 = 0;
            pxDataOut3 = 0;
            pxDataOut4 = 0;
            outBus = 0;
        end
        else begin
            if(read)begin
				if(FSM.readReg == 0)begin
					pxDataOut1 <= pxData1;
					pxDataOut2 <= pxData2;
				end
				else if(FSM.readReg == 1)begin
					pxDataOut3 <= pxData3;
					pxDataOut4 <= pxData4;
				end
				outBus = {pxDataOut1,pxDataOut2,pxDataOut3,pxDataOut4};
			end
		end
	end

    initial begin
        rst = 1;

        #clk_period rst = 0;
        

        $dumpfile("PxSensor_tb.vcd");
        $dumpvars(0,PxSensor_tb);
        
        
        
        #c_rst rst = 1;
        
        #(c_rst+10) rst = 0;

        #sim_end $stop;
    end
endmodule

`include "pixelsensor.v"
`include "pixelsensorFSM.v"
