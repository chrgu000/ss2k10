/* poporp03.p - PURCHASE ORDER PRINT AND UPDATE                         */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.8.1.12 $                                            */
/*V8:ConvertMode=Report                                          */
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
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.8.1.6     BY: Dorota Hohol        DATE: 02/25/03  ECO: *P0N6*  */
/* Revision: 1.8.1.7     BY: Narathip W.         DATE: 05/06/03  ECO: *P0R9*  */
/* Revision: 1.8.1.9     BY: Paul Donnelly (SB)  DATE: 06/28/03  ECO: *Q00J*  */
/* Revision: 1.8.1.10    BY: Orawan S.           DATE: 10/08/03  ECO: *P13T*  */
/* Revision: 1.8.1.11    BY: Shivanand H         DATE: 04/27/04  ECO: *P1Z2*  */
/* $Revision: 1.8.1.12 $ BY: Laxmikant B         DATE: 07/22/04  ECO: *P2BX*  */
/* $Revision: 1.8.1.12 $ BY: Bill Jiang         DATE: 04/11/08  ECO: *SS - 20080411.1*  */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 20080411.1 - B */
{sspoporp0301.i "new"}
/* SS - 20080411.1 - E */

/* DISPLAY TITLE */
{mfdtitle.i "1+ "}
{cxcustom.i "POPORP03.P"}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE poporp03_p_1 "Open PO's Only"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporp03_p_2 "Print Bill-To Address"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporp03_p_3 "Print Features and Options"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporp03_p_4 "Message"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporp03_p_5 "Include EMT Orders"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporp03_p_6 "Include Schedule Orders"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporp03_p_7 "Form Code"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporp03_p_8 "Unprinted PO's Only"
/* MaxLen: Comment: */

&SCOPED-DEFINE poporp03_p_9 "Update"
/* MaxLen: 9 Comment: FACILITATE SIMULATION MODE PRINTING*/

&SCOPED-DEFINE poporp03_p_10 "Include Retained Taxes"
/* MaxLen: 33 Comment: Label for l_include_retain */
{&POPORP03-P-TAG12}

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
{&POPORP03-P-TAG13}
define variable form_code as character format "x(2)"
   label {&poporp03_p_7}.
{&POPORP03-P-TAG14}
define variable run_file as character format "X(12)".

define variable update_yn like mfc_logical initial yes
   label {&poporp03_p_9} no-undo.
define variable l_runok as logical no-undo.

define new shared variable print_bill like mfc_logical initial yes.
define new shared variable new_only like mfc_logical initial NO.
define new shared variable open_only like mfc_logical initial NO.
define new shared variable sort_by_site like poc_sort_by.
define new shared variable include_sched like mfc_logical.
define new shared variable incl_b2b_po like mfc_logical.
define new shared variable print_options like mfc_logical INITIAL NO.
define new shared variable l_include_retain like mfc_logical
   initial yes no-undo.
{&POPORP03-P-TAG1}

/* SS - 20080411.1 - B */
DEFINE BUFFER bad1 FOR ad_mstr.

/* SS - 20080411.1 - E */
DEFINE VARIABLE sComment AS CHARACTER.
DEFINE VARIABLE i AS INTEGER.


find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock.
find first poc_ctrl  where poc_ctrl.poc_domain = global_domain no-lock.
sort_by_site = poc_sort_by.

/* FACILITATE UPDATE FLAG AS REPORT INPUT CRITERIA, TO */
/* ELIMINATE USER INTERACTION AT THE END OF REPORT     */

