module raccoon_ctrl
  #(parameter c_PLAYER_WIDTH = 32,     // Largeur du raton laveur
    parameter c_PLAYER_HEIGHT = 32,    // Hauteur du raton laveur
    parameter c_GAME_HEIGHT = 480,     // Hauteur de l'écran de jeu
    parameter c_GAME_WIDTH = 640)      // Largeur de l'écran de jeu
  (
   input            i_Clk,              // Signal d'horloge
   input            i_Raccoon_Up,       // Mouvement vers le haut
   input            i_Raccoon_Dn,       // Mouvement vers le bas
   input            i_Raccoon_lt,       // Mouvement vers la gauche
   input            i_Raccoon_rt,       // Mouvement vers la droite
   output reg [9:0] o_Raccoon_X,        // Position X du raton laveur
   output reg [9:0] o_Raccoon_Y);       // Position Y du raton laveur

  // Initialisation de la position du raton laveur (centrée)
  initial begin
    o_Raccoon_X = (c_GAME_WIDTH / 2) / 32 * 32; // Centré sur un multiple de 32
    o_Raccoon_Y = (c_GAME_HEIGHT - c_PLAYER_HEIGHT) / 32 * 32; // Aligné en bas
  end

  reg [19:0] clk_div = 0;  // Diviseur d'horloge

  always @(posedge i_Clk) begin
    clk_div <= clk_div + 1;
  end

  always @(posedge clk_div[19]) begin
    // Mouvement en fonction des boutons tout en vérifiant les limites
    if (i_Raccoon_Up && o_Raccoon_Y >= 32) begin
      o_Raccoon_Y <= o_Raccoon_Y - 32; // Déplacement de 32 pixels vers le haut
    end 
    else if (i_Raccoon_Dn && o_Raccoon_Y <= (c_GAME_HEIGHT - c_PLAYER_HEIGHT - 32)) begin
      o_Raccoon_Y <= o_Raccoon_Y + 32; // Déplacement de 32 pixels vers le bas
    end
    
    if (i_Raccoon_lt && o_Raccoon_X >= 32) begin
      o_Raccoon_X <= o_Raccoon_X - 32; // Déplacement de 32 pixels vers la gauche
    end 
    else if (i_Raccoon_rt && o_Raccoon_X <= (c_GAME_WIDTH - c_PLAYER_WIDTH - 32)) begin
      o_Raccoon_X <= o_Raccoon_X + 32; // Déplacement de 32 pixels vers la droite
    end
  end
endmodule
