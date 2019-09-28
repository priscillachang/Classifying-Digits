.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 is the pointer to the array
#	a1 is the # of elements in the array
# Returns:
#	None
# ==============================================================================
relu:
    # Prologue
    addi sp sp -12
    sw s0 0(sp)
    sw s1 4(sp)
    sw s2 8(sp)

loop_start:
    # Save arguments
    mv s0 a0                         # Start
    mv s1 a1                         # Num elements in array
    li s2 0                          # Indexer

loop_continue:
    bge s2 s1 loop_end
    mv t1 s2                         # At index places from start
    slli t1 t1 2                     # Stride of 4
    add t1 t1 s0                     # Relative to Start
    lw t0 0(t1)
    addi s2 s2 1                     # Index Increment

    bge t0 x0 loop_continue          # If less than 0, proceed to below
    sw x0 0(t1)                      # Set ot 0
    j loop_continue

loop_end:
    mv a0 s0
    mv a1 s1

    # Epilogue
    lw s0 0(sp)
    lw s1 4(sp)
    lw s2 8(sp)
    addi sp sp 12
    ret
