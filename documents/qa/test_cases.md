<div align="center">

# Test Cases

---


**Project** : Frogger <br>
**Team** : 2 <br>
**Created by** : Enoal ADAM <br>
**Creation Date** : 10/09/2024 <br>
**Updated** : 10/11/2024 <br>

---

</div>
<details>
<summary>Table of content</summary>

- [Test Cases](#test-cases)
      - [How the tests will be listed?](#how-the-tests-will-be-listed)
        - [ID](#id)
        - [Date](#date)
        - [Priority](#priority)
        - [Name](#name)
        - [Expected Result](#expected-result)
        - [What happened](#what-happened)
        - [Step to Reproduce](#step-to-reproduce)
        - [Success](#success)

</details>

#### How the tests will be listed?

|ID|Date|Priority|Name|Expected Result|What happened|Step to Reproduce|Success|
|---|---|---|---|---|---|---|---|
|1/01|10/10/24|High|Blocked Left|When the raccoon touch the left of the screen he's blocked|The raccoon comes out from the left side of the screen|1- Start the game <br> 2- Go on the left side with the raccoon <br> 3- Note the bug|No
|2/01|10/10/24|Low|Raccoon Color|The Raccoon is in the same color|/|/|Yes|


<center>

*All the real tests are indicated on **this [spreadsheet](https://docs.google.com/spreadsheets/d/1xDvMMivWDznyqAlkjNg5Zc1iZPZZttfN4TMLGhUK0E0/edit?gid=0#gid=0)***
</center>

##### ID

Each tests have a ID which is attribuated to it. This ID follow a specific model like :

- The First Number <mark>1</mark>/01:
  - 1 is a link with the software
  - 2 is a link with the hardware
- The 2 last numbers 1/<mark>01</mark>:
  - Quantify the number of tests realized in the sections above

##### Date

Indicate the date when the test has been passed.

##### Priority

The priority of tests, distributed as follow :
- **Low**: Not really important, comes after *Medium* and *High*
- **Medium**: Important, but not as *High*
- **High**: Very important, if tests fails, need to fix the bug quickly

##### Name

The name of the test (most of the time, summarises in 2 or 3 words what will be expected)

##### Expected Result

What we originally expected from the tests. Can be different to the "What happened" box if the test is inconclusive.

##### What happened

What is really happened during the tests. List if there is a bug or something else.
Can be blank if there is any issue.

##### Step to Reproduce

Indicates the steps to reproduce in order to the devs to reproduce the problem if they want to understand how it happens.
As in "What happened".

##### Success

Shows if the test passed or failed (respectively yes or no). 
*If "What happened" and "Step to reproduce" are filled, "no" will be used here, otherwise it will be "yes".*