/* xxwoworp04.p - WORK ORDER DISPATCH LIST                                */
/* GUI CONVERTED from woworp04.p (converter v1.71) Tue Oct  6 14:59:08 1998 */
/* woworp04.p - WORK ORDER DISPATCH LIST                                */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* web convert woworp04.p (converter v1.00) Fri Oct 10 13:57:24 1997 */
/* web tag in woworp04.p (converter v1.00) Mon Oct 06 14:17:53 1997 */
/*F0PN*/ /*K0Y1*/ /*V8#ConvertMode=WebReport                            */
/*V8:ConvertMode=FullGUIReport                                 */
/* REVISION: 1.0     LAST MODIFIED: 05/01/86    BY: emb                 */
/* REVISION: 2.1     LAST MODIFIED: 09/11/87    BY: wug *A94*           */
/* REVISION: 4.0     LAST MODIFIED: 01/05/88    BY: emb *A124*          */
/* REVISION: 4.0     LAST MODIFIED: 02/07/88    BY: rl  *A171*          */
/* REVISION: 4.0     LAST MODIFIED: 02/10/88    BY: wug *A175*          */
/* REVISION: 4.0     LAST MODIFIED: 03/21/88    BY: wug *A194*          */
/* REVISION: 4.0     LAST MODIFIED: 12/09/88    BY: pml *A557*          */
/* REVISION: 4.0     LAST MODIFIED: 02/18/89    BY: pml *B004*          */
/* REVISION: 4.0     LAST MODIFIED: 06/28/89    BY: emb *A754*          */
/* REVISION: 6.0     LAST MODIFIED: 10/29/90    BY: wug *D151*          */
/* REVISION: 6.0     LAST MODIFIED: 01/22/91    BY: bjb *D248*          */
/* REVISION: 7.0     LAST MODIFIED: 10/11/91    BY: emb *F024*          */
/* REVISION: 7.3     LAST MODIFIED: 11/19/92    BY: jcd *G348*          */
/* REVISION: 7.3     LAST MODIFIED: 04/14/93    BY: ram *G952*          */
/* REVISION: 7.3     LAST MODIFIED: 07/28/94    BY: qzl *FP65*          */
/* REVISION: 7.3     LAST MODIFIED: 09/01/94    BY: ljm *FQ67*          */
/* REVISION: 8.6     LAST MODIFIED: 10/14/97    BY: ays *K0Y1*          */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 9.0      LAST MODIFIED: 10/24/2000   BY: *JY000* Frankie Xu*/

     /* DISPLAY TITLE */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

