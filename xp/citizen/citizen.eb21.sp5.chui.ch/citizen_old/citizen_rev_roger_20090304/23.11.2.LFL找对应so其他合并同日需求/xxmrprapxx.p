/* mrprap.p - COMPUTER PLANNED PURCHASE ORDER (REQUISITION) APPROVAL    */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.11.1.11 $                                                         */
/*V8:ConvertMode=Maintenance                                            */
/* REVISION: 1.0      LAST MODIFIED: 06/26/86   BY: EMB                 */
/* REVISION: 1.0      LAST MODIFIED: 12/23/87   BY: EMB                 */
/* REVISION: 4.0      LAST MODIFIED: 05/30/89   BY: EMB *A740           */
/* REVISION: 6.0      LAST MODIFIED: 09/12/90   BY: emb *D040*          */
/* REVISION: 6.0      LAST MODIFIED: 08/15/91   BY: ram *D832           */
/* REVISION: 6.0      LAST MODIFIED: 12/17/91   BY: emb *D966*          */
/* REVISION: 7.3      LAST MODIFIED: 01/06/93   BY: emb *G508*          */
/* REVISION: 7.3      LAST MODIFIED: 09/13/93   BY: emb *GF09* (rev)    */
/* REVISION: 7.5      LAST MODIFIED: 08/09/94   BY: tjs *J014*          */
/* REVISION: 7.3      LAST MODIFIED: 11/09/94   BY: srk *GO05*          */
/* REVISION: 7.5      LAST MODIFIED: 01/01/95   BY: mwd *J034*          */
/* REVISION: 8.5      LAST MODIFIED: 02/11/97   BY: *J1YW* Patrick Rowan      */
/* REVISION: 8.5      LAST MODIFIED: 10/14/97   BY: *G2PT* Felcy D'Souza      */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 07/10/98   BY: *J2QS* Samir Bavkar       */
/* REVISION: 8.5      LAST MODIFIED: 08/12/98   BY: *J2V2* Patrick Rowan      */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KR* myb                */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.11.1.4     BY: Reetu Kapoor   DATE: 05/02/01 ECO: *M162*       */
/* Revision: 1.11.1.6     BY: Sandeep P.     DATE: 08/24/01 ECO: *M1J7*       */
/* Revision: 1.11.1.7     BY: Sandeep P.     DATE: 09/10/01 ECO: *M1KJ*       */
/* Revision: 1.11.1.8  BY: Rajaneesh S. DATE: 08/29/02 ECO: *M1BY* */
/* Revision: 1.11.1.10  BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00J* */
/* $Revision: 1.11.1.11 $ BY: Subramanian Iyer  DATE: 11/24/03 ECO: *P13Q* */


/* $MODIFIED BY: softspeed Roger Xiao         DATE: 2007/12/03  ECO: *xp001*  */  
					/*除ord_pol = "LFL",把计划订单按同零件同止日的合并到一项  */
					/*核准后,找数量刚好匹配的so,记录so_nbr到req_det or rqd_det*/
/* $MODIFIED BY: softspeed Roger Xiao         DATE: 2008/03/28  ECO: *xp002*  */   
                    /*buyer1 ,  loc = in_loc , 同一地点相同供应商的零件且交货库位相同的采购计划才能有相同的采购申请号*/

/* $MODIFIED BY: softspeed Roger Xiao         DATE: 2008/04/22  ECO: *xp003*  */  
					/*加记录so_rmks 到req_det or rqd_det*/
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdtitle.i "1+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE mrprap_p_1 "Include Manufactured Items"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrprap_p_2 "Include Phantoms"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrprap_p_3 "Default Approve"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define new shared variable release_all like mfc_logical
   label {&mrprap_p_3}.
define new shared variable numlines as integer initial 10.
define new shared variable mindwn as integer.
define new shared variable maxdwn as integer.
define new shared variable worecno as recid extent 10 no-undo.
define new shared variable grs_req_nbr like req_nbr no-undo.
define new shared variable grs_approval_cntr as integer no-undo.


define variable show_phantom like mfc_logical
   label {&mrprap_p_2} initial no.
define variable show_mfg like mfc_logical initial no
   label {&mrprap_p_1}.
define variable buyer like pt_buyer.
define variable buyer1 like pt_buyer. /*xp002*/
define var      loc  like pt_loc . /*xp002*/
define variable nbr like req_nbr.
define variable part like mrp_part.
define variable part2 like mrp_part.
define variable rel_date like mrp_rel_date.
define variable rel_date2 like mrp_rel_date.
define variable dwn as integer.
define variable yn like mfc_logical.
define variable site like si_site.
define variable site2 like si_site.
define variable l_part like pt_part no-undo.
define variable l_vend like pt_vend no-undo.
define variable l_cnt  as   integer no-undo.
define variable using_grs like mfc_logical no-undo.

