<div align="center">

# Test Plan

---


**Project** : Frogger <br>
**Team** : 2 <br>
**Created by** : Enoal ADAM <br>
**Creation Date** : 09/26/2024 <br>
**Updated** : 09/26/2024 <br>

---

<details>
<summary>Table of content</summary>

</details>
</div>

## 1. Introduction

The aim of this project is to, using the Verilog language, re-create a classic game nammed Frogger. It's an arcade game where reach the top of the screen is the goal. For doing that, the frog need to avoid some cars while she crossed all the roads. 
<!--Need to review with Vianney or anyone else to check this part-->

## 2. Goals <!--(Purposes maybe)-->

### 2.1 Document purpose

The aim of this document is to report what will be test on the game, as well the hardware side, as the software side. To do that, all the test will be carried out by manual testing.

More precisely, this document will gether some informations like:
- Check if the game works correctly or not.
- Ensures that the product answer at the software and hardware requirements.
- Identify the presence of bugs or other problems.
- Check the code's and game's security in order to not produce breaches on the custumer's hardware.
- Verify the responsivity of the product

### 2.2 Test purposes

#### 2.2.1 Definition of tests <!--"What is a test?" might be a good title idea too-->

- **Unit test**

  - A unit test is a testing method where the units or componant are checked individually so as to verify that all the features of a product work separately.

How does it work? :
1. Write test cases for individual components.
2. Conduct unit testing for each component.
3. Review test results and identify any issues.
4. Resolve any issues and retest components.
5. Document test results and provide feedback.
6. Repeat the process until all components pass unit testing.

<!--Need to review this part-->

- **System test**

  - A system test is another testing method quite different from the unit test. Indeed, this kind of try is "global", in order, this time, to check if all the functionalities operate together.

#### 2.2.2 Test list

All of the tests are written below but, the complete ckeck list is findable [here](test_cases.md) (redirection to the Test Cases)

**In-game tests** <!--Might be important to review the name-->
|Name|Description|
|---|---|
|Frog Spawn|The frog spawn when the game starts|
|Frog Up|The frog goes up when the associate button is press|
|Frog Down|The frog goes down when the associate button is press|
|Frog Left|The frog goes left when the associate button is press|
|Frog Right|The frog goes right when the associate button is press|
|Frog Dead|When the frog touch a car, she dies|
|Frog Respawn|When the frog is died, she respawn|
|Frog Block L|When the frog touch the left of the screen she's blocked|
|Frog Block R|When the frog touch the right of the screen she's blocked|
|Frog Block D|If the player tries to go down when he's already at the bottom of the screen, the frog is blocked|
|Finish|If the frog reach the finish line, she desappear|
|Cars Appear|The cars normally appear|
|Cars Disapear|If the cars reach the opposite side where it spawn, it disappear|

<br>

**Technical tests**
|Name|Description|
|---|---|
|||

## 3. Hardware Specifications

### 3.1 Windows
<br>

**Lenovo 20SL**
|Specification|Details|
|---|---|
|Processor|Intel Core I7 10th Gen (1.30 Ghz Base)|

<br>

**MacBook Air**
|Specification|Details|
|---|---|
|||