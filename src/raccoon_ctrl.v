`include "constants.v"

module raccoon_ctrl (
    input            i_Clk,              // Clock signal
    input            i_Raccoon_Up,       // Move up button
    input            i_Raccoon_Dn,       // Move down button
    input            i_Raccoon_lt,       // Move left button
    input            i_Raccoon_rt,       // Move right button
    input            i_Collision,        // Collision signal
    input [1:0]      game_state,       // State of the game
    output reg [9:0] o_Raccoon_X,        // Raccoon X position
    output reg [9:0] o_Raccoon_Y,        // Raccoon Y position
    output reg [3:0] o_Level             // Current level
);

    // Initialiser la position du raton laveur et le niveau
    initial begin
        o_Raccoon_X = (GAME_WIDTH / 2) / GRID_WIDTH * GRID_WIDTH;  // Centré sur un multiple de la taille de la grille
        o_Raccoon_Y = (GAME_HEIGHT - PLAYER_HEIGHT) / GRID_HEIGHT * GRID_HEIGHT; // Aligné en bas
        o_Level = 4'd1; // Niveau initial
    end

    reg [24:0] clk_div = 0;  // Diviseur d'horloge

    always @(posedge i_Clk) begin
        clk_div <= clk_div + 1;
    end

    // Assurez-vous que l'index du diviseur d'horloge est dans une plage valide
    always @(posedge clk_div[RACCOON_SPEED]) begin
        if (!i_Collision && game_state == 2'b01) begin  // Ne bougez que si le jeu est en cours (RUN) et sans collision
            // Mouvement vers le haut
            if (i_Raccoon_Up && o_Raccoon_Y > 0) begin
                o_Raccoon_Y <= o_Raccoon_Y - GRID_HEIGHT;
            end 
            // Mouvement vers le bas
            if (i_Raccoon_Dn && o_Raccoon_Y < (GAME_HEIGHT - PLAYER_HEIGHT)) begin
                o_Raccoon_Y <= o_Raccoon_Y + GRID_HEIGHT;
            end
            
            // Mouvement vers la gauche
            if (i_Raccoon_lt && o_Raccoon_X > 0) begin
                o_Raccoon_X <= o_Raccoon_X - GRID_WIDTH;
            end 
            // Mouvement vers la droite
            if (i_Raccoon_rt && o_Raccoon_X < (GAME_WIDTH - PLAYER_WIDTH)) begin
                o_Raccoon_X <= o_Raccoon_X + GRID_WIDTH;
            end
        end else if (i_Collision || game_state == 2'b11) begin
            // Réinitialiser la position du raton laveur en bas ou en cas d'état CLEAN
            o_Raccoon_X <= (GAME_WIDTH / 2) / GRID_WIDTH * GRID_WIDTH;  // Remettre au centre
            o_Raccoon_Y <= (GAME_HEIGHT - PLAYER_HEIGHT) / GRID_HEIGHT * GRID_HEIGHT; // Aligné en bas
        end

        // Vérifier si le raton laveur a atteint le haut de l'écran
        if (o_Raccoon_Y == 0 && game_state == 2'b01) begin
            o_Raccoon_X <= (GAME_WIDTH / 2) / GRID_WIDTH * GRID_WIDTH;  // Remettre au centre
            o_Raccoon_Y <= (GAME_HEIGHT - PLAYER_HEIGHT) / GRID_HEIGHT * GRID_HEIGHT; // Aligné en bas

            // Incrémenter le niveau si le niveau est inférieur à 9
            if (o_Level < 4'd9) begin
                o_Level <= o_Level + 1; // Passer au niveau suivant
            end
        end
    end
endmodule