define new shared temp-table tt-rqm-mstr no-undo
    field tt-vend   like rqm_mstr.rqm_vend
	field tt-site   like rqd_det.rqd_site /*xp002*/
	field tt-loc    like rqd_det.rqd_loc  /*xp002*/
    field tt-nbr    like rqm_mstr.rqm_nbr
    field tt-line   like rqd_det.rqd_line
    field tt-part   like rqd_det.rqd_part
    field tt-yn     like mfc_logical
    field tt-wo-nbr like wo_nbr
    field tt-wo-lot like wo_lot
    index vend is primary
       tt-vend
       tt-nbr
       tt-line
    index ttnbrlot
       tt-wo-nbr
       tt-wo-lot
    index ttnbr
       tt-nbr.


/*xp001*/
define var v_qty like wo_qty_ord .

define new shared temp-table xwod_det 
	field xwod_nbr like wo_nbr 
	field xwod_qty like wo_qty_ord .

define new shared temp-table xwo_mstr 
		field xwo_nbr    like wo_nbr
		field xwo_part   like wo_part
		/*field xwo_rel_date like wo_rel_date */
		field xwo_due_date like wo_due_Date
		field xwo_qty      like wo_qty_ord 	
    index partdate is primary
		xwo_part
		xwo_due_date
		xwo_nbr
	.
define var a as integer .
/*xp001*/

/* INPUT OPTION FORM */
form
   part                     colon 15
   /*V8! View-as fill-in size 18 by 1 */
   part2 label {t001.i}     colon 45
   /*V8! View-as fill-in size 18 by 1 */
   buyer                    colon 15
   buyer1                   colon 45
   site                     colon 15
   site2 label {t001.i}     colon 45
   rel_date                 colon 15
   rel_date2 label {t001.i} colon 45 skip(1)

   loc                      colon 36
   release_all              colon 36
   show_phantom             colon 36
   show_mfg                 colon 36
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

assign
   release_all = yes
   site = global_site
   site2 = global_site.

main-loop:
repeat:
   assign
      worecno = ?
      dwn = 0
      mindwn = 1
      maxdwn = 0.

    ststatus = stline[1].
    status input ststatus.

   if part2 = hi_char then part2 = "".
   if buyer1 = hi_char then buyer1 = "".
   if site2 = hi_char then site2 = "".
   if rel_date = low_date then rel_date = ?.
   if rel_date2 = hi_date  then rel_date2 = ?.

   /* GRS INITIALIZATION */
   assign
      l_cnt             = 0
      grs_req_nbr       = ""
      grs_approval_cntr = 0.

   update
      part part2
	  buyer buyer1
      site site2
      rel_date rel_date2
	  loc
      release_all

      show_phantom
      show_mfg
   with frame a
   editing:

      if frame-field = "part"
      then do:

         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp.i wo_mstr part  " wo_mstr.wo_domain = global_domain and wo_part
         "  part wo_part wo_part}

         if recno <> ?
         then do:
            if available wo_mstr
            and wo_joint_type = ""
            then do:
               part = wo_part.
               display part with frame a.
               recno = ?.
            end. /*IF AVAILABLE .......*/
         end. /* IF recno <> ? */
      end. /* IF frame-field = "part" */
      else if frame-field = "part2"
      then do:

         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp.i wo_mstr part2  " wo_mstr.wo_domain = global_domain and wo_part
         "  part2 wo_part wo_part}

         if recno <> ?
         then do:

            if available wo_mstr
            and wo_joint_type = ""
            then do:
               part2 = wo_part.
               display part2 with frame a.
               recno = ?.
            end. /* IF AVAILABLE wo_mstr */
         end. /* IF recno <> ? */
      end. /* ELSE IF */
      else if frame-field = "site"
      then do:

         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp.i si_mstr site  " si_mstr.si_domain = global_domain and si_site
         "  site si_site si_site}

         if recno <> ?
         then
            display si_site @ site with frame a.
      end. /* ELSE IF frame-field .. */
      else if frame-field = "site2"
      then do:

         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp.i si_mstr site2  " si_mstr.si_domain = global_domain and si_site
         "  site2 si_site si_site}

         if recno <> ?
         then
            display si_site @ site2 with frame a.
      end. /* ELSE IF frame-field = "site2" */
      else do:
         ststatus = stline[3].
         status input ststatus.
         readkey.
         apply lastkey.
      end. /* ELSE DO */
   end. /* EDITING */

   status input "".

   if part2 = "" then part2 = hi_char.
   if buyer1 = "" then buyer1 = hi_char .
   if site2 = "" then site2 = hi_char.
   if rel_date = ? then  rel_date = low_date.
   if rel_date2 = ? then rel_date2 = hi_date.

   {gprun.i ""gpsirvr.p""
      "(input site, input site2, output return_int)"}
   if return_int = 0
   then do:
      next-prompt site with frame a.
      undo main-loop, retry main-loop.
   end. /* IF return_int = 0 */

