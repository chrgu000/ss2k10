/* GUI CONVERTED from wowoisrc.p (converter v1.78) Mon Nov 22 00:43:44 2010 */
/* wowoisrc.p - WORK ORDER RECEIPT BACKFLUSH                                  */
/* Copyright 1986-2010 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* REVISION: 6.0      LAST MODIFIED: 05/24/90   BY: emb                       */
/* REVISION: 6.0      LAST MODIFIED: 03/14/91   BY: emb *D413*                */
/* REVISION: 6.0      LAST MODIFIED: 04/24/91   BY: ram *D581*                */
/* REVISION: 6.0      LAST MODIFIED: 07/02/91   BY: emb *D741*                */
/* REVISION: 6.0      LAST MODIFIED: 07/02/91   BY: emb *D744*                */
/* REVISION: 6.0      LAST MODIFIED: 08/29/91   BY: emb *D841*                */
/* REVISION: 6.0      LAST MODIFIED: 10/03/91   BY: alb *D887*                */
/* REVISION: 6.0      LAST MODIFIED: 11/27/91   BY: ram *D954*                */
/* REVISION: 7.0      LAST MODIFIED: 01/28/92   BY: pma *F104*                */
/* REVISION: 7.0      LAST MODIFIED: 09/11/92   BY: ram *F896*                */
/* REVISION: 7.3      LAST MODIFIED: 09/30/92   BY: ram *G115*                */
/* REVISION: 7.3      LAST MODIFIED: 10/21/92   BY: emb *G216*                */
/* REVISION: 7.3      LAST MODIFIED: 09/27/93   BY: jcd *G255*                */
/* REVISION: 7.3      LAST MODIFIED: 11/09/92   BY: emb *G292*                */
/* REVISION: 7.3      LAST MODIFIED: 02/03/93   BY: fwy *G630*(rev only)      */
/* REVISION: 7.3      LAST MODIFIED: 02/09/93   BY: emb *G656*(rev only)      */
/* REVISION: 7.3      LAST MODIFIED: 03/04/93   BY: ram *G782*                */
/* REVISION: 7.3      LAST MODIFIED: 07/06/93   BY: pma *GD11*(rev only)      */
/* REVISION: 7.3      LAST MODIFIED: 08/18/93   BY: pxd *GE21*(rev only)      */
/* REVISION: 7.3      LAST MODIFIED: 09/08/93   BY: emb *GE91*                */
/* REVISION: 7.3      LAST MODIFIED: 09/15/93   BY: ram *GF19*(rev only)      */
/* REVISION: 7.4      LAST MODIFIED: 07/22/93   BY: pcd *H039*                */
/* REVISION: 7.2      LAST MODIFIED: 02/17/94   BY: ais *FL87*                */
/* Oracle changes (share-locks)      09/15/94   BY: rwl *GM56*                */
/* REVISION: 7.2      LAST MODIFIED: 09/28/94   BY: ljm *GM78*                */
/* REVISION: 7.3      LAST MODIFIED: 10/31/94   BY: wug *GN76*                */
/* REVISION: 8.5      LAST MODIFIED: 12/08/94   BY: mwd *J034*                */
/* REVISION: 8.5      LAST MODIFIED: 12/09/94   BY: taf *J038*                */
/* REVISION: 8.5      LAST MODIFIED: 01/05/95   BY: ktn *J041*                */
/* REVISION: 8.5      LAST MODIFIED: 01/05/95   BY: pma *J040*                */
/* REVISION: 8.5      LAST MODIFIED: 03/08/95   BY: dzs *J046*                */
/* REVISION: 8.5      LAST MODIFIED: 03/29/95   BY: dzn *F0PN*                */
/* REVISION: 7.2      LAST MODIFIED: 04/13/95   BY: srk *G0KT*                */
/* REVISION: 8.5      LAST MODIFIED: 10/03/95   BY: tjs *J082*                */
/* REVISION: 8.5      LAST MODIFIED: 11/01/95   BY: tjs *J08X*                */
/* REVISION: 7.3      LAST MODIFIED: 12/12/95   BY: rvw *G1FL*                */
/* REVISION: 8.5      LAST MODIFIED: 03/06/96   BY: kxn *J09C*                */
/* REVISION: 8.5      LAST MODIFIED: 01/18/96   BY: *J0FY* bholmes            */
/* REVISION: 8.5      LAST MODIFIED: 04/15/96   BY: *J04C* Sue Poland         */
/* REVISION: 8.5      LAST MODIFIED: 04/15/96   BY: *J04C* Markus Barone      */
/* REVISION: 8.5      LAST MODIFIED: 04/18/96   BY: *G1Q9* Julie Milligan     */
/* REVISION: 8.5      LAST MODIFIED: 04/26/96   BY: *J0KF* BHolmes            */
/* REVISION: 8.6      LAST MODIFIED: 06/11/96   BY: *K001* ejh                */
/* REVISION: 8.5      LAST MODIFIED: 06/24/96   BY: *G1XY* RWitt              */
/* REVISION: 8.5      LAST MODIFIED: 07/08/96   BY: *J0Y1* kxn                */
/* REVISION: 8.5      LAST MODIFIED: 07/16/96   BY: *J0QX* kxn                */
/* REVISION: 8.5      LAST MODIFIED: 07/23/96   BY: *J10N* GWM                */
/* REVISION: 8.6      LAST MODIFIED: 02/04/97   BY: *J1GW* Murli Shastri      */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.5      LAST MODIFIED: 04/15/98   BY: *J2K7* Fred Yeadon        */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 06/04/99   BY: *J3DH* Satish Chavan      */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Patti Gaultney     */
/* REVISION: 9.1      LAST MODIFIED: 10/25/99   BY: *N002* Steve Nugent       */
/* REVISION: 9.1      LAST MODIFIED: 02/11/00   BY: *J3P4* Sachin Shinde      */
/* REVISION: 9.1      LAST MODIFIED: 02/23/00   BY: *M0JN* Kirti Desai        */
/* REVISION: 9.1      LAST MODIFIED: 03/06/00   BY: *N05Q* Vincent Koh        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 04/13/00   BY: *L0TJ* Jyoti Thatte       */
/* REVISION: 9.1      LAST MODIFIED: 05/10/00   BY: *N091* Vandna Rohira      */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KC* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 08/16/00   BY: *N0LH* Arul Victoria      */
/* REVISION: 9.1      LAST MODIFIED: 01/08/01   BY: *L171* Vivek Gogte        */
/* Revision: 1.24          BY: Niranjan R.      DATE: 07/13/01  ECO: *P00L*   */
/* Revision: 1.25          BY: Robin McCarthy   DATE: 11/26/01  ECO: *P023*   */
/* Revision: 1.26          BY: Jean Miller      DATE: 05/17/02  ECO: *P05V*   */
/* Revision: 1.28          BY: Niranjan R.      DATE: 06/25/02  ECO: *P09L*   */
/* Revision: 1.29          BY: Vivek Gogte      DATE: 08/06/02  ECO: *N1QQ*   */
/* Revision: 1.30          BY: Kirti Desai      DATE: 01/23/03  ECO: *N241*   */
/* Revision: 1.32          BY: Dorota Hohol     DATE: 02/25/03  ECO: *P0N6*   */
/* Revision: 1.33          BY: Narathip W.      DATE: 04/29/03  ECO: *P0QN*   */
/* Revision: 1.35          BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00N*  */
/* Revision: 1.38          BY: Hareesh V.       DATE: 09/17/03  ECO: *P132*   */
/* Revision: 1.39          BY: Ken Casey        DATE: 02/19/04  ECO: *N2GM*   */
/* Revision: 1.40          By: Chi Liu          DATE: 07/07/05  ECO: *P3S7*   */
/* Revision: 1.41          By: Jean Miller      DATE: 01/10/06  ECO: *Q0PD*   */
/* Revision: 1.41.1.2      By: Ashim Mishra     DATE: 03/22/07  ECO: *P5RK*   */
/* Revision: 1.41.1.6      By: Archana Kirtane  DATE: 09/27/07  ECO: *P68H*   */
/* $Revision: 1.41.1.7 $      By: Shivakumar Patil DATE: 11/11/10  ECO: *Q4GM*   */
/*-Revision end---------------------------------------------------------------*/


