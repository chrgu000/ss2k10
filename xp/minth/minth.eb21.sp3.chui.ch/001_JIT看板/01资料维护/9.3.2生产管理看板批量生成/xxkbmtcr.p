/* xxkbmtcr.p   mfg kb batch create progamm                                 */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=NoConvert                                                  */
/* REVISION: 1.0      LAST MODIFIED: 10/08/07   BY: Softspeed roger xiao    */
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
define var v_buyer    like ptp_buyer   label  "计划员" .
define var v_buyer1   like ptp_buyer .
define var v_buyer2   like ptp_buyer .
define var v_line    like pt_prod_line .
define var v_line1   like pt_prod_line.
define var v_type    like pt_part_type .
define var v_type1   like pt_part_type.
define var v_group   like pt_group .
define var v_group1  like pt_group .
define var v_qty_need     like xmpt_kb_suggest .
define var v_qty_chg      like xmpt_kb_suggest .
define var v_kb_id        like xkb_kb_id . 
define var v_yn      like mfc_logical initial no .
define var v_kb_old  like xmpt_kb_number .
define var trnbr like tr_trnbr.
define var v_total as integer .
define var v_add as integer format "->>9" .

define buffer xkbhhist for xkbh_hist.


define var i as integer .
define var j as integer .




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
    v_qty_need               colon 18   label "需要的看板张数"
    v_yn                     colon 18   label "产生方式(Y/N)" format "Y-按建议的看板张数产生/N-按输入的看板张数产生"
with frame a  side-labels width 80 attr-space.

