.import ../dot.s
.import ../utils.s

# Set vector values for testing
.data
vector0: .word 1 1 1 1 1 1 1
vector1: .word 1 1 1 1 1 1 1


.text
# main function for testing
main:
    # Load vector addresses into registers
    la s0 vector0
    la s1 vector1

    # Set vector attributes
    li a2 5        # VECTOR LENGTH
    li a3 1        # v0 STRIDE
    li a4 1        # v1 STRIDE

    # Call dot function
    mv a0 s0
    mv a1 s1
    jal ra dot

    # Print the output of argmax
    mv a1 a0
    jal ra print_int

    # Print newline
    li a1 '\n'
    jal ra print_char

    # Exit
    jal exit