/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*V8:ConvertMode=Maintenance                                                  */
{mfdtitle.i "1+ "}
{cxcustom.i "WOWOISRC.P"}

{gldydef.i new}
{gldynrm.i new}

define new shared variable gldetail like mfc_logical no-undo initial no.
define new shared variable gltrans like mfc_logical no-undo initial no.
define new shared variable rmks like tr_rmks.
define new shared variable serial like tr_serial.
define new shared variable conv like um_conv label "Conversion" no-undo.
define new shared variable reject_conv like conv no-undo.
define new shared variable pl_recno as recid.
define new shared variable close_wo like mfc_logical label "Close".
define new shared variable undo_all like mfc_logical no-undo.
define new shared variable comp like ps_comp.
define new shared variable qty like wo_qty_ord.
define new shared variable leadtime like pt_mfg_lead.
define new shared variable prev_status like wo_status.
define new shared variable prev_release like wo_rel_date.
define new shared variable prev_due like wo_due_date.
define new shared variable prev_qty like wo_qty_ord.
define new shared variable prev_site like wo_site.
define new shared variable del-yn like mfc_logical.
define new shared variable deliv like wod_deliver.
define new shared variable any_issued like mfc_logical.
define new shared variable any_feedbk like mfc_logical.
define new shared variable part like wod_part.
define new shared variable nbr like wo_nbr.
define new shared variable yn like mfc_logical.
define new shared variable sf_cr_acct like dpt_lbr_acct.
define new shared variable sf_cr_sub  like dpt_lbr_sub .
define new shared variable sf_dr_acct like dpt_lbr_acct.
define new shared variable sf_dr_sub  like dpt_lbr_sub .
define new shared variable sf_cr_cc like dpt_lbr_cc.
define new shared variable sf_dr_cc like dpt_lbr_cc.
define new shared variable sf_cr_proj like glt_project.
define new shared variable sf_dr_proj like glt_project.
define new shared variable sf_gl_amt like tr_gl_amt.
define new shared variable sf_entity like en_entity.
define new shared variable eff_date like glt_effdate.
define new shared variable ref like glt_ref.
define new shared variable i as integer.
define new shared variable wopart_wip_acct like pl_wip_acct.
define new shared variable wopart_wip_sub  like pl_wip_sub .
define new shared variable wopart_wip_cc like pl_wip_cc.
define new shared variable wo_recno as recid.
define new shared variable site like sr_site no-undo.
define new shared variable location like sr_loc no-undo.
define new shared variable lotref like sr_ref format "x(8)" no-undo.
define new shared variable lotserial like sr_lotser no-undo.
define new shared variable lotserial_qty like sr_qty no-undo.
define new shared variable multi_entry as logical label "Multi Entry" no-undo.
define new shared variable lotserial_control as character.
define new shared variable cline as character.
define new shared variable row_nbr as integer.
define new shared variable col_nbr as integer.
define new shared variable total_lotserial_qty like wod_qty_chg.
define new shared variable wo_recid as recid.
define new shared variable wod_recno as recid.
define new shared variable outta_here as logical initial "no" no-undo.
define new shared variable rejected   as logical initial "no" no-undo.
define new shared variable critical-part like wod_part    no-undo.
define new shared variable critical_flg  like mfc_logical no-undo.
define new shared variable jp like mfc_logical.
define new shared variable joint_type like wo_joint_type.
define new shared variable base like mfc_logical.
define new shared variable base_id like wo_base_id.
define new shared variable jp-yn like mfc_logical.
define new shared variable recv like mfc_logical initial yes.
define new shared variable recv_all like mfc_logical initial no.
define new shared variable open_ref like sr_qty.
define new shared variable um like pt_um no-undo.
define new shared variable tot_units like wo_qty_chg.
define new shared variable reject_um like pt_um no-undo.
define new shared variable reject_qty like wo_rjct_chg no-undo.
define new shared variable trans_um like pt_um.
define new shared variable transtype as character
   initial "RCT-WO".
