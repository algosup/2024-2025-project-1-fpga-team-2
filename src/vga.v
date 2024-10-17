module vga_display (
    input wire clk,              // Clock signal
    input wire [9:0] raccoon_x, // Raccoon X position (in pixels, 10-bit)
    input wire [9:0] raccoon_y, // Raccoon Y position (in pixels, 10-bit)
    output reg [2:0] vga_r,      // VGA Red signal
    output reg [2:0] vga_g,      // VGA Green signal
    output reg [2:0] vga_b,      // VGA Blue signal
    output reg vga_hs,           // VGA Horizontal sync
    output reg vga_vs            // VGA Vertical sync
);

    // VGA timing parameters for 640x480 resolution
    localparam H_SYNC_CYC = 96;
    localparam H_BACK_PORCH = 48;
    localparam H_ACTIVE_VIDEO = 640;
    localparam H_FRONT_PORCH = 15;
    localparam H_LINE = 800;

    localparam V_SYNC_CYC = 2;
    localparam V_BACK_PORCH = 33;
    localparam V_ACTIVE_VIDEO = 480;
    localparam V_FRONT_PORCH = 10;
    localparam V_LINE = 525;

    // Horizontal and vertical counters for VGA timing
    reg [9:0] h_count = 0;
    reg [9:0] v_count = 0;  // Change v_count to 9 bits to match 480 resolution

    always @(posedge clk) begin
        // Horizontal counter
        if (h_count == H_LINE - 1) begin
            h_count <= 0;
            // Vertical counter
            if (v_count == V_LINE - 1) begin
                v_count <= 0;
            end else begin
                v_count <= v_count + 1;
            end
        end else begin
            h_count <= h_count + 1;
        end

        // Generate horizontal sync pulse
        vga_hs <= (h_count < H_SYNC_CYC) ? 0 : 1;

        // Generate vertical sync pulse
        vga_vs <= (v_count < V_SYNC_CYC) ? 0 : 1;

        // Default to black (background color)
        vga_r <= 3'b000;
        vga_g <= 3'b000;
        vga_b <= 3'b000;

        // Check if in the active video area
        if (h_count >= H_SYNC_CYC + H_BACK_PORCH && h_count < H_SYNC_CYC + H_BACK_PORCH + H_ACTIVE_VIDEO &&
            v_count >= V_SYNC_CYC + V_BACK_PORCH && v_count < V_SYNC_CYC + V_BACK_PORCH + V_ACTIVE_VIDEO) begin
            
            // Check if the pixel is part of the raccoon
            if (h_count - (H_SYNC_CYC + H_BACK_PORCH) >= raccoon_x &&
                h_count - (H_SYNC_CYC + H_BACK_PORCH) < raccoon_x + 32 &&  // Adjust for raccoon size
                v_count - (V_SYNC_CYC + V_BACK_PORCH) >= raccoon_y &&
                v_count - (V_SYNC_CYC + V_BACK_PORCH) < raccoon_y + 32) begin
                // Raccoon color (adjust RGB as needed)
                vga_r <= 3'b111; // White
                vga_g <= 3'b111;
                vga_b <= 3'b111;
            end
        end
    end
endmodule
