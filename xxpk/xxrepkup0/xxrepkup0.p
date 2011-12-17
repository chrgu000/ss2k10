/* GUI CONVERTED from repkup.p (converter v1.76) Wed Dec 18 20:55:26 2002 */
/* repkup.p - REPETITIVE PICKLIST CALCULATION                           */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.6.1.9 $                                                 */
/*V8:ConvertMode=Report                                                 */
/* REVISION: 7.3      LAST MODIFIED: 09/06/92   BY: emb  *G071*         */
/* REVISION: 7.3      LAST MODIFIED: 10/13/92   BY: emb  *G071*         */
/* REVISION: 7.3      LAST MODIFIED: 10/26/92   BY: emb  *G071*         */
/* REVISION: 7.3      LAST MODIFIED: 02/22/93   BY: emb  *G722*         */
/* REVISION: 7.3      LAST MODIFIED: 09/27/93   BY: ram  *GF97*         */
/* REVISION: 7.3      LAST MODIFIED: 11/01/94   by: ame  *GN86*         */
/* REVISION: 7.3      LAST MODIFIED: 11/07/94   by: pxd  *GO32*         */
/* REVISION: 8.5      LAST MODIFIED: 01/03/95   BY: mwd  *J034*         */
/* REVISION: 7.3      LAST MODIFIED: 01/04/95   by: srk  *G0B8*         */
/* REVISION: 7.3      LAST MODIFIED: 01/30/95   BY: qzl  *G0DD*         */
/* REVISION: 7.3      LAST MODIFIED: 03/09/95   BY: pxe  *G0GW*         */
/* REVISION: 7.3      LAST MODIFIED: 03/14/95   BY: ais  *G0HC*         */
/* REVISION: 7.3      LAST MODIFIED: 06/09/95   BY: qzl  *G0PT*         */
/* REVISION: 7.3      LAST MODIFIED: 06/20/95   BY: str  *G0N9*         */
/* REVISION: 8.5      LAST MODIFIED: 09/05/95   BY: srk  *J07G*         */
/* REVISION: 7.3      LAST MODIFIED: 01/29/96   BY: jym  *G1LC*         */
/* REVISION: 8.5      LAST MODIFIED: 06/20/96   BY: taf  *J0VG*         */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane    */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 8.6E     LAST MODIFIED: 11/19/99   BY: *J3MK* Prashanth Narayan  */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 07/25/00   BY: *N0GD* Peggy Ng           */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Old ECO marker removed, but no ECO header exists *GOGW*                    */
/* Revision: 1.6.1.8      BY: Katie Hilbert      DATE: 05/15/02  ECO: *P06H*  */
/* $Revision: 1.6.1.9 $           BY: Nishit V           DATE: 12/10/02  ECO: *N21K*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
{mfdtitle.i "111217.1"}

define new shared variable site           like si_site.
define new shared variable site1          like si_site.
define new shared variable wkctr          like op_wkctr initial "HPS".
define new shared variable wkctr1         like op_wkctr initial "HPS".
define new shared variable part           like ps_par
                                          label "父零件".
define new shared variable part1          like ps_par.
define new shared variable comp1          like ps_comp
                                          label "子零件".
define new shared variable comp2          like ps_comp.
define new shared variable desc1          like pt_desc1.
define new shared variable desc2          like pt_desc1.
define new shared variable issue          like wo_rel_date
                                          label "生产日期".
define new shared variable issue1         like wo_rel_date.
define new shared variable reldate        like wo_rel_date
                                          label "发放日期".
define new shared variable reldate1       like wo_rel_date.
define new shared variable nbr            as character format "x(10)"
                                          label "Picklist Number".
define new shared variable delete_pklst   like mfc_logical initial no
                                          label "Delete When Done".
define new shared variable nbr_replace    as character format "x(10)".
define new shared variable qtyneed        like wod_qty_chg
                                          label "Qty Required".
define new shared variable netgr          like mfc_logical initial yes
                                          label "Use Work Center Inventory".
define new shared variable detail_display like mfc_logical initial  no
                                          label "Detail Requirements".
define new shared variable um             like pt_um.
define new shared variable wc_qoh         like ld_qty_oh.
define new shared variable temp_qty       like wod_qty_chg.
define new shared variable temp_nbr       like lad_nbr.
define new shared variable ord_max        like pt_ord_max.
define new shared variable comp_max       like wod_qty_chg.
define new shared variable pick-used      like mfc_logical.
define new shared variable isspol         like pt_iss_pol.

nbr_replace = getTermLabel("TEMPORARY",10).

assign issue = today
       issue1 = today
       reldate = today
       reldate1 = today.
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM
   site           label "地点" colon 22
   site1          label "到" colon 49 skip
   part           label "父零件" colon 22
   part1          label "到" colon 49 skip
   comp1          label "子零件" colon 22
   comp2          label "到" colon 49 skip
   wkctr          label "工作中心" colon 22
   wkctr1         label "到" colon 49 skip
   issue          label "生产日期" colon 22
   issue1         label "到" colon 49
   reldate        label "发放日期" colon 22
   reldate1       label "到" colon 49 skip(1)
   netgr          label "使用工作中心库存" colon 30
   detail_display label "详细需求量" colon 30
   nbr            label "领料单号" colon 30
   delete_pklst   label "完成删除" colon 30
with frame a side-labels width 80 attr-space.
/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME

/* 取消自动翻译 Frame
setFrameLabels(frame a:handle).
*/
if not can-find(first rpc_ctrl) then do transaction:
   create rpc_ctrl.
   release rpc_ctrl.
