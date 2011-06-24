/* mrprapa.p - APPROVE PLANNED PURCHASE ORDERS 1st subroutine           */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.41 $                                                        */
/* REVISION: 1.0     LAST MODIFIED: 05/09/86    BY: EMB      */
/* REVISION: 1.0     LAST MODIFIED: 10/24/86    BY: EMB *37* */
/* REVISION: 2.0     LAST MODIFIED: 03/06/87    BY: EMB *A39* */
/* REVISION: 2.1     LAST MODIFIED: 06/15/87    BY: WUG *A67* */
/* REVISION: 2.1     LAST MODIFIED: 09/18/87    BY: WUG *A94* */
/* REVISION: 2.1     LAST MODIFIED: 12/22/87    BY: emb       */
/* REVISION: 4.1     LAST MODIFIED: 07/14/88    BY: emb *A322**/
/* REVISION: 4.1     LAST MODIFIED: 09/06/88    BY: emb *A420**/
/* REVISION: 4.1     LAST MODIFIED: 01/24/89    BY: emb *A621**/
/* REVISION: 4.1     LAST MODIFIED: 05/30/89    BY: emb *A740**/
/* REVISION: 4.1     LAST MODIFIED: 01/08/90    BY: emb *A800**/
/* REVISION: 5.0     LAST MODIFIED: 11/10/89    BY: emb *B389**/
/* REVISION: 6.0     LAST MODIFIED: 07/06/90    BY: emb *D040**/
/* REVISION: 6.0     LAST MODIFIED: 01/29/91    BY: bjb *D248**/
/* REVISION: 6.0     LAST MODIFIED: 08/15/91    BY: RAM *D832**/
/* REVISION: 6.0     LAST MODIFIED: 12/17/91    BY: emb *D966**/
/* REVISION: 7.0     LAST MODIFIED: 08/28/91    BY: MLV *F006**/
/* REVISION: 7.0     LAST MODIFIED: 10/17/91    BY: emb *F024**/
/* REVISION: 7.0     LAST MODIFIED: 12/09/91    BY: RAM *F033**/
/* REVISION: 7.3     LAST MODIFIED: 01/06/93    BY: emb *G508**/
/* REVISION: 7.3     LAST MODIFIED: 09/13/93    BY: emb *GF09**/
/* REVISION: 7.3     LAST MODIFIED: 09/01/94    BY: ljm *FQ67**/
/* Oracle changes (share-locks)     09/12/94    BY: rwl *GM39**/
/* REVISION: 7.3     LAST MODIFIED: 09/20/94    BY: jpm *GM74**/
/* REVISION: 7.3     LAST MODIFIED: 11/09/94    BY: srk *GO05**/
/* REVISION: 7.3     LAST MODIFIED: 10/16/95    BY: emb *G0ZK**/
/* REVISION: 8.5     LAST MODIFIED: 10/16/96    BY: *J164* Murli Shastri */
/* REVISION: 8.5     LAST MODIFIED: 02/11/97    BY: *J1YW* Patrick Rowan */
/* REVISION: 8.6E    LAST MODIFIED: 02/23/98    BY: *L007* A. Rahane     */
/* REVISION: 8.6E    LAST MODIFIED: 05/20/98    BY: *K1Q4* Alfred Tan    */
/* REVISION: 8.5     LAST MODIFIED: 07/30/98    BY: *J2V2* Patrick Rowan */
/* REVISION: 8.6E    LAST MODIFIED: 10/04/98    BY: *J314* Alfred Tan    */
/* REVISION: 9.0     LAST MODIFIED: 11/06/98    BY: *J33S* Sandesh Mahagaokar */
/* REVISION: 9.0     LAST MODIFIED: 03/13/99    BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1     LAST MODIFIED: 10/01/99    BY: *N014* Patti Gaultney     */
/* REVISION: 9.1     LAST MODIFIED: 10/19/99    BY: *K23S* John Corda         */
/* REVISION: 9.1     LAST MODIFIED: 03/24/00    BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1     LAST MODIFIED: 08/13/00    BY: *N0KR* myb                */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.24     BY: Reetu Kapoor        DATE: 05/02/01 ECO: *M162*      */
/* Revision: 1.27     BY: Thomas Fernandes    DATE: 05/30/01 ECO: *L17S*      */
/* Revision: 1.28     BY: Niranjan R.         DATE: 07/23/01 ECO: *P00L*      */
/* Revision: 1.30     BY: Sandeep P.          DATE: 08/24/01 ECO: *M1J7*      */
/* Revision: 1.31     BY: Sandeep P.          DATE: 09/10/01 ECO: *M1KJ*      */
/* Revision: 1.33     BY: Mercy Chittilapilly DATE: 08/26/02 ECO: *N1RX*      */
/* Revision: 1.34     BY: Rajaneesh S.        DATE: 08/29/02 ECO: *M1BY*      */
/* Revision: 1.35     BY: Vandna Rohira       DATE: 01/21/03 ECO: *N24S*      */
/* Revision: 1.37     BY: Paul Donnelly (SB)  DATE: 06/28/03 ECO: *Q00J*      */
/* Revision: 1.39     BY: Katie Hilbert       DATE: 01/08/04 ECO: *P1J4*      */
/* $Revision: 1.41 $       BY: Swati Sharma        DATE: 07/30/04 ECO: *P2CW*      */
/*By: Neil Gao 08/06/30 ECO: *SS 20080630* */

