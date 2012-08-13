/* GUI CONVERTED from porcrp.p (converter v1.75) Thu Aug 17 13:39:32 2000 */
/* porcrp.p - RECEIVER PRINT AND UPDATE                                 */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*H0J4*/ /*F0PN*/ /*V8:ConvertMode=Report                               */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                 */
/* REVISION: 4.0     LAST MODIFIED: 03/24/88    BY: FLM *A108**/
/* REVISION: 4.0     LAST MODIFIED: 02/29/88    BY: WUG *A175**/
/* REVISION: 4.0     LAST MODIFIED: 07/19/88    BY: FLM *A332**/
/* REVISION: 4.0     LAST MODIFIED: 09/13/88    BY: FLM *A436**/
/* REVISION: 4.0     LAST MODIFIED: 11/01/88    BY: FLM *A511**/
/* REVISION: 4.0     LAST MODIFIED: 01/11/89    BY: EMB *A596**/
/* REVISION: 4.0     LAST MODIFIED: 01/18/89    BY: PML *B017**/
/* REVISION: 5.0     LAST MODIFIED: 03/15/89    BY: MLB *B056**/
/* REVISION: 4.0     LAST MODIFIED: 03/15/89    BY: MLB *A671**/
/* REVISION: 4.0     LAST MODIFIED: 01/16/90    BY: WUG *A801**/
/* REVISION: 4.0     LAST MODIFIED: 05/15/90    BY: WUG *D002**/
/* REVISION: 6.0     LAST MODIFIED: 06/12/90    BY: RAM *D030**/
/* REVISION: 6.0     LAST MODIFIED: 07/03/90    BY: WUG *D043**/
/* REVISION: 5.0     LAST MODIFIED: 07/24/90    BY: WUG *B740**/
/* REVISION: 6.0     LAST MODIFIED: 06/19/91    BY: RAM *D716**/
/* REVISION: 7.0     LAST MODIFIED: 09/10/91    BY: MLV *F006**/
/* REVISION: 6.0     LAST MODIFIED: 11/13/91    BY: WUG *D887**/
/* REVISION: 6.0     LAST MODIFIED: 01/06/92    BY: RAM *D978**/
/* REVISION: 7.0     LAST MODIFIED: 03/24/92    BY: MLV *F279**/
/* REVISION: 7.0     LAST MODIFIED: 04/13/92    BY: RAM *F385**/
/* REVISION: 7.3     LAST MODIFIED: 09/17/92    BY: pma *G068**/
/* REVISION: 7.3     LAST MODIFIED: 02/12/93    BY: tjs *G677**/
/* REVISION: 7.3     LAST MODIFIED: 02/22/93    BY: tjs *G718**/
/* REVISION: 7.3     LAST MODIFIED: 05/28/93    BY: kgs *GB61**/
/* REVISION: 7.4     LAST MODIFIED: 07/22/93    BY: bcm *H035**/
/* REVISION: 7.4     LAST MODIFIED: 08/26/93    BY: tjs *H090**/
/* REVISION: 7.4     LAST MODIFIED: 02/10/94    BY: dpm *FM02**/
/* REVISION: 7.4     LAST MODIFIED: 09/29/94    BY: bcm *H543**/
/* REVISION: 7.2     LAST MODIFIED: 11/12/94    BY: ais *FT65**/
/* REVISION: 7.3     LAST MODIFIED: 10/18/94    BY: jzs *GN91**/
/* REVISION: 7.4     LAST MODIFIED: 11/18/94    BY: bcm *GO37**/
/* REVISION: 7.4     LAST MODIFIED: 03/21/95    BY: aed *G0HT**/
/* REVISION: 8.5     LAST MODIFIED: 10/12/95    BY: taf *J053**/
/* REVISION: 8.5     LAST MODIFIED: 01/17/96    BY: rxm *H0J4**/
/* REVISION: 8.5     LAST MODIFIED: 02/14/96    BY: rxm *H0JJ**/
/* REVISION: 8.5     LAST MODIFIED: 03/07/96    BY: *J0CV* Robert Wachowicz*/
/* REVISION: 8.5     LAST MODIFIED: 05/27/96    BY: *J0NX* M. Deleeuw **/
/* REVISION: 8.5     LAST MODIFIED: 07/18/96    BY: taf *J0ZS**/
/* REVISION: 8.5     LAST MODIFIED: 10/17/96    BY: *J15T* Aruna Patil */
/* REVISION: 8.5     LAST MODIFIED: 04/10/97    BY: *H0Q6* Ajit Deodhar */
/* REVISION: 8.5     LAST MODIFIED: 12/23/97    BY: *H1H7* Niranjan R.  */
/* REVISION: 8.6E    LAST MODIFIED: 02/23/98    BY: *L007* A. Rahane */
/* REVISION: 8.6E    LAST MODIFIED: 05/20/98    BY: *K1Q4* Alfred Tan      */
/* REVISION: 8.6E    LAST MODIFIED: 06/16/98    BY: *L020* Charles Yen   */
/* REVISION: 9.0     LAST MODIFIED: 02/06/99    BY: *M06R* Doug Norton     */
/* REVISION: 9.0     LAST MODIFIED: 03/13/99    BY: *M0BD* Alfred Tan      */
/* REVISION: 9.1     LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1     LAST MODIFIED: 07/31/00 BY: *N0GV* Mudit Mehta        */
/***********************************************************************/


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

         {mfdtitle.i "b+ "}

