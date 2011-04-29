/* xxkbptsm.p   pur kb status change                                        */
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

define var i as integer .
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
/*     site1                    colon 54   label  {t001.i} */
    part                     colon 18
    part1                    colon 54   label  {t001.i} 
    v_line                   colon 18   label  "产品类"
    v_line1                  colon 54   label  {t001.i} 
    v_type                   colon 18   label  "零件类型"
    v_type1                  colon 54   label  {t001.i} 
    v_group                  colon 18   label  "零件组"
    v_group1                 colon 54   label  {t001.i} 
    id_from                  colon 18   label  "看板ID"
    id_to                    colon 54   label  {t001.i}     
    v_stat_from              colon 18   label  "旧状态"
    v_stat_to                colon 54   label  "新状态"
with frame a  side-labels width 80 attr-space.

/* SET EXTERNAL LABELS  */
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
    if part1 = part       then part1 = "".
    if v_line1 = v_line   then v_line1 = "".
    if v_type1 = v_type   then v_type1 = "".
    if v_group1 = v_group then v_group1 = "".

    if c-application-mode <> 'web' then  
        update site part part1 v_line v_line1 v_type v_type1 v_group v_group1  id_from id_to v_stat_from v_stat_to with frame a.

	{wbrp06.i &command = update &fields = "site  part part1 v_line v_line1 v_type v_type1 v_group v_group1  id_from id_to  v_stat_from v_stat_to "  &frm = "a"}
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
        

        find first xppt_mstr where xppt_domain = global_domain and ( xppt_site = site or site = "" ) 
             and ( xppt_part >= part and (xppt_part <= part1 or part1 = "" )) no-lock no-error .
        if not avail xppt_mstr then do:
            /* {pxmsg.i &MSGNUM=???? &ERRORLEVEL=3} */
            message "无采购管理看板基本资料" view-as alert-box .
            leave .
        end.
    

        bcdparm = "".
        {mfquoter.i site     }
        {mfquoter.i part     }
        {mfquoter.i part1    }
        {mfquoter.i v_line     }
        {mfquoter.i v_line1    }
        {mfquoter.i v_type     }
        {mfquoter.i v_type1    }
        {mfquoter.i v_group  }
        {mfquoter.i v_group1   }
        {mfquoter.i id_from  }
        {mfquoter.i id_to    }

        if part1 = "" then part1 = part.
        if v_line1 = "" then v_line1 = v_line.
        if v_type1 = "" then v_type1 = v_type.
        if v_group1 = "" then v_group1 = v_group .
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

        
        for each xppt_mstr where xppt_domain  = global_domain and xppt_site = site and ( xppt_part >= part and (xppt_part <= part1 or part1 = "" )) exclusive-lock,
            each pt_mstr   where pt_domain = global_domain and ( pt_part = xppt_part ) 
                           and ( pt_pm_code = "" or pt_pm_code = "p" ) and ( pt_part_type >= v_type and (pt_part_type <= v_type1 or v_type1 = ""))
                           and ( pt_prod_line  >= v_line and (pt_prod_line <= v_line1 or v_line1 = "" )) and ( pt_group >= v_group and (pt_group <= v_group1 or v_group1 = "" )) no-lock :
            i = 0 .
            find first xkb_mstr where xkb_domain = global_domain and xkb_site = xppt_site and xkb_part = xppt_part and xkb_type = "P" 
                and xkb_status = v_stat_from  and ( xkb_kb_id >= id_from and xkb_kb_id <= id_to ) exclusive-lock no-error .
            if not avail xkb_mstr then next . 
            else do:
                repeat:
                    assign xkb_status =  caps(v_stat_to)  .
                    if ( xkb_kb_id <> 000 and xkb_kb_id <> 999 ) then i = i + 1 .
                    if ( xkb_kb_id <> 000 and xkb_kb_id <> 999 ) then do:
                        if v_stat_to <>  "D" then assign xppt_kb_avail = xppt_kb_avail + 1 .
                        if v_stat_to = "D"   then assign xppt_kb_avail = max(xppt_kb_avail - 1,0) .
                    end.
                    {xxkbhist.i &type="xkb_type"      &part="xkb_part"      &site="xkb_site"
                                &kb_id="xkb_kb_id"    &effdate=today        &program="'xxkbmtsm.p'"
                                &qty="xkb_kb_qty"     &ori_qty="xkb_kb_raim_qty" &tr_trnbr=0
                                &b_status="v_stat_from"       &c_status="v_stat_to"
                                &rain_qty="xkb_kb_raim_qty"}
                    find first xkb_mstr where xkb_domain = global_domain and xkb_site = xppt_site and xkb_part = xppt_part and xkb_type = "P" 
                         and xkb_status = v_stat_from  and ( xkb_kb_id >= id_from and xkb_kb_id <= id_to ) exclusive-lock no-error .
                    if not avail xkb_mstr then  leave .
                end.
            end.


            disp pt_part pt_desc1 pt_desc2 xppt_kb_number xppt_kb_avail  i label "状态变更张数"  with  stream-io width 130 .
            
            {mfrpexit.i} 
        end. /*  for each xkb_mstr*/
    end. /* mainloop: */
    {mfrtrail.i}  /* REPORT TRAILER  */
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}