/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*V8:ConvertMode=Maintenance                                                  */

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

{pxmaint.i}

define shared variable release_all       like mfc_logical.
define shared variable worecno           as recid extent 10 no-undo.
define shared variable numlines          as integer initial 10.
define shared variable mindwn            as integer.
define shared variable maxdwn            as integer.
define shared variable grs_req_nbr       like req_nbr no-undo.
define shared variable grs_approval_cntr as integer no-undo.

define variable nbr             like req_nbr           no-undo.
define variable dwn             like pod_line          no-undo.
define variable wonbrs          as character extent 10 no-undo.
define variable wolots          as character extent 10 no-undo.
define variable yn              like mfc_logical column-label "Y" no-undo.
define variable flag            as integer initial 0   no-undo.
define variable line            like req_line          no-undo.
define variable i               as integer             no-undo.
define variable nonwdays        as integer             no-undo.
define variable overlap         as integer             no-undo.
define variable workdays        as integer             no-undo.
define variable interval        as integer             no-undo.
define variable frwrd           as integer             no-undo.
define variable know_date       as date                no-undo.
define variable find_date       as date                no-undo.
define variable approve         like mfc_logical extent 10    no-undo.
define variable grs_return_code as   integer           no-undo.
define variable remarks_text    like rqm_rmks          no-undo.
define variable l_req_nbr       like rqm_mstr.rqm_nbr  no-undo.
define variable l_approve_ctr   as   integer           no-undo.
define variable l_displayed     like mfc_logical       no-undo.
define variable using_grs       like mfc_logical       no-undo.
/* ss 20071107 - b */
define var sonbr like so_nbr.
define var sonbrext like so_nbr extent 10.
define var wolotext like wo_lot extent 10.
define var vend like po_vend.
define var vendext like po_vend extent 10.
define var expert as logical format "Y/N".
define var expertext like expert extent 10.
define buffer womstr for wo_mstr.
define var tmpqty1 like tr_qty_loc.
define var tmpqty2 like tr_qty_loc.

/* ss 20080126 - b */
define var tmpdate1 as date.
define var tmpdate2 as date.
/* ss 20080126 - e */

define shared temp-table xxtb
	field xxtb_nbr  like wo_nbr
	field xxtb_vend like po_vend
	field xxtb_part like pt_part
	field xxtb_qty  like tr_qty_loc
	field xxtb_wolot like wo_lot
	index xxtb_wolot 
				xxtb_wolot.

/* ss 20071211 - e */
define shared var cfall as int.
/* ss 20071211 - b */

/* ss 20071226 - b */
define var sodnbr like sod_nbr.
define var sodline like sod_line.
define var reqnbrs as character extent 10.
define var reqzd   as logical   extent 10. /* 判断是否配套 */
/* ss 20071226 - e */