/*L020*/ define variable mc-error-number like msg_nbr no-undo.

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE porcrp_p_6 "只打印未打印过的收货单"
/* MaxLen: Comment: */

&SCOPED-DEFINE porcrp_p_8 "打印收货尾栏"
/* MaxLen: Comment: */

&SCOPED-DEFINE porcrp_p_9 "列出全部说明"
/* MaxLen: Comment: */

&SCOPED-DEFINE porcrp_p_11 "打印加工单短缺量"
/* MaxLen: Comment: */

&SCOPED-DEFINE porcrp_p_12 "打印核准的收货单"
/* MaxLen: Comment: */


/*N0GV*------------START COMMENT----------------
 * &SCOPED-DEFINE porcrp_p_1 "Ship Date:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE porcrp_p_2 "Receipt Date:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE porcrp_p_3 "R E C E I V E R"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE porcrp_p_4 "Receiver:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE porcrp_p_5 "Remarks:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE porcrp_p_7 "Supplier:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE porcrp_p_10 "Page:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE porcrp_p_13 "Packing Slip:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE porcrp_p_14 "Print Date:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE porcrp_p_15 "PO Revision:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE porcrp_p_16 "Purchase Order:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE porcrp_p_17 "*** Cont ***"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE porcrp_p_18 "*DUPLICATE*"
 * /* MaxLen: Comment: */
 *N0GV*----------END COMMENT----------------- */

/* ********** End Translatable Strings Definitions ********* */

         define new shared variable convertmode as character no-undo.
         define new shared variable rndmthd like rnd_rnd_mthd.
         define new shared variable oldcurr like po_curr.
         /* CORRECT INITIAL TAX TYPE TO INDICATE RECEIPT (21) NOT RETURN (25)*/
         define new shared variable tax_tr_type     like tx2d_tr_type no-undo
                                                    initial '21'.
         define variable nbr like prh_nbr.
         define variable nbr1 like prh_nbr.
         define variable vend like prh_vend.
         define variable vend1 like prh_vend.
         define variable rcvr like prh_receiver.
         define variable rcvr1 like prh_receiver.
         define variable rcv_date like prh_rcp_date.
         define variable rcv_date1 like prh_rcp_date.
         define variable new_only like mfc_logical initial yes.
         define variable revision like po_rev.
         define variable buyer like po_buyer.
         define variable tranqty like tr_qty_chg.
         define variable pdate like prh_rcp_date.
         define variable pages as integer.
         define variable old_receiver like prh_receiver.
         define variable location like pt_loc.
         define variable det_lines as integer.
         define variable vendor as character format "x(38)" extent 6.
         define variable vend_phone like ad_phone.
         define variable duplicate as character format "x(11)" label "".
         define variable newline like mfc_logical initial yes.
         define variable continue_yn like mfc_logical initial no.
         define new shared variable prh_recno as recid.

         define variable printwo like mfc_logical initial yes.
         define variable rmks like po_rmks.
         define new shared variable printcmts like mfc_logical initial no.
         define variable i as integer.
         define variable cont_lbl as character format "x(12)"
