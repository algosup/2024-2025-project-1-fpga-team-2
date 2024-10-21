module LED_control (
    input [3:0] i_Lives,    // Remaining lives
    output reg o_LED_1,
    output reg o_LED_2,
    output reg o_LED_3
);
    always @(*) begin
        case (i_Lives)
            4'b0000: begin
                o_LED_1 = 0;
                o_LED_2 = 0;
                o_LED_3 = 0;
            end
            4'b0001: begin
                o_LED_1 = 1;
                o_LED_2 = 0;
                o_LED_3 = 0;
            end
            4'b0010: begin
                o_LED_1 = 1;
                o_LED_2 = 1;
                o_LED_3 = 0;
            end
            4'b0011: begin
                o_LED_1 = 1;
                o_LED_2 = 1;
                o_LED_3 = 1;
            end
            default: begin
                o_LED_1 = 0;
                o_LED_2 = 0;
                o_LED_3 = 0;
            end
        endcase
    end
endmodule

