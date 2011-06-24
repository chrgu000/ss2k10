/* sopke01.p - TOTAL DETAIL ALLOCATIONS FOR A SALES ORDER LINE          */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                 */
/* REVISION: 7.3      LAST MODIFIED: 01/06/92   BY: afs *G511**/
/* REVISION: 7.3      LAST MODIFIED: 01/14/94   BY: afs *FL21**/
/* REVISION: 7.3      LAST MODIFIED: 07/26/96   BY: *Ajit Deodhar* **F0XH**/

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan     */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan     */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00 BY: *N0JM* Mudit Mehta      */

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE sopke01_p_2 " Shipped"
/* MaxLen: Comment: */

&SCOPED-DEFINE sopke01_p_3 "Ext Price"
/* MaxLen: Comment: */

&SCOPED-DEFINE sopke01_p_4 "Qty Open!Qty to Ship"
/* MaxLen: Comment: */

/*N0JM*
 * &SCOPED-DEFINE sopke01_p_1 "*** cont ***"
 * /* MaxLen: Comment: */
 *N0JM*/


/* ********** End Translatable Strings Definitions ********* */

DEFINE  SHARED VAR v_lad_loc LIKE lad_loc.

define shared variable tot_qty_all like lad_qty_all.
define shared variable alc_sod_nbr like sod_nbr.
define shared variable alc_sod_line like sod_line.
/*N0JM*  define variable cont_lbl as character format "x(12)" initial {&sopke01_p_1}. */
/*N0JM*/ define variable cont_lbl as character format "x(12)" no-undo.
define variable qty_all like lad_qty_all.
define variable qty_open like sod_qty_ord column-label {&sopke01_p_4}
 format "->>>>>9.9<<<<<".
define variable ext_price like sod_price label {&sopke01_p_3}
 format "->>,>>>,>>9.99".
define variable desc1 like pt_desc1. /* format "x(21)". */
define variable qtyshipped as character format "x(8)"
 initial "(      )" label {&sopke01_p_2}.
define shared frame d.
define variable rev like pt_rev.
/*FL21*/ define new shared variable lad_recno as recid.

/*N0JM*/ assign
          cont_lbl = dynamic-function('getTermLabelFillCentered' in h-label,
                     input "CONTINUE", input 12, input '*').

{xxsopkf01.i}  /* Define shared frame d for sales order lines */

/*F0XH*/  find first icc_ctrl no-lock no-error.

find sod_det where sod_nbr = alc_sod_nbr
           and sod_line = alc_sod_line no-lock.

        /*DISPLAY ALLOCATION DETAIL*/
        for each lad_det where lad_dataset = "sod_det"
                   and lad_nbr = sod_nbr
                   and lad_line = string(sod_line)
         with frame d:
           find ld_det where ld_site = lad_site
                 and ld_loc  = lad_loc
                 and ld_part = lad_part
                 and ld_lot  = lad_lot
                 and ld_ref  = lad_ref
        no-lock no-error.

/*F0XH*/       if ld_expire <= today + icc_iss_days then next.

               qty_all = lad_qty_all.
/*F444*/       accumulate lad_qty_all (total).
/*FL21**       (Moved database updates to a separate program, so changes can be
 *             made to this program by users with only query-level Progress.)
 *             lad_qty_pick = lad_qty_pick + lad_qty_all.
 *FL21**       lad_qty_all = 0.  **/
/*FL21*/       lad_recno = recid(lad_det).
/*FL21*/       {gprun.i ""sosopke.p""}

           if page-size - line-counter < 1 then do:
              page.
              /*DISPLAY CONTINUED*/
              {xxsopkd01.i}
              down 1 with frame d.
           end.
           /******************* SS - Micho 20060320 B **************************/
           /*
           {sopkc01.i}
           */
           v_lad_loc = lad_loc .
           /*
           down 1 with frame d.
           /*IF QTY OH - QTY ALL TO OTHER ORDERS < QTY ALL TO THIS ORDER*/
           if not available ld_det
        or ld_qty_oh - ld_qty_all + lad_qty_all < lad_qty_all
        then do:
          if page-size - line-counter < 1 then do:
             page.
             /*DISPLAY CONTINUED*/
             {sopkd01.i}
             down 1 with frame d.
          end.
          find msg_mstr where msg_lang = global_user_lang
          and msg_nbr = 4992 no-lock no-error.
          if available msg_mstr then put msg_desc at 20 skip.
          
          /*Quantity not available at this location*/
           end.
          */
           /******************* SS - Micho 20060320 B **************************/

        end.
/*F444*/    tot_qty_all = accum total (lad_qty_all).

        /*
        put skip(1).
        */
