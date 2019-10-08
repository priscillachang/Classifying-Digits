.import ../read_matrix.s
.import ../utils.s

.data
file_path: .asciiz "./test_input.bin"

.text
main:
    # Read matrix into memory
    li a0 4 # Alloc space for pointer to rows
    jal malloc
    mv a1 a0

    li a1 4 # Alloc space for pointer to cols
    jal malloc
    mv a2 a0

    la a0 file_path

    addi sp sp -8
    sw a1 0(sp)
    sw a2 4(sp)
    jal read_matrix
    lw a1 0(sp)
    lw a2 4(sp)
    addi sp sp 8

    # Print out elements of matrix
    lw a1 0(a1)
    lw a2 0(a2)
    jal print_int_array

    # Terminate the program
    addi a0, x0, 10
    ecall
