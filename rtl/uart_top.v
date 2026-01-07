//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.01.2026 17:07:02
// Design Name: 
// Module Name: uart
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module uart
(
    input  wire       clk,
    input  wire       reset,

    input  wire       rd_uart,
    input  wire       wr_uart,
    input  wire [7:0] w_data,
    output wire [7:0] r_data,
    output wire       rx_empty,
    output wire       tx_full,

    input  wire       rx,
    output wire       tx,

    input  wire       s_tick
);

    wire rx_done_tick;
    wire tx_done_tick;

    wire rx_flag;
    wire tx_flag;

    wire [7:0] rx_data;
    wire [7:0] tx_data;

   
    uart_rx uart_rx_unit (
        .clk(clk),
        .reset(reset),
        .rx(rx),
        .s_tick(s_tick),
        .rx_done_tick(rx_done_tick),
        .dout(rx_data)
    );

  
    flag_buf #(.W(8)) rx_flag_buf (
        .clk(clk),
        .reset(reset),
        .set_flag(rx_done_tick),
        .clr_flag(rd_uart),
        .din(rx_data),
        .flag(rx_flag),
        .dout(r_data)
    );

    assign rx_empty = ~rx_flag;

  
    flag_buf #(.W(8)) tx_flag_buf (
        .clk(clk),
        .reset(reset),
        .set_flag(wr_uart),
        .clr_flag(tx_done_tick),
        .din(w_data),
        .flag(tx_flag),
        .dout(tx_data)
    );

    assign tx_full = tx_flag;

 
    uart_tx uart_tx_unit (
        .clk(clk),
        .reset(reset),
        .tx_start(tx_flag),
        .s_tick(s_tick),
        .din(tx_data),
        .tx_done_tick(tx_done_tick),
        .tx(tx)
    );

endmodule


