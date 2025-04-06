vlib work
vlog APB.V top_module_apb.v APB_TB.sv RAM_SLAVE_APB1.v  +cover -covercells
vsim -voptargs=+acc work.APB_TB2 -cover
add wave *
add wave -position insertpoint  \
sim:/APB_TB2/m1/PRDATA0 \
sim:/APB_TB2/m1/PRDATA1 \
sim:/APB_TB2/m1/PWDATA0 \
sim:/APB_TB2/m1/PWDATA1 \
sim:/APB_TB2/m1/ready0 \
sim:/APB_TB2/m1/PREADY1 \
sim:/APB_TB2/m1/PADDR \
sim:/APB_TB2/m1/PSEL1 \
sim:/APB_TB2/m1/PSEL2 \
sim:/APB_TB2/m1/PENABLE
add wave -position insertpoint  \
sim:/APB_TB2/m1/apb_master/ns \
sim:/APB_TB2/m1/apb_master/cs
add wave -position insertpoint  \
sim:/APB_TB2/m1/alu_slave/operand_A \
sim:/APB_TB2/m1/alu_slave/operand_B \
sim:/APB_TB2/m1/alu_slave/result \
sim:/APB_TB2/m1/alu_slave/operation_code
add wave -position insertpoint  \
sim:/APB_TB2/m1/memory_slave/data_in \
sim:/APB_TB2/m1/memory_slave/address \
sim:/APB_TB2/m1/memory_slave/data_out \
sim:/APB_TB2/m1/memory_slave/mem
coverage save -du APB APB_TB.ucdb -onexit
run 500