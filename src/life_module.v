module life_module (
    input wire [3:0] i_Life,           // Nombre de vies restantes
    input wire [9:0] i_Col_Count,      // Compteur de colonnes
    input wire [9:0] i_Row_Count,      // Compteur de lignes
    output reg [3:0] o_Red_Video,      // Couleur rouge de l'affichage
    output reg [3:0] o_Grn_Video,      // Couleur verte de l'affichage
    output reg [3:0] o_Blu_Video       // Couleur bleue de l'affichage
);

    always @(*) begin
        // Par défaut, effacer la couleur des vidéos
        o_Red_Video = 4'b0000;
        o_Grn_Video = 4'b0000;
        o_Blu_Video = 4'b0000;

        // Dessiner les carrés de vie
        if (i_Row_Count >= 480 - 16) begin // Ligne de base
            if (i_Col_Count >= 0 && i_Col_Count < 16 && i_Life > 0) begin // Carré 1
                o_Red_Video = 4'b1111; // Couleur rouge
            end
            if (i_Col_Count >= 20 && i_Col_Count < 36 && i_Life > 1) begin // Carré 2
                o_Red_Video = 4'b1111; // Couleur rouge
            end
            if (i_Col_Count >= 40 && i_Col_Count < 56 && i_Life > 2) begin // Carré 3
                o_Red_Video = 4'b1111; // Couleur rouge
            end
            if (i_Col_Count >= 60 && i_Col_Count < 76 && i_Life > 3) begin // Carré 4
                o_Red_Video = 4'b1111; // Couleur rouge
            end
        end
    end
endmodule
