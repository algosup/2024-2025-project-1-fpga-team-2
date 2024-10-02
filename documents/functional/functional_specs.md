### **Functional Specifications for "Frogger" Game Recreation**

## **1. Introduction**

The purpose of this document is to outline the functional specifications for the recreation of the classic *Frogger* game. It details all the functionalities, features, and interactions that the game will encompass. This document aims to answer every potential "what" question regarding the game design and structure.

---

## **2. Game Overview**

**What is Frogger?**

Frogger is an arcade-style game where the player controls a frog that must make its way across a busy road and river to reach the other side safely. The objective is to avoid obstacles and reach the goal within a certain time.

**What is the main goal of the game?**

The goal of the game is to guide the frog from the bottom of the screen to a safe destination at the top, avoiding obstacles such as cars, trucks, and hazards in the river, and reaching the final "home" spaces.

---

## **3. Game Mechanics**

### **3.1 Movement and Controls**

**What controls are available to the player?**

- Players can move the frog up, down, left, or right using the switches of the board.

**What happens when the player moves the frog?**

- The frog moves one step in the chosen direction, and if the switch is maintained, the frog will pursue his way in the choosen direction until the switch is released.

**What restrictions are there on movement?**

- The frog cannot move off the screen.
- Movement are restricted based on obstacles such as traffic, water, and boundaries.

---

### **3.2 Obstacles and Hazards**

**What types of obstacles are there?**

1. **Traffic:**
    - Cars, garbage truck, and school buses move horizontally across the screen in predefined lanes.
2. <span style="color: grey">**River Hazards:**
    - Water is an instant hazard where the frog will drown unless standing on a floating object, as logs and trurtules.
    - Logs and turtles float on the river, allowing safe passage if timed correctly.</span>

**What happens when the frog encounters an obstacle?**

- If the frog touches a vehicle the player loses a life, and the frog returns to the start of the level.

---

### **3.3 Timer and Score**

**What is the purpose of the timer?**

- Each level has a time limit (60 seconds), requiring the player to move quickly to complete the level.

**What happens when the timer reaches zero?**

- The player will lose a life if the timer runs out before the frog reaches the destination.

**What scoring system is implemented?**

- Points are awarded for successfully completing a level.

---

### **3.4 Winning and Losing Conditions**

**What are the win conditions?**

- The player wins the level when all frogs safely reach the designated "home" spots at the top of the screen. Those 5 "homes" are represented by trashes. To complete a level, the player has to reach the five trashes.

**What are the losing conditions?**

- The player loses a life if they:
    - Get hit by a vehicle.
    - <span style="color: grey">Fall into the river.</span>
    - Run out of time.
    - Land in a non-home space at the top of the screen (the worksite barriers).
- The game is over when the 5 lives are lost.

---

## **4. Levels and Progression**

**What defines a level in the game?**

- A level consists of a road section with moving vehicles. <span style="color: grey">and a river section with floating logs, turtles, and hazards.</span> At the top of the screen are empty trashes slots where the raccoon must reach.

**What changes between levels?**

- **Traffic Speed and Volume:** Vehicles number increase (up to 16 at the same time on the screen), at the same time as their movement speed.
- <span style="color: grey">**River Difficulty:** The speed of logs/turtles increases, and gaps between safe zones may become larger.</span>

**What happens after the player completes a level?**

- The player proceeds to the next level, which increases in difficulty. The game continues until the player runs out of lives. Reaching the next level does not restore lives.

<span style="color: yellow"> -------------------------- </span>

## **5. User Interface (UI)**

### **5.1 Main Menu**

**What options are available in the main menu?**

- Start Game
- Highest Scores

**What does each option in the menu do?**

- **Start Game:** Launches the game from the first level.
- **High Scores:** Displays a leaderboard of top scores.

---

### **5.2 In-Game HUD**

**What information is displayed during gameplay?**

