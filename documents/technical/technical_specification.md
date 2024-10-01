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
1.1| 10/01/2024|Mattéo LEFIN|- add Overview and conventions |

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
 - [**3.2 Debbuging system**]()
 - [**3.3 **]()
 - [**3.4 The menu and game background**]()
 - [**3.5 Controls and characters movement**]()
 - [**3.6 Drawing in VGA**]()
   - [**A. Graphics**]()
   - [**B. The sprites**]()
 - [**3.7 Game mechanics**]()
 - [**3.8 Score system**]()







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
- The VGA to show it on a ??? screen
- 


</details>