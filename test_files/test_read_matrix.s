.import ../read_matrix.s
.import ../utils.s

.data
file_path: .asciiz "./test_input.bin"
string1: .asciiz "Number of Rows: "
string2: .asciiz "Number of Columns: "

.text
main:
    # Read matrix into memory
    li a0 4 # Alloc space for pointer to rows
    jal malloc
    mv a1 a0
    mv s1 a0

    li a1 4 # Alloc space for pointer to cols
    jal malloc
    mv a2 a0
    mv s2 a0

    la a0 file_path

    addi sp sp -8
    sw a1 0(sp)
    sw a2 4(sp)
    jal read_matrix
    lw a1 0(sp)
    lw a2 4(sp)
    mv s5 a0
    mv s3 a1
    mv s4 a2
    addi sp sp 8

    # Print out elements of matrix
    la a1 string1
    jal print_str
    lw a1 0(s1)
    jal print_int
    li a1 '\n'
    jal print_char
    la a1 string2
    jal print_str
    lw a1 0(s2)
    jal print_int
    li a1 '\n'
    jal print_char

    mv a0 s5
    lw a1 0(s3)
    lw a2 0(s4)
    jal print_int_array

    # Terminate the program
    addi a0, x0, 10
    ecall
