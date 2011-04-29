/* popmform.i               Purchasing Control file Forms                     */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*J0CV*/ /*V8:ConvertMode=Maintenance                                         */
/*N014*/ /*V8:RunMode=Character,Windows                                       */
/* REVISION: 8.5      LAST MODIFIED: 02/21/96   BY: *J0CV* Brandy J Ewing     */
/* REVISION: 8.6      LAST MODIFIED: 02/21/96   BY: *K004* Kurt De Wit        */
/* REVISION: 8.6      LAST MODIFIED: 07/04/97   BY: *H0ZX* Aruna Patil        */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 12/02/98   BY: *K1QY* Suresh Nayak       */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 07/23/99   BY: *N014* Robin McCarthy     */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 07/06/00 BY: *N0F4* Mudit Mehta      */
/* REVISION: 9.1      LAST MODIFIED: 07/18/00 BY: *M0PQ* Falguni Dalal    */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00 BY: *N0KQ* myb                  */
/* REVISION: 9.1      LAST MODIFIED: 09/27/00 BY: *N0W9* Mudit Mehta          */

/*N014************************************************************************/
/*      SUB-ACCOUNT FIELD ADDED; WILL BE USED IN CONJUNCTION WITH ACCT AND   */
/*      COST CENTER. SUB-ACCOUNT IS NO LONGER CONCATENATED TO ACCT AND IS A  */
/*      SEPARATE 8 CHARACTER FIELD.  CHANGED RUN MODE TOKEN.                 */
/*N014************************************************************************/

/*N0W9*/  {cxcustom.i "POPMFORM.I"}
/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE popmform_i_1 " Purchase Order Control File "
/* MaxLen: Comment: */

&SCOPED-DEFINE popmform_i_2 "Apprvd Reqs for POs"
/* MaxLen: Comment: */

/*N014* &SCOPED-DEFINE popmform_i_3 "Price by PO Line Due Date" */
/*N014* /* MaxLen: Comment: */ */

&SCOPED-DEFINE popmform_i_5 "Cancel Backorders"
/* MaxLen: Comment: */


/*N014* &SCOPED-DEFINE popmform_i_6 "PO Interest Accrued Acct" */
/*N014* /* MaxLen: Comment: */ */

/*N014* &SCOPED-DEFINE popmform_i_9 "PO Interest Applied CC" */
/*N014* /* MaxLen: Comment: */ */

&SCOPED-DEFINE popmform_i_10 "Price Table Required"
/* MaxLen: Comment: */

/*N014* &SCOPED-DEFINE popmform_i_11 "PO Interest Applied Acct" */
/*N014* /* MaxLen: Comment: */ */

/*N014* &SCOPED-DEFINE popmform_i_12 "PO Interest Accrued CC"   */
/*N014* /* MaxLen: Comment: */ */

/*N014* &SCOPED-DEFINE popmform_i_13 "Next Fiscal Batch" */
/*N014* /* MaxLen: Comment: */ */

&SCOPED-DEFINE popmform_i_14 "Disc Table Required"
/* MaxLen: Comment: */

&SCOPED-DEFINE popmform_i_16 "Sequential Receiver"
/* MaxLen: Comment: */

&SCOPED-DEFINE popmform_i_17 "Generate Date Based Release ID"
/* MaxLen: Comment: */

/*N0F4*
 * &SCOPED-DEFINE popmform_i_4 "1 - Print for each shipment"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE popmform_i_7 "(Acceptance limit for overshipments)"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE popmform_i_8 "2 - Print for each item/shipment"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE popmform_i_15 "Type:  0 - Do not print receivers"
 * /* MaxLen: Comment: */
 *N0F4*/
/*N0W9*/ {&POPMFORM-I-TAG1}

/* ********** End Translatable Strings Definitions ********* */

/* MOVED FROM MFPMFORM.I TO CONFORM TO STANDARDS */

         define variable cancel like mfc_logical label {&popmform_i_5}
            initial no.
/*N014*  BEGIN DELETE; FIELDS NOW DEFINED IN SCHEMA *************************
 *       define variable poc_pc_line like mfc_logical
 *          label {&popmform_i_3}.
 *       define variable poc_crtacc_acct like gl_crterms_acct
 *          label {&popmform_i_6}.
 *       define variable poc_crtacc_cc like gl_crterms_cc
 *          label {&popmform_i_12}.
 *       define variable poc_crtapp_acct like gl_crterms_acct
 *          label {&popmform_i_11}.
 *       define variable poc_crtapp_cc like gl_crterms_cc
 *          label {&popmform_i_9}.
 *       define variable poc_next_batch as integer label {&popmform_i_13}.
 *N014* ****************************END DELETE***************************** */
      /* define variable poc_pt_req as logical                          **M0PQ*/
         define variable poc_pt_req like mfc_logical                    /*M0PQ*/
            label {&popmform_i_10}.
/* /*H0ZX*/ define variable poc_seq_rcv as logical                      **M0PQ*/
         define variable poc_seq_rcv like mfc_logical                   /*M0PQ*/
/*H0ZX*/    label {&popmform_i_16} initial "yes" no-undo.
/*N0F4*/ define variable disp-char15 as character no-undo format "x(35)".
/*N0F4*/ define variable disp-char4  as character no-undo format "x(35)".
/*N0F4*/ define variable disp-char8  as character no-undo format "x(35)".
/*N0F4*/ define variable disp-char7  as character no-undo format "x(36)" extent 2.

