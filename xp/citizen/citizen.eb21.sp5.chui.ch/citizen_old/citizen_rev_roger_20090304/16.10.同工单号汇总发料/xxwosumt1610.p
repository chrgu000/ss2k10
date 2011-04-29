/* wosumt.p - WORK ORDER ISSUE SUBSTITUTE PART INTERFACE                      */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.14 $                                                          */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 6.0     LAST MODIFIED: 05/14/90    BY: emb *D025*                */
/* REVISION: 6.0     LAST MODIFIED: 07/06/90    BY: emb *D040*                */
/* REVISION: 6.0     LAST MODIFIED: 10/02/91    BY: emb *D886*                */
/* REVISION: 7.0     LAST MODIFIED: 08/26/92    BY: ram *F867*                */
/* REVISION: 7.3     LAST MODIFIED: 10/19/92    BY: emb *G208*                */
/* REVISION: 7.3     LAST MODIFIED: 10/21/92    BY: emb *G216*                */
/* Revision: 7.3        Last edit: 09/27/93             By: jcd *G247*        */
/* REVISION: 7.3     LAST MODIFIED: 02/08/93    BY: emb *G656*                */
/* REVISION: 7.2     LAST MODIFIED: 04/11/94    BY: ais *FM98*                */
/* Oracle changes (share-locks)    09/13/94           BY: rwl *GM56*          */
/* REVISION: 7.2    LAST MODIFIED: 01/18/95    BY: ais *F0F2*                 */
/* REVISION: 7.3    LAST MODIFIED: 04/26/96    BY: rvw *G1TJ*                 */
/* REVISION: 7.3    LAST MODIFIED: 08/29/96   BY: *G2D9* Julie Milligan       */
/* REVISION: 8.6E   LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane            */
/* REVISION: 8.6E   LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan           */
/* REVISION: 8.6E   LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan           */
/* REVISION: 8.6E   LAST MODIFIED: 10/09/98   BY: *J315* Viswanathan M        */
/* REVISION: 9.1    LAST MODIFIED: 08/12/00   BY: *N0KC* Mark Brown           */
/* REVISION: 9.1    LAST MODIFIED: 09/05/00   BY: *N0K2* Phil DeRogatis       */
/* REVISION: 9.1    LAST MODIFIED: 10/16/00   BY: *N0SX* Jean Miller          */
/* REVISION: 9.1    LAST MODIFIED: 11/06/00   BY: *N0TN* Jean Miller          */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.12  BY: Katie Hilbert DATE: 04/01/01 ECO: *P008* */
/* $Revision: 1.14 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00N* */



/* $MODIFIED BY: softspeed Roger Xiao         DATE: 2008/01/05  ECO: *xp001*  */ /*同nbr一起发料*/
/* $MODIFIED BY: softspeed Roger Xiao         DATE: 2008/01/22  ECO: *xp002*  */ /*加自编单号*/
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */


define input parameter wo-op like wod_op . /*xp001*/

define var v_qty_open like wod_qty_req.
define var vopen like wod_qty_req .
define temp-table xxsub
	field xx_lot like wod_lot 
	field xx_part like wod_part
	field xx_op   like wod_op
	field xx_qty  like wod_qty_req 
	field xx_qty_sub like wod_qty_req .


define temp-table rlswo
		field rls_lot like wo_lot .

define var v_nbr like wo_nbr .







define shared variable wod_recno as recid.
define shared variable part like wod_part.
define shared variable lotserial_qty like sr_qty no-undo.
define variable pts_recno as recid.
define variable open_qty like mrp_qty.
define variable open_qty1 like mrp_qty.
define variable qty_chg like wod_qty_chg.
define variable temp_qty like pk_qty.
define variable temp_qty1 like pk_qty.
define variable inrecno     as recid   no-undo.
define variable msg-counter as integer no-undo.
define buffer woddet for wod_det.

find wod_det where recid(wod_det) = wod_recno no-error.
find wo_mstr no-lock  where wo_mstr.wo_domain = global_domain and  wo_lot =
wod_lot.
v_nbr = wo_nbr .

