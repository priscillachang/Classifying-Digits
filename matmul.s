.import ../utils.s
.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 float matrices
# 	d = matmul(m0, m1)
#   If the dimensions don't match, exit with exit code 2
# Arguments:
# 	a0 is the pointer to the start of m0
#	a1 is the # of rows (height) of m0
#	a2 is the # of columns (width) of m0
#	a3 is the pointer to the start of m1
# 	a4 is the # of rows (height) of m1
#	a5 is the # of columns (width) of m1
#	a6 is the pointer to the the start of d
# Returns:
#	None, sets d = matmul(m0, m1)
# =======================================================
matmul:

    # Error if mismatched dimensions
    bne a2 a4 mismatched_dimensions

    # Prologue
    addi sp sp -32
    sw s0 0(sp)
    sw s1 4(sp)
    sw s2 8(sp)
    sw s3 12(sp)
    sw s4 16(sp)
    sw s5 20(sp)
    sw s6 24(sp)
    sw ra 28(sp)

    mv s0 a0
    mv s1 a1
    mv s2 a2
    mv s3 a3
    mv s4 a4
    mv s5 a5
    mv s6 a6

outer_loop_start:
    li t0 0                             # INNER INDEX
    li t1 0                             # OUTER INDEX
    li t2 0                             # For Indexing Output array

inner_loop_start:
    bge t1 s1 outer_loop_end
    bge t0 s2 inner_loop_end

    # Prepare for dot subroutine
    mul a0 t1 s2
    slli a0 a0 2
    add a0 a0 s0                        # Start of v0

    mv a1 t0
    slli a1 a1 2
    add a1 a1 s3                        # Start of v1

    mv a2 s2                            # Dot Product input: m0 rowlength
    li a3 1                             # Stride: 1
    mv a4 s5                            # Stride: m1 rowlength

    # STORE THINGS
    addi sp sp -32
    sw t0 0(sp)
    sw t1 4(sp)
    sw t2 8(sp)
    sw t3 12(sp)
    sw t4 16(sp)
    sw t5 20(sp)
    sw t6 24(sp)
    sw ra 28(sp)
    jal ra dot
    # LOAD THINGS
    lw t0 0(sp)
    lw t1 4(sp)
    lw t2 8(sp)
    lw t3 12(sp)
    lw t4 16(sp)
    lw t5 20(sp)
    lw t6 24(sp)
    lw ra 28(sp)
    addi sp sp 32

    # Compute index of output array
    li t2 0
    mul t2 t1 s1
    add t2 t2 t0
    slli t2 t2 2
    add t2 t2 s6
    sw a0 0(t2)

    addi t0 t0 1
    j inner_loop_start

inner_loop_end:
    li t0 0
    addi t1 t1 1
    j inner_loop_start

outer_loop_end:
    # Epilogue
    lw s0 0(sp)
    lw s1 4(sp)
    lw s2 8(sp)
    lw s3 12(sp)
    lw s4 16(sp)
    lw s5 20(sp)
    lw s6 24(sp)
    lw ra 28(sp)
    addi sp sp 32

    ret

mismatched_dimensions:
    li a1 2
    jal exit2