define new shared variable trans_conv like sod_um_conv.
define new shared variable msg-counter as integer no-undo.
define new shared variable recpt-bkfl like mfc_logical initial yes.
define new shared variable back_qty like sr_qty.
define new shared variable undo_setd like mfc_logical no-undo.
define new shared variable undo_jp like mfc_logical.
define new shared variable issue_or_receipt as character.
define new shared variable chg_attr like mfc_logical no-undo
   label "Set Attributes".
define new shared variable wolot like wo_lot.
define new shared variable h_wiplottrace_procs as handle no-undo.
define new shared variable h_wiplottrace_funcs as handle no-undo.

define variable qopen like wod_qty_all label "Qty Open".
define variable desc1 like pt_desc1.
define variable trlot like tr_lot.
define variable qty_left like tr_qty_chg.
define variable j as integer.
define variable tot_lad_all like lad_qty_all.
define variable ladqtychg like lad_qty_all.
define variable sub_comp like mfc_logical label "Substitute".
define variable firstpass like mfc_logical.
define variable cancel_bo as logical label "Cancel B/O".
define variable fas_wo_rec like fac_wo_rec.
define variable regular like mfc_logical initial yes.
define variable issue like mfc_logical label "Backflush" initial yes.
{&WOWOISRC-P-TAG5}
define variable receive like mfc_logical label "Receive" initial yes.
{&WOWOISRC-P-TAG6}
define variable backqty like sr_qty.
define variable base_qty like sr_qty.
define variable parent_item like pt_part.
define variable base_item like pt_part.
define variable reg as character format "x(1)".
define variable parent_qty like sr_qty.
define variable glcost like sct_cst_tot.
define variable msgref like tr_msg.
define variable oldlot like sr_lotser .
define variable trans_ok like mfc_logical.
define variable w-file-type as character format "x(25)".
define variable w_nbr like wo_mstr.wo_nbr.
define variable w_wip_site like si_mstr.si_site.
define variable w_wo_lot   like wo_mstr.wo_lot.
define variable w_part     like pt_mstr.pt_part.
define variable w-te_nbr as integer.
define variable w-te_type as character.
define variable w-datastr as character format "x(255)".
define variable w-len as integer.
define variable w-counter as integer.
define variable w-tstring as character format "x(50)".
define variable w-group as character format "x(18)".
define variable w-str-len as integer.
define variable w-update as character format "x".
define variable w-sent as integer initial 0.
define variable routing_code as character no-undo.
define variable dummy_gl_amt like tr_gl_amt no-undo.
define variable l_entered_wo_recid as recid no-undo.
{&WOWOISRC-P-TAG1}

