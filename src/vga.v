module vga (
    input wire clk,                   // Signal d'horloge
    input wire [9:0] raccoonX,        // Position X du raton laveur (10 bits)
    input wire [9:0] raccoonY,        // Position Y du raton laveur (10 bits)
    input wire [9:0] carX_1,          // Position X de la première voiture
    input wire [9:0] carY_1,          // Position Y de la première voiture
    input wire [9:0] carX_2,          // Position X de la deuxième voiture
    input wire [9:0] carY_2,          // Position Y de la deuxième voiture
    input wire [9:0] carX_3,          // Position X de la troisième voiture
    input wire [9:0] carY_3,          // Position Y de la troisième voiture
    input wire [2:0] lives,           // Nombre de vies restantes (3 bits)
    output reg [2:0] vgaR,            // Signal rouge VGA
    output reg [2:0] vgaG,            // Signal vert VGA
    output reg [2:0] vgaB,            // Signal bleu VGA
    output reg vgaHs,                 // Sync horizontal VGA
    output reg vgaVs                  // Sync vertical VGA
);

    // Compteurs horizontal et vertical pour la synchronisation VGA
    reg [9:0] hCount = 0;             // Compteur de pixels horizontal
    reg [9:0] vCount = 0;             // Compteur de pixels vertical

    // Positions des pixels calculées
    reg [9:0] pixelX;
    reg [9:0] pixelY;

    always @(posedge clk) begin
        // Gestion du compteur horizontal et vertical
        if (hCount == H_LINE - 1) begin
            hCount <= 0;
            if (vCount == V_LINE - 1) begin
                vCount <= 0;
            end else begin
                vCount <= vCount + 1;
            end
        end else begin
            hCount <= hCount + 1;
        end

        // Génération des impulsions de synchronisation
        vgaHs <= (hCount < H_SYNC_CYC) ? 0 : 1;
        vgaVs <= (vCount < V_SYNC_CYC) ? 0 : 1;

        // Fond noir par défaut
        vgaR <= 3'b000;
        vgaG <= 3'b000;
        vgaB <= 3'b000;

        // Vérification de la zone active de l'écran
        if (hCount >= H_SYNC_CYC + H_BACK_PORCH && hCount < H_SYNC_CYC + H_BACK_PORCH + H_ACTIVE_VIDEO &&
            vCount >= V_SYNC_CYC + V_BACK_PORCH && vCount < V_SYNC_CYC + V_BACK_PORCH + V_ACTIVE_VIDEO) begin

            pixelX <= hCount - (H_SYNC_CYC + H_BACK_PORCH);
            pixelY <= vCount - (V_SYNC_CYC + V_BACK_PORCH);

            // Affichage du raton laveur (blanc)
            if (pixelX >= raccoonX && pixelX < raccoonX + PLAYER_WIDTH &&
                pixelY >= raccoonY && pixelY < raccoonY + PLAYER_HEIGHT) begin
                vgaR <= 3'b111;  // Blanc
                vgaG <= 3'b111;
                vgaB <= 3'b111;
            end
            // Affichage de la première voiture (rouge)
            else if (pixelX >= carX_1 && pixelX < carX_1 + CAR_WIDTH &&
                     pixelY >= carY_1 && pixelY < carY_1 + CAR_HEIGHT) begin
                vgaR <= 3'b111;  // Rouge
                vgaG <= 3'b000;
                vgaB <= 3'b000;
            end
            // Affichage de la deuxième voiture (rouge)
            else if (pixelX >= carX_2 && pixelX < carX_2 + CAR_WIDTH &&
                     pixelY >= carY_2 && pixelY < carY_2 + CAR_HEIGHT) begin
                vgaR <= 3'b111;  // Rouge
                vgaG <= 3'b000;
                vgaB <= 3'b000;
            end
            // Affichage de la troisième voiture (rouge)
            else if (pixelX >= carX_3 && pixelX < carX_3 + CAR_WIDTH &&
                     pixelY >= carY_3 && pixelY < carY_3 + CAR_HEIGHT) begin
                vgaR <= 3'b111;  // Rouge
                vgaG <= 3'b000;
                vgaB <= 3'b000;
            end

            // Affichage des lignes de la grille (gris)
            else if ((pixelX % GRID_WIDTH == 0) || (pixelY % GRID_HEIGHT == 0)) begin
                vgaR <= 3'b100;  // Gris
                vgaG <= 3'b100;
                vgaB <= 3'b100;
            end

            // Affichage des vies restantes en bas à gauche
            else if (pixelY >= V_ACTIVE_VIDEO - 32 && pixelY < V_ACTIVE_VIDEO - 16) begin
                case (lives)
                    3'b011: begin // 3 vies
                        if (pixelX >= 0 && pixelX < 16) begin 
                            vgaR <= 3'b000; // Vert
                            vgaG <= 3'b111;
                            vgaB <= 3'b000; 
                        end else if (pixelX >= 20 && pixelX < 36) begin 
                            vgaR <= 3'b000; // Vert
                            vgaG <= 3'b111;
                            vgaB <= 3'b000; 
                        end else if (pixelX >= 40 && pixelX < 56) begin 
                            vgaR <= 3'b000; // Vert
                            vgaG <= 3'b111;
                            vgaB <= 3'b000; 
                        end 
                    end
                    3'b010: begin // 2 vies
                        if (pixelX >= 0 && pixelX < 16) begin 
                            vgaR <= 3'b000; // Vert
                            vgaG <= 3'b111;
                            vgaB <= 3'b000; 
                        end else if (pixelX >= 20 && pixelX < 36) begin 
                            vgaR <= 3'b000; // Vert
                            vgaG <= 3'b111;
                            vgaB <= 3'b000; 
                        end
                    end
                    3'b001: begin // 1 vie
                        if (pixelX >= 0 && pixelX < 16) begin 
                            vgaR <= 3'b000; // Vert
                            vgaG <= 3'b111;
                            vgaB <= 3'b000; 
                        end
                    end
                endcase
            end
        end
    end
endmodule
