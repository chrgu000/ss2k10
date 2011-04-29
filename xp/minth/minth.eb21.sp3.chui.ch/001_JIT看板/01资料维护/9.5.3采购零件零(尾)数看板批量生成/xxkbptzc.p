/* xxkbptzc.p    pur zero kb create programm                                */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=NoConvert                                                  */
/* REVISION: 1.0      LAST MODIFIED: 10/08/07   BY: Softspeed roger xiao    */
/*-Revision end------------------------------------------------------------ */



/* DISPLAY TITLE */
{mfdtitle.i "1.0"}

/* ********** Begin Translatable Strings Definitions ********* */



/* ********** End Translatable Strings Definitions ********* */

define var part  like xppt_part .
define var part1 like xppt_part .
define var desc1 like pt_desc1.
define var desc2 like pt_desc2 .
define var site  like xppt_site .
define var v_buyer    like ptp_buyer   label  "计划员" .
define var v_buyer1   like ptp_buyer .
define var v_buyer2   like ptp_buyer .
define var v_line    like pt_prod_line .
define var v_line1   like pt_prod_line.
define var v_type    like pt_part_type .
define var v_type1   like pt_part_type.
define var v_group   like pt_group .
define var v_group1  like pt_group .
define var v_kb_id   like xkb_kb_id .
define var v_new  like mfc_logical initial no. 
define var v_newstat as char format "x(10)"  label "备注" .
define var trnbr like tr_trnbr.

define buffer xkbhhist for xkbh_hist.



find icc_ctrl where icc_domain = global_domain no-lock no-error.
site = if avail icc_ctrl then icc_site else global_site .
disp site with frame a .   



define  frame a.

/* DISPLAY SELECTION FORM */
form
    SKIP(.2)
    site                     colon 18   
    part                     colon 18
    part1                    colon 54   label  {t001.i} 
    v_buyer                   colon 18   label  "计划员"
    v_buyer1                  colon 54   label  {t001.i}
    v_line                   colon 18   label  "产品类"
    v_line1                  colon 54   label  {t001.i} 
    v_type                   colon 18   label  "零件类型"
    v_type1                  colon 54   label  {t001.i} 
    v_group                  colon 18   label  "零件组"
    v_group1                 colon 54   label  {t001.i} 
with frame a  side-labels width 80 attr-space.

