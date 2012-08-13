/* xxsoivmt01.i - PENDING INV MAINTENANCE FRAME D SECOND TRAILER FRAME    */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*N014*/ /*V8:RunMode=Character,Windows                                 */
/* REVISION: 8.5      LAST MODIFIED: 10/06/95   BY: taf *J053**/
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Patti Gaultney */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00 BY: *N0KN* myb              */




/*J053** - LEFT PATCH GM77 IN TO - WAS UNSURE AND WANTED THE PATCH MARKER */
/*J053**   TO REMAIN IN PLACE TO MARK GUI V8 CHANGEES */
/*N014* *****************************BEGIN DELETE****************************
 *            form
 *               so_cr_init     colon 15
 *               so_inv_nbr     colon 40
 *               so_ar_acct
 * /*GM77*/ /*V8-*/ colon 63 /*V8+*/ /*V8!colon 61 */
 *               so_ar_cc no-label
 *               so_cr_card     colon 15
 *               so_to_inv      colon 40
 *               so_print_so
 * /*GM77*/ /*V8-*/ colon 63 /*V8+*/ /*V8!colon 61 */
 *               so_stat        colon 15
 *               so_invoiced    colon 40
 *               so_print_pl
 * /*GM77*/ /*V8-*/ colon 63 /*V8+*/ /*V8!colon 61 */
 *               so_rev         colon 15
 *               so_prepaid     colon 40
 *               so_fob         colon 15
 *            with frame d side-labels width 80.
 *N014* *****************************END DELETE****************************** */
/*N014* *****************************BEGIN ADD ****************************** */
           FORM /*GUI*/ 
              
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
so_cr_init     colon 15
              so_inv_nbr     colon 48

              so_cr_card     colon 15
              so_to_inv      colon 48
              so_print_so
              /*V8+*/      colon 70   

              so_stat        colon 15
              so_invoiced    colon 48
              so_print_pl
              /*V8+*/      colon 70   

              so_rev         colon 15
              so_prepaid     colon 48

              so_fob         colon 15
/**xx**/  so__dec01  COLON 48 LABEL "Surcharge Amt"  FORMAT "->>>,>>>,>>9.9<<<<<"
              so_ar_acct     colon 15
              so_ar_sub                 no-label
              so_ar_cc                  no-label
            SKIP(.4)  /*GUI*/
with frame d side-labels width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-d-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame d = F-d-title.
 RECT-FRAME-LABEL:HIDDEN in frame d = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame d =
  FRAME d:HEIGHT-PIXELS - RECT-FRAME:Y in frame d - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME d = FRAME d:WIDTH-CHARS - .5.  /*GUI*/


           /* SET EXTERNAL LABELS */
           setFrameLabels(frame d:handle).
/*N014* *****************************END ADD ****************************** */
