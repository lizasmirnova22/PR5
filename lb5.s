.text
.global _start
_start:
    # Константы
    .equ a, 18
    .equ b, 8
    .equ c, 9
    addi s0, x0, a  # s0 = a
    addi s1, x0, b  # s1 = b
    addi s2, x0, c  # s2 = c 

    # Входные данные {x1, y1, z1}
    li a2, -1      # x1
    li a3, -1     # y1
    li a4, -1        # z1

    # Входные данные {x2, y2, z2}
    li a5, 1     # x2
    li a6, 1      # y2
    li a7, 1      # z2
    mv s4, a7

    # Вывод формулы
    la a0, formula
    addi a7, x0, 4  # PrintString
    ecall

    # Вывод входных данных
    mv a0, a2       # x1
    addi a7, x0, 1  # PrintInt
    ecall
    li a0, 32
    addi a7, x0, 11 # PrintChar (space)
    ecall
    mv a0, a3       # y1
    addi a7, x0, 1
    ecall
    li a0, 32
    addi a7, x0, 11
    ecall
    mv a0, a4       # z1
    addi a7, x0, 1
    ecall
    li a0, 10
    addi a7, x0, 11 # PrintChar (newline)
    ecall

    # Вывод второго набора данных
    la a0, data
    addi a7, x0, 4  # PrintString
    ecall
    mv a0, a5       # x2
    addi a7, x0, 1  # PrintInt
    ecall
    li a0, 32
    addi a7, x0, 11 # PrintChar (space)
    ecall
    mv a0, a6       # y2
    addi a7, x0, 1
    ecall
    li a0, 32
    addi a7, x0, 11
    ecall
    mv a7, s4       # z2
    mv a0, a7
    addi a7, x0, 1
    ecall
    li a0, 10
    addi a7, x0, 11 # PrintChar (newline)
    ecall

    # Вызов процедуры вычислений
    call calc_expression

    # Вывод результатов
    la a0, results
    addi a7, x0, 4  # PrintString
    ecall
    mv a0, a1       # r1
    addi a7, x0, 1  # PrintInt
    ecall
    li a0, 10
    addi a7, x0, 11 # PrintChar (newline)
    ecall
    mv a0, a2       # r2
    addi a7, x0, 1  # PrintInt
    ecall
    addi a0, x0, 1	# завершение программы системным вызовом
    addi a7, x0, 93	# Exit (a7=93) с кодом возврата в регистре а0
    ecall

calc_expression:
    # Вычисление для {x1, y1, z1}
    neg s2, s2       # s2 = -c 
    sra t0, a2, s0   # t0 = x1 >> a
    add t1, a3, s1   # t1 = y1 + b
    and t2, t0, t1   # t2 = (x1 >> a) & (y1 + b)
    or t3, a4, s2    # t3 = z1 | c
    add a1, t2, t3   # r1 = ((x1 >> a) & (y1 + b)) + (z1 | c)

    # Вычисление для {x2, y2, z2}
    sra t0, a5, s0  # t0 = x2 >> a
    add t1, a6, s1   # t1 = y2 + b
    and t2, t0, t1   # t2 = (x2 >> a) & (y2 + b)
    or t3, s4, s2    # t3 = z2 | c
    add a2, t2, t3   # r2 = ((x2 >> a) & (y2 + b)) + (z2 | c)

    ret              # возврат из процедуры

.data
formula: .asciz "Formula: ((x >> 18) & (y + 8)) + (z | -9)\nInput data:\n{x1, y1, z1} = "
data:    .asciz "{x2, y2, z2} = "
results: .asciz "Results:\n"
