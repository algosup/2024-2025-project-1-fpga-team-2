`include "constants.v"

module top (
    input i_Clk,                       // Signal d'horloge
    input i_Switch_1,                  // Bouton pour monter
    input i_Switch_2,                  // Bouton pour descendre
    input i_Switch_3,                  // Bouton pour droite
    input i_Switch_4,                  // Bouton pour gauche
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
    output o_VGA_VSync,                 // Sync vertical VGA

    // Afficheurs à segments
    output o_Segment2_A,
    output o_Segment2_B,
    output o_Segment2_C,
    output o_Segment2_D,
    output o_Segment2_E,
    output o_Segment2_F,
    output o_Segment2_G,

    // Ajout led pour les vies
    output reg o_LED_1,
    output reg o_LED_2,
    output reg o_LED_3,
    output reg o_LED_4 // Just turn off 
);

    // --- Position du joueur (raccoon) --- 
    wire [9:0] raccoonX;               // Position X du joueur
    wire [9:0] raccoonY;               // Position Y du joueur
    wire [3:0] level;                  // Niveau courant
    wire collision;                    // Signal de collision
    wire [1:0] game_state;             // Etat du jeu (00: idle, 01: running, 10: win, 11: clean)
    
    // Signal pour démarrer le jeu
    wire i_StartGame = i_Switch_1 && i_Switch_2 && i_Switch_3;

    // Registre pour le niveau affiché
    reg [3:0] current_level;           // Niveau courant affiché

    raccoon_ctrl raccoonController (
        .i_Clk(i_Clk),
        .i_Raccoon_Up(i_Switch_1),     // Bouton pour monter
        .i_Raccoon_Dn(i_Switch_2),     // Bouton pour descendre
        .i_Raccoon_lt(i_Switch_4),     // Bouton pour gauche
        .i_Raccoon_rt(i_Switch_3),     // Bouton pour droite
        .i_Collision(collision),
        .game_state(game_state),
        .i_Reset_Level(i_Switch_1 && i_Switch_2 && i_Switch_3 && i_Switch_4), // Reset de niveau
        .o_Raccoon_X(raccoonX),
        .o_Raccoon_Y(raccoonY),
        .o_Level(level)
    );

    // --- Instanciation du module de gestion d'état du jeu --- 
    game_state gameStateModule (
        .i_Clk(i_Clk),
        .i_StartGame(i_StartGame),           // Signal pour démarrer le jeu
        .i_Collision(collision),             // Indicateur de collision
        .i_Lives(lives_remaining),           // Vies restantes
        .i_Win_Condition(level == 4'b1001),  // Condition de victoire (niveau atteint)
        .i_Reset(i_Switch_1 && i_Switch_2 && i_Switch_3 && i_Switch_4),  // Reset manuel ou en cas de fin
        .o_Game_State(game_state)            // Etat du jeu (00: idle, 01: running, 10: win, 11: clean)
    );

    // --- Positions des voitures --- 
    wire [9:0] carX_1;
    wire [9:0] carY_1;
    wire [9:0] carX_2;
    wire [9:0] carY_2;
    wire [9:0] carX_3;
    wire [9:0] carY_3;
    // --- Instanciation des voitures --- 
    car_ctrl #(.C_CAR_X(0), .C_CAR_Y(96), .C_DIRECTION(1)) car1 (
        .i_Clk(i_Clk),
        .level(current_level), // Utiliser le niveau affiché
        .game_state(game_state),
        .i_Reset(i_Switch_1 && i_Switch_2 && i_Switch_3 && i_Switch_4), // Réinitialiser en cas de collision
        .o_carX(carX_1),
        .o_carY(carY_1)
    );

    car_ctrl #(.C_CAR_X(100), .C_CAR_Y(160), .C_DIRECTION(0)) car2 (
        .i_Clk(i_Clk),
        .level(current_level), // Utiliser le niveau affiché
        .game_state(game_state),
        .i_Reset(i_Switch_1 && i_Switch_2 && i_Switch_3 && i_Switch_4), // Réinitialiser en cas de collision
        .o_carX(carX_2),
        .o_carY(carY_2)
    );

    car_ctrl #(.C_CAR_X(200), .C_CAR_Y(192), .C_DIRECTION(1)) car3 (
        .i_Clk(i_Clk),
        .level(current_level),
        .game_state(game_state),
        .i_Reset(i_Switch_1 && i_Switch_2 && i_Switch_3 && i_Switch_4),
        .o_carX(carX_3),
        .o_carY(carY_3)
    );

    // --- Instanciation du module VGA --- 
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
        .vgaR({o_VGA_Red_2, o_VGA_Red_1, o_VGA_Red_0}),
        .vgaG({o_VGA_Grn_2, o_VGA_Grn_1, o_VGA_Grn_0}),
        .vgaB({o_VGA_Blu_2, o_VGA_Blu_1, o_VGA_Blu_0}),
        .vgaHs(o_VGA_HSync),
        .vgaVs(o_VGA_VSync)
    );

    // --- Détection de collision --- 
    assign collision = ((raccoonX < carX_1 + 32) && (raccoonX + 32 > carX_1) &&
                        (raccoonY < carY_1 + 32) && (raccoonY + 32 > carY_1)) ||
                       ((raccoonX < carX_2 + 32) && (raccoonX + 32 > carX_2) &&
                        (raccoonY < carY_2 + 32) && (raccoonY + 32 > carY_2)) ||
                       ((raccoonX < carX_3 + 32) && (raccoonX + 32 > carX_3) &&
                        (raccoonY < carY_3 + 32) && (raccoonY + 32 > carY_3));

    // --- Instanciation du module de vies --- 
    wire [3:0] lives_remaining; // Vies restantes
    lives lives_inst (
        .i_Clk(i_Clk),
        .i_Reset(i_Switch_1 && i_Switch_2 && i_Switch_3 && i_Switch_4),
        .i_Collision(collision),
        .o_Lives(lives_remaining)   // Vies restantes
    );

    always @(posedge i_Clk) begin
        // Si le jeu est réinitialisé manuellement, ou si toutes les vies sont perdues, ou si le niveau 9 est atteint
        if (i_Switch_1 && i_Switch_2 && i_Switch_3 && i_Switch_4) begin
            current_level <= 4'b0000;  // Réinitialiser le niveau à 0 lors du reset manuel
        end else if (game_state == 2'b00 || lives_remaining == 0 || level == 4'b1001) begin
            current_level <= 4'b0000;  // Réinitialiser le niveau à 0 dans d'autres cas de fin
        end else begin
            current_level <= level;  // Sinon, suivre le niveau courant
        end
    end

    // --- Instanciation du module de décodage des segments ---
    wire [6:0] seg_display_units;

    segment_decoder segment_display (
        .i_Clk(i_Clk),                  // Horloge
        .i_Level(current_level),        // Passer le niveau courant
        .o_Segment(seg_display_units)   // Récupérer la valeur décodée
    );

    // --- Connecter les segments à l'afficheur ---
    assign {o_Segment2_G, o_Segment2_F, o_Segment2_E, o_Segment2_D, o_Segment2_C, o_Segment2_B, o_Segment2_A} = seg_display_units;

    // --- Instanciation du module de contrôle des LEDs --- 
    LED_control ledControl (
        .i_Lives(lives_remaining),      // Vies restantes
        .o_LED_1(o_LED_1),
        .o_LED_2(o_LED_2),
        .o_LED_3(o_LED_3)
    );

endmodule
