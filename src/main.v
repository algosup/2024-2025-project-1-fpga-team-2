module main (
    input wire clk,          // horloge d'entrée
    input wire reset,        // réinitialisation d'entrée
    output wire hsync,       // signal de synchronisation horizontale
    output wire vsync,       // signal de synchronisation verticale
    output wire [2:0] red,   // signal RVB rouge
    output wire [2:0] green, // signal RVB vert
    output wire [2:0] blue   // signal RVB bleu
);

// Instanciation du contrôleur VGA
vga_controller vga_inst (
    .clk(clk),
    .reset(reset),
    .hsync(hsync),
    .vsync(vsync),
    .red(red),
    .green(green),
    .blue(blue)
);

endmodule
