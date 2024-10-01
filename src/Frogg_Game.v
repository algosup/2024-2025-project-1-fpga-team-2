module Frogg_Game
  #(parameter c_TOTAL_COLS=800,
    parameter c_TOTAL_ROWS=525,
    parameter c_ACTIVE_COLS=640,
    parameter c_ACTIVE_ROWS=480)
  (input            i_Clk,
   input            i_HSync,
   input            i_VSync,
   // Game Start Button   
   input            i_Game_Start,
   // Player 1 Controls (Controls Paddle)
   input            i_Paddle_Up_P1,
   input            i_Paddle_Dn_P1,
   input            i_Paddle_lt_P1,
   input            i_Paddle_rt_P1,
   // Output Video
   output reg       o_HSync,
   output reg       o_VSync,
   output [3:0]     o_Red_Video,
   output [3:0]     o_Grn_Video,
   output [3:0]     o_Blu_Video);

  // Local Constants to Determine Game Play
  parameter c_GAME_WIDTH  = 40;
  parameter c_GAME_HEIGHT = 30;
  parameter c_SCORE_LIMIT = 9;
  parameter c_PADDLE_HEIGHT = 1;
  parameter c_PADDLE_COL_P1 = 0;  // Col Index of Paddle for P1

  // State machine enumerations
  parameter IDLE    = 3'b000;
  parameter RUNNING = 3'b001;
  parameter LOSE    = 3'b101;  // New state for losing
  parameter WIN     = 3'b110;  // New state for winning
  parameter CLEANUP = 3'b100;

  reg [2:0] r_SM_Main = IDLE;

  wire       w_HSync, w_VSync;
  wire [9:0] w_Col_Count, w_Row_Count;
  
  wire       w_Game_Active;
  wire       w_Draw_Paddle_P1;
  wire [5:0] w_Paddle_Y_P1;
  wire       w_Draw_car, w_Draw_Any;
  wire [5:0] w_car_X, w_car_Y;

  reg [3:0] r_P1_Score = 0;

  // Divided version of the Row/Col Counters
  // Allows us to make the board 40x30
  wire [5:0] w_Col_Count_Div, w_Row_Count_Div;

  Sync_To_Count #(.TOTAL_COLS(c_TOTAL_COLS),
                  .TOTAL_ROWS(c_TOTAL_ROWS)) Sync_To_Count_Inst
    (.i_Clk(i_Clk),
     .i_HSync(i_HSync),
     .i_VSync(i_VSync),
     .o_HSync(w_HSync),
     .o_VSync(w_VSync),
     .o_Col_Count(w_Col_Count),
     .o_Row_Count(w_Row_Count));

  // Register syncs to align with output data.
  always @(posedge i_Clk)
  begin
    o_HSync <= w_HSync;
    o_VSync <= w_VSync;
  end

  // Drop 4 LSBs, which effectively divides by 16
  assign w_Col_Count_Div = w_Col_Count[9:4];
  assign w_Row_Count_Div = w_Row_Count[9:4];

  // Instantiation of Paddle Control + Draw for Player 1
  Frogg_Paddle_Ctrl #(.c_PLAYER_PADDLE_X(c_PADDLE_COL_P1),
                     .c_GAME_HEIGHT(c_GAME_HEIGHT)) P1_Inst
    (.i_Clk(i_Clk),
     .i_Col_Count_Div(w_Col_Count_Div),
     .i_Row_Count_Div(w_Row_Count_Div),
     .i_Paddle_Up(i_Paddle_Up_P1),
     .i_Paddle_Dn(i_Paddle_Dn_P1),
     .i_Paddle_lt(i_Paddle_lt_P1),
     .i_Paddle_rt(i_Paddle_rt_P1),
     .o_Draw_Paddle(w_Draw_Paddle_P1),
     .o_Paddle_Y(w_Paddle_Y_P1));

  // Instantiation of car Control + Draw
  car_Ctrl car_Ctrl_Inst
    (.i_Clk(i_Clk),
     .i_Game_Active(w_Game_Active),
     .i_Col_Count_Div(w_Col_Count_Div),
     .i_Row_Count_Div(w_Row_Count_Div),
     .o_Draw_car(w_Draw_car),
     .o_car_X(w_car_X),
     .o_car_Y(w_car_Y));

  // Parameters for car width
  parameter c_CAR_WIDTH = 2; // Width of the car

  // Register for storing the real X position of Paddle P1
  reg [5:0] r_Paddle_X_P1;
  reg [5:0] r_Paddle_Y_P1;

  // Store the actual paddle position on each cycle
  always @(posedge i_Clk) begin
    r_Paddle_X_P1 <= w_Col_Count_Div;
    r_Paddle_Y_P1 <= w_Paddle_Y_P1;
  end

  // Détection de collision améliorée avec la voiture (à la fois sur les axes X et Y)
  // Comparer la position réelle du paddle avec la voiture
  wire collision_with_car;
  assign collision_with_car = (r_Paddle_Y_P1 == w_car_Y) && 
                              (r_Paddle_X_P1 >= w_car_X && r_Paddle_X_P1 < (w_car_X + c_CAR_WIDTH));

  // Correction de la condition de perte de jeu
  // Check if the player reached the top (win condition)
  wire reached_top;
  assign reached_top = (w_Paddle_Y_P1 == 0);

  // Create a state machine to control the state of play
  always @(posedge i_Clk)
  begin
      case (r_SM_Main)

      // Stay in this state until Game Start button is hit
      IDLE :
      begin
          if (i_Game_Start == 1'b1)
              r_SM_Main <= RUNNING;
      end

      // Stay in this state until either player touches the car (lose) or reaches the top (win)
      RUNNING :
      begin
          if (collision_with_car)    // Collision with the car
              r_SM_Main <= LOSE;     // Perte si la collision est détectée
          else if (reached_top)      // Player reaches the top
              r_SM_Main <= WIN;
      end

      // Player loses
      LOSE :
      begin
          //go to CLEANUP state
          r_SM_Main <= CLEANUP;
      end

      // Player wins
      WIN :
      begin
          //go to CLEANUP state
          r_SM_Main <= CLEANUP;
      end

      CLEANUP :
      begin
          r_SM_Main <= IDLE;  // Return to the initial state
      end

      endcase
  end

  // Conditional Assignment based on State Machine state
  assign w_Game_Active = (r_SM_Main == RUNNING) ? 1'b1 : 1'b0;

  assign w_Draw_Any = w_Draw_Paddle_P1 || w_Draw_car;

  // Assign colors based on game state
  always @(posedge i_Clk)
  begin
    case (r_SM_Main)

      // Normal game play
      default:
      begin
        if (w_Draw_Any)  // If something is being drawn
        begin
          o_Red_Video <= 4'b1111;  // White
          o_Grn_Video <= 4'b1111;
          o_Blu_Video <= 4'b1111;
        end
        else  // Otherwise, black screen
        begin
          o_Red_Video <= 4'b0000;
          o_Grn_Video <= 4'b0000;
          o_Blu_Video <= 4'b0000;
        end
      end
    endcase
  end

endmodule // Frogg_Game