/*N0GV*            initial {&porcrp_p_17} */ .
         define new shared variable tr_count as integer.
         define new shared variable print_approval like mfc_logical initial yes
            label {&porcrp_p_12}.
         define new shared variable print_trlr like mfc_logical initial no
        label {&porcrp_p_8}.
         /* MOVED TO POTRLDEF.I */
         define new shared variable maint like mfc_logical initial false
                                            no-undo.
         define new shared variable po_recno as recid. /* USED FOR RCVR NBR */
         define new shared variable receivernbr like prh_receiver.
         define new shared variable eff_date like glt_effdate.
         define buffer prhhist for prh_hist.
         define new shared variable fiscal_id      like prh_receiver.
         define new shared variable fiscal_rec     as logical init false.
/*H0JJ
 * /*FT65*/ define variable loc_qty like ld_qty_all.
 * /*FT65*/ define variable avail_qty like ld_qty_all. */
         define variable oldsession as character no-undo.
         define variable l_prh_recno as recid no-undo.

         define variable err-flag as integer no-undo.
         define variable old_db like si_db no-undo.

/*N0GV*/ assign cont_lbl = "*** " + getTermLabel("CONTINUE",4) + " ***".
         find first gl_ctrl no-lock no-error.

            {pocurvar.i "NEW"}
            {txcurvar.i "NEW"}
            /* DEFINE TRAILER VARS AS NEW, SO THAT CORRECT _OLD FORMATS */
            /* CAN BE ASSIGNED BASED ON INITIAL DEFINE                  */
            {potrldef.i "NEW"}
            assign
                    nontax_old         = nontaxable_amt:format
                    taxable_old        = taxable_amt:format
                    lines_tot_old      = lines_total:format
                    tax_tot_old        = tax_total:format
                    order_amt_old      = order_amt:format
                    line_tax_old       = line_tax:format
                    line_tot_old       = line_total:format
                    tax_old            = tax_2:format
                    tax_amt_old        = tax_amt:format
                    ord_amt_old        = ord_amt:format
                    vtord_amt_old      = vtord_amt:format
                    line_pst_old       = line_pst:format
                    prepaid_old        = po_prepaid:format
                    frt_old            = po_frt:format
                    spec_chg_old       = po_spec_chg:format
                    serv_chg_old       = po_serv_chg:format.

         
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
nbr            colon 15
            nbr1           label {t001.i} colon 49
            rcvr           colon 15
            rcvr1          label {t001.i} colon 49
            vend           colon 15
            vend1          label {t001.i} colon 49
            rcv_date       colon 15
            rcv_date1      label {t001.i} colon 49
            skip(1)
            new_only       colon 30 label {&porcrp_p_6}
            printcmts      colon 30 label {&porcrp_p_9}
            print_approval colon 30
            printwo        colon 30 label {&porcrp_p_11}
            print_trlr     colon 30
         with frame a attr-space side-labels width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



         /* SET EXTERNAL LABELS */
         setFrameLabels(frame a:handle).

         convertmode = "REPORT".

         view frame a.
         find first poc_ctrl no-lock no-error.
         if available poc_ctrl and poc_rcv_typ = 0 then do:
            continue_yn = no.
            bell.
            {mfmsg01.i 353 2 continue_yn}
            if continue_yn = no then leave.
         end.

         assign
            rcv_date   = today
            rcv_date1  = today
            oldcurr    = ""
            oldsession = SESSION:numeric-format.

         repeat:
            if nbr1 = hi_char then nbr1 = "".
            if rcvr1 = hi_char then rcvr1 = "".
            if vend1 = hi_char then vend1 = "".
            if rcv_date = low_date then rcv_date = ?.
            if rcv_date1 = hi_date then rcv_date1 = ?.

            update
            nbr nbr1 rcvr rcvr1 vend vend1 rcv_date rcv_date1 new_only
            printcmts print_approval printwo
            print_trlr when ({txnew.i})
            with frame a.

            bcdparm = "".
            {mfquoter.i nbr}
            {mfquoter.i nbr1}
            {mfquoter.i rcvr}
            {mfquoter.i rcvr1}
            {mfquoter.i vend}
            {mfquoter.i vend1}
            {mfquoter.i rcv_date}
            {mfquoter.i rcv_date1}
            {mfquoter.i new_only}
            {mfquoter.i printcmts}
            {mfquoter.i print_approval}
            {mfquoter.i printwo}
            {mfquoter.i print_trlr}

            if nbr1 = "" then nbr1 = hi_char.
            if rcvr1 = "" then rcvr1 = hi_char.
            if vend1 = "" then vend1 = hi_char.
            if rcv_date = ? then rcv_date = low_date.
            if rcv_date1 = ? then rcv_date1 = hi_date.

            /* SELECT PRINTER */
            {mfselbpr.i "printer" 80}
