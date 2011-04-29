/* .p                                                    */
/* REVISION: 9.1      LAST MODIFIED: 07/09/03   BY: xp001        */
/*-Revision end---------------------------------------------------------------*/



/* DISPLAY TITLE */
{mfdtitle.i "1.0"}

/* ********** Begin Translatable Strings Definitions ********* */



/* ********** End Translatable Strings Definitions ********* */

define var part  like xmpt_part .
define var part1 like xmpt_part .
define var desc1 like pt_desc1.
define var desc2 like pt_desc2 .

define var site  like xmpt_site .
define var v_line    like pt_prod_line .
define var v_line1   like pt_prod_line.
define var v_type    like pt_part_type .
define var v_type1   like pt_part_type.
define var v_group   like pt_group .
define var v_group1  like pt_group .
define var v_stat_from like xkb_status .
define var v_stat_to   like xkb_status .
define var id_from     like xkb_kb_id .
define var id_to       like xkb_kb_id .
define var v_yn        as logical .

define var i as integer .

define var trnbr like tr_trnbr.
define buffer xkbhhist for xkbh_hist.

define buffer xkbmstr for xkb_mstr .

find icc_ctrl where icc_domain = global_domain no-lock no-error.
site = if avail icc_ctrl then icc_site else global_site .



define var v_sn as char format "x(25)"    .
define var v_comb1       as logical .
define var v_comb2       as logical .
define variable cumwo_lot            as character .
define var v_Start as  date .
define var v_wostat as char format "x(1)".
define var v_qty_oh like ld_qty_oh .
define var v_qty_tr like ld_qty_oh label "trqty" .
define var line as char .
define var op like ro_op .


define  frame a.

/* DISPLAY SELECTION FORM */
form
    SKIP(.2)
           v_sn colon 18 label "看板条码"
    skip (2)

with frame a  side-labels width 80 attr-space.

/* SET EXTERNAL LABELS  */
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:

    

    if c-application-mode <> 'web' then  
        update v_sn  with frame a.

	{wbrp06.i &command = update &fields = "v_sn "  &frm = "a"}
    if (c-application-mode <> 'web') or (c-application-mode = 'web' and (c-web-request begins 'data')) then do:

        find first xkbc_ctrl where xkbc_domain = global_domain and xkbc_enable = yes and ( xkbc_site = site) no-lock no-error .
        if not avail xkbc_ctrl then do:
            find first xkbc_ctrl where xkbc_domain = global_domain and xkbc_enable = yes and ( xkbc_site = "" ) no-lock no-error .
            if not avail xkbc_ctrl then do:
                /* {pxmsg.i &MSGNUM=???? &ERRORLEVEL=3} */
                message "看板模块没有开启" view-as alert-box .
                leave .
            end.
        end.
           



	end.  /* if c-application-mode <> 'web' */

    /* PRINTER SELECTION */
    /* OUTPUT DESTINATION SELECTION */
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
        


/* for each xkb_mstr where xkb_domain = global_domain and xkb_type + xkb_part + string(xkb_kb_id,"999") = v_sn no-lock with frame x width 300 : */
/*  disp xkb_part xkb_qty  xkb_stat xkb_kab_raim_qty xkb_upt_date xkb_par with fram x .                                                         */
/*                                                                                                                                              */
/* end.                                                                                                                                         */


for each xkb_mstr where xkb_domain = global_domain and v_sn begins string(xkb_type + xkb_part) no-lock with frame x width 300 :
 setFrameLabels(frame x:handle).
 disp xkb_type xkb_part xkb_kb_id xkb_kb_qty  xkb_stat xkb_kb_raim_qty xkb_loc xkb_lot xkb_ref xkb_par with fram x .

end.



end. /* mainloop: */
{mfrtrail.i}  /* REPORT TRAILER  */
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}
