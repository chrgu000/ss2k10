/* .p                                                    */
/* REVISION: 9.1      LAST MODIFIED: 07/09/03   BY: xp001        */
/*-Revision end---------------------------------------------------------------*/



/* DISPLAY TITLE */
{mfdtitle.i "1.0"}

/* ********** Begin Translatable Strings Definitions ********* */



/* ********** End Translatable Strings Definitions ********* */


define var site  like xmpt_site .
find icc_ctrl where icc_domain = global_domain no-lock no-error.
site = if avail icc_ctrl then icc_site else global_site .



define var v_sn as char format "x(25)"    .

define var line as char label "产线".








define  frame a.

/* DISPLAY SELECTION FORM */
form
    SKIP(.2)
           v_sn colon 18 label "看板条码"
           line colon 18 label "产线"
    skip (2)

with frame a  side-labels width 80 attr-space.

/* SET EXTERNAL LABELS  */
/* setFrameLabels(frame a:handle). */

{wbrp01.i}
repeat:

    

    if c-application-mode <> 'web' then  
        update v_sn line  with frame a.

	{wbrp06.i &command = update &fields = "v_sn line "  &frm = "a"}
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
        


for each xkb_mstr where xkb_domain = global_domain and xkb_type + xkb_part + string(xkb_kb_id,"999") = v_sn no-lock with frame x width 300 :
     setFrameLabels(frame x:handle).

    for first xkbl_det where xkbl_domain = global_domain and xkbl_site = xkb_site 
    and xkbl_line  = line  and xkbl_part = xkb_part and xkbl_par = xkb_par exclusive-lock :
    end.
    if not avail xkbl_det then do :
    
        create xkbl_det .
        assign
        xkbl_domain = global_domain 
        xkbl_site = xkb_site 
        xkbl_line  = line
        xkbl_part = xkb_part
        xkbl_par = xkb_par
        xkbl_req_num = 3 
        .

        disp xkbl_det with frame x.
    end.
    else do : 
        xkbl_req_num = 3 .
        disp xkbl_Det with frame x.
    end.

end.





end. /* mainloop: */
{mfrtrail.i}  /* REPORT TRAILER  */
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}
