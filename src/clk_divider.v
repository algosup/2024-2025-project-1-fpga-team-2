module clk_divider #(
    parameter DIV_RATIO = 24'd99  // Ratio de division pour la fréquence de sortie
)(
    input wire i_clk,              // Signal d'horloge d'entrée
    output reg o_slow_clk          // Signal d'horloge divisé en sortie
);

    reg [23:0] div_counter = 0;    // Compteur pour diviser l'horloge

    always @(posedge i_clk) begin
        if (div_counter == DIV_RATIO - 1) begin
            div_counter <= 0;          // Réinitialiser le compteur
            o_slow_clk <= ~o_slow_clk; // Inverser l'horloge divisée
        end else begin
            div_counter <= div_counter + 1;  // Incrémenter le compteur
        end
    end
endmodule
