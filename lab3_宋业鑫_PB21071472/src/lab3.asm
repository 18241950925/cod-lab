.data
fib: .word 1, 1 # 储存斐波那契卢卡斯数列的前两项
statereg: .word 0x7f00
outreg: .word 0x7f0c
.text
.globl main
main:
    # 读取n
#    lui t3, %hi(statereg) #t3存状态寄存器地址
 #   addi t3, t3, %lo(statereg)
	
 	li t3, 0x7f00
    li t1, 99  #取c为结束符
loop0:     
    lw t2, (t3)
    beq t2, x0, loop0
    lw t2, 4(t3)   #取数据寄存器,十进制输入,n存在t4
    beq t1, t2, startfib
    add t5, t4, t4   #t4乘10
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
    blt t0, t1, exit # 如果n<=2，直接退出程序
    # 计算斐波那契卢卡斯数列
    addi t0, t0, -2
    addi t2, x0, 4 
    addi t3, x0, 1 # t3=fib[0]
    addi t4, x0, 1 # t4=fib[1]
loop:
    add t5, t3, t4 # t5=fib[i-1]+fib[i-2]
    sw t5, 4(t2) # 将fib[i]存入地址t2+4中
    addi t2, t2, 4 # t2=t2+4
    addi t3, t4, 0 # t3=fib[i-2]
    addi t4, t5, 0 # t4=fib[i-1]
    addi t0, t0, -1
    beq x0, t0, exit # 如果i==n-1，退出循环
    j loop # 跳转到loop标签
exit:
    li t5, 0
    add t0, x0, s1 #t0为n
loopexit:    jal x1, print
    addi t5, t5, 4
    addi t0, t0, -1
    blt x0,t0 loopexit
stop: j stop
     # 退出程序

print:
    #打印t5内所存地址的16进制数，打印换行符
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
    sw t2, (t1)		#打印0x
    li t2, 0xf0000000
cnt0:
    srli t2, t2, 4
    addi t4, t4, 1	#t4存前面有多少个0
    and t3, t2, t0
    beqz t3, cnt0
    li t3, 7
    sub t4, t3, t4	#t4为最前面的数应该右移几位
    
    add t4, t4,t4
    add t4, t4, t4
loopprint:    
    li t3, 15
    srl t2, t0, t4
    and t2, t2, t3			#需要判断是数字还是字母
    li t3, 9
    blt t3, t2, prw
    addi t2, t2, 48
    sw t2, (t1)
    j pre
prw:					#是字母
    addi t2, t2, 87
    sw t2, (t1)    
pre:    addi t4, t4, -4
    li t2, -1
    blt t2, t4 loopprint
    
    li t0, 0x0A		#打印换行符
    sw t0, (t1)
    li t0, 0x0D
    sw t0, (t1)
    add t0, x0, s2
    add t1, x0, s3
    add t2, x0, s4
    add t3, x0, s5
    add t4, x0, s6
    jr x1