/*xp001 begin*****************************************************/
a = time .
   for each xwo_mstr exclusive-lock:
      delete xwo_mstr.
   end. 

   for each xwod_det exclusive-lock:
      delete xwod_det .
   end. 
for each pt_mstr
		fields (pt_domain pt_part pt_ord_pol pt_pm_code pt_buyer pt_phantom)
		where pt_mstr.pt_domain = global_domain 
		and (pt_part >= part and  pt_part <= part2) no-lock  ,
    each in_mstr
		  fields (in_domain in_site in_part)
		  use-index in_part 
		  where in_mstr.in_domain = global_domain
		  and   in_part  = pt_part
		  and (in_site >= site
		  and  in_site <= site2)
		  and (in_loc = loc or loc = "" )
		  and can-find (first wo_mstr  
					where wo_mstr.wo_domain = global_domain
					and  wo_part = in_part 
					and  wo_site = in_site) 
		no-lock  :


		find ptp_det no-lock
			where ptp_det.ptp_domain = global_domain 
			and  ptp_part = in_part
			and ptp_site = in_site
		no-error.

      if (available ptp_det
         and (ptp_phantom = no    or show_phantom   = yes)
         and (ptp_buyer >= buyer and ptp_buyer <= buyer1 ) 
         and (ptp_pm_code = "P"   or show_mfg       = yes))
         or
         (not available ptp_det
         and (pt_phantom  = no    or show_phantom   = yes)
         and (pt_buyer >= buyer and pt_buyer <= buyer1 ) 
         and (pt_pm_code  = "P"   or show_mfg       = yes)) then
      do:

		  if (available ptp_det and ptp_ord_pol = "LFL" )
			 or
			 (not available ptp_det and pt_ord_pol = "LFL") then
		  next . /*xp001: LFL可直接找到sod_det,不合并*/


         for each wo_mstr 
			  fields (wo_domain wo_part wo_site  wo_nbr  wo_due_date  wo_rel_date wo_status  wo_qty_ord wo_joint_type  )
			  use-index wo_part_rel 
			  where wo_mstr.wo_domain = global_domain
               and wo_part      = in_part
               and wo_site      = in_site
               and wo_rel_date >= rel_date
               and wo_rel_date <= rel_date2
               and wo_status    = "P"
               and wo_joint_type = ""
			    no-lock :

				create xwo_mstr .
				assign  xwo_nbr  = wo_nbr 
						xwo_part = wo_part
						xwo_due_date = wo_due_date 
						xwo_qty  = wo_qty_ord.
				release xwo_mstr.

         end. /* FOR EACH WO_MSTR */
      end. /* IF AVAILABLE PTP_DET */
/**/

end. /* FOR EACH PT_MSTR */
/*message "time_used_1:" string(time - a ,"hh:mm:ss") view-as alert-box.
*/


v_qty  = 0.
for each xwo_mstr use-index partdate break by xwo_part by xwo_due_date by xwo_nbr :
	if first-of(xwo_due_date) then do:
		v_qty  = 0 .
	end. /*if first-of(xwo_due*/

	v_qty  = v_qty + xwo_qty .

	if last-of(xwo_due_date) then do:
			/*产生 每个零件+到期日 的唯一记录*/
			find first xwod_det where xwod_nbr = xwo_nbr no-error .
			if not avail xwod_det then do:
				create  xwod_det .
				assign  xwod_nbr = xwo_nbr 
						xwod_qty = v_qty .
				release xwod_Det .
			end.
			else do:
				xwod_qty = v_qty + xwod_qty .
			end. 
	end. /*if first-of(xwo_due*/
end. /*for each xwo_mstr*/

/*message "time_used_2:" string(time - a ,"hh:mm:ss") view-as alert-box.
*/


