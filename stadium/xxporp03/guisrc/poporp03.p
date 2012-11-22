/* GUI CONVERTED from poporp03.p (converter v1.75) Sun Aug 13 13:40:35 2000 */
/* poporp03.p - PURCHASE ORDER PRINT AND UPDATE                         */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=FullGUIReport                                 */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                 */
/* REVISION: 1.0    LAST MODIFIED: 08/30/86     BY: PML *15*            */
/* REVISION: 1.0    LAST MODIFIED: 09/02/86     BY: EMB *12*            */
/* REVISION: 2.0    LAST MODIFIED: 12/23/86     BY: PML *A8*            */
/* REVISION: 2.0    LAST MODIFIED: 01/29/87     BY: EMB *A23*           */
/* REVISION: 2.1    LAST MODIFIED: 09/09/87     BY: WUG *A94*           */
/* REVISION: 4.0    LAST MODIFIED: 12/18/87     BY: PML *A113           */
/* REVISION: 4.0    LAST MODIFIED: 02/01/88     BY: FLM *A108           */
/* REVISION: 4.0    LAST MODIFIED: 12/30/87     BY: WUG *A137*          */
/* REVISION: 4.0    LAST MODIFIED: 01/29/88     BY: PML *A119*          */
/* REVISION: 4.0    LAST MODIFIED: 02/22/88     BY: WUG *A177*          */
/* REVISION: 4.0    LAST MODIFIED: 02/29/88     BY: WUG *A175*          */
/* REVISION: 4.0    LAST MODIFIED: 06/14/88     BY: FLM *A268*          */
/* REVISION: 4.0    LAST MODIFIED: 08/24/88     BY: FLM *A406*          */
/* REVISION: 4.0    LAST MODIFIED: 09/08/88     BY: FLM *A430*          */
/* REVISION: 4.0    LAST MODIFIED: 02/09/89     BY: FLM *A641*          */
/* REVISION: 4.0    LAST MODIFIED: 02/22/89     BY: WUG *A657*          */
/* REVISION: 5.0    LAST MODIFIED: 03/14/89     BY: MLB *B056*          */
/* REVISION: 5.0    LAST MODIFIED: 04/07/89     BY: WUG *B094*          */
/* REVISION: 4.0    LAST MODIFIED: 05/05/89     BY: MLB *A730*          */
/* REVISION: 5.0    LAST MODIFIED: 06/08/89     BY: MLB *B130*          */
/* REVISION: 5.0    LAST MODIFIED: 07/25/89     BY: WUG *B198*          */
/* REVISION: 5.0    LAST MODIFIED: 10/27/89     BY: MLB *B324*          */
/* REVISION: 5.0    LAST MODIFIED: 02/13/90     BY: FTB *B565*          */
/* REVISION: 5.0    LAST MODIFIED: 03/13/90     BY: MLB *B586*          */
/* REVISION: 5.0    LAST MODIFIED: 03/28/90     BY: MLB *B615*          */
/* REVISION: 6.0    LAST MODIFIED: 06/14/90     BY: RAM *D030*          */
/* REVISION: 6.0    LAST MODIFIED: 09/18/90     BY: MLB *D055*          */
/* REVISION: 6.0    LAST MODIFIED: 11/12/90     BY: MLB *D200*          */
/* REVISION: 6.0    LAST MODIFIED: 08/14/91     BY: RAM *D828*          */
/* REVISION: 6.0    LAST MODIFIED: 09/26/91     BY: RAM *D881*          */
/* REVISION: 6.0    LAST MODIFIED: 11/05/91     BY: RAM *D913*          */
/* REVISION: 7.3    LAST MODIFIED: 02/22/93     by: jms *G712*(rev only)*/
/* REVISION: 7.4    LAST MODIFIED: 07/20/93     by: bcm *H033*(rev only)*/
/* REVISION: 7.4    LAST MODIFIED: 07/25/94     BY: dpm *FP50*          */
/*                                 09/10/94     BY: bcm *GM03*          */
/* REVISION: 8.5    LAST MODIFIED: 04/26/96     BY: jpm *H0KS*          */
/* REVISION: 8.6    LAST MODIFIED: 11/21/96     BY: *K022* Tejas Modi   */
/* REVISION: 8.6    LAST MODIFIED: 04/03/97     BY: *K09K* Arul Victoria */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan    */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan    */
/* REVISION: 9.1      LAST MODIFIED: 07/28/99   BY: *N01B* John Corda    */
/* REVISION: 9.1      LAST MODIFIED: 03/02/00   BY: *L0SH* Santosh Rao   */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00 BY: *N0KQ* myb              */

         /* DISPLAY TITLE */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

