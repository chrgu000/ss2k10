/* xxkbplsm.p    L kb status change                                         */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=NoConvert                                                  */
/* REVISION: 1.0      LAST MODIFIED: 10/08/07   BY: Softspeed roger xiao    */
/*-Revision end------------------------------------------------------------ */



/* DISPLAY TITLE */
{mfdtitle.i "1.0"}

/* ********** Begin Translatable Strings Definitions ********* */



/* ********** End Translatable Strings Definitions ********* */

define var part  like xmpt_part .
define var part1 like xmpt_part .
define var par   like xkb_par .
define var par1  like xkb_par .
define var desc1 like pt_desc1.
define var desc2 like pt_desc2 .
define var desc3 like pt_desc1 .
define var desc4 like pt_desc2 .
define var site  like xmpt_site .
define var v_stat_from like xkb_status .
define var v_stat_to   like xkb_status .
define var id_from     like xkb_kb_id .
define var id_to       like xkb_kb_id .


define var i as  integer .
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
    par                      colon 18   label  "父件编号"
    par1                     colon 54   label  {t001.i} 
    part                     colon 18   label  "子件编号"
    part1                    colon 54   label  {t001.i}   
    id_from                  colon 18   label  "看板ID"
    id_to                    colon 54   label  {t001.i}
    v_stat_from              colon 18   label  "旧状态"
    v_stat_to                colon 54   label  "新状态"
with frame a  side-labels width 80 attr-space.

/* SET EXTERNAL LABELS  */
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
    if par1 = par        then par1 = "".
    if part1 = part       then part1 = "".

    if c-application-mode <> 'web' then  
        update site par par1 part part1  id_from id_to v_stat_from v_stat_to  with frame a.

	{wbrp06.i &command = update &fields = " site par par1 part part1  id_from id_to v_stat_from v_stat_to  "  &frm = "a"}
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
        

        find first xmpt_mstr where xmpt_domain = global_domain and ( xmpt_site = site or site = "" ) 
             and (( xmpt_part >= part and ( xmpt_part <= part1 or part1 = "" ) ) or ( xmpt_part >= par and (xmpt_part <= par1 or par1 = ""))) no-lock no-error .
        if not avail xmpt_mstr then do:
            /* {pxmsg.i &MSGNUM=???? &ERRORLEVEL=3} */
            message "无生产管理看板基本资料" view-as alert-box .
            leave .
        end.
    

        bcdparm = "".
        {mfquoter.i site     }
        {mfquoter.i par     }
        {mfquoter.i par1    }
        {mfquoter.i part     }
        {mfquoter.i part1    }
        {mfquoter.i v_stat_from    }
        {mfquoter.i v_stat_to      }
        {mfquoter.i id_from  }
        {mfquoter.i id_to    }

        if par1 = "" then par1 = par.
        if part1 = "" then part1 = part.
         if id_to = 0 then id_to = 999 .
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

        if v_stat_from = "U" or v_stat_to = "U" then do:
            message "使用状态(U)不能参与状态转换." view-as alert-box .
            undo mainloop ,retry mainloop .
        end.
        if v_stat_from = "A" and v_stat_to = "R" then do:
            message "状态转换(A to R)请使用看板刷读下达程式." view-as alert-box .
            undo mainloop ,retry mainloop .
        end.
        if v_stat_from = "D" and v_stat_to <> "A" then do:
            message "状态D只能转换为状态A." view-as alert-box .
            undo mainloop ,retry mainloop .
        end.

        
        for each xkb_mstr where xkb_domain = global_domain and xkb_site = site and xkb_type = "L" and xkb_status = v_stat_from 
                          and ( xkb_kb_id >= id_from and xkb_kb_id <= id_to ) 
                          and (( xkb_part >= part and ( xkb_part <= part1 or part1 = "" )) 
                          and ( xkb_par >= par and (xkb_par <= par1 or par1 = ""))) exclusive-lock :
            assign xkb_status = caps(v_stat_to)   i = i + 1 .
            {xxkbhist.i &type="xkb_type"      &part="xkb_part"      &site="xkb_site"
                            &kb_id="xkb_kb_id"    &effdate=today        &program="'xxkbplsm.p'"
                            &qty="xkb_kb_qty"     &ori_qty="xkb_kb_Raim_qty" &tr_trnbr=0
                            &b_status="v_stat_from"       &c_status="v_stat_to"
                            &rain_qty="xkb_kb_raim_qty"}
                            
            find pt_mstr where pt_domain = global_domain and pt_part = xkb_part no-lock no-error .
            desc1 = if avail pt_mstr then pt_desc1 else "" .
            desc2 = if avail pt_mstr then pt_desc2 else "" .
            find pt_mstr where pt_domain = global_domain and pt_part = xkb_par no-lock no-error .
            desc3 = if avail pt_mstr then pt_desc1 else "" .
            desc4 = if avail pt_mstr then pt_desc2 else "" .

            disp xkb_par desc3 desc4 xkb_part desc1 desc2  i label "状态变更张数"  with stream-io width 100 .
            
            {mfrpexit.i} 
        end. /*  for each xkb_mstr*/
    end. /* mainloop: */
    {mfrtrail.i}  /* REPORT TRAILER  */
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}
