<div align="center">

# Test Plan

---


**Project** : Frogger <br>
**Team** : 2 <br>
**Created by** : Enoal ADAM <br>
**Creation Date** : 09/26/2024 <br>
**Updated** : 10/10/2024 <br>

---

<details>
<summary>Table of content</summary>

- [Test Plan](#test-plan)
  - [1. Introduction](#1-introduction)
  - [2. Goals ](#2-goals-)
    - [2.1 Document purpose](#21-document-purpose)
    - [2.2 Test purposes](#22-test-purposes)
      - [A. Tests' definition ](#a-tests-definition-)
      - [B. Test list](#b-test-list)
  - [3. Hardware used for tests](#3-hardware-used-for-tests)
    - [3.1 Computer](#31-computer)
    - [3.2 Go-Board](#32-go-board)
- [Glossary](#glossary)

</details>
</div>

## 1. Introduction

The aim of this project is to, using the Verilog language, re-create a classic game nammed Frogger. It's an arcade game where reach the top of the screen is the goal. For doing that, the frog need to avoid some cars while she crossed all the roads. Since is a re-creation, some sprites have changed like the frog, now a raccoon and the cars which are now garbage trucks.
<!--Need to review with Vianney or anyone else to check this part-->

## 2. Goals <!--(Purposes maybe)-->

### 2.1 Document purpose

The aim of this document is to report what will be test on the game, as well the hardware side, as the software side. To do that, all the test will be carried out by manual testing.

More precisely, this document and the test cases will gether some informations like:
- Check if the game works correctly or not.
- Ensures that the product answer at the software requirements.
- Identify the presence of bugs or other problems.
- Check the code's and game's security in order to not produce issues on the custumer's hardware.
- Verify the responsivity of the product

### 2.2 Test purposes

#### A. Tests' definition <!--"What is a test?" might be a good title idea too-->

- **Unit test**

  - A unit test is a testing method where the units or componant are checked individually so as to verify that all the features of a product work separately.

How does it work?
1. Write the tests for individual components
2. Do the tests
3. Point any issues or problems
4. Resolve any troubles and retest components
5. Document test results
6. Repeat the process until all components pass unit testing

<!--Need to review this part-->

- **System test**

  - A system test is another testing method quite different from the unit test. Indeed, this kind of try is "global", in order, this time, to check if all the functionalities operate together.

How does it work? *(a little bit different)*
1. Write tests for the game
2. Observe the tests 
3. Point any issues or problems
4. Resolve any troubles and reobserve the test
5. Document test results
6. Repeat the process until the game pass system testing

#### B. Test list

All of the tests are written below but, the complete ckeck list is findable [here](test_cases.md) (redirection to the Test Cases)

**In-game tests** <!--Might be important to review the name-->
|Name|Expected Results|
|---|---|
|Spawn|The raccoon spawn when the game starts|
|Up|The raccoon goes up when the associate button is press|
|Down|The raccoon goes down when the associate button is press|
|Left|The raccoon goes left when the associate button is press|
|Right|The raccoon goes right when the associate button is press|
|Dead|When the raccoon touch a car, she dies|
|Respawn|When the raccoon is died, she respawn|
|Blocked Left|When the raccoon touch the left of the screen she's blocked|
|Blocked Right|When the raccoon touch the right of the screen she's blocked|
|Blocked Down|If the player tries to go down when he's already at the bottom of the screen, the raccoon is blocked|
|Finish|If the raccoon reach the finish line, she desappear|
|Cars Appear|The cars normally appear|
|Cars Disapear|If the cars reach the opposite side where it spawn, it disappear|

<br>

**Technical tests**
|Name|Expected Results|
|---|---|
|Segment Level|The score increases by 1 when a level is successfully complete|
|Switch 1|The raccoon goes ? when the 1st switch is pressed|
|Switch 2|The raccoon goes ? when the 2nd switch is pressed|
|Switch 3|The raccoon goes ? when the 3rd switch is pressed|
|Switch 4|The raccoon goes ? when the 4th switch is pressed|
|Led 1|If the switch 1 is pushed, the Led 1 turn on|
|Led 2|If the switch 2 is pushed, the Led 2 turn on|
|Led 3|If the switch 3 is pushed, the Led 3 turn on|
|Led 4|If the switch 4 is pushed, the Led 4 turn on|
|VGA|When the VGA socket is plug-in, the game is displayed|

## 3. Hardware used for tests

### 3.1 Computer
<br>

**Lenovo 20SL**
|Specification|Details|
|---|---|
|Operating System|Windows 11|
|Processor|Intel Core I7 10th Gen (1.30 Ghz Base)|
|RAM|16 GB|
|Storage|SSD 512 GB|
|Resolution|1920x1080px|

### 3.2 Go-Board

|Specification|Details|
|---|---|
|FPGA|Lattice ICE40 HX1K FPGA|
|Connectivity|Micro USB, VGA, PMOD Connector|
|Setable|4 LEDs, 4 switches, 2 7-Segments|

# Glossary

<!-- Add Redirection to this board-->

|Term|Definition|
|---|---|
|<span id="verilog">Verilog</span>|A language principally used for the programation of FPGA|
|<span id="hardware">Hardware</span>|The computer science materials used to do something (e.g. computer, smartphone, etc.)|
|<span id="software">Software</span>|A set of programs, procedures, and rules that enable a computer to work. It can be an OS like Windows, an application, etc.|
|<span id="vga">VGA</span>|A connector commonly used to transmit video signals from a device (such as an FPGA) to a monitor or display.|
|<span id="fpga">FPGA</span>|*(aka Field-Programmable Gate Array)* <br> A type of integrated circuit that can be configured by the user or designer after manufacturing, often used in specialized gaming platforms.

<!--Add Out-Scope and In-Scope-->