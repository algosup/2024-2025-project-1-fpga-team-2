module car_ctrl #(
    parameter C_CAR_X = 0,              // Starting position in X
    parameter C_CAR_Y = 128,            // Starting position in Y
    parameter C_DIRECTION = 1           // Direction of movement: 0 = Left, 1 = Right
) (
    input wire i_Clk,                   // Clock signal
    input wire [3:0] level,             // Game level (affects speed)
    input wire [1:0] game_state,        // Game state input
    input wire i_Reset,                 // Reset button
    output reg [9:0] o_carX,            // Car's X position
    output reg [8:0] o_carY             // Car's Y position
);

    // Initial position of the car
    reg [9:0] carX = C_CAR_X;           // X position initialized with the parameter
    reg [8:0] carY = C_CAR_Y;           // Fixed Y position

    // Counter to control the car's speed
    reg [15:0] speed_counter = 0;       // 16 bits should be enough for the counter
    reg [16:0] speed;                   // Speed of the car, reduced to 17 bits

    // Speed definition based on the game level
    always @(*) begin
        case (level)
            4'b0001: speed = 17'd50000;  // Level 1: initial speed
            4'b0010: speed = 17'd45000;  // Level 2: increased speed
            4'b0011: speed = 17'd40000;  // Level 3: faster
            4'b0100: speed = 17'd35000;  // Level 4: even faster
            4'b0101: speed = 17'd30000;  // Level 5: acceleration
            4'b0110: speed = 17'd25000;  // Level 6: notable speed
            4'b0111: speed = 17'd20000;  // Level 7: high speed
            4'b1000: speed = 17'd10000;  // Level 8: very fast
            default: speed = 17'd50000;  // Default speed level
        endcase
    end

    // Always block for car movement and reset management
    always @(posedge i_Clk) begin
        if (i_Reset) begin
            // Reset car positions to their starting positions
            carX <= C_CAR_X;
            carY <= C_CAR_Y;
            speed_counter <= 0;
        end else if (game_state == 2'b01) begin  // "running" state
            if (speed_counter < speed) begin
                speed_counter <= speed_counter + 1;
            end else begin
                speed_counter <= 0;  // Reset the speed counter

                // Move according to the direction
                if (C_DIRECTION == 1) begin
                    // Move to the right
                    if (carX < GAME_WIDTH - 1) begin
                        carX <= carX + 1;   // Increment X position to the right
                    end else begin
                        carX <= 0;  // Reset to the left if the right boundary is reached
                    end
                end else begin
                    // Move to the left
                    if (carX > 0) begin
                        carX <= carX - 1;   // Decrement X position to the left
                    end else begin
                        carX <= GAME_WIDTH - 1;  // Reset to the right if the left boundary is reached
                    end
                end
            end
        end

        // Update output signals
        o_carX <= carX;
        o_carY <= carY;  // Y position remains constant
    end

endmodule