define buffer womstr for wo_mstr.

/*DEFINE VARIABLES FOR CHANGE ATTRIBUTES FEATURE*/
{gpatrdef.i "new shared"}

{wlfnc.i} /* FUNCTION FORWARD DECLARATIONS */
{wlcon.i} /* CONSTANTS DEFINITIONS         */

{gpglefv.i}
{&WOWOISRC-P-TAG4}

if is_wiplottrace_enabled()
then do:
   {gprunmo.i
      &program="wlpl.p""
      &module="AWT"
      &persistent="""persistent set h_wiplottrace_procs"""}

   {gprunmo.i
      &program=""wlfl.p""
      &module="AWT"
      &persistent="""persistent set h_wiplottrace_funcs"""}
end. /*IF is_wiplottrace_enabled()*/

/* INPUT OPTION FORM */
{&WOWOISRC-P-TAG7}

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
wo_nbr      colon 12 wo_lot      eff_date    colon 68
   wo_part     colon 12 wo_status   receive     colon 68
   desc1       at 14 no-label       issue       colon 68
 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME


{&WOWOISRC-P-TAG8}

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
skip (1)
   recv_all colon 40 label "Receive All Co/By-Products"
   recv     colon 40 label "Receipt Qty = Open Qty"
   skip (1)
 SKIP(.4)  /*GUI*/
with frame r side-labels overlay row 9 column 19

width 50 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-r-title AS CHARACTER.
 F-r-title = (getFrameTitle("CO/BY-PRODUCTS_RECEIPT_OPTIONS",42)).
 RECT-FRAME-LABEL:SCREEN-VALUE in frame r = F-r-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame r =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame r + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame r =
  FRAME r:HEIGHT-PIXELS - RECT-FRAME:Y in frame r - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME r = FRAME r:WIDTH-CHARS - .5. /*GUI*/


/* SET EXTERNAL LABELS */
setFrameLabels(frame r:handle).

/* ASSIGN LABEL MANUALLY */
if dynamic-function('getTranslateFramesFlag' in h-label) then
   recv:label = string(getTermLabel("RECEIPT_QTY",20) + " = "
              + getTermLabel("OPEN_QTY",16)).

assign
   issue_or_receipt = getTermLabel("ISSUE",8)
   eff_date         = today.

do transaction:

   find mfc_ctrl exclusive-lock
       where mfc_ctrl.mfc_domain = global_domain and  mfc_field = "fas_wo_rec"
      no-error.
   if available mfc_ctrl
   then do:
      find first fac_ctrl  where fac_ctrl.fac_domain = global_domain
      exclusive-lock no-error.
      if available fac_ctrl
      then do:
         fac_wo_rec = mfc_logical.
         delete mfc_ctrl.
      end. /* IF AVAILABLE fac_ctrl */
      release fac_ctrl.
   end. /* IF AVAILABLE mfc_ctrl */

   release mfc_ctrl.

   for first fac_ctrl
      fields( fac_domain fac_wo_rec)
       where fac_ctrl.fac_domain = global_domain no-lock:
   end. /* FOR FIRST fac_ctrl */

   if available fac_ctrl
   then
      fas_wo_rec = fac_wo_rec.

end. /* DO TRANSACTION */

/* DISPLAY */
mainloop:
repeat:
/*GUI*/ if global-beam-me-up then undo, leave.

   {&WOWOISRC-P-TAG2}
   do transaction:
/*GUI*/ if global-beam-me-up then undo, leave.


      for each sr_wkfl
         exclusive-lock
          where sr_wkfl.sr_domain = global_domain and  sr_userid = mfguser:
         delete sr_wkfl.
      end. /* FOR EACH sr_wkfl */

      {gprun.i ""gplotwdl.p""}
