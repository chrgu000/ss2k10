/**/
/* REVISION: 1.0      LAST MODIFIED: 2009/01/07   BY: Softspeed roger xiao   ECO:*xp003* */ 
/*-Revision end--------------------------------------------------------------------------*/



/* DISPLAY TITLE */
{mfdtitle.i "1.0"}

define var site  like xmpt_site .
define var v_buyer like pt_buyer  label "计划员".
define var v_buyer1 like pt_buyer .
define var v_buyer2 like pt_buyer .
define var part  like xmpt_part .
define var part1 like xmpt_part .
define var desc1 like pt_desc1.
define var desc2 like pt_desc2 .
define var loc   like ld_loc .
define var loc1  like ld_loc .
define var v_yn  as logical initial "No" .


define var v_qty_kb like ld_qty_oh.
define var v_qty_ld like ld_qty_oh.
define var v_error  as logical initial "No" .

find icc_ctrl where icc_domain = global_domain no-lock no-error.
site = if avail icc_ctrl then icc_site else global_site .

define  frame a.

/* DISPLAY SELECTION FORM */
form
    SKIP(.2)

    site                     colon 18   
    v_buyer                  colon 18   label "计划员"
    v_buyer1                 colon 54   label  {t001.i}
    part                     colon 18
    part1                    colon 54   label  {t001.i}
    loc                      colon 18
    loc1                     colon 54   label  {t001.i}
    skip(1)
    v_yn                     colon 18   label "仅差异部分"
    skip (2)
   
with frame a  side-labels width 80 attr-space.

/* SET EXTERNAL LABELS  */
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
    if part1 = part         then part1 = "".
    if v_buyer1 = v_buyer   then v_buyer1 = "".
    if loc1 = loc           then loc1 = "".

    disp site with frame a .   

    update site v_buyer v_buyer1 part part1 loc loc1 v_yn with frame a.

    find first xkbc_ctrl where xkbc_domain = global_domain and xkbc_enable = yes and ( xkbc_site = site) no-lock no-error .
    if not avail xkbc_ctrl then do:
        find first xkbc_ctrl where xkbc_domain = global_domain and xkbc_enable = yes and ( xkbc_site = "" ) no-lock no-error .
        if not avail xkbc_ctrl then do:
            /* {pxmsg.i &MSGNUM=???? &ERRORLEVEL=3} */
            message "看板模块没有开启" view-as alert-box .
            leave .
        end.
    end.


    if part1 = ""       then part1 = part.
    if v_buyer1 = ""    then v_buyer1 = v_buyer.
    if loc1 = ""        then loc1 = loc.

    /* PRINTER SELECTION */
    {gpselout.i &printType = "printer"
                &printWidth = 132
                &pagedFlag = " "
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



for each xkb_mstr 
    where xkb_domain = global_domain 
    and  xkb_site = site 
    and  xkb_part >= part and (xkb_part <= part1 or part1 = "" )
    and  xkb_loc  >= loc and (xkb_loc  <= loc1 or loc1 = ""  )
    and  xkb_status = "U"
    no-lock break by xkb_part by xkb_loc 
    with frame x width 100 :

    v_buyer2 = "" .
    find first ptp_det  where ptp_domain = global_domain and ptp_site = xkb_site and ptp_part = xkb_part no-lock no-error .
    if avail ptp_det then do:
        if ptp_buyer <> ""  then v_buyer2 = ptp_buyer .
        else do:
            find first pt_mstr  where pt_domain = global_domain and pt_part = xkb_part no-lock no-error .
            if avail pt_mstr then do:
                if pt_buyer <> "" then assign v_buyer2 = pt_buyer .
            end.
        end.
    end.
    else do:
        find first pt_mstr  where pt_domain = global_domain and pt_part = xkb_part no-lock no-error .
        if avail pt_mstr then do:
            if pt_buyer <> "" then assign v_buyer2 = pt_buyer .
        end.
    end.

    if not ( v_buyer2 >= v_buyer and ( v_buyer2 <= v_buyer1 or v_buyer1 = "" )) then next .
    

    if first-of (xkb_loc) then do:
        v_qty_kb = 0 .
        v_qty_ld = 0 .
        for each ld_Det 
            use-index ld_part_loc 
            where ld_domain = global_domain and ld_part = xkb_part and ld_site = xkb_site and ld_loc = xkb_loc no-lock :
            v_qty_ld = v_qty_ld + ld_qty_oh .
        end.
    end.

    v_qty_kb = v_qty_kb + xkb_kb_raim_qty .

    if last-of (xkb_loc) then do:
        v_error = if v_qty_kb = v_qty_ld then no else yes .

        if v_yn = no then do:
            disp 
                 xkb_part                label "料号"
                 xkb_site                label "地点"
                 xkb_loc                 label "库位"
                 v_qty_kb                label "看板余量"
                 v_qty_ld                label "实际库存"
                 v_error                 label "差异"
            with frame x .
        end.
        else do:
            if v_qty_kb <> v_qty_ld then 
            disp 
                 xkb_part                label "料号"
                 xkb_site                label "地点"
                 xkb_loc                 label "库位"
                 v_qty_kb                label "看板余量"
                 v_qty_ld                label "实际库存"
                 v_error                 label "差异"
            with frame x .
        end.        
    end.



end. /*  for each xkb_mstr*/

      

end. /* mainloop: */
{mfreset.i}
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}
