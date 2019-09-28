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
    li t0 0                 # t0: Sum
    li t6 0                 # t6: Indexer

loop_start:
    bge t6 a2 loop_end

    li t3 0
    mul t3 t6 a3
    slli t3 t3 2
    add t3 t3 a0

    li t4 0
    mul t4 t6 a4
    slli t4 t4 2
    add t4 t4 a1

    lw t1 0(t3)             # t1: Value at curr v0 index
    lw t2 0(t4)             # t2: Value at curr v1 index

    ##DEBUG##
     addi sp sp -8
     sw a0 0(sp)
     sw a1 4(sp)
     li a0 1
     mv a1 t1
     ecall
     li a0 11
     li a1 ' '
     ecall
     li a0 1
     mv a1 t2
     ecall
     li a0 11
     li a1 '\n'
     ecall
     lw a0 0(sp)
     lw a1 4(sp)
     addi sp sp 8
    #########

    mul t5 t1 t2            # t5: 2-Element Product = t1 * t2
    add t0 t0 t5            # Sum += Product

    addi t6 t6 1
    j loop_start

loop_end:
    mv a0 t0

    # Epilogue

    ret
