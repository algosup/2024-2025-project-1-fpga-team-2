module game_state (
    input wire i_Clk,               // Clock signal
    input i_StartGame,              // Signal to start the game (start button)
    input i_Collision,              // Collision signal
    input wire [3:0] i_Lives,       // Number of remaining lives
    input i_Win_Condition,          // Win condition (e.g., reaching a position)
    input i_Reset,                  // Manual reset to restart the game
    output reg [1:0] o_Game_State   // Game state output (00: idle, 01: run, 10: win, 11: clean)
);

    // Declaration of game states
    localparam IDLE  = 2'b00;
    localparam RUN   = 2'b01;
    localparam WIN   = 2'b10;
    localparam CLEAN = 2'b11;

    // Current game state
    reg [1:0] r_CurrentState;
    reg [1:0] r_NextState;

    // Initialize the state to IDLE
    initial begin
        r_CurrentState = IDLE;
    end

    // State change logic
    always @(posedge i_Clk or posedge i_Reset) begin
        if (i_Reset) begin
            // Reset: return to IDLE state
            r_CurrentState <= IDLE;
        end else begin
            // Otherwise, move to the next state
            r_CurrentState <= r_NextState;
        end
    end

    // State transition logic
    always @(*) begin
        // By default, remain in the current state
        r_NextState = r_CurrentState;

        case (r_CurrentState)
            IDLE: begin
                // If the "start" button is pressed, move to RUN
                if (i_StartGame) begin
                    r_NextState = RUN;
                end
            end

            RUN: begin
                // If a collision occurs and there are lives left, move to CLEAN
                if (i_Collision && i_Lives > 0) begin
                    r_NextState = CLEAN;
                end
                // If the win condition is met, move to WIN
                else if (i_Win_Condition) begin
                    r_NextState = WIN;
                end
                // If all lives are lost, return to IDLE
                else if (i_Lives == 0) begin
                    r_NextState = IDLE;
                end
            end

            CLEAN: begin
                // After clearing the collision (e.g., after a reset), return to RUN
                if (!i_Collision) begin
                    r_NextState = RUN;
                end
            end

            WIN: begin
                // In case of a win, remain in WIN state until reset
                if (i_Reset) begin
                    r_NextState = CLEAN;
                end
            end
        endcase
    end

    // Update the game state output
    always @(*) begin
        o_Game_State = r_CurrentState;
    end

endmodule
