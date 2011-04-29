/* txdetrpb.i - qad DISPLAY TAX DETAIL AMOUNTS FOR A TRANSACTION              */
/* Copyright 1986-2006 QAD Inc., Carpinteria, CA, USA.                        */
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
/* Revision: 1.15.2.1  BY: Karel Groos DATE: 04/01/05 ECO: *P2BV*        */
/* $Revision: 1.15.2.2 $    BY: Puja Bajaj       DATE: 04/12/06 ECO: *P4P1* */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 100726.1  By: Roger Xiao */

                {cxcustom.i "TXDETRPB.I"}

                /* DISPLAY OF TAX DETAILS. */
                for each taxdetail by typedesc
                                   by taxclass
                                   by taxusage:


           assign
              l_sign = if tr_type = "25" or tr_type = "21" then
                          -1
                       else
                           1
              taxtotal = taxtotal * l_sign
              taxbase  = taxbase  * l_sign
              nontax   = nontax   * l_sign.

                    if col-80 then do:
/* SS - 100726.1 - B 
                        if page-size - line-counter -
                            (if first_page then page_break else 0) < 3 then do:
                            view frame continue.
                            page.
                            first_page = false.
                        end.

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
   SS - 100726.1 - E */
                    end.
                    else do:
                        assign
                           l-taxdesc  = taxdesc
                           l-taxclass = taxclass
                           l-nontax   = nontax.

/* SS - 100726.1 - B 
                        display
                           typedesc

                   l-taxdesc
                   l-taxclass
                           taxusage
                           taxtotal
                           taxpercnt
                           taxbase

                   l-nontax
                        with frame det_132.
                        down 1 with frame det_132.
   SS - 100726.1 - E */
                        if taxadj <> 0 then do:
/* SS - 100726.1 - B 
                            down with frame det_132.
                            if ar_ap then
                                display "  " + getTermLabel("ABSORBED",22) @ l-taxdesc
                                taxadj @ taxtotal with frame det_132.
                            else
                                display "  " + getTermLabel("RECOVERABLE",22) @ l-taxdesc
                                taxadj @ taxtotal with frame det_132.
                            down with frame det_132.
   SS - 100726.1 - E */
                        end.
                    end.

            if execname <> "soivpst.p" then
            do:
                       {mfrpchk.i &label=mainloop} /* exit if f4 */
            end. /* IF EXECNAME <> "SOIVPST.P" */

{&TXDETRPB-I-TAG1}
                end. /* FOR EACH DETAIL */