/*GUI*/ if global-beam-me-up then undo, leave.


      /* DELETE STRANDED lad_det RECORDS  */
      for each lad_det exclusive-lock
             where lad_det.lad_domain = global_domain and  lad_dataset  =
             "wod_det"
            and lad_nbr      = wolot
            and lad_qty_all  = 0
            and lad_qty_pick = 0:
         delete lad_det.
      end. /* FOR EACH lad_det ... */

   end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* DO TRANSACTION */

   assign
      regular = yes
      jp      = no
      nbr     = "".

   {&WOWOISRC-P-TAG9}
   display
      eff_date
      issue
      receive
      {&WOWOISRC-P-TAG10}
   with frame a.

   prompt-for
      wo_nbr
      wo_lot
      eff_date
      receive
      issue
      {&WOWOISRC-P-TAG11}
   with frame a
   editing:

      if frame-field = "wo_nbr"
      then do:
         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp.i wo_mstr wo_nbr  " wo_mstr.wo_domain = global_domain and wo_nbr
         "  wo_nbr wo_nbr wo_nbr}
      end. /* IF FRAME-FIELD = "wo_nbr" */

      else if frame-field = "wo_lot"
      then do:
         /* FIND NEXT/PREVIOUS RECORD */
         if input wo_nbr <> ""
         then do:
            {mfnp01.i
               wo_mstr
               wo_lot
               wo_lot
               "input wo_nbr"
                " wo_mstr.wo_domain = global_domain and wo_nbr "
               wo_nbr}
         end. /* IF INPUT wo_nbr <> "" */
         else do:
            {mfnp.i wo_mstr wo_lot  " wo_mstr.wo_domain = global_domain and
            wo_lot "  wo_lot wo_lot wo_lot}
         end. /* ELSE DO */
      end. /* IF FRAME-FIELD = "wo_lot" */

      else do:
         status input.
         readkey.
         apply lastkey.
      end. /* ELSE DO */

      if recno <> ?
      then do:
         wolot = wo_lot.
         desc1 = "".
         for first pt_mstr
            fields( pt_domain pt_loc pt_desc1 pt_part pt_prod_line)
             where pt_mstr.pt_domain = global_domain and  pt_part = wo_part
            no-lock:
            desc1 = pt_desc1.
         end. /* FOR FIRST pt_mstr */
         display
            wo_nbr
            wo_lot
            wo_part
            wo_status
            desc1
            with frame a.
      end. /* IF recno <> ? */

      else
         wolot = input wo_lot.

   end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* EDITING */

   assign
      eff_date
      issue
      receive.
   {&WOWOISRC-P-TAG12}
   if eff_date = ?
   then
      eff_date = today.

   /* CHECK EFFECTIVE DATE */
   nbr = input wo_nbr.
   if input wo_nbr <> ""
   then
if not can-find(first wo_mstr using  wo_nbr where wo_mstr.wo_domain =
global_domain ) then do:

         {pxmsg.i &MSGNUM=503 &ERRORLEVEL=3}.
         undo, retry.
      end. /* IF NOT CAN-FIND */

   if nbr = ""
   and input wo_lot = ""
   then
      undo, retry.


   if wo_nbr:MODIFIED = true and
      wo_lot:MODIFIED = true
   then do:
      if input wo_nbr  <> "" and
         input wo_lot <> ""
      then
         for first wo_mstr
            use-index wo_lot
            using  wo_lot and wo_nbr
            where wo_mstr.wo_domain = global_domain
            no-lock:
         end. /* FOR FIRST wo_mstr */
      else
      if input wo_nbr <> ""
      then
         for first wo_mstr
            use-index wo_nbr
            using  wo_nbr
            where wo_mstr.wo_domain = global_domain
            no-lock:
         end. /* FOR FIRST wo_mstr */
      if input wo_lot <> ""
      then
         for first wo_mstr
            use-index wo_lot
            using  wo_lot
            where wo_mstr.wo_domain = global_domain
            no-lock:
         end. /* FOR FIRST wo_mstr */
   end. /* IF wo_nbr:MODIFIED     = true */

   if wo_nbr:MODIFIED = false and
      wo_lot:MODIFIED = true
   then do:
      if input wo_lot <> ""
      then
         for first wo_mstr
            use-index wo_lot
            using  wo_lot
            where wo_mstr.wo_domain = global_domain
            no-lock:
         end. /* FOR FIRST wo_mstr */
      else
         for first wo_mstr
            use-index wo_nbr
            using  wo_nbr
            where wo_mstr.wo_domain = global_domain
            no-lock:
         end. /* FOR FIRST wo_mstr */
   end. /* IF wo_nbr:MODIFIED     = false */

   if wo_nbr:MODIFIED = true and
      wo_lot:MODIFIED = false
   then do:
      if input wo_nbr <> ""
      then
         for first wo_mstr
            use-index wo_nbr
            using  wo_nbr
            where wo_mstr.wo_domain = global_domain
            no-lock:
         end. /* FOR FIRST wo_mstr */
      else
         for first wo_mstr
            use-index wo_lot
            using  wo_lot
            where wo_mstr.wo_domain = global_domain
            no-lock :
         end. /* FOR FIRST wo_mstr */

   end. /* ELSE IF wo_nbr:MODIFIED      = true */

   if wo_nbr:MODIFIED = false and
      wo_lot:MODIFIED = false
   then do:
      for first wo_mstr
         use-index wo_lot
         using  wo_lot and wo_nbr
         where wo_mstr.wo_domain = global_domain
         no-lock:
      end. /* FOR FIRST wo_mstr */
   end. /* IF wo_nbr:MODIFIED     = false */

   if not available wo_mstr
   then do:
      if input wo_lot <> ""
      then
         for first wo_mstr
            use-index wo_lot
            using  wo_lot
            where wo_mstr.wo_domain = global_domain
            no-lock:
         end. /* FOR FIRST wo_mstr */

   end. /* IF NOT AVAILABLE wo_mstr */

   desc1 = "".

   if available wo_mstr
   then do:
      display
         wo_nbr
         wo_part
         wo_lot
         wo_status
         desc1
      with frame a.
   end. /* IF AVAILABLE wo_mstr */
   else do:
      /*  WORK ORDER DOES NOT EXIST.*/
      {pxmsg.i &MSGNUM=510 &ERRORLEVEL=3}
      undo, retry.
   end.


   for first si_mstr
      fields( si_domain si_entity si_site)
       where si_mstr.si_domain = global_domain and  si_site = wo_site
      no-lock:
   end. /* FOR FIRST si_mstr */

   {gpglef1.i &module = ""WO""
      &entity = si_entity
      &date = eff_date
      &prompt = "eff_date"
      &frame = "a"
      &loop = "mainloop"}


   if input wo_lot <> "" or
      input wo_lot <> " "
   then
      wolot = input wo_lot.
   else
      wolot = wo_lot.

   /* DON'T ALLOW PROJECT ACTIVITY RECORDING WORK ORDERS */
   if wo_fsm_type = "PRM"
   then do:
      /* CONTROLLED BY PRM MODULE */
      {pxmsg.i &MSGNUM=3426 &ERRORLEVEL=3}
      undo, retry.
   end. /* IF wo_fsm_type = "PRM" */

   if lookup(wo_status,"A,R" ) = 0
      and (issue or receive)
   then do:
      /* WORK ORDER LOT IS CLOSED, PLANNED OR FIRM PLANNED */
      {pxmsg.i &MSGNUM=523 &ERRORLEVEL=3}
      /* CURRENT WORK ORDER STATUS: */
      {pxmsg.i &MSGNUM=525 &ERRORLEVEL=1 &MSGARG1=wo_status}
      undo, retry.
   end. /* IF LOOKUP(wo_status,"A,R" ) = 0 */

   /* DON'T ALLOW CALL ACTIVITY RECORDING WORK ORDERS */
   if wo_fsm_type = "FSM-RO"
   then do:
      /* FIELD SERVICE CONTROLLED */
      {pxmsg.i &MSGNUM=7492 &ERRORLEVEL=3}
      undo, retry.
   end. /* IF wo_fsm_type = "FSM-RO" */

   {gprun.i ""gpsiver.p""
      "(input wo_site,
        input ?,
        output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

   if return_int = 0
   then do:
      /* USER DOES NOT HAVE ACCESS TO SITE XXXXX*/
      {pxmsg.i &MSGNUM=2710 &ERRORLEVEL=3 &MSGARG1=wo_site}
      undo mainloop, retry.
   end. /* IF return_int = 0 */

   if wo_type = "c"
   and wo_nbr = ""
   then do:
      {pxmsg.i &MSGNUM=5123 &ERRORLEVEL=3}
      undo, retry.
   end. /* IF wo_type = "c" */

   if wo_type = "w"
   then do:
      /* WORD ORDER TYPE IS FLOW */
      {pxmsg.i &MSGNUM=5285 &ERRORLEVEL=3}
      undo, retry.
   end. /* IF wo_type = "w" */

   if is_wiplottrace_enabled()
   then do:

      routing_code = if wo_routing = ""
                     then
                        wo_part
                     else
                        wo_routing.

      for last wlrm_mstr
         fields( wlrm_domain wlrm_end wlrm_routing wlrm_start wlrm_trc_parent)
          where wlrm_mstr.wlrm_domain = global_domain and (  wlrm_routing =
          routing_code
         and wlrm_start <= eff_date
         and (wlrm_end >= eff_date or wlrm_end = ?)
      ) no-lock:
      end. /* FOR LAST wlrm_mstr */

      if not available wlrm_mstr
      then do:
         for first wlrm_mstr
            fields( wlrm_domain wlrm_end wlrm_routing wlrm_start
            wlrm_trc_parent)
             where wlrm_mstr.wlrm_domain = global_domain and (  wlrm_routing =
             routing_code
            and wlrm_start = ?
            and (wlrm_end >= eff_date or wlrm_end = ?)
         ) no-lock:
         end. /* FOR FIRST wlrm_mstr */
      end. /* IF NOT AVAILABLE wlrm_mstr */

      if available wlrm_mstr
      and wlrm_trc_parent
      then do:
         /* WIP LOT TRACE ENABLED.  USE WORK ORDER BACKFLUSH */
         {pxmsg.i &MSGNUM=8552 &ERRORLEVEL=3}
         undo, retry.
      end. /* IF AVAILABLE wlrm_mstr */
      else do:
         for first wlc_ctrl
            fields( wlc_domain wlc_trc_parents wlc_enable_wlt)
             where wlc_ctrl.wlc_domain = global_domain no-lock:
         end. /* FOR FIRST wlc_ctrl */
         if wlc_trc_parent
         then do:
            /* WIP LOT TRACE ENABLED.  USE WORK ORDER BACKFLUSH */
            {pxmsg.i &MSGNUM=8552 &ERRORLEVEL=3}
            undo, retry.
         end. /* IF wlc_trc_parent */
      end. /* ELSE DO */

   end. /* IF is_wiplottrace_enabled() */

   if receive
   then do:
      if wo_type = "F"
      and fas_wo_rec = false
      then do:
         /* WORK ORDER RECEIPT NOT ALLOWED FOR FINAL ASSY ORDER */
         {pxmsg.i &MSGNUM=3804 &ERRORLEVEL=3}
         undo, retry.
      end. /* IF wo_type = "F" */
   end. /* IF receive */

   assign
      prev_status     = wo_status
      prev_release    = wo_rel_date
      prev_due        = wo_due_date
      prev_qty        = wo_qty_ord
      prev_site       = wo_site
      wopart_wip_acct = wo_acct
      wopart_wip_sub  = wo_sub
      wopart_wip_cc   = wo_cc.

   desc1 = "".
   for first pt_mstr
      fields( pt_domain pt_loc pt_desc1 pt_part pt_prod_line)
       where pt_mstr.pt_domain = global_domain and  pt_part = wo_part
      no-lock:
   end. /* FOR FIRST pt_mstr */

   if available pt_mstr
   then do:
      desc1 = pt_desc1.
      for first pl_mstr
         fields( pl_domain pl_prod_line)
          where pl_mstr.pl_domain = global_domain and  pl_prod_line =
          pt_prod_line
         no-lock:
      end. /* FOR FIRST pl_mstr */
      if available(pl_mstr)
      and wopart_wip_acct = ""
      then do:
         {gprun.i ""glactdft.p"" "(input ""WO_WIP_ACCT"",
                                   input pl_prod_line,
                                   input wo_site,
                                   input """",
                                   input """",
                                   input no,
                                   output wopart_wip_acct,
                                   output wopart_wip_sub,
                                   output wopart_wip_cc)"}
/*GUI*/ if global-beam-me-up then undo, leave.

      end. /* IF AVAILABLE pl_mstr */
   end. /* IF AVAILABLE pt_mstr */

   display
      wo_nbr
      wo_part
      wo_lot
      wo_status
      desc1
   with frame a.

   if eff_date = ?
   then
      eff_date = today.

   wo_recno = recid(wo_mstr).

   /* CHECK FOR JOINT PRODUCT FLAGS */
   if wo_joint_type <> ""
   then do:
      /* STORE THE RECID OF THE ENTERED WORK ORDER, AS THE */
      /* VALUE OF wo_recno IS LOST AT THE TIME OF ISSUE.   */
      assign
         l_entered_wo_recid = wo_recno
         jp                 = yes.
      if wo_joint_type = "5"
      then
         assign
            base_id = wo_lot
            base    = yes.
      else
         assign
            base        = no
            parent_item = wo_part
            base_id     = wo_base_id
            parent_qty  = wo_qty_ord.
   end. /* IF wo_joint_type <> "" */

   if jp
   then
      assign
         regular = no
         jp-yn   = yes
         recv    = yes.

   do transaction:
      for each sr_wkfl
         exclusive-lock
         where sr_wkfl.sr_domain = global_domain
         and   sr_userid         = mfguser:
         delete sr_wkfl.
      end. /* FOR EACH sr_wkfl */

      find wo_mstr
         where recid(wo_mstr) = wo_recno
      exclusive-lock no-error.

      if available wo_mstr
      then
         assign
            wo_qty_chg  = 0
            wo_rjct_chg = 0.

   end. /* DO TRANSACTION */

   if jp
   and receive
   then do:
      assign
         regular   = no
         jp-yn     = yes
         firstpass = yes
         recv_all  = yes
         recv      = no.

      pause 0.

      if base
      then
         display
         recv_all
         with frame r.

      update
         recv_all when (not base)
         with frame r.

      if recv_all
      then
         update
             recv with frame r.

      if recv_all
      or base
      then do:
         hide frame a no-pause.
         hide frame r no-pause.
         {gprun.i ""wojprc.p"" "(input wo_nbr)"}
/*GUI*/ if global-beam-me-up then undo, leave.

         if undo_jp
         then
            undo, retry.
         if undo_setd
         then
            next mainloop.
      end. /* IF recv_all */
   end. /* IF jp */

   release wo_mstr.

   if (regular
   and receive)
   or (not recv_all
   and receive)
   then do:
      view frame a.
      {gprun.i ""woisrc02.p"" "(output trans_ok)"}
/*GUI*/ if global-beam-me-up then undo, leave.

      if not trans_ok
      then
         undo, retry.
      /*V8+*/
   end. /* IF (regular */

   /* DISPLAY THE BASE ITEM IN FRAME A ***/
   if jp
   and issue
   then do:

      for first wo_mstr
         fields( wo_domain wo_acct wo_base_id wo_cc wo_due_date wo_fsm_type
         wo_joint_type
                wo_lot wo_nbr wo_part wo_qty_chg wo_qty_ord wo_rel_date
                wo_rjct_chg wo_routing wo_site wo_status wo_stat_close_date
                wo_stat_close_userid wo_sub wo_type)
          where wo_mstr.wo_domain = global_domain and  wo_lot = base_id
         no-lock:
      end. /* FOR FIRST wo_mstr */

      if available wo_mstr
      then do:

         wo_recno = recid(wo_mstr).

         for first pt_mstr
            fields( pt_domain pt_loc pt_desc1 pt_part pt_prod_line)
             where pt_mstr.pt_domain = global_domain and  pt_part = wo_part
            no-lock:
            desc1 = pt_desc1.
         end. /* FOR FIRST pt_mstr */

         assign
            base_item = wo_part
            base_qty  = wo_qty_ord.

         for first bom_mstr
            fields( bom_domain bom_parent bom_mthd)
             where bom_mstr.bom_domain = global_domain and  bom_parent =
             base_item
            no-lock:
         end. /* FOR FIRST bom_mstr */

         display
            wo_nbr
            wo_lot
            wo_part
            wo_status
            desc1
         with frame a.

         if bom_mthd = "2"
         then
            back_qty = base_qty.
      end. /* IF AVAILABLE wo_mstr */

   end. /* IF jp */

   if issue
   then do:
      if jp
      and undo_jp
      then
         undo, retry.
            outta_here = no.   

      /* ADDED INPUT PARAMETER FOR ENABLING UI */
      {gprun.i ""woisrc01.p"" "(input Yes)"}
/*GUI*/ if global-beam-me-up then undo, leave.


      /*V8+*/
            if outta_here then undo, retry.   
   end. /* IF issue */

   do transaction
   on endkey undo mainloop, retry mainloop:
/*GUI*/ if global-beam-me-up then undo, leave.


      yn = yes.

      /* Identify context for QXtend */
      {gpcontxt.i
         &STACKFRAG = 'wowoisrc'
         &FRAME = 'yn' &CONTEXT = 'C'}

      /* "PLEASE CONFIRM UPDATE" */
      {pxmsg.i &MSGNUM=32 &ERRORLEVEL=1 &CONFIRM=yn}

      /* Clear context for QXtend */
      {gpcontxt.i
         &STACKFRAG = 'wowoisrc'
         &FRAME = 'yn'}

      if yn
      then do:

         if issue
         then do:
            /* RECHECK INVENTORY TO VERIFY ALL IS STILL OK    */
            {gprun.i ""woisrc1c.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

            if rejected then undo mainloop, retry mainloop.
            {&WOWOISRC-P-TAG13}
            /* ADDED THIRD INPUT AND FOURTH OUTPUT PARAMETER. THESE TWO   */
            /* PARAMETER WILL BE USED BY FLOW. INPUT PARAMETER IS LOT ID. */
            /* OTHER THAN FLOW IT WILL BE BLANK OUTPUT PARAMETER IS       */
            /* ACCUMLATED TRANSACTION AMOUNT. OTHER THAN FLOW IT WILL BE  */
            /* ALWAYS O     */
            {gprun.i ""wowoisa.p"" "(input no,
                                     input ?,
                                     input  """",
                                     output dummy_gl_amt
                                    )"}
/*GUI*/ if global-beam-me-up then undo, leave.

         end. /* IF issue */

         if not jp
         and receive
         then do:

            /* CREATE TRANSACTION HISTORY RECORD */
            /* ADDED TWO INPUT PARAMETER. THESE TWO PARAMETER WILL BE USED BY */
            /* FLOW FIRST INPUT PARAMETER IS LOT ID. OTHER THAN FLOW IT WILL  */
            /* BE BLANK SECOND INPUT PARAMETER IS ACCUMLATED TRANSACTION      */
            /* AMOUNT. OTHER THAN FLOW IT WILL BE ALWAYS O */
            {gprun.i ""woworca.p"" "(input """",
                                     input 0
                                    )"}
/*GUI*/ if global-beam-me-up then undo, leave.

            {&WOWOISRC-P-TAG3}


            find wo_mstr
               where recid(wo_mstr) = wo_recno
               exclusive-lock no-error.

            if close_wo
            then do:
               wo_status = "C".
               /* UPDATE STATUS CLOSE DATE AND USERID ON DISCRETE WORK ORDERS */
               {wostatcl.i}
            end. /* IF close_wo */

            {gprun.i ""wowomta.p""}
/*GUI*/ if global-beam-me-up then undo, leave.


         end. /* IF NOT jp*/

         /* JOINT PRODUCT INVENTORY, GL, AND WO_MSTR UPDATES */
         if jp
         and not undo_jp
         and receive
         then do:
            /* ADDED INPUT PARAMETERS l_entered_wo_recid AND */
            /* recv_all, TO INDICATE IF SINGLE CO /          */
            /* BY-PRODUCT RECEIPT                            */
            {gprun.i ""wojprcb.p""
                     "(input l_entered_wo_recid,
                       input recv_all)"
            }
/*GUI*/ if global-beam-me-up then undo, leave.

         end. /* IF jp */

      end. /* IF yn */

   end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* DO TRANSACTION */

   if available wo_mstr
   then
      display
         wo_nbr
         wo_lot
         wo_part
         wo_status
      with frame a.

end. /* REPEAT */
