/* popopm.p - PURCHASE ORDER PARAMETER MAINTENANCE                          */
/* Copyright 1986-2001 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                       */
/*N014*/ /*V8:RunMode=Character,Windows                                     */
/* REVISION: 1.0      LAST MODIFIED: 04/05/86   BY: PML      *              */
/* REVISION: 4.0      LAST MODIFIED: 01/18/88   BY: FLM *A108*              */
/* REVISION: 4.0      LAST MODIFIED: 01/16/88   BY: PML *A119*              */
/* REVISION: 4.0      LAST MODIFIED: 03/21/88   BY: FLM *A185*              */
/* REVISION: 5.0      LAST MODIFIED: 03/21/89   BY: WUG *B071*              */
/* REVISION: 5.0      LAST MODIFIED: 08/18/89   BY: EMB *B235*              */
/* REVISION: 6.0      LAST MODIFIED: 12/31/90   BY: MLB *D238*              */
/* REVISION: 6.0      LAST MODIFIED: 01/21/91   BY: RAM *D310*              */
/* REVISION: 7.0      LAST MODIFIED: 01/13/92   BY: RAM *F033*              */
/* REVISION: 7.0      LAST MODIFIED: 01/31/92   BY: RAM *F126*              */
/* REVISION: 7.0      LAST MODIFIED: 02/04/92   BY: RAM *F163*              */
/* REVISION: 7.0      LAST MODIFIED: 03/06/92   BY: RAM *F267*              */
/* REVISION: 7.0      LAST MODIFIED: 05/20/92   BY: MLV *F514*              */
/* REVISION: 7.3      LAST MODIFIED: 08/25/92   BY: tjs *G028*              */
/* REVISION: 7.3      LAST MODIFIED: 04/30/93   BY: WUG *GA61*              */
/* REVISION: 7.4      LAST MODIFIED: 09/29/93   BY: CDT *H086*              */
/* REVISION: 7.4      LAST MODIFIED: 10/23/93   BY: CDT *H184*              */
/* REVISION: 7.4      LAST MODIFIED: 03/03/94   BY: CDT *H289*              */
/* REVISION: 7.4      LAST MODIFIED: 03/09/94   BY: CDT *H292*              */
/* REVISION: 7.4      LAST MODIFIED: 12/16/93   BY: dpm *H074*              */
/* REVISION: 7.4      LAST MODIFIED: 07/29/94   BY: bcm *H464*              */
/* REVISION: 7.4      LAST MODIFIED: 09/09/94   BY: afs *H510*              */
/* REVISION: 7.4      LAST MODIFIED: 11/07/94   BY: ljm *GO15*              */
/* REVISION: 7.4      LAST MODIFIED: 11/30/94   BY: srk *GO58*              */
/* REVISION: 7.4      LAST MODIFIED: 01/18/95   BY: bcm *F0FF*              */
/* REVISION: 8.5      LAST MODIFIED: 02/15/96   BY: *J0CV* Brandy J Ewing   */
/* REVISION: 8.6      LAST MODIFIED: 04/18/96   BY: *K004* Kurt De Wit      */
/* REVISION: 8.6      LAST MODIFIED: 01/09/97   BY: *J1B1* Robin McCarthy   */
/* REVISION: 8.6      LAST MODIFIED: 07/04/97   BY: *H0ZX* Aruna Patil      */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane        */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan       */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan       */
/* REVISION: 9.0      LAST MODIFIED: 12/01/98   BY: *K1QY* Suresh Nayak     */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan       */
/* REVISION: 9.1      LAST MODIFIED: 08/04/99   BY: *N014* Robin McCarthy   */
/* REVISION: 9.1      LAST MODIFIED: 01/19/00   BY: *N077* Vijaya Pakala    */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 06/27/00   BY: *N0DM* Mudit Mehta      */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* myb              */
/* REVISION: 9.1      LAST MODIFIED: 09/26/00   BY: *N0W9* Mudit Mehta      */
/* REVISION: 9.1      LAST MODIFIED: 05/14/01   BY: *N0YM* Vandna Rohira    */

         {mfdtitle.i "b+ "}               /*H074*/
/*N0W9*/ {cxcustom.i "POPOPM.P"}

/*N014************************************************************************/
/*      SUB-ACCOUNT FIELD ADDED; WILL BE USED IN CONJUNCTION WITH ACCT AND   */
/*      COST CENTER. SUB-ACCOUNT IS NO LONGER CONCATENATED TO ACCT AND IS A  */
/*      SEPARATE 8 CHARACTER FIELD.  CHANGED RUN MODE TOKEN.                 */
/*N014************************************************************************/

