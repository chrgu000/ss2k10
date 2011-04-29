/* sosoina.p - INVOICE GET NEXT INVOICE AND UPDATE SO HEADER            */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                 */
/* REVISION: 1.0      LAST MODIFIED: 03/11/86   BY: PML       */
/* REVISION: 7.0      LAST MODIFIED: 04/02/92   BY: afs *F348**/
/* REVISION: 7.3      LAST MODIFIED: 09/04/92   BY: afs *G047**/
/* REVISION: 7.3      LAST MODIFIED: 02/18/93   BY: afs *G692**/
/* REVISION: 7.3      LAST MODIFIED: 09/24/96   BY: *G2FD* Ajit Deodhar */
/* REVISION: 7.3      LAST MODIFIED: 07/23/97   BY: *G2NZ* Seema Varma  */
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6      LAST MODIFIED: 09/14/98   BY: *J29B* Ajit Deodhar */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* myb          */
/* REVISION: 9.1      LAST MODIFIED: 10/09/00   BY: *N0WB* Mudit Mehta  */
/* Revision: 1.7.2.4  BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00L* */
/* $Revision: 1.7.2.5 $ BY: Ed van de Gevel DATE: 12/24/03 ECO: *Q04S* */
/*未作修改,仅清除all eco 信息 ECO:*xp001* */
/*-Revision end---------------------------------------------------------------*/


/*N0WB*/ {cxcustom.i "SOSOINA.P"}
/*N0WB*/ {&SOSOINA-P-TAG1}

{mgdomain.i}
{&SOSOINA-P-TAG6}

define shared variable so_recno as recid.
define shared variable inv_date like ar_date.
define buffer somstr for so_mstr.
define shared variable next_inv_nbr like soc_inv.
define shared variable comb_inv_nbr like so_inv_nbr.
define shared variable next_inv_pre like soc_inv_pre.
define        variable new_inv_nbr  like so_inv_nbr no-undo.
define        variable l_next_inv_nbr like soc_inv no-undo.
define        variable l_next_inv_pre like soc_inv_pre no-undo.

 assign l_next_inv_nbr = next_inv_nbr
        l_next_inv_pre = next_inv_pre.

do for somstr:
   find somstr where recid(somstr) = so_recno exclusive-lock.  {&SOSOINA-P-TAG2}
   
   if comb_inv_nbr <> "" then so_inv_nbr = comb_inv_nbr.
   
   if so_inv_nbr = "" then do:  {&SOSOINA-P-TAG3}
        repeat:
            l_next_inv_nbr = l_next_inv_nbr + 1.

            if length(l_next_inv_pre) + length(string(l_next_inv_nbr,"999999")) > 8 then l_next_inv_nbr = 1.
            new_inv_nbr = l_next_inv_pre + string(l_next_inv_nbr,"999999").

            if not 
            (   can-find(first somstr  where somstr.so_domain = global_domain and (so_inv_nbr = new_inv_nbr))
                or can-find(ar_mstr  where ar_mstr.ar_domain = global_domain and (ar_nbr = new_inv_nbr))
                or can-find(first ih_hist  where ih_hist.ih_domain = global_domain and (  ih_inv_nbr = new_inv_nbr)) 
            )
            then leave.
        end. /* end repeat */

        next_inv_nbr = l_next_inv_nbr.
        so_inv_nbr = new_inv_nbr.
   end.
   so_to_inv = no.
   so_invoiced = yes.
   so_inv_date = inv_date.

   if recid(so_mstr) = -1 then .
end.
