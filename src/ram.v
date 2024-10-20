module ram #(
    parameter FILE_NAME = "sprite.mem" 
)(
    input wire i_Clk,                                   // Horloge
    input wire [$clog2(1024)-1:0] addr,             // Adresse pour accéder aux pixels dans le sprite
    output reg [8:0] data_out                         // 9 bits par pixel (RGB 3 bits chaque)
);

    reg [8:0] sprite [0:1023];                   // Déclaration de la mémoire pour les sprites

    initial begin
        // Initialisation de la mémoire des sprites à partir du fichier spécifié par le paramètre
        $readmemh(FILE_NAME, sprite);
    end

    always @(posedge i_Clk) begin
        data_out <= sprite[addr];                // Lecture des données de la mémoire
    end
endmodule
