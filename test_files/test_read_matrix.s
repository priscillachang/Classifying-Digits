.import ../read_matrix.s
.import ../utils.s

.data
file_path: .asciiz "./test_input.bin"

.text
main:
    # Read matrix into memory
    la a0 file_path
    li a1 3
    li a2 3
    addi sp sp -8
    sw a1 0(sp)
    sw a2 4(sp)
    jal read_matrix
    lw a1 0(sp)
    lw a2 4(sp)
    addi sp sp 8

    # Print out elements of matrix
    jal print_int_array

    # Terminate the program
    addi a0, x0, 10
    ecall