/*GUI*/ RECT-FRAME:HEIGHT-PIXELS in frame a = FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.


            assign
               pages = 0
               pdate = today
               old_receiver = ?.

            for each prh_hist no-lock
            where (prh_nbr >= nbr) and (prh_nbr <=nbr1)
            and (prh_receiver >= rcvr) and (prh_receiver <= rcvr1)
            and (prh_vend >= vend) and (prh_vend <= vend1)
            and (prh_rcp_date >= rcv_date) and (prh_rcp_date <= rcv_date1)
            and (prh_print = yes or not new_only)
            and prh_rcp_type <> "R"
            use-index prh_rcp_date break by prh_receiver
            by prh_nbr by prh_line:

               if (oldcurr <> prh_curr) or (oldcurr = "") then do:
/*L020*           {gpcurmth.i */
/*L020*        "prh_curr" */
/*L020*        "4" */
/*L020*        "next" */
/*L020*        "pause" } */
/*L020*/          if prh_curr = gl_base_curr then
/*L020*/             rndmthd = gl_rnd_mthd.
/*L020*/          else do:
/*L020*/             /* GET ROUNDING METHOD FROM CURRENCY MASTER */
/*L020*/             {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                      "(input prh_curr,
                        output rndmthd,
                        output mc-error-number)"}
/*L020*/             if mc-error-number <> 0 then do:
/*L020*/                {mfmsg.i mc-error-number 4}
/*L020*/                if c-application-mode <> "WEB":U then
/*L020*/                   pause.
/*L020*/                next.
/*L020*/             end.
/*L020*/          end.

                  /* DETERMINE CURRENCY DISPLAY AMERICAN OR EUROPEAN        */
                  find rnd_mstr where rnd_rnd_mthd = rndmthd no-lock no-error.
                  if not available rnd_mstr then do:
                     {mfmsg.i 863 4}    /* ROUND METHOD RECORD NOT FOUND */
                     next.
                  end.
                  /* IF RND_DEC_PT = COMMA FOR DECIMAL POINT */
                  /* THIS IS A EUROPEAN STYLE CURRENCY */
                  if (rnd_dec_pt = "," )
                  then SESSION:numeric-format = "European".
                  else SESSION:numeric-format = "American".
                  {pocurfmt.i}
                  oldcurr = prh_curr.
               end.

               assign
                  prh_recno = recid(prh_hist)
                  duplicate = ""
                  revision  = 0
                  buyer     = ""
                  rmks      = "".

