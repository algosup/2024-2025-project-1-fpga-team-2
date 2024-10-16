module Sync_To_Count 
 #(parameter TOTAL_COLS = 800,   // Total of columns (inclued porches)
   parameter TOTAL_ROWS = 525)   // Total of lines (inclued porches)
  (input            i_Clk,       // Principal Clock
   input            i_HSync,     // Signal synchronisation horizontal
   input            i_VSync,     // Signal synchronisation vertical
   output reg       o_HSync = 0, // Exit for synchronisation horizontal
   output reg       o_VSync = 0, // Exit for synchronisation vertical
   output reg [9:0] o_Col_Count = 0,  // Counter of columns
   output reg [9:0] o_Row_Count = 0); // Counter of lines
   
   wire w_Frame_Start;  // Signal to detect the start of the frame
   
   // Synchronisation register to align the exit signals
   always @(posedge i_Clk)
   begin
     o_VSync <= i_VSync;
     o_HSync <= i_HSync;
   end

   // Follow the counters of columns and lines
   always @(posedge i_Clk)
   begin
     if (w_Frame_Start == 1'b1)
     begin
       o_Col_Count <= 0;  // Reset the counter of columns
       o_Row_Count <= 0;  // Reset the counter of lines
     end
     else
     begin
       if (o_Col_Count == TOTAL_COLS-1)  // If we reach the end of the frame
       begin
         if (o_Row_Count == TOTAL_ROWS-1)  // If we reach the end of the frame
         begin
           o_Row_Count <= 0;  // Reset the counter of lines
         end
         else
         begin
           o_Row_Count <= o_Row_Count + 1;  // Increment the lines
         end
         o_Col_Count <= 0;  // Reset the counter of columns
       end
       else
       begin
         o_Col_Count <= o_Col_Count + 1;  // Increment the columns
       end
     end
   end

   // Detection of the rise of the vertical sync signal to reset the counters
   assign w_Frame_Start = (~o_VSync & i_VSync);

endmodule