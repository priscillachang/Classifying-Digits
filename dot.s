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
    li t0 0                 # t0: Dot product
    li t6 0                 # t6: Indexer

loop_start:
    bge t6 a2 loop_end

    mul t3 t6 a3
    slli t3 t3 2
    add t3 t3 a0            # t3: Elem address of v0

    mul t4 t6 a4
    slli t4 t4 2
    add t4 t4 a1            # t4: Elem address of v1

    lw t1 0(t3)             # t1: Value at v0 index
    lw t2 0(t4)             # t2: Value at v1 index

    mul t5 t1 t2            # t5: 2-Elem product = t1 * t2
    add t0 t0 t5            # t0 += t1 * t2

    addi t6 t6 1            # Increment index
    j loop_start

loop_end:
    mv a0 t0
    ret
