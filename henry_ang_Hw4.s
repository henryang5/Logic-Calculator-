# Henry Ang
# 2/12/17
# CSC 3760
# HW 4 Programming

# Logic calculator based on NAND logic. Program will create NAND, OR, and NOR logic.

.data
.text

main:
        # load A in $a0: 0xABCDEFED
        lui $a0, 0xABCD       # load upper 16 bits 0xABCD
        ori $a0, $a0, 0xEFED  # load lower 16 bits 0xEFED

        # load B in $a1: 0xDEADBEEF
        lui $a1, 0xDEAD       # load upper 16 bits 0xDEAD
        ori $a1, $a1, 0xBEEF  # load lower 16 bits 0xBEEF

        jal myNAND            # call myNAND function, saves address of next instr in $ra(31)
        jal myOR              # call myOR function, saves address of next instr in $ra(31)
        jal myNOR             # call myNOR function, saves address of next instr in $ra(31)

        j END                 # jump to end, closes program

myNAND:
        # NAND logic (1 1 1 0)
        and  $t0, $a0, $a1     #  AND A+B                        (AND)(0 0 0 1)
        nor  $t1, $t0, $t0     # (AND A+B) NOR (AND A+B) = NAND. (NOR)(1 0 0 0) -> (1 1 1 0)(NAND)
        add $v0, $0, $t1       # copy NAND output into register $v0

        jr	$ra                # return to return address in $ra

myOR:
        # store temparary A, B
        add $t8, $0, $a0      # store temp A into register $t8
        add $t9, $0, $a1      # store temp B into register $t9

        # A NAND A
        add $a1, $0, $t8      # Make B = A
        addi $sp, $sp, -4     # adjust the sp
        sw	 $ra, 0($sp)      # store old ra on stack
        jal  myNAND           # call myNAND fuction, saves address of next instr in $ra(31)
        lw   $ra, 0($sp)      # restore ra
        addi $sp, $sp, 4      # re adjust sp
        add $t4, $0, $v0      # store output of A NAND A in $t4


        # B NAND B
        add $a0, $0, $t9      # Make a0(A) = B
        add $a1, $0, $t9      # Make a1(B) = B
        addi $sp, $sp, -4     # adjust the sp
        sw	 $ra, 0($sp)      # store old ra on stack
        jal myNAND            # call myNAND fuction, saves address of next instr in $ra(31)
        lw   $ra, 0($sp)      # restore ra
        addi $sp, $sp, 4      # re adjust sp
        add $t5, $0, $v0      # store output of B NAND B in $t5


        # A output NAND B output
        add $a0, $0, $t4      # Make A = A output
        add $a1, $0, $t5      # Make B = B output
        addi $sp, $sp, -4     # adjust the sp
        sw	 $ra, 0($sp)      # store old ra on stack
        jal myNAND            # call myNAND fuction, saves address of next instr in $ra(31)
        lw   $ra, 0($sp)      # restore ra
        addi $sp, $sp, 4      # re adjust sp

        # reset A and B to original hex number
        # load A: 0xABCDEFED
        lui $a0, 0xABCD       # load upper 16 bits 0xABCD
        ori $a0, $a0, 0xEFED  # load lower 16 bits 0xEFED

        # load B: 0xDEADBEEF
        lui $a1, 0xDEAD       # load upper 16 bits 0xDEAD
        ori $a1, $a1, 0xBEEF  # load lower 16 bits 0xBEEF

        jr	$ra               # return to return address in $ra


myNOR:
        # store temparary A, B
        add $t8, $0, $a0      # store temp A into register $t8
        add $t9, $0, $a1      # store temp B into register $t9

        # A NAND A
        add $a1, $0, $t8      # Make B = A
        addi $sp, $sp, -4     # adjust the sp
        sw	 $ra, 0($sp)      # store old ra on stack
        jal  myNAND           # call myNAND fuction, saves address of next instr in $ra(31)
        lw   $ra, 0($sp)      # restore ra
        addi $sp, $sp, 4      # re adjust sp
        add $t4, $0, $v0      # Store output of A NAND A in $t4

        # B NAND B
        add $a0, $0, $t9      # Make a0(A) = B
        add $a1, $0, $t9      # Make a1(B) = B
        addi $sp, $sp, -4     # adjust the sp
        sw	 $ra, 0($sp)      # store old ra on stack
        jal myNAND            # call myNAND fuction, saves address of next instr in $ra(31)
        lw   $ra, 0($sp)      # restore ra
        addi $sp, $sp, 4      # re adjust sp
        add $t5, $0, $v0      # store output of B NAND B in $t5

        # A output NAND B output
        add $a0, $0, $t4      # Make A = A output
        add $a1, $0, $t5      # Make B = B output
        addi $sp, $sp, -4     # adjust the sp
        sw	 $ra, 0($sp)      # store old ra on stack
        jal myNAND            # casl myNAND fuction, saves address of next instr in $ra(31)
        lw   $ra, 0($sp)      # restore ra
        addi $sp, $sp, 4      # re adjust sp
        add $t6, $0, $v0      # store output of A output NAND B output in $t6

        # (A output NAND B output) NAND (A output NAND B output)
        add $a0, $0, $t6      # Make A = A, B output
        add $a1, $0, $t6      # Make B = A, B output
        addi $sp, $sp, -4     # adjust the sp
        sw	 $ra, 0($sp)      # store old ra on stack
        jal myNAND            # call myNAND fuction, saves address of next instr in $ra(31)
        lw   $ra, 0($sp)      # restore ra
        addi $sp, $sp, 4      # re adjust sp

        jr	$ra               # return to return address in $ra

END:
        # exit the program
        li	$v0,10			# code for exit
        syscall				# exit program
