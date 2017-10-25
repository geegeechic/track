.global main
.func main
   
main:
    BL  _scanf              @ branch to scanf procedure with return
    BL  _getchar            @ branch to scanf procedure with return
    BL  _scanf2              @ branch to scanf procedure with return
    MOV R1, R0              @ move return value R0 to argument register R1
    BL  _compare            @ check the scanf input
    BL  _printf             @ branch to print procedure with return
    B   _exit               @ branch to exit procedure with no return
   
_exit:  
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #21             @ print string length
    LDR R1, =exit_str       @ string at label exit_str:
    SWI 0                   @ execute syscall
    MOV R7, #1              @ terminate syscall, 1
    SWI 0                   @ execute syscall
                      
_getchar:
    MOV R7, #3              @ write syscall, 3
    MOV R0, #0              @ input stream from monitor, 0
    MOV R2, #1              @ read a single character
    LDR R1, =read_char      @ store the character in data memory
    SWI 0                   @ execute the system call
    LDR R0, [R1]            @ move the character to the return register
    AND R0, #0xFF           @ mask out all but the lowest 8 bit
    MOV PC, LR              @ return
 
_printf:
    MOV R4, LR              @ store LR since printf call overwrites
    LDR R0, =printf_str     @ R0 contains formatted string address
    MOV R1, R1              @ R1 contains printf argument (redundant line)
    BL printf               @ call printf
    MOV PC, R4              @ return
                               
_scanf:
    PUSH {LR}                @ store LR since scanf call overwrites
    SUB SP, SP, #4          @ make room on stack
    LDR R0, =format_str     @ R0 contains address of format string
    MOV R3, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ restore the stack pointer
    POP {PC}                 @ return

_scanf2:
    PUSH {LR}                @ store LR since scanf call overwrites
    SUB SP, SP, #4          @ make room on stack
    LDR R0, =format_str2     @ R0 contains address of format string
    MOV R6, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ restore the stack pointer
    POP {PC}                 @ return

_compare:
	  CMP R1, #'+'
	  BEQ _add
	  BNE _compare1
  
_compare1:
	  CMP R1, #'-'
	  BEQ _subt
	  BNE _compare2
    
_compare2:
  	CMP R1, #'*'
	  BEQ _multi
	  BNE _incorrect

_add:
  	MOV R0, R3         @ copy input register R1 to return register R0
  	ADD R0, R6          @ add input register R2 to return register R0
  	MOV PC, LR          @ return

_subt:
  	MOV R0, R3         @ copy input register R1 to return register R0
	  SUB R0, R6          @ add input register R2 to return register R0
	  MOV PC, LR          @ return

_multi:
	  MOV R0, R3          @ copy input register R1 to return register R0
	  MUL R0, R6          @ add input register R2 to return register R0
	  MOV PC, LR          @ return
                                
 
_incorrect:
    MOV R5, LR              @ store LR since printf call overwrites
    LDR R0, =nequal_str     @ R0 contains formatted string address
    BL printf               @ call printf
    MOV PC, R5              @ return
    
 
.data
format_str:     .asciz      "%d"
read_char:      .ascii      " "
format_str2:     .asciz      "%d"
printf_str:     .asciz      "The result is: %d\n"
nequal_str:     .asciz      "INCORRECT: %c \n"
exit_str:       .ascii      "Terminating program.\n"