/*N0GV*        if prh_print = no then duplicate = {&porcrp_p_18}. */
/*N0GV*/       if prh_print = no then duplicate = "*" +
/*N0GV*/                        caps(getTermLabel("DUPLICATE",9)) + "*".

               find po_mstr where po_nbr = prh_nbr no-lock no-error.
               if available po_mstr then
                  assign
                     revision = po_rev
                     buyer    = po_buyer
                     rmks     = po_rmks.

               assign vendor = "".
               find ad_mstr where ad_addr = prh_vend
               no-lock no-wait no-error.
               if available ad_mstr then do:
                  assign
                     vendor[1]  = ad_name
                     vendor[2]  = ad_line1
                     vendor[3]  = ad_line2
                     vendor[4]  = ad_line3
                     vendor[6]  = ad_country
                     vend_phone = ad_phone.
                  {mfcsz.i vendor[5] ad_city ad_state ad_zip}
                  {mfaddr.i
                     vendor[1]
                     vendor[2]
                     vendor[3]
                     vendor[4]
                     vendor[5]
                     vendor[6]}.
               end.

               FORM /*GUI*/  header
/*N0GV*           {&porcrp_p_3}   at 33
 *N0GV*           {&porcrp_p_10}             to 62 */
/*N0GV*/          /*getTermLabel("R_E_C_E_I_V_E_R",20)   at 33 format "x(20)"      yang*/
                   "材料验收单"  AT 33 FORMAT "x(20)"                                /***************************此处修改了报表头*******************************/
/*N0GV*/          getTermLabelRtColon("PAGE_OF_REPORT",8) to 62                
                  string(page-number
                  -
                  pages)
                  duplicate           at 68
/*N0GV*
 *                {&porcrp_p_7}         at 11
 *                prh_vend
 *                {&porcrp_p_4}         to 68
 *N0GV*/
/*N0GV*/          getTermLabel("SUPPLIER",15) + ": " +
/*N0GV*/          prh_vend at 11 format "x(25)"
/*N0GV*/          getTermLabelRtColon("RECEIVER",20) to 68 format "x(20)"
                  prh_receiver
                  vendor[1]           at 11
/*N0GV*           {&porcrp_p_2}     to 68 */
/*N0GV*/          getTermLabelRtColon("RECEIPT_DATE",18) to 68 format "x(18)"
                  prh_rcp_date
                 /* vendor[2]           at 11*/
/*N0GV*           {&porcrp_p_14}       to 68 */
/*N0GV*/          
                 /* vendor[3]           at 11*/
/*N0GV*           {&porcrp_p_16}   to 68 */
/*N0GV*/          getTermLabelRtColon("PURCHASE_ORDER",18) 
                    AT 4 format "x(18)"
                  prh_nbr
                   getTermLabelRtColon("PRINT_DATE",18) TO 68 format "x(18)"
                  pdate
                 /* vendor[4]           at 11
/*N0GV*           {&porcrp_p_15}      to 68 */
/*N0GV*/          getTermLabelRtColon("PURCHASE_ORDER_REVISION",18) to 68 format "x(18)"
                  revision
                  vendor[5]           at 11
                  vendor[6]           at 11
                  vend_phone          at 11*/
/*N0GV*           {&porcrp_p_1}        to 68 */
/*N0GV*/         /* getTermLabelRtColon("SHIP_DATE",18) to 68 format "x(18)"
                  prh_ship_date*/
                  skip
/*N0GV*
 *                {&porcrp_p_13}     at 11
 *                prh_ps_nbr
 *                {&porcrp_p_5}          at 11
 *                rmks
 *N0GV*/
/*N0GV*/          getTermLabel("PACKING_SLIP",25) + ": " +
/*N0GV*/          prh_ps_nbr  at 11 format "x(39)"
/*N0GV*/          getTermLabel("REMARKS",25) + ": " +
/*N0GV*/          rmks at 11 format "x(67)"
                  skip(1)
               with STREAM-IO /*GUI*/  frame phead1 page-top width 80.
               view frame phead1.
