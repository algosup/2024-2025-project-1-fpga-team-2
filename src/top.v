module top (
    input  i_Clk,
    input  i_Switch_1, // Bouton pour mouvement vers le haut
    input  i_Switch_2, // Bouton pour mouvement vers le bas
    input  i_Switch_3, // Bouton pour mouvement vers la droite
    input  i_Switch_4, // Bouton pour mouvement vers la gauche
    
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
    output o_VGA_VSync);
    
    wire [9:0] raccoon_x; // Ajusté pour être 10 bits pour VGA
    wire [9:0] raccoon_y; // Ajusté pour être 10 bits pour VGA

    // Instanciation des modules
    raccoon_ctrl raccoon_controller(
        .i_Clk(i_Clk),            
        .i_Raccoon_Up(i_Switch_1),    // Assigné au bouton pour mouvement vers le haut
        .i_Raccoon_Dn(i_Switch_2),    // Assigné au bouton pour mouvement vers le bas
        .i_Raccoon_lt(i_Switch_3),     // Assigné au bouton pour mouvement vers la gauche
        .i_Raccoon_rt(i_Switch_4),     // Assigné au bouton pour mouvement vers la droite
        .o_Raccoon_X(raccoon_x),       // Sortie de la position X du raccoon
        .o_Raccoon_Y(raccoon_y)        // Sortie de la position Y du raccoon
    );

    vga_display vga(
        .clk(i_Clk),
        .raccoon_x(raccoon_x),
        .raccoon_y(raccoon_y),
        .vga_hs(o_VGA_HSync), 
        .vga_vs(o_VGA_VSync), 
        .vga_r({o_VGA_Red_2, o_VGA_Red_1, o_VGA_Red_0}), 
        .vga_g({o_VGA_Grn_2, o_VGA_Grn_1, o_VGA_Grn_0}), 
        .vga_b({o_VGA_Blu_2, o_VGA_Blu_1, o_VGA_Blu_0}) 
    );
endmodule