/*EAS019A Del Begin ***************
         form
            poc_bill       colon 25
            poc_ship       colon 25
            poc_po_pre     colon 25
            poc_ln_fmt     colon 57
            poc_po_nbr     colon 25
            poc_hcmmts     colon 57
            poc_rcv_pre    colon 25
            poc_lcmmts     colon 57
            poc_rcv_nbr    colon 25
            cancel         colon 57
            poc_sort_by    colon 25
            poc_po_hist    colon 57
            poc_rcv_all    colon 25
/*J0CV*/    poc_ers_proc   colon 57
            poc_pt_req     colon 25
/*J0CV*/    poc_ers_opt    colon 57
            poc_pl_req     colon 25
                                    label {&popmform_i_14}
            poc_apv_req    colon 25 label {&popmform_i_2}
            poc_insp_loc   colon 25
            poc_rcv_typ    colon 25
/*N0F4*     {&popmform_i_15} at 36 */
/*N0F4*/    disp-char15 at 36 no-label
/*H0ZX*/    poc_seq_rcv    colon 25
/*N0F4*     {&popmform_i_4} at 43 */
/*N0F4*/    disp-char4 at 43 no-label
/*N0F4*     {&popmform_i_8} at 43 */
/*N0F4*/    disp-char8 at 43 no-label
            poc_tol_pct    colon 25
/*N0F4*     {&popmform_i_7} at 43 */
/*N0F4*/    disp-char7[1] at 43 no-label
            poc_tol_cst    colon 25
/*N0F4*     {&popmform_i_7} at 43 */
/*N0F4*/    disp-char7[2] at 43 no-label
/*N0F4*     with frame mfpopm-a side-labels width 80 attr-space*/
/*N0F4*/    with frame mfpopm-a side-labels width 80 no-attr-space
         /*V8! title color normal
         (getFrameTitle("PURCHASE_ORDER_CONTROL_FILE",38)) */ .
EAS019A ********************************************  */
/*EAS019A Add Begin *************** */
         form
            poc_bill       colon 25
            poc_ship       colon 25
            
            poc_po_pre     colon 25
            xxpoc_po_pre2  colon 40
            xxpoc_po_pre3  colon 55
            poc_po_nbr     colon 25
            xxpoc_po_nbr2  colon 40
            xxpoc_po_nbr3  colon 55
                        
                        
            poc_rcv_pre    colon 25
            poc_ln_fmt     colon 57
            poc_rcv_nbr    colon 25                                 
            poc_hcmmts     colon 57
            poc_sort_by    colon 25
            poc_lcmmts     colon 57
            poc_rcv_all    colon 25
            cancel         colon 57
            poc_pt_req     colon 25            
            poc_po_hist    colon 57
            poc_pl_req     colon 25 label {&popmform_i_14}            
/*J0CV*/    poc_ers_proc   colon 57
            poc_apv_req    colon 25 label {&popmform_i_2}           
/*J0CV*/    poc_ers_opt    colon 57
            
                                    
            poc_insp_loc   colon 25
            poc_rcv_typ    colon 25
/*N0F4*     {&popmform_i_15} at 36 */
/*N0F4*/    disp-char15 at 36 no-label
/*H0ZX*/    poc_seq_rcv    colon 25
/*N0F4*     {&popmform_i_4} at 43 */
/*N0F4*/    disp-char4 at 43 no-label
/*N0F4*     {&popmform_i_8} at 43 */
/*N0F4*/    disp-char8 at 43 no-label
            poc_tol_pct    colon 25
/*N0F4*     {&popmform_i_7} at 43 */
/*N0F4*/    disp-char7[1] at 43 no-label
            poc_tol_cst    colon 25
/*N0F4*     {&popmform_i_7} at 43 */
/*N0F4*/    disp-char7[2] at 43 no-label
/*N0F4*     with frame mfpopm-a side-labels width 80 attr-space*/
/*N0F4*/    with frame mfpopm-a side-labels width 80 no-attr-space
         /*V8! title color normal
         (getFrameTitle("PURCHASE_ORDER_CONTROL_FILE",38)) */ .
/*EAS019A Add End */
         /* SET EXTERNAL LABELS */
         setFrameLabels(frame mfpopm-a:handle).

/*N0F4*/ assign
         disp-char15:screen-value    in frame mfpopm-a = getTermLabel("TYPE:__0_-_DO_NOT_PRINT_RECEIVERS",35)
         disp-char4:screen-value     in frame mfpopm-a = getTermLabel("1_-_PRINT_FOR_EACH_SHIPMENT",35)
         disp-char8:screen-value     in frame mfpopm-a = getTermLabel("2_-_PRINT_FOR_EACH_ITEM/SHIPMENT",35)
         disp-char7[1]:screen-value  in frame mfpopm-a = "(":U + getTermLabel("ACCEPTANCE_LIMIT_FOR_OVERSHIPMENTS",34) + ")":U
         disp-char7[2]:screen-value  in frame mfpopm-a = "(":U + getTermLabel("ACCEPTANCE_LIMIT_FOR_OVERSHIPMENTS",34) + ")":U.
/*N0W9*/ {&POPMFORM-I-TAG2}

         form
            poc_pc_line     colon 35
            poc_crtacc_acct colon 35
/*N014*/    poc_crtacc_sub              no-label
            poc_crtacc_cc               no-label
            poc_crtapp_acct colon 35
/*N014*/    poc_crtapp_sub              no-label
            poc_crtapp_cc               no-label
            poc_next_batch  colon 35
/*K004*/    poc_ack_req     colon 35
/*K1QY*/    poc__qadl06     colon 35 label {&popmform_i_17}
         with frame mfpopm-b side-labels width 80 attr-space.
/*N0W9*/ {&POPMFORM-I-TAG3}

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame mfpopm-b:handle).