/********************************************************************************************************************************************************/                 
                  FORM HEADER
                 
                                                                             "判定栏位:_______________" AT 65
                  SKIP(1)
                  "收料员:_______________ 仓库主管:_______________ 仓管员:_______________ IQC:_______________"
                  SKIP(1)
                  "财务(白) 采购(红) 仓库(黄) 品管(绿) 厂商(蓝)"
                      WITH STREAM-IO FRAME kk PAGE-BOTTOM  WIDTH 130.
                  VIEW FRAME kk.
 /*******************************************************************************************************************************************************/
               if first-of (prh_receiver) then do:
                   assign
                     pages        = page-number - 1
                     old_receiver = prh_receiver.

                  old_db = global_db.
                  find first pod_det where pod_nbr = po_nbr no-lock no-error.
                  if available pod_det then do:
                     if global_db <> pod_po_db then do:
                        {gprun.i ""gpalias3.p"" "(pod_po_db, output err-flag)" }
                     end.
                  end. /* IF AVAILABLE POD_DET */

                  if available po_mstr then do:
                     /* PRINT ALL COMMENTS */
                     if printcmts then do:
                        {gprun.i ""pohdcmt.p"" "(input po_nbr, input 'RP' )"}
                     end. /* IF PRINTCMTS */
                     /* PRINT RECEIVER COMMENTS ONLY */
                     else do:
                        {gprun.i ""pohdcmt.p"" "(input po_nbr, input 'RC' )"}
                     end. /* ELSE */
                  end. /* IF AVAILABLE PO_MSTR */

                  if old_db <> global_db then do:
                     {gprun.i ""gpalias3.p"" "(old_db, output err-flag)" }
                  end. /* IF OLD_DB <> GLOBAL_DB */

               end. /* IF FIRST-OF (PRH_RECEIVER) */

               /* DISPLAY PO RECEIPT LINE INFORMATION */
               {gprun.i ""porcrpb.p""}

               /* DISPLAY TRANSACTION HISTORY DETAIL FOR LOT/SERIAL NBRS */
               if tr_count > 1 then do:
                  prh_recno = recid(prh_hist).
                  {gprun.i ""porcrpc.p""}

               end.  /* (IF TR_COUNT > 1) */

                if printwo then do:
                  l_prh_recno = recid(prh_hist).
                  {gprun.i ""porcrpwo.p"" "(prh_part,l_prh_recno)"}

                end.

               
/*GUI*/ {mfguirex.i } /*Replace mfrpexit*/


               /* TRAILER */
               if last-of(prh_receiver) and print_trlr and {txnew.i} then do:
                  find po_mstr where po_nbr = prh_nbr no-lock.
                  assign
                     undo_trl2   = true
                     po_recno    = recid(po_mstr)
                     receivernbr = prh_receiver.

                  {gprun.i ""porctrl2.p""}
                  if undo_trl2 then undo, leave.
               end.
               else
               if page-size - line-count < 4 then page.
               put skip (1).
         /*V8+*/
               if not last(prh_receiver) and
               last-of (prh_receiver) then do:
                  page.
                  assign
                     pdate        = today
                     old_receiver = ?.
               end.

               find prhhist where recid(prhhist) = prh_recno exclusive-lock.
               /* CHANGE PRINT FLAG TO "NO" */
               if available prhhist then
               prhhist.prh_print = no.

            end.
            /* End Processing prh_hist */
/********************************************************************************************************************************************************/                 
                 PUT
                 
                                                                             "判定栏位:_______________" AT 65
                  SKIP(1)
                  "收料员:_______________ 仓库主管:_______________ 仓管员:_______________ IQC:_______________"
                  SKIP(1)
                  "财务(白) 采购(红) 仓库(黄) 品管(绿) 厂商(蓝)"
                  .
            
 /*******************************************************************************************************************************************************/
            {mfreset.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/


         end.
         SESSION:numeric-format = oldsession.
