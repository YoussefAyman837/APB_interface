module Top_Module (
    input wire PCLK,
    input wire PRESETn,
    input wire transfer,
    input wire PWRITE,
    input wire [31:0] APB_write_ADDRESS,
    input wire [31:0] APB_read_ADDRESS,
    input wire [31:0] APB_DATA,
    output wire [31:0] APB_read_data_out
);

    // Internal Signals for Slave Read/Write Data
    wire [31:0] PRDATA0, PRDATA1;
    wire [31:0] PWDATA0, PWDATA1;
    wire ready0, PREADY1 ;
    wire [31:0]PADDR;
    wire PSEL1,PSEL2;

    
    // Instantiate APB Master
    APB apb_master (
        .PCLK(PCLK),
        .PRESETn(PRESETn),
        .PADDR(PADDR),
        .PSEL1(PSEL1),
        .PSEL2(PSEL2),
        .PENABLE(PENABLE),
        .PWRITE(PWRITE),
        .PREADY0(ready0),
        .PREADY1(PREADY1),
        .PSTRB(),
        .PWDATA0(PWDATA0),
        .PWDATA1(PWDATA1),
        .transfer(transfer),
        .APB_read_ADDRESS(APB_read_ADDRESS),
        .APB_write_ADDRESS(APB_write_ADDRESS),
        .APB_DATA(APB_DATA),
        .APB_read_data_out(APB_read_data_out),
        .PRDATA0(PRDATA0),
        .PRDATA1(PRDATA1)
    );

    // Instantiate ALU Slave
    APB_ALU_Slave alu_slave (
        .PCLK(PCLK),
        .PRESETn(PRESETn),
        .PSEL2(PSEL2),
        .PENABLE(PENABLE),
        .PWRITE(PWRITE),
        .PWDATA(PWDATA1),
        .PRDATA(PRDATA1),
        .PREADY1(PREADY1)
    );

    // Instantiate Memory Slave (Slave1)
    slave1 memory_slave (
        .data_in(PWDATA0),
        .data_out(PRDATA0),
        .PSEL1(PSEL1),
        .address(PADDR),
        .clk(PCLK),
        .rst_n(PRESETn),
        .ready0(ready0),
        .PWRITE(PWRITE),
        .PENABLE(PENABLE)
    );

endmodule