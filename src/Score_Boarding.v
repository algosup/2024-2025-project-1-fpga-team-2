module SevenSegmentDisplay
  (input            i_Clk,
   input [7:0]      i_Score,  // 8-bit score input
   output reg [6:0] o_Segment_Units, // 7-segment display for units
   output reg [6:0] o_Segment_Tens); // 7-segment display for tens

  reg [3:0] r_Units;
  reg [3:0] r_Tens;

  always @(posedge i_Clk) begin
    r_Units <= i_Score % 10; // Extract the units digit
    r_Tens  <= i_Score / 10; // Extract the tens digit
  end

  // 7-segment decoder for units
  always @(*) begin
    case (r_Units)
      4'b0000: o_Segment_Units = 7'b1000000; // 0
      4'b0001: o_Segment_Units = 7'b1111001; // 1
      4'b0010: o_Segment_Units = 7'b0100100; // 2
      4'b0011: o_Segment_Units = 7'b0110000; // 3
      4'b0100: o_Segment_Units = 7'b0011001; // 4
      4'b0101: o_Segment_Units = 7'b0010010; // 5
      4'b0110: o_Segment_Units = 7'b0000010; // 6
      4'b0111: o_Segment_Units = 7'b1111000; // 7
      4'b1000: o_Segment_Units = 7'b0000000; // 8
      4'b1001: o_Segment_Units = 7'b0010000; // 9
      default: o_Segment_Units = 7'b1111111; // Error state
    endcase
  end

  // 7-segment decoder for tens
  always @(*) begin
    case (r_Tens)
      4'b0000: o_Segment_Tens = 7'b1000000; // 0
      4'b0001: o_Segment_Tens = 7'b1111001; // 1
      4'b0010: o_Segment_Tens = 7'b0100100; // 2
      4'b0011: o_Segment_Tens = 7'b0110000; // 3
      4'b0100: o_Segment_Tens = 7'b0011001; // 4
      4'b0101: o_Segment_Tens = 7'b0010010; // 5
      4'b0110: o_Segment_Tens = 7'b0000010; // 6
      4'b0111: o_Segment_Tens = 7'b1111000; // 7
      4'b1000: o_Segment_Tens = 7'b0000000; // 8
      4'b1001: o_Segment_Tens = 7'b0010000; // 9
      default: o_Segment_Tens = 7'b1111111; // Error state
    endcase
  end

endmodule
