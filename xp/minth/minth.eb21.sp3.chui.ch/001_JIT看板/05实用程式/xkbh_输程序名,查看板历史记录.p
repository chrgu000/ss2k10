/* .p                                                    */
/* REVISION: 9.1      LAST MODIFIED: 07/09/03   BY: xp001        */
/*-Revision end---------------------------------------------------------------*/



/* DISPLAY TITLE */
{mfdtitle.i "1.0"}

/* ********** Begin Translatable Strings Definitions ********* */



/* ********** End Translatable Strings Definitions ********* */

define var site like loc_site .
find icc_ctrl where icc_domain = global_domain no-lock no-error.
site = if avail icc_ctrl then icc_site else global_site .



define var v_sn as char format "x(25)"    .
define var eff_date as date initial today .


define  frame a.

/* DISPLAY SELECTION FORM */
form
    SKIP(.2)
           v_sn colon 18 label "源程序名"
           eff_Date colon 18 label "执行日期"
    skip (2)

with frame a  side-labels width 80 attr-space.

/* SET EXTERNAL LABELS  */
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:

    

    if c-application-mode <> 'web' then  
        update v_sn eff_date  with frame a.

	{wbrp06.i &command = update &fields = "v_sn eff_date "  &frm = "a"}
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
        


for each xkbh_hist where xkbh_domain = global_domain  
    and xkbh_prog = v_sn 
    and xkbh_eff_date = eff_Date no-lock
    with frame x no-labels no-box width 200 :

    disp string(xkbh_type + xkbh_part + string(xkbh_kb_id,"999"))  format "x(22)" 
        string(xkbh_time,"hh:mm:ss")
        xkbh_b_stat  format "x(1)"
        xkbh_c_stat  format "x(1)"
        xkbh_ori_qty
        xkbh_kb_rain_qty 
        xkbh_tr_trnbr
    with frame x.
        



end.



end. /* mainloop: */
{mfrtrail.i}  /* REPORT TRAILER  */
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}
