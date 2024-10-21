`ifndef CONSTANTS_V
`define CONSTANTS_V

parameter H_SYNC_CYC = 96;
parameter H_BACK_PORCH = 46;
parameter H_ACTIVE_VIDEO = 640;
parameter H_FRONT_PORCH = 16;
parameter H_LINE = H_SYNC_CYC + H_BACK_PORCH + H_ACTIVE_VIDEO + H_FRONT_PORCH;

parameter V_SYNC_CYC = 1;
parameter V_BACK_PORCH = 33;
parameter V_ACTIVE_VIDEO = 480;
parameter V_FRONT_PORCH = 10;
parameter V_LINE = V_SYNC_CYC + V_BACK_PORCH + V_ACTIVE_VIDEO + V_FRONT_PORCH;

// Color constants
localparam [2:0] WHITE = 3'b111;  // White
localparam [2:0] RED   = 3'b100;  // Red
localparam [2:0] GREEN = 3'b010;  // Green
localparam [2:0] BLUE  = 3'b001;  // Blue
localparam [2:0] GRAY  = 3'b110;  // Gray
localparam [2:0] BLACK = 3'b000;  // Black

// Grid dimensions
localparam GRID_WIDTH        = 32;    // Width of each grid block
localparam GRID_HEIGHT       = 32;    // Height of each grid block

// Game area dimensions
localparam GAME_WIDTH        = 640;   // Game area width
localparam GAME_HEIGHT       = 480;   // Game area height

// Player (Raccoon) dimensions
localparam PLAYER_WIDTH      = 32;    // Raccoon width 
localparam PLAYER_HEIGHT     = 32;    // Raccoon height
localparam RACCOON_SPEED     = 21;    // Raccoon movement speed

// Car dimensions and properties
localparam CAR_WIDTH         = 32;    // Width of the car
localparam CAR_HEIGHT        = 32;    // Height of the car
localparam C_CAR_SPEED = 24'd99;     // Car speed control frequency

`endif