form
   dwn
   nbr
	 sonbr
	 vend
	 expert
   wo_part
   wo_qty_ord
   wo_due_date
   yn format "Y/N"
with frame d.
/* ss 20071107 - e */

/* SET EXTERNAL LABELS */
setFrameLabels(frame d:handle).

remarks_text = getTermLabel("MRP_PLANNED_ORDER",23).

for first gl_ctrl no-lock:
end. /* FOR FIRST gl_ctrl */

assign
    using_grs    = can-find(mfc_ctrl where
                      mfc_field = "grs_installed" and
                      mfc_logical = yes)
   l_approve_ctr = 0
   l_displayed   = no
   approve       = release_all.

/* GET NEXT GRS REQUISITION NBR IF RELEASE_ALL = YES */


do transaction on error undo, retry:
   mainloop:
   repeat:
			
      /*V8-*/
      do dwn = mindwn to maxdwn
         with frame b 10 down width 80 no-attr-space:
      /*V8+*/
      /*V8!
      do dwn = mindwn to maxdwn
         with frame b 10 down width 80 attr-space bgcolor 8:   */

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame b:handle).
/*
         wonbrs[dwn - mindwn + 1] = "".
         wolots[dwn - mindwn + 1] = "".
         sonbrext[dwn - mindwn + 1] = "".
         vendext[dwn - mindwn + 1] = "".
         expertext[dwn - mindwn + 1] = no.
*/

         /* DISPLAY DETAIL */
         if worecno[dwn - mindwn + 1] <> ?
         then do with frame b:

            for first wo_mstr
               fields (wo_due_date wo_lot wo_nbr wo_part
                       wo_qty_ord wo_rel_date wo_site)
               where recid(wo_mstr) = worecno[dwn - mindwn + 1]
            no-lock:
            end. /* FOR FIRST wo_mstr */

            if available wo_mstr
            then do with frame b:

               /* CHECK AND SET THE APPROVAL FLAG FOR INDIVIDUAL WORK ORDER   */
               /* LINES WHEN DEFAULT APPROVAL FLAG (release_all) IS SET TO NO */
               /* BUT ONLY FOR THE FIRST ITERATION                            */

               if l_displayed = no
                  and release_all
               then do:

                  /* GET THE ITEM STATUS and CHECK IF IT HAS A RESTRICTED */
                  /* TRANSACTION 'ADD-PO'                                 */

                  for first pt_mstr
                     fields( pt_part pt_status pt_rev)
                      where pt_part = wo_part
                     no-lock:

                     /* ADDED THIRD INPUT PARAMETER, TO INDICATE THAT  */
                     /* THE MESSAGE SHOULD NOT BE DISPLAYED            */
                     {pxrun.i &PROC='validateRestrictedStatus'
                              &PROGRAM='ppitxr.p'
                              &PARAM="(input pt_status,
                                       input 'ADD-PO',
                                       input no)"
                              &NOAPPERROR=True
                              &CATCHERROR=True}

                     if return-value <> {&SUCCESS-RESULT}
                     then do:
                        assign
                           approve[dwn - mindwn + 1] = no
                           l_approve_ctr             = l_approve_ctr + 1.

                     end. /* IF return-value <> {&SUCCESS-RESULT} */

                  end. /* FOR FIRST pt_mstr */

               end. /* IF l_displayed = NO AND release_all */

               /* DISPLAY GRS REQUISITION NBR IF APPROVE = YES */
               
               wonbrs[dwn - mindwn + 1] = wo_nbr.
               wolots[dwn - mindwn + 1] = wo_lot.
               
