.import ../matmul.s
.import ../utils.s
.import ../dot.s

# static values for testing
.data
m0: .word 1 2 3 4 5 6 7 8 9 10 11 12
m1: .word 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
d: .word 0 0 0 0 0 0 0 0 0 # allocate static space for output

.text
main:
    # Load addresses of input matrices (which are in static memory), and set their dimensions
    la s0 m0
    la s1 m1
    la s2 d
    li s3 4
    li s4 5
    la a0 m0
    la a3 m1
    la a6 d
    li a1 4
    li a2 3
    li a4 3
    li a5 5

    # Call matrix multiply, m0 * m1
    jal ra matmul

    # Print the output (use print_int_array in utils.s)
    mv a0 s2
    mv a1 s3
    mv a2 s4
    jal ra print_int_array
    li a1 '\n'
    jal ra print_char

    # Exit the program
    jal exit
