/* GUI CONVERTED from woworp.p (converter v1.71) Tue Oct  6 14:59:05 1998 */
/* woworp.p - WORK ORDER REPORT                                         */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* web convert woworp.p (converter v1.00) Fri Oct 10 13:58:11 1997 */
/* web tag in woworp.p (converter v1.00) Mon Oct 06 14:18:54 1997 */
/*F0PN*/ /*K0WH*/ /*V8#ConvertMode=WebReport                            */
/*V8:ConvertMode=Report                                        */
/* REVISION: 1.0     LAST MODIFIED: 04/15/86    BY: pml                 */
/* REVISION: 1.0     LAST MODIFIED: 05/01/86    BY: emb                 */
/* REVISION: 2.1     LAST MODIFIED: 10/19/87    BY: wug *A94*           */
/* REVISION: 2.1     LAST MODIFIED: 12/29/87    BY: emb                 */
/* REVISION: 4.0     LAST MODIFIED: 02/16/88    BY: flm *A175*          */
/* REVISION: 4.0     LAST MODIFIED: 03/23/88    BY: rl  *A171*          */
/* REVISION: 5.0     LAST MODIFIED: 04/10/89    BY: mlb *B096*          */
/* REVISION: 5.0     LAST MODIFIED: 10/26/89    BY: emb *B357*          */
/* REVISION: 5.0     LAST MODIFIED: 01/24/90    BY: ftb *B531*          */
/* REVISION: 5.0     LAST MODIFIED: 02/13/91    BY: emb *B893*          */
/* REVISION: 6.0     LAST MODIFIED: 01/22/91    BY: bjb *D248*          */
/* REVISION: 7.3     LAST MODIFIED: 11/19/92    BY: jcd *G348*          */
/* REVISION: 7.3     LAST MODIFIED: 04/23/93    BY: ram *GA24*          */
/* REVISION: 7.3     LAST MODIFIED: 09/23/94    BY: cpp *FQ88*          */
/* REVISION: 7.5     LAST MODIFIED: 10/07/94    BY: TAF *J035*          */
/* REVISION: 8.6     LAST MODIFIED: 10/13/97    by: ays *K0WH*          */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
     /* DISPLAY TITLE */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