/* ********** Begin Translatable Strings Definitions ********* */

/*N014*      THE FOLLOWING CODE NO LONGER REQUIRED SINCE THE FIELDS HAVE BEEN
 *           ADDED TO THE SCHEMA. */
/*N014 *****************************BEGIN DELETE******************************
 * &SCOPED-DEFINE popopm_p_1 "Next Fiscal Batch"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE popopm_p_2 "PO Interest Accrued Acct"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE popopm_p_3 "PO Interest Accrued CC"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE popopm_p_4 "PO Interest Applied Acct"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE popopm_p_5 "PO Interest Applied CC"
 * /* MaxLen: Comment: */
 *
 * /*N014* &SCOPED-DEFINE popopm_p_6 "Price by PO Line Due Date" */
 * /* MaxLen: Comment: */
 *N014* *****************************END DELETE***************************** */

&SCOPED-DEFINE popopm_p_8 "GST ID"
/* MaxLen: Comment: */

/*N0DM*
 * &SCOPED-DEFINE popopm_p_7 "Price Table Required"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE popopm_p_9 "Sequential Receiver"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE popopm_p_10 "Generate Date Based Release ID"
 * /* MaxLen: Comment: */
 *N0DM */

/* ********** End Translatable Strings Definitions ********* */


/*H510** define new shared variable module like mfc_module.  **/
         define variable del-yn          like mfc_logical initial no.
/*GO58*
 *G028*  define variable cancel          like mfc_logical
 *GO58*                      label "Cancel Backorders" initial no. */
/*H184*/ define variable valid_acct      like mfc_logical initial no.
/*J0CV*/ define variable ansyn like mfc_logical.

/*GO58* REMOVE - NOW IN MFPMFORM.I **************
 *H464*  define variable poc_pc_line     like mfc_logical
 *H510**                                 label "PO Price by Line Values". **
 *H510*                                  label "Price by PO Line Due Date".
 *H464*  define variable poc_crtacc_acct like gl_crterms_acct
                                         label "PO Interest Accrued Acct".
 *H464*  define variable poc_crtacc_cc   like gl_crterms_cc
                                         label "PO Interest Accrued CC".
 *H464*  define variable poc_crtapp_acct like gl_crterms_acct
                                         label "PO Interest Applied Acct".
 *H464*  define variable poc_crtapp_cc   like gl_crterms_cc
                                         label "PO Interest Applied CC".
 *H464*  define variable poc_next_batch  like mfc_integer
                                         label "Next Fiscal Batch".
 *H510*  define variable poc_pt_req      like mfc_logical
 *H510*                                  label "Price Table Required".
 *GO58*********/

/**J0CV**MOVED TO SEPARATE INCLUDE TO CONFORM WITH STANDARDS**/
/**J0CV** /*GO58*/ {mfpmform.i} **/
/*EAS019A /*J0CV*/ {popmform.i}  */
/*EAS019A */ {xxpopmform.i}

         {gpfieldv.i}           /*GA61*/

         find first gl_ctrl no-lock.

         /* Read/create mfc_ctrl variables */
/*H510*/ do transaction:
/*EAS019A Add Begin ********************* */
             find first xxpoc_ctrl exclusive-lock no-error.
             if not avail xxpoc_ctrl then do:
                create xxpoc_ctrl.
                       assign                           
                           xxpoc_po_pre2 = "TM"                           
                           xxpoc_po_nbr2 = 0
                           xxpoc_po_pre3 = ""                           
                           xxpoc_po_nbr3 = 0
                       .
             end.   
/*EAs019A Add End ********************** */

             
/*N0YM*/    find first poc_ctrl exclusive-lock no-error.

/*N014*       THE FOLLOWING CODE NO LONGER REQUIRED SINCE THE FIELDS HAVE BEEN
 *           ADDED TO THE SCHEMA. */
