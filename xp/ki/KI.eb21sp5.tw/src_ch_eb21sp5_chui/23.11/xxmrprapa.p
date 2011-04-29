/* xxmrprapa.p - APPROVE PLANNED PURCHASE ORDERS 1st subroutine         */
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
/* SSIVAN 07111701 BY:Ivan Yang Date:11/17/07  */
/*                   1. Add Excess Qty/Amount and modified xxmrprapa.p   */
/*                   2. ptp_buyer should be setup b4 creating records    */
/*                   3. Check req_nbr not exist in usrw_wkfl             */
/*                   4. Assign req_rel_date = today, Request By = User ID*/
/*                   5. Not display Excess Amount                        */
/*                   6. Allow edit to Qty Ordered and Due Date flag      */
/* 7. Debug: Modify Qty Ordered/Due in 23.11 does not updated mrp_det    */

/* SS - 090917.1  By: Roger Xiao */   
/*SS - 090917.1*/  /*增加del-to相关(85g逻辑中的ECO为*080502*) */

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
define variable yn              like mfc_logical column-label "Approve" no-undo.
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

define shared temp-table tt-rqm-mstr no-undo
    field tt-vend   like rqm_mstr.rqm_vend
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

define buffer b-rqm-mstr for tt-rqm-mstr.

/*SSIVAN 07111701 add*/ define variable dec01 as decimal format "->,>>>,>>9.99" no-undo.
/*SSIVAN 07111701 add*/ define variable ttl_dec01 like mrp_qty.
/*SSIVAN 07111701 add*/ define TEMP-TABLE t-mrpr
/*SSIVAN 07111701 add*/        field t-dwn like pod_line
/*SSIVAN 07111701 add*/        field t-site like mrp_site
/*SSIVAN 07111701 add*/        field t-part like mrp_part
/*SSIVAN 07111701 add*/        field t-qty like mrp_qty
/*SSIVAN 07111701 add*/        index t-dwn IS PRIMARY t-dwn.
/*SSIVAN 07111701 add*/ define variable ord like wo_qty_ord no-undo.
/*SSIVAN 07111701 add*/ define variable due like wo_due_date no-undo.
/*SSIVAN 07111701 add*/ define variable o_qty_ord like wo_qty_ord no-undo.
/*SSIVAN 07111701 add*/ define variable o_due_date like wo_due_date no-undo.

/*SS - 090917.1*/ define variable deliver2 as char format "x(2)" extent 10 no-undo.
/*SS - 090917.1*/ define variable del-to as character format "x(2)"
/*SS - 090917.1*/                        column-label "交付".
/*SS - 090917.1*/ define temp-table t-deliverto
/*SS - 090917.1*/        field t-seq like pod_line
/*SS - 090917.1*/        field t-nbr like req_nbr
/*SS - 090917.1*/        field t-delto as character format "x(2)"
/*SS - 090917.1*/        index t-seq IS PRIMARY t-seq.




form
   dwn
   nbr
   wo_part
/*SSIVAN 07111701 rmk*/  /*  wo_qty_ord	 */
/*SSIVAN 07111701 add*/ ord
   wo_rel_date label "Rel Date"
/*SSIVAN 07111701 rmk*/  /* wo_due_date	  */
/*SSIVAN 07111701 add*/	 due
/*SS - 090917.1*/  del-to
   yn
with frame d.

/* SET EXTERNAL LABELS */
setFrameLabels(frame d:handle).

remarks_text = getTermLabel("MRP_PLANNED_ORDER",23).

for first gl_ctrl
   where gl_domain = global_domain no-lock:
end. /* FOR FIRST gl_ctrl */

assign
    using_grs    = can-find(mfc_ctrl where
                      mfc_domain = global_domain  and
                      mfc_field = "grs_installed" and
                      mfc_logical = yes)
   l_approve_ctr = 0
   l_displayed   = no
   approve       = release_all.

/* GET NEXT GRS REQUISITION NBR IF RELEASE_ALL = YES */
if using_grs
then do:

   for each tt-rqm-mstr
      where tt-nbr = ""
   use-index ttnbr
   exclusive-lock break by tt-vend:

      for first b-rqm-mstr
         where b-rqm-mstr.tt-vend = tt-rqm-mstr.tt-vend
         and   b-rqm-mstr.tt-nbr  <> ""
      use-index vend
      no-lock:
      end. /* FOR FIRST b-rqm-mstr */
      if not available b-rqm-mstr
      then do:
         {gprunmo.i
            &program="mrprapa1.p"
            &module="GRS"
            &param="""(output grs_return_code,
                       output grs_req_nbr)"""}
         if grs_return_code = 0
         then
            assign
               tt-rqm-mstr.tt-nbr = grs_req_nbr
               tt-rqm-mstr.tt-yn  = release_all.
      end. /* IF NOT AVAILABLE b-rqm-mstr */
      else do:
         l_req_nbr = b-rqm-mstr.tt-nbr.
         find first b-rqm-mstr
            where b-rqm-mstr.tt-vend = tt-rqm-mstr.tt-vend
            and   b-rqm-mstr.tt-nbr  = ""
         use-index vend
         exclusive-lock no-error.
         if available b-rqm-mstr
         then
            assign
               b-rqm-mstr.tt-nbr = l_req_nbr
               b-rqm-mstr.tt-yn  = release_all.
      end. /* ELSE DO */
   end. /* FOR EACH tt-rqm-mstr */

end.  /* if using_grs */