/* SET EXTERNAL LABELS  */
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
    if v_buyer1 = v_buyer   then v_buyer1 = "".
    if part1 = part       then part1 = "".
    if v_line1 = v_line   then v_line1 = "".
    if v_type1 = v_type   then v_type1 = "".
    if v_group1 = v_group then v_group1 = "".

    if c-application-mode <> 'web' then  
        update site part part1 v_buyer v_buyer1 v_line v_line1 v_type v_type1 v_group v_group1  with frame a.

	{wbrp06.i &command = update &fields = "site  part part1 v_buyer v_buyer1 v_line v_line1 v_type v_type1 v_group v_group1 "  &frm = "a"}
    if (c-application-mode <> 'web') or (c-application-mode = 'web' and (c-web-request begins 'data')) then do:

        find first xkbc_ctrl where xkbc_domain = global_domain and xkbc_enable = yes and ( xkbc_site = site) no-lock no-error .
        if not avail xkbc_ctrl then do:
            find first xkbc_ctrl where xkbc_domain = global_domain and xkbc_enable = yes and ( xkbc_site = "" ) no-lock no-error .
            if not avail xkbc_ctrl then do:
                /* {pxmsg.i &MSGNUM=???? &ERRORLEVEL=3} */
                message "看板模块没有开启" view-as alert-box .
                leave.
            end.
        end.

        assign v_kb_id = if xkbc_use_seq = yes then 000 else 999 .

        find first xppt_mstr where xppt_domain = global_domain and ( xppt_site = site or site = "" ) and ( xppt_part >= part and ( xppt_part <= part1 or part1 = "") ) no-lock no-error .
        if not avail xppt_mstr then do:
            /* {pxmsg.i &MSGNUM=???? &ERRORLEVEL=3} */
            message "无采购管理看板基本资料" view-as alert-box .
            leave .
        end.
    

        bcdparm = "".
        {mfquoter.i site     }
        {mfquoter.i part     }
        {mfquoter.i part1    }
        {mfquoter.i v_buyer     }
        {mfquoter.i v_buyer1    }
        {mfquoter.i v_line     }
        {mfquoter.i v_line1    }
        {mfquoter.i v_type     }
        {mfquoter.i v_type1    }
        {mfquoter.i v_group  }
        {mfquoter.i v_group1   }

        if part1 = "" then part1 = part.
        if v_buyer1 = "" then v_buyer1 = v_buyer.
        if v_line1 = "" then v_line1 = v_line.
        if v_type1 = "" then v_type1 = v_type.
        if v_group1 = "" then v_group1 = v_group .
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
    
        {mfphead.i}
        for each xppt_mstr where xppt_domain  = global_domain and xppt_site = site and ( xppt_part >= part and (xppt_part <= part1 or part1 = "") ) exclusive-lock,
            each pt_mstr   where pt_domain = global_domain and ( pt_part = xppt_part ) 
                           and ( pt_pm_code = "" or pt_pm_code = "p" ) and ( pt_part_type >= v_type and( pt_part_type <= v_type1 or v_type1 = "" ))
                           and ( pt_prod_line  >= v_line and ( pt_prod_line <= v_line1 or v_line1 = "" )) and ( pt_group >= v_group and ( pt_group <= v_group1 or v_group1 = "")) no-lock :
            
            v_buyer2 = "" .
            find first ptp_det  where ptp_domain = global_domain and ptp_site = site and ptp_part = xppt_part no-lock no-error .
            if avail ptp_det then do:
                if ptp_buyer <> ""  then v_buyer2 = ptp_buyer .
                else do:
                        if pt_buyer <> "" then assign v_buyer2 = pt_buyer .
                end.
            end.
                else do:
                        if pt_buyer <> "" then assign v_buyer2 = pt_buyer .
                    
                end.
            
            if not ( v_buyer2 >= v_buyer and ( v_buyer2 <= v_buyer1 or v_buyer1 = "" )) then next .
                        
            
            v_new = no .
            find first xkb_mstr where xkb_domain = global_domain and xkb_site = xppt_site and xkb_part = xppt_part and xkb_type = "P"
                                and ( xkb_kb_id <> 000 and xkb_kb_id <> 999 ) no-lock no-error .
            if not avail xkb_mstr then next . /*没采购管理看板,则不能产生对应的管理尾数看板*/

            find xkb_mstr where xkb_domain = global_domain and xkb_site = xppt_site and xkb_part = xppt_part and xkb_type = "P" 
                          and ( xkb_kb_id = 000 or xkb_kb_id = 999) exclusive-lock no-error .
            if avail xkb_mstr then do:
                if xkb_status = "D" or (xkb_status = "U" and xkb_kb_Raim_qty = 0 )  then do : 
                    assign xkb_status = "A"   xkb_kb_id  = v_kb_id .
                    {xxkbhist.i &type="xkb_type"      &part="xkb_part"      &site="xkb_site"
                                &kb_id="xkb_kb_id"    &effdate=today        &program="'xxkbptzc.p'"
                                &qty="xkb_kb_qty"     &ori_qty="xkb_kb_raim_qty" &tr_trnbr=0
                                &b_status="xkb_status"       &c_status="'A'"
                                &rain_qty="xkb_kb_raim_qty"}
                end.
                                                 
            end.
            else do: 
                create  xkb_mstr .
                assign  xkb_domain = global_domain 
                        xkb_site = site 
                        xkb_part = xppt_part
                        xkb_vend = xppt_vend
                        xkb_status = "A"
                        xkb_type = "P"
                        xkb_kb_id = v_kb_id 
                        xkb_kb_qty = xppt_kb_rolume  
                        xkb_crt_date = today
                        xkb_print = no 
                        v_new = yes /*new_added*/    .
            end.

            v_newstat = if v_new then "新增" else "已存在" .
            disp pt_part pt_desc1 pt_desc2 v_newstat  with stream-io width 100 .
            
            {mfrpexit.i} 
        end. /*  for each xkb_mstr*/
    end. /* mainloop: */
    {mfrtrail.i}  /* REPORT TRAILER  */
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}
