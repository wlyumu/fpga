module top_key_beep(
    input clk,
    input rst_n,
    input key,
    output beep
);

wire key_flag;
wire key_value;

key_debounce  ukey_debounce(
     .clk         (clk),
     .rst_n       (rst_n),
     .key         (key),
     .key_value   (key_value),
     .key_flag    (key_flag)

);

beep_control ubeep_control(
    .clk          (clk),
    .rst_n        (rst_n),

    .key_flag     (key_flag),
    .key_value    (key_value),
    .beep         (beep)
);

endmodule // top_key_beep
    