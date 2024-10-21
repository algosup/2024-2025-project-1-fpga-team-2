`include "constants.v"

module car_ctrl #(
    parameter C_CAR_X = 0,              // Position de départ en X
    parameter C_CAR_Y = 128,            // Position de départ en Y
    parameter C_DIRECTION = 1           // Direction du mouvement: 0 = Gauche, 1 = Droite
) (
    input wire i_Clk,                    // Signal d'horloge
    input wire [3:0] level,              // Niveau du jeu (affecte la vitesse)
    input wire [1:0] game_state,         // Nouveau port d'entrée pour l'état du jeu
    input wire i_Reset,                  // Nouveau bouton de réinitialisation
    output reg [9:0] o_carX,             // Position X de la voiture
    output reg [8:0] o_carY              // Position Y de la voiture
);

    // Position initiale de la voiture
    reg [9:0] carX = C_CAR_X;            // Position X initialisée avec le paramètre
    reg [8:0] carY = C_CAR_Y;            // Position Y fixe

    // Compteur pour contrôler la vitesse de la voiture
    reg [15:0] speed_counter = 0;        // 16 bits devraient suffire
    reg [16:0] speed;                    // Vitesse de la voiture réduite à 17 bits

    // Définition des vitesses en fonction du niveau
    always @(*) begin
        case (level)
            4'b0001: speed = 17'd50000;   // Niveau 1 : vitesse initiale
            4'b0010: speed = 17'd45000;   // Niveau 2 : augmentation de la vitesse
            4'b0011: speed = 17'd40000;   // Niveau 3 : plus rapide
            4'b0100: speed = 17'd35000;   // Niveau 4 : encore plus rapide
            4'b0101: speed = 17'd30000;   // Niveau 5 : accélération
            4'b0110: speed = 17'd25000;   // Niveau 6 : vitesse notable
            4'b0111: speed = 17'd20000;   // Niveau 7 : vitesse élevée
            4'b1000: speed = 17'd15000;   // Niveau 8 : très rapide
            default: speed = 17'd50000;   // Niveau par défaut
        endcase
    end

    // Bloc always pour le mouvement de la voiture et la gestion du reset
    always @(posedge i_Clk) begin
        if (i_Reset) begin
            // Réinitialisation des positions des voitures à leurs positions de départ
            carX <= C_CAR_X;
            carY <= C_CAR_Y;
            speed_counter <= 0;
        end else if (game_state == 2'b01) begin  // État "running"
            if (speed_counter < speed) begin
                speed_counter <= speed_counter + 1;
            end else begin
                speed_counter <= 0;  // Réinitialiser le compteur de vitesse

                // Déplacement selon la direction
                if (C_DIRECTION == 1) begin
                    // Mouvement vers la droite
                    if (carX < GAME_WIDTH - 1) begin
                        carX <= carX + 1;   // Incrémenter la position X vers la droite
                    end else begin
                        carX <= 0;  // Réinitialiser à gauche si on atteint la limite droite
                    end
                end else begin
                    // Mouvement vers la gauche
                    if (carX > 0) begin
                        carX <= carX - 1;   // Décrémenter la position X vers la gauche
                    end else begin
                        carX <= GAME_WIDTH - 1;  // Réinitialiser à droite si on atteint la limite gauche
                    end
                end
            end
        end

        // Mise à jour des sorties
        o_carX <= carX;
        o_carY <= carY;  // La position Y reste constante
    end

endmodule