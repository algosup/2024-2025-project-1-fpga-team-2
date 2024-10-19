// constants.v
`ifndef CONSTANTS_V
`define CONSTANTS_V

// VGA timing constants for 640x480 resolution
localparam H_SYNC_CYC        = 96;    // Horizontal sync cycle
localparam H_BACK_PORCH      = 48;    // Horizontal back porch
localparam H_ACTIVE_VIDEO    = 640;   // Horizontal active video
localparam H_FRONT_PORCH     = 15;    // Horizontal front porch
localparam H_LINE            = 800;   // Total horizontal line width

localparam V_SYNC_CYC        = 1;     // Vertical sync cycle
localparam V_BACK_PORCH      = 33;    // Vertical back porch
localparam V_ACTIVE_VIDEO    = 480;   // Vertical active video
localparam V_FRONT_PORCH     = 10;    // Vertical front porch
localparam V_LINE            = 525;   // Total vertical line height

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

// Voitures (Cars) dimensions et propriétés
localparam CAR_WIDTH         = 64;    // Largeur de la voiture
localparam CAR_HEIGHT        = 32;    // Hauteur de la voiture
localparam C_CAR_SPEED = 24'd99;     // Fréquence de la vitesse (utilisée pour le contrôle de la vitesse)

`endif
