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

    // Constantes pour la position centrale et la position de départ
    localparam RACCOON_START_X = (GAME_WIDTH / 2) / GRID_WIDTH * GRID_WIDTH;
    localparam RACCOON_START_Y = (GAME_HEIGHT - PLAYER_HEIGHT) / GRID_HEIGHT * GRID_HEIGHT;

    // Initialisation de la position du raton laveur et du niveau
    initial begin
        o_Raccoon_X = RACCOON_START_X;
        o_Raccoon_Y = RACCOON_START_Y;
        o_Level = 4'd1;  // Niveau initial
    end

    reg [24:0] clk_div = 0;  // Diviseur d'horloge pour contrôler la vitesse du raton laveur

    // Incrémentation du diviseur d'horloge
    always @(posedge i_Clk) begin
        clk_div <= clk_div + 1;
    end

    // Logique principale de contrôle du mouvement du raton laveur
    always @(posedge clk_div[RACCOON_SPEED]) begin
        if (i_Collision) begin
            // Réinitialiser la position en cas de collision
            o_Raccoon_X <= RACCOON_START_X;
            o_Raccoon_Y <= RACCOON_START_Y;
        end else begin
            // Mouvement en fonction des boutons
            if (i_Raccoon_Up && o_Raccoon_Y > 0) begin
                o_Raccoon_Y <= o_Raccoon_Y - GRID_HEIGHT;
            end else if (i_Raccoon_Dn && o_Raccoon_Y < (GAME_HEIGHT - PLAYER_HEIGHT)) begin
                o_Raccoon_Y <= o_Raccoon_Y + GRID_HEIGHT;
            end

            if (i_Raccoon_lt && o_Raccoon_X > 0) begin
                o_Raccoon_X <= o_Raccoon_X - GRID_WIDTH;
            end else if (i_Raccoon_rt && o_Raccoon_X < (GAME_WIDTH - PLAYER_WIDTH)) begin
                o_Raccoon_X <= o_Raccoon_X + GRID_WIDTH;
            end
        end

        // Vérification si le raton laveur a atteint le haut de l'écran (fin de niveau)
        if (o_Raccoon_Y == 0) begin
            o_Raccoon_X <= RACCOON_START_X;
            o_Raccoon_Y <= RACCOON_START_Y;

            // Incrémenter le niveau si le niveau est inférieur à 9
            if (o_Level < 4'd9) begin
                o_Level <= o_Level + 1;
            end
        end
    end
endmodule
