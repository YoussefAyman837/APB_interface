module slave1 (
    data_in,data_out,address,clk,rst_n,ready0,PWRITE ,PENABLE,PSEL1
);
parameter MEM_DEPTH =1024;
parameter ADDR_SIZE=32;
parameter MEM_WEDTH=32;
input [31:0] data_in , address;
input clk ,rst_n , PWRITE,PENABLE;
input PSEL1;
output reg [31:0]data_out;
output reg ready0 ;
reg [1:0]access_cycle_count;
reg [ADDR_SIZE-1:0] ADDR_WRITE,ADDR_READ;
reg [MEM_WEDTH-1:0] mem [MEM_DEPTH-1:0];

integer i;

initial begin
    for (i = 0; i < 1024; i=i+1) 
        mem[i] = 32'h00000000;  // Initialize all memory locations to zero
end

    always @(posedge clk) begin
            if(~rst_n)begin
            data_out<=0;
        end
            else if(PENABLE) begin                         
                if(PSEL1 && PWRITE)begin                 //write operation
                data_out<=0;
                ADDR_WRITE<=address;
                mem[ADDR_WRITE]<=data_in;
            end
            else if (PSEL1 && ~PWRITE)begin             //read operation
                ADDR_READ<=address;
                data_out<=mem[ADDR_READ];
                
            end

            end
            end


           always @(posedge clk) begin
        if (!rst_n) begin
            ready0 <= 0;
            access_cycle_count <= 0;
        end else begin
            if (PSEL1 && PENABLE) begin  // When in ACCESS state
                if (access_cycle_count == 0) begin
                    // First cycle in ACCESS state
                    ready0 <= 0;  // Keep ready0 low to hold in ACCESS state
                    access_cycle_count <= access_cycle_count + 1;
                end else if (access_cycle_count == 1) begin
                    // Second cycle in ACCESS state
                    ready0 <= 1;  // Drive ready0 high to indicate the slave is ready
                    access_cycle_count <= 0; // Reset cycle count for next transaction
                end
            end else begin
                // Default state (IDLE or no transaction)
                ready0 <= 0;  
                access_cycle_count <= 0;
            end
        end
    end
endmodule