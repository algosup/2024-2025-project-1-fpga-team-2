module top (
    input i_Clk,                       // Clock signal
    input i_Switch_1,                  // Button for up
    input i_Switch_2,                  // Button for down
    input i_Switch_3,                  // Button for right
    input i_Switch_4,                  // Button for left
    output o_VGA_Red_0,
    output o_VGA_Red_1,
    output o_VGA_Red_2,
    output o_VGA_Grn_0,
    output o_VGA_Grn_1,
    output o_VGA_Grn_2,
    output o_VGA_Blu_0,
    output o_VGA_Blu_1,
    output o_VGA_Blu_2,
    output o_VGA_HSync,
    output o_VGA_VSync,                 // VGA vertical sync

    // 7-segment display outputs
    output o_Segment2_A,
    output o_Segment2_B,
    output o_Segment2_C,
    output o_Segment2_D,
    output o_Segment2_E,
    output o_Segment2_F,
    output o_Segment2_G,

    // Added LEDs for lives
    output reg o_LED_1,
    output reg o_LED_2,
    output reg o_LED_3,
    output reg o_LED_4 // Just turn off 
);

    // --- Player (raccoon) position --- 
    wire [9:0] raccoonX;               // Player X position
    wire [9:0] raccoonY;               // Player Y position
    wire [3:0] level;                  // Current level
    wire collision;                    // Collision signal
    wire [1:0] game_state;             // Game state (00: idle, 01: running, 10: win, 11: clean)
    
    // Signal to start the game
    wire i_StartGame = i_Switch_1 && i_Switch_2 && i_Switch_3;

    // Register to display the current level
    reg [3:0] current_level;           // Displayed current level

    // // --- Déclarations des signaux débouncés ---
    // wire debounced_switch_1;
    // wire debounced_switch_2;
    // wire debounced_switch_3;
    // wire debounced_switch_4;

    // // --- Instanciation des modules debounce pour chaque bouton ---
    // debounce_switch debounce_1 (
    //     .i_Clk(i_Clk),
    //     .i_Switch(i_Switch_1),
    //     .o_Switch(debounced_switch_1)
    // );

    // debounce_switch debounce_2 (
    //     .i_Clk(i_Clk),
    //     .i_Switch(i_Switch_2),
    //     .o_Switch(debounced_switch_2)
    // );

    // debounce_switch debounce_3 (
    //     .i_Clk(i_Clk),
    //     .i_Switch(i_Switch_3),
    //     .o_Switch(debounced_switch_3)
    // );

    // debounce_switch debounce_4 (
    //     .i_Clk(i_Clk),
    //     .i_Switch(i_Switch_4),
    //     .o_Switch(debounced_switch_4)
    // );

    // --- Raccoon control module instantiation ---
    raccoon_ctrl raccoonController (
        .i_Clk(i_Clk),
        .i_Raccoon_Up(i_Switch_1),     // Button for up
        .i_Raccoon_Dn(i_Switch_2),     // Button for down
        .i_Raccoon_lt(i_Switch_4),     // Button for left
        .i_Raccoon_rt(i_Switch_3),     // Button for right
        // .i_Raccoon_Up(debounced_switch_1),    // Bouton pour monter (debounced)
        // .i_Raccoon_Dn(debounced_switch_2),    // Bouton pour descendre (debounced)
        // .i_Raccoon_lt(debounced_switch_4),    // Bouton pour gauche (debounced)
        // .i_Raccoon_rt(debounced_switch_3),    // Bouton pour droite (debounced)
        .i_Collision(collision),
        .game_state(game_state),
        .i_Reset_Level(i_Switch_1 && i_Switch_2 && i_Switch_3 && i_Switch_4), // Reset level
        .o_Raccoon_X(raccoonX),
        .o_Raccoon_Y(raccoonY),
        .o_Level(level)
    );

    // --- Game state management module instantiation --- 
    game_state gameStateModule (
        .i_Clk(i_Clk),
        .i_StartGame(i_StartGame),           // Signal to start the game
        .i_Collision(collision),             // Collision indicator
        .i_Lives(lives_remaining),           // Remaining lives
        .i_Win_Condition(level == 4'b1001),  // Win condition (level reached)
        .i_Reset(i_Switch_1 && i_Switch_2 && i_Switch_3 && i_Switch_4),  // Manual or end reset
        .o_Game_State(game_state)            // Game state (00: idle, 01: running, 10: win, 11: clean)
    );

    // --- Car positions --- 
    wire [9:0] carX_1;
    wire [8:0] carY_1;
    wire [9:0] carX_2;
    wire [8:0] carY_2;
    wire [9:0] carX_3;
    wire [8:0] carY_3;
    wire [9:0] carX_4;
    wire [8:0] carY_4;
    wire [9:0] carX_5;
    wire [8:0] carY_5;


    // --- Car modules instantiation --- 
    car_ctrl #(.C_CAR_X(0), .C_CAR_Y(256), .C_DIRECTION(1)) car1 (
        .i_Clk(i_Clk),
        .level(current_level), // Use the displayed level
        .game_state(game_state),
        .i_Reset(i_Switch_1 && i_Switch_2 && i_Switch_3 && i_Switch_4), // Reset on collision
        .o_carX(carX_1),
        .o_carY(carY_1)
    );

    car_ctrl #(.C_CAR_X(550), .C_CAR_Y(288), .C_DIRECTION(0)) car2 (
        .i_Clk(i_Clk),
        .level(current_level), // Use the displayed level
        .game_state(game_state),
        .i_Reset(i_Switch_1 && i_Switch_2 && i_Switch_3 && i_Switch_4), // Reset on collision
        .o_carX(carX_2),
        .o_carY(carY_2)
    );

    car_ctrl #(.C_CAR_X(200), .C_CAR_Y(384), .C_DIRECTION(1)) car3 (
        .i_Clk(i_Clk),
        .level(current_level),
        .game_state(game_state),
        .i_Reset(i_Switch_1 && i_Switch_2 && i_Switch_3 && i_Switch_4),
        .o_carX(carX_3),
        .o_carY(carY_3)
    );

    car_ctrl #(.C_CAR_X(300), .C_CAR_Y(96), .C_DIRECTION(0)) car4 (
    .i_Clk(i_Clk),
    .level(current_level),
    .game_state(game_state),
    .i_Reset(i_Switch_1 && i_Switch_2 && i_Switch_3 && i_Switch_4),
    .o_carX(carX_4),
    .o_carY(carY_4)
    );

    car_ctrl #(.C_CAR_X(400), .C_CAR_Y(160), .C_DIRECTION(1)) car5 (
    .i_Clk(i_Clk),
    .level(current_level),
    .game_state(game_state),
    .i_Reset(i_Switch_1 && i_Switch_2 && i_Switch_3 && i_Switch_4),
    .o_carX(carX_5),
    .o_carY(carY_5)
    );


    // --- VGA module instantiation --- 
    vga vga_inst (
        .clk(i_Clk),
        .raccoonX(raccoonX),
        .raccoonY(raccoonY),
        .carX_1(carX_1),
        .carY_1(carY_1),
        .carX_2(carX_2),
        .carY_2(carY_2),
        .carX_3(carX_3),
        .carY_3(carY_3),
        .carX_4(carX_4),
        .carY_4(carY_4),
        .carX_5(carX_5),
        .carY_5(carY_5),
        .vgaR({o_VGA_Red_2, o_VGA_Red_1, o_VGA_Red_0}),
        .vgaG({o_VGA_Grn_2, o_VGA_Grn_1, o_VGA_Grn_0}),
        .vgaB({o_VGA_Blu_2, o_VGA_Blu_1, o_VGA_Blu_0}),
        .vgaHs(o_VGA_HSync),
        .vgaVs(o_VGA_VSync)
    );

    // --- Collision detection --- 
    assign collision = ((raccoonX < carX_1 + CAR_WIDTH) && (raccoonX + PLAYER_WIDTH > carX_1) &&
                        (raccoonY < carY_1 + CAR_HEIGHT) && (raccoonY + PLAYER_HEIGHT > carY_1)) ||
                        ((raccoonX < carX_2 + CAR_WIDTH) && (raccoonX + PLAYER_WIDTH > carX_2) &&
                        (raccoonY < carY_2 + CAR_HEIGHT) && (raccoonY + PLAYER_HEIGHT > carY_2)) ||
                        ((raccoonX < carX_3 + CAR_WIDTH) && (raccoonX + PLAYER_WIDTH > carX_3) &&
                        (raccoonY < carY_3 + CAR_HEIGHT) && (raccoonY + PLAYER_HEIGHT > carY_3)) ||
                        ((raccoonX < carX_5 + CAR_WIDTH) && (raccoonX + PLAYER_WIDTH > carX_5) &&
                        (raccoonY < carY_5 + CAR_HEIGHT) && (raccoonY + PLAYER_HEIGHT > carY_5)) ||
                        ((raccoonX < carX_4 + CAR_WIDTH) && (raccoonX + PLAYER_WIDTH > carX_4) &&
                        (raccoonY < carY_4 + CAR_HEIGHT) && (raccoonY + PLAYER_HEIGHT > carY_4));

