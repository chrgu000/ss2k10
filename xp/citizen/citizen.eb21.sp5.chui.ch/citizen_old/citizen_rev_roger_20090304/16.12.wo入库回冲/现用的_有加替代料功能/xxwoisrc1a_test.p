/* woisrc1a.p - WORK ORDER ISSUE WITH SERIAL NUMBERS                          */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.18 $                                                               */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 6.0      LAST MODIFIED: 06/14/90   BY: emb                       */
/* REVISION: 6.0      LAST MODIFIED: 09/24/91   BY: wug *D858*                */
/* REVISION: 6.0      LAST MODIFIED: 10/07/91   BY: alb *D887*                */
/* REVISION: 6.0      LAST MODIFIED: 11/29/91   BY: ram *D954*                */
/* REVISION: 7.3      LAST MODIFIED: 12/31/92   BY: pma *G382*                */
/* REVISION: 7.3      LAST MODIFIED: 02/08/93   BY: emb *G656*                */
/* REVISION: 7.3      LAST MODIFIED: 03/04/93   BY: ram *G782*                */
/* REVISION: 7.0      LAST MODIFIED: 09/08/94   BY: ais *FQ57*                */
/* REVISION: 7.3      LAST MODIFIED: 09/09/94   BY: qzl *GM01*                */
/* Oracle changes (share-locks)      09/13/94   BY: rwl *GM56*                */
/* REVISION: 7.3      LAST MODIFIED: 10/16/94   BY: qzl *FS45*                */
/* REVISION: 8.5      LAST MODIFIED: 11/22/94   BY: taf *J038*                */
/* REVISION: 7.3      LAST MODIFIED: 12/15/94   BY: qzl *F09T*                */
/* REVISION: 7.3      LAST MODIFIED: 02/03/95   BY: pxd *F0H6*                */
/* REVISION: 7.3      LAST MODIFIED: 02/28/95   BY: ais *F0KS*                */
/* REVISION: 7.2      LAST MODIFIED: 03/07/95   BY: ais *F0LX*                */
/* REVISION: 7.3      LAST MODIFIED: 03/15/95   BY: pxe *F0N7*                */
/* REVISION: 7.3      LAST MODIFIED: 07/03/95   BY: qzl *F0T0*                */
/* REVISION: 7.3      LAST MODIFIED: 05/10/96   BY: rvw *G1V7*                */
/* REVISION: 7.3      LAST MODIFIED: 06/13/96   BY: rvw *G1Y3*                */
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 12/08/98   BY: *J368* Mugdha Tambe       */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 06/06/00   BY: *L0Z1* Kirti Desai        */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KC* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 09/13/00   BY: *L141* Mark Christian     */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.13      BY: Veena Lad        DATE: 11/30/00 ECO: *P008*        */
/* Revision: 1.14      BY: Rajiv Ramaiah    DATE: 12/04/01 ECO: *N16T*        */
/* Revision: 1.15      BY: Hareesh V.       DATE: 09/27/02 ECO: *N1VY*        */
/* Revision: 1.16  BY: Vivek Gogte DATE: 12/03/02 ECO: *N213* */
/* $Revision: 1.18 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00N* */




/* $MODIFIED BY: softspeed Roger Xiao         DATE: 2008/01/16  ECO: *xp001*  */ /*默认倒冲库位*/
/* $MODIFIED BY: softspeed Roger Xiao         DATE: 2008/01/28  ECO: *xp002*  */ /*优先发放替代料*/
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}

define shared variable wo_recno       as recid.
define shared variable fill_all       like mfc_logical.
define shared variable fill_pick      like mfc_logical.
define shared variable wo-op          like wod_op.
define shared variable backflush_qty  like wod_qty_chg.
define shared variable avgissue       like mfc_logical.
define shared variable eff_date       like glt_effdate.
define shared variable default_cancel like mfc_logical.

{woisrc1c.i}

define buffer woddet for wod_det.
define buffer ptmstr for pt_mstr.

