.import read_matrix.s
.import write_matrix.s
.import matmul.s
.import dot.s
.import relu.s
.import argmax.s
.import utils.s

.globl main

.text
main:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0: int argc
    #   a1: char** argv
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

    # Exit if incorrect number of command line args
    li t0 5
    bne a0 t0 error
    mv s5 a1                 # s5 = argv

	  # =====================================
    # LOAD MATRICES
    # =====================================

    # Load pretrained m0
    li a0 4
    jal malloc
    mv a1 a0                 # Pointer to rows
    li a0 4
    jal malloc
    mv a2 a0                 # Pointer to columns
    lw a0 4(s5)              # Read M0_PATH
    jal save
    jal read_matrix
    jal load
    lw t0 0(a1)              # t0: M0 rows (TENTATIVE)
    lw t1 0(a2)              # t1: M0 cols (TENTATIVE)
    mv s0 a0                 # s0 = M0

    # Load pretrained m1
    li a0 4
    jal malloc
    mv a1 a0                 # Pointer to rows
    li a0 4
    jal malloc
    mv a2 a0                 # Pointer to columns
    lw a0 8(s5)              # Read M1_PATH
    jal save
    jal read_matrix
    jal load
    lw t2 0(a1)              # t2: M1 rows (TENTATIVE)
    lw t3 0(a2)              # t3: M1 cols (TENTATIVE)
    mv s1 a0                 # s1 = M1

    # Load input matrix
    li a0 4
    jal malloc
    mv a1 a0                 # Pointer to rows
    li a0 4
    jal malloc
    mv a2 a0                 # Pointer to columns
    lw a0 12(s5)             # Read INPUT
    jal save
    jal read_matrix
    jal load
    lw t4 0(a1)              # t4: INPUT rows (TENTATIVE)
    lw t5 0(a2)              # t5: INPUT cols (TENTATIVE)
    mv s2 a0                 # s2 = INPUT

    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
    jal save
    mv a0 s0
    mv a1 t0
    mv a2 t1
    mv a3 s2
    mv a4 t4
    mv a5 t5
    mv a6 x0                # a6 = m0 * input
    jal matmul
    jal load



    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    lw a0 16(s0) # Load pointer to output filename
    mv a1 s3
    mv a2 t2
    mv a3 t5
    jal save
    jal write_matrix
    jal load

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    mv a0 s3
    mul a1 t2 t5
    jal save
    jal argmax
    jal load

    # Print classification
    mv a1 a0
    jal print_int

    # Print newline afterwards for clarity
    li a1 '\n'
    jal print_char

    jal exit

error:
    li a1 3
    jal exit2

save:
    addi sp sp -40
    sw t0 0(sp)
    sw t1 4(sp)
    sw t2 8(sp)
    sw t3 12(sp)
    sw t4 16(sp)
    sw t5 20(sp)
    sw t6 24(sp)
    sw a1 32(sp)
    sw a2 36(sp)
    jr ra

load:
    lw t0 0(sp)
    lw t1 4(sp)
    lw t2 8(sp)
    lw t3 12(sp)
    lw t4 16(sp)
    lw t5 20(sp)
    lw t6 24(sp)
    lw a1 32(sp)
    lw a2 36(sp)
    addi sp sp 40
    jr ra
