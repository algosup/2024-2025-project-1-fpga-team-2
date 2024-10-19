module Debounce_Switch (
    input i_Clk,            // Horloge
    input i_Switch,         // Entrée brute du bouton
    output o_Switch,        // Sortie débouncée (niveau stable)
    output o_Switch_Edge    // Signal de front montant détecté
);

    parameter c_DEBOUNCE_LIMIT = 20000;  // Ajuster la durée de debounce (réduite pour réagir plus rapidement)

    reg [17:0] r_Count = 0;
    reg r_State = 1'b0;
    reg r_State_Delay = 1'b0;
    reg r_Edge = 1'b0;

    always @(posedge i_Clk) begin
        // Si le signal change mais n'est pas encore stabilisé, incrémenter le compteur
        if (i_Switch !== r_State && r_Count < c_DEBOUNCE_LIMIT) begin
            r_Count <= r_Count + 1;
        end else if (r_Count == c_DEBOUNCE_LIMIT) begin
            // Une fois stabilisé, mettre à jour l'état interne
            r_State <= i_Switch;
            r_Count <= 0;
        end else begin
            r_Count <= 0;  // Réinitialiser le compteur si pas de changement
        end

        // Détection du front montant
        r_State_Delay <= r_State;
        r_Edge <= (r_State && !r_State_Delay);
    end

    // Sorties
    assign o_Switch = r_State;       // État stabilisé du switch
    assign o_Switch_Edge = r_Edge;   // Front montant détecté
endmodule
