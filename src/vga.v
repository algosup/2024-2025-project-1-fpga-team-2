module vga (
    input wire clk,                  // Clock signal
    input wire [9:0] raccoonX,      // Raccoon X position (in pixels, 10-bit)
    input wire [9:0] raccoonY,      // Raccoon Y position (in pixels, 10-bit)
    output reg [2:0] vgaR,          // VGA Red signal
    output reg [2:0] vgaG,          // VGA Green signal
    output reg [2:0] vgaB,          // VGA Blue signal
    output reg vgaHs,               // VGA Horizontal sync
    output reg vgaVs                // VGA Vertical sync
);

    // VGA timing parameters for 640x480 resolution
    localparam H_SYNC_CYC = 96;          // Horizontal sync cycle
    localparam H_BACK_PORCH = 48;        // Horizontal back porch
    localparam H_ACTIVE_VIDEO = 640;      // Horizontal active video
    localparam H_FRONT_PORCH = 15;       // Horizontal front porch
    localparam H_LINE = 800;              // Total horizontal line width

    localparam V_SYNC_CYC = 1 ;          // Vertical sync cycle
    localparam V_BACK_PORCH = 33;        // Vertical back porch
    localparam V_ACTIVE_VIDEO = 480;      // Vertical active video
    localparam V_FRONT_PORCH = 10;       // Vertical front porch
    localparam V_LINE = 525;              // Total vertical line height

    // Define grid dimensions
    localparam GRID_WIDTH = 32;           // Width of each grid block
    localparam GRID_HEIGHT = 32;          // Height of each grid block

    // Horizontal and vertical counters for VGA timing
    reg [9:0] hCount = 0;                 // Horizontal pixel counter
    reg [9:0] vCount = 0;                 // Vertical pixel counter

    // Declare pixelX and pixelY outside the always block
    reg [9:0] pixelX;                     // Calculated pixel X position
    reg [9:0] pixelY;                     // Calculated pixel Y position

    always @(posedge clk) begin
        // Increment horizontal counter
        if (hCount == H_LINE - 1) begin
            hCount <= 0; // Reset horizontal counter
            // Increment vertical counter
            if (vCount == V_LINE - 1) begin
                vCount <= 0; // Reset vertical counter
            end else begin
                vCount <= vCount + 1; // Increment vertical counter
            end
        end else begin
            hCount <= hCount + 1; // Increment horizontal counter
        end

        // Generate horizontal sync pulse
        vgaHs <= (hCount < H_SYNC_CYC) ? 0 : 1;

        // Generate vertical sync pulse
        vgaVs <= (vCount < V_SYNC_CYC) ? 0 : 1;

        // Default to black (background color)
        vgaR <= 3'b000;
        vgaG <= 3'b000;
        vgaB <= 3'b000;

        // Check if in the active video area
        if (hCount >= H_SYNC_CYC + H_BACK_PORCH && hCount < H_SYNC_CYC + H_BACK_PORCH + H_ACTIVE_VIDEO &&
            vCount >= V_SYNC_CYC + V_BACK_PORCH && vCount < V_SYNC_CYC + V_BACK_PORCH + V_ACTIVE_VIDEO) begin
            
            // Calculate pixel positions in active area
            pixelX <= (hCount - (H_SYNC_CYC + H_BACK_PORCH));
            pixelY <= (vCount - (V_SYNC_CYC + V_BACK_PORCH));

            // Check if pixel is part of the raccoon
            if (pixelX >= raccoonX && pixelX < raccoonX + 32 &&
                pixelY >= raccoonY && pixelY < raccoonY + 32) begin
                // Raccoon color (White)
                vgaR <= 3'b111;
                vgaG <= 3'b111;
                vgaB <= 3'b111;
            end
            // Check if the pixel is part of the grid lines
            else if ((pixelX % GRID_WIDTH == 0) || (pixelY % GRID_HEIGHT == 0)) begin
                // Grid color (Light gray)
                vgaR <= 3'b100;
                vgaG <= 3'b100;
                vgaB <= 3'b100;
            end
        end
    end
endmodule
