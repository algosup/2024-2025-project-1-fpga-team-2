module Frogg_Game
  #(parameter c_TOTAL_COLS = 800,
    parameter c_TOTAL_ROWS = 525,
    parameter c_ACTIVE_COLS = 640,
    parameter c_ACTIVE_ROWS = 480,
    parameter c_GAME_WIDTH = 640,
    parameter c_GAME_HEIGHT = 480,
    parameter c_PADDLE_HEIGHT = 32,
    parameter c_PADDLE_WIDTH = 32,
    parameter c_PADDLE_COL_P1 = 0,
    parameter c_CAR_COUNT = 3)
  (input            i_Clk,
   input            i_HSync,
   input            i_VSync,
   input            i_Game_Start,
   input            i_Paddle_Up_P1,
   input            i_Paddle_Dn_P1,
   input            i_Paddle_lt_P1,
   input            i_Paddle_rt_P1,
   output reg       o_HSync,
   output reg       o_VSync,
   output [3:0]     o_Red_Video,
   output [3:0]     o_Grn_Video,
   output [3:0]     o_Blu_Video,
   output [7:0]     o_Score);  

  parameter IDLE = 3'b000, RUNNING = 3'b001, WIN = 3'b110, CLEANUP = 3'b100;

  reg [2:0] r_SM_Main = IDLE;
  wire [9:0] w_Col_Count, w_Row_Count;
  wire w_Game_Active;
  wire w_Draw_Paddle_P1;
  wire [9:0] w_Paddle_Y_P1;
  wire w_Draw_Any;

  // Variables liées aux voitures (X et Y)
  wire [c_CAR_COUNT-1:0] w_Draw_car;
  wire [9:0] w_car_X[c_CAR_COUNT-1:0];
  wire [9:0] w_car_Y[c_CAR_COUNT-1:0];

  // Synchronisation avec les colonnes et lignes
  Sync_To_Count #(.TOTAL_COLS(c_TOTAL_COLS), .TOTAL_ROWS(c_TOTAL_ROWS)) Sync_To_Count_Inst
    (.i_Clk(i_Clk), .i_HSync(i_HSync), .i_VSync(i_VSync),
     .o_HSync(w_HSync), .o_VSync(w_VSync),
     .o_Col_Count(w_Col_Count), .o_Row_Count(w_Row_Count));

  always @(posedge i_Clk) begin
    o_HSync <= w_HSync;
    o_VSync <= w_VSync;
  end

  Frogg_Paddle_Ctrl #(.c_PLAYER_PADDLE_X(c_PADDLE_COL_P1), .c_GAME_HEIGHT(c_GAME_HEIGHT)) P1_Inst
    (.i_Clk(i_Clk), .i_Col_Count_Div(w_Col_Count), .i_Row_Count_Div(w_Row_Count),
     .i_Paddle_Up(i_Paddle_Up_P1), .i_Paddle_Dn(i_Paddle_Dn_P1),
     .i_Paddle_lt(i_Paddle_lt_P1), .i_Paddle_rt(i_Paddle_rt_P1),
     .o_Draw_Paddle(w_Draw_Paddle_P1), .o_Paddle_Y(w_Paddle_Y_P1));

  // Génération des instances de voitures avec generate
  genvar i;
  generate
    for (i = 0; i < c_CAR_COUNT; i = i + 1) begin: cars
      car_Ctrl #(
        .c_initial_position((i == 0) ? 0 : 639),
        .c_direction((i == 0) ? 0 : 1),
        .c_car_SPEED(1000000 + (i * 70000)) // Vitesse décalée pour chaque voiture
      ) car_inst (
        .i_Clk(i_Clk), .i_Game_Active(w_Game_Active),
        .i_Col_Count_Div(w_Col_Count), .i_Row_Count_Div(w_Row_Count),
        .i_car_Y(50 + (i * 40)),  // Les voitures sont espacées verticalement
        .o_Draw_car(w_Draw_car[i]), .o_car_X(w_car_X[i]), .o_car_Y(w_car_Y[i])
      );
    end
  endgenerate

  // Declare score as a reg to keep its value across game states
  reg [7:0] r_Score = 0;

  // Modify the output score
  assign o_Score = r_Score;

  // Game state machine
  always @(posedge i_Clk) begin
    case (r_SM_Main)
      IDLE: begin
        if (i_Game_Start == 1'b1) begin
          // No reset of score, the score persists across game restarts
          r_SM_Main <= RUNNING; // Start the game
        end
      end
      RUNNING: begin
        if (w_Paddle_Y_P1 <= 0) begin // Victory condition
          r_Score <= r_Score + 1;     // Increment the score
          r_SM_Main <= WIN;           // Transition to WIN state
        end
      end
      WIN: begin
        // Add any additional win logic here (optional)
        r_SM_Main <= CLEANUP; // Transition to CLEANUP state
      end
      CLEANUP: begin
        // Any cleanup logic can go here if needed
        r_SM_Main <= IDLE; // Reset back to IDLE
      end
    endcase
  end

  // Jeu en cours
  assign w_Game_Active = (r_SM_Main == RUNNING);

  // Dessin de n'importe quel objet
  assign w_Draw_Any = w_Draw_Paddle_P1 || |w_Draw_car;

  // Couleurs de sortie
  always @(posedge i_Clk) begin
    if (w_Draw_Paddle_P1) begin
      o_Red_Video <= 4'b1100;
      o_Grn_Video <= 4'b1100;
      o_Blu_Video <= 4'b1100;
    end else if (|w_Draw_car) begin
      o_Red_Video <= 4'b1111;
      o_Grn_Video <= 4'b1111;
      o_Blu_Video <= 4'b1111;
    end else begin
      o_Red_Video <= 4'b0000;
      o_Grn_Video <= 4'b0000;
      o_Blu_Video <= 4'b0000;
    end
  end

endmodule
