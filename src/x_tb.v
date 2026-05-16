/*
  TIMING ANALYSIS (based on COUNT_LIMIT = 9):
  1. Start: Pressed at 30ns.
  2. Lap 1: Pressed at 2430ns -> Watch shows 0:0:24 (24ms).
  3. Lap 2: Pressed at 5040ns -> Watch shows 0:0:50 (50ms).
  4. Lap 3: Pressed at 103,850ns -> Watch shows 0:1:38 (1 sec, 38ms).
  5. Stop:  Pressed at 105,460ns -> Watch shows 0:1:54 (1 sec, 54ms).
*/
module stopwatch_tb;
    reg clk, rst_n, start_btn, stop_btn, lap_btn;
    wire [5:0] mins, secs, l_mins, l_secs;
    wire [9:0] msecs, l_msecs;

    stopwatch #(.COUNT_LIMIT(9)) uut ( 
    .clk(clk), 
    .rst_n(rst_n),
    .start_btn(start_btn), 
    .stop_btn(stop_btn), 
    .lap_btn(lap_btn),
    .mins(mins),        // Fixed name
    .secs(secs),        // Fixed name
    .msecs(msecs),      // Fixed name
    .lap_mins(l_mins),  // Fixed name
    .lap_secs(l_secs),  // Fixed name
    .lap_msecs(l_msecs) // Fixed name
);

    // 100MHz Clock
    always #5 clk = ~clk;

    // Clean Monitor Logic
    // We use the wire names (mins, secs, msecs) defined in this testbench
    always @(posedge clk) begin
        if (start_btn || stop_btn || lap_btn || (msecs == 0 && uut.ms_tick)) begin
            $display("Time: %0t | Watch: %0d:%0d:%0d | Lap: %0d:%0d:%0d", 
                     $time, mins, secs, msecs, l_mins, l_secs, l_msecs);
        end
    end

    initial begin
        // VCD Dumping for Waveform viewing
        $dumpfile("Wave2.vcd"); 
        $dumpvars(0, stopwatch_tb);

        // 1. Initialize and Reset
        clk = 0; rst_n = 0; start_btn = 0; stop_btn = 0; lap_btn = 0;
        #20 rst_n = 1;
        
        // 2. Start
        $display("--- Starting Stopwatch ---");
        #10 start_btn = 1; #10 start_btn = 0;

        // 3. Lap at 24ms (2400ns)
        #2400; 
        $display("--- Pressing Lap at 24ms ---");
        lap_btn = 1; #10 lap_btn = 0;

        // 4. Lap at 50ms total (+2600ns)
        #2600;
        $display("--- Pressing Lap at 50ms ---");
        lap_btn = 1; #10 lap_btn = 0;

        // 5. Lap at 1s 38ms (+98800ns)
        #98800;
        $display("--- Pressing Lap at 1.038s ---");
        lap_btn = 1; #10 lap_btn = 0;

        // 6. Stop at 1s 54ms (+1600ns)
        #1600;
        $display("--- Pressing Stop at 1.054s ---");
        stop_btn = 1; #10 stop_btn = 0;

        #100;
        $display("Simulation Finished at %0t", $time);
        $finish;
    end
endmodule


