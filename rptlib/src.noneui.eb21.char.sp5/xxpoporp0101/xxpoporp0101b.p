/* poporpb.p - PURCHASE ORDER REPORT INCLUDE FILE MULTI-DB EXTENSION    */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.9.1.9 $                                                 */

/*V8:ConvertMode=Report                                                 */
/* REVISION: 7.3     LAST MODIFIED: 09/12/95    BY: dxk   *F0V5*        */
/* REVISION: 7.3     LAST MODIFIED: 04/10/96    BY: jzw   *G1LD*        */
/* REVISION: 8.6     LAST MODIFIED: 10/11/97    BY: mur   *K0M3*        */
/* REVISION: 8.6E    LAST MODIFIED: 02/23/98    BY: *L007* A. Rahane    */
/* REVISION: 8.6E    LAST MODIFIED: 10/04/98    BY: *J314* Alfred Tan   */
/* REVISION: 9.1     LAST MODIFIED: 07/07/99    BY: *N00X* Anup Pereira */
/* REVISION: 9.1     LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane*/
/* REVISION: 9.1     LAST MODIFIED: 07/20/00 BY: *N0GF* Mudit Mehta     */
/* REVISION: 9.1     LAST MODIFIED: 08/13/00 BY: *N0KQ* myb             */
/* Revision: 1.9.1.7  BY: Hareesh V. DATE: 06/21/02 ECO: *N1HY* */
/* $Revision: 1.9.1.9 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00J* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*V8:DontRefreshTitle=zz */

/* 以下为版本历史 */
/* SS - 090227.1 By: Ellen Xu */

{mfdeclre.i}

/* SS - 090227.1 - B */
/* 临时表 */
{xxpoporp0101.i}
/* SS - 090227.1 - E */

{gplabel.i} /* EXTERNAL LABEL INCLUDE */

{wbrp02.i}

define shared variable base_amt like pod_pur_cost.
define shared variable base_rpt like po_curr.
define shared variable mixed_rpt like mfc_logical.
define shared variable disp_curr as character format "x(1)".

define shared variable l_currdisp1 as character format "X(20)" no-undo.
define shared variable l_currdisp2 as character format "X(20)" no-undo.

define input parameter ponbr like po_nbr no-undo.
define buffer ship-to for ad_mstr.

{porpfrm.i}

find po_mstr no-lock  where po_mstr.po_domain = global_domain and  po_nbr =
ponbr no-error.
find ad_mstr  where ad_mstr.ad_domain = global_domain and  ad_mstr.ad_addr =
po_vend no-lock no-error.
find ship-to  where ship-to.ad_domain = global_domain and  ship-to.ad_addr =
po_ship no-lock no-error.

if (po_curr <> base_curr)
   and base_rpt = ""
   and not mixed_rpt
   then
      disp_curr = getTermLabel("YES",1).
else
if (po_curr <> base_curr)
   and base_rpt = ""
   and not mixed_rpt
   then
      disp_curr = getTermLabel("YES",1).
else
   disp_curr = "".

/* BUILD DISPLAY TEXT FOR EXCHANGE RATE */
{gprunp.i "mcui" "p" "mc-ex-rate-output"
   "(input  po_curr,
     input  base_curr,
     input  po_ex_rate,
     input  po_ex_rate2,
     input  po_exru_seq,
     output l_currdisp1,
     output l_currdisp2)"}

/*  SS - 090227.1 - B 
    禁止标准输出
clear frame zz no-pause.
display
   po_nbr
   po_vend
   po_ship
   po_ord_date
   ad_mstr.ad_name                                   when (available ad_mstr)
   getTermLabel("ADDRESS_RECORD_NOT_AVAILABLE",28)   when
   (not available ad_mstr) @ ad_mstr.ad_name
   ship-to.ad_name                                   when (available ship-to)
   getTermLabel("ADDRESS_RECORD_NOT_AVAILABLE",28)   when
   (not available ship-to) @ ship-to.ad_name
   po_cr_terms
   ad_mstr.ad_phone                                  when (available ad_mstr)
   ad_mstr.ad_ext                                    when (available ad_mstr)
   ship-to.ad_phone                                  when (available ship-to)
   ship-to.ad_ext                                    when (available ship-to)
   po_buyer
   po_contact
   po_rev
   po_cls_date
   po_stat
   po_curr
   po_blanket
   po_rel_nbr
   l_currdisp1
   l_currdisp2                                      when (l_currdisp2 <> "")
   po_rmks
   disp_curr
with frame zz.
SS - 090227.1 - E  */

/* SS - 090227.1 - B */
EMPTY TEMP-TABLE ttxxpoporp0101a.
CREATE ttxxpoporp0101a.
ASSIGN
   ttxxpoporp0101_po_nbr = po_nbr
   ttxxpoporp0101_po_vend = po_vend
   ttxxpoporp0101_po_ship = po_ship
   ttxxpoporp0101_po_ord_date = po_ord_date
   ttxxpoporp0101_ad_name = ad_mstr.ad_name
   ttxxpoporp0101_ship_name = ship-to.ad_name
   ttxxpoporp0101_po_cr_terms = po_cr_terms
   ttxxpoporp0101_ad_phone = ad_mstr.ad_phone
   ttxxpoporp0101_ad_ext = ad_mstr.ad_ext
   ttxxpoporp0101_ship_phone = ship-to.ad_phone
   ttxxpoporp0101_ship_ext = ship-to.ad_ext
   ttxxpoporp0101_po_buyer = po_buyer
   ttxxpoporp0101_po_contact = po_contact
   ttxxpoporp0101_po_rev = po_rev
   ttxxpoporp0101_po_cls_date = po_cls_date
   ttxxpoporp0101_po_stat = po_stat
   ttxxpoporp0101_po_curr = po_curr
   ttxxpoporp0101_po_blanket = po_blanket
   ttxxpoporp0101_po_rel_nbr = po_rel_nbr
   ttxxpoporp0101_l_currdisp1 = l_currdisp1
   ttxxpoporp0101_l_currdisp2 = l_currdisp2
   ttxxpoporp0101_po_rmks = po_rmks
   ttxxpoporp0101_disp_curr = disp_curr
   .
/* SS - 090227.1 - E */

{wbrp04.i}
