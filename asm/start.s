.section .entry
.align 1

.global _entry
_entry:
    j _entry
    j _entry
    j _entry
    j _entry
    j start

.section .text.start
.align 1

.global start
start:
    /* Set up stack pointer and global pointer */
.option push
.option norelax
1:  auipc   gp, %pcrel_hi(__global_pointer$)
    addi    gp, gp, %pcrel_lo(1b)
.option pop
    la      sp, __stack_va

    /* Copy data sections from ROM into RAM */
    la      t0, __data_start
    la      t1, __data_end
    la      t2, __data_va
    j       copy_data_loop_end
copy_data_loop:
    lw      t3, 0(t0)
    addi    t0, t0, 4
    addi    t2, t2, 4
    sw      t3, -4(t2)
copy_data_loop_end:
    bltu    t0, t1, copy_data_loop

    /* Clear bss sections */
    la      t0, __bss_start
    la      t1, __bss_end
    j       clear_bss_loop_end
clear_bss_loop:
    sw      zero, 0(t0)
    addi    t0, t0, 4
clear_bss_loop_end:
    bltu    t0, t1, clear_bss_loop

    /* Run the main function */
    jal     main

    ebreak
end_loop:
    j       end_loop

.global riscv_cycles
riscv_cycles:
    rdcycleh a1
    rdcycle a0
    rdcycleh t0
    bne     a1, t0, riscv_cycles
    ret

.global riscv_instret
riscv_instret:
    rdinstreth a1
    rdinstret a0
    rdinstreth t0
    bne     a1, t0, riscv_instret
    ret