define variable tot_lad_all  like lad_qty_all no-undo.
define variable ladqtychg    like lad_qty_all no-undo.
define variable found_reject like mfc_logical no-undo.
define variable issue_pol    like pt_iss_pol  no-undo.
define variable rejected     like mfc_logical no-undo.



define shared var v_loc like loc_loc . /*xp001*/
/*xp002-------*/
define var loc_from     like loc_loc .   
define var lot_from     like ld_lot  .
define var v_qty_oh     like ld_qty_oh .
define var v_qty_pts    like ld_qty_oh .
define var v_qty_flush  like ld_qty_oh .


define shared temp-table xx_Det 
field xx_lot   like wod_lot 
field xx_part  like wod_part 
field xx_op    like wod_op
field xx_qty_req like  wod_qty_req
field xx_qty_chg like  wod_qty_chg
field xx_bo_chg  like  wod_bo_chg
/*field xx_qty_req like  wod_qty_req
field xx_qty_req like  wod_qty_req*/
.


/*-------xp002*/

for first wo_mstr
   fields( wo_domain wo_lot wo_qty_comp wo_qty_ord)
   where recid(wo_mstr) = wo_recno
   no-lock:
end. /* FOR FIRST wo_mstr */

/*xp002****

	quantity-method = 2 : 每个加工单物料清单量
	quantity-method = 3 : 首先虚拟件 --> backflush-method = 1
	quantity-method = 1 : 组件需求量 

	backflush-method = 1 :标准倒冲(std_backflush)
	backflush-method = 2 :净发放与收货(net_backflush)

phantom_first = 3 : default when shared define 
comp_rqd_qty  = 1.
std_backflush = 1.
w_o_bill_qty  = 2.
net_backflush = 2.



message "test_msg" quantity-method backflush-method phantom_first_allowed  view-as alert-box.

****xp002*/

if quantity-method = phantom_first
then
   avgissue = no.
else
   avgissue = yes.


 /*xp002*/

/*---save the old wod_det*/
for each xx_det : delete xx_Det . end.

for each wod_Det 
	where wod_domain = global_domain 
	and  wod_lot = wo_lot	:
	find first xx_Det where xx_lot = wod_det.wod_lot and xx_part = wod_det.wod_part and xx_op = wod_det.wod_op no-error.
	if not avail xx_det then do:
		create xx_det .
		assign xx_lot = wod_det.wod_lot 
			   xx_part = wod_det.wod_part 
			   xx_op = wod_det.wod_op
			   xx_qty_req = wod_det.wod_qty_req
			   xx_qty_chg = wod_det.wod_qty_chg
			   xx_bo_chg  = wod_det.wod_bo_chg .
	end.
end.
/*---end save the old wod_det*/




if backflush_qty > 0 then do:   /*aaa_1*/  

