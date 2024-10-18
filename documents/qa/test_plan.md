<div align="center">

# Test Plan

---


**Project** : Frogger <br>
**Team** : 2 <br>
**Created by** : Enoal ADAM <br>
**Creation Date** : 09/26/2024 <br>
**Updated** : 17/11/2024 <br>

---

<details>
<summary>Table of content</summary>

- [Test Plan](#test-plan)
  - [1. Introduction](#1-introduction)
  - [2. Document purpose](#2-document-purpose)
  - [3. In-Scope/Out-Scope](#3-in-scopeout-scope)
    - [3.1 In-Scope](#31-in-scope)
    - [3.2 Out-Scope](#32-out-scope)
  - [4. Test goals](#4-test-goals)
    - [4.1. Tests' definition](#41-tests-definition)
    - [4.2 Test list](#42-test-list)
      - [A. Software tests (without visuals)](#a-software-tests-without-visuals)
      - [B. Technical/Hardware tests](#b-technicalhardware-tests)
      - [C. Visuals tests](#c-visuals-tests)
  - [5. Hardware used for tests](#5-hardware-used-for-tests)
    - [5.1. Computer](#51-computer)
    - [5.2. Go-Board](#52-go-board)
  - [6. Glossary](#6-glossary)

</details>
</div>

## 1. Introduction

The aim of this project is to, using the Verilog[^1] language, re-create a classic game named Frogger. It's an arcade game where reach each waterlilies (5 in total) is the goal. For doing that, the frog needs to avoid some cars on the roads, cross a river climbing on logs or turtles shells. Since is a re-creation, some sprites have changed like the frog, now a raccoon, cars which are now garbage trucks and waterlilies that are henceforth trash cans.

## 2. Document purpose

The aim of this document is to report what will be test on the game, as well the hardware[^2] side, as the software[^3] side. To do that, all the test will be carried out by manual testing.

More precisely, this document and the test cases will gether some information like:
- Check if the game works correctly or not.
- Ensures that the product answer at the software[^3] requirements.
- Identify the presence of bugs or other problems.
- Check the code's and game's security in order to not produce issues on the customer's hardware[^2].
- Verify the responsiveness of the product

## 3. In-Scope/Out-Scope

### 3.1 In-Scope
- Main functionalities
- No bugs or any kind of issues which could impact the gameplay
- Responsive and usable switches without latency
- A consistency between the current level (not round) and the number displays on the 7-segments screen
- Sprites which show correctly
- A playable sprite that moves according to the switches pushed

### 3.2 Out-Scope
- Sprites' colors
- Any futures updates or improvements (indicate in the [Functional Specification](documents/functional/functional_specifications.md))

## 4. Test goals

It's very important to correctly defined the tests for a understanding approach. Indeed, bugs, issues or anything else can be very well hidden in the code. In order to prevent these problems, each component will be tested individually and collectively with a particularly attention on the performance, verifying that previous features will not be impacted when implementing changes to the code.
You will find all the tests which will be carried out below.

### 4.1. Tests' definition

- **Unit test**

  - A unit test is a testing method where the units or component are checked individually so as to verify that all the features of a product work separately.
  
  <br><u>How does it work?</u>
  1. Write the tests for individual components
  2. Do the tests
  3. Point any issues or problems
  4. Resolve any troubles and retest components
  5. Document test results
  6. Repeat the process until all components pass unit testing
<br>

- **System test**

  - A system test is another testing method quite different from the unit test. Indeed, this kind of try is "global", in order, this time, to check if all the functionalities operate together.

  <br><u>How does it work? *(a little bit different)*</u>
  1. Write tests for the game
  2. Observe the tests 
  3. Point any issues or problems
  4. Resolve any troubles and re-observe the test
  5. Document test results
  6. Repeat the process until the game pass system testing
<br>

- **Regression test**

  - A regression test is ensuring that the previously working functionalities remain intact after changes.

  <br><u>How does it work?</u>
  1. Write tests for the game
  2. Observe if new features don't impact the oldest ones
  3. Point any issues or problems
  4. Resolve any troubles and re-observe the tests
  5. Document test results
  6. Repeat the process until the game pass regression testing
<br>

- **Performance test**

  - A performance test is measuring the system’s performance under different conditions, like load testing.

  <br><u>How does it works?</u>
  1. Write tests for the game
  2. Observe if the game doesn't make too time to respond to our command
  3. Point any issues or problems
  4. Resolve any latency between our action and the game
  5. Document test results
  6. Repeat the process until the game pass performance tests
<br>

### 4.2 Test list

All of the tests are written below but, the complete check list is findable [here](documents/qa/test_cases.md) (redirection to the Test Cases)

#### A. Software tests (without visuals)
|Name|Expected Results|
|---|---|
|Spawn|The raccoon spawn when the game starts|
|Up|The raccoon can goes up|
|Down|The raccoon can goes down|
|Left|The raccoon can goes left|
|Right|The raccoon can goes right|
|Life|When the raccoon touch a car, he loses a life|
|Game Over|When all the lives are lost, the game stops|
|Respawn|When the raccoon loses a life, he respawns at the bottom of the screen|
|Blocked Left|When the raccoon touch the left of the screen, he's blocked|
|Blocked Right|When the raccoon touch the right of the screen, he's blocked|
|Blocked Down|If the player tries to go down when he's already at the bottom of the screen, the raccoon is blocked|
|Finish|If the raccoon reach the finish line, he respawns at the bottom of the screen|
|Cars Appear|The cars normally appear|
|Cars Disappear|If the cars reach the opposite side where it spawns, it disappears|
|Life Counter|If the raccoon touch the life counter (invisible), he goes behind it|
<!--Not complete, please ignore it for now-->

<br>

#### B. Technical/Hardware tests
|Name|Expected Results|
|---|---|
|Segment Level|The score increases by 1 when a level is successfully complete|
|Switch 1|The raccoon goes up when the 1st switch is pressed|
|Switch 2|The raccoon goes to the left when the 2nd switch is pressed|
|Switch 3|The raccoon goes down when the 3rd switch is pressed|
|Switch 4|The raccoon goes to the right when the 4th switch is pressed|
|Led 1|If the switch 1 is pushed, the Led 1 turn on|
|Led 2|If the switch 2 is pushed, the Led 2 turn on|
|Led 3|If the switch 3 is pushed, the Led 3 turn on|
|Led 4|If the switch 4 is pushed, the Led 4 turn on|
|VGA[^4]|When the VGA socket is plug-in, the game is displayed|
|Up Debounce|The raccoon goes up only one by one|
|Down Debounce|The raccoon goes down only one by one|
|Left Debounce|The raccoon goes on the left only one by one|
|Right Debounce|The raccoon goes on the right only one by one|
<!--Not complete, please ignore it for now-->

#### C. Visuals tests

|Name|Expected Results|
|---|---|

## 5. Hardware used for tests

### 5.1. Computer
<br>

**Lenovo 20SL**
|Specification|Details|
|---|---|
|Operating System|Windows 11|
|Processor|Intel Core I7 10th Gen (1.30 Ghz Base)|
|RAM|16 GB|
|Storage|SSD 512 GB|
|Resolution|1920x1080px|

### 5.2. Go-Board

|Specification|Details|
|---|---|
|FPGA[^5]|Lattice ICE40 HX1K FPGA|
|Connectivity|Micro USB, VGA[^4], PMOD Connector|
|Settable|4 LEDs, 4 switches, 2 7-Segments|

---

<!--Don't definitive-->

## 6. Glossary

[^1]: Verilog
A language principally used for the programming of FPGA
[^2]: Hardware
The computer science materials used to do something (e.g. computer, smartphone, etc.)
[^3]: Software
A set of programs, procedures, and rules that enable a computer to work. It can be an OS like Windows, an application, etc.
[^4]: VGA
A connector commonly used to transmit video signals from a device (such as an FPGA) to a monitor or display.
[^5]: FPGA
*(aka Field-Programmable Gate Array)* <br> A type of integrated circuit that can be configured by the user or designer after manufacturing, often used in specialized gaming platforms.