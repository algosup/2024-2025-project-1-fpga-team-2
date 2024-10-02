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

</details>

---

<details open>

<summary>Glossary</summary>

## Glossarry

|Word|Definition|Source|
|-------|----|---|
|||| 

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
 - [**3.1 Used technologie's**]()
 - [**3.2 Go board set up**]()
 - [**3.3 Drawing in VGA**]()
   - [**A. Graphics**]()
   - [**B. The sprites**]()
 - [**3.4 Controls and characters movement**]()
   - [**A. Car movements**]()
   - [**B. Racoon movements**]()
 - [**3.5 Menu and game background**]()
   - [**A. The menu**]()
   - [**B. The background**]()
 - [**3.6 Game mechanics**]()
   - [**A. Wining and loosing mechanics**]()
   - [**B. Starting and finishing zone**]()
   - [**C. Points and high scores**]()
 - [**3.7 Score system**]()







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
- four MacOS 
- three Windows

#### B. The board

For this project, we need to use a Go Board given by [Russel Merrick]().

![Go_board_image]()

On this board we need to use :

- The four Switches for the frog movement.
- The VGA to show it on a ??? screen.
- The LED segments for levels.

You can access the Go Board plans by [Clicking here]().

#### C. Debuging system

For debugging, we are using [EDAplayground](https://edaplayground.com)

### 3.2 Go Board set up.

The Go Board needs some set up to be used properly by using the [Setup documentation]() provided directly on Nandland website.

### 3.3 Drawing in VGA.

#### A. Graphics.

To show anything on a VGA screen, we first

#### B. Sprites.

We can use up to 16 different colors by sprites, reducing the quality of it and forcing us to choose wisely which of the 512 colors available we will use in our game.

When we selected all the colors for our sprites, we simulate how we want a sprite to look like, for this we use [Asesprite]() to draw our sprite and have an idea on howw it will look like.

![Asersprite Racoon]()

*Making off of the racoon sprite on Asersprite*

When it's done, we do the racoon sprite in a bit map in `Frogg_Paddle_Ctrl.v`

![Racoon bit map]()

*Racoon bit map in Frogg_Paddle_Ctrl.v* 

### 3.4 Menu and game background.

#### A. The menu.

#### B. The Background.

### 3.5 Controls and movements.

#### A Car movements

The different cars should move horrizontaly on the road

#### B Racoon controls

To control the main character, the racoon, we'll use the four buttons to move it in this exact order :

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

The code for the racooon movement is similar to cars movement except we

### 3.6 Game mechanics.

#### A. Winning and loosing mechanics.

#### B. 

### 3.7 Score system.

The score system will


</details>