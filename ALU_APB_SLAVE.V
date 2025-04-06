module APB_ALU_Slave (
    input wire PCLK,
    input wire PRESETn,
    input wire PENABLE,
    input wire PWRITE,
    input wire [31:0] PWDATA,
    input wire PSEL2,
    output reg [31:0] PRDATA,
    output reg PREADY1
);
    reg [1:0] access_cycle_count;
    // ALU internal registers
    reg signed [6:0] operand_A;
    reg signed [6:0] operand_B;
    reg signed [15:0] result;
    reg  [1:0] operation_code;

    always @(posedge PCLK) begin
            if(~PRESETn)begin
            PRDATA<=0;
            operand_A<=0;
            operand_B<=0;
            operation_code<=0;
            
        end
        else if(PENABLE) begin
            if(PSEL2 && PWRITE) begin          //write operation
                
                operand_A<=PWDATA[6:0];
                operand_B<=PWDATA[13:7];
                operation_code<=PWDATA[16:14];

           
        end
        else if(PSEL2 && ~PWRITE) begin            //read operation 
            PRDATA<=result;
           
        end
        end
       
    end
    always @(*) begin
        if(~PRESETn)begin
            result=0;
        end
        else begin
        case (operation_code)                     // opcode operations 
            2'b00:result=operand_A+operand_B;
            2'b01:result=operand_A-operand_B;
            2'b10:result=operand_A*operand_B;
            2'b11:result=operand_A^operand_B; 
        endcase
    end
    end
always @(posedge PCLK) begin
        if (!PRESETn) begin
            PREADY1 <= 0;
            access_cycle_count <= 0;
        end else begin
            if (PSEL2 && PENABLE) begin  
                if (access_cycle_count == 0) begin
                    // First cycle in ACCESS state
                    PREADY1 <= 0;  // Keep PREADY1 low to hold in ACCESS state
                    access_cycle_count <= access_cycle_count + 1;
                end else if (access_cycle_count == 1) begin
                    // Second cycle in ACCESS state
                    PREADY1 <= 1;  // Drive PREADY1 high to indicate the slave is ready
                    access_cycle_count <= 0; // Reset cycle count for next transaction
                end
            end 
            else begin
                // Default state (IDLE or no transaction)
                PREADY1 <= 0;  
                access_cycle_count <= 0;
            end
        end
    end

    endmodule