# Frogger - Team 2

[Frogger](https://en.wikipedia.org/wiki/Frogger) is a classic arcade game originally developed by [Konami](https://en.wikipedia.org/Konami) in 1981. The game's objective is to guide a frog from the bottom of the screen to its home at the top, avoiding various obstacles along the way.

## Gameplay

#### <span style="font-family: Courier; font-weight: 300">1. Objective</span>

The player controls a frog, navigating it through multiple hazards, such as moving cars. The primary goal is to reach the frog’s home at the top of the screen without being hit by moving obstacles. 

#### <span style="font-family: Courier; font-weight: 300">2. Controls</span>

The player uses directional controls (up, down, left, right) to move the frog. The frog can move one step at a time, with each step taking it closer to its destination. Switches of the board will be used to controll the frog
<span style="color: grey"> A keyboard is required to play, since directional controls are the up, down, left and right arrows.</span>

#### <span style="font-family: Courier; font-weight: 300">3. Game Mechanics</span>

- **Welcome Screen**: Once the game has been launched, the welcome screen appears, with a 'Start' button allowing the player to begin a new game.

- **Starting zone**: The bottom of the screen, serves as starting area for every level, which is equivalent to a row in terms of size, and this row is obstacle-free.

- **Travel Mechanic**: The player must hop onto safe spaces, those who remains free of vehicules for a short period of time, to travel across the map.

- **Road Traffic**: Vehicles move horizontally across the screen, from left to right or conversely, and their amount and speed can vary from one row to another. Colliding with any of them will result in losing the game and displaying the game over screen.

- **Game Over**: When the player loose, game over's screen and a replay button will be displayed. Pressing the restart button will bring back the player to the first level.

- **Home Spaces**: At the top of the screen are safe spaces where the frog must land to complete the level. Completing a level allow the player to earn points and send him to the starting zone of the next level.

- **Points**: Points are earned by finishing a level, they accumulate along the game, resulting as the final score of each game.

#### <span style="font-family: Courier; font-weight: 300">4. Levels and Difficulty</span>

As the player advances through the levels, the speed and difficulty increase. Vehicles move faster, and obstacles become more challenging to navigate.

## Technologies used
### Hardware Requirements
- <span style="font-family: Courier; font-weight: 100">**FPGA Board**</span>: A suitable FPGA development board.

- <span style="font-family: Courier; font-weight: 100">**Input/Output Devices**</span>: Buttons or joysticks for user controls, VGA output for video display.
- <span style="font-family: Courier; font-weight: 100">**Power Supply**</span>: Reliable power source with proper voltage regulation.
- <span style="font-family: Courier; font-weight: 100">**Testing Equipment**</span>: Logic analyzer, oscilloscope, or simulation probes for hardware debugging.
### Software Requirements
- <span style="font-family: Courier; font-weight: 100">**Simulation Tools**</span>: For testing game mechanics before hardware deployment.

- <span style="font-family: Courier; font-weight: 100">**Synthesis & Implementation Tools**</span>: To compile and synthesize the design for the FPGA.
- <span style="font-family: Courier; font-weight: 100">**Version Control System**</span>: GitHub or equivalent platform for collaboration and version tracking.

### Device

For this project, an **FPGA (Field Programmable Gate Array)** is used. An FPGA is a powerful hardware device that allows for the implementation of custom digital circuits. In this project, the FPGA will handle the core mechanics of the Frogger game, including rendering the screen, processing inputs from controls, and managing game states (such as traffic movement, collision detection, and score tracking). The flexibility of an FPGA allows for highly optimized real-time performance and parallel processing, making it ideal for a game like Frogger.

### Language

Since an FPGA is used, **Verilog** has been chosen to code the game. Verilog is a hardware description language (HDL) that enables us to design and simulate the digital circuits needed to implement Frogger's mechanics. With Verilog, we can define how the game logic behaves, such as how the frog moves, how the traffic progresses, and how collisions are detected. These behaviors are then transferred into the FPGA as hardware circuits, enabling fast and efficient execution of the game on the FPGA device.

## Designs and Visuals ...