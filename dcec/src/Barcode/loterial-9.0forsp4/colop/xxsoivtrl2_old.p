/* xxsoivtrl2.p - PENDING INVOICE TRAILER                                 */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.9.1.2 $                                             */
/*V8:ConvertMode=Maintenance                                            */
/* REVISION: 7.3            CREATED: 02/09/93   BY: bcm *G416*          */
/* REVISION: 7.4      LAST MODIFIED: 06/07/93   BY: skk *H002*          */
/* REVISION: 7.4      LAST MODIFIED: 07/22/93   BY: bcm *H032*          */
/* REVISION: 7.4      LAST MODIFIED: 07/28/93   BY: bcm *H042*          */
/* REVISION: 7.4      LAST MODIFIED: 07/29/93   BY: jjs *H043*          */
/* REVISION: 7.4      LAST MODIFIED: 09/08/94   BY: bcm *H509*          */
/* REVISION: 7.4      LAST MODIFIED: 11/15/94   BY: bcm *H601*          */
/* REVISION: 7.4      LAST MODIFIED: 11/22/94   BY: bcm *H606*          */
/* REVISION: 7.4      LAST MODIFIED: 07/06/95   BY: jym *H0F7*          */
/* REVISION: 7.4      LAST MODIFIED: 08/15/95   BY: bcm *H0FJ*          */
/* REVISION: 7.4      LAST MODIFIED: 09/25/95   BY: rxm *H0G3*          */
/* REVISION: 7.4      LAST MODIFIED: 10/02/95   BY: jym *G0XY*          */
/* REVISION: 8.5      LAST MODIFIED: 07/13/95   BY: taf *J053*          */
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* myb          */
/* Old ECO marker removed, but no ECO header exists *F0PN*               */
/* $Revision: 1.9.1.2 $ BY: Steve Nugent DATE: 07/09/01 ECO: *P007* */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*!
  PARAMETERS:
    I/O      NAME        LIKE          DESCRIPTION
    ------   ----------  ------------  ----------------------------------
    input    ref         tx2d_ref      so_nbr until inv printed; then so_inv_nbr
    input    nbr         tx2d_nbr      blank until inv printed; then so_nbr
    input    col-80      mfc_logical   true to print report with 80 columns
                       otherwise report uses 132 columns
    input    tax_tr_type tx2d_tr_type  13 for Pending SO; 16 for posting
    input    tot_cont_charge decimal   Total container charge amount
    input    tot_line_charge decimal   Total line charge amount
*/

{mfdeclre.i}

define input parameter ref          like tx2d_ref.
define input parameter nbr          like tx2d_nbr.
define input parameter col-80       like mfc_logical.
define input parameter tax_tr_type  like tx2d_tr_type.
define input parameter tot_cont_charge as decimal no-undo.
define input parameter tot_line_charge as decimal no-undo.

define shared variable convertmode as character no-undo.
define shared variable rndmthd          like rnd_rnd_mthd.


if convertmode = "MAINT" then do:

    {gprun.i ""xxsoivtrld.p"" "(input ref /* TX2D_REF */,
                             input nbr    /* TX2D_NBR */,
                             input col-80 /* REPORT WIDTH */,
                             input tax_tr_type /* TRANSACTION TYPE */,
                             input tot_cont_charge,
                             input tot_line_charge)"}
/*GUI*/ if global-beam-me-up then undo, leave.

end.
else do:
   {gprun.i ""xxsoivtrlc.p"" "(input ref /* TX2D_REF */,
                             input nbr    /* TX2D_NBR */,
                             input col-80 /* REPORT WIDTH */,
                             input tax_tr_type /* TRANSACTION TYPE */,
                             input tot_cont_charge,
                             input tot_line_charge)"}
/*GUI*/ if global-beam-me-up then undo, leave.

end.