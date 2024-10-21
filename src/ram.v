module ram #(
    parameter FILE_NAME = "sprite.mem" 
)(
    input wire i_Clk,                                   // Clock signal
    input wire [$clog2(1024)-1:0] addr,                 // Address to access pixels in the sprite
    output reg [8:0] data_out                           // 9 bits per pixel (RGB 3 bits each)
);

    reg [8:0] sprite [0:1023];                          // Declaration of memory for sprites

    initial begin
        // Initialization of sprite memory from the file specified by the parameter
        $readmemh(FILE_NAME, sprite);
    end

    always @(posedge i_Clk) begin
        data_out <= sprite[addr];                       // Reading data from memory
    end
endmodule
