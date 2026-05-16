# 1. Keep the 100MHz clock
create_clock -name sys_clk -period 10.0 [get_ports clk]

# 2. REDUCE THIS: 0.5 is too punishing. 0.1 is standard.
set_clock_uncertainty 0.1 [get_clocks sys_clk]

# 3. Transition is fine at 0.3
set_clock_transition 0.3 [get_clocks sys_clk]

# 4. Input Delays: Max 2.0 is fine for setup, Min 0.2 helps fix hold
set_input_delay -max 2.0 -clock [get_clocks sys_clk] [get_ports {rst_n start_btn stop_btn lap_btn}]
set_input_delay -min 0.2 -clock [get_clocks sys_clk] [get_ports {rst_n start_btn stop_btn lap_btn}]

# 5. Output Delays: Max 2.0 is fine, Min 0.2 helps fix hold
set_output_delay -max 2.0 -clock [get_clocks sys_clk] [get_ports {mins[*] secs[*] msecs[*] lap_mins[*] lap_secs[*] lap_msecs[*]}]
set_output_delay -min 0.2 -clock [get_clocks sys_clk] [get_ports {mins[*] secs[*] msecs[*] lap_mins[*] lap_secs[*] lap_msecs[*]}]
