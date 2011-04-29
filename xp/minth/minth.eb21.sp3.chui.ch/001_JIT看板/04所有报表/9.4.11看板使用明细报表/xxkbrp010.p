/* xxkbrp010.p  看板使用明显报表                                                     */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                               */
/* All rights reserved worldwide.  This is an unpublished work.                      */
/*V8:ConvertMode=NoConvert                                                           */
/* REVISION: 1.0      LAST MODIFIED: 10/08/07   BY: Softspeed roger xiao   /*xp001*/ */
/*-Revision end------------------------------------------------------------          */


/* DISPLAY TITLE */
{mfdtitle.i "1.0"}

/* ********** Begin Translatable Strings Definitions ********* */



/* ********** End Translatable Strings Definitions ********* */
define var site  like xmpt_site .
define var v_buyer like pt_buyer  label "计划员".
define var v_buyer1 like pt_buyer .
define var v_buyer2 like pt_buyer .
define var part  like xmpt_part .
define var part1 like xmpt_part .
define var desc1 like pt_desc1.
define var desc2 like pt_desc2 .
define var v_type     like xkb_type .  v_type = "P" .
define var v_status   like xkb_status .
define var v_yn        as logical .
define var i as integer .

define buffer xkbmstr for xkb_mstr .

find icc_ctrl where icc_domain = global_domain no-lock no-error.
site = if avail icc_ctrl then icc_site else global_site .
disp site with frame a .   

define  frame a.

/* DISPLAY SELECTION FORM */
form
    SKIP(.2)
    site                     colon 18 
    v_type                   colon 18   label  "看板类型"
    v_status                 colon 18   label  "看板状态"

    skip(1) 
    
    part                     colon 18
    part1                    colon 54   label  {t001.i} 
    v_buyer                  colon 18   label "计划员"
    v_buyer1                 colon 54   label {t001.i}


    
   
with frame a  side-labels width 80 attr-space.

/* SET EXTERNAL LABELS  */
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
    if part1 = part       then part1 = "".
    if v_buyer1 = v_buyer   then v_buyer1 = "".


    if c-application-mode <> 'web' then  
        update site v_type v_status part part1 v_buyer v_buyer1 with frame a.

	{wbrp06.i &command = update &fields = " site v_type v_status part part1 v_buyer v_buyer1 "  &frm = "a"}
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
            

/*         find first xmpt_mstr where xmpt_domain = global_domain and ( xmpt_site = site or site = "" ) */
/*              and ( xmpt_part >= part and ( xmpt_part <= part1 or part1 = "" )) no-lock no-error .    */
/*         if not avail xmpt_mstr then do:                                                              */
/*             /* {pxmsg.i &MSGNUM=???? &ERRORLEVEL=3} */                                               */
/*             message "无生产管理看板基本资料" view-as alert-box .                                     */
/*             leave .                                                                                  */
/*         end.                                                                                         */
    

        bcdparm = "".
        {mfquoter.i site       }
        {mfquoter.i v_buyer    }
        {mfquoter.i v_buyer1   }
        {mfquoter.i part       }
        {mfquoter.i part1      }
        {mfquoter.i v_type     }
        {mfquoter.i v_status    }

        if part1 = "" then part1 = part.
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


for each xkb_mstr where xkb_domain = global_domain 
    and xkb_site = site 
    and  xkb_type = v_type 
    and  xkb_part >= part and (xkb_part <= part1 or part1 = "" )
    and (xkb_status = v_status or v_status = "" )
    no-lock break by xkb_type by xkb_part by xkb_kb_id  with frame x with width 600 :

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
    

    if first-of (xkb_part) then do:
        assign i = 0 .   
    end.
    i =  i + 1 .

    if last-of(xkb_part) then do:
        find pt_mstr where pt_domain = global_domain and pt_part = xkb_part no-lock no-error .
        desc1 = if avail pt_mstr then pt_desc1   else "".
        desc2 = if avail pt_mstr then pt_desc2   else "".

            for each xkbmstr where xkbmstr.xkb_domain = global_domain 
                             and xkbmstr.xkb_type = xkb_mstr.xkb_type 
                             and xkbmstr.xkb_part = xkb_mstr.xkb_part 
                            /* and xkbmstr.xkb_status = xkb_mstr.xkb_status */
                no-lock break by xkbmstr.xkb_part by xkbmstr.xkb_kb_id with frame xxx with width 600  :


                disp xkbmstr.xkb_type column-label "类型" when first-of( xkbmstr.xkb_part)
                     v_buyer2         column-label "计划员" when first-of( xkbmstr.xkb_part)
                     xkbmstr.xkb_part column-label "料号" when first-of( xkbmstr.xkb_part)
                     desc1            column-label "说明1" when first-of( xkbmstr.xkb_part)
                     desc2            column-label "说明2" when first-of( xkbmstr.xkb_part)
                     i                column-label "张数" when first-of( xkbmstr.xkb_part)
                     xkbmstr.xkb_kb_id         column-label "序号"
                     xkbmstr.xkb_status        column-label "状态"
                     xkbmstr.xkb_kb_qty        column-label "看板容量"
                     xkbmstr.xkb_kb_raim_qty   column-label "看板余量"
                     xkbmstr.xkb_crt_date      column-label "产生日期" 
                     xkbmstr.xkb_upt_date      column-label "最近使用" 
                     with frame xxx  .

            end. /* for each xkbmstr */

    end.  /*if last-of(xkb_part) */

{mfrpexit.i} 
end. /*  for each xkb_mstr*/



end. /* mainloop: */
{mfrtrail.i}  /* REPORT TRAILER  */
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}