/*处理Db数据:留唯一的数据,数量取加总值; 删除其他数据 */
for each xwo_mstr use-index partdate break by xwo_part by xwo_due_date by xwo_nbr :
	find first xwod_det where xwod_nbr = xwo_nbr no-lock no-error .
	if avail xwod_det then do:
		if xwod_qty <> xwo_qty then do:
			find first wo_mstr where wo_nbr = xwo_nbr no-error.
			if available wo_mstr then do:
				wo_qty_ord = xwod_qty .

				find mrp_det exclusive-lock
					where mrp_domain = global_domain
					and   mrp_dataset = "wo_mstr"
					and   mrp_part = wo_part
					and   mrp_nbr  = wo_nbr
					and   mrp_line = wo_lot 
				no-error.
				if available mrp_det then do:
					mrp_qty = wo_qty_ord .
				end.
			end.
		end.
	end. /*if avail xwod_det*/
	else do: /*删除*/
		find wo_mstr exclusive-lock where wo_nbr = xwo_nbr no-error.
		if available wo_mstr then do:

			for each wod_det 
				fields(wod_domain wod_lot wod_nbr  wod_part wod_op wod_site)
				where wod_domain = global_domain
				and   wod_lot = wo_lot
			exclusive-lock:

				find first mrp_det exclusive-lock
					where mrp_domain  = global_domain
					and   mrp_dataset = "wod_det"
					and   mrp_part    = wod_part
					and   mrp_nbr     = wod_nbr
					and   mrp_line    = wod_lot
					and   mrp_line2   = string(wod_op)
				no-error.
				if available mrp_det then delete mrp_det.

				/* UPDATE PART MASTER MRP FLAG */
				{inmrp.i &part=wod_part &site=wod_site}

				delete wod_det.
			end. /*for each wod_det*/

			for each wr_route
				fields( wr_domain wr_lot )
				where wr_domain = global_domain
				and   wr_lot = wo_lot
			exclusive-lock:
				delete wr_route.
			end.

			find mrp_det exclusive-lock
				where mrp_domain = global_domain
				and   mrp_dataset = "wo_mstr"
				and   mrp_part = wo_part
				and   mrp_nbr = wo_nbr
				and   mrp_line = wo_lot 
			no-error.
			if available mrp_det then delete mrp_det.

			find mrp_det exclusive-lock
				where mrp_domain = global_domain
				and   mrp_dataset = "wo_scrap"
				and   mrp_part = wo_part
				and   mrp_nbr = wo_nbr
				and   mrp_line = wo_lot 
			no-error.
			if available mrp_det then delete mrp_det.

			delete wo_mstr.
		end. /*find wo_mstr */
	end . /*删除*/
end. /*for each xwo_mstr*/
/*message "time_used_3:" string(time - a ,"hh:mm:ss") view-as alert-box.
*/


