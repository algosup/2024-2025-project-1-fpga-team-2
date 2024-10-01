module Frogg_Paddle_Ctrl
  #(parameter c_PLAYER_PADDLE_X=0,
    parameter c_PADDLE_HEIGHT=1,
    parameter c_PADDLE_WIDTH=1,
    parameter c_GAME_HEIGHT=30,
    parameter c_GAME_WIDTH=40)
  (input            i_Clk,
   input [5:0]      i_Col_Count_Div,
   input [5:0]      i_Row_Count_Div,
   input            i_Paddle_Up,
   input            i_Paddle_Dn,
   input            i_Paddle_lt,
   input            i_Paddle_rt,
   output reg       o_Draw_Paddle,
   output reg [5:0] o_Paddle_Y,
   output reg [5:0] o_Paddle_X);

  // Set the Speed of the paddle movement.  
  parameter c_PADDLE_SPEED = 2550000;

  reg [31:0] r_Paddle_Count = 0;

  wire w_Paddle_Count_En;

  // Only allow paddles to move if only one button is pushed.
  assign w_Paddle_Count_En = i_Paddle_Up ^ i_Paddle_Dn ^ i_Paddle_lt ^ i_Paddle_rt;

  // Initialize the paddle position on reset or first clock cycle
  initial begin
    o_Paddle_Y = c_GAME_HEIGHT - c_PADDLE_HEIGHT; // Position the paddle at the bottom
    o_Paddle_X = (c_GAME_WIDTH - c_PADDLE_WIDTH) / 2; // Center the paddle horizontally
  end

  always @(posedge i_Clk) begin
    if (w_Paddle_Count_En == 1'b1) begin
      if (r_Paddle_Count == c_PADDLE_SPEED)
        r_Paddle_Count <= 0;
      else
        r_Paddle_Count <= r_Paddle_Count + 1;
    end

    // Update the Paddle Location slowly
    if (r_Paddle_Count == c_PADDLE_SPEED) begin
      // Paddle movement logic
      if (i_Paddle_Up == 1'b1 && o_Paddle_Y > 0)
        o_Paddle_Y <= o_Paddle_Y - 1;
      else if (i_Paddle_Dn == 1'b1 && o_Paddle_Y < c_GAME_HEIGHT - c_PADDLE_HEIGHT)
        o_Paddle_Y <= o_Paddle_Y + 1;
      else if (i_Paddle_lt == 1'b1 && o_Paddle_X > 0)
        o_Paddle_X <= o_Paddle_X - 1;
      else if (i_Paddle_rt == 1'b1 && o_Paddle_X < c_GAME_WIDTH - c_PADDLE_WIDTH)
        o_Paddle_X <= o_Paddle_X + 1;      
    end
  end

  // Draw the Paddle based on the current paddle position
  always @(posedge i_Clk) begin
    // Draws in a range of columns and rows based on paddle position
    if (i_Col_Count_Div == o_Paddle_X &&
        i_Row_Count_Div >= o_Paddle_Y &&
        i_Row_Count_Div < o_Paddle_Y + c_PADDLE_HEIGHT) // Adjusted to use '<' for height
      o_Draw_Paddle <= 1'b1;
    else
      o_Draw_Paddle <= 1'b0;
  end

endmodule // Frogg_Paddle_Ctrl
