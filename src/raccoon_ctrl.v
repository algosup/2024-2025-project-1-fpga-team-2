module raccoon_ctrl (
    input            i_Clk,              // Clock signal
    input            i_Raccoon_Up,       // Move up button
    input            i_Raccoon_Dn,       // Move down button
    input            i_Raccoon_lt,       // Move left button
    input            i_Raccoon_rt,       // Move right button
    input            i_Collision,        // Collision signal
    input [1:0]      game_state,         // State of the game
    input            i_Reset_Level,      // Signal to reset level
    output reg [9:0] o_Raccoon_X,        // Raccoon X position
    output reg [9:0] o_Raccoon_Y,        // Raccoon Y position
    output reg [3:0] o_Level             // Current level
);

    // Initialize the raccoon's position and level
    initial begin
        o_Raccoon_X = (GAME_WIDTH / 2) / GRID_WIDTH * GRID_WIDTH;  // Centered on a grid size multiple
        o_Raccoon_Y = (GAME_HEIGHT - PLAYER_HEIGHT) / GRID_HEIGHT * GRID_HEIGHT; // Aligned at the bottom
        o_Level = 4'd1; // Initial level
    end

    reg [24:0] clk_div = 0;  // Clock divider

    always @(posedge i_Clk) begin
        clk_div <= clk_div + 1;
    end

    always @(posedge clk_div[RACCOON_SPEED]) begin
        if (i_Reset_Level) begin
            // If the reset signal is active, reset the level to 1
            o_Level <= 4'd1;
        end else if (!i_Collision && game_state == 2'b01) begin  // Move only if the game is in RUN state and there's no collision
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
        end else if (i_Collision || game_state == 2'b11) begin
            // Reset the raccoon's position to the bottom or in CLEAN state
            o_Raccoon_X <= (GAME_WIDTH / 2) / GRID_WIDTH * GRID_WIDTH;  // Reset to the center
            o_Raccoon_Y <= (GAME_HEIGHT - PLAYER_HEIGHT) / GRID_HEIGHT * GRID_HEIGHT; // Aligned at the bottom
        end

        // Check if the raccoon has reached the top of the screen
        if (o_Raccoon_Y == 0 && game_state == 2'b01) begin
            o_Raccoon_X <= (GAME_WIDTH / 2) / GRID_WIDTH * GRID_WIDTH;  // Reset to the center
            o_Raccoon_Y <= (GAME_HEIGHT - PLAYER_HEIGHT) / GRID_HEIGHT * GRID_HEIGHT; // Aligned at the bottom

            // Increment the level if it is less than 9
            if (o_Level < 4'd9) begin
                o_Level <= o_Level + 1; // Move to the next level
            end
        end
    end
endmodule
