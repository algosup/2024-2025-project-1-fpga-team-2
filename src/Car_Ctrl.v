module car_Ctrl 
  #(parameter c_GAME_WIDTH=40, // Size of the game
    parameter c_GAME_HEIGHT=30) 
  (input            i_Clk,
   input            i_Game_Active,
   input [5:0]      i_Col_Count_Div,
   input [5:0]      i_Row_Count_Div,
   output reg       o_Draw_car,
   output reg [5:0] o_car_X = 0,
   output reg [5:0] o_car_Y = 0);

  // Set the Speed of the car movement.
  parameter c_car_SPEED = 1650000;

  reg [31:0] r_car_Count = 0;

  // New parameter for Y position cycling
  reg [5:0] r_car_Y_counter = 0;

  always @(posedge i_Clk)
  begin
    // If the game is not active, car stays in the middle of
    // screen until the game starts.
    if (i_Game_Active == 1'b0)
    begin
      o_car_X <= c_GAME_WIDTH/2; // Position of the car
      o_car_Y <= c_GAME_HEIGHT/2; // Position of the car
    end
    else
    begin
      // Update the car counter continuously. Car movement
      // update rate is determined by input parameter
      if (r_car_Count < c_car_SPEED)
        r_car_Count <= r_car_Count + 1;
      else
      begin
        r_car_Count <= 0;

        // Move the car left
        if (o_car_X > 0) begin
          o_car_X <= o_car_X - 1; // Move left
        end else begin
          // Reset car to right side and assign a new Y position
          o_car_X <= c_GAME_WIDTH - 1; // Reset position to the right

          // Cycle through Y positions for the car
          if (r_car_Y_counter < (c_GAME_HEIGHT - 1)) begin
            r_car_Y_counter <= r_car_Y_counter + 1; // Increment Y counter
          end else begin
            r_car_Y_counter <= 0; // Reset to 0
          end

          o_car_Y <= r_car_Y_counter; // Assign Y position
        end
      end
    end
  end // always @ (posedge i_Clk)

  // Draws a car at the location determined by X and Y indexes.
  always @(posedge i_Clk)
  begin
    if (i_Col_Count_Div == o_car_X && i_Row_Count_Div == o_car_Y)
      o_Draw_car <= 1'b1;
    else
      o_Draw_car <= 1'b0;
  end

endmodule // car_Ctrl