/* ss 20071226 - b */
               	sodnbr = "".
               	if index(wo_mstr.wo_so_job,"&") > 0 then do:
              		
              	end.
              	else do:
              		sodnbr = wo_so_job.
              		sodline = wo__dec02.
              		wolotext[dwn - mindwn + 1] = sodnbr.
              	end.
              	sonbrext[dwn - mindwn + 1] = sodnbr.
              	
              	if reqnbrs[dwn - mindwn + 1] = "" then do:
              		nbr = "".
              		
              		{mfnctrla.i 
                    woc_ctrl woc_nbr req_det req_nbr nbr}
                    loop-a:
                    repeat:
                        do-a:
                        do:
                           do i = mindwn to maxdwn:
                              if i <> dwn
                                 and nbr = reqnbrs[i - mindwn + 1]
                                 then
                                    leave do-a.
                           end.
                           if not can-find(first req_det
                               where req_nbr = nbr)
                           then
                              leave loop-a.
                        end.
                        nbr = string(integer(nbr) + 1).
                		end.
                		reqnbrs[dwn - mindwn + 1] = nbr.
              	end.
              	
               
               sonbr = sonbrext[dwn - mindwn + 1].
               vend  = vendext[dwn - mindwn + 1].
               expert = expertext[dwn - mindwn + 1].
               reqzd[dwn - mindwn + 1] = no.

								if month(today) <= 2 then do:
									tmpdate1 = date(month(today) + 10,1,year(today) - 1).
								end.
								else do:
									tmpdate1 = date(month(today) - 2,1,year(today)).
								end.

								tmpdate2 = today.
								if wo_part begins "14031" and vend = "" then do:
									find first xxtb where xxtb_part begins "14030" and xxtb_wolot = wolotext[dwn - mindwn + 1] no-lock no-error.
									if avail xxtb then assign vend = xxtb_vend .
								end.
               
               if vend  = "" then do:
									
									{gprunp.i "xxvdpct" "P" "getvend"
         										"( 	input wo_part,
            										input tmpdate1,
            										input tmpdate2,
            										input wo_qty_ord,
            										output vend
          									 )"}
 								              
               end.

               vendext[dwn - mindwn + 1]  = vend.
               
               if vend = "" then approve[dwn - mindwn + 1] = no.
               
                  display
                     dwn
                     reqnbrs[dwn - mindwn + 1] @ nbr
                     sonbr
                     vend
                     expert label "批"
                     wo_part
                     wo_qty_ord
                     /*wo_rel_date label "Rel Date"*/
                     wo_due_date
                     approve[dwn - mindwn + 1] @ yn.
            end.
         end.
      end.

      /* NOTIFY THE USER WHEN ANY OF THE ITEM IS NOT APPROVED (BECAUSE OF */
      /* 'ADD_PO' RESTRICTION) THOUGH THE DEFAULT APPROVAL IS SET TO YES  */

      if l_displayed        = no
         and release_all
         and l_approve_ctr <> 0
      then do:

         /* APPROVAL SET TO NO FOR ITEM(S) WITH RESTRICTED TRANSACTION #  */
         {pxmsg.i &MSGNUM    =5595
                  &ERRORLEVEL=2
                  &MSGARG1   =""ADD-PO""}

      end. /* IF l_displayed */

      /* l_displayed IS SET TO YES AS CHECKING/SETTING OF APPROVAL FLAG */
      /* BASED ON RESTRICTED TRANSACTION IS NO LONGER REQUIRED          */

      assign
         l_displayed = yes
         nbr         = "".

      do on error undo, leave:
         do on error undo, retry:

            dwn = mindwn - 1.
            clear frame d.
            /*V8-*/

						if cfall <> 999 then
            set dwn with frame d width 80 no-attr-space
            editing:
            /*V8+*/
            /*V8!
            set dwn with frame d width 80 attr-space three-d editing:
            */
               
               {mfnarray.i dwn mindwn maxdwn}

               display dwn with frame d.

               if dwn >= mindwn and dwn <= maxdwn
                  and wonbrs[dwn - mindwn + 1] <> ""
                  then do:
                  for first wo_mstr
                     fields (wo_due_date wo_lot wo_nbr wo_part
                             wo_qty_ord wo_rel_date wo_site)
                     where recid(wo_mstr) = worecno[dwn - mindwn + 1]
                  no-lock:
                  end. /* FOR FIRST wo_mstr */

                  if available wo_mstr
                  then do:

                    	/* DISPLAY GRS REQUISITION NBR IF APPROVE = YES */
                        display
                           dwn
                           reqnbrs[dwn - mindwn + 1] @ nbr
                           sonbrext[dwn - mindwn + 1] @ sonbr
                           vendext[dwn - mindwn + 1] @ vend
                           expertext[dwn - mindwn + 1] @ expert label "批"
                           wo_part
                           wo_qty_ord
                           /*wo_rel_date*/
                           wo_due_date
                           approve[dwn - mindwn + 1] @ yn
                        with frame d.
                  end. /* IF AVAILABLE(wo_mstr) ... */
                  else do:
                      /* PLANNED PURCHASE ORDER NUMBER DOES NOT EXIST. */
                      {pxmsg.i &MSGNUM=308 &ERRORLEVEL=3}
                      undo, retry.
                  end. /* ELSE - NOT AVAILABLE wo_mstr */

               end.
            end.
            if cfall <> 999 then cfall = dwn.

            if input dwn <> 0 and ((dwn < mindwn or dwn > maxdwn)
               or (dwn >= mindwn and dwn <= maxdwn
               and wonbrs[dwn - mindwn + 1] = ""))
							 and dwn <> 999
            then do:
               /* MUST SELECT A NUMBER LISTED ABOVE. */
               {pxmsg.i &MSGNUM=18 &ERRORLEVEL=3}
               undo, retry.
            end.
         end.

         if dwn >= mindwn and dwn <= maxdwn
         then do:

            for first wo_mstr
               fields (wo_due_date wo_lot wo_nbr wo_part
                       wo_qty_ord wo_rel_date wo_site)
               where recid(wo_mstr) = worecno[dwn - mindwn + 1]
            no-lock:
            end. /* FOR FIRST wo_mstr */

            if not available wo_mstr
            then do:
               /* PLANNED PURCHASE ORDER NUMBER DOES NOT EXIST. */
               {pxmsg.i &MSGNUM=308 &ERRORLEVEL=3}
               undo, retry.
            end.
            else do:
               
               /* DISPLAY GRS REQUISITION NBR IF APPROVE = YES */
                  display
                     dwn
                     reqnbrs[dwn - mindwn + 1] @ nbr
                     sonbrext[dwn - mindwn + 1] @ sonbr
                     vendext[dwn - mindwn + 1] @ vend
                     expertext[dwn - mindwn + 1] @ expert label "批"
                     wo_part
                     wo_qty_ord
                     /*wo_rel_date*/
                     wo_due_date
                     approve[dwn - mindwn + 1] @ yn
                  with frame d.

               setyn_loop:
               do on error undo, retry:

                  /* ONLY ALLOW ACCESS TO FLAG WHEN GRS INSTALLED */
                     set
                        vend
                        yn
                     with frame d.

                  /* STOP APPROVAL FOR THE ITEM WITH RESTRICTED    */
                  /* TRANSACTION OF 'ADD-PO'                       */
                  if vend <> "" then do:
                  	find first vd_mstr where vd_addr = vend no-lock no-error.
                  	if not avail vd_mstr then do:
                  		undo,retry.
                  	end.
                  end.
                  
                  if yn
                  then do:

                     
                     for first pt_mstr
                        fields( pt_part pt_status pt_rev)
                         where pt_part = wo_part
                     no-lock:

                        /* ADDED THIRD INPUT PARAMETER, TO INDICATE THAT  */
                        /* THE MESSAGE SHOULD BE DISPLAYED                */
                        {pxrun.i &PROC='validateRestrictedStatus'
                                 &PROGRAM='ppitxr.p'
                                 &PARAM="(input pt_status,
                                          input 'ADD-PO',
                                          input yes)"
                                 &NOAPPERROR=True
                                 &CATCHERROR=True}

                        if return-value <> {&SUCCESS-RESULT}
                        then do:
                           next-prompt
                              yn
                           with frame d.

                           undo setyn_loop, retry setyn_loop.

                        end. /* IF return_value <> ... */

                     end. /* FOR FIRST pt_mstr */

                  end.  /* IF yn */

                  /* DISPLAY GRS REQUISITION NBR IF APPROVE = YES */
                  
                  approve[dwn - mindwn + 1] = yn.
                  vendext[dwn - mindwn + 1] = vend.
                                    
               end.
            end.
         end.
         else do:
          if cfall <> 999 then do:
            repeat:
               yn = no.
               /* IS ALL INFO CORRECT? */
               {pxmsg.i &MSGNUM=12 &ERRORLEVEL=1 &CONFIRM=yn}
               if yn = ? 
    					 then undo mainloop, leave mainloop.
               leave.
            end.
					end.
					else yn = yes.
					
            if yn
            then do on error undo, retry:
 
 							 /*empty temp-table xxtb.*/
 							 		
               do dwn = 1 to 10:

                  if worecno[dwn] <> ? and approve[dwn]
                  then do:

                     /* PROCESS req_det ONLY     */
                     /* WHEN GRS NOT INSTALLED   */
                     if not using_grs
                     then do:
                        if can-find(first req_det
                           where req_nbr = wonbrs[dwn])
                        then do:
                           /* REQUISITION NUMBER ALREADY EXISTS */
                           {pxmsg.i &MSGNUM=360
                                    &ERRORLEVEL=3
                                    &MSGARG1="(""("" + wonbrs[dwn] + "")"")"}
                           undo, retry.
                        end.
                     end.  /* if not using_grs */

                     find wo_mstr exclusive-lock
                        where recid(wo_mstr) = worecno[dwn] no-error.
                     if available wo_mstr
                     then do:

                        for each wod_det
                           where wod_lot = wo_lot
                        exclusive-lock:

                           find first mrp_det exclusive-lock
                              where mrp_dataset = "wod_det"
                              and   mrp_part    = wod_part
                              and   mrp_nbr     = wod_nbr
                              and   mrp_line    = wod_lot
                              and   mrp_line2   = string(wod_op)
                           no-error.
                           if available mrp_det
                           then
                              delete mrp_det.

                           /* UPDATE PART MASTER MRP FLAG */
                           {inmrp.i &part=wod_part &site=wod_site}

                           delete wod_det.
                        end.

                        for each wr_route
                           where wr_lot = wo_lot
                        exclusive-lock:
                           delete wr_route.
                        end.

                        find mrp_det exclusive-lock
                           where mrp_dataset = "wo_mstr"
                           and   mrp_part = wo_part
                           and   mrp_nbr = wo_nbr
                           and   mrp_line = wo_lot no-error.
                        if available mrp_det
                        then
                           delete mrp_det.

                        find mrp_det exclusive-lock
                           where mrp_dataset = "wo_scrap"
                           and   mrp_part = wo_part
                           and   mrp_nbr = wo_nbr
                           and   mrp_line = wo_lot no-error.
                        if available mrp_det
                        then
                           delete mrp_det.

                        line = 0.

                        /* CREATE req_det ONLY */
                        /* WHEN GRS NOT INSTALLED */
                        if not using_grs
                        then do:
                           do while can-find(req_det
                              where req_nbr = wo_nbr
                              and   req_line = line):
                              line = line + 1.
                           end.

                           for first pt_mstr
                              fields (pt_abc pt_avg_int pt_bom_code
                                      pt_desc1 pt_desc2 pt_insp_lead pt_insp_rqd
                                      pt_joint_type pt_loc pt_mfg_lead pt_mrp
                                      pt_network pt_ord_max pt_ord_min
                                      pt_ord_mult pt_ord_per pt_ord_pol
                                      pt_ord_qty pt_part pt_plan_ord pt_pm_code
                                      pt_po_site pt_prod_line pt_pur_lead
                                      pt_rctpo_active pt_rctpo_status
                                      pt_rctwo_active pt_rctwo_status pt_routing
                                      pt_sfty_time pt_status pt_timefence pt_um
                                      pt_yield_pct pt_cyc_int pt_rev)
                               where pt_part = wo_part
                           no-lock:
                           end. /* FOR FIRST pt_mstr */

                           for first ptp_det
                              fields (ptp_bom_code ptp_ins_lead
                                      ptp_joint_type ptp_mfg_lead ptp_network
                                      ptp_ord_max ptp_ord_min ptp_ord_mult
                                      ptp_ord_per ptp_ord_pol ptp_ord_qty
                                      ptp_part ptp_plan_ord ptp_pm_code
                                      ptp_po_site ptp_pur_lead ptp_routing
                                      ptp_sfty_tme ptp_site ptp_timefnce
                                      ptp_yld_pct ptp_ins_rqd)
                              where ptp_part = wo_part
                              and   ptp_site = wo_site
                           no-lock:
                           end. /* FOR FIRST ptp_det */

														tmpdate1 = max(wo_rel_date,today).
														tmpdate2 = max(wo_due_date,today).

                           find first req_det where req_site = wo_site 
                           		and req_part = wo_part and req_need = tmpdate2
                           		and req_user1 = vendext[dwn] no-error.
                           if not avail req_det or expertext[dwn] or ( avail pt_mstr and pt_rev = "D" ) 
                           		/*or reqzd[dwn]*/
                           then do:

                           		create req_det.
                           		assign
                              req_nbr      = reqnbrs[dwn]
                              req_request  = wo_nbr
                              req_site     = wo_site
                              req_line     = line
                              req_part     = wo_part
                              req_qty      = wo_qty_ord
