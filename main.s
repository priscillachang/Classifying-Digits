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
    bne a0 5 error
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
    mv a0 4(s5)              # Read M0_PATH

    jal save
    jal read_matrix
    jal load

    mv s0 a0                 # s0 = M0

    # Load pretrained m1
    li a0 4
    jal malloc
    mv a1 a0                 # Pointer to rows
    li a0 4
    jal malloc
    mv a2 a0                 # Pointer to columns
    mv a0 8(s5)              # Read M1_PATH
    jal save
    jal read_matrix
    jal load
    mv s1 a0                 # s1 = M1

    # Load input matrix
    li a0 4
    jal malloc
    mv a1 a0                 # Pointer to rows
    li a0 4
    jal malloc
    mv a2 a0                 # Pointer to columns
    mv a0 12(s5)             # Read INPUT
    jal save
    jal read_matrix
    jal load
    mv s2 a0                 # s2 = INPUT

    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)















    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    lw a0 16(s0) # Load pointer to output filename





    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax




    # Print classification




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
    jr ra

load:
    lw t0 0(sp)
    lw t1 4(sp)
    lw t2 8(sp)
    lw t3 12(sp)
    lw t4 16(sp)
    lw t5 20(sp)
    lw t6 24(sp)
    addi sp sp 40
    jr ra