end.

assign
   site  = global_site
   site1 = global_site.

repeat:

   find first rpc_ctrl no-lock no-error.
   nbr = rpc_nbr_pre + string(rpc_nbr).

   if site1    = hi_char  then site1    = "".
   if part1    = hi_char  then part1    = "".
   if comp2    = hi_char  then comp2    = "".
   if issue    = low_date then issue    = ?.
   if wkctr1   = hi_char  then wkctr1   = "".
   if issue1   = hi_date  then issue1   = ?.
   if reldate  = low_date then reldate  = ?.
   if reldate1 = hi_date  then reldate1 = ?.

   display nbr with frame a.

   update
      site  site1
      part  part1
      comp1 comp2
      wkctr wkctr1
      issue issue1
      reldate reldate1
      netgr
      detail_display
      nbr
      delete_pklst
   with frame a.

   if delete_pklst then nbr = mfguser.

   bcdparm = "".

   {gprun.i ""gpquote.p"" "(input-output bcdparm,16,
        site,site1,part,part1,comp1,comp2,wkctr,wkctr1,
        string(issue),string(issue1),string(reldate),string(reldate1),
        string(netgr),string(detail_display),nbr,string(delete_pklst),
        null_char,null_char,null_char,null_char)"}

   if site1    = "" then site1    = hi_char.
   if part1    = "" then part1    = hi_char.
   if comp2    = "" then comp2    = hi_char.
   if wkctr1   = "" then wkctr1   = hi_char.
   if issue    = ?  then issue    = low_date.
   if issue1   = ?  then issue1   = hi_date.
   if reldate  = ?  then reldate  = low_date.
   if reldate1 = ?  then reldate1 = hi_date.

   if not batchrun then do:
      {gprun.i ""gpsirvr.p""
         "(input site, input site1, output return_int)"}
      if return_int = 0 then do:
         next-prompt site with frame a.
         undo , retry.
      end.
   end.

   /* OUTPUT DESTINATION SELECTION */
   {xxgpselout.i &printType = "printer"
               &printWidth = 130
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "yes"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}
 
   {mfphead.i}

   /* REPKUPA.P ATTEMPS TO APPLY PHANTOM USE-UP LOGIC WHICH DOES NOT    */
   /* APPLY TO THE REPETITVE MODULE.  THEREFORE, DO NOT CALL REPKUPA.P  */

   {gprun.i ""xxrepkupd0.p""}

   /* ADDED SECTION TO DELETE 'FLAG' lad_det, AS WELL AS PICKLISTS
      THAT WERE CREATED THIS SESSION BUT SHOULD BE DELETED         */

   {gprun.i ""repkupc.p""}

   /* REPORT TRAILER  */
   {mfrtrail.i}
   if temp_nbr = rpc_nbr_pre + string(rpc_nbr)
      and pick-used
      and not delete_pklst
   then do transaction:

      {gprun.i ""gpnbr.p"" "(16,input-output nbr)"}
      find first rpc_ctrl exclusive-lock.
      rpc_nbr = integer(substring(nbr,length(rpc_nbr_pre) + 1)).
      release rpc_ctrl.
   end.

end.  /* REPEAT */
