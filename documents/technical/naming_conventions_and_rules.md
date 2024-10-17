# Naming conventions and rules.

---

## Naming conventions.

### Folder

Folders and subfolders are written in ``flatcase``, meaning every words are in **lower case** and **attached together**.

(e.g : namingconventions)

### Files

Any kind of files (like code, documents or images) are written in ``snake_case``, meaning every words are in **minuscule** and **separated by an underscore ' _ '**.

(e.g : naming_conventions)

### Variables (for code only)

All variables used in the code are written in ``camel_Snake_Case``, meaning every words are in **minuscule** and **separated by an underscore ' _ '**.

(e.g : naming_Conventions)

---

## Rules.

### Comments

```Verilog
//This Program is an exemple for the rules by Mattéo Lefin 

    module example_project(
        input i_Clk, // Initialize a go_board's clock
        input i_Switch_1, // Initialize the first button on the go_board
        output o_LED_1 // Initialize the first LED on the go_board
     );
    reg prev_switch; // This register has for purpose to keep the previous state of the button

    // This part of the code will turn on/off a LED and keep it on/off using a switch
    always @(posedge i_Clk)
    begin
        if(i_Switch_1 && prev_switch)
        begin
            o_LED_1 = ~r_LED_1; 
        end
        prev_switch <= o_LED_1;
    end


    endmodule

```
