/* GUI CONVERTED from rsrp05a.p (converter v1.75) Sat Aug 12 23:15:23 2000 */
/* rsrp05a.p - Release Management Supplier Schedules                    */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* web convert rsrp05a.p (converter v1.00) Mon Oct 06 14:22:18 1997 */
/* web tag in rsrp05a.p (converter v1.00) Mon Oct 06 14:18:40 1997 */
/*F0PN*/ /*K0PC*/ /*                                                    */
/*V8:ConvertMode=Report                                        */
/* REVISION: 7.0    LAST MODIFIED: 01/29/92           BY: WUG *F110*    */
/* REVISION: 7.3    LAST MODIFIED: 09/25/92           BY: WUG *G094*    */
/* REVISION: 7.3    LAST MODIFIED: 08/09/92           BY: WUG *G462*    */
/* REVISION: 7.3    LAST MODIFIED: 06/01/93           BY: WUG *GB48*    */
/* REVISION: 7.3    LAST MODIFIED: 06/29/93           BY: WUG *GC84*    */
/* REVISION: 7.4    LAST MODIFIED: 11/01/93           BY: WUG *H204*    */
/* REVISION: 7.4    LAST MODIFIED: 01/11/94           BY: WUG *H275*    */
/* REVISION: 8.6    LAST MODIFIED: 10/09/97           BY: GYK *K0PC*    */
/* REVISION: 8.6    LAST MODIFIED: 12/01/98   BY: *K1QY* Pat McCormick  */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00 BY: *N0KP* myb              */

/* SCHEDULE PRINT SUBPROGRAM */


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
/*K0PC*/ {wbrp02.i}

/*K0PC*
def shared var supplier_from like po_vend.
def shared var supplier_to like po_vend.
def shared var shipto_from like po_ship.
def shared var shipto_to like po_ship.
def shared var part_from like pod_part.
def shared var part_to like pod_part.
def shared var po_from like po_nbr.
def shared var po_to like po_nbr.
def shared var buyer_from like po_buyer.
def shared var buyer_to like po_buyer.
def shared var print_zero like mfc_logical.

def var fax_nbr as char format "x(17)".
*K0PC*/
/*K0PC*/ define shared variable supplier_from like po_vend.
/*K0PC*/ define shared variable supplier_to like po_vend.
/*K0PC*/ define shared variable shipto_from like po_ship.
/*K0PC*/ define shared variable shipto_to like po_ship.
/*K0PC*/ define shared variable part_from like pod_part.
/*K0PC*/ define shared variable part_to like pod_part.
/*K0PC*/ define shared variable po_from like po_nbr.
/*K0PC*/ define shared variable po_to like po_nbr.
/*K0PC*/ define shared variable buyer_from like po_buyer.
/*K0PC*/ define shared variable buyer_to like po_buyer.
/*K1QY*/ define shared variable schtype like sch_type initial 4 no-undo.
/*K0PC*/ define shared variable print_zero like mfc_logical.

/*K0PC*/ define variable fax_nbr as character format "x(17)".

/*K0PC*
form with frame phead1.
*K0PC*/
/*K0PC*/ FORM /*GUI*/  with STREAM-IO /*GUI*/  frame phead1 width 132.

mainloop:
for each po_mstr no-lock
where po_nbr >= po_from and po_nbr <= po_to
and po_vend >= supplier_from and po_vend <= supplier_to
and po_buyer >= buyer_from and po_buyer <= buyer_to
and
(po_sch_mthd = "" or po_sch_mthd = "p" or po_sch_mthd = "b"
 or substring(po_sch_mthd,1,1) = "y"               /*H275*/
) /*GC84*/
use-index po_vend,
each pod_det no-lock
where pod_nbr = po_nbr
and pod_sched
and pod_part >= part_from and pod_part <= part_to
/* and pod_nbr >= po_from and pod_nbr <= po_to  *GB48*/
and pod_site >= shipto_from and pod_site <= shipto_to
use-index pod_nbrln,    /*GB48*/
each pt_mstr no-lock where pt_part = pod_part,
each sch_mstr no-lock
/*K1QY**
 *   where sch_type = 4 and sch_nbr = pod_nbr and sch_line = pod_line
 *   and sch_rlse_id = pod_curr_rlse_id[1]
 *K1QY*/

/*K1QY*/ where sch_type = schtype and sch_nbr = pod_nbr and sch_line = pod_line
/*K1QY*/ and sch_rlse_id = pod_curr_rlse_id[schtype - 3]

break by pod_site by po_vend by pod_part by po_nbr:
/*judy 07/07/05*/ /*   {rsrp05.i}*/
/*judy 07/07/05*/   {yyrsrp05.i}
end.
/*K0PC*/ {wbrp04.i}
