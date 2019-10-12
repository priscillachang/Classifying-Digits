.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 is the pointer to string representing the filename
#   a1 is a pointer to an integer, we will set it to the number of rows
#   a2 is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 is the pointer to the matrix in memory
# ==============================================================================
read_matrix:

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
		mv s1 a1                     # s1 = Pointer to NumRows
		mv s2 a2                     # s2 = Pointer to NumCols

		# Prepare for fopen
		mv a1 s0                     # fopen Arg1: Filename
		li a2 0                      # fopen Arg2: Read-Only Permission
		jal fopen
		li t0 -1
		beq a0 t0 eof_or_error
		mv s4 a0                     # s4 = File Descriptor

		# Get num rows
		mv a1 s4                     # fread Arg1: File Descriptor
		mv a2 s1                     # fread Arg2: Read bytes into here
		li a3 4                      # fread Arg3: Read 4 bytes at a time
		jal fread
		bne a0 a3 eof_or_error

		# Get num cols
		mv a1 s4                     # fread Arg1: File Descriptor
		mv a2 s2                     # fread Arg2: Read bytes into here
		li a3 4                      # fread Arg3: Read 4 bytes at a time
		jal fread
		bne a0 a3 eof_or_error

		# Prepare for malloc
		lw t0 0(s1)
		lw t1 0(s2)
		mul s3 t0 t1                 # s3 = Matrix Size
		slli a0 s3 2                 # malloc Arg0: Size to malloc
		jal malloc

		li t0 0                      # Counter
		mv t1 a0                     # Pointer to buffer
		mv s5 a0                     # s5: Pointer to matrix head

		mv a1 s4                     # fread Arg1: File Descriptor
		mv a2 t1                     # fread Arg2: Read bytes into here
		mv a3 s3                     # fread Arg3: Read s3 elems
		slli a3 a3 2                 # 4 bytes each
		jal fread
		bne a0 a3 eof_or_error

		mv a1 s4                     # fclose Arg1: File Descriptor
		jal fclose
		bne a0 x0 eof_or_error       # Unsuccessful fclose
		mv a0 s5

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