/*N014 *****************************BEGIN DELETE******************************
 *
 * /*H086*/    /* Added Control field for Discount Table Required */
 * /*H086*/    find first mfc_ctrl where mfc_field = "poc_pc_line"
 * /*H086*/       no-lock no-error.
 * /*H086*/    if not available mfc_ctrl then do:
 * /*H086*/       create mfc_ctrl.
 * /*H086*/       assign
 * /*H086*/       mfc_field = "poc_pc_line"
 * /*H086*/       mfc_type = "L"
 * /*H292*/       /* mfc_label = "Price by Line Item Values" */
 * /*H510**       mfc_label = "PO Price by Line Values" **/
 * /*H510*/       mfc_label = {&popopm_p_6}
 * /*H086*/       mfc_module = "PO"
 * /*H086*/       mfc_seq = 11
 * /*H086*/       mfc_logical = no.
 * /*H086*/    end.
 * /*H464*/    poc_pc_line = mfc_logical.
 *
 * /*H184*/    /* ADDED CONTROL FIELDS FOR PO CREDIT TERMS INTEREST ACCOUNTS */
 * /*H184*/    find first mfc_ctrl where mfc_field = "poc_crtacc_acct"
 * /*H184*/    no-lock no-error.
 * /*H184*/    if not available mfc_ctrl then do:
 * /*H184*/       create mfc_ctrl.
 * /*H184*/       assign
 * /*H184*/       mfc_field = "poc_crtacc_acct"
 * /*H184*/       mfc_type = "C"
 * /*H184*/       mfc_label = {&popopm_p_2}
 * /*H184*/       mfc_module = "PO"
 * /*H184*/       mfc_seq = 12
 * /*H184*/       mfc_char = "".
 * /*H184*/    end.
 * /*H464*/    poc_crtacc_acct = mfc_char.
 *
 * /*H184*/    find first mfc_ctrl where mfc_field = "poc_crtacc_cc"
 * /*H184*/    no-lock no-error.
 * /*H184*/    if not available mfc_ctrl then do:
 * /*H184*/       create mfc_ctrl.
 * /*H184*/       assign
 * /*H184*/       mfc_field = "poc_crtacc_cc"
 * /*H184*/       mfc_type = "C"
 * /*H184*/       mfc_label = {&popopm_p_3}
 * /*H184*/       mfc_module = "PO"
 * /*H184*/       mfc_seq = 13
 * /*H184*/       mfc_char = "".
 * /*H184*/    end.
 * /*H464*/    poc_crtacc_cc = mfc_char.
 *
 * /*H184*/    find first mfc_ctrl where mfc_field = "poc_crtapp_acct"
 * /*H184*/    no-lock no-error.
 * /*H184*/    if not available mfc_ctrl then do:
 * /*H184*/       create mfc_ctrl.
 * /*H184*/       assign
 * /*H184*/       mfc_field = "poc_crtapp_acct"
 * /*H184*/       mfc_type = "C"
 * /*H184*/       mfc_label = {&popopm_p_4}
 * /*H184*/       mfc_module = "PO"
 * /*H184*/       mfc_seq = 14
 * /*H184*/       mfc_char = "".
 * /*H184*/    end.
 * /*H464*/    poc_crtapp_acct = mfc_char.
 *
 * /*H184*/    find first mfc_ctrl where mfc_field = "poc_crtapp_cc"
 * /*H184*/    no-lock no-error.
 * /*H184*/    if not available mfc_ctrl then do:
 * /*H184*/       create mfc_ctrl.
 * /*H184*/       assign
 * /*H184*/       mfc_field = "poc_crtapp_cc"
 * /*H184*/       mfc_type = "C"
 * /*H184*/       mfc_label = {&popopm_p_5}
 * /*H184*/       mfc_module = "PO"
 * /*H184*/       mfc_seq = 15
 * /*H184*/       mfc_char = "".
 * /*H184*/    end.
 * /*H464*/    poc_crtapp_cc = mfc_char.
 *
 * /*H074*/    /* ADDED CONTROL FIELD FOR BATCH NUMBER */
 * /*H074*/    find first mfc_ctrl where mfc_field = "poc_next_batch"
 * /*H074*/    no-lock no-error.
 * /*H074*/    if not available mfc_ctrl then do:
 * /*H074*/       create mfc_ctrl.
 * /*H074*/       assign
 * /*H074*/       mfc_field = "poc_next_batch"
 * /*H074*/       mfc_type = "I"
 * /*H074*/       mfc_label = {&popopm_p_1}
 * /*H074*/       mfc_module = "PO"
 * /*H074*/       mfc_seq = 16
 * /*H074*/       mfc_integer = 1.
 * /*H074*/    end.
 * /*H464*/    poc_next_batch = mfc_integer.
 *N014* *****************************END DELETE***************************** */

