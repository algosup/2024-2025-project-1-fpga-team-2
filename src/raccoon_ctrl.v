module raccoon_ctrl
  #(parameter c_PLAYER_WIDTH = 32,     // Largeur du raton laveur
    parameter c_PLAYER_HEIGHT = 32,    // Hauteur du raton laveur
    parameter c_GAME_HEIGHT = 480,     // Hauteur de l'écran de jeu
    parameter c_GAME_WIDTH = 640,      // Largeur de l'écran de jeu
    parameter c_SPEED = 10)            // Vitesse de déplacement (en pixels)
  (
   input            i_Clk,              // Signal d'horloge
   input            i_Raccoon_Up,       // Bouton pour mouvement vers le haut
   input            i_Raccoon_Dn,       // Bouton pour mouvement vers le bas
   input            i_Raccoon_lt,       // Bouton pour mouvement vers la gauche
   input            i_Raccoon_rt,       // Bouton pour mouvement vers la droite
   output reg [9:0] o_Raccoon_X,        // Position X du raton laveur
   output reg [9:0] o_Raccoon_Y);       // Position Y du raton laveur

  // Initialisation de la position du raton laveur
  initial begin
    o_Raccoon_X = (c_GAME_WIDTH - c_PLAYER_WIDTH) / 2;  // Centré horizontalement
    o_Raccoon_Y = (c_GAME_HEIGHT - c_PLAYER_HEIGHT) / 2; // Centré verticalement
  end

  reg [19:0] clk_div = 0;  // Diviseur d'horloge simple

  always @(posedge i_Clk) begin
    clk_div <= clk_div + 1;
  end

  reg [9:0] new_x;
  reg [9:0] new_y;

  always @(posedge clk_div[19]) begin
    // Variables temporaires pour la nouvelle position
    new_x = o_Raccoon_X;
    new_y = o_Raccoon_Y;

    // Logique de mouvement du raton laveur avec vitesse paramétrée
    if (i_Raccoon_Up) begin
      new_y = o_Raccoon_Y - c_SPEED; // Déplacer vers le haut
    end
    if (i_Raccoon_Dn) begin
      new_y = o_Raccoon_Y + c_SPEED; // Déplacer vers le bas
    end
    if (i_Raccoon_lt) begin
      new_x = o_Raccoon_X - c_SPEED; // Déplacer vers la gauche
    end
    if (i_Raccoon_rt) begin
      new_x = o_Raccoon_X + c_SPEED; // Déplacer vers la droite
    end

    // Vérification des limites après calcul du mouvement
    if (new_x >= 0 && new_x <= (c_GAME_WIDTH - c_PLAYER_WIDTH)) begin
      o_Raccoon_X <= new_x;  // Appliquer la nouvelle position X seulement si dans les limites
    end
    if (new_y >= 0 && new_y <= (c_GAME_HEIGHT - c_PLAYER_HEIGHT)) begin
      o_Raccoon_Y <= new_y;  // Appliquer la nouvelle position Y seulement si dans les limites
    end
  end
endmodule