/*GA24*/ {mfdtitle.i "e+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE woworp_p_1 "订单日期!发放日期"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp_p_2 "加工单!批处理"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp_p_3 "短缺量"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */


     define variable vend like wo_vend.
     define variable nbr like wo_nbr.
     define variable nbr1 like wo_nbr.
     define variable lot like wo_lot.
     define variable lot1 like wo_lot.
     define variable part like wo_part.
     define variable part1 like wo_part.
/*J035*/ define variable wobatch like wo_batch.
/*J035*/ define variable wobatch1 like wo_batch.
     define variable rel like wo_rel_date.
     define variable rel1 like wo_rel_date.
     define variable due like wo_due_date.
     define variable due1 like wo_due_date.
     define variable so_job like wo_so_job.
     define variable so_job1 like wo_so_job.
     define variable qty_open like wo_qty_ord label {&woworp_p_3}.
     define variable stat like wo_status.
     define variable buyer like pt_buyer.

     
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
        
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
        nbr         colon 15
        nbr1        label {t001.i} colon 49 skip
        lot         colon 15
        lot1        label {t001.i} colon 49 skip
        part        colon 15
        part1       label {t001.i} colon 49 skip
/*J035*/    wobatch     colon 15
/*J035*/    wobatch1    label {t001.i} colon 49 skip
        rel         colon 15
        rel1        label {t001.i} colon 49 skip
        due         colon 15
        due1        label {t001.i} colon 49 skip
        so_job      colon 15
        so_job1     label {t001.i} colon 49 skip (1)        
        vend        colon 15 skip
        buyer        colon 15 skip

        stat        colon 15 skip
     with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME




/*K0WH*/ {wbrp01.i}
repeat on error undo, retry:

        if nbr1 = hi_char then nbr1 = "".
        if nbr1 = hi_char  then nbr1 ="".
        if part1 = hi_char then part1 = "".
/*J035*/    if wobatch1 = hi_char then wobatch1 = "".
/*J035*/    if due = low_date then due = ?.
/*J035*/    if due1 = hi_date then due1 = ?.
/*J035*/    if rel = low_date then rel = ?.
/*J035*/    if rel1 = hi_date then rel1 = ?.


/*K0WH*/     if c-application-mode <> 'web':u then
            update
           nbr      nbr1
           lot     lot1
           part     part1
/*J035*/       wobatch  wobatch1
           rel      rel1
           due      due1
           so_job   so_job1           
           vend
           buyer
           stat
        with frame a.

/*K0WH*/ {wbrp06.i &command = update &fields = "  nbr nbr1 lot lot1 part part1  wobatch
         wobatch1 rel rel1 due due1 so_job so_job1 vend buyer stat" &frm = "a"}

/*K0WH*/ if (c-application-mode <> 'web':u) or
/*K0WH*/ (c-application-mode = 'web':u and
/*K0WH*/ (c-web-request begins 'data':u)) then do:


        bcdparm = "".
        {mfquoter.i nbr     }
        {mfquoter.i nbr1    }
        {mfquoter.i part    }
        {mfquoter.i part1   }
/*J035*/    {mfquoter.i wobatch }
/*J035*/    {mfquoter.i wobatch1}
        {mfquoter.i rel     }
        {mfquoter.i rel1    }
        {mfquoter.i due     }
        {mfquoter.i due1    }
        {mfquoter.i so_job  }
        {mfquoter.i so_job1 }
        {mfquoter.i lot     }
        {mfquoter.i lot1    }
        {mfquoter.i vend    }
         {mfquoter.i buyer   }

        {mfquoter.i stat    }
       
        if nbr1 = "" then nbr1 = hi_char.
        if lot1 ="" then lot1 = hi_char.
        if part1 = "" then part1 = hi_char.
/*J035*/    if wobatch1 = "" then wobatch1 = hi_char.
/*J035*/    if due = ? then due = low_date.
/*J035*/    if due1 = ? then due1 = hi_date.
/*J035*/    if rel = ? then rel = low_date.
/*J035*/    if rel1 = ? then rel1 = hi_date.

/*GA24      if index("FEARCB",stat) = 0 and stat <> "" */
/*GA24*/    if index("PFEARCB",stat) = 0 and stat <> ""
        then do with frame a:
           {mfmsg.i 19 3}

/*K0WH*/     if c-application-mode = 'web':u then return.
            else next-prompt stat.
           undo, retry.
        end.


/*K0WH*/ end.
        /* SELECT PRINTER */
            {mfselbpr.i "printer" 132}
/*GUI*/ RECT-FRAME:HEIGHT-PIXELS in frame a = FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.

        {mfphead.i}

        /* FIND AND DISPLAY */
        for each wo_mstr where (wo_nbr >= nbr and wo_nbr <= nbr1)
        and (wo_lot >= lot and wo_lot <=lot1)
        and (wo_part >= part and wo_part <= part1)
/*J035*/    and (wo_batch >= wobatch and wo_batch <= wobatch1)
        and (wo_vend = vend or vend = "")
/*J035*     and (wo_due_date >= due or due = ?)                        */
/*J035*     and (wo_due_date <= due1 or due1 = ?)                      */
/*J035*     and (wo_rel_date >= rel or rel = ?)                        */
/*J035*     and (wo_rel_date <= rel1 or rel1 = ?)                      */
/*J035*/    and (wo_due_date >= due and wo_due_date <= due1)
/*J035*/    and (wo_rel_date >= rel and wo_rel_date <= rel1)
        and (wo_so_job >= so_job) and (wo_so_job <= so_job1 or so_job1 = "")
/*GA24      and (wo_status <> "P") */
        and (wo_status = stat or stat = "")
        no-lock by wo_nbr with width 160 no-attr-space:

/*GA24                          {mfrpchk.i}                     /*G348*/ */
 if buyer <> "" then do :
           find pt_mstr where pt_part = wo_part and pt_buyer = buyer no-lock no-error.
           end.
           else do :
           find pt_mstr where pt_part = wo_part  no-lock no-error.
           end.


/*GA24*/       find ptp_det no-lock
/*GA24*/       where ptp_part = wo_part
/*GA24*/       and ptp_site = wo_site no-error.

/*FQ88******BEGIN REMOVED CODE ***********************************************
 *             if wo_status = "P"
 *             and ((available ptp_det and ptp_pm_code <> "M")
 *             or (not available ptp_det
 *             and available pt_mstr and pt_pm_code <> "M"))
 *             then next.
 *FQ88******END REMOVED CODE */

/*FQ88* PLANNED ORDERS (WO_STATUS = P) PRINT ONLY PM_CODE = M OR SPACE */
/*FQ88*/       if wo_status = "P"
/*FQ88*/       and ((available ptp_det and
/*FQ88*/             ptp_pm_code <> "M" and ptp_pm_code <> "")
/*FQ88*/          or (not available ptp_det and available pt_mstr and
/*FQ88*/             pt_pm_code <> "M" and pt_pm_code <> ""))
/*FQ88*/       then next.


           qty_open = max(wo_qty_ord - wo_qty_comp - wo_qty_rjct,0).

           if wo_status = "C" then qty_open = 0.

           if page-size - line-counter < 3 then page.
 if available(pt_mstr) then 
           display
/*J035*       wo_nbr                                        */
/*J035*/      wo_nbr column-label {&woworp_p_2}
          wo_lot
          wo_part     format "x(24)"
          wo_qty_ord
          wo_qty_comp
          wo_qty_rjct
          qty_open
          wo_ord_date column-label {&woworp_p_1}
          wo_due_date
          wo_so_job
          wo_vend
          wo_status 
          pt_buyer
          WITH STREAM-IO /*GUI*/ .
if available pt_mstr then do :
           down 1.
/*J035*/    display wo_batch @ wo_nbr  WITH STREAM-IO /*GUI*/ .
           if available pt_mstr and pt_desc1 <> ""
           then display pt_desc1 @ wo_part WITH STREAM-IO /*GUI*/ .

             display wo_rel_date @ wo_ord_date WITH STREAM-IO /*GUI*/ .

           if available pt_mstr and pt_desc2 <> "" and pt_desc1 <> ""
           then down 1.

           if available pt_mstr and pt_desc2 <> ""
           then display pt_desc2 @ wo_part WITH STREAM-IO /*GUI*/ .
end.
/*GA24*/       
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/


        end.

        {mfrtrail.i}

     end.

/*K0WH*/ {wbrp04.i &frame-spec = a}