/*H510*/    /* Added control field for Price Table Required */
/*H510*/    find first mfc_ctrl where mfc_field = "poc_pt_req"
/*H510*/    no-lock no-error.
/*H510*/    if not available mfc_ctrl then do:
/*H510*/       create mfc_ctrl.
/*H510*/       assign
/*N0DM*/          mfc_label = getTermLabel("PRICE_TABLE_REQUIRED",24)
/*H510*/          mfc_field = "poc_pt_req"
/*H510*/          mfc_type = "L"
/*N0DM* /*H510*/  mfc_label = {&popopm_p_7} */
/*H510*/          mfc_module = "PO"
/*H510*/          mfc_seq = 17
/*H510*/          mfc_logical = no.
/*H510*/    end.
/*H510*/    poc_pt_req = mfc_logical.

/*H0ZX*/    /* ADDED CONTROL FIELD FOR SEQUENTIAL RECEIVERS */
/*H0ZX*/    find first mfc_ctrl where mfc_field = "poc_seq_rcv"
/*H0ZX*/    no-lock no-error.
/*H0ZX*/    if not available mfc_ctrl then do:
/*H0ZX*/       create mfc_ctrl.
/*H0ZX*/       assign
/*N0DM*/          mfc_label = getTermLabel("SEQUENTIAL_RECEIVER",24)
/*H0ZX*/          mfc_field = "poc_seq_rcv"
/*H0ZX*/          mfc_type = "L"
/*N0DM* /*H0ZX*/  mfc_label = {&popopm_p_9} */
/*H0ZX*/          mfc_module = "PO"
/*H0ZX*/          mfc_seq = 18
/*H0ZX*/          mfc_logical = yes.
/*H0ZX*/    end.
/*H0ZX*/    poc_seq_rcv = mfc_logical.

/*H510*/ end.  /* mfc_ctrl read/create */

/*G028*  /*F514 ADDED FOLLOWING*/
 *       find first mfc_ctrl where mfc_field = "poc_apv_req" no-lock no-error.
 *       if not available mfc_ctrl then do:
 *          create mfc_ctrl.
 *          assign
 *          mfc_field = "poc_apv_req"
 *          mfc_type = "L"
 *          mfc_label = "Approvals Required"
 *          mfc_module = "PO"
 *          mfc_seq = 15.
 *          mfc_logical = yes.
 *       end.
 *       /*F514  END*/
 *
 *       /* DISPLAY SELECTION FORM */
 *G028*  {mfpmform.i} */

/*N0W9*/ {&POPOPM-P-TAG1}
/*GO58* PUT BACK INTO MFPMFORM.I NEVER SHOULD HAVE BEEN REMOVED FROM THERE *
 *       form
 *          poc_bill       colon 25
 *          poc_ship       colon 25
 *          poc_po_pre     colon 25
 *          poc_ln_fmt     colon 57
 *          poc_po_nbr     colon 25
 *          poc_hcmmts     colon 57
 *          poc_rcv_pre    colon 25
 *          poc_lcmmts     colon 57
 *          poc_rcv_nbr    colon 25
 *          cancel         colon 57
 *          poc_sort_by    colon 25
 *          poc_po_hist    colon 57
 *          poc_rcv_all    colon 25
 *H510*     poc_pt_req     colon 25
 *H510*     poc_pl_req     colon 25 label "Disc Table Required"
 *          poc_apv_req    colon 25 label "Apprvd Reqs for POs"
 *          poc_insp_loc   colon 25
 *          poc_rcv_typ    colon 25
 *          "Type:  0 - Do not print receivers" at 36
 *          "1 - Print for each shipment" at 43
 *          "2 - Print for each item/shipment" at 43
 *          poc_tol_pct    colon 25
 *          "(Acceptance limit for overshipments)" at 43
 *          poc_tol_cst    colon 25
 *          "(Acceptance limit for overshipments)" at 43
 *       with frame mfpopm-a side-labels width 80 attr-space.
 *
 *H464*  form
 *H464*     poc_pc_line     colon 35
 *H464*     poc_crtacc_acct colon 35 poc_crtacc_cc no-label
 *H464*     poc_crtapp_acct colon 35 poc_crtapp_cc   no-label
 *H464*     poc_next_batch  colon 35
 *H464*  with frame mfpopm-b side-labels width 80 attr-space.
 *GO58******/

/*J0CV*/ main-loop:
         repeat with frame mfpopm-a:

            view frame mfpopm-a.

/*N0YM**    find first poc_ctrl no-lock no-error.  */
/*N0YM*/    find first poc_ctrl exclusive-lock no-error.
/*EAS019A             if not available poc_ctrl then create poc_ctrl. */

