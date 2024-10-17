`include "constants.v"

module raccoon_ctrl (
    input            i_Clk,              // Clock signal
    input            i_Raccoon_Up,       // Move up button
    input            i_Raccoon_Dn,       // Move down button
    input            i_Raccoon_lt,       // Move left button
    input            i_Raccoon_rt,       // Move right button
    output reg [9:0] o_Raccoon_X,        // Raccoon X position
    output reg [9:0] o_Raccoon_Y         // Raccoon Y position
);

    // Initialize raccoon position (centered)
    initial begin
        o_Raccoon_X = (GAME_WIDTH / 2) / GRID_WIDTH * GRID_WIDTH;  // Centered on a multiple of grid size
        o_Raccoon_Y = (GAME_HEIGHT - PLAYER_HEIGHT) / GRID_HEIGHT * GRID_HEIGHT; // Aligned at the bottom
    end

    reg [24:0] clk_div = 0;  // Clock divider

    always @(posedge i_Clk) begin
        clk_div <= clk_div + 1;
    end

    // Ensure the clock divider index is a valid range
    always @(posedge clk_div[RACCOON_SPEED]) begin
        // Move up
        if (i_Raccoon_Up && o_Raccoon_Y > 0) begin
            o_Raccoon_Y <= o_Raccoon_Y - GRID_HEIGHT;
        end 
        // Move down
        if (i_Raccoon_Dn && o_Raccoon_Y < (GAME_HEIGHT - PLAYER_HEIGHT)) begin
            o_Raccoon_Y <= o_Raccoon_Y + GRID_HEIGHT;
        end
        
        // Move left
        if (i_Raccoon_lt && o_Raccoon_X > 0) begin
            o_Raccoon_X <= o_Raccoon_X - GRID_WIDTH;
        end 
        // Move right
        if (i_Raccoon_rt && o_Raccoon_X < (GAME_WIDTH - PLAYER_WIDTH)) begin
            o_Raccoon_X <= o_Raccoon_X + GRID_WIDTH;
        end
    end
endmodule
