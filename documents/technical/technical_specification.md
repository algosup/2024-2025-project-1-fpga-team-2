# Technical Specifications
---

|Author|Mattéo LEFIN|
|-|-|
|Created|09/26/2024|
|Finished||

---

<details open>

<summary>Changelog</summary>

## Changelog

|Version|Date|Author|Description|
|-------|----|---|--|
|1.0|09/27/2024|Mattéo LEFIN| - Create documents and finished Overview.|
1.1| 10/01/2024|Mattéo LEFIN| - add Overview and conventions |
1.2| 10/02/2024|Mattéo LEFIN| - Remade the table of content <br> - finished 3.1/2/3.B |
1.3| 10/08/2024|Mattéo LEFIN| - added code in 3.5 |
1.4| 10/10/2024|Mattéo LEFIN| - finished writing <br> - added winning/loosing schema <br> - added all code|

</details>

---

<details open>

<summary>Glossary</summary>

## Glossarry

|Word|Definition|Source|
|-------|----|---|
|VGA||| 

</details>

---

<details open>

<summary>Table of content</summary>

## Table of content


[**Glossary**](#glossary)

[**1. Overview**](#1-overview)
 - [**1.1 Document purpose**](#1-document-purpose)
 - [**1.2 Project audiance**](#12-project-audiance)
 
[**2. Convention**](#2-conventions)
 - [**2.1 Naming convention**](#21-naming-conventions)
 - [**2.2 GitHub organization**](#22-github-organization)
 - [**2.3 Folder structure**](#23-folder-structure)

[**3. Into technicalities**](#3-into-technicalities)
 - [**3.1 Used technologie's**](#31-used-technologies)
 - [**3.2 Go board set up**](#32-go-board-set-up)
 - [**3.3 Drawing in VGA**](#33-drawing-in-vga)
   - [**A. Graphics**](#a-graphics)
   - [**B. Sprites**](#b-sprites)
 - [**3.4 Controls and characters movement**](#34-controls-and-movements)
   - [**A. Car movements**](#a-car-movements)
   - [**B. Raccoon controls**](#b-raccoon-controls)
 - [**3.5 Game background**](#35-game-background)
 - [**3.6 Game mechanics**](#36-game-mechanics)
   - [**A. Wining and loosing mechanics**](#a-winning-and-loosing-mechanics)
   - [**B. Starting and finishing zone**](#b-starting-and-finishing-zone)
   - [**C. Lives**](#c-lives)
   - [**D. Points and high scores**](#d-points-and-high-scores)

</details>

---

<details>

<summary>1. Overview</summary>

## 1. Overview

### 1. Document purpose

This document has for purpose to provide clear and detailed informations on functionalities and the structuration of the project for the software engineers to understand what's are the requirement of the projecte and the path to proceed.


### 1.2 Project audiance

Our project target's are mostly nostalgic people and retro gaming fans giving this good old sensation of the past. Refreshed with new designs, it will bring back this old game with a new look.


</details>


---

<details>

<summary>2. Conventions</summary>

## 2. Conventions

### 2.1 Naming conventions.

All details about our naming conventions and coding rules can be found on the [naming convention and rules document.]()

### 2.2 GitHub organization.

- Each pull-request has to contain labels, the project, the dedicated milestone, and at least 2 reviewers.
- Each issue has to contain labels, the project, the dedicated milestone, and the assigned member.
- The workin version shall go to ``main``.
- There can't be any direct push to the main. The member has to do a pull-request to merge their changes in the main.
- Only push working code that has been tested by the Quality Assurance.

### 2.3 Folder Structure.

A folder structure is mandatory for a good understanding of all file locations.

Here, you will find our file structure plan :

```
2024-2025-project-1-fpga-team-2
  ├── document/
  │     ├── functional_specification/
  │     │   ├── functional_specification.md
  │     ├── management/
  │     ├── technical_specification/
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
  ├── frogger (Game launcher)
  ├── READEME.md

```

</details>

---

<details>

<summary>3. Into technicalities</summary>

## 3. Into technicalities.

### 3.1 Used Technologies

#### A. Used computers

For this project, we used for developpment :
- LENOVO ThinkPad 21JKCTO1WW - Core i7 - 16 Go RAM - 512 SSD
- LENOVO ThinkBook 21DH - Code i7 - 16Go RAM - 512 Go SSD
- LENOVO ThinkBook 20SL - Code i7 - 16Go RAM - 512 Go SSD
- Four Macbook Air M3 2024 - 16 Go RAM - 512 SSD

- A Screen compatible with [*VGA](#glossarry) system.

#### B. The board

For this project, we need to use a Go Board given by [Russel Merrick]().

![Go_board_image]()

On this board we need to use :

- The four Switches for the frog movement.
- The VGA to show it on a compatible screen.
- The LED segments for levels.

You can access the Go Board plans by [Clicking here]().

#### C. Debuging system

For debugging, we are using [EDAplayground](https://edaplayground.com)

### 3.2 Go Board set up.

The Go Board needs some set up to be used properly by using the [Setup documentation]() provided directly on Nandland website.

### 3.3 Drawing in VGA.

#### A. Graphics.

Firstly, you need A VGA cable and attached it to the board and to a compatible screen.

Then, if we want to see anything on a VGA screen, we draw in segment meaning that it will change quickly the color of every pixel horyzontaly until he arrives at the bottom right of the screen.

You can see on this schema below that the screen is actually separated into rows and colums , represesnted by V_sync_Pulse and H_sync_Pulse with 1 or 0 depending on which state they are.

when the program finished to draws a row, V_Sync_Pulse will change state and will be at 1, then it will jump to the next row until it starts to draw the last row where H_Sync_Pulse state will be 1.

![VGA screen schema]()

The image is complete when both V and H sync pulse have a state of 1 that the image is completely drawed, and will start the next one. It does everything so quickly that the drawing of one row by one row isn't visible to human eye and we see directly the complete image.


#### B. Sprites.

We can use up to 16 different colors by sprites, reducing the quality of it and forcing us to choose wisely which of the 512 colors available we will use in our game.

When we selected all the colors for our sprites, we simulate how we want a sprite to look like, for this we use [Asesprite]() to draw our sprite and have an idea on howw it will look like.

![Asersprite Raccoon]()

*Making off of the raccoon sprite on Asersprite*

When it's done, we do the raccoon sprite in a bit map in `Frogg_Paddle_Ctrl.v`

![Raccoon bit map]()

*Raccoon bit map in Frogg_Paddle_Ctrl.v* 


### 3.4 Controls and movements.


#### A Car movements

The different cars should move horizontaly on the road from left to right or from right to left depending on which road he is.

For this, we first select if the car start from the right to the left by giving the car a value of 0 (left) or -1 (right).

then we select the direction which the car goes using the same system, 0 for right and 1 for left

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

Now, we need to know and register the car position.

```Verilog
(
    input            i_Clk,
    input            i_Game_Active,
    input [9:0]      i_Col_Count_Div, // Columns counter (10 bits)
    input [9:0]      i_Row_Count_Div, // Lignes counter (10 bits)
    input [9:0]      i_car_Y,         //  Vertical  position(Y) of the car
    output reg       o_Draw_car,      // Indicator to draw the car
    output reg [9:0] o_car_X = 0,     // Horizontal position (X) of the car
    output reg [9:0] o_car_Y = 0      // Vertical  position(Y) of the car
  );

```

*Initialization of the position in `car_crtl.v`*

Finally, to make our car actually move, we need to change the position depending on the direction that our car is heading.

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

To control the main character, the raccoon, we'll use the four buttons to move it in this exact order :

- Switch 1 : Forward
- Switch 2 : Left
- Switch 3 : Backwards
- Switch 4 : Right

![Switch plan]()

To ensure this, we firstly need to initialize the buttons in `go_Board_Constraints.pcf`.

```Verilog
## Push-Button Switches
set_io i_Switch_1 53 // it initialize as an input the switch by 
set_io i_Switch_2 51 // using  set_io <input/output name> <pin number>
set_io i_Switch_3 54 // 'set_io' means 'set_InputOutput'
set_io i_Switch_4 52
```
*Code section in go_Boards_Constraints.pcf whre switches are initialized*

The code for the racooon movement is similar to cars movement except we add also inputs to control the raccoon movements.

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
*Initialization of the position and movement indicators in `Frogg_Paddle_Ctrl.v`*

Now that we initialized our positions we can add the movement of the raccoon.

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
*Movements and controls of the raccoon in `Frogg_Paddle_Ctrl.v`*


### 3.5 Game background.

For the background of our game, we aren't able to have it on time to implement it.

### 3.6 Game mechanics.

#### A. Winning and loosing mechanics.

![winning/loosing schema](/documents/images/technical/winning:loosing%20schema.png)
*A schema of how we can win or loose in the game*



#### B. Starting and finishing zone.

The starting zone is where the raccoon will apear and so, start crossing the road.

The finishing zone is the objective of the raccoon. He has to enter the bins to gain points.

To detect if the raccoon is in the finishing zone we firstly identify where is the finishing zone.

```Verilog
  if (w_Paddle_Y_P1 <= 0) 
        
        begin // Victory condition
          r_SM_Main <= WIN;           // Transition to WIN state
        end
```

#### C. Lives


to make the game understand how to loose lives we need to create collision first.

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

*Collision of the car and how the player loose a life if the raccoon touches it `.v`*

if we loose all of our lives the game completely stops.


#### D. Points and high scores

Points and high scores would be calculated using basic calculation based on which action that can modify points are done.

![Points schema]()

to make the game understand how to count points we need to add collision first.

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

*Parts of the code that add incrementation of the score if we touch the finishing zone in `Frogg_game.v`*

After, we should display them on the board.

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