for each wod_det /*aaa_2*/     
	where wod_det.wod_domain = global_domain 
	and  wod_lot = wo_lot
    and   (wod_op = wo-op or wo-op = 0)
	:
	v_qty_pts = 0 .
	v_qty_oh = 0 .
	v_qty_flush = 0 .
	loc_from = if v_loc <> "" then v_loc else wod_loc .
	lot_from = if v_loc <> "" then "" else wod_serial .
	if (wod_det.wod_qty_req ) <= 0 then next. /*负,零需求*/
	if (wod_det.wod_qty_req - wod_det.wod_qty_iss ) <= 0 then next. /*有需求才找替代料*/

	if can-find (first pts_det
		where pts_det.pts_domain = global_domain and (
		pts_part = wod_part
	   and   pts_par  = ""))
	or can-find (first pts_det
		where pts_det.pts_domain = global_domain and
		pts_part = wod_part
	   and   pts_par  = wo_part)
	then do:
		v_qty_oh = 0 .
		for each pts_det
				where pts_det.pts_domain = global_domain 
				and pts_part = wod_part
				and ( pts_par  = "" or  pts_par  = wo_part )
				no-lock break by pts_user1 by pts_part :

				for each ld_det 
						where ld_domain = global_domain 
						and ld_site = wod_site  
						and ld_part = pts_sub_part 
						and ld_loc = loc_from
						no-lock :
					v_qty_oh = ld_qty_oh / pts_qty_per  + v_qty_oh .
				end. /*累加:替代料的有效库存*/

		end. /*for each pts_det*/

		if v_qty_oh <= 0 then next .

		for each ld_det 
				where ld_domain = global_domain 
				and ld_site = wod_site  
				and ld_part = wod_part 
				and ld_loc = loc_from
				no-lock :
			v_qty_oh = ld_qty_oh  + v_qty_oh .
		end.  /*再累加:原料的有效库存*/		

		v_qty_flush = truncate(wod_det.wod_qty_req / wo_qty_ord  * backflush_qty ,7) .

		if v_qty_oh >= v_qty_flush then do:  /*足料*/
			
			/*create 替代料的 wod_det*/
					
			for each pts_det
					where pts_det.pts_domain = global_domain 
					and pts_part = wod_part
					and ( pts_par  = "" or  pts_par  = wo_part )
					no-lock break by pts_user1 by pts_part :
					
					if v_qty_flush <= 0 then leave /*foreach pts_det*/.
					v_qty_pts = 0 .
					
					for each ld_det 
							where ld_domain = global_domain 
							and ld_site = wod_site  
							and ld_part = pts_sub_part 
							and ld_loc = loc_from
							no-lock :
						v_qty_pts = truncate(ld_qty_oh / pts_qty_per  + v_qty_pts ,7) .
					end. /*累加:替代料的有效库存*/

					if v_qty_pts <= 0 then next .	
					else if v_qty_pts >= v_qty_flush then do: /*bbb_1*/
							find first woddet 
								where woddet.wod_domain = global_domain 
								and woddet.wod_lot = wod_det.wod_lot
								and woddet.wod_part = pts_sub_part
								and woddet.wod_op   = wod_det.wod_op
							no-error.
							if not avail woddet then do:

								create woddet .
								assign 
									woddet.wod_domain = global_domain 
									woddet.wod_nbr = wod_det.wod_nbr
									woddet.wod_lot = wod_det.wod_lot
									woddet.wod_part = pts_sub_part
									woddet.wod_op   = wod_det.wod_op
									woddet.wod_site = wod_det.wod_site
									woddet.wod_loc = loc_from
									woddet.wod_iss_date = wod_det.wod_iss_date
									woddet.wod__chr02   = "999"   /*标识替代料*/
									woddet.wod_qty_chg  = truncate(v_qty_flush *  pts_qty_per, 7) 
									/*woddet.wod_bom_qty  = wod_det.wod_bom_qty *  pts_qty_per */ .
							end.
							else do:
								woddet.wod_qty_chg  = woddet.wod_qty_chg + truncate(v_qty_flush *  pts_qty_per ,7) .
							end.


							assign wod_det.wod__dec01 = wod_det.wod__dec01 + v_qty_flush .
							v_qty_flush  = 0 .							

					end.  /*bbb_1*/
					else do:  /*bbb_2*/
							find first woddet 
								where woddet.wod_domain = global_domain 
								and woddet.wod_lot = wod_det.wod_lot
								and woddet.wod_part = pts_sub_part
								and woddet.wod_op   = wod_det.wod_op
							no-error.
							if not avail woddet then do:
								create woddet .
								assign 
									woddet.wod_domain = global_domain 
									woddet.wod_nbr = wod_det.wod_nbr
									woddet.wod_lot = wod_det.wod_lot
									woddet.wod_part = pts_sub_part
									woddet.wod_op   = wod_det.wod_op
									woddet.wod_site = wod_det.wod_site
									woddet.wod_loc = loc_from
									woddet.wod_iss_date = wod_det.wod_iss_date
									woddet.wod__chr02   = "999"  /*标识替代料*/
									woddet.wod_qty_chg  = truncate(v_qty_pts *  pts_qty_per ,7)
									/*woddet.wod_bom_qty  = wod_det.wod_bom_qty *  pts_qty_per */.
							end.
							else do:
								woddet.wod_qty_chg = woddet.wod_qty_chg + truncate(v_qty_pts *  pts_qty_per ,7) .
							end.


							assign wod_det.wod__dec01  = wod_det.wod__dec01  + v_qty_pts   .
							v_qty_flush = max(v_qty_flush - v_qty_pts ,0) .
					end.  /*bbb_2*/
			end. /*for each pts_det*/
		end. /*足料*/
		else do:
			/*加上替代料仍然欠料,不执行任何操作,下面的程式会提示料不足*/
		end.
	end. /* IF CAN-FIND */

