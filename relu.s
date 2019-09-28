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

loop_start:
    li t2 0                          # t2: Indexer

loop_continue:
    bge t2 a1 loop_end
    mv t1 t2                         # At index places from start
    slli t1 t1 2                     # Stride of 4
    add t1 t1 a0                     # t1: Address of elem
    lw t0 0(t1)                      # t0: Elem value to be compared to 0
    addi t2 t2 1                     # Index increment

    bge t0 x0 loop_continue          # If less than 0, proceed to below
    sw x0 0(t1)                      # Set ot 0
    j loop_continue

loop_end:
    ret
