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
           v_sn colon 18 label "领料看板条码"
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
        


for each xkb_mstr where xkb_domain = global_domain and xkb_type = "L" no-lock 
    break by xkb_part with frame x width 300 :
        
   if first-of(xkb_part) then do:
        find first ro_det where ro_domain = global_domain and  ro_routing = xkb_par and ro_start <= today and (ro_end >= today or ro_end = ? ) no-lock no-error.
        if not avail ro_det then do:
                   line = "" .
                   op = 10 .
        end.  /*if not avail ro_det */
        else do:  /*if  avail ro_det */
            line = ro_wkctr .
            op  = ro_op .
        end.


        find first xkbl_det where xkbl_domain = global_domain 
                             and xkbl_site  = xkb_site 
                            and xkbl_line = line 
                            and xkbl_part = xkb_part 
                            and xkbl_par  = xkb_par exclusive-lock no-error .
        if not avail xkbl_det then do:
            create xkbl_det .
            assign xkbl_domain = global_domain 
                    xkbl_site  = xkb_site 
                    xkbl_line = line 
                    xkbl_part = xkb_part 
                    xkbl_par  = xkb_par 
                    xkbl_usrid = "AutoCreate"
                    .
        end.

        xkbl_req_num = 10 .
        xkbl_mod_date = today .

        




         disp  xkb_part xkb_par line 

         with frame x .       



   end.



end.


end. /* mainloop: */
{mfrtrail.i}  /* REPORT TRAILER  */
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}