end.  /*aaa_2*/ 
end.  /*aaa_1*/ 


release wod_det .
/**/

/*xp002*/
/*---------------------------------------------------------------------------------------------------------------*/







if not avgissue
then do:
   {gprun.i ""wowoisa1.p"" "(input wo_recno, backflush_qty, eff_date)"}
end. /* IF NOT avgissue */


for each wod_det
   fields( wod_domain wod_bom_qty wod_bo_chg wod_loc wod_lot wod_op wod_part
          wod_qty_chg wod_qty_iss wod_qty_req wod_serial wod_site 
		  wod__chr02 wod__dec01 ) /*xp002*/
    where wod_det.wod_domain = global_domain and (  wod_lot = wo_lot
   and   (wod_op = wo-op or wo-op = 0)
   and wod__chr02 = "" /*xp002*/
   ) /*no-lock*/ /*xp002*/ :




   assign
      found_reject = no
      issue_pol    = no.

   for first pt_mstr
      fields( pt_domain pt_iss_pol pt_part pt_um)
       where pt_mstr.pt_domain = global_domain and  pt_part = wod_part
      no-lock:
      issue_pol = pt_iss_pol.
   end. /* FOR FIRST pt_mstr */

   for first ptp_det
      fields( ptp_domain ptp_iss_pol ptp_part ptp_site)
       where ptp_det.ptp_domain = global_domain and  ptp_part = wod_part
      and   ptp_site = wod_site
      no-lock:
      issue_pol = ptp_iss_pol.
   end. /* FOR FIRST ptp_det */

   do for woddet:

      find woddet
         where recid(woddet) = recid(wod_det)
         exclusive-lock no-error.

      /* PHANTOM FIRST WAS HANDLED IN wowoisa1;                     */
      /* NOW DO EVERYTHING ELSE                                     */
      if quantity-method <> phantom_first
      then do:
         if issue_pol = no
         then
            wod_qty_chg = 0.
         else do:

            /* USE STANDARD FORMULA, STANDARD BACKFLUSH                    */

            /* QUANTITY TO ISSUE SHOULD BE CALCULATED BY USING QUANTITY    */
            /* REQUIRED, BACKFLUSH QUANTITY AND WO QUANTITY ORDERED        */
            /* FOR CALCULATING CORRECT QUANTITY TO ISSUE IN CASE           */
            /* OF SUBSTITUTE ITEMS QUANTITY CALCULATION METHOD 'WORK       */
            /* ORDER BILL QTY PER' SHOULD BE USED                          */

            if quantity-method      = comp_rqd_qty
               and backflush-method = std_backflush
            then
               wod_qty_chg = wod_qty_req * backflush_qty / wo_qty_ord - wod__dec01 .

            /* USE STANDARD FORMULA, NET OF PRIOR ISSUES, RECEIPTS   */
            else if quantity-method = comp_rqd_qty
               and backflush-method = net_backflush
            then
               if wod_qty_req > 0
               then
                  wod_qty_chg = max(wod_qty_req * (wo_qty_comp + backflush_qty)
                                / wo_qty_ord - max(wod_qty_iss,0) - wod__dec01 ,0).
               else
                  wod_qty_chg = min(wod_qty_req * (wo_qty_comp + backflush_qty)
                                / wo_qty_ord - min(wod_qty_iss,0)  - wod__dec01 ,0).

            /* USE wod_bom_qty, STANDARD BACKFLUSH                   */
            else if quantity-method = w_o_bill_qty
               and backflush-method = std_backflush
            then
               wod_qty_chg = wod_bom_qty * backflush_qty  - wod__dec01 .

            /* USE wod_bom_qty, NET OF PRIOR ISSUES, RECEIPTS        */
            else if quantity-method = w_o_bill_qty
               and backflush-method = net_backflush
            then
               if wod_qty_req > 0
               then
                  wod_qty_chg = max(wod_bom_qty * (wo_qty_comp + backflush_qty)
                                - max(wod_qty_iss,0)  - wod__dec01 ,0).
               else
                  wod_qty_chg = min(wod_bom_qty * (wo_qty_comp + backflush_qty)
                                - min(wod_qty_iss,0)  - wod__dec01 ,0).
               if wod_qty_chg = ?
               then
                  wod_qty_chg = 0.

               /* TRUNCATE wod_qty_chg TO AVOID ROUNDING ERRORS */
               wod_qty_chg = truncate(wod_qty_chg,7).

         end. /* IF issue_pol = no */

      end. /* IF quantity-method <> phantom_first */

      assign
         wod_bo_chg  = 0
         tot_lad_all = 0
         ladqtychg   = 0.

      if wod_qty_req = 0
      then
         wod_qty_chg = 0.