do transaction on error undo, retry:
   mainloop:
   repeat:
      /*V8-*/
      do dwn = mindwn to maxdwn
         with frame b 10 down width 80 attr-space:
      /*V8+*/
      /*V8!
      do dwn = mindwn to maxdwn
         with frame b 10 down width 80 attr-space bgcolor 8:   */

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame b:handle).

         wonbrs[dwn - mindwn + 1] = "".
         wolots[dwn - mindwn + 1] = "".

         /* DISPLAY DETAIL */
         if worecno[dwn - mindwn + 1] <> ?
         then do with frame b:

            for first wo_mstr
               fields (wo_domain wo_due_date wo_lot wo_nbr wo_part
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
                     fields( pt_domain pt_part pt_status)
                      where pt_domain = global_domain
                       and  pt_part = wo_part
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

                        if using_grs
                        then
                           run grs_approve (input wo_nbr,
                                            input wo_lot).

                     end. /* IF return-value <> {&SUCCESS-RESULT} */

                  end. /* FOR FIRST pt_mstr */

               end. /* IF l_displayed = NO AND release_all */

               /* DISPLAY GRS REQUISITION NBR IF APPROVE = YES */
               if using_grs and approve[dwn - mindwn + 1]
               then do:
                  for first tt-rqm-mstr
                     where tt-rqm-mstr.tt-wo-nbr = wo_nbr
                     and   tt-rqm-mstr.tt-wo-lot = wo_lot
                  use-index ttnbrlot
                  no-lock:
                  end. /* FOR FIRST tt-rqm-mstr */
                  if available tt-rqm-mstr
                  then
                     display
                        dwn
                        tt-rqm-mstr.tt-nbr @ nbr
                        wo_part
                        wo_qty_ord
/*SSIVAN 07111701 add*/         @ ord
                        wo_rel_date label "Rel Date"
                        wo_due_date
/*SSIVAN 07111701 add*/         @ due
                        approve[dwn - mindwn + 1] @ yn.
               end.  /* if using_grs */
               else
                  display
                     dwn
                     wo_nbr @ nbr
                     wo_part
                     wo_qty_ord
/*SSIVAN 07111701 add*/         @ ord
                     wo_rel_date label "Rel Date"
                     wo_due_date
/*SSIVAN 07111701 add*/         @ due
                     approve[dwn - mindwn + 1] @ yn.

               wonbrs[dwn - mindwn + 1] = wo_nbr.
               wolots[dwn - mindwn + 1] = wo_lot.
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
/*SSIVAN 07111701 add*/  ord = 0.
/*SSIVAN 07111701 add*/  due = ?.

      do on error undo, leave:
         do on error undo, retry:

            dwn = mindwn - 1.
            clear frame d.
            /*V8-*/
/*SS - 090917.1**   set dwn with frame d width 80 attr-space editing:  **/
/*SS - 090917.1*/   set dwn with frame d width 80 no-attr-space editing:
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
                     fields (wo_domain wo_due_date wo_lot wo_nbr wo_part
                             wo_qty_ord wo_rel_date wo_site)
                     where recid(wo_mstr) = worecno[dwn - mindwn + 1]
                  no-lock:
                  end. /* FOR FIRST wo_mstr */

                  if available wo_mstr
                  then do:

                     /* DISPLAY GRS REQUISITION NBR IF APPROVE = YES */
                     if using_grs and approve[dwn - mindwn + 1]
                     then do:
                        for first tt-rqm-mstr
                           where tt-rqm-mstr.tt-wo-nbr = wo_nbr
                           and   tt-rqm-mstr.tt-wo-lot = wo_lot
                        use-index ttnbrlot
                        no-lock:
                        end. /* FOR FIRST tt-rqm-mstr */
                        if available tt-rqm-mstr
                        then
                           display
                              dwn
                              tt-rqm-mstr.tt-nbr @ nbr
                              wo_part
                              wo_qty_ord
/*SSIVAN 07111701 add*/         @ ord
                              wo_rel_date
                              wo_due_date
/*SSIVAN 07111701 add*/            @ due
/*SS - 090917.1*/           deliver2[dwn - mindwn + 1] @ del-to
                              approve[dwn - mindwn + 1] @ yn
                           with frame d.
                     end.  /* if using_grs */
                     else
                        display
                           dwn
                           wo_nbr @ nbr
                           wo_part
                           wo_qty_ord
/*SSIVAN 07111701 add*/         @ ord
                           wo_rel_date
                           wo_due_date
/*SSIVAN 07111701 add*/            @ due
/*SS - 090917.1*/           deliver2[dwn - mindwn + 1] @ del-to
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

            if input dwn <> 0 and ((dwn < mindwn or dwn > maxdwn)
               or (dwn >= mindwn and dwn <= maxdwn
               and wonbrs[dwn - mindwn + 1] = ""))
            then do:
               /* MUST SELECT A NUMBER LISTED ABOVE. */
               {pxmsg.i &MSGNUM=18 &ERRORLEVEL=3}
               undo, retry.
            end.
         end.

         if dwn >= mindwn and dwn <= maxdwn
         then do:

            for first wo_mstr
               fields (wo_domain wo_due_date wo_lot wo_nbr wo_part
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
               if using_grs and approve[dwn - mindwn + 1]
               then do:
                  for first tt-rqm-mstr
                     where tt-rqm-mstr.tt-wo-nbr = wo_nbr
                     and   tt-rqm-mstr.tt-wo-lot = wo_lot
                  use-index ttnbrlot
                  no-lock:
                  end. /* FOR FIRST tt-rqm-mstr */
                  if available tt-rqm-mstr
                  then
                     display
                        dwn
                        tt-rqm-mstr.tt-nbr @ nbr
                        wo_part
                        wo_qty_ord
/*SSIVAN 07111701 add*/         @ ord
                        wo_rel_date
                        wo_due_date
/*SSIVAN 07111701 add*/            @ due
/*SS - 090917.1*/        deliver2[dwn - mindwn + 1] @ del-to
                        approve[dwn - mindwn + 1] @ yn
                     with frame d.
               end.  /* if using_grs */
               else
                  display
                     dwn
                     wo_nbr @ nbr
                     wo_part
                     wo_qty_ord
/*SSIVAN 07111701 add*/         @ ord
                     wo_rel_date
                     wo_due_date
/*SSIVAN 07111701 add*/            @ due
/*SS - 090917.1*/        deliver2[dwn - mindwn + 1] @ del-to
                     approve[dwn - mindwn + 1] @ yn
                  with frame d.

               setyn_loop:
               do on error undo, retry:

                  /* ONLY ALLOW ACCESS TO FLAG WHEN GRS INSTALLED */
                  if using_grs
                  then do:
                     set yn
                     with frame d.
                     nbr = wo_nbr.
/*SSIVAN 07111701 add*/                     ord = wo_qty_ord.
/*SSIVAN 07111701 add*/                     due = wo_due_date.
                  end.  /* if using_grs */
                  else
/*SSIVAN 07111701 add*/                  do:
                     set
                        nbr
/*SSIVAN 07111701 rmk*/       /*                  yn	 */
                     with frame d.

/*SSIVAN 07111701 add*/ /* CALCULATE EXCESS QTY(req__dec01) and EXCESS AMOUNT(req__dec02)*/
/*SSIVAN 07111701 add*/         for each in_mstr where 
/*SSIVAN 07111701 add*/				 in_mstr.in_domain = global_domain
/*SSIVAN 07111701 add*/				   and in_site = wo_site
/*SSIVAN 07111701 add*/                            and in_part = wo_part
/*SSIVAN 07111701 add*/         no-lock:
/*SSIVAN 07111701 add*/           dec01 = in_qty_oh.
/*SSIVAN 07111701 add*/           for each mrp_det where 
/*SSIVAN 07111701 add*/				   mrp_det.mrp_domain = global_domain
/*SSIVAN 07111701 add*/				     and mrp_site = wo_site
/*SSIVAN 07111701 add*/                              and mrp_part = wo_part
/*SSIVAN 07111701 add*/           no-lock:
/*SSIVAN 07111701 add*/              if index(mrp_type,"demand") > 0
/*SSIVAN 07111701 add*/                 then dec01 = dec01 - mrp_qty.
/*SSIVAN 07111701 add*/              else
/*SSIVAN 07111701 add*/              if index(mrp_type,"supply") > 0
/*SSIVAN 07111701 add*/                       and mrp_type <> "supplyp"
/*SSIVAN 07111701 add*/                 then dec01 = dec01 + mrp_qty.
/*SSIVAN 07111701 add*/           end.

/*SSIVAN 07111701 add*/           for each t-mrpr where t-part = wo_part 
/*SSIVAN 07111701 add*/                             and t-site = wo_site
/*SSIVAN 07111701 add*/           no-lock:
/*SSIVAN 07111701 add*/             ttl_dec01 = ttl_dec01 + t-qty.
/*SSIVAN 07111701 add*/           end.

/*SSIVAN 07111701 add*/           dec01 = dec01 + ttl_dec01.
/*SSIVAN 07111701 add*/           ttl_dec01 = 0.

/*SSIVAN 07111701 add*/           display dec01  label "Excess Qty"
/*SSIVAN 07111701 add*/           with frame ex overlay column 34 row 16 attr-space.
/*SSIVAN 07111701 add*/         end.  /* for each in_mstr */


/*SS - 090917.1*/        find first t-deliverto where t-seq = dwn
/*SS - 090917.1*/        no-lock no-error.
/*SS - 090917.1*/        if not available t-deliverto then do:
/*SS - 090917.1*/          find first pt_mstr where pt_domain = global_domain and  pt_part = wo_part
/*SS - 090917.1*/          no-lock no-error.
/*SS - 090917.1*/          if available pt_mstr then do:
/*SS - 090917.1*/            find first code_mstr where code_domain = global_domain and code_fldname = "del-to"
/*SS - 090917.1*/              and substring(code_value,1,4) = wo_site
/*SS - 090917.1*/              and substring(code_value,6,8) = pt_group
/*SS - 090917.1*/            no-lock no-error.
/*SS - 090917.1*/            if available code_mstr then do:
/*SS - 090917.1*/              message "厂别:" wo_site "产品组:" pt_group
/*SS - 090917.1*/                      "交付前置为:" code_cmmt.
/*SS - 090917.1*/              display code_cmmt @ del-to with frame d.
/*SS - 090917.1*/            end.
/*SS - 090917.1*/          end.
/*SS - 090917.1*/        end. /*not avail t-deliverto, defa del-to from code_mstr*/

/*SSIVAN 07111701 add*/         set ord due 
/*SS - 090917.1*/                          del-to 
                                with frame d.
/*SS - 090917.1*/        if del-to = "" then do:
/*SS - 090917.1*/          {mfmsg.i 40 3}
/*SS - 090917.1*/          next-prompt del-to with frame d.
/*SS - 090917.1*/          undo, retry.
/*SS - 090917.1*/        end.
/*SS - 090917.1*/        else do:
/*SS - 090917.1*/          find first code_mstr where code_domain = global_domain and  code_fldname = "po_del_to"
/*SS - 090917.1*/          and code_value = input del-to
/*SS - 090917.1*/          no-lock no-error.
/*SS - 090917.1*/          if not available(code_mstr) then do:
/*SS - 090917.1*/            {mfmsg.i 8253 3} /*INVALID DELIVERY */
/*SS - 090917.1*/            next-prompt del-to with frame d.
/*SS - 090917.1*/            undo, retry.
/*SS - 090917.1*/          end.
/*SS - 090917.1*/        end.

/*SSIVAN 07111701 add*/         set yn with frame d.

/*SSIVAN 07111701 add*/   if yn then do:
/*SSIVAN 07111701 add*/      find ptp_det where
/*SSIVAN 07111701 add*/			ptp_det.ptp_domain = global_domain
/*SSIVAN 07111701 add*/			    and ptp_part = wo_part
/*SSIVAN 07111701 add*/                     and ptp_site = wo_site no-lock no-error.
/*SSIVAN 07111701 add*/      if available ptp_det then do:
/*SSIVAN 07111701 add*/        if ptp_buyer = "" then do:
/*SSIVAN 07111701 rmk*/           /* message "ERROR: PLANNER/BUYER CANNOT BE BLANK – Setup in 1.4.17.".  */
/*SSIVAN 07111701 add*/		   {pxmsg.i &MSGNUM=9012 &ERRORLEVEL=3}
/*SSIVAN 07111701 add*/           yn = no.
/*SSIVAN 07111701 add*/           display yn with frame d.
/*SSIVAN 07111701 add*/           next-prompt nbr.
/*SSIVAN 07111701 add*/           undo, retry.
/*SSIVAN 07111701 add*/        end.
/*SSIVAN 07111701 add*/      end.
/*SSIVAN 07111701 add*/      if not available ptp_det then do:
/*SSIVAN 07111701 rmk*/         /* message "ERROR: ITEM-SITE PLANNING RECORD DOES NOT EXIST - Setup in 1.4.17.". */
/*SSIVAN 07111701 add*/		 {pxmsg.i &MSGNUM=9013 &ERRORLEVEL=3}
/*SSIVAN 07111701 add*/         yn = no.
/*SSIVAN 07111701 add*/         display yn with frame d.
/*SSIVAN 07111701 add*/         next-prompt nbr.
/*SSIVAN 07111701 add*/         undo, retry.
/*SSIVAN 07111701 add*/      end.
/*SS - 090917.1*/     find t-deliverto where t-seq = dwn exclusive-lock no-error.
/*SS - 090917.1*/     if not available t-deliverto and yn = yes then do:
/*SS - 090917.1*/        create t-deliverto.
/*SS - 090917.1*/        assign t-seq = dwn
/*SS - 090917.1*/               t-nbr = nbr
/*SS - 090917.1*/               t-delto = del-to.
/*SS - 090917.1*/     end.
/*SS - 090917.1*/     else assign t-seq = dwn
/*SS - 090917.1*/                 t-nbr = nbr
/*SS - 090917.1*/                 t-delto = del-to.

/*SSIVAN 07111701 add*/   end.

/*SSIVAN 07111701 add*/         if dwn >= mindwn and dwn <= maxdwn then do:
/*SSIVAN 07111701 add*/            for each wod_det where
/*SSIVAN 07111701 add*/			wod_det.wod_domain = global_domain
/*SSIVAN 07111701 add*/			and wod_lot = wo_lot
/*SSIVAN 07111701 add*/            no-lock:
/*SSIVAN 07111701 add*/               find mrp_det no-lock
/*SSIVAN 07111701 add*/               where 
/*SSIVAN 07111701 add*/			mrp_det.mrp_domain = global_domain
/*SSIVAN 07111701 add*/		      and mrp_dataset = "wod_det"
/*SSIVAN 07111701 add*/               and mrp_part = wod_part
/*SSIVAN 07111701 add*/               and mrp_nbr = wod_nbr
/*SSIVAN 07111701 add*/               and mrp_line = wod_lot no-error.
/*SSIVAN 07111701 add*/               if available mrp_det then do:
/*SSIVAN 07111701 add*/                  find t-mrpr exclusive-lock
/*SSIVAN 07111701 add*/                  where t-dwn = dwn no-error.
/*SSIVAN 07111701 add*/                  if not available t-mrpr and yn = yes then do:
/*SSIVAN 07111701 add*/                  create t-mrpr.
/*SSIVAN 07111701 add*/                  assign t-dwn = dwn
/*SSIVAN 07111701 add*/                         t-site = mrp_site
/*SSIVAN 07111701 add*/                         t-part = mrp_part
/*SSIVAN 07111701 add*/                         t-qty = mrp_qty.
/*SSIVAN 07111701 add*/                  end.
/*SSIVAN 07111701 add*/                  if available t-mrpr and yn = no then
/*SSIVAN 07111701 add*/                  delete t-mrpr.
/*SSIVAN 07111701 add*/               end.
/*SSIVAN 07111701 add*/            end.  /* for each wod_det */

/*SSIVAN 07111701 add*/            find mrp_det no-lock
/*SSIVAN 07111701 add*/            where
/*SSIVAN 07111701 add*/		    mrp_det.mrp_domain = global_domain
/*SSIVAN 07111701 add*/		   and mrp_dataset = "wo_mstr"
/*SSIVAN 07111701 add*/            and mrp_part = wo_part and mrp_nbr = wo_nbr
/*SSIVAN 07111701 add*/            and mrp_line = wo_lot no-error.
/*SSIVAN 07111701 add*/            if available mrp_det then do:
/*SSIVAN 07111701 add*/               find t-mrpr exclusive-lock
/*SSIVAN 07111701 add*/               where t-dwn = dwn no-error.
/*SSIVAN 07111701 add*/               if not available t-mrpr and yn = yes then do:
/*SSIVAN 07111701 add*/               create t-mrpr.
/*SSIVAN 07111701 add*/               assign t-dwn = dwn
/*SSIVAN 07111701 add*/                      t-site = mrp_site
/*SSIVAN 07111701 add*/                      t-part = mrp_part
/*SSIVAN 07111701 add*/                      t-qty = mrp_qty.
/*SSIVAN 07111701 add*/               end.
/*SSIVAN 07111701 add*/               if available t-mrpr and yn = no then 
/*SSIVAN 07111701 add*/               delete t-mrpr.
/*SSIVAN 07111701 add*/            end.

/*SSIVAN 07111701 add*/            find mrp_det no-lock
/*SSIVAN 07111701 add*/            where
/*SSIVAN 07111701 add*/		    mrp_det.mrp_domain = global_domain
/*SSIVAN 07111701 add*/		   and mrp_dataset = "wo_scrap"
/*SSIVAN 07111701 add*/            and mrp_part = wo_part and mrp_nbr = wo_nbr
/*SSIVAN 07111701 add*/            and mrp_line = wo_lot no-error.
/*SSIVAN 07111701 add*/            if available mrp_det then do:
/*SSIVAN 07111701 add*/               find t-mrpr exclusive-lock
/*SSIVAN 07111701 add*/               where t-dwn = dwn no-error.
/*SSIVAN 07111701 add*/               if not available t-mrpr and yn = yes then do:
/*SSIVAN 07111701 add*/               create t-mrpr.
/*SSIVAN 07111701 add*/               assign t-dwn = dwn
/*SSIVAN 07111701 add*/                      t-site = mrp_site
/*SSIVAN 07111701 add*/                      t-part = mrp_part
/*SSIVAN 07111701 add*/                      t-qty = mrp_qty.
/*SSIVAN 07111701 add*/               end.
/*SSIVAN 07111701 add*/               if available t-mrpr and yn = no then
/*SSIVAN 07111701 add*/               delete t-mrpr.
/*SSIVAN 07111701 add*/            end.	/*if available mrp_det*/
/*SSIVAN 07111701 add*/         end.
/*SSIVAN 07111701 add*/     end. /* not using_grs */

                  /* STOP APPROVAL FOR THE ITEM WITH RESTRICTED    */
                  /* TRANSACTION OF 'ADD-PO'                       */
                  if yn
                  then do:

                     for first pt_mstr
                        fields( pt_domain pt_part pt_status)
                         where pt_domain = global_domain
                          and  pt_part = wo_part
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
                  if using_grs
                  then do:

                     if approve[dwn - mindwn + 1] <> yn
                     then do:

                        find first tt-rqm-mstr
                           where tt-wo-nbr = wo_nbr
                           and   tt-wo-lot = wo_lot
                        use-index ttnbrlot
                        exclusive-lock.
                        if available tt-rqm-mstr
                        then
                           tt-rqm-mstr.tt-yn = yn.

                     end.
                  end.  /* if using_grs */

                  approve[dwn - mindwn + 1] = yn.
/*SS - 090917.1*/     deliver2[dwn - mindwn + 1] = del-to.

                  /*GET NEXT REQ NUMBER IF BLANK */
                  if nbr = ""
                  then do with frame d:
                     {mfnctrla.i "woc_ctrl.woc_domain = global_domain"
                     "woc_ctrl.woc_domain" "req_det.req_domain = global_domain"
                     woc_ctrl woc_nbr req_det req_nbr nbr}
                     loop-a:
                     repeat:

                        do-a:
                        do:

                           do i = mindwn to maxdwn:
                              if i <> dwn
                                 and nbr = wonbrs[i - mindwn + 1]
                                 then
                                    leave do-a.
                           end.
                           if not can-find(first req_det
                               where req_domain = global_domain
                               and   req_nbr = nbr)
                           then
                              leave loop-a.
                        end.
                        nbr = string(integer(nbr) + 1).
                     end.
                  end.

                  if nbr = ""
                  then do:
                     /* BLANK NOT ALLOWED */
                     {pxmsg.i &MSGNUM=40 &ERRORLEVEL=3}
                     undo, retry.
                  end.

                  /* CAN ONLY REFERENCE req_det */
                  /* WHEN GRS NOT INSTALLED    */
                  if not using_grs
                  then do:
                     if can-find(first req_det
                     where req_domain = global_domain
                      and  req_nbr = nbr)
                     then do:
                        /* REQUISITION NUMBER ALREADY EXISTS */
                        {pxmsg.i &MSGNUM=360 &ERRORLEVEL=3}
                        next-prompt nbr.
                        undo, retry.
                     end.
                  end.  /* if not using_grs */

/*SSIVAN 07111701 add*/      if can-find(first usrw_wkfl where 
/*SSIVAN 07111701 add*/			 usrw_wkfl.usrw_domain = global_domain 
/*SSIVAN 07111701 add*/			 and usrw_key1 = nbr
/*SSIVAN 07111701 add*/                  and usrw_key3 = "PR")
/*SSIVAN 07111701 add*/      then do:
/*SSIVAN 07111701 add*/         {mfmsg.i 2142 3}
/*SSIVAN 07111701 add*/         next-prompt nbr.
/*SSIVAN 07111701 add*/         undo, retry.
/*SSIVAN 07111701 add*/      end.


                  do i = mindwn to maxdwn:
                     if i <> dwn
                        and nbr = wonbrs[i - mindwn + 1]
                     then do:
                        /* REQUISITION NUMBER ALREADY EXISTS */
                        {pxmsg.i &MSGNUM=360 &ERRORLEVEL=2}
                     end.
                  end.

                  if wo_nbr <> nbr
                  then do:
                     if can-find(wo_mstr
                        where wo_domain = global_domain
                         and  wo_nbr = nbr
                         and  wo_lot = wolots[dwn - mindwn + 1])
                     then do:
                        /* Work Order already exists with that number */
                        {pxmsg.i &MSGNUM=505 &ERRORLEVEL=3}
                        undo, retry.
                     end.

                     dwn = 0.

                     do while wo_nbr <> nbr and dwn < 10:
                        dwn = dwn + 1.
                        if wo_nbr = wonbrs[dwn]
                        then do:
                           find wo_mstr
                              where recid(wo_mstr) = worecno[dwn]
                           exclusive-lock no-error.

                           wonbrs[dwn] = nbr.

                           for each wod_det
                              where wod_domain = global_domain
                              and   wod_lot = wo_lot
                           exclusive-lock:

                           /* ADDED LINE TO CHECK OPERATION OF THE COMPONENTS */

                              find first mrp_det exclusive-lock
                                 where mrp_domain  = global_domain
                                 and   mrp_dataset = "wod_det"
                                 and   mrp_part    = wod_part
                                 and   mrp_nbr     = wod_nbr
                                 and   mrp_line    = wod_lot
                                 and   mrp_line2   = string(wod_op)
                              no-error.
                              if available mrp_det
                              then
/*SSIVAN 07111701 rmk*/     /*                            mrp_nbr = nbr.    */
/*SSIVAN 07111701 add*/                    do:
/*SSIVAN 07111701 add*/                mrp_nbr = nbr. 
/*SSIVAN 07111701 add*/                mrp_due = due.
/*SSIVAN 07111701 add*/                mrp_qty = ord. 
/*SSIVAN 07111701 add*/             end.

                              wod_nbr = nbr.
                           end.

                           find mrp_det exclusive-lock
                              where mrp_domain = global_domain
                              and   mrp_dataset = "wo_mstr"
                              and   mrp_part = wo_part
                              and   mrp_nbr = wo_nbr
                              and   mrp_line = wo_lot
                           no-error.
                           if available mrp_det
                           then
/*SSIVAN 07111701 rmk*/     /*                               mrp_nbr = nbr. */
/*SSIVAN 07111701 add*/	   do:
/*SSIVAN 07111701 add*/                mrp_nbr = nbr. 
/*SSIVAN 07111701 add*/                mrp_due = due.
/*SSIVAN 07111701 add*/                mrp_qty = ord. 
/*SSIVAN 07111701 add*/             end.

                           wo_nbr = nbr.
/*SSIVAN 07111701 add*/           wo_qty_ord = ord.
/*SSIVAN 07111701 add*/           wo_due_date = due.
                        end.
                     end.
                  end.
/*SSIVAN 07111701 add*/      if wo_nbr = nbr and 
/*SSIVAN 07111701 add*/         (wo_qty_ord <> ord or wo_due_date <> due)
/*SSIVAN 07111701 add*/      then do:

/*SSIVAN 07111701 add*/         dwn = 0.
/*SSIVAN 07111701 add*/         do while wo_nbr = nbr and dwn < 10:
/*SSIVAN 07111701 add*/            dwn = dwn + 1.
/*SSIVAN 07111701 add*/            if wo_nbr = wonbrs[dwn] then do:
/*SSIVAN 07111701 add*/               find wo_mstr exclusive-lock where
/*SSIVAN 07111701 add*/                           recid(wo_mstr) = worecno[dwn]
/*SSIVAN 07111701 add*/               no-error.

/*SSIVAN 07111701 add*/               wonbrs[dwn] = nbr.

/*SSIVAN 07111701 add*/               for each wod_det exclusive-lock
/*SSIVAN 07111701 add*/               where wod_det.wod_domain = global_domain and wod_lot = wo_lot:

/*SSIVAN 07111701 add*/                 find mrp_det exclusive-lock
/*SSIVAN 07111701 add*/                 where 
/*SSIVAN 07111701 add*/			mrp_det.mrp_domain = global_domain
/*SSIVAN 07111701 add*/			and mrp_dataset = "wod_det"
/*SSIVAN 07111701 add*/                 and mrp_part = wod_part
/*SSIVAN 07111701 add*/                 and mrp_nbr = wod_nbr
/*SSIVAN 07111701 add*/                 and mrp_line = wod_lot no-error.
/*SSIVAN 07111701 add*/                if available mrp_det then do:
/*SSIVAN 07111701 add*/                   mrp_nbr = nbr.   
/*SSIVAN 07111701 add*/                   mrp_due = due.   
/*SSIVAN 07111701 add*/                   mrp_qty = ord.
/*SSIVAN 07111701 add*/                end.

/*SSIVAN 07111701 add*/                 wod_nbr = nbr.
/*SSIVAN 07111701 add*/               end.

/*SSIVAN 07111701 add*/               find mrp_det exclusive-lock
/*SSIVAN 07111701 add*/               where 
/*SSIVAN 07111701 add*/               mrp_det.mrp_domain = global_domain
/*SSIVAN 07111701 add*/		      and mrp_dataset = "wo_mstr"
/*SSIVAN 07111701 add*/               and mrp_part = wo_part and mrp_nbr = wo_nbr
/*SSIVAN 07111701 add*/               and mrp_line = wo_lot no-error.
/*SSIVAN 07111701 add*/              if available mrp_det then do:
/*SSIVAN 07111701 add*/                mrp_nbr = nbr.   
/*SSIVAN 07111701 add*/                 mrp_due = due.   
/*SSIVAN 07111701 add*/                 mrp_qty = ord.
/*SSIVAN 07111701 add*/              end.

/*SSIVAN 07111701 add*/               wo_nbr = nbr.
/*SSIVAN 07111701 add*/               wo_qty_ord = ord.
/*SSIVAN 07111701 add*/               wo_due_date = due.
/*SSIVAN 07111701 add*/            end.
/*SSIVAN 07111701 add*/         end. /* do while */
/*SSIVAN 07111701 add*/      end.  /* if wo_qty_ord <> ord */
               end.
            end.
         end.
         else do:
            repeat:
               yn = no.
               /* IS ALL INFO CORRECT? */
               {pxmsg.i &MSGNUM=12 &ERRORLEVEL=1 &CONFIRM=yn}
               if yn = ?
               then undo mainloop, leave mainloop.
               leave.
            end.

            if yn
            then do on error undo, retry:
               do dwn = 1 to 10:

                  if worecno[dwn] <> ? and approve[dwn]
                  then do:

                     /* PROCESS req_det ONLY     */
                     /* WHEN GRS NOT INSTALLED   */
                     if not using_grs
                     then do:
                        if can-find(first req_det
                           where req_domain = global_domain
                           and   req_nbr = wonbrs[dwn])
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
                           if available mrp_det
                           then
                              delete mrp_det.

                           /* UPDATE PART MASTER MRP FLAG */
                           {inmrp.i &part=wod_part &site=wod_site}

                           delete wod_det.
                        end.

                        for each wr_route
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
                           and   mrp_line = wo_lot no-error.
                        if available mrp_det
                        then
                           delete mrp_det.

                        find mrp_det exclusive-lock
                           where mrp_domain = global_domain
                           and   mrp_dataset = "wo_scrap"
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
                              where req_domain = global_domain
                              and   req_nbr = wo_nbr
                              and   req_line = line):
                              line = line + 1.
                           end.

/*SS - 090917.1*/          find first t-deliverto where t-nbr = wo_nbr   no-lock no-error.

                           for first pt_mstr
                              fields (pt_domain pt_abc pt_avg_int pt_bom_code
                                      pt_desc1 pt_desc2 pt_insp_lead pt_insp_rqd
                                      pt_joint_type pt_loc pt_mfg_lead pt_mrp
                                      pt_network pt_ord_max pt_ord_min
                                      pt_ord_mult pt_ord_per pt_ord_pol
                                      pt_ord_qty pt_part pt_plan_ord pt_pm_code
                                      pt_po_site pt_prod_line pt_pur_lead
                                      pt_rctpo_active pt_rctpo_status
                                      pt_rctwo_active pt_rctwo_status pt_routing
                                      pt_sfty_time pt_status pt_timefence pt_um
                                      pt_yield_pct pt_cyc_int)
                               where pt_domain = global_domain
                               and   pt_part = wo_part
                           no-lock:
                           end. /* FOR FIRST pt_mstr */

                           for first ptp_det
                              fields (ptp_domain ptp_bom_code ptp_ins_lead
                                      ptp_joint_type ptp_mfg_lead ptp_network
                                      ptp_ord_max ptp_ord_min ptp_ord_mult
                                      ptp_ord_per ptp_ord_pol ptp_ord_qty
                                      ptp_part ptp_plan_ord ptp_pm_code
                                      ptp_po_site ptp_pur_lead ptp_routing
                                      ptp_sfty_tme ptp_site ptp_timefnce
                                      ptp_yld_pct ptp_ins_rqd)
                              where ptp_domain = global_domain
                              and   ptp_part = wo_part
                              and   ptp_site = wo_site
                           no-lock:
                           end. /* FOR FIRST ptp_det */

                           create req_det.
                           assign
                              req_domain   = global_domain
                              req_nbr      = wo_nbr
                              req_site     = wo_site
                              req_line     = line
                              req_part     = wo_part
/*SS - 090917.1*/             req__chr05 = t-delto when available t-deliverto
                              req_qty      = wo_qty_ord
/*SSIVAN 07111701 rmk*/       /* req_rel_date = wo_rel_date	*/
/*SSIVAN 07111701 add*/          req_rel_date = today
/*SSIVAN 07111701 add*/           req_request = global_userid
                              req_need     = wo_due_date.

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


/*SSIVAN 07111701 add*/ /* CALCULATE EXCESS QTY(req__dec01) and EXCESS AMOUNT(req__dec02)*/
/*SSIVAN 07111701 add*/         for each in_mstr where 
							in_mstr.in_domain = global_domain 
						   and in_site = req_site
/*SSIVAN 07111701 add*/                            and in_part = req_part
/*SSIVAN 07111701 add*/         no-lock:
/*SSIVAN 07111701 add*/           req__dec01 = in_qty_oh.
/*SSIVAN 07111701 add*/           for each mrp_det where
/*SSIVAN 07111701 add*/					mrp_det.mrp_domain = global_domain
/*SSIVAN 07111701 add*/				     and mrp_site = req_site
/*SSIVAN 07111701 add*/                              and mrp_part = req_part
/*SSIVAN 07111701 add*/           no-lock:
/*SSIVAN 07111701 add*/              if index(mrp_type,"demand") > 0
/*SSIVAN 07111701 add*/                 then req__dec01 = req__dec01 - mrp_qty.
/*SSIVAN 07111701 add*/              else
/*SSIVAN 07111701 add*/              if index(mrp_type,"supply") > 0
/*SSIVAN 07111701 add*/                       and mrp_type <> "supplyp"
/*SSIVAN 07111701 add*/                 then req__dec01 = req__dec01 + mrp_qty.
/*SSIVAN 07111701 add*/           end.
/*SSIVAN 07111701 add*/           req__dec02 = 0.
/*SSIVAN 07111701 add*/           find last prh_hist where 
/*SSIVAN 07111701 add*/					prh_hist.prh_domain = global_domain 
/*SSIVAN 07111701 add*/				       and prh_part = req_part
/*SSIVAN 07111701 add*/                                and prh_pur_cost <> 0
/*SSIVAN 07111701 add*/           use-index prh_part no-lock no-error.
/*SSIVAN 07111701 add*/           if available prh_hist
/*SSIVAN 07111701 add*/           then
/*SSIVAN 07111701 add*/             req__dec02 = prh_pur_cost * req__dec01.
/*SSIVAN 07111701 add*/           else do:
/*SSIVAN 07111701 add*/             find last pod_det where 
/*SSIVAN 07111701 add*/					pod_det.pod_domain = global_domain 
/*SSIVAN 07111701 add*/					and pod_part = req_part
/*SSIVAN 07111701 add*/                                 and pod_pur_cost <> 0
/*SSIVAN 07111701 add*/             use-index pod_partdue no-lock no-error.
/*SSIVAN 07111701 add*/             if available pod_det then do:
/*SSIVAN 07111701 add*/               find first po_mstr where po_mstr.po_domain = global_domain and po_nbr = pod_nbr
/*SSIVAN 07111701 add*/               no-lock no-error.
/*SSIVAN 07111701 add*/               if available po_mstr then
/*SSIVAN 07111701 add*/                  req__dec02 = pod_pur_cost * po_ent_ex * req__dec01.
/*SSIVAN 07111701 add*/             end.
/*SSIVAN 07111701 add*/             else do:
/*SSIVAN 07111701 add*/               find first sct_det where sct_det.sct_domain = global_domain 
/*SSIVAN 07111701 add*/					   and sct_part = req_part
/*SSIVAN 07111701 add*/                    and sct_sim  = "Standard" and sct_site = req_site
/*SSIVAN 07111701 add*/               no-lock no-error.
/*SSIVAN 07111701 add*/               if available sct_det then
/*SSIVAN 07111701 add*/                 req__dec02 = sct_cst_tot * req__dec01.
/*SSIVAN 07111701 add*/             end.
/*SSIVAN 07111701 add*/           end.
/*SSIVAN 07111701 add*/         end.

                        end.  /* if not using_grs */
                        else do:
                           /* CREATE rqm_mstr & rqd_det */
                           /* WHEN GRS IS INSTALLED */

                           for first tt-rqm-mstr
                              where tt-rqm-mstr.tt-wo-nbr = wo_nbr
                              and   tt-rqm-mstr.tt-wo-lot = wo_lot
                              and   tt-rqm-mstr.tt-yn
                              use-index ttnbrlot
                           no-lock:

                              grs_req_nbr = tt-rqm-mstr.tt-nbr.

                              for first rqm_mstr
                                 fields (rqm_domain rqm_nbr rqm_vend)
                                 where rqm_domain = global_domain
                                 and   rqm_nbr    = tt-rqm-mstr.tt-nbr
                                 and   rqm_vend   = tt-rqm-mstr.tt-vend
                              no-lock:
                              end. /* FOR FIRST rqm_mstr */
                              if not available rqm_mstr
                              then
                                 grs_approval_cntr = 0.

                              /* ADD +1 TO THE COUNTER */
                              /* OF RECORDS SELECTED   */
                              grs_approval_cntr =
                                    grs_approval_cntr + 1.

                              {gprunmo.i
                               &program="mrprapa2.p"
                               &module="GRS"
                               &param="""(input grs_approval_cntr,
                                          input grs_req_nbr,
                                          input wo_part,
                                          input wo_site,
                                          input wo_qty_ord,
                                          input wo_rel_date,
                                          input wo_due_date,
                                          input remarks_text,
                                          output grs_return_code)"""}

                              if grs_return_code <> 0
                              then do:
                                 hide frame d.
                                 undo, leave.
                              end. /* if grs_return_code <> 0 */
                           end. /* FOR FIRST tt-rqm-mstr */
                        end.  /* if using_grs */

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

   hide frame d.

end.
hide frame b.


/* PROCEDURE TO SET THE APPROVAL FLAG OF tt-rqm-mstr, WHEN USING GRS */

PROCEDURE grs_approve:

   define input parameter p_nbr     as character no-undo.
   define input parameter p_lot     as character no-undo.

   for first tt-rqm-mstr
      where tt-rqm-mstr.tt-wo-nbr = p_nbr
      and   tt-rqm-mstr.tt-wo-lot = p_lot
      use-index ttnbrlot
   exclusive-lock:

      tt-rqm-mstr.tt-yn = no.

   end. /* FOR FIRST tt-rqm-mstr */

END PROCEDURE. /* PROCEDURE grs_approve */
