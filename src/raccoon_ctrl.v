module raccoon_ctrl (
    input            i_Clk,              // Signal d'horloge
    input            i_Raccoon_Up,       // Mouvement vers le haut (bouton débogué)
    input            i_Raccoon_Dn,       // Mouvement vers le bas (bouton débogué)
    input            i_Raccoon_lt,       // Mouvement vers la gauche (bouton débogué)
    input            i_Raccoon_rt,       // Mouvement vers la droite (bouton débogué)
    input            i_Collision,        // Signal de collision
    output reg [9:0] o_Raccoon_X,        // Position X du raton laveur
    output reg [9:0] o_Raccoon_Y,        // Position Y du raton laveur
    output reg [3:0] o_Level             // Niveau actuel
);

    // Initialisation de la position du raton laveur et du niveau
    initial begin
        o_Raccoon_X = (GAME_WIDTH / 2) / GRID_WIDTH * GRID_WIDTH;  // Centré sur un multiple de la grille
        o_Raccoon_Y = (GAME_HEIGHT - PLAYER_HEIGHT) / GRID_HEIGHT * GRID_HEIGHT; // Aligné en bas
        o_Level = 4'd1; // Niveau initial
    end

    reg [24:0] clk_div = 0;  // Diviseur d'horloge pour contrôler la vitesse du raton laveur

    always @(posedge i_Clk) begin
        clk_div <= clk_div + 1;
    end

    always @(posedge clk_div[RACCOON_SPEED]) begin
        if (!i_Collision) begin
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
        end else begin
            // Réinitialisation de la position en cas de collision
            o_Raccoon_X <= (GAME_WIDTH / 2) / GRID_WIDTH * GRID_WIDTH;  // Recentrer
            o_Raccoon_Y <= (GAME_HEIGHT - PLAYER_HEIGHT) / GRID_HEIGHT * GRID_HEIGHT; // Revenir en bas
        end

        // Vérifier si le raton laveur a atteint le haut de l'écran
        if (o_Raccoon_Y == 0) begin
            o_Raccoon_X <= (GAME_WIDTH / 2) / GRID_WIDTH * GRID_WIDTH;  // Recentrer
            o_Raccoon_Y <= (GAME_HEIGHT - PLAYER_HEIGHT) / GRID_HEIGHT * GRID_HEIGHT; // Revenir en bas

            // Incrémenter le niveau si le niveau est inférieur à 9
            if (o_Level < 4'd9) begin
                o_Level <= o_Level + 1; // Passer au niveau suivant
            end
        end
    end
endmodule