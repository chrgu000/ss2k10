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
/*By: Neil Gao 08/06/30 ECO: *SS 20080630* */

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

/* ss 20071211 - e */
define new shared var cfall as int.
/* ss 20071211 - b */

define new shared temp-table tt-rqm-mstr no-undo
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

define new shared temp-table xxtb
	field xxtb_nbr  like wo_nbr
	field xxtb_vend like po_vend
	field xxtb_part like pt_part
	field xxtb_qty  like tr_qty_loc
	field xxtb_wolot like wo_lot
	index xxtb_wolot 
				xxtb_wolot.

/*SS 20080520 - B*/
define buffer womstr for wo_mstr.
/*SS 20080520 - E*/

/* INPUT OPTION FORM */
form
   part                     colon 15
   /*V8! View-as fill-in size 18 by 1 */
   part2 label {t001.i}     colon 45
   /*V8! View-as fill-in size 18 by 1 */
   rel_date                 colon 15
   rel_date2 label {t001.i} colon 45 skip(1)
   release_all              colon 36
   buyer                    colon 36
   show_phantom             colon 36
   show_mfg                 colon 36
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

assign
   release_all = yes
   site = global_site
   site2 = global_site.

/* ss 20071211 - b */
	 buyer = global_userid.
	 disp buyer with frame a.
/* ss 20071211 - e */


main-loop:
repeat:
   assign
      worecno = ?
      dwn = 0
      mindwn = 1
      maxdwn = 0.

/* ss 20071211 - b */
			cfall = 0.
/* ss 20071211 - e */

/*SS 20080520 - B*/
empty temp-table xxtb.
/*SS 20080520 - E*/


    ststatus = stline[1].
    status input ststatus.

   if part2 = hi_char then part2 = "".
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
      rel_date rel_date2
      release_all
/* ss 20071211 - b */
      buyer
/* ss 20071211 - e */
      show_phantom
      show_mfg
   with frame a
   editing:


    	do:
         ststatus = stline[3].
         status input ststatus.
         readkey.
         apply lastkey.
      end. /*  DO */
   end. /* EDITING */

   status input "".

   if part2 = "" then part2 = hi_char.
   if site2 = "" then site2 = hi_char.
   if rel_date = ? then  rel_date = low_date.
   if rel_date2 = ? then rel_date2 = hi_date.


   for each tt-rqm-mstr
      exclusive-lock:
      delete tt-rqm-mstr.
   end. /* FOR EACH tt-rqm-mstr */

   /* BELOW CODE STARTS WITH THE PT_MSTR AND IN_MSTR TABLES,         */
   /* SELECTING THE RECORDS WITHIN THE SELECTION CRITERIA OF ITEM    */
   /* AND SITE FOR WHICH WO EXISTS. THEN A CHECK IS MADE FOR PURCHASE*/
   /* MANUFACTURE, PHANTOM, BUYER/PLANNER VALUES BEFORE SEARCHING FOR*/
   /* WORK ORDERS WITH A PLANNED STATUS CODE. THIS IS SIGNIFICANTLY  */
   /* FASTER WHEN THERE ARE LARGE NUMBER OF WORK ORDERS AND WHEN     */
   /* BUYER/PLANNER FIELD IS ENTERED IN THE SELECTION CRITERIA.      */

   for each pt_mstr no-lock  where 
   (pt_part >= part
                              and  pt_part <= part2),
       each in_mstr no-lock  where 
       in_part  = pt_part
                              and (in_site >= site
                              and  in_site <= site2)
         and can-find (first wo_mstr where
            wo_part = in_part and wo_site = in_site):

      find ptp_det
         no-lock
          where  ptp_part = in_part
         and ptp_site = in_site
         no-error.

      if (available ptp_det
         and (ptp_phantom = no    or show_phantom   = yes)
         and (ptp_buyer   = buyer or buyer          = "" )
         and (ptp_pm_code = "P"   or show_mfg       = yes))
         or
         (not available ptp_det
         and (pt_phantom  = no    or show_phantom   = yes)
         and (pt_buyer    = buyer or buyer          = "" )
         and (pt_pm_code  = "P"   or show_mfg       = yes)) then
      do:
         
         for each wo_mstr no-lock  where
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
                            where
                            mfc_field   = "grs_installed"
                             and mfc_logical = yes).

            if dwn = numlines or maxdwn = 999
            then do:

               hide frame a.
/* ss 20071107 - b */
/*
               {gprun.i ""mrprapa.p""}
*/
               {gprun.i ""xxmrprapa.p""}
/* ss 20071107 - e */
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
/* ss 20071107 - b */
/*
      {gprun.i ""mrprapa.p""}
*/
      {gprun.i ""xxmrprapa.p""}
/* ss 20071107 - e */

      if worecno[1] = ?
      then
         undo main-loop, next main-loop.
   end. /* IF dwn <> 0 */
   else do:
      {pxmsg.i &MSGNUM=307 &ERRORLEVEL=1}
      /* NO MORE PLANNED PURCHASE ORDERS SATISFY CRITERIA */
   end. /* ELSE DO */

/* ss 20071229 - e */

end. /* MAINLOOP */
