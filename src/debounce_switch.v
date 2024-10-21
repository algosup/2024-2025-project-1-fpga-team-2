module debounce_switch 
  (
    input wire i_Clk,               // Clock input
    input wire i_Switch,            // Noisy switch input
    output reg o_Switch             // Debounced switch output
  );

  parameter c_DEBOUNCE_LIMIT = 250000;  // 10 ms debounce time for a 25 MHz clock
  
  reg [17:0] r_Debounce_Count = 0;  // Counter for debounce
  reg r_State = 1'b0;               // Registered switch state

  always @(posedge i_Clk) begin
    // Switch input is changing, increment counter until stable
    if (i_Switch !== r_State && r_Debounce_Count < c_DEBOUNCE_LIMIT)
      r_Debounce_Count <= r_Debounce_Count + 1;
    // When counter reaches limit, register the new switch state and reset counter
    else if (r_Debounce_Count == c_DEBOUNCE_LIMIT) begin
      r_State <= i_Switch;
      r_Debounce_Count <= 0;
    end else
      r_Debounce_Count <= 0;  // Reset counter if switch is stable
  end

  // Output the debounced state
  assign o_Switch = r_State;

endmodule

// not used 