/*xp001*/
/*******************************
      for each lad_det
         fields( lad_domain lad_dataset lad_line lad_loc lad_lot lad_nbr
         lad_part
                lad_qty_all lad_qty_chg lad_qty_pick lad_ref lad_site)
          where lad_det.lad_domain = global_domain and  lad_dataset = "wod_det"
         and   lad_nbr     = wod_lot
         and   lad_line    = string(wod_op)
         and   lad_part    = wod_part
         exclusive-lock:

         lad_qty_chg = 0.

         for first pt_mstr
            fields( pt_domain pt_iss_pol pt_part pt_um)
             where pt_mstr.pt_domain = global_domain and  pt_part = wod_part
            no-lock:

            if (fill_pick and lad_qty_pick <> 0)
            or (fill_all and lad_qty_all <> 0)
            then do:

               {gprun.i ""icedit2.p""
                  "(input ""ISS-WO"",
                    input lad_site,
                    input lad_loc,
                    input lad_part,
                    input lad_lot,
                    input lad_ref,
                    input lad_qty_chg,
                    input pt_um,
                    input """",
                    input """",
                    output rejected)"}

            end. 
         end.

         if rejected
         then
            do on endkey undo, retry:
               found_reject = yes.
               next.
            end. 

         if fill_pick
         then do:
            assign
               lad_qty_chg = min(lad_qty_pick,wod_qty_chg - ladqtychg)
               ladqtychg   = ladqtychg + lad_qty_chg.
         end. 

         if fill_all
         then do:
            assign
               lad_qty_chg = lad_qty_chg
                             + min(lad_qty_all, wod_qty_chg - ladqtychg)
               ladqtychg   = ladqtychg
                             + min(lad_qty_all, wod_qty_chg - ladqtychg).
         end. 

      end. 
************************************************/

/*add***********************************************/
      for each lad_det
         fields( lad_domain lad_dataset lad_line lad_loc lad_lot lad_nbr
         lad_part
                lad_qty_all lad_qty_chg lad_qty_pick lad_ref lad_site)
          where lad_det.lad_domain = global_domain and  lad_dataset = "wod_det"
         and   lad_nbr     = wod_lot
         and   lad_line    = string(wod_op)
         and   lad_part    = wod_part
         exclusive-lock:

		 delete lad_det .

      end. /*for each lad_det*/

/*end***********************************************/
/*xp001*/

      if wod_qty_chg <> ladqtychg
      then do:

         for first pt_mstr
            fields( pt_domain pt_iss_pol pt_part pt_um)
             where pt_mstr.pt_domain = global_domain and  pt_part = wod_part
            no-lock:

  /*xp001*/
