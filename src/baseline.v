// This source file contains the baseline version of the timing system without ICG or power aware changes

`timescale 1ns / 1ps
module stopwatch #(
    parameter integer MS_TICK_LIMIT = 99_999)(
    input clk,
    input rst_n,       // Assuming Active Low based on name
    input start_btn,
    input stop_btn,
    input lap_btn,
    output reg [5:0] minutes = 0,
    output reg [5:0] seconds = 0,
    output reg [9:0] milliseconds = 0,
    output reg [5:0] lap_minutes = 0,
    output reg [5:0] lap_seconds = 0,
    output reg [9:0] lap_milliseconds = 0
);

    reg running = 0;
    reg [16:0] clkdiv = 0;

    // Control Logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) 
            running <= 0;
        else if (start_btn) 
            running <= 1;
        else if (stop_btn)  
            running <= 0;
    end

    // Frequency Divider
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) 
            clkdiv <= 0;
        else if (running) begin
            if (clkdiv == MS_TICK_LIMIT) 
                clkdiv <= 0;
            else 
                clkdiv <= clkdiv + 1;
        end else begin
            clkdiv <= 0; // Reset divider when stopped for precision
        end
    end

    wire ms_tick = (running && clkdiv == MS_TICK_LIMIT);

    // Counter Logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            milliseconds <= 0;
            seconds <= 0;
            minutes <= 0;
        end else if (ms_tick) begin
            if (milliseconds == 999) begin
                milliseconds <= 0;
                if (seconds == 59) begin
                    seconds <= 0;
                    minutes <= (minutes == 59) ? 0 : minutes + 1;
                end else seconds <= seconds + 1;
            end else milliseconds <= milliseconds + 1;
        end
    end

    // Lap Logic (Synchronous Edge Detection)
    reg lap_prev;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            lap_prev <= 0;
            {lap_minutes, lap_seconds, lap_milliseconds} <= 0;
        end else begin
            lap_prev <= lap_btn;
            if (lap_btn && !lap_prev) begin // Posedge detect
                lap_minutes <= minutes;
                lap_seconds <= seconds;
                lap_milliseconds <= milliseconds;
            end
        end
    end
endmodule
