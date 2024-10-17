module vga_controller (
    input wire clk,          // horloge de la carte FPGA
    input wire reset,        // signal de réinitialisation
    output reg hsync,        // signal de synchronisation horizontale
    output reg vsync,        // signal de synchronisation verticale
    output reg [2:0] red,    // composante rouge du signal RVB
    output reg [2:0] green,  // composante verte du signal RVB
    output reg [2:0] blue    // composante bleue du signal RVB
);

// Variables pour le comptage
reg [9:0] hcount = 0;
reg [9:0] vcount = 0;

// Signal de zone visible
wire display_active = (hcount < H_VISIBLE_AREA) && (vcount < V_VISIBLE_AREA);

// Génération de HSYNC et VSYNC
always @(posedge clk or posedge reset) begin
    if (reset) begin
        hcount <= 0;
        vcount <= 0;
        hsync  <= 1;
        vsync  <= 1;
    end else begin
        // Compteur horizontal
        if (hcount < H_TOTAL - 1)
            hcount <= hcount + 1;
        else begin
            hcount <= 0;
            // Compteur vertical
            if (vcount < V_TOTAL - 1)
                vcount <= vcount + 1;
            else
                vcount <= 0;
        end

        // Génération de l'impulsion de synchronisation horizontale
        if (hcount >= (H_VISIBLE_AREA + H_FRONT_PORCH) && hcount < (H_VISIBLE_AREA + H_FRONT_PORCH + H_SYNC_PULSE))
            hsync <= 0;
        else
            hsync <= 1;

        // Génération de l'impulsion de synchronisation verticale
        if (vcount >= (V_VISIBLE_AREA + V_FRONT_PORCH) && vcount < (V_VISIBLE_AREA + V_FRONT_PORCH + V_SYNC_PULSE))
            vsync <= 0;
        else
            vsync <= 1;
    end
end

// Affichage de la grenouille (32x32 pixels)
always @(posedge clk) begin
    if (display_active) begin
        // Position de la grenouille : x=300 à 332, y=200 à 232
        if (hcount >= 300 && hcount < 332 && vcount >= 200 && vcount < 232) begin
            red   <= 3'b000;  // noir
            green <= 3'b111;  // vert
            blue  <= 3'b000;  // pas de bleu
        end else begin
            red   <= 3'b000;  // fond noir
            green <= 3'b000;  // fond noir
            blue  <= 3'b000;  // fond noir
        end
    end else begin
        red   <= 3'b000;  // hors écran (noir)
        green <= 3'b000;
        blue  <= 3'b000;
    end
end

endmodule
