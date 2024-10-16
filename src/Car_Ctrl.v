module car_Ctrl 
  #(parameter c_GAME_WIDTH=640, // Resolution of the game (Horizontal)
    parameter c_GAME_HEIGHT=480, // Résolution of the game (Vertical)
    parameter c_initial_position = 0, // initial position of the car (0 for the left, c_GAME_WIDTH - 1 for the right)
    parameter c_direction = 0,   // deplacement direction (0 = right, 1 = left)
    parameter c_car_SPEED = 1650000,  // speed of the car
    parameter c_CAR_WIDTH = 32,  // Width of the car setting up
    parameter c_CAR_HEIGHT = 32) // High of the car setting up
  (
    input            i_Clk,
    input            i_Game_Active,
    input [9:0]      i_Col_Count_Div, // Columns counter (10 bits)
    input [9:0]      i_Row_Count_Div, // Lines counter(10 bits)
    input [9:0]      i_car_Y,         // Vertical position (Y) of the car
    output reg       o_Draw_car,      // Indicator to draw the car
    output reg [9:0] o_car_X = 0,     // Horizontal position (X) of the car
    output reg [9:0] o_car_Y = 0      // Vertical position (Y) of the car
  );

  reg [31:0] r_car_Count = 0; // Counter to manage the car speed
  reg [9:0] r_car_X_Prev = 0; // Previous position of the car

  always @(posedge i_Clk)
  begin
    // If the game is not ON, the car is set to the initial position
    if (i_Game_Active == 1'b0)
    begin
      o_car_X      <= c_initial_position; 
      o_car_Y      <= i_car_Y;            
      r_car_X_Prev <= c_initial_position; 
    end
    else
    begin
      // Manage the counter to control the car speed
      if (r_car_Count < c_car_SPEED)
        r_car_Count <= r_car_Count + 1;
      else
      begin
        r_car_Count <= 0;

        r_car_X_Prev <= o_car_X;
        
        // Car deplacement
        if (c_direction == 0)  // If the direction is 0, the car moves to the right
        begin
          if (o_car_X == c_GAME_WIDTH - 1)
            o_car_X <= 0; 
          else
            o_car_X <= o_car_X + 1; 
        end
        else  // If the direction is 1, the car moves to the left
        begin
          if (o_car_X == 0)
            o_car_X <= c_GAME_WIDTH - 1; 
          else
            o_car_X <= o_car_X - 1; 
        end
      end
    end
  end

  // Draw the car in the function of the coordinates X and Y, with the width and height 
  always @(posedge i_Clk)
  begin
    // If the car is in the range of the coordinates X and Y, the car is drawn
    if (i_Col_Count_Div >= o_car_X && i_Col_Count_Div < o_car_X + c_CAR_WIDTH && 
        i_Row_Count_Div >= o_car_Y && i_Row_Count_Div < o_car_Y + c_CAR_HEIGHT) 
      o_Draw_car <= 1'b1; // The car is drawn
    else
      o_Draw_car <= 1'b0; // The car is not drawn
  end

endmodule // car_Ctrl
