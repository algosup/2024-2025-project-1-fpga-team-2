module vga (
    input wire clk,                    // Clock signal
    input wire [9:0] raccoonX,         // X position of the raccoon (10 bits)
    input wire [9:0] raccoonY,         // Y position of the raccoon (10 bits)
    input wire [9:0] carX_1,           // X position of the first car
    input wire [8:0] carY_1,           // Y position of the first car
    input wire [9:0] carX_2,           // X position of the second car
    input wire [8:0] carY_2,           // Y position of the second car
    input wire [9:0] carX_3,           // X position of the third car
    input wire [8:0] carY_3,           // Y position of the third car
    input wire [9:0] carX_4,           // X position of the fourth car
    input wire [8:0] carY_4,           // Y position of the fourth car
    input wire [9:0] carX_5,           // X position of the fifth car
    input wire [8:0] carY_5,           // Y position of the fifth car
    output reg [2:0] vgaR,             // VGA red signal
    output reg [2:0] vgaG,             // VGA green signal
    output reg [2:0] vgaB,             // VGA blue signal
    output reg vgaHs,                  // VGA horizontal sync
    output reg vgaVs                   // VGA vertical sync
);

    // Raccoon sprite RAM module instantiation
    wire [8:0] raccoon_sprite_data;        // Sprite data for the raccoon
    wire [$clog2(1024)-1:0] raccoon_sprite_addr;  // Sprite address
    ram #(.FILE_NAME("raccoon.txt")) raccoon_ram (
        .i_Clk(clk),
        .addr(raccoon_sprite_addr),
        .data_out(raccoon_sprite_data)
    );

    // Grass sprite RAM module instantiation
    wire [8:0] grass_sprite_data;          // Sprite data for the grass
    wire [$clog2(1024)-1:0] grass_sprite_addr;  // Sprite address
    ram #(.FILE_NAME("grasstest.txt")) grass_ram (
        .i_Clk(clk),
        .addr(grass_sprite_addr),
        .data_out(grass_sprite_data)
    );

    // Car sprite RAM module instantiation
    wire [8:0] car_sprite_data;            // Sprite data for the cars
    wire [$clog2(1024)-1:0] car_sprite_addr;   // Sprite address
    ram #(.FILE_NAME("cars.txt")) car_ram (
        .i_Clk(clk),
        .addr(car_sprite_addr),
        .data_out(car_sprite_data)
    );

    // Dotted line sprite RAM module instantiation
    wire [8:0] dotted_sprite_data;         // Sprite data for the dotted line
    wire [$clog2(1024)-1:0] dotted_sprite_addr; // Sprite address
    ram #(.FILE_NAME("dottedt.txt")) dotted_ram (
        .i_Clk(clk),
        .addr(dotted_sprite_addr),
        .data_out(dotted_sprite_data)
    );

    // Horizontal and vertical counters for VGA synchronization
    reg [9:0] hCount = 0;                  // Horizontal pixel counter
    reg [9:0] vCount = 0;                  // Vertical pixel counter

    // Calculated pixel positions
    reg [9:0] pixelX;
    reg [9:0] pixelY;

    always @(posedge clk) begin
        // Handle horizontal and vertical counters
        if (hCount == H_LINE - 1) begin
            hCount <= 0;
            if (vCount == V_LINE - 1) begin
                vCount <= 0;
            end else begin
                vCount <= vCount + 1;
            end
        end else begin
            hCount <= hCount + 1;
        end

        // Generate synchronization pulses
        vgaHs <= (hCount < H_SYNC_CYC) ? 0 : 1;
        vgaVs <= (vCount < V_SYNC_CYC) ? 0 : 1;

        // Check if we are in the active screen area
        if (hCount >= H_SYNC_CYC + H_BACK_PORCH && hCount < H_SYNC_CYC + H_BACK_PORCH + H_ACTIVE_VIDEO &&
            vCount >= V_SYNC_CYC + V_BACK_PORCH && vCount < V_SYNC_CYC + V_BACK_PORCH + V_ACTIVE_VIDEO) begin

            // Calculate active pixel positions
            pixelX <= hCount - (H_SYNC_CYC + H_BACK_PORCH);
            pixelY <= vCount - (V_SYNC_CYC + V_BACK_PORCH);

            // Default background is black
            vgaR <= BLACK;
            vgaG <= BLACK;
            vgaB <= BLACK;

            // Display colored stripes
            if (pixelY < 2 * GRID_HEIGHT) begin
                // Grey stripes on the first two lines of blocks
                grass_sprite_addr <= (pixelY - 13 * GRID_HEIGHT) * GRID_WIDTH + (pixelX % GRID_WIDTH);
                set_color(grass_sprite_data[8:6], grass_sprite_data[5:3], grass_sprite_data[2:0]);
            end else if (pixelY >= 7 * GRID_HEIGHT && pixelY < 8 * GRID_HEIGHT) begin
                // Specific colored stripes on lines 7 and 8
                grass_sprite_addr <= (pixelY - 13 * GRID_HEIGHT) * GRID_WIDTH + (pixelX % GRID_WIDTH);
                set_color(grass_sprite_data[8:6], grass_sprite_data[5:3], grass_sprite_data[2:0]);
            end else if (pixelY >= 13 * GRID_HEIGHT && pixelY < 15 * GRID_HEIGHT) begin
                // Specific colored stripes on lines 14 and 15
                grass_sprite_addr <= (pixelY - 13 * GRID_HEIGHT) * GRID_WIDTH + (pixelX % GRID_WIDTH);
                set_color(grass_sprite_data[8:6], grass_sprite_data[5:3], grass_sprite_data[2:0]);

            end else if (is_car(pixelX, pixelY, carX_1, carY_1, carX_2, carY_2, carX_3, carY_3, carX_4, carY_4, carX_5, carY_5)) begin
                // Calculate sprite address for the car
                if (in_bounds(pixelX, pixelY, carX_1, carY_1, CAR_WIDTH, CAR_HEIGHT)) begin
                    car_sprite_addr <= (pixelY - carY_1) * CAR_WIDTH + (pixelX - carX_1);
                end else if (in_bounds(pixelX, pixelY, carX_2, carY_2, CAR_WIDTH, CAR_HEIGHT)) begin
                    car_sprite_addr <= (pixelY - carY_2) * CAR_WIDTH + (pixelX - carX_2);
                end else if (in_bounds(pixelX, pixelY, carX_3, carY_3, CAR_WIDTH, CAR_HEIGHT)) begin
                    car_sprite_addr <= (pixelY - carY_3) * CAR_WIDTH + (pixelX - carX_3);
                end else if (in_bounds(pixelX, pixelY, carX_4, carY_4, CAR_WIDTH, CAR_HEIGHT)) begin
                    car_sprite_addr <= (pixelY - carY_4) * CAR_WIDTH + (pixelX - carX_4);
                end else if (in_bounds(pixelX, pixelY, carX_5, carY_5, CAR_WIDTH, CAR_HEIGHT)) begin
                    car_sprite_addr <= (pixelY - carY_5) * CAR_WIDTH + (pixelX - carX_5);
                end

                if (raccoon_sprite_data != 000000) begin
                    set_color(car_sprite_data[8:6], car_sprite_data[5:3], car_sprite_data[2:0]);
                end
            end else if (is_dotted_line(pixelX, pixelY)) begin
                // Display dotted lines on line 5
                set_color(WHITE, WHITE, WHITE);
            end

            // Display raccoon (with transparency for color 0x808080)
            if (in_bounds(pixelX, pixelY, raccoonX, raccoonY, PLAYER_WIDTH, PLAYER_HEIGHT)) begin
                raccoon_sprite_addr <= (pixelY - raccoonY) * PLAYER_WIDTH + (pixelX - raccoonX);
                // If the sprite pixel is not 0x808080 (medium gray)
                if (raccoon_sprite_data != 000001) begin  // Color 0x808080 (medium gray)
                    set_color(raccoon_sprite_data[8:6], raccoon_sprite_data[5:3], raccoon_sprite_data[2:0]);
                end
            end
        end else begin
            vgaR <= BLACK;
            vgaG <= BLACK;
            vgaB <= BLACK;
        end
    end

    // Task to set VGA colors
    task set_color(input [2:0] r, input [2:0] g, input [2:0] b);
        begin
            vgaR <= r;
            vgaG <= g;
            vgaB <= b;
        end
    endtask

    // Function to check if coordinates are within the bounds of an object
    function in_bounds(input [9:0] px, input [9:0] py, input [9:0] objX, input [9:0] objY, input [9:0] width, input [9:0] height);
        begin
            in_bounds = (px >= objX && px < objX + width && py >= objY && py < objY + height);
        end
    endfunction

    function is_grid(input [9:0] px, input [9:0] py);
        begin
            is_grid = (px % GRID_WIDTH == 0) || (py % GRID_HEIGHT == 0);
        end
    endfunction

    // Function to check if a pixel is part of a car
    function is_car(input [9:0] px, input [9:0] py, input [9:0] car1X, input [8:0] car1Y, input [9:0] car2X, input [8:0] car2Y, input [9:0] car3X, input [8:0] car3Y, input [9:0] car4X, input [8:0] car4Y, input [9:0] car5X, input [8:0] car5Y);
        begin
            is_car = in_bounds(px, py, car1X, car1Y, CAR_WIDTH, CAR_HEIGHT) ||
                     in_bounds(px, py, car2X, car2Y, CAR_WIDTH, CAR_HEIGHT) ||
                     in_bounds(px, py, car3X, car3Y, CAR_WIDTH, CAR_HEIGHT) ||
                     in_bounds(px, py, car4X, car4Y, CAR_WIDTH, CAR_HEIGHT) ||
                     in_bounds(px, py, car5X, car5Y, CAR_WIDTH, CAR_HEIGHT);
        end
    endfunction

    function is_dotted_line(input [9:0] px, input [9:0] py);
        begin
            // Dotted lines on line 5 (from 4 * GRID_HEIGHT + 8 to 4 * GRID_HEIGHT + 24)
            // Dotted lines on line 11 (from 10 * GRID_HEIGHT + 8 to 10 * GRID_HEIGHT + 24)
            is_dotted_line = ((py >= 4 * GRID_HEIGHT + 8 && py < 4 * GRID_HEIGHT + 24) ||
                              (py >= 10 * GRID_HEIGHT + 8 && py < 10 * GRID_HEIGHT + 24)) &&
                              ((px % (2 * GRID_WIDTH) >= 4 && px % (2 * GRID_WIDTH) < 28));
        end
    endfunction
    
endmodule
