`include "constants.v"

module vga (
    input wire clk,                    // Signal d'horloge
    input wire [9:0] raccoonX,         // Position X du raton laveur (10 bits)
    input wire [9:0] raccoonY,         // Position Y du raton laveur (10 bits)
    input wire [9:0] carX_1,           // Position X de la première voiture
    input wire [9:0] carY_1,           // Position Y de la première voiture
    input wire [9:0] carX_2,           // Position X de la deuxième voiture
    input wire [9:0] carY_2,           // Position Y de la deuxième voiture
    input wire [9:0] carX_3,           // Position X de la troisième voiture
    input wire [9:0] carY_3,           // Position Y de la troisième voiture
    output reg [2:0] vgaR,             // Signal rouge VGA
    output reg [2:0] vgaG,             // Signal vert VGA
    output reg [2:0] vgaB,             // Signal bleu VGA
    output reg vgaHs,                  // Sync horizontal VGA
    output reg vgaVs                   // Sync vertical VGA
);

    // Compteurs horizontal et vertical pour la synchronisation VGA
    reg [9:0] hCount = 0;              // Compteur de pixels horizontal
    reg [9:0] vCount = 0;              // Compteur de pixels vertical

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

        // Vérification de la zone active de l'écran
        if (hCount >= H_SYNC_CYC + H_BACK_PORCH && hCount < H_SYNC_CYC + H_BACK_PORCH + H_ACTIVE_VIDEO &&
            vCount >= V_SYNC_CYC + V_BACK_PORCH && vCount < V_SYNC_CYC + V_BACK_PORCH + V_ACTIVE_VIDEO) begin

            // Calcul de la position des pixels actifs
            pixelX <= hCount - (H_SYNC_CYC + H_BACK_PORCH);
            pixelY <= vCount - (V_SYNC_CYC + V_BACK_PORCH);

            // Par défaut, fond noir
            vgaR <= BLACK;
            vgaG <= BLACK;
            vgaB <= BLACK;

            // Affichage des bandes de couleurs
            if (pixelY < 2 * GRID_HEIGHT) begin
                // Bandes grises sur les deux premières lignes de blocs
                vgaR <= GRAY;
                vgaG <= GRAY;
                vgaB <= GRAY;
            end else if (pixelY >= 7 * GRID_HEIGHT && pixelY < 9 * GRID_HEIGHT) begin
                // Bandes de couleurs spécifiques sur les lignes de blocs 7 et 8
                vgaR <= GRAY;
                vgaG <= GRAY;
                vgaB <= GRAY;
            end else if (pixelY >= 13 * GRID_HEIGHT && pixelY < 16 * GRID_HEIGHT) begin
                // Bandes de couleurs spécifiques sur les lignes de blocs 14 et 15
                vgaR <= GRAY;
                vgaG <= GRAY;
                vgaB <= GRAY;
            end else if (is_car(pixelX, pixelY, carX_1, carY_1, carX_2, carY_2, carX_3, carY_3)) begin
                // Affichage des voitures (rouge)
                set_color(RED, BLACK, BLACK);
            end else if (is_grid(pixelX, pixelY)) begin
                // Affichage des lignes de la grille (gris)
                set_color(GRAY, GRAY, GRAY);
            end

            // Affichage du raton laveur (blanc) par-dessus les bandes de couleurs
            if (in_bounds(pixelX, pixelY, raccoonX, raccoonY, PLAYER_WIDTH, PLAYER_HEIGHT)) begin
                set_color(WHITE, WHITE, WHITE);
            end
        end else begin
            vgaR <= BLACK;
            vgaG <= BLACK;
            vgaB <= BLACK;
        end
    end

    // Fonction pour définir les couleurs du VGA
    task set_color(input [2:0] r, input [2:0] g, input [2:0] b);
        begin
            vgaR <= r;
            vgaG <= g;
            vgaB <= b;
        end
    endtask

    // Fonction pour vérifier si les coordonnées sont dans les limites d'un objet
    function in_bounds(input [9:0] px, input [9:0] py, input [9:0] objX, input [9:0] objY, input [9:0] width, input [9:0] height);
        begin
            in_bounds = (px >= objX && px < objX + width && py >= objY && py < objY + height);
        end
    endfunction

    // Fonction pour vérifier si un pixel fait partie des voitures
    function is_car(input [9:0] px, input [9:0] py, input [9:0] car1X, input [9:0] car1Y, input [9:0] car2X, input [9:0] car2Y, input [9:0] car3X, input [9:0] car3Y);
        begin
            is_car = in_bounds(px, py, car1X, car1Y, CAR_WIDTH, CAR_HEIGHT) ||
                     in_bounds(px, py, car2X, car2Y, CAR_WIDTH, CAR_HEIGHT) ||
                     in_bounds(px, py, car3X, car3Y, CAR_WIDTH, CAR_HEIGHT);
        end
    endfunction

    // Fonction pour vérifier si un pixel fait partie de la grille
    function is_grid(input [9:0] px, input [9:0] py);
        begin
            is_grid = (px % GRID_WIDTH == 0) || (py % GRID_HEIGHT == 0);
        end
    endfunction

endmodule