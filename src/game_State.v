module game_state (
    input wire i_Clk,               // Horloge
    input i_StartGame,             // Signal pour démarrer le jeu (bouton de start)
    input i_Collision,         // Signal de collision
    input wire [2:0] i_Lives,       // Nombre de vies restantes
    input i_Win_Condition,     // Condition de victoire (par exemple atteindre une position)
    input i_Reset,             // Reset manuel pour réinitialiser le jeu
    output reg [1:0] o_Game_State   // État du jeu (00: idle, 01: run, 10: win, 11: clean)
);

    // Déclaration des états du jeu
    localparam IDLE  = 2'b00;
    localparam RUN   = 2'b01;
    localparam WIN   = 2'b10;
    localparam CLEAN = 2'b11;

    // État courant du jeu
    reg [1:0] r_CurrentState;
    reg [1:0] r_NextState;

    // Initialisation de l'état à IDLE
    initial begin
        r_CurrentState = IDLE;
    end

    // Logique de changement d'état
    always @(posedge i_Clk or posedge i_Reset) begin
        if (i_Reset) begin
            // Réinitialisation : retour à l'état IDLE
            r_CurrentState <= IDLE;
        end else begin
            // Sinon, passer à l'état suivant
            r_CurrentState <= r_NextState;
        end
    end

    // Logique de transition d'état
    always @(*) begin
        // Par défaut, rester dans l'état courant
        r_NextState = r_CurrentState;

        case (r_CurrentState)
            IDLE: begin
                // Si le bouton "start" est appuyé, passer à RUN
                if (i_StartGame) begin
                    r_NextState = RUN;
                end
            end

            RUN: begin
                // Si une collision a lieu et qu'il reste des vies, passer à CLEAN
                if (i_Collision && i_Lives > 0) begin
                    r_NextState = CLEAN;
                end
                // Si la condition de victoire est remplie, passer à WIN
                else if (i_Win_Condition) begin
                    r_NextState = WIN;
                end
                // Si toutes les vies sont perdues, retour à IDLE
                else if (i_Lives == 0) begin
                    r_NextState = IDLE;
                end
            end

            CLEAN: begin
                // Après avoir nettoyé la collision (par exemple, après une réinitialisation), retourner à RUN
                if (!i_Collision) begin
                    r_NextState = RUN;
                end
            end

            WIN: begin
                // En cas de victoire, on reste dans l'état WIN jusqu'à un reset
                if (i_Reset) begin
                    r_NextState = CLEAN;

                end
            end
        endcase
    end

    // Mise à jour de la sortie de l'état du jeu
    always @(*) begin
        o_Game_State = r_CurrentState;
    end

endmodule
