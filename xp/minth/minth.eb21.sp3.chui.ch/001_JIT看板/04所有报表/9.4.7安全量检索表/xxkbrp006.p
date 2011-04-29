/* xxkbrp006.p  安全库存量检索表                                                   */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                               */
/* All rights reserved worldwide.  This is an unpublished work.                      */
/*V8:ConvertMode=NoConvert                                                           */
/* REVISION: 1.0      LAST MODIFIED: 10/08/07   BY: Softspeed roger xiao   /*xp001*/ */
/*-Revision end------------------------------------------------------------          */


/* DISPLAY TITLE */
{mfdtitle.i "1.0"}

/* ********** Begin Translatable Strings Definitions ********* */



/* ********** End Translatable Strings Definitions ********* */

define var part  like xmpt_part .
define var part1 like xmpt_part .
define var loc  like ld_loc .
define var loc1 like ld_loc .
define var desc1 like pt_desc1.
define var desc2 like pt_desc2 .
define var desc3 like loc_Desc label "仓库名称" .
define var um    like pt_um .
define var site  like xmpt_site .
define var v_buyer    like ptp_buyer   label  "计划员" .

define var v_sfty_stk  like ld_qty_oh label "安全库存" .
define var v_qty_oh    like ld_qty_oh label "现有库存".
define var v_qty_err   like ld_qty_oh label "差异数量".
define var v_rmks      as char format "x(30)" label "原因分析            改善措施               担当     期限".


find icc_ctrl where icc_domain = global_domain no-lock no-error.
site = if avail icc_ctrl then icc_site else global_site .
disp site with frame a .   

define  frame a.

/* DISPLAY SELECTION FORM */
form
    SKIP(.2)
    site                      colon 18      
    loc                       colon 18
    loc1                      colon 54   label  {t001.i} 
    part                      colon 18
    part1                     colon 54   label  {t001.i} 
    v_buyer                   colon 18   label  "计划员"
    
    skip(1)

    
with frame a  side-labels width 80 attr-space.

/* SET EXTERNAL LABELS  */
setFrameLabels(frame a:handle).

{wbrp01.i}
repeat:
    if part1 = part       then part1 = "".
    if loc1 = loc         then loc1 = "".
/*     if rel1 = hi_date then rel1 = ? . */
/*     if rel  = low_date then rel = ? . */
    
    if c-application-mode <> 'web' then  
        update site loc loc1 part part1 v_buyer   with frame a.

	{wbrp06.i &command = update &fields = " site loc loc1 part part1  v_buyer  "  &frm = "a"}
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
    

        bcdparm = "".
        {mfquoter.i site     }
        {mfquoter.i v_buyer     }  
        {mfquoter.i loc       }
        {mfquoter.i loc1     }
        {mfquoter.i part     }
        {mfquoter.i part1    }
/*         {mfquoter.i rel      } */
/*         {mfquoter.i rel1     } */

/*         if rel <> low_date and rel1 = ? then rel1 = rel . */
/*         if rel = ?        then rel = low_date .           */
/*         if rel1 = ?       then rel1 = hi_date.            */
        if loc1 = ""      then loc1 = loc .
        if part1 = ""     then part1 = part.


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

/*{mfphead.i}     put skip "test start: " string(time,"hh:mm:ss")skip . */

PUT UNFORMATTED "#def REPORTPATH=$/Minth/xxkbrp006" SKIP.
PUT UNFORMATTED "#def :end" SKIP.


for each ld_det where ld_domain = global_domain and ld_site = site 
                and ld_loc >= loc   and (ld_loc <= loc1 or loc1 = "" )
                and ld_part >= part and (ld_part <= part1 or part1 = "" ) 
                and (can-find(first ptp_det where ptp_domain = global_domain and ptp_site = site 
                              and ptp_part = ld_part and (ptp_buyer = v_buyer  or v_buyer = "") )
                      or
                    ((not can-find(first ptp_det where ptp_domain = global_domain and ptp_site = site 
                                   and ptp_part = ld_part and (ptp_buyer = v_buyer or v_buyer = "" )))
                      and can-find(first pt_mstr where pt_domain = global_domain  and pt_part = ld_part 
                                   and (pt_buyer = v_buyer or v_buyer = "" ))) )
                no-lock break by ld_part by ld_loc  with frame x  with width 300 :


    if first-of(ld_loc) then do:
        v_qty_oh = 0 . 
    end.
    v_qty_oh = v_qty_oh + ld_qty_oh .

    if last-of(ld_loc) then do:
        find first pt_mstr where pt_domain = global_domain and pt_part = ld_part no-lock no-error .
        desc1 = if avail pt_mstr then pt_desc1 else "" .
        desc2 = if avail pt_mstr then pt_desc2 else "" .
        um = if avail pt_mstr then pt_um else "" .
        find first loc_mstr where loc_domain = global_domain and loc_loc = ld_loc no-lock no-error.
        desc3 = if avail loc_mstr then loc_Desc else "" .
    
        v_sfty_stk = 0 .
        find first ptp_det  where ptp_domain = global_domain and ptp_site = site and ptp_part = ld_part no-lock no-error .
        if avail ptp_det then do:
            if ptp_sfty_stk <> 0  then v_sfty_stk  = ptp_sfty_stk  .
            else do:
                find first pt_mstr where pt_domain = global_domain and pt_part = ld_part no-lock no-error .
                if avail pt_mstr then do:
                    if pt_sfty_stk <> 0  then v_sfty_stk  = pt_sfty_stk  .
                end.
            end.
        end.
        else do:
            find first pt_mstr where pt_domain = global_domain and pt_part = ld_part no-lock no-error .
            if avail pt_mstr then do:
                if pt_sfty_stk <> 0  then v_sfty_stk  = pt_sfty_stk  .
            end.
        end.

        v_qty_err = v_qty_oh - v_sfty_stk .

        /* setframelabels(frame x:handle) .                                                              */
        /* disp ld_part desc1 desc2  um ld_loc desc3 v_qty_oh v_sfty_stk v_qty_err v_rmks with frame x . */

        export delimiter ";"
            ld_part 
            desc1 
            desc2  
            um 
            ld_loc 
            desc3 
            v_qty_oh 
            v_sfty_stk 
            v_qty_err
            ""
            ""
            ""
            ""
            .

    end.  /* if last-of(ld_loc) then */
 

      /* {mfrpexit.i} */
end.  /*for each ld_det */


    /* put skip(3) "test end: " string(time,"hh:mm:ss") skip . */
    end. /* mainloop: */
    /* {mfrtrail.i}  REPORT TRAILER  */
    {mfreset.i}
end.  /* REPEAT */
{wbrp04.i &frame-spec = a}
