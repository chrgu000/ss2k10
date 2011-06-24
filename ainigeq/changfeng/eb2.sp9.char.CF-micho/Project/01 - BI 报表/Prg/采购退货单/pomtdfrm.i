/* pomtdfrm.i - DEFINE FORM PURCHASE ORDER TRAILER INCLUDE FILE         */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*N014*/ /*V8:RunMode=Character,Windows                                 */
/* REVISION: 7.4            CREATED: 06/24/94   BY: bcm *H397**/
/* REVISION: 7.4      LAST MODIFIED: 09/20/94   BY: jpm *GM74**/
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan      */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Patti Gaultney  */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* myb             */


/*N014************************************************************************/
/*      SUB-ACCOUNT FIELD ADDED; WILL BE USED IN CONJUNCTION WITH ACCT AND   */
/*      COST CENTER. SUB-ACCOUNT IS NO LONGER CONCATENATED TO ACCT AND IS A  */
/*      SEPARATE 8 CHARACTER FIELD.  CHANGED RUN MODE TOKEN.                 */
/*N014************************************************************************/

/*GM74 /*H397*/ def var edi_po like mfc_logical label "EDI PO".  */

        /*H397 REVISIONS TO FOLLOWING FORM*/
/*GM74      form                                */
                             po_rev         colon 15
                             po_prepaid     colon 50
                             po_print       colon 15
                             po_stat        colon 50
                             edi_po         colon 15
                             po_cls_date    colon 50
                             po_ap_acct     colon 15
/*GM74*/             /*V8!  view-as fill-in size 9 by 1 space(.5) */
/*N014*/                     po_ap_sub      no-label
                             po_ap_cc       no-label
/*GM74*/       /*V8!  view-as fill-in size 5 by 1           */
                             po_fob         colon 50
                             po_del_to      colon 15
                             po_shipvia     colon 50
/*GM74      with frame d attr-space side-labels width 80.  */