/*G952*/ {mfdtitle.i "e+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE woworp04_p_1 "按工作中心分页"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp04_p_2 "工序"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp04_p_3 "  标志: "
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp04_p_4 "短缺量"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp04_p_5 "调度天数"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */


/*jy000*/     define variable nbr   like wo_nbr.
/*jy000*/     define variable nbr1  like wo_nbr.
     
     define variable site  like si_site.
     define variable site1 like si_site.
     define variable wkctr like wr_wkctr.
     define variable wkctr1 like wr_wkctr.
     define variable open_ref like wo_qty_ord label {&woworp04_p_4}.
     define variable setup like wr_setup.
     define variable runtime like wr_run.
     define variable op_status like wr_status format "X(8)".
     define variable skpage like mfc_logical initial yes
        label {&woworp04_p_1}.
/*FQ67*  define variable window as integer label "Window Days" initial 3. */
/*FQ67*/ define variable wndw as integer label {&woworp04_p_5} initial 3.
     define variable cutoff as date.
     define variable i as integer.
     define variable nonwdays as integer.
     define variable overlap as integer.
     define variable workdays as integer.
     define variable interval as integer.
     define variable know_date as date.
     define variable find_date as date.
/*FQ67*  define variable forward as integer. */
/*FQ67*/ define variable frwrd as integer.
     define variable last_wkctr like wr_wkctr.
     define variable last_mch like wr_mch.
     define variable op as character format "x(24)" label {&woworp04_p_2}.

     
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
        
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
        nbr            colon 30
        nbr1           label {t001.i} colon 51
        site           colon 30
        site1          label {t001.i} colon 49
        wkctr          colon 30
        wkctr1         label {t001.i} colon 49 skip (1)
/*FQ67*     window         colon 30 */
/*FQ67*/    wndw         colon 30
        skpage         colon 30 skip
      SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = &IF (DEFINED(SELECTION_CRITERIA) = 0)
  &THEN " 选择条件 "
  &ELSE {&SELECTION_CRITERIA}
  &ENDIF .
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



     FORM /*GUI*/ 
        wr_wkctr
        wr_mch
        wc_desc        no-label
/*K0Y1*  with frame b side-labels page-top. */
/*K0Y1*/ with STREAM-IO /*GUI*/  frame b side-labels page-top WIDTH 132.

     site = global_site.
     site1 = global_site.


/*K0Y1*/ {wbrp01.i}
        
/*GUI*/ {mfguirpa.i true  "printer" 132 }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:


        if wkctr1 = hi_char then wkctr1 = "".
        if site1 = hi_char then site1 = "".


/*K0Y1*/ if c-application-mode <> 'web':u then
        
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


/*K0Y1*/ {wbrp06.i &command = update &fields = "  site site1   wkctr wkctr1 wndw
        skpage" &frm = "a"}

/*K0Y1*/ if (c-application-mode <> 'web':u) or
/*K0Y1*/ (c-application-mode = 'web':u and
/*K0Y1*/ (c-web-request begins 'data':u)) then do:


        bcdparm = "".
/*Jy000*/        {mfquoter.i nbr   }
/*jy000*/        {mfquoter.i nbr1  }
        {mfquoter.i site   }
        {mfquoter.i site1  }
        {mfquoter.i wkctr  }
        {mfquoter.i wkctr1 }
/*FQ67*     {mfquoter.i window } */
/*FQ67*/    {mfquoter.i wndw }
        {mfquoter.i skpage }

        if wkctr1 = "" then wkctr1 = hi_char.
        if site1  = "" then site1  = hi_char.
/*jy000*/ if nbr1 = "" then nbr1 = hi_char.


/*K0Y1*/ end.

        /* SELECT PRINTER  */
            
/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i  "printer" 132}
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:



        {mfphead.i} 

        last_wkctr = ?.

        for each si_mstr no-lock where si_site >= site and si_site <= site1
        with width 132 no-attr-space:

           
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/
                      /*G348*/

           cutoff = ?.
           know_date = today.
/*FQ67*    {mfdate.i know_date cutoff window si_site} */
/*FQ67*/   {mfdate.i know_date cutoff wndw si_site}

           /* FIND AND DISPLAY */
           for each wr_route where (wr_wkctr >= wkctr)
           and (wr_wkctr <= wkctr1)
           and (index ("qhsr",wr_status) > 0
           or  (wr_start <= cutoff and wr_status <> "C"))
/*jy000*/  and ( wr_nbr >= nbr and wr_nbr <= nbr1 )            
           no-lock by wr_wkctr by wr_mch by wr_start by wr_due by wr_nbr
           by wr_lot by wr_op with width 132 no-attr-space:

          
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/
                   /*G348*/

          find wc_mstr where wc_wkctr = wr_wkctr
          and wc_mch = wr_mch
          no-lock no-error.
          if not available wc_mstr then next.

          find wo_mstr where wo_lot = wr_lot no-lock no-error.
          if available wo_mstr then do:
             if wo_status <> "R" then next.
             if wo_site <> si_site then next.

             if wr_wkctr <> last_wkctr or wr_mch <> last_mch then do:
            hide frame b.
            if last_wkctr <> ? and skpage then page.
            display wr_wkctr wr_mch wc_desc si_site with frame b STREAM-IO /*GUI*/ .
            last_wkctr = wr_wkctr.
            last_mch = wr_mch.
             end.
             else do:
            view frame b.
             end.

/*FP65*              open_ref = max(wr_qty_ord - wr_qty_comp - wr_qty_rjct,0).*/
/*FP65*/             open_ref = max(wr_qty_ord - (wr_qty_comp + wr_sub_com)
/*FP65*/                - wr_qty_rjct,0).

             setup = 0.
/*G952               if index("qhr",wr_status) > 0 and wr_act_run = 0 then */
/*G952*/             if wr_status <> "c"
/*G952*/             and open_ref <> 0
/*G952*/             and wr_act_run = 0 then
            setup = wr_setup.
             runtime = open_ref * wr_run.

             find pt_mstr where pt_part = wo_part no-lock no-error.
             if available pt_mstr  and pt_desc2 <> ""
             and page-size - line-counter < 3 then page.
             else if page-size - line-counter < 2 then page.

             display wo_part format "X(27)" wr_nbr string(wr_op) @ op
             wr_start wr_due
             setup runtime open_ref wr_status WITH STREAM-IO /*GUI*/ .

             down 1.
             display  "   " + pt_desc1  @ wo_part
             {&woworp04_p_3} + wr_lot @ wr_nbr
             wr_desc @ op WITH STREAM-IO /*GUI*/ .
             if available pt_mstr and pt_desc2 <> "" then do:
            down 1.
            display "   " + pt_desc2  @ wo_part WITH STREAM-IO /*GUI*/ .
             end.
          end.
           end.
        end.

        hide frame b.
        
/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

     end.

/*K0Y1*/ {wbrp04.i &frame-spec = a}

/*GUI*/ end procedure. /*p-report*/
/*GUI*/ {mfguirpb.i &flds=" nbr nbr1 site site1 wkctr wkctr1 wndw skpage "} /*Drive the Report*/