/* SET EXTERNAL LABELS  */
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
    if part1 = part       then part1 = "".
    if v_buyer1 = v_buyer   then v_buyer1 = "".
    if v_line1 = v_line   then v_line1 = "".
    if v_type1 = v_type   then v_type1 = "".
    if v_group1 = v_group then v_group1 = "".

    if c-application-mode <> 'web' then  
        update site  part part1  v_buyer v_buyer1  v_line v_line1 v_type v_type1 v_group v_group1 v_qty_need v_yn with frame a.

	{wbrp06.i &command = update &fields = "site part part1  v_buyer v_buyer1  v_line v_line1 v_type v_type1 v_group v_group1 v_qty_need v_yn"  &frm = "a"}
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

        find first xmpt_mstr where xmpt_domain = global_domain and ( xmpt_site = site or site = "" ) and ( xmpt_part >= part and (xmpt_part <= part1 or part1 = "") ) no-lock no-error .
        if not avail xmpt_mstr then do:
            /* {pxmsg.i &MSGNUM=???? &ERRORLEVEL=3} */
            message "无生产管理看板基本资料" view-as alert-box .
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
        if v_line1 = "" then v_line1 = v_line.
        if v_type1 = "" then v_type1 = v_type.
        if v_group1 = "" then v_group1 = v_group .
        if v_buyer1 = "" then v_buyer1 = v_buyer.

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
        for each xmpt_mstr where xmpt_domain  = global_domain and xmpt_site = site and ( xmpt_part >= part and ( xmpt_part <= part1 or part1 = "")) exclusive-lock,
            each pt_mstr   where pt_domain = global_domain and ( pt_part = xmpt_part ) 
                           and ( pt_pm_code = "" or pt_pm_code = "m" or pt_pm_code = "l" ) and ( pt_part_type >= v_type and ( pt_part_type <= v_type1 or v_type1 = ""))
                           and ( pt_prod_line  >= v_line and (pt_prod_line <= v_line1 or v_line1 = "" )) and ( pt_group >= v_group and ( pt_group <= v_group1 or v_group1 = "") ) no-lock :
            
            

            v_buyer2 = "" .
            find first ptp_det  where ptp_domain = global_domain and ptp_site = site and ptp_part = xmpt_part no-lock no-error .
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


            if v_yn then assign v_qty_need = xmpt_kb_suggest .
            v_total = 0 .
            v_kb_id = 0 .
            i = 0 .

            for each xkb_mstr where xkb_domain  = global_domain and xkb_site = xmpt_site and xkb_part = xmpt_part 
                              and xkb_type = "M" and ( xkb_kb_id <> 000 and xkb_kb_id <> 999 ) no-lock break by xkb_kb_id :
                v_total = v_total + 1 .
                if xkb_status <> "D" then i = i + 1 .
                if last-of(xkb_kb_id) then assign v_kb_id = xkb_kb_id .
            end.

            xmpt_kb_avail = i .
            xmpt_kb_number = v_total .
            v_kb_old = xmpt_kb_number .


            v_total = i .
            if v_total < v_qty_need then do:
                    
            
                    /*先把无效的看板改为有效*/
                    /*若再不够则需要新产生看板*/
                        for each xkb_mstr where xkb_domain  = global_domain and xkb_site = xmpt_site and xkb_part = xmpt_part  and xkb_type = "M"
                                          and ( xkb_kb_id <> 000 and xkb_kb_id <> 999 ) exclusive-lock break by xkb_kb_id :
                            if  v_total >= v_qty_need then next .
                            if xkb_status = "D" then  do:
                                assign xkb_status = "A" 
                                       xkb_print = no 
                                       v_total = v_total + 1 .
                                
                                {xxkbhist.i &type="xkb_type"      &part="xkb_part"      &site="xkb_site"
                			                &kb_id="xkb_kb_id"    &effdate=today        &program="'xxkbmtcr.p'"
                				            &qty="xkb_kb_qty"     &ori_qty="xkb_kb_qty" &tr_trnbr=0
                				            &b_status="'D'"       &c_status="'A'"
                				            &rain_qty="xkb_kb_raim_qty"}
                            end.
                            
                        end.  /* for each xkb_mstr */     
                        
                        if  v_total < v_qty_need  then do:
                            i  = 0 .               
                            do i = 1 to ( v_qty_need - v_total  ) :
                                v_kb_id = v_kb_id + 1 .
                                create xkb_mstr .
                                assign xkb_domain = global_domain 
                                       xkb_site = site 
                                       xkb_part = xmpt_part
                                       xkb_status = "A"
                                       xkb_type = "M"
                                       xkb_kb_id = v_kb_id 
                                       xkb_kb_qty = xmpt_kb_rolume  
                                       xkb_crt_date = today
                                       xkb_print = no .

                                find first lna_det where lna_domain = global_domain and lna_site = site and lna_part = xmpt_part and lna_allocation = 100 no-lock no-error .
                                xkb_prod_line = if avail lna_det then lna_line else "" .


                            end.
                        end.
                            
    
                    assign xmpt_kb_avail = v_qty_need
                           xmpt_kb_number = max(v_qty_need,v_kb_old) .
            end.   /* if xmpt_kb_avail < v_qty_need */
            else do:
                     
                    /*有多则让序号从大到小的顺序把空的有效的看板进行失效*/
                    v_qty_chg = v_qty_need . 
                    for each xkb_mstr where xkb_domain  = global_domain and xkb_site = xmpt_site and xkb_part = xmpt_part and xkb_status = "A" and xkb_kb_raim_qty = 0 
                                      and ( xkb_kb_id <> 000 and xkb_kb_id <> 999 )  and xkb_type = "M" exclusive-lock by xkb_kb_id desc :
                        if v_qty_chg >= xmpt_kb_avail then next .
                        assign   xkb_status = "D"    v_qty_chg = v_qty_chg + 1.
                        {xxkbhist.i &type="xkb_type"      &part="xkb_part"      &site="xkb_site"
        			                &kb_id="xkb_kb_id"    &effdate=today        &program="'xxkbmtcr.p'"
        				            &qty="xkb_kb_qty"     &ori_qty="xkb_kb_qty" &tr_trnbr=0
        				            &b_status="'A'"       &c_status="'D'"
        				            &rain_qty="xkb_kb_raim_qty"}
                    end.  /* for each xkb_mstr */
   
                    /*还有多,继续失效有存货的看板或最先分发的看板*/
                    if v_qty_chg < xmpt_kb_avail then do:
                        for each xkb_mstr where xkb_domain  = global_domain and xkb_site = xmpt_site and xkb_part = xmpt_part and xkb_status = "A" and xkb_kb_raim_qty <> 0 
                                          and ( xkb_kb_id <> 000 and xkb_kb_id <> 999 )  and xkb_type = "M" exclusive-lock by xkb_kb_id  :
                            if v_qty_chg >= xmpt_kb_avail then next .
                            assign   xkb_status = "D"    v_qty_chg = v_qty_chg + 1.
                            {xxkbhist.i &type="xkb_type"      &part="xkb_part"      &site="xkb_site"
        			                &kb_id="xkb_kb_id"    &effdate=today        &program="'xxkbmtcr.p'"
        				            &qty="xkb_kb_qty"     &ori_qty="xkb_kb_qty" &tr_trnbr=0
        				            &b_status="'A'"       &c_status="'D'"
        				            &rain_qty="xkb_kb_raim_qty"}
                        end.
                    end.  /* if v_qty_chg > xmpt_kb_avail */
    
                    assign xmpt_kb_avail = v_qty_need  .

            end.  /* if xmpt_kb_avail < v_qty_need */

            v_add = if ( xmpt_kb_number - v_kb_old ) > 0 then ( xmpt_kb_number - v_kb_old ) else 0 .

            disp pt_part 
                 pt_desc1 
                 pt_desc2 
                 xmpt_kb_number 
                 xmpt_kb_avail 
                 v_add format "->>9" label "新增看板张数" 
                 with stream-io width 140 .

            {mfrpexit.i}
        end. /*  for each xkb_mstr*/
    end. /* mainloop: */
    {mfrtrail.i}  /* REPORT TRAILER  */
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}
