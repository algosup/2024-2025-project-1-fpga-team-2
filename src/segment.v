module segment_decoder (
    input i_Clk,                    // Horloge
    input [3:0] i_Level,           // Niveau courant en entrée
    output reg [6:0] o_Segment     // Sortie pour l'afficheur 7 segments
);

    reg [3:0] r_Units;             // Unités du niveau
    reg [3:0] r_Level;             // Registre pour stocker la valeur de niveau

    always @(posedge i_Clk) begin
        r_Level <= i_Level;        // Met à jour le registre avec la valeur de niveau
    end

    always @(*) begin
        // Extraire les unités à partir du niveau
        r_Units = r_Level % 10;

        // Décoder les unités pour les segments à 7 segments
        case (r_Units)
            4'b0000: o_Segment = 7'b1000000; // 0
            4'b0001: o_Segment = 7'b1111001; // 1
            4'b0010: o_Segment = 7'b0100100; // 2
            4'b0011: o_Segment = 7'b0110000; // 3
            4'b0100: o_Segment = 7'b0011001; // 4
            4'b0101: o_Segment = 7'b0010010; // 5
            4'b0110: o_Segment = 7'b0000010; // 6
            4'b0111: o_Segment = 7'b1111000; // 7
            4'b1000: o_Segment = 7'b0000000; // 8
            4'b1001: o_Segment = 7'b0010000; // 9
            default: o_Segment = 7'b1111111; // Erreur
        endcase
    end

endmodule