{&POPORP03-P-TAG15}
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

   /* RE-ARRANGED REPORT INPUT CRITERIA, TO FIT ON SCREEN */

   lang1          label {t001.i} colon 49 skip(1)
   open_only      colon 25 label {&poporp03_p_1}
   print_options  colon 60 label {&poporp03_p_3}
   new_only       colon 25 label {&poporp03_p_8}

   /* RE-ARRANGED REPORT INPUT CRITERIA, TO FIT "INCLUDE RETAINED  */
   /* TAXES" ON THE SCREEN                                         */

   l_include_retain colon 60 label {&poporp03_p_10}
   include_sched  colon 25 label {&poporp03_p_6}
   sort_by_site   colon 60
   print_bill     colon 25 label {&poporp03_p_2}
   form_code      colon 60 deblank
   {&POPORP03-P-TAG2}
   incl_b2b_po    colon 25 label {&poporp03_p_5}
   update_yn      colon 60 skip(1)

   space(1)
   msg            label {&poporp03_p_4} skip(1)
with frame a width 80 attr-space side-labels.
{&POPORP03-P-TAG16}

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{&POPORP03-P-TAG3}

repeat:
   if nbr1 = hi_char then nbr1 = "".
   if vend1 = hi_char then vend1 = "".
   if buyer1 = hi_char then buyer1 = "".
   if ord_date = low_date then ord_date = ?.
   if ord_date1 = hi_date then ord_date1 = ?.
   if lang1 = hi_char then lang1 = "".
   if form_code = "" then form_code = "1".
   {&POPORP03-P-TAG17}
   update nbr nbr1 vend vend1
      buyer buyer1
      ord_date ord_date1
      lang lang1

      open_only new_only include_sched print_bill
      incl_b2b_po print_options
      l_include_retain
      sort_by_site
      form_code
      {&POPORP03-P-TAG4}
      update_yn
      msg with frame a.

   {&POPORP03-P-TAG5}

   if lookup(form_code,"1") = 0 then do:
      {pxmsg.i &MSGNUM=129 &ERRORLEVEL=3}
      next-prompt form_code with frame a.
      undo, retry.
   end.

   {&POPORP03-P-TAG6}

   {&POPORP03-P-TAG18}
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
   {&POPORP03-P-TAG19}
   {mfquoter.i open_only}
   {mfquoter.i new_only}
   {mfquoter.i include_sched}
   {mfquoter.i print_bill}
   {mfquoter.i incl_b2b_po}
   {mfquoter.i print_options}
   {mfquoter.i l_include_retain}
   {mfquoter.i sort_by_site}
   {mfquoter.i form_code}
   {&POPORP03-P-TAG7}
   {mfquoter.i update_yn}
   {mfquoter.i msg    }
   {&POPORP03-P-TAG20}

   if nbr1 = "" then nbr1 = hi_char.
   if vend1 = "" then vend1 = hi_char.
   if buyer1 = "" then buyer1 = hi_char.
   if ord_date = ? then ord_date = low_date.
   if ord_date1 = ? then ord_date1 = hi_date.
   if lang1 = "" then lang1 = hi_char.

   /* OUTPUT DESTINATION SELECTION */
   {&POPORP03-P-TAG8}
   {gpselout.i &printType = "printer"
               &printWidth = 80
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
   {&POPORP03-P-TAG9}

   /* SS - 20080411.1 - B */
   /*
   /* RUN SELECTED FORMAT */
   {gprfile.i}

   {&POPORP03-P-TAG21}
   if false then do:

      {gprun.i ""porp0301.p"" "(input update_yn)"}
   end.

   {&POPORP03-P-TAG10}
   {gprun.i  """porp03"" + run_file + "".p""" "(input update_yn)"}
   {&POPORP03-P-TAG11}
   {&POPORP03-P-TAG22}
   */
   /*
   PUT UNFORMATTED "BEGIN: " + STRING(TIME, "HH:MM:SS") SKIP.
   */
   PUT UNFORMATTED "#def REPORTPATH=$/QAD Addons/BI Report/" + SUBSTRING(execname,1,LENGTH(execname) - 2) SKIP.
   PUT UNFORMATTED "#def :end" SKIP.

   EMPTY TEMP-TABLE ttsspoporp0301.
   EMPTY TEMP-TABLE ttsspoporp03012.

   {gprun.i ""sspoporp0301.p"" "(
      input nbr,
      input nbr1,
      input vend,
      input vend1,
      input buyer,
      input buyer1,
      input ord_date,
      input ord_date1,
      input lang,
      input lang1,
      input open_only,
      input new_only,
      input include_sched,
      input print_bill,
      input incl_b2b_po,
      input print_options,
      input l_include_retain,
      input sort_by_site,
      input form_code,
      input update_yn,
      input msg
      )"}


   FOR EACH ttsspoporp0301
      ,EACH ttsspoporp03012
      WHERE ttsspoporp03012_po_nbr = ttsspoporp0301_po_nbr
   	:
      ASSIGN
         ttsspoporp0301_nontaxable_amt = ttsspoporp03012_nontaxable_amt
         ttsspoporp0301_taxable_amt = ttsspoporp03012_taxable_amt
         ttsspoporp0301_po_curr = ttsspoporp03012_po_curr
         ttsspoporp0301_lines_total = ttsspoporp03012_lines_total
         ttsspoporp0301_tax_date = ttsspoporp03012_tax_date
         ttsspoporp0301_tax_total = ttsspoporp03012_tax_total
         ttsspoporp0301_order_amt = ttsspoporp03012_order_amt
         .
   END.

   EXPORT DELIMITER ";" "billto1" "billto2" "billto3" "billto4" "billto5" "billto6" "po_nbr" "po_rev" "po_ord_date" "po_vend" "poship" "vendor1" "vendor2" "vendor3" "vendor4" "vendor5" "vendor6" "shipto1" "shipto2" "shipto3" "shipto4" "shipto5" "shipto6" "vdattn" "po_confirm" "vend_phone" "po_buyer" "po_contact" "po_cr_terms" "po_shipvia" "terms" "po_fob" "po_rmks" "vatreg" "l_tx_misc1" "l_tx_misc2" "l_tx_misc3" "pod_line" "pod_part" "tax_flag" "pod_due_date" "qty_open" "pod_um" "pod_pur_cost" "ext_cost" "po_so_nbr" "pod_sod_line" "pod_rev" "discdesc" "pod_site" "pod_vpart" "pod_type" "mfgr" "mfgr_part" "desc1" "desc2" "pod_wip_lotser" "c-cn-contract" 
      "nontaxable_amt" "taxable_amt" "po_curr" "lines_total" "tax_date" "tax_total" "order_amt" 
      "ship_phone" "ship_fax" "vend_phone" "vend_fax" "cmmt".
   
   FOR EACH ttsspoporp0301:

       FIND FIRST so_mstr WHERE so_domain = GLOBAL_domain AND so_nbr = ttsspoporp0301_po_nbr  NO-LOCK NO-ERROR.
       IF AVAIL so_mstr THEN DO:
           FIND FIRST ad_mstr WHERE ad_domain = global_domain AND ad_addr = so_cust NO-LOCK NO-ERROR.
           IF AVAIL ad_mstr THEN DO:
              ttsspoporp0301_shipto[6] = ad_name + "," + ad_attn + "," + ad_phone. 
           END.         
       END.
   END.

   FOR EACH ttsspoporp0301
      ,EACH ad_mstr NO-LOCK
      WHERE ad_mstr.ad_domain = GLOBAL_domain
      AND ad_mstr.ad_addr = ttsspoporp0301_poship
      ,EACH bad1 NO-LOCK
      WHERE bad1.ad_domain = GLOBAL_domain
      AND bad1.ad_addr = ttsspoporp0301_po_vend
      :

        FIND FIRST CODE_mstr WHERE CODE_domain = GLOBAL_domain 
            AND CODE_fldname = "pt_buyer"
            AND CODE_value = ttsspoporp0301_po_buyer NO-LOCK NO-ERROR.
        IF AVAIL CODE_mstr THEN DO:
           ttsspoporp0301_po_buyer = code_cmmt.
        END.

        sComment = "".
        FIND FIRST pod_det WHERE pod_domain = GLOBAL_domain AND pod_nbr = ttsspoporp0301_po_nbr AND pod_line = ttsspoporp0301_pod_line NO-LOCK NO-ERROR.
        for each cmt_det
        no-lock
        where cmt_domain = global_domain
            and cmt_indx = pod_cmtindx
        :
            do i = 1 to 15:
                sComment = sComment + trim(cmt_cmmt[i]).
            end.
        end.
      IF sComment <> "" THEN  DO:
          sComment = "หตร๗:" + sComment.
      END.

          

      EXPORT DELIMITER ";" ttsspoporp0301_billto[1] ttsspoporp0301_billto[2] ttsspoporp0301_billto[3] ttsspoporp0301_billto[4] ttsspoporp0301_billto[5] ttsspoporp0301_billto[6] ttsspoporp0301_po_nbr ttsspoporp0301_po_rev ttsspoporp0301_po_ord_date ttsspoporp0301_po_vend ttsspoporp0301_poship ttsspoporp0301_vendor[1] ttsspoporp0301_vendor[2] ttsspoporp0301_vendor[3] ttsspoporp0301_vendor[4] ttsspoporp0301_vendor[5] ttsspoporp0301_vendor[6] ttsspoporp0301_shipto[1] ttsspoporp0301_shipto[2] ttsspoporp0301_shipto[3] ttsspoporp0301_shipto[4] ttsspoporp0301_shipto[5] ttsspoporp0301_shipto[6] ttsspoporp0301_vdattn ttsspoporp0301_po_confirm ttsspoporp0301_vend_phone ttsspoporp0301_po_buyer ttsspoporp0301_po_contact ttsspoporp0301_po_cr_terms ttsspoporp0301_po_shipvia ttsspoporp0301_terms ttsspoporp0301_po_fob ttsspoporp0301_po_rmks ttsspoporp0301_vatreg ttsspoporp0301_l_tx_misc1 ttsspoporp0301_l_tx_misc2 ttsspoporp0301_l_tx_misc3 ttsspoporp0301_pod_line ttsspoporp0301_pod_part ttsspoporp0301_tax_flag ttsspoporp0301_pod_due_date ttsspoporp0301_qty_open ttsspoporp0301_pod_um ttsspoporp0301_pod_pur_cost ttsspoporp0301_ext_cost ttsspoporp0301_po_so_nbr ttsspoporp0301_pod_sod_line ttsspoporp0301_pod_rev ttsspoporp0301_discdesc ttsspoporp0301_pod_site ttsspoporp0301_pod_vpart ttsspoporp0301_pod_type ttsspoporp0301_mfgr ttsspoporp0301_mfgr_part ttsspoporp0301_desc1 ttsspoporp0301_desc2 ttsspoporp0301_pod_wip_lotser ttsspoporp0301_c-cn-contract 
         ttsspoporp0301_nontaxable_amt ttsspoporp0301_taxable_amt ttsspoporp0301_po_curr ttsspoporp0301_lines_total ttsspoporp0301_tax_date ttsspoporp0301_tax_total ttsspoporp0301_order_amt
         ad_mstr.ad_phone ad_mstr.ad_fax 
         bad1.ad_phone bad1.ad_fax sComment
         .
   END.

   /*
   PUT UNFORMATTED "END: " + STRING(TIME, "HH:MM:SS") SKIP.
   */
   /* SS - 20080411.1 - E */

   {mfreset.i}

   if batchrun
   then
      l_runok = runok.

   /* OBSOLETED MESSAGE 306 AND MOVED USER INTERACTION */
   /* TO REPORT INPUT CRITERIA.                        */

   if batchrun
   then
      runok = l_runok.

end.
