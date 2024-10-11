# Technical Specifications
---

|Author|Mattéo LEFIN|
|-|-|
|Created|09/26/2024|
|Finished|10/11/2024|

---

<details open>

<summary>Changelog</summary>

## Changelog

|Version|Date|Author|Description|
|-------|----|---|--|
|1.0|09/27/2024|Mattéo LEFIN| - Create documents and finished Overview.|
1.1| 10/01/2024|Mattéo LEFIN| - Add Overview and Conventions |
1.2| 10/02/2024|Mattéo LEFIN| - Remade the Table of content <br> - finished 3.1/2/3.B |
1.3| 10/08/2024|Mattéo LEFIN| - Added code in 3.5 |
1.4| 10/10/2024|Mattéo LEFIN| - Finished writing <br> - added winning/loosing schema <br> - Added all code|
1.5 | 10/11/2024|Mattéo LEFIN| - Text polishing <br> - Add images <br> - Delete Glossary |

</details>



---

<details open>

<summary>Table of content</summary>

## Table of content

[**1. Overview**](#1-overview)
 - [**1.1 Document purpose**](#1-document-purpose)
 - [**1.2 Project audiance**](#12-project-audiance)
 
[**2. Convention**](#2-conventions)
 - [**2.1 Naming convention**](#21-naming-conventions)
 - [**2.2 GitHub organization**](#22-github-organization)
 - [**2.3 Folder structure**](#23-folder-structure)

[**3. In technical details**](#3-in-technical-details)
 - [**3.1 Used technologies**](#31-used-technologies)
 - [**3.2 Go board set up**](#32-go-board-set-up)
 - [**3.3 Drawing in VGA**](#33-drawing-in-vga)
   - [**A. Graphics**](#a-graphics)
   - [**B. Sprites**](#b-sprites)
 - [**3.4 Controls and characters movements**](#34-controls-and-movements)
   - [**A. Car movements**](#a-car-movements)
   - [**B. Raccoon controls**](#b-raccoon-controls)
 - [**3.5 Game background**](#35-game-background)
 - [**3.6 Game mechanics**](#36-game-mechanics)
   - [**A. Wining and loosing mechanics**](#a-winning-and-loosing-mechanics)
   - [**B. Starting and finishing zone**](#b-starting-and-finishing-zone)
   - [**C. Lives**](#c-lives)
   - [**D. Points and high score**](#d-points-and-high-scores)

</details>

---

<details>

<summary>1. Overview</summary>

## 1. Overview

### 1. Document purpose

The purpose of this document is to provide clear and detailed information on the functionalities and structure of the project, enabling software engineers to understand the project requirements and the steps necessary to proceed.


### 1.2 Project audiance

Our project primarily targets nostalgic individuals and retro gaming enthusiasts, aiming to evoke the classic sensations of the past. With new designs, it will revive the old game, offering a new look.


</details>


---

<details>

<summary>2. Conventions</summary>

## 2. Conventions

### 2.1 Naming conventions

All details about our naming conventions and coding rules can be found in the [naming convention and rules document.](/documents/technical/naming_conventions_and_rules.md)

### 2.2 GitHub organization

- Each pull request must include labels, the associated project, the designated milestone, and at least two reviewers.
- Each issue must include labels, the associated project, the designated milestone, and an assigned team member.
- The working version should be merged into the `main` branch.
- Direct pushes to the main branch are not permitted.
- Team members must submit a pull request to merge their changes into the `main` branch.
- Only tested, functional code that has passed Quality Assurance (QA) should be pushed.

### 2.3 Folder Structure

A well-organized folder structure is essential for ensuring clear understanding of all file locations. 

Below is our file structure plan :

```
2024-2025-project-1-fpga-team-2
  ├── document/
  │     ├── functional/
  │     │   ├── functional_specification.md
  │     ├── management/
  │     ├── technical/
  │     │   ├── technical_specification.md  
  │     │   ├── naming_conventions_and_rules.md
  │     ├── images/
  │     │   ├── functional_specification/
  │     │   │   ├── (any images related to functional  documents)
  │     │   ├── management/
  │     │   │   ├── (any images related to management documents)
  │     │   ├── technical_specification/
  │     │   │   ├── (any images related to technical documents)
  ├── src/
  │   ├── (all the files related to code are here)
  ├── README.md

```

</details>

---

<details>

<summary>3. Into technicalities</summary>

## 3. In technical details

### 3.1 Used Technologies

#### A. Used computers

For this project, we used for developpement :
- LENOVO ThinkPad 21JKCTO1WW - Core i7 - 16 Go RAM - 512 SSD
- LENOVO ThinkBook 21DH - Code i7 - 16Go RAM - 512 Go SSD
- LENOVO ThinkBook 20SL - Code i7 - 16Go RAM - 512 Go SSD
- Four Macbook Air M3 2024 - 16 Go RAM - 512 SSD

- A Screen compatible with [*VGA](#glossarry) system.

#### B. The board

For this project, we will be using a Go Board provided by [Russel Merrick](https://www.linkedin.com/in/russell-merrick-6058b34/).

![Go_board_image](/documents/images/technical/goboard.jpg)

On this board we need to use :

- The four switches for the frog movement.
- The VGA to display it on a compatible screen.
- The LED segments for current score.

You can access the Go Board plans by [Clicking here](https://nandland.com/wp-content/uploads/2022/06/Go_Board_V1.pdf).

#### C. Debuging system

For debugging, we are using [EDAplayground](https://edaplayground.com)

### 3.2 Go Board set up

The Go Board needs some set up to be used properly by using the [the Go_Board documentation](https://nandland.com/go-board-tutorials/) provided directly on Nandland website.

### 3.3 Drawing in VGA

#### A. Graphics

First, you will need a VGA cable, which should be connected to the board and to a compatible screen.

To display anything on the VGA screen, we display pixels in segments, which means the screen is refreshed by quickly changing the color of each pixel horizontally, progressing row by row until it reaches the bottom-right corner.

As shown in the diagram below, the screen is divided into rows and columns, represented by the V_sync_Pulse and H_sync_Pulse, which alternate between 1 and 0 depending on their current state.

Once the program finishes drawing a row, the V_Sync_Pulse will change state to 1, moving the process to the next row. This continues until the final row is drawn, at which point the H_Sync_Pulse will also switch to 1.

![VGA screen schema](/documents/images/technical/vga_screen_schema.png)

The image in pixels is considered complete when both the V_sync_Pulse and H_sync_Pulse reach a state of 1, indicating that the entire image has been drawn. At this point, the process will begin again for the next image. This happens so quickly that the row-by-row rendering is imperceptible to the human eye, and we only see the fully rendered image.


#### B. Sprites

We can utilize up to 16 different colors for sprites, which reduces their quality and requires us to make careful selections from the 512 available colors for our game.

Once we have selected the colors for our sprites, we simulate their appearance using [Aseprite](https://www.aseprite.org) to create our sprite designs and gain a clearer understanding of how they will look in the game.

![Aseprite Raccoon](/documents/images/technical/raccoon.png)

*Making off of the raccoon sprite on Asersprite*

Once completed, we will create the raccoon sprite as a bitmap in `raccoon_paddle_ctrl.v`

![Raccoon bit map](/documents/images/technical/raccoon_bit_map.png)

*The `raccoon_paddle_ctrl.v` file, the raccoon bitmap is limited to only two colors due to memory constraints: black is represented by 0, and grey is represented by 1."* 


### 3.4 Controls and movements


#### A Car movements

Different cars should move horizontally across the road, either from left to right or from right to left, depending on their designated lane.

To achieve this, we first determine whether the car starts from the right or the left by assigning a value of 0 (for left) or -1 (for right).

Next, we specify the direction in which the car will move, using the same system: 0 indicates movement to the right, while 1 indicates movement to the left.

```Verilog

module car_Ctrl 
  #(parameter c_GAME_WIDTH=640, // Game's horizontal resolution
    parameter c_GAME_HEIGHT=480, // Game's vertical resolution
    parameter c_initial_position = 0, // Initial position of the car(0 for the left, c_GAME_WIDTH - 1 for the right)
    parameter c_direction = 0,   // Movement direction(0 = right, 1 = left)
    parameter c_car_SPEED = 1650000,  // Car's speed
    parameter c_CAR_WIDTH = 32,  // Configured car width
    parameter c_CAR_HEIGHT = 32) // Configured car height

```

*Parameters for the car control in `car_crtl.v`*

Next, we need to determine and record the position of the car.

```Verilog
(
    input            i_Clk,
    input            i_Game_Active,
    input [9:0]      i_Col_Count_Div, // Columns counter (10 bits)
    input [9:0]      i_Row_Count_Div, // Lines counter (10 bits)
    input [9:0]      i_car_Y,         //  Vertical  position(Y) of the car
    output reg       o_Draw_car,      // Indicator to draw the car
    output reg [9:0] o_car_X = 0,     // Horizontal position (X) of the car
    output reg [9:0] o_car_Y = 0      // Vertical  position(Y) of the car
  );

```

*Initialization of the position in `car_crtl.v`*

Finally, to enable the car to move, we must update its position based on the direction in which it is heading.

```Verilog
        // Car's movement
        if (c_direction == 0)  // If the direction is equal to 0, The car moves to the right
        begin
          if (o_car_X == c_GAME_WIDTH - 1)
            o_car_X <= 0; 
          else
            o_car_X <= o_car_X + 1; 
        end
        else  // If the direction is equal to 0, The car moves to the right
        begin
          if (o_car_X == 0)
            o_car_X <= c_GAME_WIDTH - 1; 
          else
            o_car_X <= o_car_X - 1; 
```
*movement of the car in `car_crtl.v`*

#### B Raccoon controls

To control the main character, the raccoon, we will utilize the four buttons to move it in the following order:

- Switch 1 : Up
- Switch 2 : Left
- Switch 3 : Down
- Switch 4 : Right

To ensure this functionality, we first need to initialize the buttons in `go_Board_Constraints.pcf`.

```Verilog
## Push-Button Switches
set_io i_Switch_1 53 // it initialize as an input the switch by 
set_io i_Switch_2 51 // using  set_io <input/output name> <pin number>
set_io i_Switch_3 54 // 'set_io' means 'set_InputOutput'
set_io i_Switch_4 52
```
*Code section in go_Boards_Constraints.pcf where switches are initialized*

The code for the raccoon movement is similar to that of the cars; however, it also includes inputs to control the raccoon's movements.

```Verilog
(input            i_Clk,
   input [9:0]      i_Col_Count_Div, // Columns counter (10 bits)
   input [9:0]      i_Row_Count_Div, // Lignes counter (10 bits)
   input            i_Paddle_Up, // Indicator to move the raccoon forward
   input            i_Paddle_Dn, // Indicator to move the raccoon backward
   input            i_Paddle_lt, // Indicator to move the raccoon to the left
   input            i_Paddle_rt, // Indicator to move the raccoon to the right
   output reg       o_Draw_Paddle, // Indicator to draw the raccoon
   output reg [9:0] o_Paddle_Y,// Vertical  position(Y) of the raccoon
   output reg [9:0] o_Paddle_X);// Horizontal position(X) of the raccoon
```
*Initialization of the position and movements indicators in `raccoon_paddle_ctrl.v`*

Now that we have initialized the positions, we can implement the movement of the raccoon.

```Verilog

if (r_Paddle_Count == c_PADDLE_SPEED) begin
      // Paddle movement logic
      if (i_Paddle_Up == 1'b1 && o_Paddle_Y > 0)
        o_Paddle_Y <= o_Paddle_Y - 1; // If we press the UP button, the raccoon goes forward
      else if (i_Paddle_Dn == 1'b1 && o_Paddle_Y < c_GAME_HEIGHT - c_PADDLE_HEIGHT) 
        o_Paddle_Y <= o_Paddle_Y + 1;// If we press the Down button, the raccoon goes backward
      else if (i_Paddle_lt == 1'b1 && o_Paddle_X > 0)
        o_Paddle_X <= o_Paddle_X - 1;// If we press the UP button, the raccoon goes to the left
      else if (i_Paddle_rt == 1'b1 && o_Paddle_X < c_GAME_WIDTH - c_PADDLE_WIDTH) 
        o_Paddle_X <= o_Paddle_X + 1;// If we press the UP button, the raccoon goes to the right 

    end

```
*Movements and controls of the raccoon in `raccoon_paddle_ctrl.v`*


### 3.5 Game background

We are unable to obtain the background for our game in time for implementation.

### 3.6 Game mechanics

#### A. Winning and loosing mechanics

![winning/loosing schema](/documents/images/technical/winning_loosing_schema.png)
*A schema of how we can win or loose in the game*



#### B. Starting and finishing zone

The starting zone is where the raccoon will appear and start crossing the road.

The finishing zone represents the raccoon's objective, where he must enter the trash cans to earn points.

To determine if the raccoon is in the finishing zone, we first need to identify its boundaries.

```Verilog
  if (w_Paddle_Y_P1 <= 0) 
        
        begin // Victory condition
          r_SM_Main <= WIN;           // Transition to WIN state
        end
```

#### C. Lives


To enable the game to recognize how to loose lives, we first need to implement collision detection.

```Verilog

  always @(*) begin
    collision = 0;
    for (j = 0; j < c_CAR_COUNT; j = j + 1) 
    begin 
        if (r_Paddle_X_P1 < w_car_X[j] + 64 && r_Paddle_X_P1 + 32 > w_car_X[j] && // The raccoon over the car on X
        r_Paddle_Y_P1 < w_car_Y[j] + 32 && r_Paddle_Y_P1 + 32 > w_car_Y[j])
        // The raccoon over the car on Y
      begin  
        collision = 1; // Hitted by the car
        lives <= lives - 1; // Lose a life
      end
    end
  end

```

*Collision of the car and how the player loose a life if the raccoon touches it in `raccoon_game.v`.*

If we lose all of our lives, the game will completely cease to operate.


#### D. Points and high score

Points and high score will be calculated based on basic computations, determined by the actions that affect the score.

To enable the game to accurately count points, we first need to implement collision detection.

```Verilog

output [7:0]     o_Score // we set a score output (8 bit)

//...

// Modify the output score
  assign o_Score = r_Score;

//...

if (w_Paddle_Y_P1 <= 0) 
        
        begin // Victory condition
          r_Score <= r_Score + 1;     // Increment the score
          r_SM_Main <= WIN;           // Transition to WIN state
        end

//...

```

*Parts of the code that add incrementation of the score if we touch the finishing zone in `raccoon_game.v`*

Afterward, we should display the points and high scores on the board.

```Verilog

module SevenSegmentDisplay
  (input            i_Clk,
   input [7:0]      i_Score,  // 8-bit score input
   output reg [6:0] o_Segment_Units); // 7-segment display for units

  reg [3:0] r_Units;

  always @(posedge i_Clk) begin
    r_Units <= i_Score % 10; // Extract the units digit
  end

  // 7-segment decoder for units
  always @(*) begin
    case (r_Units)
      4'b0000: o_Segment_Units = 7'b1000000; // 0
      4'b0001: o_Segment_Units = 7'b1111001; // 1
      4'b0010: o_Segment_Units = 7'b0100100; // 2
      4'b0011: o_Segment_Units = 7'b0110000; // 3
      4'b0100: o_Segment_Units = 7'b0011001; // 4
      4'b0101: o_Segment_Units = 7'b0010010; // 5
      4'b0110: o_Segment_Units = 7'b0000010; // 6
      4'b0111: o_Segment_Units = 7'b1111000; // 7
      4'b1000: o_Segment_Units = 7'b0000000; // 8
      4'b1001: o_Segment_Units = 7'b0010000; // 9
      default: o_Segment_Units = 7'b1111111; // Error state
    endcase
  end

  // 7-segment decoder has to be done for tens


endmodule
```
*Units display in `Score_boarding.v`*

</details>