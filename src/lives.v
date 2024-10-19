module lives (
    input i_Clk,
    input i_Reset,
    input i_Collision,
    output reg [3:0] o_Lives  // Ici, vous avez 4 bits, ce qui est correct pour 0 à 3 vies
);

    reg collision_d;

    initial begin
        o_Lives = 3;                // Initialiser à 3 vies
        collision_d = 0;            // Initialiser l'état précédent de la collision
    end

    always @(posedge i_Clk ) begin
        if (i_Reset) begin
            o_Lives <= 3;           // Réinitialiser à 3 vies
            collision_d <= 0;       // Réinitialiser l'état précédent de la collision
        end else begin
            // Détecter le front montant de la collision
            if (i_Collision && !collision_d && o_Lives > 0) begin
                o_Lives <= o_Lives - 1; // Décrémenter le nombre de vies en cas de front montant de la collision
            end
            // Mémoriser l'état courant de la collision pour la détection du front montant
            collision_d <= i_Collision;
        end
    end
endmodule