if v_loc <> "" then do:
            find lad_det
                where lad_det.lad_domain = global_domain and  lad_dataset =
                "wod_det"
               and   lad_nbr     = wod_lot
               and   lad_line    = string(wod_op)
               and   lad_part    = wod_part
               and   lad_site    = wod_site
               and   lad_loc     = v_loc  /*xp001*/
               and   lad_lot     = ""   /*xp001*/
               exclusive-lock no-error.

            if not available lad_det
            then do:
               create lad_det. lad_det.lad_domain = global_domain.
               assign
                  lad_dataset = "wod_det"
                  lad_nbr     = wod_lot
                  lad_line    = string(wod_op)
                  lad_part    = wod_part
                  lad_site    = wod_site
                  lad_loc     = v_loc
                  lad_lot     = "".
            end. /* IF NOT AVAILABLE lad_det */

            {gprun.i ""icedit2.p""
               "(input ""ISS-WO"",
                 input wod_site,
                 input v_loc,
                 input wod_part,
                 input """",
                 input """",
                 input wod_qty_chg - ladqtychg +
                       if available lad_det
                       then
                          lad_qty_chg
                       else
                          0,
                 input if available pt_mstr
                       then
                          pt_um
                       else
                          """",
                 input """",
                 input """",
                 output rejected)"}
end.
else do:
            find lad_det
                where lad_det.lad_domain = global_domain and  lad_dataset =
                "wod_det"
               and   lad_nbr     = wod_lot
               and   lad_line    = string(wod_op)
               and   lad_part    = wod_part
               and   lad_site    = wod_site
               and   lad_loc     = wod_loc
               and   lad_lot     = wod_serial
               exclusive-lock no-error.

            if not available lad_det
            then do:
               create lad_det. lad_det.lad_domain = global_domain.
               assign
                  lad_dataset = "wod_det"
                  lad_nbr     = wod_lot
                  lad_line    = string(wod_op)
                  lad_part    = wod_part
                  lad_site    = wod_site
                  lad_loc     = wod_loc
                  lad_lot     = wod_serial.
            end. /* IF NOT AVAILABLE lad_det */

            {gprun.i ""icedit2.p""
               "(input ""ISS-WO"",
                 input wod_site,
                 input wod_loc,
                 input wod_part,
                 input wod_serial,
                 input """",
                 input wod_qty_chg - ladqtychg +
                       if available lad_det
                       then
                          lad_qty_chg
                       else
                          0,
                 input if available pt_mstr
                       then
                          pt_um
                       else
                          """",
                 input """",
                 input """",
                 output rejected)"}

end.
  /*xp001*/
			
			if rejected
            then
               found_reject = yes.

            assign
               lad_qty_chg = lad_qty_chg + wod_qty_chg - ladqtychg
               ladqtychg   = wod_qty_chg.

         end. /* FOR FIRST pt_mstr */

      end. /* IF wod_qty_chg <> ladqtychg */

      wod_qty_chg = ladqtychg.


	  assign wod_qty_req = max(wod_qty_req - wod__dec01, 0 ).  /*xp002*/
		     wod__dec01 = 0 .  /*xp002*/

      if default_cancel
      then
         wod_bo_chg = 0.
      else if wod_qty_req >= 0
      then
         wod_bo_chg = max(0, wod_qty_req - max(wod_qty_iss, 0) - wod_qty_chg).
      else
         wod_bo_chg = min(0, wod_qty_req - min(wod_qty_iss, 0) - wod_qty_chg).

      if found_reject
      then
         do on endkey undo, retry:
         /* UNABLE TO ISSUE OR RECEIVE FOR ITEM: # */
         {pxmsg.i &MSGNUM=161 &ERRORLEVEL=2 &MSGARG1=wod_part}
      end. /* IF found_reject */

   end. /* DO FOR woddet */

end. /* FOR EACH wod_det */


/*xp002* 替代料wod__chr02 = "999"部分create lad_Det *********/

for each wod_det
   fields( wod_domain wod_bom_qty wod_bo_chg wod_loc wod_lot wod_op wod_part
          wod_qty_chg wod_qty_iss wod_qty_req wod_serial wod_site 
		  wod__chr02 wod__dec01 ) /*xp002*/
    where wod_det.wod_domain = global_domain and (  wod_lot = wo_lot
   and   (wod_op = wo-op or wo-op = 0)
   and wod__chr02 = "999" /*xp002*/   ) :

   ladqtychg = 0 .
   if wod_qty_chg = 0  then next .

   do for woddet:

      find woddet
         where recid(woddet) = recid(wod_det)
         exclusive-lock no-error.


      for each lad_det
         fields( lad_domain lad_dataset lad_line lad_loc lad_lot lad_nbr
         lad_part
                lad_qty_all lad_qty_chg lad_qty_pick lad_ref lad_site)
          where lad_det.lad_domain = global_domain and  lad_dataset = "wod_det"
         and   lad_nbr     = wod_lot
         and   lad_line    = string(wod_op)
         and   lad_part    = wod_part
         exclusive-lock:

		 delete lad_det .

      end. /*for each lad_det*/


         for first pt_mstr
            fields( pt_domain pt_iss_pol pt_part pt_um)
             where pt_mstr.pt_domain = global_domain and  pt_part = wod_part
            no-lock:

  /*xp001*/
if v_loc <> "" then do:
            find lad_det
                where lad_det.lad_domain = global_domain and  lad_dataset =
                "wod_det"
               and   lad_nbr     = wod_lot
               and   lad_line    = string(wod_op)
               and   lad_part    = wod_part
               and   lad_site    = wod_site
               and   lad_loc     = v_loc  /*xp001*/
               and   lad_lot     = ""   /*xp001*/
               exclusive-lock no-error.

            if not available lad_det
            then do:
               create lad_det. lad_det.lad_domain = global_domain.
               assign
                  lad_dataset = "wod_det"
                  lad_nbr     = wod_lot
                  lad_line    = string(wod_op)
                  lad_part    = wod_part
                  lad_site    = wod_site
                  lad_loc     = v_loc
                  lad_lot     = "".
            end. /* IF NOT AVAILABLE lad_det */

            {gprun.i ""icedit2.p""
               "(input ""ISS-WO"",
                 input wod_site,
                 input v_loc,
                 input wod_part,
                 input """",
                 input """",
                 input wod_qty_chg - ladqtychg +
                       if available lad_det
                       then
                          lad_qty_chg
                       else
                          0,
                 input if available pt_mstr
                       then
                          pt_um
                       else
                          """",
                 input """",
                 input """",
                 output rejected)"}