/*EAS019A Add Begin ********************* */
                    if not available poc_ctrl then do:
                             create poc_ctrl. 
                              assign 
                                poc_po_pre = "CM"
                                poc_po_nbr = 0
                             .
                     end.        
                     poc_po_pre = "CM" .
/*EAS019A Add End ********************* */

/*N0YM**    find first poc_ctrl. */

            if poc_ln_stat = "x" then cancel = yes.
                                 else cancel = no.

/*G028*     update poc_bill poc_ship   Changed sequence
      *     poc_po_pre
      *     poc_po_nbr poc_ln_fmt
      *     poc_hcmmts poc_lcmmts
      *     poc_sort_by
      *     poc_rcv_all
      *     poc_insp_loc
      *     poc_rcv_typ
      *     poc_rcv_pre
 *G028*     poc_rcv_nbr cancel poc_tol_pct poc_tol_cst. */

/*EAS019A Del Begin ***************************
/*G028*/    update
               poc_bill
               poc_ship
               poc_po_pre
               poc_po_nbr
               poc_rcv_pre
               poc_rcv_nbr
               poc_sort_by
               poc_rcv_all
/*H510*/       poc_pt_req
/*H086*/       poc_pl_req
               poc_apv_req
               poc_insp_loc
               poc_rcv_typ
/*H0ZX*/       poc_seq_rcv
               poc_tol_pct
               poc_tol_cst
               poc_ln_fmt
               poc_hcmmts
               poc_lcmmts
               cancel
               poc_po_hist
/*J0CV*/       poc_ers_proc
/*J0CV*/       poc_ers_opt
               .
EAS019A ************************* */
/*EAS019A */
            disp
              poc_po_pre     
              xxpoc_po_pre2  
            .
            
/*G028*/    update
               poc_bill
               poc_ship
               
/*            poc_po_pre     
            xxpoc_po_pre2  
*/            
            xxpoc_po_pre3  
            poc_po_nbr     
            xxpoc_po_nbr2  
            xxpoc_po_nbr3                             
               
            
               poc_rcv_pre
               poc_rcv_nbr
               poc_sort_by
               poc_rcv_all
/*H510*/       poc_pt_req
/*H086*/       poc_pl_req
               poc_apv_req
               poc_insp_loc
               poc_rcv_typ
/*H0ZX*/       poc_seq_rcv
               poc_tol_pct
               poc_tol_cst
               poc_ln_fmt
               poc_hcmmts
               poc_lcmmts
               cancel
               poc_po_hist
/*J0CV*/       poc_ers_proc
/*J0CV*/       poc_ers_opt
               .


