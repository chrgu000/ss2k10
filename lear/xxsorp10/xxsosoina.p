/* sosoina.p - INVOICE GET NEXT INVOICE AND UPDATE SO HEADER            */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
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
{mfdeclre.i}
/*N0WB*/ {cxcustom.i "SOSOINA.P"}
/*N0WB*/ {&SOSOINA-P-TAG1}
define shared variable so_recno as recid.
define shared variable inv_date like ar_date.
/*F348*/ define buffer somstr for so_mstr.
/*F348*/ define shared variable next_inv_nbr like soc_inv.
/*G047*/ define shared variable comb_inv_nbr like so_inv_nbr.
/*G692*/ define shared variable next_inv_pre like soc_inv_pre.
/*G2FD** /*G692*/ define        variable new_inv_nbr  like so_inv_nbr. */
/*G2FD*/ define        variable new_inv_nbr  like so_inv_nbr no-undo.
/*G2FD*/ define        variable l_next_inv_nbr like soc_inv no-undo.
/*G2FD*/ define        variable l_next_inv_pre like soc_inv_pre no-undo.

/*G2FD*/ assign l_next_inv_nbr = next_inv_nbr
/*G2FD*/        l_next_inv_pre = next_inv_pre.

/*F348 Update the sales order header */
do for somstr:
   find somstr where recid(somstr) = so_recno exclusive-lock.
/*N0WB*/ {&SOSOINA-P-TAG2}
/*G047*/ if comb_inv_nbr <> "" then so_inv_nbr = comb_inv_nbr.
   /* Update the sales order based on a variable rather than finding */
   /* and updating (and locking) the sales order control file.       */
/*roger*/   if so_inv_nbr <> "" then do:
       ASSIGN SUBSTRING(so_inv_nbr,1,2) = NEXT_inv_pre.
/*roger*/    END.
   ELSE DO:
/*N0WB*/ {&SOSOINA-P-TAG3}
      repeat:
/*G2FD*/ /* THIS PATCH REPLACES next_inv_nbr and next_inv_pre WITH  LOCAL
        VARIABLES l_next_inv_nbr and l_next_inv_pre ; HAVING NO-UNDO
        PROPERTY TO AVOID GROWING UP OF lbi FILE. */
/*G2FD**
*    next_inv_nbr = next_inv_nbr + 1.
* /*G692** if next_inv_nbr > 99999999 then next_inv_nbr = 1. **/
* /*G692*/ if length(next_inv_pre) + length(string(next_inv_nbr)) > 8
* /*G692*/  then next_inv_nbr = 1.
* /*G692*/ new_inv_nbr = next_inv_pre + string(next_inv_nbr).
* /*G692** if not (                                                    **/
* /*G692**  can-find(somstr where so_domain = global_domain and so_inv_nbr = string(next_inv_nbr))   **/
* /*G692**  or can-find(ar_mstr where ar_domain = global_domain and ar_nbr = string(next_inv_nbr)) ) **/
* /*G692**  then leave.                                                **/
* /*G692*/ if not (
* /*G692*/  can-find(somstr where so_domain = global_domain and so_inv_nbr = new_inv_nbr)
* /*G692*/  or can-find(ar_mstr where ar_domain = global_domain and ar_nbr = new_inv_nbr) )
* /*G692*/  then leave.
**G2FD*/

/*G2FD*/ l_next_inv_nbr = l_next_inv_nbr + 1.
/*G2FD*/ if length(l_next_inv_pre) + length(string(l_next_inv_nbr)) > 8
/*G2FD*/  then l_next_inv_nbr = 1.
/*G2FD*/ new_inv_nbr = l_next_inv_pre + string(l_next_inv_nbr).
/*G2FD*/ if not (
/*G2NZ** /*G2FD*/  can-find(somstr where so_domain = global_domain and so_inv_nbr = new_inv_nbr) */
/*G2NZ*/  can-find(first somstr where so_domain = global_domain and so_inv_nbr = new_inv_nbr)
/*G2FD*/  or can-find(ar_mstr where ar_domain = global_domain and ar_nbr = new_inv_nbr)
/*G2FD*/  or can-find(first ih_hist where ih_domain = global_domain and ih_inv_nbr = new_inv_nbr) )
/*G2FD*/  then leave.
      end. /* end repeat */

/*N0WB*/ {&SOSOINA-P-TAG4}
/*G2FD*/ next_inv_nbr = l_next_inv_nbr.
/*G692** so_inv_nbr = string(next_inv_nbr). **/
/*G692*/ so_inv_nbr = new_inv_nbr.
   end.
   so_to_inv = no.
   so_invoiced = yes.
   so_inv_date = inv_date.

/*J29B*/ if recid(so_mstr) = -1 then .
/*N0WB*/ {&SOSOINA-P-TAG5}
end.
