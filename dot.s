.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 is the pointer to the start of v0
#   a1 is the pointer to the start of v1
#   a2 is the length of the vectors
#   a3 is the stride of v0
#   a4 is the stride of v1
# Returns:
#   a0 is the dot product of v0 and v1
# =======================================================
dot:
    # Prologue
    addi sp sp -12
    sw s0 0(sp)
    sw s1 4(sp)
    sw s2 8(sp)

    li t0 0                 # t0: Sum
    mv s2 a2
    mv t3 a0                # t3: Curr index of v0
    mv t4 a1                # t4: Curr index of v1

loop_start:
    bge x0 s2 loop_end
    lw t1 0(t3)             # t1: Value at curr v0 index
    lw t2 0(t4)             # t2: Value at curr v1 index
    mul t5 t1 t2            # t5: 2-Element Product = t1 * t2
    add t0 t0 t5            # Sum += Product
    add t3 t3 a3            # t3++
    add t4 t4 a4            # t4++
    addi s2 s2 -1           # s2--
    j loop_start

loop_end:
    mv a0 t0

    # Epilogue
    lw s0 0(sp)
    lw s1 4(sp)
    lw s2 8(sp)
    addi sp sp 12

    ret
