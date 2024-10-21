module lives (
    input i_Clk,
    input i_Reset,
    input i_Collision,
    output reg [3:0] o_Lives  // You have 4 bits here, which is correct for 0 to 3 lives
);

    reg collision_d;

    initial begin
        o_Lives = 3;                // Initialize to 3 lives
        collision_d = 0;            // Initialize previous collision state
    end

    always @(posedge i_Clk ) begin
        if (i_Reset) begin
            o_Lives <= 3;           // Reset to 3 lives
            collision_d <= 0;       // Reset previous collision state
        end else begin
            // Detect the rising edge of the collision
            if (i_Collision && !collision_d && o_Lives > 0) begin
                o_Lives <= o_Lives - 1; // Decrease the number of lives on a rising edge of collision
            end
            // Store the current state of the collision for rising edge detection
            collision_d <= i_Collision;
        end
    end
endmodule
