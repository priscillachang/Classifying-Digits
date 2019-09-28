.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element and its value. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 is the pointer to the start of the vector
#	a1 is the # of elements in the vector
# Returns:
#	a0 is the first index of the largest element
# =================================================================
argmax:
    # Prologue
    addi sp sp -12
    sw s0 0(sp)
    sw s1 4(sp)
    sw s2 8(sp)

loop_start:
    mv s0 a0                         # Start
    mv s1 a1                         # Num elements in array
    li s2 0                          # Indexer
    li t0 0                          # t0; Index of Max
    lw t1 0(s0)                      # t1: Value of Max

loop_continue:
    bge s2 s1 loop_end
    mv t2 s2                         # At index places from start
    slli t2 t2 2                     # Stride of 4
    add t2 t2 s0                     # Relative to Start
    lw t3 0(t2)                      # t3: Value at current index
    addi s2 s2 1                     # Index Increment

    bge t1 t3 loop_continue          # If curr > max, proceed to below.
    mv t1 t3
    addi t0 s2 -1
    j loop_continue

loop_end:
    mv a0 t0
    mv a1 s1

    # Epilogue
    lw s0 0(sp)
    lw s1 4(sp)
    lw s2 8(sp)
    addi sp sp 12

    ret