/*H033*/ {mfdtitle.i "b+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE poporp03_p_1 "只打印未结的采购单"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporp03_p_2 "打印票据开往地址"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporp03_p_3 "打印特性与选项"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporp03_p_4 "信息"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporp03_p_5 "包括 BMT 订单"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporp03_p_6 "包括计划采购单"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporp03_p_7 "格式代码"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporp03_p_8 "只打印未打印过的采购单"
/* MaxLen: Comment: */

/*N01B*/ &SCOPED-DEFINE poporp03_p_9 "更新"
/*N01B*/ /* MaxLen: 9 Comment: FACILITATE SIMULATION MODE PRINTING*/

/*L0SH*/
&SCOPED-DEFINE poporp03_p_10 "包括留存税"
/* MaxLen: 33 Comment: Label for l_include_retain */

/* ********** End Translatable Strings Definitions ********* */


         define new shared variable ord_date like po_ord_date.
         define new shared variable ord_date1 like po_ord_date.
         define new shared variable nbr like po_nbr.
         define new shared variable nbr1 like po_nbr.
         define new shared variable vend like po_vend.
         define new shared variable vend1 like po_vend.
         define new shared variable buyer like po_buyer.
         define new shared variable buyer1 like po_buyer.
         define new shared variable msg as character format "X(60)".
         define new shared variable lang like so_lang.
         define new shared variable lang1 like lang.
         define variable form_code as character format "x(2)"
            label {&poporp03_p_7}.
         define variable run_file as character format "X(12)".

/*N01B** define variable yn like mfc_logical initial yes. */
/*N01B*/ define variable update_yn like mfc_logical initial yes
/*N01B*/    label {&poporp03_p_9} no-undo.

         define new shared variable print_bill like mfc_logical initial yes.
         define new shared variable new_only like mfc_logical initial yes.
         define new shared variable open_only like mfc_logical initial yes.
         define new shared variable sort_by_site like poc_sort_by.
/*FP50*/ define new shared variable include_sched like mfc_logical.
/*K022*/ define new shared variable incl_b2b_po like mfc_logical.
/*K022*/ define new shared variable print_options like mfc_logical.
/*L0SH*/ define new shared variable l_include_retain like mfc_logical
/*L0SH*/    initial yes no-undo.

         find first gl_ctrl no-lock.
         find first poc_ctrl no-lock.
         sort_by_site = poc_sort_by.

/*N01B*/ /* FACILITATE UPDATE FLAG AS REPORT INPUT CRITERIA, TO */
/*N01B*/ /* ELIMINATE USER INTERACTION AT THE END OF REPORT     */

         
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
nbr            colon 15
            nbr1           label {t001.i} colon 49
            vend           colon 15
            vend1          label {t001.i} colon 49
            buyer          colon 15
            buyer1         label {t001.i} colon 49
            ord_date       colon 15
            ord_date1      label {t001.i} colon 49 skip
            lang           colon 15
/*K022*     lang1          label {t001.i} colon 49 skip(1)    */

/*N01B*/ /* RE-ARRANGED REPORT INPUT CRITERIA, TO FIT ON SCREEN */

/*N01B** BEGIN DELETE
 * /*K022*/    lang1          label {t001.i} colon 49 skip
 *          open_only      colon 35 label {&poporp03_p_1}
 *          new_only       colon 35 label {&poporp03_p_8}
 * /*FP50*/    include_sched  colon 35 label {&poporp03_p_6}
 *          print_bill     colon 35 label {&poporp03_p_2}
 * /*K022*/    incl_b2b_po    colon 35
 * /*K09K*     label "Include Back to Back Orders" */
 * /*K09K*/    label {&poporp03_p_5}
 * /*K022*/    print_options  colon 35 label {&poporp03_p_3}
 *          sort_by_site   colon 35
 *          form_code      colon 35 deblank skip(1)
 *N01B** END DELETE */

/*N01B*/    lang1          label {t001.i} colon 49 skip(1)
/*N01B*/    open_only      colon 25 label {&poporp03_p_1}
/*N01B*/    print_options  colon 60 label {&poporp03_p_3}
/*N01B*/    new_only       colon 25 label {&poporp03_p_8}

/*L0SH*/ /* RE-ARRANGED REPORT INPUT CRITERIA, TO FIT "INCLUDE RETAINED  */
/*L0SH*/ /* TAXES" ON THE SCREEN                                         */
/*L0SH** BEGIN DELETE **
 * /*N01B*/    sort_by_site   colon 60
 * /*N01B*/    include_sched  colon 25 label {&poporp03_p_6}
 * /*N01B*/    form_code      colon 60 deblank
 * /*N01B*/    print_bill     colon 25 label {&poporp03_p_2}
 * /*N01B*/    update_yn      colon 60
 * /*N01B*/    incl_b2b_po    colon 25 label {&poporp03_p_5} skip(1)
 *L0SH** END DELETE **/

/*L0SH*/    l_include_retain colon 60 label {&poporp03_p_10}
/*L0SH*/    include_sched  colon 25 label {&poporp03_p_6}
/*L0SH*/    sort_by_site   colon 60
/*L0SH*/    print_bill     colon 25 label {&poporp03_p_2}
/*L0SH*/    form_code      colon 60 deblank
/*L0SH*/    incl_b2b_po    colon 25 label {&poporp03_p_5}
/*L0SH*/    update_yn      colon 60 skip(1)

/*GM03*/    space(1)
            msg            label {&poporp03_p_4} skip(1)
          SKIP(.4)  /*GUI*/
with frame a width 80 attr-space side-labels NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = &IF (DEFINED(SELECTION_CRITERIA) = 0)
  &THEN " Selection Criteria "
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



         /* SET EXTERNAL LABELS */
         setFrameLabels(frame a:handle).

         
/*GUI*/ {mfguirpa.i true  "printer" 80 }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:

            if nbr1 = hi_char then nbr1 = "".
            if vend1 = hi_char then vend1 = "".
            if buyer1 = hi_char then buyer1 = "".
            if ord_date = low_date then ord_date = ?.
            if ord_date1 = hi_date then ord_date1 = ?.
            if lang1 = hi_char then lang1 = "".
            if form_code = "" then form_code = "1".
            
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


            if lookup(form_code,"1") = 0 then do:
               {mfmsg.i 129 3}
               /*GUI NEXT-PROMPT removed */
               /*GUI UNDO removed */ RETURN ERROR.
            end.

            bcdparm = "".
            {mfquoter.i nbr    }
            {mfquoter.i nbr1   }
            {mfquoter.i vend   }
            {mfquoter.i vend1  }
            {mfquoter.i buyer  }
            {mfquoter.i buyer1 }
            {mfquoter.i ord_date}
            {mfquoter.i ord_date1}
            {mfquoter.i lang}
            {mfquoter.i lang1}
            {mfquoter.i open_only}
            {mfquoter.i new_only}
/*FP50*/    {mfquoter.i include_sched}
            {mfquoter.i print_bill}
/*K022*/    {mfquoter.i incl_b2b_po}
/*K022*/    {mfquoter.i print_options}
/*L0SH*/    {mfquoter.i l_include_retain}
            {mfquoter.i sort_by_site}
            {mfquoter.i form_code}
/*N01B*/    {mfquoter.i update_yn}
            {mfquoter.i msg    }

            if  nbr1 = "" then nbr1 = hi_char.
            if  vend1 = "" then vend1 = hi_char.
            if  buyer1 = "" then buyer1 = hi_char.
            if  ord_date = ? then ord_date = low_date.
            if  ord_date1 = ? then ord_date1 = hi_date.
            if  lang1 = "" then lang1 = hi_char.

            /* SELECT PRINTER */
            
/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i  "printer" 80}
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:
find first gl_ctrl no-lock.
find first poc_ctrl no-lock.




            
/*GUI mainloop removed */

            do transaction on error undo , leave on endkey undo , leave:

               /* RUN SELECTED FORMAT */
               {gprfile.i}

