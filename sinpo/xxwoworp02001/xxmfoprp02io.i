/* mfoprp.i - WORK ORDER OPERATION LIST INCLUDE FILE                      */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                    */
/* All rights reserved worldwide.  This is an unpublished work.           */
/* $Revision: 1.9 $                                                       */
/*V8:ConvertMode=Report                                                   */
/* REVISION: 1.0      LAST EDIT: 05/12/86  MODIFIED BY: EMB               */
/* REVISION: 4.0      LAST EDIT: 02/21/88  MODIFIED BY: WUG *A194*        */
/* REVISION: 5.0      LAST EDIT: 10/26/89  MODIFIED BY: emb *B357*        */
/* REVISION: 7.0      LAST EDIT: 07/28/94  MODIFIED BY: qzl *FP65*        */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane      */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan     */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KR* myb            */
/* Old ECO marker removed, but no ECO header exists *F0PN*                */
/* Revision: 1.7  BY: Tiziana Giustozzi DATE: 09/16/01 ECO: *N12M* */
/* $Revision: 1.9 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00G* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE mfoprp_i_1 "Status"
/* MaxLen: Comment: */

&SCOPED-DEFINE mfoprp_i_2 "Std Run"
/* MaxLen: Comment: */

&SCOPED-DEFINE mfoprp_i_3 "Std Setup"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define variable setup like wr_setup label {&mfoprp_i_3}.
define variable runtime like wr_run label {&mfoprp_i_2} format ">>>,>>9.999".
define variable op_status as character format "x(8)" label {&mfoprp_i_1}.

/*35*/ if not can-find (first wr_route where wr_route.wr_domain = global_domain
/*35*/                    and wr_lot = wo_lot) then do:
/*35*/        create xxwoworp02wr.
/*35*/        assign xx_wr_wo_lot = wo_lot.
/*35*/ end.

for each wr_route  where wr_route.wr_domain = global_domain and  wr_lot =
wo_lot no-lock by wr_op /*35 with frame c */:

   /* SET EXTERNAL LABELS */
/*35   setFrameLabels(frame c:handle).           */

   if wr_qty_ord >= 0 then
      open_ref = max(wr_qty_ord - (wr_qty_comp + wr_sub_comp),0).
   else
      open_ref = min(wr_qty_ord - (wr_qty_comp + wr_sub_comp),0).

   if wo_status = "C" or wr_status = "C" then open_ref = 0.

   setup = 0.

   if index("rc",wr_status) = 0
      and wr_act_run = 0
      and wr_qty_comp = 0
   then setup = wr_setup.

   runtime = open_ref * wr_run.

   {mfwrstat.i op_status}
    create xxwoworp02wr.
    assign xx_wr_wo_lot = wo_lot
           xx_wr_desc1 = desc1
           xx_wr_rcpt_userid = rcpt_userid
           xx_wr_rcpt_date = rcpt_date
           xx_wr_op = wr_op
           xx_wr_std_op = wr_std_op
           xx_wr_desc = wr_desc
           xx_wr_wkctr = wr_wkctr
           xx_wr_start = wr_start
           xx_wr_due = wr_due
           xx_wr_setup = setup
           xx_wr_runtime = runtime
           xx_wr_open_ref = open_ref
           xx_wr_op_status = op_status.
/*35   if page-size - line-counter < 2 then page.                         */
/*35                                                                      */
/*35   display                                                            */
/*35      wr_op                                                           */
/*35      wr_std_op                                                       */
/*35      wr_desc                                                         */
/*35      wr_wkctr                                                        */
/*35      wr_start                                                        */
/*35      wr_due                                                          */
/*35      setup                                                           */
/*35      runtime                                                         */
/*35      open_ref                                                        */
/*35      op_status                                                       */
/*35   with width 132 no-attr-space.                                      */
/*35                                                                      */

   find wc_mstr
      where wc_mstr.wc_domain = global_domain and  wc_wkctr = wr_wkctr and
      wc_mch = wr_mch
   no-lock no-error.
   if available wc_mstr then do:
      assign xx_wr_wc_desc = wc_desc.
   end.

/*35   if available wc_mstr then put space(38) wc_desc skip.                */
/*35                                                                        */
/*35   if page-size - line-counter < 2 then page.                           */

end.
