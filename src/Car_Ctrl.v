module car_Ctrl 
  #(parameter c_GAME_WIDTH=640,         // Largeur du jeu
    parameter c_GAME_HEIGHT=480,
    parameter c_initial_position = 0,   // Position initiale de la voiture
    parameter c_direction = 0,          // Direction de la voiture (0 = droite, 1 = gauche)
    parameter c_car_SPEED = 1650000,    // Vitesse de la voiture
    parameter c_CAR_WIDTH = 64,         // Largeur de la voiture
    parameter c_CAR_HEIGHT = 32)        // Hauteur de la voiture
  (
    input            i_Clk,
    input            i_Game_Active,
    input [9:0]      i_Col_Count_Div,   // Compteur de colonnes (10 bits)
    input [9:0]      i_Row_Count_Div,   // Compteur de lignes (10 bits)
    input [9:0]      i_car_Y,           // Position verticale de la voiture
    output reg       o_Draw_car,        // Indicateur de dessin de la voiture
    output reg [9:0] o_car_X = 0,       // Position horizontale de la voiture
    output reg [9:0] o_car_Y = 0        // Position verticale de la voiture
  );

  reg [31:0] r_car_Count = 0; // Compteur pour contrôler la vitesse du mouvement


  reg [63:0] cars_bitmap [0:31];

  initial begin
    // Initialize the cars bitmap with your desired pattern
    // Example: a simple square cars
// Example: a simple square cars

    cars_bitmap[0]  = 64'b0000000000000000000000000000000000000000000000000000000000000000;
    cars_bitmap[1]  = 64'b0000000000000000000000000000000000000000000000000000000000000000;
    cars_bitmap[2]  = 64'b0000011111011111111111101111111111111111000000000000000000000000;
    cars_bitmap[3]  = 64'b0001100000100000000000010000000000000000100000000000000000000000;
    cars_bitmap[4]  = 64'b0010011111011111111111101111111111111101110000000000000000000000;
    cars_bitmap[5]  = 64'b0101100011100000000000000010000000000010010001111111100000000000;
    cars_bitmap[6]  = 64'b1010000000110000000000000011000000000001011111111111111111111000;
    cars_bitmap[7]  = 64'b1010000000001000000000000001111111000001010010000000010001000100;
    cars_bitmap[8]  = 64'b1010000000001100000000000001000000110001001010000000001010100100;
    cars_bitmap[9]  = 64'b1010000000000100000000000001000000011000101010000000000100011110;
    cars_bitmap[10] = 64'b1010000000000111000000000011000000001000100100000000000100000010;
    cars_bitmap[11] = 64'b1010000000000010111100000110000000001000101000000000000100000001;
    cars_bitmap[12] = 64'b1010000000000110000100001100000000001011001000000000000100000001;
    cars_bitmap[13] = 64'b1010000000001100000010111100000000001101001000000000000100000001;
    cars_bitmap[14] = 64'b1011110000111000000001000110000011111001001000000000000100000001;
    cars_bitmap[15] = 64'b1010011111100000000001100011000111110001001000000000000100000001;
    cars_bitmap[16] = 64'b1010000000110000000000100001100011100101001000000000000100000001;
    cars_bitmap[17] = 64'b1010000000011000000000100000111100000101001000000000000100000001;
    cars_bitmap[18] = 64'b1010000000001000000000100000000010000101001000000000000100000001;
    cars_bitmap[19] = 64'b1010000000011000000001100000000010000101001000000000000100000001;
    cars_bitmap[20] = 64'b1010000000010000000001100000000010000101001000000000000100000001;
    cars_bitmap[21] = 64'b1010000000110000000010000000000110000100101000000000000100000010;
    cars_bitmap[22] = 64'b1010000000100000011101110100011001111100101010000000000100011110;
    cars_bitmap[23] = 64'b1010000000111111110000001111110000000100101010000000001010100100;
    cars_bitmap[24] = 64'b1010000011100000000000001000000000000011010010000000010001000100;
    cars_bitmap[25] = 64'b1010011110000000000000000100000000000001011111111111111111111000;
    cars_bitmap[26] = 64'b0101100000000000000000000101111111111101110001111111100000000000;
    cars_bitmap[27] = 64'b0010011111111111111111101110000000000100000000000000000000000000;
    cars_bitmap[28] = 64'b0001100000000000000000000010000000000000100000000000000000000000;
    cars_bitmap[29] = 64'b0000011111111111111111101111111111101111000000000000000000000000;
    cars_bitmap[30] = 64'b0000000000000000000000000000000000000000000000000000000000000000;
    cars_bitmap[31] = 64'b0000000000000000000000000000000000000000000000000000000000000000;



  end


  always @(posedge i_Clk)
  begin
    // Si le jeu n'est pas actif, on réinitialise la position de la voiture
    if (!i_Game_Active) 
    begin
      o_car_X <= c_initial_position; 
      o_car_Y <= i_car_Y;
    end 
    else 
    begin
      // Gestion du compteur pour la vitesse de la voiture
      if (r_car_Count < c_car_SPEED)
        r_car_Count <= r_car_Count + 1;
      else 
      begin
        r_car_Count <= 0;

        // Déplacement de la voiture selon la direction
        if (c_direction == 0) // Déplacement vers la droite
        begin
          if (o_car_X >= c_GAME_WIDTH - 1)  // Si la voiture atteint le bord droit
            o_car_X <= 0;  // Réapparition à gauche
          else
            o_car_X <= o_car_X + 1;
        end 
        else // Déplacement vers la gauche
        begin
          if (o_car_X == 0)  // Si la voiture atteint le bord gauche
            o_car_X <= c_GAME_WIDTH - 1;  // Réapparition à droite
          else
            o_car_X <= o_car_X - 1;
        end
      end
    end
  end

  // Gestion du dessin de la voiture

// Draw the car based on the current car position
always @(posedge i_Clk) begin
  // Calculate the relative position within the car bitmap
  if (i_Col_Count_Div >= o_car_X && i_Col_Count_Div < o_car_X + c_CAR_WIDTH &&
      i_Row_Count_Div >= o_car_Y && i_Row_Count_Div < o_car_Y + c_CAR_HEIGHT) begin
    o_Draw_car <= cars_bitmap[i_Row_Count_Div - o_car_Y][i_Col_Count_Div - o_car_X];
  end else begin
    o_Draw_car <= 1'b0;
  end
end



endmodule // car_Ctrl
