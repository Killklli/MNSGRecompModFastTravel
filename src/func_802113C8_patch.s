.include "macro.inc"

.set noat
.set noreorder

.section .bss
.align 2
delay_counter: .space 4
should_delay: .space 4

.section .recomp_patch, "ax"

glabel func_802113C8_670378
    /* 670378 802113C8 27BDFFE0 */  addiu      $sp, $sp, -0x20
    /* 67037C 802113CC AFBF0014 */  sw         $ra, 0x14($sp)
    /* 670380 802113D0 AFA40020 */  sw         $a0, 0x20($sp)
    /* 670384 802113D4 AFA50024 */  sw         $a1, 0x24($sp)
    /* 670388 802113D8 0C0843E0 */  jal        func_80210F80_66FF30
    /* 67038C 802113DC 8C840068 */   lw        $a0, 0x68($a0)
    /* 670390 802113E0 24010001 */  addiu      $at, $zero, 0x1
    /* 670394 802113E4 14410003 */  bne        $v0, $at, .L_check_delay
    /* 670398 802113E8 8FBF0014 */   lw        $ra, 0x14($sp)
    
    # v0 == 1, continue with normal flow
    /* 67039C 802113EC 08000000 */  j          .L_continue_normal
    /* 6703A0 802113F0 00000000 */   nop

.L_check_delay:
    # Load should_delay to check if we need to start delaying
    lui        $t0, %hi(should_delay)
    lw         $t0, %lo(should_delay)($t0)
    
    # If should_delay is 0, initialize delay
    bnez       $t0, .L_check_delay_counter
    nop
    
    # Initialize delay: should_delay = 1, delay_counter = 100
    lui        $t0, %hi(should_delay)
    addiu      $t1, $zero, 0x1
    sw         $t1, %lo(should_delay)($t0)
    
    lui        $t0, %hi(delay_counter)
    addiu      $t1, $zero, 100  # 100 frames = ~2 seconds at 60fps
    sw         $t1, %lo(delay_counter)($t0)

.L_check_delay_counter:
    # Load delay_counter
    lui        $t0, %hi(delay_counter)
    lw         $t1, %lo(delay_counter)($t0)
    
    # If delay_counter > 0, decrement and exit (keep calling this function)
    blez       $t1, .L_end_delay
    nop
    
    # Decrement delay_counter
    addiu      $t1, $t1, -1
    sw         $t1, %lo(delay_counter)($t0)
    
    # Exit function to keep animation running (this will cause the function to be called again)
    /* 6703C4 80211414 08000000 */  j          .L80211418_6703C8
    /* 6703C8 80211418 00000000 */   nop

.L_end_delay:
    # Reset should_delay = 0 when delay is over
    lui        $t0, %hi(should_delay)
    sw         $zero, %lo(should_delay)($t0)
    
    # Now allow animation to end normally by continuing with the function

.L_continue_normal:
    /* 67039C 802113EC 8FA20020 */  lw         $v0, 0x20($sp)
    /* 6703A0 802113F0 2442005C */  addiu      $v0, $v0, 0x5C
    /* 6703A4 802113F4 8C440008 */  lw         $a0, 0x8($v0)
    /* 6703A8 802113F8 0C084471 */  jal        func_802111C4_670174
    /* 6703AC 802113FC AFA20018 */   sw        $v0, 0x18($sp)
    /* 6703B0 80211400 8FA20018 */  lw         $v0, 0x18($sp)
    /* 6703B4 80211404 3C048021 */  lui        $a0, %hi(func_802112C0_670270)
    /* 6703B8 80211408 248412C0 */  addiu      $a0, $a0, %lo(func_802112C0_670270)
    /* 6703BC 8021140C 0C00D487 */  jal        func_8003521C_35E1C
    /* 6703C0 80211410 AC400018 */   sw        $zero, 0x18($v0)
    /* 6703C4 80211414 8FBF0014 */  lw         $ra, 0x14($sp)
  .L80211418_6703C8:
    /* 6703C8 80211418 27BD0020 */  addiu      $sp, $sp, 0x20
    /* 6703CC 8021141C 03E00008 */  jr         $ra
    /* 6703D0 80211420 00000000 */   nop
endlabel func_802113C8_670378