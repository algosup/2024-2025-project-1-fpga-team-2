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

    // Instanciation du module RAM pour le raton laveur
    wire [8:0] raccoon_sprite_data; // Données du sprite pour le raton laveur
    wire [$clog2(1024)-1:0] raccoon_sprite_addr; // Adresse pour le sprite
    ram #(.FILE_NAME("raccoon.txt")) raccoon_ram (
        .i_Clk(clk),
        .addr(raccoon_sprite_addr),
        .data_out(raccoon_sprite_data)
    );

    // Instanciation du module RAM pour le raton laveur
    wire [8:0] grass_sprite_data; // Données du sprite pour le raton laveur
    wire [$clog2(1024)-1:0] grass_sprite_addr; // Adresse pour le sprite
    ram #(.FILE_NAME("grasstest.txt")) grass_ram (
        .i_Clk(clk),
        .addr(grass_sprite_addr),
        .data_out(grass_sprite_data)
    );

    // Instanciation du module RAM pour le raton laveur
    wire [8:0] car_sprite_data; // Données du sprite pour le raton laveur
    wire [$clog2(1024)-1:0] car_sprite_addr; // Adresse pour le sprite
    ram #(.FILE_NAME("cars.txt")) car_ram (
        .i_Clk(clk),
        .addr(car_sprite_addr),
        .data_out(car_sprite_data)
    );

    // Instanciation du module RAM pour le raton laveur
    wire [8:0] dotted_sprite_data; // Données du sprite pour le raton laveur
    wire [$clog2(1024)-1:0] dotted_sprite_addr; // Adresse pour le sprite
    ram #(.FILE_NAME("dottedt.txt")) dotted_ram (
        .i_Clk(clk),
        .addr(dotted_sprite_addr),
        .data_out(dotted_sprite_data)
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
                grass_sprite_addr <= (pixelY - 13 * GRID_HEIGHT) * GRID_WIDTH + (pixelX % GRID_WIDTH);
                set_color(grass_sprite_data[8:6], grass_sprite_data[5:3], grass_sprite_data[2:0]);
            end else if (pixelY >= 7 * GRID_HEIGHT && pixelY < 8 * GRID_HEIGHT) begin
                // Bandes de couleurs spécifiques sur les lignes de blocs 7 et 8
                vgaR <= GRAY;
                vgaG <= GRAY;
                vgaB <= GRAY;
            end else if (pixelY >= 13 * GRID_HEIGHT && pixelY < 15 * GRID_HEIGHT) begin
                // Bandes de couleurs spécifiques sur les lignes de blocs 14 et 15
                // Calculer l'adresse dans la mémoire du sprite de l'herbe
                grass_sprite_addr <= (pixelY - 13 * GRID_HEIGHT) * GRID_WIDTH + (pixelX % GRID_WIDTH);
                set_color(grass_sprite_data[8:6], grass_sprite_data[5:3], grass_sprite_data[2:0]);
            end else if (is_car(pixelX, pixelY, carX_1, carY_1, carX_2, carY_2, carX_3, carY_3)) begin
                // Calculer l'adresse dans la mémoire du sprite de la voiture
                if (in_bounds(pixelX, pixelY, carX_1, carY_1, CAR_WIDTH, CAR_HEIGHT)) begin
                    car_sprite_addr <= (pixelY - carY_1) * CAR_WIDTH + (pixelX - carX_1);
                end else if (in_bounds(pixelX, pixelY, carX_2, carY_2, CAR_WIDTH, CAR_HEIGHT)) begin
                    car_sprite_addr <= (pixelY - carY_2) * CAR_WIDTH + (pixelX - carX_2);
                end else if (in_bounds(pixelX, pixelY, carX_3, carY_3, CAR_WIDTH, CAR_HEIGHT)) begin
                    car_sprite_addr <= (pixelY - carY_3) * CAR_WIDTH + (pixelX - carX_3);
                end
                if (raccoon_sprite_data != 000000) begin
                    set_color(car_sprite_data[8:6], car_sprite_data[5:3], car_sprite_data[2:0]);
                end
            end 

                // Remplace la fonction is_dotted_line par l'accès au sprite de pointillés
            // et l'affichage à la position désirée
            if (pixelY >= 4 * GRID_HEIGHT && pixelY < 5 * GRID_HEIGHT) begin
                // Affichage des pointillés sur la ligne 5
                dotted_sprite_addr <= (pixelY - 4 * GRID_HEIGHT) * GRID_WIDTH + (pixelX % GRID_WIDTH);
                set_color(dotted_sprite_data[8:6], dotted_sprite_data[5:3], dotted_sprite_data[2:0]);
            end else if (pixelY >= 10 * GRID_HEIGHT && pixelY < 11 * GRID_HEIGHT) begin
                // Affichage des pointillés sur la ligne 11
                dotted_sprite_addr <= (pixelY - 10 * GRID_HEIGHT) * GRID_WIDTH + (pixelX % GRID_WIDTH);
                set_color(dotted_sprite_data[8:6], dotted_sprite_data[5:3], dotted_sprite_data[2:0]);
            end

            // Affichage du raton laveur (avec gestion de la transparence pour la couleur 0x808080)
            if (in_bounds(pixelX, pixelY, raccoonX, raccoonY, PLAYER_WIDTH, PLAYER_HEIGHT)) begin
                // Calculer l'adresse dans la mémoire du sprite du raton laveur
                raccoon_sprite_addr <= (pixelY - raccoonY) * PLAYER_WIDTH + (pixelX - raccoonX);
                // Si le pixel du sprite n'est pas 0x808080 (gris moyen)
                if (raccoon_sprite_data != 000001) begin  // Couleur 0x808080 (gris moyen)
                    set_color(raccoon_sprite_data[8:6], raccoon_sprite_data[5:3], raccoon_sprite_data[2:0]);
                end
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


    

endmodule
