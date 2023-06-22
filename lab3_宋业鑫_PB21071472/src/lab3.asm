.data
fib: .word 1, 1 # ����쳲�����¬��˹���е�ǰ����
statereg: .word 0x7f00
outreg: .word 0x7f0c
.text
.globl main
main:
    # ��ȡn
#    lui t3, %hi(statereg) #t3��״̬�Ĵ�����ַ
 #   addi t3, t3, %lo(statereg)
	
 	li t3, 0x7f00
    li t1, 99  #ȡcΪ������
loop0:     
    lw t2, (t3)
    beq t2, x0, loop0
    lw t2, 4(t3)   #ȡ���ݼĴ���,ʮ��������,n����t4
    beq t1, t2, startfib
    add t5, t4, t4   #t4��10
    add t4, t5, t5
    add t4, t4, t4
    add t4, t4, t5
    addi t2, t2,-48
    add t4, t4, t2
    j loop0


startfib:    
    add t0, x0, t4
    add s1, x0, t4
    addi t1, x0, 2 # t1=2
    blt t0, t1, exit # ���n<=2��ֱ���˳�����
    # ����쳲�����¬��˹����
    addi t0, t0, -2
    addi t2, x0, 4 
    addi t3, x0, 1 # t3=fib[0]
    addi t4, x0, 1 # t4=fib[1]
loop:
    add t5, t3, t4 # t5=fib[i-1]+fib[i-2]
    sw t5, 4(t2) # ��fib[i]�����ַt2+4��
    addi t2, t2, 4 # t2=t2+4
    addi t3, t4, 0 # t3=fib[i-2]
    addi t4, t5, 0 # t4=fib[i-1]
    addi t0, t0, -1
    beq x0, t0, exit # ���i==n-1���˳�ѭ��
    j loop # ��ת��loop��ǩ
exit:
    li t5, 0
    add t0, x0, s1 #t0Ϊn
loopexit:    jal x1, print
    addi t5, t5, 4
    addi t0, t0, -1
    blt x0,t0 loopexit
stop: j stop
     # �˳�����

print:
    #��ӡt5�������ַ��16����������ӡ���з�
    add s2, x0, t0
    add s3, x0, t1
    add s4, x0, t2
    add s5, x0, t3
    add s6, x0, t4
    lw t0, (t5)
    li t4, 0
    li t1, 0x7f0c
    li t2, 0x30
    sw t2, (t1)
    li t2, 0x78
    sw t2, (t1)		#��ӡ0x
    li t2, 0xf0000000
cnt0:
    srli t2, t2, 4
    addi t4, t4, 1	#t4��ǰ���ж��ٸ�0
    and t3, t2, t0
    beqz t3, cnt0
    li t3, 7
    sub t4, t3, t4	#t4Ϊ��ǰ�����Ӧ�����Ƽ�λ
    
    add t4, t4,t4
    add t4, t4, t4
loopprint:    
    li t3, 15
    srl t2, t0, t4
    and t2, t2, t3			#��Ҫ�ж������ֻ�����ĸ
    li t3, 9
    blt t3, t2, prw
    addi t2, t2, 48
    sw t2, (t1)
    j pre
prw:					#����ĸ
    addi t2, t2, 87
    sw t2, (t1)    
pre:    addi t4, t4, -4
    li t2, -1
    blt t2, t4 loopprint
    
    li t0, 0x0A		#��ӡ���з�
    sw t0, (t1)
    li t0, 0x0D
    sw t0, (t1)
    add t0, x0, s2
    add t1, x0, s3
    add t2, x0, s4
    add t3, x0, s5
    add t4, x0, s6
    jr x1