/* ss 20080126 - b */
/*
                              req_rel_date = wo_rel_date
                              req_need     = wo_due_date
*/
                              req_rel_date = tmpdate1
                              req_need     = tmpdate2
/* ss 20080126 - e */
                              req_so_job   = wolotext[dwn]
                              req_user1    = vendext[dwn]
                              req_user2    = if expertext[dwn] then "Y" else "" .
                           end.
                           else do:
                           		assign req_qty = req_qty + wo_qty_ord
                           					 req_request = req_request + "," + wo_nbr.
                           end.

                           if available pt_mstr
                           then do:
                              req_um = pt_um.

                              if recid(req_det) = -1 then.
                              {gprun.i ""glactdft.p"" "(input ""PO_PUR_ACCT"",
                                                        input pt_prod_line,
                                                        input req_site,
                                                        input """",
                                                        input """",
                                                        input yes,
                                                        output req_acct,
                                                        output req_sub,
                                                        output req_cc)"}
                           end.

                           if available ptp_det
                           then do:
                              req_po_site = ptp_po_site.
                              if ptp_pm_code <> "P"
                              then do:
                                 if ptp_ins_rqd and ptp_ins_lead <> 0
                                 then do:
                                    req_need = ?.

                                    {mfdate.i req_need wo_due_date
                                       ptp_ins_lead req_site}
                                 end.

                                 req_rel_date = req_need -
                                                ptp_pur_lead.
                                 {mfhdate.i req_rel_date -1 req_site}
                              end.
                           end.
                           else
                           if available pt_mstr
                           then do:
                              req_po_site = pt_po_site.
                              if pt_pm_code <> "P"
                              then do:
                                 if pt_insp_rqd and pt_insp_lead <> 0
                                 then do:
                                    req_need = ?.

                                    {mfdate.i req_need wo_due_date
                                       pt_insp_lead req_site}
                                 end.

                                 req_rel_date = req_need - pt_pur_lead.
                                 {mfhdate.i req_rel_date -1 req_site}
                              end.

                           end.

                           /*SET THE PURCHASE APPROVAL CODE ON REQ*/
                           {gppacal.i}

                           /* Update mrp_det purchase requisitions */
                           {mfmrw.i "req_det" req_part req_nbr
                              string(req_line) """" req_rel_date req_need
                              "req_qty" "SUPPLYF" PURCHASE_REQUISITION
                              req_site}

                        end.  /* if not using_grs */
                        
                        delete wo_mstr.
                     end.

                  end.
               end.

               flag = 1.
               leave.
            end.
         end.
      end.
   end.

   if flag = 0
   then do:
      worecno[1] = ?.
      hide frame d.
      undo, leave.
   end.

   hide frame d no-pause.

end.
hide frame b no-pause.
