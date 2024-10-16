module raccoon_ctrl
  #(parameter c_PLAYER_PADDLE_X=0,
    parameter c_PADDLE_HEIGHT=32,
    parameter c_PADDLE_WIDTH=32,
    parameter c_GAME_HEIGHT=480,
    parameter c_GAME_WIDTH=640)
  (input            i_Clk,
   input [9:0]      i_Col_Count_Div,
   input [9:0]      i_Row_Count_Div,
   input            i_Paddle_Up,
   input            i_Paddle_Dn,
   input            i_Paddle_lt,
   input            i_Paddle_rt,
   output reg       o_Draw_Paddle,
   output reg [9:0] o_Paddle_Y,
   output reg [9:0] o_Paddle_X);

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

  // Define the paddle bitmap (32x32)
  reg [31:0] paddle_bitmap [0:31];

//   initial begin
//     // Initialize the paddle bitmap with your desired pattern
//     // Example: a simple square paddle
// // Example: a simple square paddle

//     paddle_bitmap[0]  = 32'b00000000000010000001000000000000;
//     paddle_bitmap[1]  = 32'b00000000000011000011000000000000;
//     paddle_bitmap[2]  = 32'b00000000000011111111000000000000;
//     paddle_bitmap[3]  = 32'b00000000000111011011110000000000;
//     paddle_bitmap[4]  = 32'b00000000001000111100010000000000;
//     paddle_bitmap[5]  = 32'b00000000011100011000111000000000;
//     paddle_bitmap[6]  = 32'b00000000001111110111100000000000;
//     paddle_bitmap[7]  = 32'b00000000000111011111000000000000;
//     paddle_bitmap[8]  = 32'b00000011000001111100000110000000;
//     paddle_bitmap[9]  = 32'b00000001100110000010101100000000;
//     paddle_bitmap[10] = 32'b00000000111111111111111000000000;
//     paddle_bitmap[11] = 32'b00000000011111111111111000000000;
//     paddle_bitmap[12] = 32'b00000000001111111111110000000000;
//     paddle_bitmap[13] = 32'b00000000000111111111100000000000;
//     paddle_bitmap[14] = 32'b00000000000011111111000000000000;
//     paddle_bitmap[15] = 32'b00000000000011111111000000000000;
//     paddle_bitmap[16] = 32'b00000000000011111111000000000000;
//     paddle_bitmap[17] = 32'b00000000000111111111100000000000;
//     paddle_bitmap[18] = 32'b00000000000111111111100000000000;
//     paddle_bitmap[19] = 32'b00000000000111111111100000000000;
//     paddle_bitmap[20] = 32'b00000000111111111111111000000000;
//     paddle_bitmap[21] = 32'b00000001111111111111111111000000;
//     paddle_bitmap[22] = 32'b00000000000111111111100000000000;
//     paddle_bitmap[23] = 32'b00000000000000111000000000000000;
//     paddle_bitmap[24] = 32'b00000000000000011000000000000000;
//     paddle_bitmap[25] = 32'b00000000000000011100000000000000;
//     paddle_bitmap[26] = 32'b00000000000001111100000000000000;
//     paddle_bitmap[27] = 32'b00000000011111110000010000000000;
//     paddle_bitmap[28] = 32'b00000000011100000000111000000000;
//     paddle_bitmap[29] = 32'b00000000111100011111100000000000;
//     paddle_bitmap[30] = 32'b00000000001111111110000000000000;
//     paddle_bitmap[31] = 32'b00000000000000000000000000000000;

//   end

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
        o_Paddle_Y <= o_Paddle_Y - 32;
      else if (i_Paddle_Dn == 1'b1 && o_Paddle_Y < c_GAME_HEIGHT - c_PADDLE_HEIGHT)
        o_Paddle_Y <= o_Paddle_Y + 32;
      else if (i_Paddle_lt == 1'b1 && o_Paddle_X > 0)
        o_Paddle_X <= o_Paddle_X - 32;
      else if (i_Paddle_rt == 1'b1 && o_Paddle_X < c_GAME_WIDTH - c_PADDLE_WIDTH)
        o_Paddle_X <= o_Paddle_X + 32;      
    end
  end

  // Draw the Paddle based on the current paddle position
  always @(posedge i_Clk) begin
    // Vérifie si la position actuelle est dans les limites du paddle en largeur et en hauteur
    if (i_Col_Count_Div >= o_Paddle_X && i_Col_Count_Div < o_Paddle_X + c_PADDLE_WIDTH &&
        i_Row_Count_Div >= o_Paddle_Y && i_Row_Count_Div < o_Paddle_Y + c_PADDLE_HEIGHT) begin
      o_Draw_Paddle <= 1'b1; // Active le dessin du paddle si dans les limites
    end else begin
      o_Draw_Paddle <= 1'b0; // Désactive le dessin sinon
    end
  end

  // // Draw the Paddle based on the current paddle position
  // always @(*) begin
  //   // Calculate the relative position within the paddle bitmap
  //   if (i_Col_Count_Div >= o_Paddle_X && i_Col_Count_Div < o_Paddle_X + c_PADDLE_WIDTH &&
  //       i_Row_Count_Div >= o_Paddle_Y && i_Row_Count_Div < o_Paddle_Y + c_PADDLE_HEIGHT) begin
  //     o_Draw_Paddle <= paddle_bitmap[i_Row_Count_Div - o_Paddle_Y][i_Col_Count_Div - o_Paddle_X];
  //   end else begin
  //     o_Draw_Paddle <= 1'b0;
  //   end
  // end

endmodule 

