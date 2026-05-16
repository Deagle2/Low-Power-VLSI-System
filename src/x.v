module stopwatch #(
    parameter integer COUNT_LIMIT = 99_999 // Assuming 100MHz clock for 1ms tick
)(

    input  wire       clk,
    input  wire       rst_n,
    input  wire       start_btn,
    input  wire       stop_btn,
    input  wire       lap_btn,
    output reg [5:0]  mins = 0,
    output reg [5:0]  secs = 0,
    output reg [9:0]  msecs = 0,
    output reg [5:0]  lap_mins = 0,
    output reg [5:0]  lap_secs = 0,      // Renamed to match logic
    output reg [9:0]  lap_msecs = 0      // Renamed to match logic

);
reg running = 0;
reg [16:0] clkdiv = 0;
reg lap_prev;
 
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
        running <= 0;
    else if (start_btn) 
        running <= 1;
    else if (stop_btn)
        running <= 0;
end
 
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
        clkdiv <= 0;
    else if (running) begin
        if (clkdiv == COUNT_LIMIT) 
            clkdiv <= 0;
        else 
            clkdiv <= clkdiv + 1;
    end else if (clkdiv != 0) begin   
        clkdiv <= 0; //Power aware change ~ IGC? 
    end 
end

wire ms_tick = (running && clkdiv == COUNT_LIMIT);
 
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        msecs <= 0;
        secs <= 0;
        mins <= 0;
    end else if (ms_tick) begin
        if (msecs == 999) begin
            msecs <= 0;
            if (secs == 59) begin
                secs <= 0;
                mins <= (mins == 59) ? 0 : mins + 1;
            end else secs <= secs + 1;
        end else msecs <= msecs + 1;
    end
end

always @(posedge clk or negedge rst_n) begin  
    if (!rst_n) lap_prev <= 0;
    else        lap_prev <= lap_btn;
end
always @(posedge clk or negedge rst_n) begin  
    if (!rst_n)
        {lap_mins, lap_secs, lap_msecs} <= 0;
    else if (lap_btn && !lap_prev) begin
        lap_mins      <= mins;
        lap_secs      <= secs;
        lap_msecs <= msecs;
    end
end

endmodule
