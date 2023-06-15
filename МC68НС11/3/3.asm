 org $8000

 ldaa #%01001011
 ldab #%11110001
 ldx #%0000000000000000

 stx $8100

 lslb
 rol $8100
 lsla
 rol $8100
 lslb
 rol $8100
 lsla
 rol $8100
 lslb
 rol $8100
 lsla
 rol $8100
 lslb
 rol $8100
 lsla
 rol $8100

 lslb
 rol $8101
 lsla
 rol $8101
 lslb
 rol $8101
 lsla
 rol $8101
 lslb
 rol $8101
 lsla
 rol $8101
 lslb
 rol $8101
 lsla
 rol $8101

 ldx $8100