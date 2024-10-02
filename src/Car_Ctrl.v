module car_Ctrl 
  #(parameter c_GAME_WIDTH=640, // Résolution horizontale du jeu
    parameter c_GAME_HEIGHT=480, // Résolution verticale du jeu
    parameter c_initial_position = 0, // Position initiale de la voiture (0 pour la gauche, c_GAME_WIDTH - 1 pour la droite)
    parameter c_direction = 0,   // Direction de déplacement (0 = droite, 1 = gauche)
    parameter c_car_SPEED = 1650000,  // Vitesse de la voiture
    parameter c_CAR_WIDTH = 32,  // Largeur de la voiture paramétrée
    parameter c_CAR_HEIGHT = 32) // Hauteur de la voiture paramétrée
  (
    input            i_Clk,
    input            i_Game_Active,
    input [9:0]      i_Col_Count_Div, // Compteur de colonnes (10 bits)
    input [9:0]      i_Row_Count_Div, // Compteur de lignes (10 bits)
    input [9:0]      i_car_Y,         // Position verticale (Y) de la voiture
    output reg       o_Draw_car,      // Indicateur pour dessiner la voiture
    output reg [9:0] o_car_X = 0,     // Position horizontale (X) de la voiture
    output reg [9:0] o_car_Y = 0      // Position verticale (Y) de la voiture
  );

  reg [31:0] r_car_Count = 0; // Compteur pour contrôler la vitesse du mouvement
  reg [9:0] r_car_X_Prev = 0; // Position précédente en X de la voiture

  always @(posedge i_Clk)
  begin
    // Si le jeu n'est pas actif, la voiture reste à la position initiale
    if (i_Game_Active == 1'b0)
    begin
      o_car_X      <= c_initial_position; 
      o_car_Y      <= i_car_Y;            
      r_car_X_Prev <= c_initial_position; 
    end
    else
    begin
      // Gestion du compteur pour la vitesse de la voiture
      if (r_car_Count < c_car_SPEED)
        r_car_Count <= r_car_Count + 1;
      else
      begin
        r_car_Count <= 0;

        r_car_X_Prev <= o_car_X;
        
        // Déplacement de la voiture
        if (c_direction == 0)  // Si la direction est 0, la voiture se déplace vers la droite
        begin
          if (o_car_X == c_GAME_WIDTH - 1)
            o_car_X <= 0; 
          else
            o_car_X <= o_car_X + 1; 
        end
        else  // Si la direction est 1, la voiture se déplace vers la gauche
        begin
          if (o_car_X == 0)
            o_car_X <= c_GAME_WIDTH - 1; 
          else
            o_car_X <= o_car_X - 1; 
        end
      end
    end
  end

  // Dessine la voiture en fonction des coordonnées X et Y, avec une largeur et hauteur paramétrables
  always @(posedge i_Clk)
  begin
    // Vérifie si la voiture doit être dessinée en fonction de sa position X et Y
    if (i_Col_Count_Div >= o_car_X && i_Col_Count_Div < o_car_X + c_CAR_WIDTH && 
        i_Row_Count_Div >= o_car_Y && i_Row_Count_Div < o_car_Y + c_CAR_HEIGHT) 
      o_Draw_car <= 1'b1; // La voiture est dessinée
    else
      o_Draw_car <= 1'b0; // La voiture n'est pas dessinée
  end

endmodule // car_Ctrl