{swindowa.i &domain="pts_det.pts_domain = global_domain and "
   &file=pts_det
   &framename="c"
   &frame-attr="overlay col 12 row 15 width 67"
   &record-id=pts_recno
   &search=pts_part
   &equality=wod_part
   &other-search="and (pts_par = """" or pts_par = wo_part)"
   &scroll-field=pts_sub
   &create-rec=no
   &update-leave=yes
   &display1=pts_sub
   &display2=pts_par
   &display3=pts_qty_per
   &display4="pts_qty_per * lotserial_qty @ qty_chg"
   }

hide frame c no-pause.

if keyfunction(lastkey) = "end-error" then leave.
find pts_det no-lock where recid(pts_det) = pts_recno no-error.
if not available pts_det then leave.

find pt_mstr no-lock  where pt_mstr.pt_domain = global_domain and  pt_part =
pts_sub no-error.
if not available pt_mstr then leave.


/*************************** start */
assign
    qty_chg = pts_qty_per * lotserial_qty . /*替代料pts_sub,等同发放量*/
	v_qty_open = lotserial_qty . /*已加限制:发放替代料,数量不可为零,否则不会产生pts_sub的wod_det*/

for each xxsub : delete xxsub . end . 
for each rlswo: delete rlswo . end.

for each wo_mstr where wo_domain = global_domain 
				and wo_nbr = v_nbr 
				and (lookup(wo_status,"A,R") <> 0 ) no-lock:
	create rlswo.
	assign rls_lot = wo_lot .
end.

find wod_det where recid(wod_det) = wod_recno no-error.
find wo_mstr no-lock  where wo_mstr.wo_domain = global_domain and  wo_lot = wod_lot.

for each wod_det 
		where wod_domain = global_domain 
		and wod_nbr = wo_nbr 
		and wod_part = pts_part 
		and  (wod_op    = wo-op   or    wo-op     = 0)
		no-lock ,
	each rlswo where rls_lot = wod_lot no-lock
		break by wod_part :

            if wod_qty_req >= 0
            then
               vopen = max(0, wod_qty_req - max(wod_qty_iss,0)).
            else
               vopen = min(0, wod_qty_req - min(wod_qty_iss,0)).

			if vopen >= v_qty_open then vopen = v_qty_open.
			
			if last-of(wod_part) and vopen < v_qty_open then vopen = v_qty_open .


			if vopen <> 0  then do:
					find first xxsub where xx_lot = wod_lot 
									 and xx_part = wod_part
									 and xx_op   = wod_op 
					no-lock no-error .
					if not avail xxsub then do:

						create xxsub.
						assign 
							xx_lot = wod_lot
							xx_part = wod_part
							xx_op = wod_op
							xx_qty = vopen
							xx_qty_sub = vopen * pts_qty_per .
					end.
			end.		

			v_qty_open = max(0,v_qty_open - vopen) .

end. /*for each wod_det :create xxsub. */

for each xxsub no-lock break by xx_lot by xx_part by xx_op :
	find wod_det where wod_domain = global_domain and wod_lot = xx_lot 
				 and wod_part = xx_part and wod_op = xx_op no-error.
	find wo_mstr where wo_mstr.wo_domain = global_domain and  wo_lot = wod_lot no-lock .
	open_qty = xx_qty .
	open_qty1 = xx_qty.

	for each lad_det exclusive-lock  
				where lad_det.lad_domain = global_domain 
				and lad_dataset = "wod_det"
				and lad_nbr = wod_lot 
				and lad_line = string(wod_op)
				and lad_part = wod_part:
	   find ld_det  where ld_det.ld_domain = global_domain 
					and  ld_site = lad_site
					and ld_loc = lad_loc 
					and ld_lot = lad_lot
					and ld_part = lad_part 
	   exclusive-lock no-error.

	   assign
		  lad_qty_all = lad_qty_all + lad_qty_pick
		  lad_qty_pick = 0.

	   if lad_qty_all < 0 and open_qty < 0
	   then temp_qty = max(lad_qty_all,open_qty).
	   else temp_qty = min(lad_qty_all,open_qty).

	   assign
		  open_qty = open_qty - temp_qty
		  lad_qty_all = lad_qty_all - temp_qty.

	   if available ld_det
	   then ld_qty_all = ld_qty_all - temp_qty.
	   {mflddel.i} /*delete ld_det when : ld_qty_oh = 0 and ld_qty_all = 0 */

	   if lad_qty_chg < 0 and open_qty1 < 0
	   then temp_qty1 = max(lad_qty_chg,open_qty1).
	   else temp_qty1 = min(lad_qty_chg,open_qty1).

	   assign
		  open_qty1 = open_qty1 - temp_qty1
		  lad_qty_chg = lad_qty_chg - temp_qty1.

	   if lad_qty_all = 0 then
		  delete lad_det.
	end. /*for each lad_det exclusive-lock */

	find in_mstr where in_mstr.in_domain = global_domain 
				 and  in_part = wod_part
				 and in_site = wod_site 
	no-lock no-error.
	if available in_mstr then do:

	   inrecno = recid(in_mstr).
	   {gplock.i &domain="in_mstr.in_domain = global_domain and "
		  &file-name=in_mstr
		  &find-criteria="recid(in_mstr) = inrecno"
		  &exit-allowed=yes
		  &record-id=recno}

	   if wod_qty_req >= 0
	   then
		  in_qty_req = in_qty_req
					 - min(max(wod_qty_req - wod_qty_iss,0),xx_qty).
	   else
		  in_qty_req = in_qty_req
					 - max(min(wod_qty_req - wod_qty_iss,0),xx_qty).

	   in_qty_all = in_qty_all - wod_qty_all - wod_qty_pick.
	end. /*if available in_mstr*/


	if wod_qty_req >= 0
	then wod_qty_req = max(wod_qty_req - xx_qty,0).
	else wod_qty_req = min(wod_qty_req - xx_qty,0).

	assign
	   wod_qty_pick = 0
	   wod_qty_chg = max(wod_qty_chg - xx_qty,0)
	   wod_qty_all = max(wod_qty_req - wod_qty_pick - wod_qty_iss,0).

	if available in_mstr
	   then in_qty_all = in_qty_all + wod_qty_all.

	wod_bo_chg = wod_qty_req - wod_qty_iss - wod_qty_chg.
	if wod_qty_req >= 0
	then wod_bo_chg = max(wod_bo_chg,0).
	else wod_bo_chg = min(wod_bo_chg,0).

	if wod_qty_req >= 0
	then open_qty = max(wod_qty_req - wod_qty_iss,0).
	else open_qty = min(wod_qty_req - wod_qty_iss,0).

	{mfmrwdel.i "wod_det" wod_part wod_nbr wod_lot """"}

	/* REPLACED PRE-PROCESSOR WITH TERM IN INCLUDE */
	{mfmrw.i "wod_det" wod_part wod_nbr wod_lot string(wod_op)
	   ? wod_iss_date open_qty "DEMAND" WORK_ORDER_COMPONENT wod_site}

	open_qty = xx_qty.
	for each sr_wkfl  
		where sr_wkfl.sr_domain = global_domain 
		and sr_userid = mfguser
		and sr_lineid = string(wod_part,"x(18)") 
			+ string(wod_lot,"x(8)") /*xp001*/ 
			+ string(wod_op)
		exclusive-lock :

	   if sr_qty < 0 and open_qty < 0
		   then temp_qty = max(sr_qty,open_qty).
		   else temp_qty = min(sr_qty,open_qty).

	   assign
		  open_qty = open_qty - temp_qty
		  sr_qty = sr_qty - temp_qty.

	   if sr_qty = 0 then
		  delete sr_wkfl.

	end.


	find wod_det  where wod_det.wod_domain = global_domain 
		and wod_lot  = xx_lot
		and   wod_part = pts_sub
		and   wod_op   = xx_op
		use-index wod_det
	exclusive-lock no-error.

	if not available wod_det then do:

		create wod_det. 
		wod_det.wod_domain = global_domain.

		assign
		wod_lot      = xx_lot
		wod_nbr      = wo_nbr
		wod_part     = pts_sub
		wod_op       = xx_op
		wod_site     = wo_site
		wod_iss_date = wo_rel_date
		wod_qty_chg  = xx_qty_sub .

		if recid(wod_det) = -1 then .

	end. /* IF NOT AVAILABLE wod_det */
	else do:
		wod_qty_chg  = wod_qty_chg + xx_qty_sub .
	end.


end. /*for each xxsub */




/* end ***********************************/
assign
   part = pts_sub_part
   lotserial_qty = qty_chg.
