module raccoon_Game
  #(parameter c_TOTAL_COLS = 800,
    parameter c_TOTAL_ROWS = 525,
    parameter c_ACTIVE_COLS = 640,
    parameter c_ACTIVE_ROWS = 480,
    parameter c_GAME_WIDTH = 640,
    parameter c_GAME_HEIGHT = 480,
    parameter c_PADDLE_HEIGHT = 32,
    parameter c_PADDLE_WIDTH = 32,
    parameter c_PADDLE_COL_P1 = 0,
    parameter c_CAR_COUNT = 1,
    parameter c_LIFE = 4) // Définir le paramètre de vie
  (
   input            i_Clk,
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
   output [7:0]     o_Score,
  );

  // State parameters
  parameter IDLE = 3'b000, RUNNING = 3'b001, WIN = 3'b110, CLEANUP = 3'b100;

  reg [2:0] r_SM_Main = IDLE;
  reg [9:0] r_Paddle_X_P1;
  reg [9:0] r_Paddle_Y_P1;
  wire [9:0] w_Col_Count, w_Row_Count;
  wire w_Game_Active;
  wire w_Draw_Paddle_P1;
  wire [9:0] w_Paddle_X_P1;
  wire [9:0] w_Paddle_Y_P1;
  wire w_Draw_Any;

  // Variables liées aux voitures (X et Y)
  wire [c_CAR_COUNT-1:0] w_Draw_car;
  wire [9:0] w_car_X[c_CAR_COUNT-1:0];
  wire [9:0] w_car_Y[c_CAR_COUNT-1:0];

  // Synchronisation avec les colonnes et lignes
  Sync_To_Count #(.TOTAL_COLS(c_TOTAL_COLS), .TOTAL_ROWS(c_TOTAL_ROWS)) Sync_To_Count_Inst
    (.i_Clk(i_Clk), .i_HSync(i_HSync), .i_VSync(i_VSync),
     .o_HSync(o_HSync), .o_VSync(o_VSync),
     .o_Col_Count(w_Col_Count), .o_Row_Count(w_Row_Count));

  // Paddle control
  raccoon_ctrl #(.c_PLAYER_PADDLE_X(c_PADDLE_COL_P1)) P1_Inst
    (.i_Clk(i_Clk), .i_Col_Count_Div(w_Col_Count), .i_Row_Count_Div(w_Row_Count),
     .i_Paddle_Up(i_Paddle_Up_P1), .i_Paddle_Dn(i_Paddle_Dn_P1),
     .i_Paddle_lt(i_Paddle_lt_P1), .i_Paddle_rt(i_Paddle_rt_P1),
     .o_Draw_Paddle(w_Draw_Paddle_P1), .o_Paddle_Y(w_Paddle_Y_P1), .o_Paddle_X(w_Paddle_X_P1));

  // Génération des instances de voitures
  genvar i;
  generate
    for (i = 0; i < c_CAR_COUNT; i = i + 1) begin: cars
      cars_ctrl #(
        .c_initial_position((i == 0) ? 0 : 639),
        .c_direction((i == 0) ? 0 : 1),
        .c_car_SPEED(100000 + (i * 70000)) // Vitesse décalée pour chaque voiture
      ) cars_inst (
        .i_Clk(i_Clk), .i_Game_Active(w_Game_Active),
        .i_Col_Count_Div(w_Col_Count), .i_Row_Count_Div(w_Row_Count),
        .i_car_Y(50 + (i * 40)),  // Les voitures sont espacées verticalement
        .o_Draw_car(w_Draw_car[i]), .o_car_X(w_car_X[i]), .o_car_Y(w_car_Y[i])
      );
    end
  endgenerate

  always @(posedge i_Clk) begin
    r_Paddle_X_P1 <= w_Paddle_X_P1;
    r_Paddle_Y_P1 <= w_Paddle_Y_P1;
  end

  reg collision;
  integer j;

  // Initialiser les vies et ajouter un registre pour suivre les collisions
  reg [3:0] r_Life = c_LIFE; // Initialise le nombre de vies
  reg collision_in_progress = 0; // Nouveau registre pour suivre l'état de collision

  // Logique de collision améliorée
  always @(*) begin
    collision = 0;
    for (j = 0; j < c_CAR_COUNT; j = j + 1) begin 
      if (r_Paddle_X_P1 < w_car_X[j] + 64 && r_Paddle_X_P1 + 32 > w_car_X[j] && // Chevauchement en X
          r_Paddle_Y_P1 < w_car_Y[j] + 32 && r_Paddle_Y_P1 + 32 > w_car_Y[j]) begin  
        collision = 1; 
      end
    end
  end

  // Declare score as a reg to keep its value across game states
  reg [7:0] r_Score = 0;

  // Modify the output score
  assign o_Score = r_Score;


  // Game state machine
  always @(posedge i_Clk) begin
    case (r_SM_Main)
      IDLE: begin
        if (i_Game_Start == 1'b1) begin
          r_Life <= c_LIFE; // Réinitialiser les vies
          collision_in_progress <= 0; // Réinitialiser l'état de collision
          r_SM_Main <= RUNNING; // Démarrer le jeu
        end
      end
      RUNNING: begin
        if (w_Paddle_Y_P1 <= 0) begin // Condition de victoire
          r_Score <= r_Score + 1; // Incrémenter le score
          r_SM_Main <= WIN; // Transition vers l'état WIN
        end else if (collision) begin
          if (!collision_in_progress) begin // Vérifier si la collision est nouvelle
            if (r_Life > 0) begin
              r_Life <= r_Life - 1; // Décrémenter les vies
            end
            collision_in_progress <= 1; // Indiquer que la collision est en cours
            if (r_Life == 1) begin
              r_SM_Main <= CLEANUP; // Transition vers CLEANUP si aucune vie restante
            end
          end
        end else begin
          collision_in_progress <= 0; // Réinitialiser lorsque le joueur est hors de la zone de collision
        end
      end
      WIN: begin
        // Logique supplémentaire de victoire (si nécessaire)
        r_SM_Main <= CLEANUP; // Transition vers l'état CLEANUP
      end
      CLEANUP: begin
        r_SM_Main <= IDLE; // Réinitialiser vers l'état IDLE
        r_Life <= c_LIFE;
      end
    endcase
  end

  // Indicateur de jeu actif
  assign w_Game_Active = (r_SM_Main == RUNNING);

  // Dessin de n'importe quel objet
  assign w_Draw_Any = w_Draw_Paddle_P1 || |w_Draw_car;

  // Instantiate life_module
  wire [3:0] life_red_video, life_grn_video, life_blu_video;

  life_module life_inst (
      .i_Life(r_Life),
      .i_Col_Count(w_Col_Count),
      .i_Row_Count(w_Row_Count),
      .o_Red_Video(life_red_video),
      .o_Grn_Video(life_grn_video),
      .o_Blu_Video(life_blu_video)
  );

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
      o_Red_Video <= life_red_video; // Couleurs de vie
      o_Grn_Video <= life_grn_video; // Couleurs de vie
      o_Blu_Video <= life_blu_video; // Couleurs de vie
    end
  end

endmodule
