module top (
    input i_Clk,                        // Clock input
    input i_Switch_1,                  // Button for moving up
    input i_Switch_2,                  // Button for moving down
    input i_Switch_3,                  // Button for moving right
    input i_Switch_4,                  // Button for moving left
    
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
    output o_VGA_VSync
);

    wire [9:0] raccoonX;               // Adjusted to be 10 bits for VGA
    wire [9:0] raccoonY;               // Adjusted to be 10 bits for VGA

    // Instantiate raccoon controller module
    raccoon_ctrl raccoonController (
        .i_Clk(i_Clk),
        .i_Raccoon_Up(i_Switch_1),      // Assigned to the button for moving up
        .i_Raccoon_Dn(i_Switch_2),      // Assigned to the button for moving down
        .i_Raccoon_lt(i_Switch_3),       // Assigned to the button for moving left
        .i_Raccoon_rt(i_Switch_4),       // Assigned to the button for moving right
        .o_Raccoon_X(raccoonX),          // Output of raccoon X position
        .o_Raccoon_Y(raccoonY)           // Output of raccoon Y position
    );

    // Instantiate VGA module
    vga vga (
        .clk(i_Clk),
        .raccoonX(raccoonX),
        .raccoonY(raccoonY),
        .vgaHs(o_VGA_HSync), 
        .vgaVs(o_VGA_VSync), 
        .vgaR({o_VGA_Red_2, o_VGA_Red_1, o_VGA_Red_0}), 
        .vgaG({o_VGA_Grn_2, o_VGA_Grn_1, o_VGA_Grn_0}), 
        .vgaB({o_VGA_Blu_2, o_VGA_Blu_1, o_VGA_Blu_0}) 
    );

endmodule
