module APB_TB2 (
);
    
//states
parameter IDLE = 2'b00;
parameter SETUP = 2'b01;
parameter ACCESS = 2'b11;
//signal declaration
reg PCLK , PRESETn , transfer, PWRITE ;
reg [31:0] APB_DATA , APB_read_ADDRESS , APB_write_ADDRESS ;
wire [31:0] APB_read_data_out ;
integer i;

Top_Module m1(.*);

initial begin
    PCLK=0;
    forever begin
        #1 PCLK= ~PCLK;
    end
end

initial begin
    PRESETn=0;
    @(posedge PCLK);
    PRESETn=1;
    transfer=1;
    @(posedge PCLK);
    //write transactions
    for (i =0 ;i<40 ;i++ ) begin
        PWRITE=1;
        APB_DATA=$random;
        APB_write_ADDRESS=i;
        APB_read_ADDRESS=0;
        @(posedge PCLK);
        @(posedge PCLK);
        @(posedge PCLK);
        @(posedge PCLK);

        
    end
    PRESETn=0;
    @(posedge PCLK);
    PRESETn=1;

    PWRITE=0;
    @(posedge PCLK);
    //read transaction from ram
    APB_write_ADDRESS=1000;
    APB_read_ADDRESS=8;
    @(posedge PCLK);
    @(posedge PCLK);
    @(posedge PCLK);
    @(posedge PCLK);
    APB_write_ADDRESS=1000;
    APB_read_ADDRESS=9;
    @(posedge PCLK);
    @(posedge PCLK);
    @(posedge PCLK);
    @(posedge PCLK);
  
end
//assert property(@(posedge PCLK)(APB_read_data_out==m1.alu_slave.result));
    
//assert property(@(posedge PCLK)(m1.PWDATA0 == m1.memory_slave.mem[APB_read_ADDRESS]));
assert property(@(posedge PCLK) (m1.PSEL1 && m1.PENABLE |-> ##[0:3] m1.ready0));
assert property(@(posedge PCLK) (m1.PSEL2 && m1.PENABLE |-> ##[0:3] m1.PREADY1));
assert property(@(posedge PCLK) (m1.ready0 |-> m1.memory_slave.mem[APB_write_ADDRESS]==m1.PWDATA0));
assert property(@(posedge PCLK) (m1.PREADY1 |-> APB_read_data_out==m1.memory_slave.mem[APB_read_ADDRESS]));
assert property(@(posedge PCLK) (m1.PREADY1 && m1.alu_slave.operation_code==2'b00 |-> m1.alu_slave.result==m1.alu_slave.operand_A+m1.alu_slave.operand_B));
assert property(@(posedge PCLK) (m1.PREADY1 && m1.alu_slave.operation_code==2'b01 |-> m1.alu_slave.result==m1.alu_slave.operand_A-m1.alu_slave.operand_B));
assert property(@(posedge PCLK) (m1.PREADY1 && m1.alu_slave.operation_code==2'b10 |-> m1.alu_slave.result==m1.alu_slave.operand_A*m1.alu_slave.operand_B));
assert property(@(posedge PCLK) (m1.PREADY1 && m1.alu_slave.operation_code==2'b11 |-> m1.alu_slave.result==m1.alu_slave.operand_A^m1.alu_slave.operand_B));
endmodule