/*H0KS*/       if false then do:
/*N01B** /*H0KS*/         {gprun.i ""porp0301.p""} */
/*N01B*/          {gprun.i ""porp0301.p"" "(input update_yn)"}
/*H0KS*/       end.

/*N01B**       {gprun.i  """porp03"" + run_file + "".p"""} */
/*N01B*/       {gprun.i  """porp03"" + run_file + "".p""" "(input update_yn)"}

               
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/
{mfreset.i}

/*N01B*/ /* OBSOLETED MESSAGE 306 AND MOVED USER INTERACTION */
/*N01B*/ /* TO REPORT INPUT CRITERIA.                        */

/*N01B** BEGIN DELETE
 *             if not batchrun then do:
 *                yn = yes.
 *                {mfmsg01.i 306 1 yn}
 *                /* Update purchase order print flag? */
 *                if not yn then undo mainloop , leave.
 *             end.
 *N01B** END DELETE */

/*N01B*/       if not update_yn then
/*N01B*/          undo mainloop, leave mainloop.

            end.
         end.

/*GUI*/ end procedure. /*p-report*/
/*GUI*/ {mfguirpb.i &flds=" nbr nbr1 vend vend1 buyer buyer1 ord_date ord_date1 lang lang1   open_only new_only include_sched print_bill  incl_b2b_po print_options  l_include_retain sort_by_site form_code  update_yn msg "} /*Drive the Report*/