end.
else do:
            find lad_det
                where lad_det.lad_domain = global_domain and  lad_dataset =
                "wod_det"
               and   lad_nbr     = wod_lot
               and   lad_line    = string(wod_op)
               and   lad_part    = wod_part
               and   lad_site    = wod_site
               and   lad_loc     = wod_loc
               and   lad_lot     = wod_serial
               exclusive-lock no-error.

            if not available lad_det
            then do:
               create lad_det. lad_det.lad_domain = global_domain.
               assign
                  lad_dataset = "wod_det"
                  lad_nbr     = wod_lot
                  lad_line    = string(wod_op)
                  lad_part    = wod_part
                  lad_site    = wod_site
                  lad_loc     = wod_loc
                  lad_lot     = wod_serial.
            end. /* IF NOT AVAILABLE lad_det */

            {gprun.i ""icedit2.p""
               "(input ""ISS-WO"",
                 input wod_site,
                 input wod_loc,
                 input wod_part,
                 input wod_serial,
                 input """",
                 input wod_qty_chg - ladqtychg +
                       if available lad_det
                       then
                          lad_qty_chg
                       else
                          0,
                 input if available pt_mstr
                       then
                          pt_um
                       else
                          """",
                 input """",
                 input """",
                 output rejected)"}

end.
  /*xp001*/
			
			if rejected
            then
               found_reject = yes.

            assign
               lad_qty_chg = lad_qty_chg + wod_qty_chg - ladqtychg.

         end. /* FOR FIRST pt_mstr */


      if found_reject
      then
         do on endkey undo, retry:
         /* UNABLE TO ISSUE OR RECEIVE FOR ITEM: # */
         {pxmsg.i &MSGNUM=161 &ERRORLEVEL=2 &MSGARG1=wod_part}
      end. /* IF found_reject */

   end. /* DO FOR woddet */

end. /* FOR EACH wod_det */


/**********xp002*/