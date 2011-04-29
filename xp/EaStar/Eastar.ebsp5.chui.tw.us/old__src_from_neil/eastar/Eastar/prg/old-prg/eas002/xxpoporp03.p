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
/* REVISION: 9.1      LAST MODIFIED: 01/16/03 BY: *EAS002A* Apple Tam     */

         /* DISPLAY TITLE */
/*H033*/ {mfdtitle.i "b+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE poporp03_p_1 "只列印未結的PO"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporp03_p_2 "列印付款地址"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporp03_p_3 "列印功能特性與配件組合"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporp03_p_4 "訊息"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporp03_p_5 "包含 EMT 訂單"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporp03_p_6 "Include Schedule Orders"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporp03_p_7 "表格代碼"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporp03_p_8 "僅限未列印的採購單"
/* MaxLen: Comment: */

/*N01B*/ &SCOPED-DEFINE poporp03_p_9 "更新"
/*N01B*/ /* MaxLen: 9 Comment: FACILITATE SIMULATION MODE PRINTING*/

/*L0SH*/
&SCOPED-DEFINE poporp03_p_10 "包括保留稅 "
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
/*eas002a         define new shared variable sort_by_site like poc_sort_by.*/
/*EAS002A*/  define new shared variable sort_by_site as logical format "Line/Site"
            initial true no-undo.
/*FP50*/ define new shared variable include_sched like mfc_logical.
/*K022*/ define new shared variable incl_b2b_po like mfc_logical.
/*K022*/ define new shared variable print_options like mfc_logical.
/*L0SH*/ define new shared variable l_include_retain like mfc_logical
/*L0SH*/    initial yes no-undo.
/*EAS002A*/ define new shared variable print_header like mfc_logical initial yes.
/*EAS002A*/ define variable yn like mfc_logical initial no.
/*EAS002A*/  define new shared variable print_header2 as logical format "T/C"
            initial true no-undo.

         find first gl_ctrl no-lock.
         find first poc_ctrl no-lock.
/*eas001a         sort_by_site = poc_sort_by.*/

/*N01B*/ /* FACILITATE UPDATE FLAG AS REPORT INPUT CRITERIA, TO */
/*N01B*/ /* ELIMINATE USER INTERACTION AT THE END OF REPORT     */

         form
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
/*L0SH*/    update_yn      colon 60 /*EAS002A* skip(1)*/
/*EAS002A*/ print_header   colon 25 label "列印標題"
/*eas002a*/ print_header2  colon 28 label "列印東星(T)/依時得(C) 標題"

/*GM03*/    space(1)
            msg            label {&poporp03_p_4} skip(1)
         with frame a width 80 attr-space side-labels.

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame a:handle).

         repeat:
            if nbr1 = hi_char then nbr1 = "".
            if vend1 = hi_char then vend1 = "".
            if buyer1 = hi_char then buyer1 = "".
            if ord_date = low_date then ord_date = ?.
            if ord_date1 = hi_date then ord_date1 = ?.
            if lang1 = hi_char then lang1 = "".
            if form_code = "" then form_code = "1".
            update nbr nbr1 vend vend1
            buyer buyer1
            ord_date ord_date1
            lang lang1
/*FP50*     open_only new_only print_bill */
/*FP50*/    open_only new_only include_sched print_bill
/*K022*/    incl_b2b_po print_options
/*L0SH*/    l_include_retain
            sort_by_site
            form_code
/*N01B*/    update_yn
/*EAS002A*/ print_header
/*EAS002A*/ print_header2
            msg with frame a.

            if lookup(form_code,"1") = 0 then do:
               {mfmsg.i 129 3}
               next-prompt form_code with frame a.
               undo, retry.
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
/*EAS002A*/ {mfquoter.i print_header}
/*EAS002A*/ {mfquoter.i print_header2}
            {mfquoter.i msg    }

            if nbr1 = "" then nbr1 = hi_char.
            if vend1 = "" then vend1 = hi_char.
            if buyer1 = "" then buyer1 = hi_char.
            if ord_date = ? then ord_date = low_date.
            if ord_date1 = ? then ord_date1 = hi_date.
            if lang1 = "" then lang1 = hi_char.

            /* SELECT PRINTER */
            {mfselbpr.i "printer" 80}

            mainloop:
            do transaction on error undo , leave on endkey undo , leave:

               /* RUN SELECTED FORMAT */
               {gprfile.i}

/*H0KS*/       if false then do:
/*N01B** /*H0KS*/         {gprun.i ""porp0301.p""} */
/*N01B*/          {gprun.i ""porp0301.p"" "(input update_yn)"}
/*H0KS*/       end.

/*N01B**       {gprun.i  """porp03"" + run_file + "".p"""} */
/*EAS002A /*N01B*/       {gprun.i  """porp03"" + run_file + "".p""" "(input update_yn)"}*/
/*EAS002A*/       {gprun.i  """xxporp03"" + run_file + "".p""" "(input update_yn)"}

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
/*EAS002A** BEGIN add*/
              if not batchrun then do:
                 yn = no.
                 message "PO Has Been Printed?" update yn.
                 /* Update purchase order print flag? */
                 if not yn then undo mainloop , leave.
              end.
 /*EAS002A** END add */
/*EAS002A*** delete***********
/*N01B*/       if not update_yn then
/*N01B*/          undo mainloop, leave mainloop.
*EAS002A*** delete***********/


            end.
         end.
