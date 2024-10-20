### **Functional Specifications for "Frogger" Game Recreation**


<summary>Content Table</summary>

- [1. Introduction](#1-introduction)
- [2. Game Overview](#2-game-overview)
- [3. Equipment](#3-equipment)
- [4. Game Mechanics](#4-game-mechanics)
    - [Movement and Controls](#41-movement-and-controls)
    - [Obstacles and Hazards](#42-obstacles-and-hazards)
    - [Timer and Score](#43-timer-and-score)
    - [Winning and Losing Conditions](#44-winning-and-losing-conditions)
- [5. Levels and Progression](#5-levels-and-progression)
- [6. User Interface (UI)](#6-user-interface-ui)
    - [In-Game HUD](#61-in-game-hud)
    - [Game Over HUD](#62-game-over-hud)
- [7. Game Modes](#7-game-modes)
- [8. Graphics and Animation](#8-graphics-and-animation)
- [9. Platform Compatibility](#9-platform-compatibility)
- [10. Updates and Expansions](#10-updates-and-expansions)
- [11. Data Handling](#11-data-handling)
- [Glossary](#glossary)

<br>
<br>

## **1. Introduction**

The purpose of this document is to outline the functional specifications for the recreation of the classic *Frogger* game. It details all the functionalities, features, and interactions that the game will encompass. This document aims to answer every potential "what" question regarding the game design and structure.

<br>
<br>

## **2. Game Overview**

**What is Frogger?**

Frogger is an arcade-style game where the player controls a frog that must make its way across a busy road and river to reach the other side safely. The objective is to avoid obstacles and reach the goal within a certain time.

**What is the main goal of the game?**

The goal of the game is to guide the frog from the bottom of the screen to a safe destination at the top, avoiding obstacles such as cars, trucks, and hazards in the river, and reaching the final "home" spaces.

**What are the visuals of the original version?**

For comparison purposes, let's introduce the original game designs :

<img title="a title" alt="Original frogger map" src="../images/functional/frogger_map.jpg" style="width: 600px; justify-item: center;">

**Description of the map and mechanics (from bottom to top):**

- The first purple zone is the starting zone, nothing can harm the frog here.

- The road is crossed horizontally by multiple obstacles (from left to right or inversely). If the frog hits an obstacle, a life is lost.

- The second purple zone is a safe zone, nothing can harm the frog here once again. It serves as transition from road to river.

- In the river, it is the opposite mechanic. The frog need to use the turtles shells and logs to cross the river. Some of the shells temporarily disappear. If the frog fall into the water, a life is lost.

- The last has the water lilys that serves as checkpoints. The frog must land on each of them to complete a level. If the frog landed on the cactus, a life is lost.


**What we decided to change compared to the original game?**

The player will now play a little raccoon, and all the basic concepts from the frogger, will be translated to fit with the raccoon. There is no longer river (in extension, turtles and logs also), the obstacles are garbage trucks, checkpoints are trashes, and cactuses are worksite barriers.

<br>
<br>

## **3. Equipment**

**Hardware**

- **FPGA** The game is programmed in verilog, and <b>FPGA</b> boards can handle this language (e.g. Lattice ICE40 HX1K).

- **Monitor**: Since the <a href="#fpga">FPGA</a> model used only support <a href="#vga">VGA</a> image transfer, a monitor that handle the VGA technology is required to play.

- **Power Supply (optional)**: If needed, you can use an external battery, with a micro-usb cable, so you don't need to have a computer along.

<br>
<br>

## **4. Game Mechanics**

### **4.1 Movement and Controls**

**What controls are available to the player?**

- Players can move the raccoon up, down, left, or right using the switches of the board.

**What happens when the player moves the raccoon?**

- The raccoon moves one step in the chosen direction, and if the switch is maintained, the raccoon will pursue its way in the chosen direction until the switch is released.

**What restrictions are there on movement?**

- The raccoon cannot move off the screen.
- Movements are restricted based on obstacles such as the garbage trucks.
- The raccoon cannot move in other ways than that : top, bottom, right and left. Moving in diagonal isn't allowed (and possible).

<br>

### **4.2 Obstacles and Hazards**

**What types of obstacles are there?**

**Traffic:** The vehicles are garbage trucks that move horizontally, across the screen in predefined lanes.

**What happens when the raccoon encounters an obstacle?**

- If the raccoon hit a garbage truck, the player loses a life, and the raccoon returns to the start of the level (5 rounds).

<br>

### **4.3 Timer and Score**

**What is the purpose of the timer?**

- Each round has a time limit (60 seconds), requiring the player to move quickly to complete the round.

**What happens when the timer reaches zero?**

- The player will lose a life if the timer runs out before the raccoon reaches a trash.

**What scoring system is implemented?**

- Points are awarded for successfully completing a level.

<br>

### **4.4 Winning and Losing Conditions**

**What are the win conditions?**

- The player wins the level when all raccoons safely reach the designated "home" spots at the top of the screen. Those 5 "homes" are represented by trashes. To complete a level, the player has to reach the five trashes. It's not allowed to reach the same trash twice during the same level.

**What are the losing conditions?**

- The player loses a life if they:
    - Get hit by a garbage truck.
    - Run out of time.
    - Land in a non-home space at the top of the screen (the worksite barriers).
- The game is over when the 3 lives are lost.

<br>
<br>

## **5. Levels and Progression**

**What defines a level in the game?**

- A level is decomposed in five 'rounds'. Rounds are related to the number of trashes at the top of the screen. Since the player has to reach all of them, there is five rounds. Reaching a trash brings the player to the 'next round'. But rounds remain in a single level. It's only after completing all the rounds that the player is allowed to go to the next level.

**What changes between levels?**

- **Traffic size and speed:** Vehicles number increase (up to 16 at the same time on the screen), and their movement speed also.

**What happens after the player completes a level?**

- The player is led to the next level, which increases in difficulty. The game continues until the player runs out of lives. Reaching the next level does not restore lives.

<br>
<br>

## **6. User Interface (UI)**

### **6.1 In-Game HUD (Heads-Up Display)**

**What informations are displayed during gameplay?**

- **Score:** Shows the player’s current score.
- **Lives:** Displays the remaining lives (e.g. 3 bars).
- **Timer:** Shows the remaining time to complete the level.
- **Level Indicator:** Displays the current level.
- **Home Slots:** Indicates which home slots have been filled. Each reached trash will contain a raccoon, and those not reached yet will remain empty.

**What happens when the HUD elements change?**

- **Lives Decrease:** A bar in the lives indicator will be removed.
- **Score Increase:** The score number updates with a calculation between the number of trash reached divided by the time required to do so. Reaching a trash gives +10'000 points.
- **Timer Countdown:** The timer decreases in real time to alerts the player when time is nearly out.

### **6.2 Game Over HUD**

**What will be on the game over screen ?**

- **Score of the current game**: Shows how many point the player scored this game
- **Highest score**: The highest score ever achieved on the game, serves as comparative data between the score of the current game.
- **Restart button**: Allows the player to restart a new game.

<br>
<br>

## **7. Game Modes**

**What game modes are available?**

**Classic Mode:**
- A recreation of the original <a href="#arcade-game">arcade-style</a> Frogger, featuring progressively harder levels and fixed obstacles.

<br>
<br>

## **8. Graphics and Animation**

**What is the graphical style of the game?**

- A <a href="#pixel-art">pixel art</a> art style to mimic the retro look of the original Frogger.

<br>
<br>

## **9. Platform Compatibility**

**What platforms will the game support?**

- <b><a href="#fpga">FPGA</a></b>s with at least a micro-usb power supply and a VGA cable.

<br>
<br>

## **10. Updates and Expansions**

**What additional features can be implemented?**

**UI**

- **Welcome screen**: Create a welcome screen with little designs, a start button (to start a new game) and the highest score ever made.

**Gamemodes**
- **Multiplayer (local)**: Adding a multiplayer mode may be a good thing to add competition. But that entails to add external hardware, like a keyboard or controller.

**Graphical animations**
- **Jumping animation**: An jumping animation (from 6 to 8 frames) of the raccoon while jumping in different directions.
- **Death animation**: A better designed death animation (from 2 to 4 frames)

**Customization and options**
- **Skins**: adding other raccoon skins (christmas raccoon, halloween raccoon, radioactive raccoon, rocket raccoon...)
- **Maps**: adding other maps (Zone 51, Space...)
- **Unlocking system**: Those cosmetics and maps will be earned by realizing different scores, as rewards.
- **Power-ups:**
    - Items such as "invincibility" for a short duration or "speed boost" can appear randomly in levels.

<br>
<br>

## **11. Data Handling**

**What data is stored in the game?**

- **Highest score**: The highest score has to be stored to add a virtual checkpoint for the player. Then he knows how far he's from his best score. Reminder : the score is calculated like that : <i>[(Number of trashes reached * 10'000) / time from start to end (all levels and rounds combined) in seconds]</i>

<br>
<br>

### Glossary

<b id="arcade-game">Arcade-style game:</b>
- A type of video game designed to be simple and straightforward, often featuring fast-paced action and short levels, inspired by games commonly found in amusement arcades.

<b id="fpga">FPGA (Field-Programmable Gate Array):</b>
- A type of integrated circuit that can be configured by the user or designer after manufacturing, often used in specialized gaming platforms.

<b id="pixel-art">Pixel Art:</b>
- A type of digital art where images are created and edited at the pixel level, often associated with retro-style video games for a nostalgic or minimalist look.

<b id="vga">VGA (Video Graphics Array) port:</b>
- A connector commonly used to transmit video signals from a device (such as an FPGA) to a monitor or display.