- **Score:** Shows the player’s current score.
- **Lives:** Displays the remaining lives (e.g. 3 bars).
- **Timer:** Shows the remaining time to complete the level.
- **Level Indicator:** Displays the current level.
- **Home Slots:** Indicates which home slots have been filled, each reached trash will contain a raccoon.

**What happens when the HUD elements change?**

- **Lives Decrease:** The frog icon in the lives indicator will disappear.
- **Score Increase:** The score number updates with every successful action (crossing lanes, collecting bonuses).
- **Timer Countdown:** The timer decreases in real time and alerts the player when time is nearly out.

---

## **6. Game Modes**

**What game modes are available?**

1. **Classic Mode:**
    - A recreation of the original arcade-style Frogger, featuring progressively harder levels and fixed obstacles.
2. **Endless Mode (optional):**
    - Players attempt to survive as long as possible with no set end to the game. The levels increase in difficulty indefinitely.
3. **Multiplayer Mode (optional):**
    - Two or more players can compete either locally or online, racing to get their frogs to safety while avoiding the same obstacles.

---

## **7. Sound and Music**

**What type of audio is in the game?**

- **Background Music:** An upbeat, arcade-style track that plays during gameplay.
- **Sound Effects:**
    - Jump sound for frog movement.
    - Collision sounds when the frog is hit.
    - River splash for falling in water.
    - Level-completion jingle when all frogs are safe.

**What customization is available for sound?**

- Players can adjust the volume of the background music and sound effects in the options menu.

---

## **8. Graphics and Animation**

**What is the graphical style of the game?**

- A pixel art or modernized 2D art style to mimic the retro look of the original Frogger, with smooth animations for movement and collisions.

**What animations are required?**

- **Frog Movement:** A jumping animation for each directional move.
- **Obstacle Movement:** Cars, trucks, logs, turtles, and other moving objects will have smooth animations across the screen.
- **Death Animation:** A short, distinct animation when the frog is hit or falls into the river.

---

## **9. Performance and Platform Compatibility**

**What platforms will the game support?**

- Desktop (Windows, macOS, Linux)
- Web (HTML5)
- Mobile (iOS, Android)

**What are the minimum performance requirements?**

- The game should run smoothly on low-end devices with minimal resource consumption.

---

## **10. Customization and Options**

**What customization options does the player have?**

1. **Graphics:**
    - Adjust quality settings (low, medium, high).
2. **Controls:**
    - Customize control schemes for different input devices (keyboard, touch controls, gamepads).
3. **Difficulty:**
    - Choose between Easy, Normal, and Hard modes that affect the speed and frequency of obstacles.

---

## **11. Special Features (Optional)**

**What additional features can be implemented?**

1. **Power-ups:**
    - Items such as "invincibility" for a short duration or "speed boost" can appear randomly in levels.
2. **Character Customization:**
    - Players can unlock different frog skins or costumes by achieving certain scores or completing levels.
3. **Achievements/Trophies:**
    - The game can include a set of achievements for players to unlock, like "First Time Survivor" or "Speed Demon."

---

## **12. Accessibility**

**What accessibility features are supported?**

1. **Color Blind Mode:**
    - Adjusts the color scheme for easier visibility.
2. **Subtitles/Visual Cues:**
    - Optional visual indicators for audio cues, making the game accessible for hearing-impaired players.
3. **Difficulty Scaling:**
    - Allows players to adjust the speed of the game for those who require slower pacing.

---

## **13. Updates and Expansions**

**What content updates are planned post-launch?**

- New levels with unique themes (e.g., different terrains like deserts, jungles).
- Seasonal or holiday-themed events with limited-time challenges or aesthetics.

---

## **14. Security and Data Handling**

**What data is stored in the game?**

- High scores and player settings (graphics, controls, sound) will be saved locally or to the cloud (if multiplayer).

**What measures are in place to ensure security?**

- Secure encryption for any online data and authentication methods for multiplayer.

---

## 15. Data handling

- High scores and player settings (graphics, controls, sound) will be saved locally or to the cloud (if multiplayer)