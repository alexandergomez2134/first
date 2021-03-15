= Begin code area ====================================================================================================================================================

;%include "savedata.inc"                                     ;Not used in this program.  External macros that assist in data backup.

;%include "debug.inc"                                        ;Not now in use.  The debug tool was used during the development stages of this program.

extern printf                                               ;External C++ function for writing to standard output device

extern scanf                                                ;External C++ function for reading from the standard input device

global array_tools                                          ;This makes array_tools callable by functions outside of this file.

segment .data                                               ;Place initialized data here

;===== Declare some messages ==============================================================================================================================================
;The identifiers in this segment are quadword pointers to ascii strings stored in heap space.  They are not variables.  They are not constants.  There are no constants in
;assembly programming.  There are no variables in assembly programming: the registers assume the role of variables.

array_tools.initialmessage db "The X86 subprogram is now executing.", 10, 0

arrayaddressmessage db "The first element of the array is located at 0x%016lx in stack space", 10, 0

promptforcell db "Please enter an integer between 0 and 11 inclusively: ", 0

promptmessage db "Enter a floating point number in base 10: ", 0

two_extra_numbers_form db "Two numbers in heap space after the end of the array are %1.16lf and %1.16lf",10,0

student_message db "Those two numbers are stored in stack space adjacent to the end of the array.", 10, 0

goodbye db "The X86 subprogram array_tools will now return to the caller program.", 10, 10, 0

stringformat db "%s", 0                                     ;general string format

integerformat db "%ld", 0                                   ;general decimal integer

eight_byte_format db "%lf", 0                               ;general 8-byte float format

segment .bss                                                ;Declare pointers to un-initialized space in this segment.


;==========================================================================================================================================================================
;===== Begin the application here: show how to input and output floating point numbers ====================================================================================
;==========================================================================================================================================================================

segment .text                                               ;Place executable instructions in this segment.

array_tools:                                                ;Entry point.  Execution begins here.

;The next two instructions should be performed at the start of every assembly program.
push       rbp                                              ;This marks the start of a new stack frame belonging to this execution of this function.
mov        rbp, rsp                                         ;rbp holds the address of the start of this new stack frame.  When this function returns to its caller rbp must
                                                            ;hold the same value it holds now.

;=========== Save the data passed to this X86 subprogram =======================

mov        r13, rdi                                         ;r13 holds the pointer to the array created in the caller program
mov        r14, rsi                                         ;r14 holds the size of the array that was passed to this x86 subprogram

;=========== Show the initial message =====================================================================================================================================

mov qword  rax, 0                                           ;No data from SSE will be printed
mov        rdi, stringformat                                ;"%s"
mov        rsi, .initialmessage                             ;"The X86 subprogram is now executing."
call       printf                                           ;Call a library function to make the output

;=========== Show the starting address of the array sent here from the caller =============================================================================================

mov qword  rax, 0                                           ;No data from SSE will be printed
mov        rdi, arrayaddressmessage                         ;"The first element of the array is located at 0x%016lx in the stack space"
mov        rsi, r13                                         ;rsi has the address of the start of the array
call       printf

;=========== Prompt for an array cell number to change ====================================================================================================================

mov qword  rax, 0
mov        rdi, promptforcell                               ;"Please enter an integer between 0 and 11 inclusively: "
call       printf

;===== OK to here

;=========== Input an integer between 0 and 11 ============================================================================================================================

push qword 0                                                ;Push 8 bytes solely for the purpose of getting onto an 16-byte boundary.
mov qword  rax, 0                                           ;No xmm register are involved in the call to scanf
push qword 0                                                ;Create space in memory for the incoming number
mov        rdi, integerformat                               ;"%ld"
mov        rsi, rsp                                         ;rsi points to the quadword of available space in memory
call       scanf
pop        r15                                              ;The cell number is now in r15
pop        rax                                              ;Remove the earlier push regarding the 16-byte boundary

;=========== Prompt for floating point number =============================================================================================================================
mov qword  rax, 0                                           ;No data from SSE will be printed
mov        rdi, stringformat                                ;"%s"
mov        rsi, promptmessage                               ;"Enter a floating point number in base 10: "
call       printf                                           ;Call a library function to make the output

;=========== Obtain a floating point number from the standard input device and store it in r8 =============================================================================

push qword 0                                                ;Push 8 bytes solely for the purpose of getting onto an 16-byte boundary.
push qword 0                                                ;Reserve 8 bytes of storage for the incoming number
mov qword  rax, 0                                           ;SSE is not involved in this scanf operation
mov        rdi, eight_byte_format                           ;"%lf"
mov        rsi, rsp                                         ;Give scanf a point to the reserved storage
call       scanf                                            ;Call a library function to do the input work
pop        r8                                               ;The float number is now in r8
pop        rax                                              ;Remove the earlier push regarding the 16-byte boundary

;=========== Place the inputted float number into its proper cell =========================================================================================================

mov        [r13+r15*8],r8                                   ;Copy the inputted number into slot r15 of the array

;=========== Just for fun: show two numbers in the heap located immediately after the end of the array =================================================================

mov        rax, 2
movsd      xmm0,[r13+8*r14]
movsd      xmm1,[r13+8*r14+8]
mov        rdi,two_extra_numbers_form                       ;"Two numbers in heap space after the end of the array are %1.16lf and %1.16lf"
call       printf

mov        rax, 0
mov        rdi, student_message                             ;"Those two numbers are stored in stack space."
call       printf

;===== Conclusion message =================================================================================================================================================
;It is not necessary to be on a boundary to output a string.

mov qword  rax, 0                                           ;No data from SSE will be printed
mov        rdi, stringformat                                ;"%s"
mov        rsi, goodbye                                     ;"The X86 subprogram arrays-x86 will now return to the caller program."
call       printf                                           ;Call a library function to do the hard work.

;========== Send a float number back to the caller ========================================================================================================================

movsd      xmm0,[r13+r15*8]                                 ;A copy from any memory location to a xmm register is allowed.

;===== Restore the pointer to the start of the stack frame before exiting from this function ==============================================================================

pop        rbp                                              ;Now the system stack is in the same state it was when this function began execution.
ret                                                         ;Pop a qword from the stack into rip, and continue executing..
