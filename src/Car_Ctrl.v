module car_Ctrl 
  #(parameter c_GAME_WIDTH=640,         // Largeur du jeu
    parameter c_initial_position = 0,   // Position initiale de la voiture
    parameter c_direction = 0,          // Direction de la voiture (0 = droite, 1 = gauche)
    parameter c_car_SPEED = 1650000,    // Vitesse de la voiture
    parameter c_CAR_WIDTH = 32,         // Largeur de la voiture
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
  always @(posedge i_Clk)
  begin
    // On dessine la voiture uniquement si les coordonnées correspondent à la zone où elle se trouve
    o_Draw_car <= (i_Col_Count_Div >= o_car_X && i_Col_Count_Div < o_car_X + c_CAR_WIDTH &&
                   i_Row_Count_Div >= o_car_Y && i_Row_Count_Div < o_car_Y + c_CAR_HEIGHT);
  end

endmodule // car_Ctrl
