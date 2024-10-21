module segment_decoder (
    input i_Clk,                    // Clock signal
    input [3:0] i_Level,            // Current level input
    output reg [6:0] o_Segment      // Output for the 7-segment display
);

    reg [3:0] r_Units;              // Units of the level
    reg [3:0] r_Level;              // Register to store the level value

    always @(posedge i_Clk) begin
        r_Level <= i_Level;         // Update the register with the level value
    end

    always @(*) begin
        // Extract units from the level
        r_Units = r_Level % 10;

        // Decode units for the 7-segment display
        case (r_Units)
            4'b0000: o_Segment = 7'b1000000; // 0
            4'b0001: o_Segment = 7'b1111001; // 1
            4'b0010: o_Segment = 7'b0100100; // 2
            4'b0011: o_Segment = 7'b0110000; // 3
            4'b0100: o_Segment = 7'b0011001; // 4
            4'b0101: o_Segment = 7'b0010010; // 5
            4'b0110: o_Segment = 7'b0000010; // 6
            4'b0111: o_Segment = 7'b1111000; // 7
            4'b1000: o_Segment = 7'b0000000; // 8
            4'b1001: o_Segment = 7'b0010000; // 9
            default: o_Segment = 7'b1111111; // Error
        endcase
    end

endmodule