/*GA61**    find _field where _field-name = "poc_po_nbr" no-lock. **/
/*GA61*/    {gpfield.i &field_name='"poc_po_nbr"'}
/*GA61      * CHANGED _FORMAT TO FIELD_FORMAT IN FOLLOWING BLOCK*/
/*F267*/    if length(poc_po_pre) + length(string(poc_po_nbr))
/*F267*/       > length(field_format) then do:
/*F267*/       {mfmsg03.i 312 3 length(field_format) """" """"}
/*F267*/       /* PREFIX AND NUMBER COMBINED CANNOT EXCEED # CHARACTERS */
/*F267*/       next-prompt poc_po_nbr.
/*F267*/       undo, retry.
/*F267*/    end.

/*GA61**    find _field where _field-name = "poc_rcv_nbr" no-lock. **/
/*GA61*/    {gpfield.i &field_name='"poc_rcv_nbr"'}
/*GA61      * CHANGED _FORMAT TO FIELD_FORMAT IN FOLLOWING BLOCK*/
/*F267*/    if length(poc_rcv_pre) + length(string(poc_rcv_nbr))
/*F267*/       > length(field_format) then do:
/*F267*/       {mfmsg03.i 312 3 length(field_format) """" """"}
/*F267*/       /* PREFIX AND NUMBER COMBINED CANNOT EXCEED # CHARACTERS */
/*F267*/       next-prompt poc_rcv_nbr.
/*F267*/       undo, retry.
/*F267*/    end.

/**J0CV**ADDED BLOCK FOR ERS PROCESSING**/
            if poc_ers_proc then do:
               ansyn = no.
               if not can-find(mfc_ctrl where mfc_field = "ers_conv_run")
               then do:
/*J1B1            {mfmsg02.i 2307 1 "'run'"}    /* ERS CONVERSION NOT RUN */ */
/*J1B1*/          {mfmsg.i 2307 1}              /* ERS CONVERSION NOT RUN */
/*J1B1            {mfmsg02.i 2306 4 "'run'"}    /* CAN'T TURN ERS ON YET  */ */
/*J1B1*/          {mfmsg.i 2306 4}              /* CAN'T TURN ERS ON YET  */
                  ansyn = yes.
               end.
               else if not can-find(mfc_ctrl where mfc_field = "ers_conv_run"
                                    and mfc_logical = yes)
               then do:
/*J1B1            /* ERS CONVERSION HAS NOT COMPLETELY RUN */ */
/*J1B1            {mfmsg02.i 2307 1 "'completely run'"} */
/*J1B1*/          {mfmsg.i 2347 1}              /* ERS CONVERSION INCOMPLETE */
                  /* CAN'T TURN ON ERS PROCESSING 'TIL CONV DONE */
/*J1B1            {mfmsg02.i 2306 4 "'completed'"} */
/*J1B1*/          {mfmsg.i 2306 4}
                  ansyn = yes.
               end.

               if ansyn then do:
                  {mfmsg01.i 2327 1 ansyn}  /* RUN THE ERS CONVERSION NOW? */
                  if ansyn then do:
                     {gprun.i ""uxers1.p""}
                  end.
                  else do:
                     next-prompt poc_ers_proc.
                     undo, retry main-loop.
                  end.
               end. /* IF ANSYN */
            end.    /* IF POC_ERS_PROC */
/**J0CV**END ADDED BLOCK**/


            if cancel = yes then poc_ln_stat = "x".
                            else poc_ln_stat = "".

            /* Default Canadian Tax Exemption License numbers */
            if gl_can then
            set_sub:
            do on error undo, retry:
               form
                 poc_fst_id colon 12 label {&popopm_p_8}
/*GO15*          poc_pst_id colon 12 */
/*GO15*/         poc_pst_id colon 12 space(2)
               with frame set_sub attr-space overlay side-labels
               column frame-col(mfpopm-a) + 40 row frame-row(mfpopm-a) + 3.

               /* SET EXTERNAL LABELS */
               setFrameLabels(frame set_sub:handle).

               update poc_fst_id poc_pst_id with frame set_sub.

/*F0FF*/       hide frame set_sub no-pause.

            end.

/*H464** DELETED SECTION - MOVED MAINTENANCE BELOW **
 **            module = "PO".
 **             if can-find (first mfc_ctrl where mfc_module = module) then do:
 **
 ** /*H184*/       /* SET_MFC VERIFIES ACCOUNTS/CC INPUT THRU MFC_CTRL */
 ** /*H184*/       set_mfc:
 ** /*H184*/       do on error undo, retry:
 **
 **                   {gprun.i ""mgpmmt01.p""}
 **
 ** /*H184*/          find first mfc_ctrl where mfc_field = "poc_crtacc_acct"
 ** /*H184*/          no-lock no-error.
 ** /*H184*/          if available mfc_ctrl and mfc_char <> "" then do:
 ** /*H184*/             poc_crtacc_acct =  mfc_char.
 ** /*H184*/             find first mfc_ctrl where mfc_field = "poc_crtacc_cc"
 ** /*H184*/             no-lock no-error.
 ** /*H184*/             if available mfc_ctrl and mfc_char <> "" then
 ** /*H184*/                poc_crtacc_cc =  mfc_char.
 ** /*H184*/             {gprun.i ""gpglver1.p"" "(input poc_crtacc_acct,
 **                                                input ?,
 **                                                input poc_crtacc_cc,
 **                                                output valid_acct)" }
 ** /*H184*/             if valid_acct = no then do:
 ** /*H184*/                pause.
 ** /*H184*/                undo set_mfc, retry.
 ** /*H184*/             end.
 ** /*H289*/            /* Cr term accts no longer required to be statistical */
 ** /*H289*/           /* find first ac_mstr where ac_code = poc_crtacc_acct */
 ** /*H289*/            /* no-lock no-error.                                  */
 ** /*H289*/           /* if available ac_mstr and ac_type <> "S" then do:   */
 ** /*H289*/            /*    {mfmsg03.i 6213 3 poc_crtacc_acct """" """"}    */
 ** /*H289*/            /*               /* Must be a statistical account*/   */
 ** /*H289*/            /*    pause.                                          */
 ** /*H289*/            /*    undo set_mfc, retry.                            */
 ** /*H289*/            /* end.                                               */
 ** /*H184*/          end.
 **
 ** /*H184*/          find first mfc_ctrl where mfc_field = "poc_crtapp_acct"
 ** /*H184*/          no-lock no-error.
 ** /*H184*/          if available mfc_ctrl and mfc_char <> "" then do:
 ** /*H184*/             poc_crtapp_acct =  mfc_char.
 ** /*H184*/             find first mfc_ctrl where mfc_field = "poc_crtapp_cc"
 ** /*H184*/             no-lock no-error.
 ** /*H184*/             if available mfc_ctrl and mfc_char <> "" then
 ** /*H184*/                poc_crtapp_cc =  mfc_char.
 ** /*H184*/             {gprun.i ""gpglver1.p"" "(input poc_crtapp_acct,
 **                                                input ?,
 **                                                input poc_crtapp_cc,
 **                                                output valid_acct)" }
 ** /*H184*/             if valid_acct = no then do:
 ** /*H184*/                pause.
 ** /*H184*/                undo set_mfc, retry.
 ** /*H184*/             end.
 ** /*H289*/            /* Cr term accts no longer required to be statistical */
 ** /*H289*/            /* find first ac_mstr where ac_code = poc_crtapp_acct */
 ** /*H289*/            /* no-lock no-error.                                  */
 ** /*H289*/            /* if available ac_mstr and ac_type <> "S" then do:   */
 ** /*H289*/            /*    {mfmsg03.i 6213 3 poc_crtapp_acct """" """"}    */
 ** /*H289*/            /*               /* Must be a statistical account*/   */
 ** /*H289*/            /*    pause.                                          */
 ** /*H289*/            /*    undo set_mfc, retry.                            */
 ** /*H289*/            /* end.                                               */
 ** /*H184*/          end.
 **
 ** /*H184*/       end. /* set_mfc */
 **
 **             end.
 **H464** END DELETED SECTION **/

/*H464*/    /* ADDED SECTION FOR THE MAINTENANCE OF NEW FIELD */
/*H464*/    hide frame mfpopm-a.
/*H464*/    view frame mfpopm-b.
/*H464*/    display poc_pc_line
/*N014* /*H464*/    poc_crtacc_acct poc_crtacc_cc */
/*N014*/            poc_crtacc_acct poc_crtacc_sub poc_crtacc_cc
/*N014* /*H464*/    poc_crtapp_acct poc_crtapp_cc */
/*N014*/            poc_crtapp_acct poc_crtapp_sub poc_crtapp_cc
/*H464*/            poc_next_batch
/*K004*/            poc_ack_req
/*K1QY*/            poc__qadl06
/*H464*/    with frame mfpopm-b.
/*N0W9*/    {&POPOPM-P-TAG2}

/*H464*/    setb:
            do with frame mfpopm-b on error undo, retry:

/*N0W9*/       {&POPOPM-P-TAG3}
/*H464*/       set poc_pc_line
/*N014* /*H464*/   poc_crtacc_acct poc_crtacc_cc */
/*N014*/           poc_crtacc_acct poc_crtacc_sub poc_crtacc_cc
/*N014* /*H464*/   poc_crtapp_acct poc_crtapp_cc */
/*N014*/           poc_crtapp_acct poc_crtapp_sub poc_crtapp_cc
/*H464*/           poc_next_batch
/*K004*/           poc_ack_req
/*K1QY*/           poc__qadl06.
/*N0W9*/       {&POPOPM-P-TAG4}

/*N014*  /*H464*/   {gpglver1.i &acc = poc_crtacc_acct &sub = "?"
 *                               &cc = poc_crtacc_cc
 *                               &frame = "mfpopm-b" &loop = "setb"}
 *N014* */

         /* INITIALIZE SETTINGS */
/*N014*/ {gprunp.i "gpglvpl" "p" "initialize"}
/*N077*/ /* SET PROJECT VERIFICATION TO NO */
/*N077*/ {gprunp.i "gpglvpl" "p" "set_proj_ver" "(input false)"}
         /* ACCT/SUB/CC/PROJ VALIDATION */
/*N014*/ {gprunp.i "gpglvpl" "p" "validate_fullcode"
                   "(input  poc_crtacc_acct,
                     input  poc_crtacc_sub,
                     input  poc_crtacc_cc,
                     input  """",
                     output valid_acct)"}

/*N014*  THE FOLLOWING CODE WAS PREVIOUSLY HANDLED WITHIN gpglver1.i; NOW IT
         NEEDS TO BE INCORPORATED BACK INTO THE PROGRAM WHICH CALLS gpglver1.i*/
/*N014*/ if valid_acct = no then do:
/*N014*/    next-prompt poc_crtacc_acct with frame mfpopm-b.
/*N014*/    undo setb, retry.
/*N014*/ end.

/*N014* /*H464*/    {gpglver1.i &acc = poc_crtapp_acct &sub = "?"
 *                              &cc = poc_crtapp_cc
 *                              &frame = "mfpopm-b" &loop = "setb"}
 *N014* */

         /* INITIALIZE SETTINGS */
/*N014*/ {gprunp.i "gpglvpl" "p" "initialize"}
/*N077*/ /* SET PROJECT VERIFICATION TO NO */
/*N077*/ {gprunp.i "gpglvpl" "p" "set_proj_ver" "(input false)"}
         /* ACCT/SUB/CC/PROJ VALIDATION */
/*N014*/ {gprunp.i "gpglvpl" "p" "validate_fullcode"
                   "(input  poc_crtapp_acct,
                     input  poc_crtapp_sub,
                     input  poc_crtapp_cc,
                     input  """",
                     output valid_acct)"}

/*N014*  THE FOLLOWING CODE WAS PREVIOUSLY HANDLED WITHIN gpglver1.i; NOW IT
         NEEDS TO BE INCORPORATED BACK INTO THE PROGRAM WHICH CALLS gpglver1.i*/
/*N014*/ if valid_acct = no then do:
/*N014*/    next-prompt poc_crtapp_acct with frame mfpopm-b.
/*N014*/    undo setb, retry.
/*N014*/ end.

/*H464*/    end.  /* setb */

/*N0W9*/     {&POPOPM-P-TAG5}
/*N014*      THE FOLLOWING CODE NO LONGER REQUIRED SINCE THE FIELDS HAVE BEEN
 *           ADDED TO THE SCHEMA. */
/*N014* ***************************BEGIN DELETE******************************
 *           /* UPDATE MFC_CTRL RECORDS */
 * /*H464*/    find first mfc_ctrl where mfc_field = "poc_pc_line"
 * /*H464*/    exclusive-lock no-error.
 * /*H464*/    if available mfc_ctrl then
 * /*H464*/       mfc_logical = poc_pc_line.
 *
 * /*H464*/    find first mfc_ctrl where mfc_field = "poc_crtacc_acct"
 * /*H464*/    exclusive-lock no-error.
 * /*H464*/    if available mfc_ctrl then
 * /*H464*/        mfc_char = poc_crtacc_acct.
 *
 * /*H464*/        find first mfc_ctrl where mfc_field = "poc_crtacc_cc"
 * /*H464*/    exclusive-lock no-error.
 * /*H464*/    if available mfc_ctrl then
 * /*H464*/        mfc_char = poc_crtacc_cc.
 *
 * /*H464*/    find first mfc_ctrl where mfc_field = "poc_crtapp_acct"
 * /*H464*/    exclusive-lock no-error.
 * /*H464*/    if available mfc_ctrl then
 * /*H464*/        mfc_char = poc_crtapp_acct.
 *
 * /*H464*/    find first mfc_ctrl where mfc_field = "poc_crtapp_cc"
 * /*H464*/    exclusive-lock no-error.
 * /*H464*/    if available mfc_ctrl then
 * /*H464*/        mfc_char = poc_crtapp_cc.
 *
 * /*H464*/    find first mfc_ctrl where mfc_field = "poc_next_batch"
 * /*H464*/    exclusive-lock no-error.
 * /*H464*/    if available mfc_ctrl then
 * /*H464*/        mfc_integer = poc_next_batch.
 *N014* *****************************END DELETE***************************** */

/*H510*/       find first mfc_ctrl where mfc_field = "poc_pt_req"
/*H510*/          exclusive-lock.
/*H510*/       mfc_logical = poc_pt_req.

/*H0ZX*/    find first mfc_ctrl where mfc_field = "poc_seq_rcv"
/*H0ZX*/    exclusive-lock no-error.
/*H0ZX*/    if available mfc_ctrl then
/*H0ZX*/        mfc_logical = poc_seq_rcv.

/*H464*/    hide frame mfpopm-b.

/*N0YM*/    release poc_ctrl.
/*N0YM*/    release mfc_ctrl.

         end.
         status input.
