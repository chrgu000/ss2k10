/*xxworp001.p ĞÍ²ÄÍ³¼Æ±í    */
/* REVISION: 101022.1   Created On: 20101022   By: Softspeed Roger Xiao                               */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 101022.1  By: Roger Xiao */
/*-Revision end---------------------------------------------------------------*/


{mfdtitle.i "101022.1"}

define var v_date     as date label "ÉúĞ§ÈÕÆÚ" no-undo.
define var v_date1    as date label "ÖÁ" no-undo.
define var v_part     like pt_part label "³µĞÍ´úÂë" no-undo.
define var v_part1    like pt_part label "ÖÁ" no-undo.

define var v_qty_rct  like tr_qty_loc .
define var v_qty_conv like um_conv .
define var v_qty_bom  like wod_bom_qty .
define var v_qty_wt   like tr_qty_loc .
define var v_um       like pt_um .

define var v_desc1    like pt_desc1 .
define var v_desc2    like pt_Desc1. 

form
    SKIP(.2)
    v_date                   colon 18 
    v_date1                  colon 53 
    v_part                   colon 18 
    v_part1                  colon 53 

    skip(1) 
with frame a  side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:

    if v_date   = low_date then v_date  = ? .    
    if v_date1  = hi_date  then v_date1 = ? .    
    if v_part1  = hi_char  then v_part1 = "" .    

    update 
        v_date    
        v_date1   
        v_part       
        v_part1     
    with frame a.

    if v_date   = ?   then v_date  = low_date  .    
    if v_date1  = ?   then v_date1 = hi_date   .    
    if v_part1  = ""  then v_part1 = hi_char   .    
    

    {gpselout.i &printType = "printer"
                &printWidth = 132
                &pagedFlag = "nopage"
                &stream = " "
                &appendToFile = " "
                &streamedOutputToTerminal = " "
                &withBatchOption = "yes"
                &displayStatementType = 1
                &withCancelMessage = "yes"
                &pageBottomMargin = 6
                &withEmail = "yes"
                &withWinprint = "yes"
                &defineVariables = "yes"}
mainloop: 
do on error undo, return error on endkey undo, return error:                    

export delimiter "~011"
    " "
    " "
    "ĞÍ²ÄÍ³¼Æ±í" 
    .

export delimiter "~011"
    "Èë¿âÈÕÆÚ"
    "³µĞÍ" 
    "ÃèÊö"
    "Èë¿âÌ¨Êı" 
    "Áã²¿¼şÍ¼ºÅ"
    "ÃèÊö"
    "Áã¼ş¶¨¶î"
    "µ¥Î»ÊıÁ¿(EA)"
    "×ÜÖØÁ¿(KG)" 
    .

for each tr_hist
    use-index tr_eff_trnbr
    where tr_domain = global_domain  
    and tr_effdate >= v_date and tr_effdate <= v_date1
    and tr_type = "RCT-WO"
    and tr_part >= v_part and tr_part <= v_part1 
    no-lock
    break by tr_effdate by tr_part :

    if first-of(tr_part) then assign v_qty_rct  = 0 .

    v_qty_rct = v_qty_rct + tr_qty_loc .

    if last-of(tr_part) then do:
        find first wod_det 
            where wod_domain = global_domain 
            and wod_lot = tr_lot
            and (wod_op = 81 or wod_op = 82 or wod_op = 83 or wod_op = 84 )
        no-lock no-error.
        if avail wod_det then do:

            find first pt_mstr
                where pt_domain = global_domain 
                and pt_part = tr_part
            no-lock no-error.
            v_desc1 = if avail pt_mstr then pt_desc1 else "" .

            for each wod_det 
                where wod_domain = global_domain 
                and wod_lot = tr_lot
                and (wod_op = 81 or wod_op = 82 or wod_op = 83 or wod_op = 84 )
                no-lock
                break by wod_part by wod_op :
                if first-of(wod_part) then v_qty_bom   = 0.

                v_qty_bom = v_qty_bom + wod_bom_qty .

                if last-of(wod_part) then do:
                    find first pt_mstr
                        where pt_domain = global_domain 
                        and pt_part = wod_part
                    no-lock no-error.
                    v_um    = if avail pt_mstr then pt_um else "" .
                    v_desc2 = if avail pt_mstr then pt_desc1 else "" .


                    find first um_mstr
                        use-index um_part
                        where um_domain = global_domain
                        and um_part     = wod_part
                        and um_um       = v_um 
                        and um_alt_um   = "KG"
                    no-lock no-error.
                    v_qty_conv  = if avail um_mstr then um_conv else 0.

                    v_qty_wt = v_qty_rct * v_qty_conv * v_qty_bom .

                    export delimiter "~011"
                        string(year(tr_effdate),"9999") + "/" + string(month(tr_effdate),"99") + "/" + string(day(tr_effdate),"99") 
                        tr_part 
                        v_desc1
                        v_qty_rct 
                        wod_part
                        v_desc2
                        v_qty_conv
                        v_qty_bom
                        v_qty_wt 
                        .

                end. /*if last-of(wod_part)*/
            end. /*for each wod_det*/
        end. /*if avail wod_det*/
    end. /*if last-of(tr_part)*/
end. /*for each tr_hist*/


put skip(1)    
    "±¨±í½áÊø"  skip .

end. /* mainloop: */
/* {mfrtrail.i}  *REPORT TRAILER  */
{mfreset.i}
{pxmsg.i &MSGNUM=9 &ERRORLEVEL=1}
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}