/*xp001 end *************************************************************************************/

   for each tt-rqm-mstr  exclusive-lock:
      delete tt-rqm-mstr.
   end. /* FOR EACH tt-rqm-mstr */

   /* BELOW CODE STARTS WITH THE PT_MSTR AND IN_MSTR TABLES,         */
   /* SELECTING THE RECORDS WITHIN THE SELECTION CRITERIA OF ITEM    */
   /* AND SITE FOR WHICH WO EXISTS. THEN A CHECK IS MADE FOR PURCHASE*/
   /* MANUFACTURE, PHANTOM, BUYER/PLANNER VALUES BEFORE SEARCHING FOR*/
   /* WORK ORDERS WITH A PLANNED STATUS CODE. THIS IS SIGNIFICANTLY  */
   /* FASTER WHEN THERE ARE LARGE NUMBER OF WORK ORDERS AND WHEN     */
   /* BUYER/PLANNER FIELD IS ENTERED IN THE SELECTION CRITERIA.      */

   for each pt_mstr no-lock  where pt_mstr.pt_domain = global_domain and
   (pt_part >= part
                              and  pt_part <= part2),
       each in_mstr no-lock  where in_mstr.in_domain = global_domain and
       in_part  = pt_part
                              and (in_site >= site
                              and  in_site <= site2)
							  and (in_loc = loc or loc = "" )
         and can-find (first wo_mstr  where wo_mstr.wo_domain = global_domain
         and
            wo_part = in_part and wo_site = in_site):

      find ptp_det
         no-lock
          where ptp_det.ptp_domain = global_domain and  ptp_part = in_part
         and ptp_site = in_site
         no-error.

      if (available ptp_det
         and (ptp_phantom = no    or show_phantom   = yes)
         and (ptp_buyer >= buyer and ptp_buyer <= buyer1 ) 
         and (ptp_pm_code = "P"   or show_mfg       = yes))
         or
         (not available ptp_det
         and (pt_phantom  = no    or show_phantom   = yes)
         and (pt_buyer >= buyer and pt_buyer <= buyer1 ) 
         and (pt_pm_code  = "P"   or show_mfg       = yes)) then
      do:

         for each wo_mstr no-lock  where wo_mstr.wo_domain = global_domain and
                   wo_part      = in_part
               and wo_site      = in_site
               and wo_rel_date >= rel_date
               and wo_rel_date <= rel_date2
               and wo_status    = "P"
               and wo_joint_type = ""
               use-index wo_part_rel:

            assign
               dwn = dwn + 1
               maxdwn = maxdwn + 1
               worecno[dwn] = recid(wo_mstr)
               l_part       = pt_part
               l_vend       = if available ptp_det
                              then ptp_vend
                              else pt_vend.


            /* RESTRICTING maxdwn TO 999 AND REASSIGNING dwn TO 0 */
            /* SO THAT DETAIL LINES TO APPROVE WOULD START FROM   */
            /* 1 - 999 FOR THE NEXT SET OF LINES ABOVE 999        */

            /* CREATING TEMP-TABLE tt-rqm-mstr. BASED ON THE RECORDS */
            /* CREATED, CORRESPONDING GRS WILL BE CREATED FOR EACH   */
            /* VENDOR (SUPPLIER)                                     */

            using_grs = can-find(mfc_ctrl
                            where mfc_ctrl.mfc_domain = global_domain and
                            mfc_field   = "grs_installed"
                             and mfc_logical = yes).


            if using_grs
            then do:
               create tt-rqm-mstr.
               assign
                  tt-wo-nbr = wo_nbr
                  tt-wo-lot = wo_lot
                  tt-vend   = l_vend
                  tt-site   = wo_site  /*xp002*/
                  tt-loc    = in_loc  /*xp002*/
                  tt-line   = dwn
                  tt-part   = l_part.
               release tt-rqm-mstr.
            end. /* IF using_grs */

            if dwn = numlines or maxdwn = 999
            then do:

               hide frame a.
               {gprun.i ""xxmrprapaxx.p""}   /*xp001*/ 

               if maxdwn = 999
               then
                  assign
                     mindwn = 1
                     maxdwn = 0.

               if worecno[1] = ?
               then do:
                  worecno = ?.
                  dwn = 0.
                  undo main-loop, next main-loop.
               end. /*IF worecno[1] = ? */

               assign
                  worecno = ?
                  dwn = 0
                  mindwn = maxdwn + 1.
            end. /* IF DWN = NUMLINES */

         end. /* FOR EACH WO_MSTR */
      end. /* IF AVAILABLE PTP_DET */
   end. /* FOR EACH PT_MSTR */

   if dwn <> 0
   then do:
      hide frame a.
      {gprun.i ""xxmrprapaxx.p""}   /*xp001*/ 
      if worecno[1] = ?
      then
         undo main-loop, next main-loop.
   end. /* IF dwn <> 0 */
   else do:
      {pxmsg.i &MSGNUM=307 &ERRORLEVEL=1}
      /* NO MORE PLANNED PURCHASE ORDERS SATISFY CRITERIA */
   end. /* ELSE DO */

   if using_grs
   and grs_req_nbr <> ""
   then do:
      for each tt-rqm-mstr
         where tt-nbr <> ""
           and tt-yn
         no-lock break by tt-vend:
         if last-of(tt-vend)
         then
            l_cnt = l_cnt + 1.
      end. /* FOR EACH tt-rqm-mstr */

      /* PROCEDURE COMPLETE. # REQUISITIONS CREATED */
      {pxmsg.i &MSGNUM=4640 &ERRORLEVEL=1 &MSGARG1=l_cnt}

      for last tt-rqm-mstr
        where tt-nbr <> ""
          and tt-yn
        use-index ttnbr no-lock:
      end. /* FOR LAST tt-rqm-mstr */
      if  available tt-rqm-mstr
      and l_cnt > 0
      then do:
         if l_cnt = 1
         then do:
            /* REQUISITION CREATED. REQUISITION NUMBER IS */
            {pxmsg.i &MSGNUM=2765 &ERRORLEVEL=1 &MSGARG1=tt-rqm-mstr.tt-nbr}
         end. /* IF l_cnt = 1 */
         else do:
            /* LAST REQUISITION CREATED: */
            {pxmsg.i &MSGNUM=4641 &ERRORLEVEL=1 &MSGARG1=tt-rqm-mstr.tt-nbr}
         end. /* ELSE DO */
      end. /* IF AVAILABLE tt-rqm-mstr AND l_cnt > 0 */

   end. /* IF using_grs */

end. /* MAINLOOP */
