module APB (
    PCLK , PRESETn , PADDR , PSEL1,PSEL2 , PENABLE , PWRITE , PWDATA0,PWDATA1 , PSTRB , PREADY1,PREADY0 ,transfer,
    APB_read_ADDRESS,APB_write_ADDRESS,APB_DATA,APB_read_data_out,PRDATA0,PRDATA1
);
//states
parameter IDLE = 2'b00;
parameter SETUP = 2'b01;
parameter ACCESS= 2'b11;
//signal declaration
input PCLK , PRESETn , transfer,PREADY0,PREADY1 ,PWRITE;
output reg  PENABLE ;
output reg PSEL1;
output reg PSEL2;
output  reg [3:0] PSTRB ;
input [31:0] APB_DATA , APB_read_ADDRESS , APB_write_ADDRESS ;
input [31:0] PRDATA0, PRDATA1;
output reg [31:0]  PADDR , PWDATA0,PWDATA1 , APB_read_data_out ;

reg [1:0]ns,cs;


// state transition between cs and ns 
always @(posedge PCLK) begin
    if(~PRESETn)begin
        cs<=IDLE;
    end
    else 
        cs<=ns;
end

// next state logic
always @(*) begin
    case (cs)
        IDLE:begin
            if(transfer)begin
                ns=SETUP;
            end
            else 
            ns=IDLE;
        end 
        SETUP: begin
            ns=ACCESS;
        end
        ACCESS:begin
            if ( PREADY0 ||  PREADY1) begin
                if (transfer) begin
                    ns = SETUP;
                end 
                else begin
                    ns = IDLE;
                end
            end 
            else begin
                ns = ACCESS; 
            end
        end
        default:ns= IDLE;
    endcase
end


//output logic 

always @(posedge PCLK) begin               
    if(~PRESETn)begin
        APB_read_data_out<=0;
        PWDATA0<=0;
        PWDATA1<=0;
        
    end
    else begin
        case (cs)
            IDLE:begin
                APB_read_data_out<=0;
            end 
            SETUP: begin
               

                if(PWRITE)begin
                    PADDR<=APB_write_ADDRESS;
                end
                else begin
                    PADDR<=APB_read_ADDRESS;
                end
                
            end
            ACCESS:begin
                PSTRB<=4'b1111;
                if(PWRITE)begin
                    if(PSEL1)begin
                      PWDATA0<=APB_DATA;
                    end
                    else if(PSEL2)begin
                        PWDATA1<=APB_DATA;
                    end
                end
                    else begin
                        if(PSEL1)begin
                            APB_read_data_out<=PRDATA0;
                        end
                        else if(PSEL2) begin
                            APB_read_data_out<=PRDATA1;
                        end
                    end
            end
            default:begin
            APB_read_data_out<=0;
            end
        endcase

    end
end

always @(*) begin
        if(cs==SETUP)begin
     if(APB_write_ADDRESS[3])begin
                    PSEL1=1;
                    PSEL2=0;
                end
                else begin
                    PSEL1=0;
                    PSEL2=1;
                end
        end
    if(cs==ACCESS)begin
        PENABLE=1;
    end
    else begin
        PENABLE=0;
    end
end
endmodule