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
    output o_Segment2_G
);

    // --- Position du joueur (raton laveur) --- 
    wire [9:0] raccoonX;               // Position X du joueur
    wire [9:0] raccoonY;               // Position Y du joueur
    wire [3:0] level;                  // Niveau courant
    wire collision;                    // Signal de collision
    wire [1:0] game_state;             // Etat du jeu (00: idle, 01: running, 10: win, 11: clean)
    
    // Signal pour démarrer le jeu
    wire i_StartGame = i_Switch_1 && i_Switch_2 && i_Switch_3;

    // Registre pour le niveau affiché
    reg [3:0] current_level;           // Niveau courant affiché

     // --- Détection des fronts montants et des maintiens des boutons ---
    wire debounced_up, debounced_dn, debounced_lt, debounced_rt;
    wire up_edge, dn_edge, lt_edge, rt_edge;

    // Instanciation des détecteurs pour chaque bouton
    Debounce_Switch debounce_Switch_1 (
        .i_Clk(i_Clk),
        .i_Switch(i_Switch_1),
        .o_Switch(debounced_up),
        .o_Switch_Edge(up_edge)
    );

    Debounce_Switch debounce_Switch_2 (
        .i_Clk(i_Clk),
        .i_Switch(i_Switch_2),
        .o_Switch(debounced_dn),
        .o_Switch_Edge(dn_edge)
    );

    Debounce_Switch debounce_Switch_3 (
        .i_Clk(i_Clk),
        .i_Switch(i_Switch_3),
        .o_Switch(debounced_lt),
        .o_Switch_Edge(lt_edge)
    );

    Debounce_Switch debounce_Switch_4 (
        .i_Clk(i_Clk),
        .i_Switch(i_Switch_4),
        .o_Switch(debounced_rt),
        .o_Switch_Edge(rt_edge)
    );

    // --- Instanciation du contrôleur de raton laveur ---
    raccoon_ctrl raccoonController (
        .i_Clk(i_Clk),
        .i_Raccoon_Up(debounced_up),  // Utilise l'état maintenu
        .i_Raccoon_Dn(debounced_dn),
        .i_Raccoon_lt(debounced_lt),
        .i_Raccoon_rt(debounced_rt),
        .o_Raccoon_X(raccoonX),
        .o_Raccoon_Y(raccoonY),
        .o_Level(level),
        .game_state(game_state),
        .i_Collision(collision)
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
    car_ctrl #(.C_CAR_X(0), .C_CAR_Y(128), .C_DIRECTION(1)) car1 (
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
        .vgaVs(o_VGA_VSync),
        .lives(lives_remaining) // Passer les vies restantes au module VGA
    );

    // --- Détection de collision --- 
    assign collision = ((raccoonX < carX_1 + CAR_WIDTH) && (raccoonX + PLAYER_WIDTH > carX_1) &&
                        (raccoonY < carY_1 + CAR_HEIGHT) && (raccoonY + PLAYER_HEIGHT > carY_1)) ||
                       ((raccoonX < carX_2 + CAR_WIDTH) && (raccoonX + PLAYER_WIDTH > carX_2) &&
                        (raccoonY < carY_2 + CAR_HEIGHT) && (raccoonY + PLAYER_HEIGHT > carY_2)) ||
                       ((raccoonX < carX_3 + CAR_WIDTH) && (raccoonX + PLAYER_WIDTH > carX_3) &&
                        (raccoonY < carY_3 + CAR_HEIGHT) && (raccoonY + PLAYER_HEIGHT > carY_3));

    // --- Instanciation du module de vies --- 
    wire [2:0] lives_remaining; // Vies restantes
    lives lives_inst (
        .i_Clk(i_Clk),
        .i_Reset(i_Switch_1 && i_Switch_2 && i_Switch_3 && i_Switch_4),       // Réinitialiser en cas de collision
        .i_Collision(collision),    // Indicateur de collision
        .o_Lives(lives_remaining)   // Vies restantes
    );

    always @(posedge i_Clk) begin
    // Si le jeu est réinitialisé (game_state == 00) ou si toutes les vies sont perdues ou si le niveau 9 est atteint
    if (game_state == 2'b00 || lives_remaining == 0 || level == 4'b1001) begin
        current_level <= 4'b0000;  // Réinitialiser le niveau à 0
    end else begin
        current_level <= level;  // Sinon, suivre le niveau courant
    end
end



    // --- Affichage du niveau sur les segments --- 
    reg [6:0] seg_display_units; // 7 segments pour l'unité
    

    // --- Logique d'affichage pour les segments --- 
    reg [3:0] r_Units;  // Unités
  

    always @(*) begin
        // Extraction des unités et dizaines à partir du niveau affiché
        r_Units = current_level % 10;  // Unités
        
        
        // Décodage des unités
         case (r_Units)
            4'b0000: seg_display_units = 7'b1000000; // 0
            4'b0001: seg_display_units = 7'b1111001; // 1
            4'b0010: seg_display_units = 7'b0100100; // 2
            4'b0011: seg_display_units = 7'b0110000; // 3
            4'b0100: seg_display_units = 7'b0011001; // 4
            4'b0101: seg_display_units = 7'b0010010; // 5
            4'b0110: seg_display_units = 7'b0000010; // 6
            4'b0111: seg_display_units = 7'b1111000; // 7
            4'b1000: seg_display_units = 7'b0000000; // 8
            4'b1001: seg_display_units = 7'b0010000; // 9
            default: seg_display_units = 7'b1111111; // Erreur
        endcase
        
       
    end

    // Connecte l'affichage des segments
   
    assign {o_Segment2_G, o_Segment2_F, o_Segment2_E, o_Segment2_D, o_Segment2_C, o_Segment2_B, o_Segment2_A} = seg_display_units; // Chiffre des dizaines à gauche

endmodule
