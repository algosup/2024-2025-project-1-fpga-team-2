module Frogg_Top
  (input  i_Clk,       // Main Clock

   // Push BUttons
   input  i_Switch_1,
   input  i_Switch_2,
   input  i_Switch_3,
   input  i_Switch_4,

   // VGA
   output o_VGA_HSync,
   output o_VGA_VSync,
   output o_VGA_Red_0,
   output o_VGA_Red_1,
   output o_VGA_Red_2,
   output o_VGA_Grn_0,
   output o_VGA_Grn_1,
   output o_VGA_Grn_2,
   output o_VGA_Blu_0,
   output o_VGA_Blu_1,
   output o_VGA_Blu_2,

   // 7-segment display outputs
   output [6:0] o_Segment_Units,
   output [6:0] o_Segment_Tens,

   output o_LED_1,
   output o_LED_2,
   output o_LED_3,
   output o_LED_4
   );
   
  // VGA Constants to set Frame Size
  parameter c_VIDEO_WIDTH = 3;
  parameter c_TOTAL_COLS  = 800;
  parameter c_TOTAL_ROWS  = 525;
  parameter c_ACTIVE_COLS = 640;
  parameter c_ACTIVE_ROWS = 480;
    
  // Common VGA Signals
  wire [c_VIDEO_WIDTH-1:0] w_Red_Video_Frogg, w_Red_Video_Porch;
  wire [c_VIDEO_WIDTH-1:0] w_Grn_Video_Frogg, w_Grn_Video_Porch;
  wire [c_VIDEO_WIDTH-1:0] w_Blu_Video_Frogg, w_Blu_Video_Porch;

  wire w_HSync_VGA, w_VSync_VGA;
  wire w_HSync_Frogg, w_VSync_Frogg;
  wire w_Switch_1, w_Switch_2, w_Switch_3, w_Switch_4;

  wire [7:0] w_Score; // Score wire
   
  // Generates Sync Pulses to run VGA
  VGA_Sync_Pulses #(.TOTAL_COLS(c_TOTAL_COLS),
                    .TOTAL_ROWS(c_TOTAL_ROWS),
                    .ACTIVE_COLS(c_ACTIVE_COLS),
                    .ACTIVE_ROWS(c_ACTIVE_ROWS)) VGA_Sync_Pulses_Inst 
  (.i_Clk(i_Clk),
   .o_HSync(w_HSync_VGA),
   .o_VSync(w_VSync_VGA),
   .o_Col_Count(),
   .o_Row_Count()
  );
  
  // Debounce All Switches
  Debounce_Switch Switch_1
    (.i_Clk(i_Clk),
     .i_Switch(i_Switch_1),
     .o_Switch(w_Switch_1));
  
  Debounce_Switch Switch_2
    (.i_Clk(i_Clk),
     .i_Switch(i_Switch_2),
     .o_Switch(w_Switch_2));
  
  Debounce_Switch Switch_3
    (.i_Clk(i_Clk),
     .i_Switch(i_Switch_3),
     .o_Switch(w_Switch_3));
  
  Debounce_Switch Switch_4
    (.i_Clk(i_Clk),
     .i_Switch(i_Switch_4),
     .o_Switch(w_Switch_4));
  
  Frogg_Game #(.c_TOTAL_COLS(c_TOTAL_COLS),
             .c_TOTAL_ROWS(c_TOTAL_ROWS),
             .c_ACTIVE_COLS(c_ACTIVE_COLS),
             .c_ACTIVE_ROWS(c_ACTIVE_ROWS)) Frogg_Inst
  (.i_Clk(i_Clk),
   .i_HSync(w_HSync_VGA),
   .i_VSync(w_VSync_VGA),
   .i_Game_Start(w_Switch_1 & w_Switch_2 & w_Switch_3 & w_Switch_4),
   .i_Paddle_Up_P1(w_Switch_1),
   .i_Paddle_Dn_P1(w_Switch_2),
   .i_Paddle_lt_P1(w_Switch_3),
   .i_Paddle_rt_P1(w_Switch_4),
  //  .i_Paddle_Up_P2(w_Switch_3),
  //  .i_Paddle_Dn_P2(w_Switch_4),
   .o_HSync(w_HSync_Frogg),
   .o_VSync(w_VSync_Frogg),
   .o_Red_Video(w_Red_Video_Frogg),
   .o_Grn_Video(w_Grn_Video_Frogg),
   .o_Blu_Video(w_Blu_Video_Frogg),
   .o_Score(w_Score));
	
  VGA_Sync_Porch  #(.VIDEO_WIDTH(c_VIDEO_WIDTH),
                    .TOTAL_COLS(c_TOTAL_COLS),
                    .TOTAL_ROWS(c_TOTAL_ROWS),
                    .ACTIVE_COLS(c_ACTIVE_COLS),
                    .ACTIVE_ROWS(c_ACTIVE_ROWS))
  VGA_Sync_Porch_Inst
   (.i_Clk(i_Clk),
    .i_HSync(w_HSync_Frogg),
    .i_VSync(w_VSync_Frogg),
    .i_Red_Video(w_Red_Video_Frogg),
    .i_Grn_Video(w_Grn_Video_Frogg),
    .i_Blu_Video(w_Blu_Video_Frogg),
    .o_HSync(o_VGA_HSync),
    .o_VSync(o_VGA_VSync),
    .o_Red_Video(w_Red_Video_Porch),
    .o_Grn_Video(w_Grn_Video_Porch),
    .o_Blu_Video(w_Blu_Video_Porch));
	  
  // 7-segment display logic
  SevenSegmentDisplay SevenSegmentDisplay_Inst
    (.i_Clk(i_Clk),
     .i_Score(w_Score),        // Pass the score
     .o_Segment_Units(o_Segment_Units),
     .o_Segment_Tens(o_Segment_Tens));

  assign o_VGA_Red_0 = w_Red_Video_Porch[0];
  assign o_VGA_Red_1 = w_Red_Video_Porch[1];
  assign o_VGA_Red_2 = w_Red_Video_Porch[2];
  
  assign o_VGA_Grn_0 = w_Grn_Video_Porch[0];
  assign o_VGA_Grn_1 = w_Grn_Video_Porch[1];
  assign o_VGA_Grn_2 = w_Grn_Video_Porch[2];

  assign o_VGA_Blu_0 = w_Blu_Video_Porch[0];
  assign o_VGA_Blu_1 = w_Blu_Video_Porch[1];
  assign o_VGA_Blu_2 = w_Blu_Video_Porch[2];

  assign o_LED_1 = w_Switch_1;
  assign o_LED_2 = w_Switch_2;
  assign o_LED_3 = w_Switch_3;
  assign o_LED_4 = w_Switch_4;

endmodule
