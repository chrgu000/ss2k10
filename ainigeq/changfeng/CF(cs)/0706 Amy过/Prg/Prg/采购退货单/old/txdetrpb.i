/* txdetrpb.i - qad DISPLAY TAX DETAIL AMOUNTS FOR A TRANSACTION              */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*V8:ConvertMode=Report                                                       */
/*  This program displays a down frame of tax detail (by) for each            */
/*  tax type/class/usage shows the tax; descrip, amount, base amount & tax %  */


/* REVISION: 8.6            CREATED: 11/13/96   BY: *H0N8* Ajit Deodhar       */


/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 12/28/98   BY: *J37L* Seema Varma        */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 12/29/99   BY: *J3MX* Surekha Joshi      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 07/19/00   BY: *N0G9* Arul Victoria   */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KC* myb                */
/* REVISION: 9.1      LAST MODIFIED: 08/18/00   BY: *N0LN* Mudit Mehta        */

                /* DISPLAY OF TAX DETAILS. */
                for each taxdetail by typedesc
                                   by taxclass
                                   by taxusage:

/* ********** Begin Translatable Strings Definitions ********* */

/*N0LN*
 * &SCOPED-DEFINE txdetrpb_i_1 "  Absorbed"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE txdetrpb_i_2 "  Recoverable"
 * /* MaxLen: Comment: */
 *N0LN*/

/* ********** End Translatable Strings Definitions ********* */

/*J37L*/           assign
/*J37L*/              l_sign = if tr_type = "25" then
/*J37L*/                          -1
/*J37L*/                       else
/*J37L*/                           1
/*J37L*/              taxtotal = taxtotal * l_sign
/*J37L*/              taxbase  = taxbase  * l_sign
/*J37L*/              nontax   = nontax   * l_sign.

                    if col-80 then do:
                        if page-size - line-counter -
                            (if first_page then page_break else 0) < 3 then do:
                            view frame continue.
                            page.
                            first_page = false.
                        end.
/*N0G9* ------------------- BEGIN DELETE ----------------------- *
 *      /* Delete as it is already used in calling programs txdetrp.p */
 *      /* txdetrp1.p  and txdetrp2.p                                 */
 *                      /* SET EXTERNAL LABELS */
 *                      setFrameLabels(frame det_80:handle).
 *N0G9* ------------------- END   DELETE ----------------------- */

                        display typedesc @ taxdesc taxclass taxtotal taxpercnt
                        taxbase @ nontax
                        with frame det_80.
                        down with frame det_80.
                        if taxadj <> 0 then
                            display taxadj @ taxtotal with frame det_80.
                        display taxdesc taxusage @ taxclass
                        nontax when (nontax <> 0)
                        with frame det_80.
                        put skip(1).
                    end.
                    else do:
/*N0G9* ------------------- BEGIN DELETE ----------------------- *
 *      /* Delete as it is already used in calling programs txdetrp.p */
 *      /* txdetrp1.p  and txdetrp2.p                                 */
 *                      /* SET EXTERNAL LABELS */
 *                      setFrameLabels(frame det_132:handle).
 *N0G9* ------------------- END   DELETE ----------------------- */

/*N0G9* ------------------- BEGIN ADD ----------------------- */
                        assign
                           l-taxdesc  = taxdesc
                           l-taxclass = taxclass
                           l-nontax   = nontax.

/*N0G9* ------------------- END   ADD ----------------------- */
                        display
                           typedesc

/*N0G9*                    taxdesc                     */
/*N0G9*                    taxclass                    */

/*N0G9*/                   l-taxdesc
/*N0G9*/                   l-taxclass
                           taxusage
                           taxtotal
                           taxpercnt
                           taxbase
/*N0G9*                    nontax                    */

/*N0G9*/                   l-nontax
                        with frame det_132.
                        down 1 with frame det_132.
                        if taxadj <> 0 then do:
                            down with frame det_132.
                            if ar_ap then
/*N0G9*                         display {&txdetrpb_i_1} @ taxdesc  */
/*N0LN* /*N0G9*/                display {&txdetrpb_i_1} @ l-taxdesc */
/*N0LN*/                        display "  " + getTermLabel("ABSORBED",22) @ l-taxdesc
                                taxadj @ taxtotal with frame det_132.
                            else
/*N0G9*                         display {&txdetrpb_i_2} @ taxdesc  */
/*N0LN* /*N0G9*/                display {&txdetrpb_i_2} @ l-taxdesc */
/*N0LN*/                        display "  " + getTermLabel("RECOVERABLE",22) @ l-taxdesc
                                taxadj @ taxtotal with frame det_132.
                            down with frame det_132.
                        end.
                    end.

/*J3MX*/            if execname <> "soivpst.p" then
/*J3MX*/            do:
                       {mfrpchk.i &label=mainloop} /* exit if f4 */
/*J3MX*/            end. /* IF EXECNAME <> "SOIVPST.P" */

                end. /* FOR EACH DETAIL */