// --- Instantiation of the lives module --- 
wire [3:0] lives_remaining; // Remaining lives
lives lives_inst (
    .i_Clk(i_Clk),
    .i_Reset(i_Switch_1 && i_Switch_2 && i_Switch_3 && i_Switch_4),
    .i_Collision(collision),
    .o_Lives(lives_remaining)   // Remaining lives
);

always @(posedge i_Clk) begin
    // If the game is manually reset, or all lives are lost, or level 9 is reached
    if (i_Switch_1 && i_Switch_2 && i_Switch_3 && i_Switch_4) begin
        current_level <= 4'b0000;  // Reset the level to 0 on manual reset
    end else if (game_state == 2'b00 || lives_remaining == 0 || level == 4'b1001) begin
        current_level <= 4'b0000;  // Reset the level to 0 in other end cases
    end else begin
        current_level <= level;  // Otherwise, follow the current level
    end
end

// --- Instantiation of the segment decoder module ---
wire [6:0] seg_display_units;

segment_decoder segment_display (
    .i_Clk(i_Clk),                  // Clock signal
    .i_Level(current_level),        // Pass the current level
    .o_Segment(seg_display_units)   // Retrieve the decoded value
);

// --- Connect the segments to the display ---
assign {o_Segment2_G, o_Segment2_F, o_Segment2_E, o_Segment2_D, o_Segment2_C, o_Segment2_B, o_Segment2_A} = seg_display_units;

// --- Instantiation of the LED control module --- 
LED_control ledControl (
    .i_Lives(lives_remaining),      // Remaining lives
    .o_LED_1(o_LED_1),
    .o_LED_2(o_LED_2),
    .o_LED_3(o_LED_3)
);

endmodule
