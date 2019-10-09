.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
#   If any file operation fails or doesn't write the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 is the pointer to string representing the filename
#   a1 is the pointer to the start of the matrix in memory
#   a2 is the number of rows in the matrix
#   a3 is the number of columns in the matrix
# Returns:
#   None
# ==============================================================================
write_matrix:

    # Prologue
    addi sp sp -28
		sw s0 0(sp)
		sw s1 4(sp)
		sw s2 8(sp)
		sw s3 12(sp)
		sw s4 16(sp)
		sw s5 20(sp)
		sw ra 24(sp)

		mv s0 a0                     # s0 = Filename
		mv s1 a1                     # s1 = Pointer to Matrix
		mv s2 a2                     # s2 = NumRows
    mv s3 a3                     # s3 = NumCols
    li a0 8
    jal malloc                 # Store in a place
    sw s2 0(a0)
    sw s3 4(a0)
    mv s5 a0

    lw a1 0(s5)
    jal print_int
    lw a1 4(s5)
    jal print_int

		# Prepare for fopen
		mv a1 s0                     # fopen Arg1: Filename
		li a2 1                      # fopen Arg2: Write Permission
		jal fopen
		mv s4 a0                     # s4 = File Descriptor

    mv a1 s4                     # Write number of rows
    mv a2 s5                     #
    li a3 1                      # Read 1 thing
    li a4 4                      # Size of thing
    jal fwrite
    blt a0 a3 eof_or_error
    addi s5 s5 4

    mv a1 s4                     # Write number of columns
    mv a2 s5                   #
    li a3 1                      # Read 1 thing
    li a4 4                      # Size of thing
    jal fwrite
    blt a0 a3 eof_or_error

    li t0 0                     # Counter
    mv t1 a1                    # Buffer to read from
    mul s3 s2 s3                # Number of elems

    li a1 'a'
    jal print_char

    mv a1 s4                    # Write number of columns
    mv a2 s1                      #
    mv a3 s3                    # Read s3 things
    li a4 4                     # Size of thing
    jal fwrite
    blt a0 a3 eof_or_error
    li a1 'a'
    jal print_char
    j end
loop:
    bge t0 s3 end
    mv a1 s4                    # Counter
    mv a2 t1                    # Buffer to read from
    li a3 1                     # Nunber of elems
    li a4 4                     # Size of thing
    jal fwrite
    blt a0 a3 eof_or_error

    addi t0 t0 1
    addi t1 t1 4
    j loop

end:
    mv a1 s4                     # fclose Arg1: File Descriptor
    jal fclose
    bne a0 x0 eof_or_error       # Unsuccessful fclose
    # Epilogue
    lw s0 0(sp)
		lw s1 4(sp)
		lw s2 8(sp)
		lw s3 12(sp)
		lw s4 16(sp)
		lw s5 20(sp)
		lw ra 24(sp)
		addi sp sp 28

    ret

eof_or_error:
    li a1 1
    jal exit2
