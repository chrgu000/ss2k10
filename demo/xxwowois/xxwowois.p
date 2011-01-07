/* wowois.p - WORK ORDER ISSUE WITH SERIAL NUMBERS                            */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.32 $                                                           */
/* REVISION: 1.0     LAST MODIFIED: 07/28/86    BY: pml                       */
/* REVISION: 1.0     LAST MODIFIED: 06/30/86    BY: emb                       */
/* REVISION: 1.0     LAST MODIFIED: 10/30/86    BY: emb *39*                  */
/* REVISION: 1.0     LAST MODIFIED: 03/03/87    BY: emb *A25*                 */
/* REVISION: 1.0     LAST MODIFIED: 02/13/87    BY: pml *A26*                 */
/* REVISION: 2.0     LAST MODIFIED: 03/20/87    BY: emb *A45*                 */
/* REVISION: 2.1     LAST MODIFIED: 06/15/87    BY: wug *A66*                 */
/* REVISION: 2.1     LAST MODIFIED: 11/20/87    BY: emb *A75*                 */
/* REVISION: 2.1     LAST MODIFIED: 07/23/87    BY: wug *A77*                 */
/* REVISION: 2.1     LAST MODIFIED: 08/31/87    BY: wug *A94*                 */
/* REVISION: 2.1     LAST MODIFIED: 09/11/87    BY: wug *A94*                 */
/* REVISION: 2.1     LAST MODIFIED: 11/04/87    BY: wug *A102*                */
/* REVISION: 2.1     LAST MODIFIED: 01/18/88    BY: wug *A151*                */
/* REVISION: 4.0     LAST MODIFIED: 02/01/88    BY: emb *A170*                */
/* REVISION: 4.0     LAST MODIFIED: 02/29/88    BY: flm *A179*                */
/* REVISION: 4.0     LAST MODIFIED: 03/14/88    BY: rl  *A171*                */
/* REVISION: 4.0     LAST MODIFIED: 03/28/88    BY: wug *A187*                */
/* REVISION: 4.0     LAST MODIFIED: 07/25/88    BY: wug *A360*                */
/* REVISION: 4.0     LAST MODIFIED: 08/31/88    BY: flm *A417*                */
/* REVISION: 4.0     LAST MODIFIED: 02/09/89    BY: emb *A643*                */
/* REVISION: 5.0     LAST MODIFIED: 06/22/89    BY: rl  *B157*                */
/* REVISION: 5.0     LAST MODIFIED: 06/23/89    BY: mlb *B159*                */
/* REVISION: 5.0     LAST MODIFIED: 07/06/89    BY: wug *B175*                */
/* REVISION: 5.0     LAST MODIFIED: 07/07/89    BY: wug *B176*                */
/* REVISION: 5.0     LAST MODIFIED: 01/22/90    BY: wug *B515*                */
/* REVISION: 5.0     LAST MODIFIED: 02/26/90    BY: emb *B589*                */
/* REVISION: 5.0     LAST MODIFIED: 04/13/90    BY: emb *B664*                */
/* REVISION: 5.0     LAST MODIFIED: 07/19/90    BY: emb *B734*                */
/* REVISION: 6.0     LAST MODIFIED: 03/14/90    BY: emb *D002*                */
/* REVISION: 6.0     LAST MODIFIED: 04/20/90    BY: wug *D002*                */
/* REVISION: 6.0     LAST MODIFIED: 05/07/90    BY: mlb *D024*                */
/* REVISION: 6.0     LAST MODIFIED: 06/26/90    BY: emb *D024*                */
/* REVISION: 6.0     LAST MODIFIED: 05/11/90    BY: emb *D025*                */
/* REVISION: 6.0     LAST MODIFIED: 12/11/90    BY: emb *D242*                */
/* REVISION: 6.0     LAST MODIFIED: 12/17/90    BY: wug *D619*                */
/* REVISION: 6.0     LAST MODIFIED: 09/12/91    BY: wug *D858*                */
/* REVISION: 6.0     LAST MODIFIED: 10/02/91    BY: emb *D886*                */
/* REVISION: 6.0     LAST MODIFIED: 10/07/91    BY: alb *D887*                */
/* REVISION: 7.0     LAST MODIFIED: 10/16/91    BY: pma *F003*                */
/* REVISION: 6.0     LAST MODIFIED: 11/08/91    BY: wug *D920*                */
/* REVISION: 6.0     LAST MODIFIED: 11/29/91    BY: ram *D954*                */
/* REVISION: 7.0     LAST MODIFIED: 02/12/92    BY: pma *F190*                */
/* REVISION: 7.3     LAST MODIFIED: 09/30/92    BY: ram *G115*                */
/* REVISION: 7.3     LAST MODIFIED: 10/21/92    BY: emb *G216*                */
/* REVISION: 7.3     LAST MODIFIED: 10/22/92    BY: emb *G223*                */
/* REVISION: 7.3     LAST MODIFIED: 09/27/93    BY: jcd *G247*                */
/* REVISION: 7.3     LAST MODIFIED: 01/08/93    BY: emb *G527*                */
/* REVISION: 7.3     LAST MODIFIED: 02/08/93    BY: emb *G656*                */
/* REVISION: 7.3     LAST MODIFIED: 03/04/93    BY: ram *G782*                */
/* REVISION: 7.3     LAST MODIFIED: 03/25/93    BY: emb *G872*                */
/* REVISION: 7.3     LAST MODIFIED: 04/21/93    BY: pma *GA01*(rev only)      */
/* REVISION: 7.3     LAST MODIFIED: 09/01/93    BY: emb *GE69*                */
/* REVISION: 7.4     LAST MODIFIED: 07/22/93    BY: pcd *H039*                */
/* REVISION: 7.4     LAST MODIFIED: 11/10/93    BY: ais *H216*                */
/* REVISION: 7.4     LAST MODIFIED: 12/21/93    BY: pxd *GI21*                */
/* REVISION: 7.4     LAST MODIFIED: 04/11/94    BY: ais *GJ31*                */
/* REVISION: 7.4     LAST MODIFIED: 05/18/94    BY: ais *FO22*                */
/* REVISION: 7.4     LAST MODIFIED: 07/26/94    BY: emb *FP55*                */
/* REVISION: 7.4     LAST MODIFIED: 08/12/94    BY: pxd *GL28*                */
/* REVISION: 7.4     LAST MODIFIED: 08/12/94    BY: pxd *FQ74*                */
/* REVISION: 7.4     LAST MODIFIED: 09/12/94    by: slm *GM61*                */
/* REVISION: 7.4     LAST MODIFIED: 09/19/94    by: pxd *FR60*                */
/* REVISION: 7.4     LAST MODIFIED: 09/22/94    by: jpm *GM78*                */
/* REVISION: 7.4     LAST MODIFIED: 09/27/94    by: emb *GM78*                */
/* REVISION: 7.4     LAST MODIFIED: 09/30/94    by: pxd *FR98*                */
/* REVISION: 8.5     LAST MODIFIED: 10/02/94    by: dzs *J046*                */
/* REVISION: 7.4     LAST MODIFIED: 10/06/94    by: pxd *FS17*                */
/* REVISION: 7.3     LAST MODIFIED: 10/31/94    by: WUG *GN76*                */
/* REVISION: 7.4     LAST MODIFIED: 11/11/94    by: rwl *GO34*                */
/* REVISION: 8.5     LAST MODIFIED: 11/21/94    by: tmf *J040*                */
/* REVISION: 8.5     LAST MODIFIED: 12/08/94    by: mwd *J034*                */
/* REVISION: 8.5     LAST MODIFIED: 12/09/94    by: taf *J038*                */
/* REVISION: 8.5     LAST MODIFIED: 12/27/94    by: ktn *J041*                */
/* REVISION: 7.4     LAST MODIFIED: 01/30/95    by: pxe *F0FQ*                */
/* REVISION: 8.5     LAST MODIFIED: 03/24/95    by: tjs *J046*                */
/* REVISION: 8.5     LAST MODIFIED: 04/18/95    by: sxb *J04D*                */
/* REVISION: 8.5     LAST MODIFIED: 07/24/95    by: tjs *J060*                */
/* REVISION: 8.5     LAST MODIFIED: 09/14/95    by: kxn *J07X*                */
/* REVISION: 7.4     LAST MODIFIED: 09/28/95    by: str *F0VL*                */
/* REVISION: 7.3     LAST MODIFIED: 11/01/95    by: ais *G0V9*                */
/* REVISION: 7.3     LAST MODIFIED: 08/24/95    by: dzs *G0SY*                */
/* REVISION: 7.2     LAST MODIFIED: 08/17/95    BY: qzl *F0TC*                */
/* REVISION: 8.5     LAST MODIFIED: 04/11/96    BY: *J04C* Sue Poland         */
/* REVISION: 8.5     LAST MODIFIED: 04/11/96    BY: *J04C* Markus Barone      */
/* REVISION: 8.5     LAST MODIFIED: 05/01/96    BY: *G1MN*  Julie Milligan    */
/* REVISION: 8.6     LAST MODIFIED: 06/11/96    BY: bjl *K001*                */
/* REVISION: 8.5     LAST MODIFIED: 07/31/96    BY: *J137* Sue Poland         */
/* REVISION: 8.6     LAST MODIFIED: 03/14/97    BY: *G2JJ* Murli Shastri      */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 06/04/99   BY: *J3DH* Satish Chavan      */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Vijaya Pakala      */
/* REVISION: 9.1      LAST MODIFIED: 10/25/99   BY: *N002* Steve Nugent       */
/* REVISION: 9.1      LAST MODIFIED: 03/06/00   BY: *N05Q* Vincent Koh        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 07/17/00   BY: *M0PQ* Falguni Dalal      */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KC* myb                */
/* REVISION: 9.1      LAST MODIFIED: 08/16/00   BY: *N0LH* Arul Victoria      */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Old ECO marker removed, but no ECO header exists *FI90*                    */
/* Revision: 1.18        BY: Niranjan R.        DATE: 07/13/01  ECO: *P00L*   */
/* Revision: 1.19        BY: Jean Miller        DATE: 05/16/02  ECO: *P05V*   */
/* Revision: 1.20        BY: Inna Fox           DATE: 06/13/02  ECO: *P04Z*   */
/* Revision: 1.21        BY: Niranjan R.        DATE: 06/14/02  ECO: *P08N*   */
/* Revision: 1.23        BY: Niranjan R.        DATE: 06/25/02  ECO: *P09L*   */
/* Revision: 1.24        BY: Vivek Gogte        DATE: 08/06/02  ECO: *N1QQ*   */
/* Revision: 1.25        BY: Dorota Hohol       DATE: 02/25/03  ECO: *P0N6*   */
/* Revision: 1.26        BY: Narathip W.        DATE: 04/29/03 ECO: *P0QN*    */
/* Revision: 1.30        BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00N*    */
/* Revision: 1.31        BY: Ken Casey          DATE: 02/19/04 ECO: *N2GM*    */
/* $Revision: 1.32 $      BY: Sukhad Kulkarni    DATE: 02/08/05 ECO: *P37G*   */
/* Revision: 110106.1       BY: ZhangYun          DATE: 01/06/11              */
/*-Revision: 110106.1----------------------------------------------------------
  Purpose: 增加物料/BOM权限控制
  Notes:code_mstr里维护资料
        code_fldname = pt_part_type(物料权限)/pt_status(BOM权限)
        code_value = userid(特定用户)/""(所有用户)
------------------------------------------------------------------------------*/
/*-Revision end---------------------------------------------------------------*/


/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*V8:ConvertMode=Maintenance                                                  */

/*DISPLAY TITLE          */
{mfdtitle.i "110106.1"}
{cxcustom.i "WOWOIS.P"}
/*110106.1*/ {xxpartbomfunc.i}
{gldydef.i new}
{gldynrm.i new}

define new shared variable part like wod_part.
define new shared variable eff_date like glt_effdate.
define new shared variable wopart_wip_acct like pl_wip_acct.
define new shared variable wopart_wip_sub like pl_wip_sub.
define new shared variable wopart_wip_cc like pl_wip_cc.
define new shared variable wo_recno as recid.
define new shared variable site like sr_site no-undo.
define new shared variable location like sr_loc no-undo.
define new shared variable lotserial like sr_lotser no-undo.
define new shared variable lotref like sr_ref format "x(8)" no-undo.
define new shared variable lotserial_qty like sr_qty no-undo.
define new shared variable multi_entry like mfc_logical
   label "Multi Entry" no-undo.
define new shared variable lotserial_control as character.
define new shared variable cline as character.
define new shared variable row_nbr as integer.
define new shared variable col_nbr as integer.
define new shared variable total_lotserial_qty like wod_qty_chg.
define new shared variable trans_um like pt_um.
define new shared variable trans_conv like sod_um_conv.
define new shared variable transtype as character initial "ISS-WO".
define new shared variable wo_recid as recid.
define new shared variable lotnext like wo_lot_next .
define new shared variable lotprcpt like wo_lot_rcpt no-undo.
define new shared variable issue_or_receipt as character.
define new shared variable h_wiplottrace_procs as handle no-undo.
define new shared variable h_wiplottrace_funcs as handle no-undo.
define new shared variable wod_recno as recid.
{&WOWOIS-P-TAG3}

define variable fill_all  like mfc_logical
   label "Issue Alloc" initial no.
define variable fill_pick like mfc_logical
   label "Issue Picked" initial yes.
{&WOWOIS-P-TAG1}
define variable nbr         like wo_nbr.
define variable yn          like mfc_logical.
define variable desc1       like pt_desc1.
define variable del-yn      like mfc_logical initial no.
define variable tot_lad_all like lad_qty_all.
define variable ladqtychg   like lad_qty_all.
define variable sub_comp    like mfc_logical label "Substitute".
define variable firstpass   like mfc_logical.
define variable undo-input  like mfc_logical.
define variable wo-op       like wod_op label "Op".
define variable msg-counter as integer no-undo.
define variable base        like mfc_logical initial no.
define variable base_id     like wo_base_id.
define variable parent_lot  like wo_lot.
define variable jp          like mfc_logical initial no.
define variable wolot       like wo_lot.
define variable issue_component like mfc_logical.
define variable ophist_recid  as recid no-undo.
define variable consider_output_qty like mfc_logical no-undo.
define variable move_to_wkctr like wc_wkctr no-undo.
define variable move_to_mch   like wc_mch no-undo.
define variable undo_stat     like mfc_logical no-undo.
define variable dummy_gl_amt  like tr_gl_amt no-undo.

{wlfnc.i} /*FUNCTION FORWARD DECLARATIONS*/
{wlcon.i} /*CONSTANTS DEFINITIONS*/

issue_or_receipt = getTermLabel("ISSUE",8).

{gpglefv.i}

if is_wiplottrace_enabled() then do:
   {gprunmo.i &program=""wlpl.p"" &module="AWT"
      &persistent="""persistent set h_wiplottrace_procs"""}
   {gprunmo.i &program=""wlfl.p"" &module="AWT"
      &persistent="""persistent set h_wiplottrace_funcs"""}
end.

{&WOWOIS-P-TAG4}
/* INPUT OPTION FORM */
form
   wo_nbr      colon 12
   wo_lot      colon 36
   wo-op       colon 50
   eff_date    colon 68
   wo_part     colon 12 wo_status   fill_all    colon 68
   desc1       at 14 no-label       fill_pick   colon 68
with frame a side-labels width 80 attr-space.
{&WOWOIS-P-TAG5}

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

find first clc_ctrl  where clc_ctrl.clc_domain = global_domain no-lock no-error.
if not available clc_ctrl then do:
   {gprun.i ""gpclccrt.p""}
   find first clc_ctrl  where clc_ctrl.clc_domain = global_domain no-lock
   no-error.
end.
eff_date = today.

/* DISPLAY */
mainloop:
repeat:

   {&WOWOIS-P-TAG6}
   part = "".
   nbr = "".

   {&WOWOIS-P-TAG7}
   display eff_date fill_all fill_pick with frame a.
   {&WOWOIS-P-TAG8}

   prompt-for
      wo_nbr wo_lot
      wo-op
      eff_date fill_all fill_pick
      {&WOWOIS-P-TAG9}
   with frame a
   editing:

      if frame-field = "wo_nbr" then do:

         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp.i wo_mstr wo_nbr  " wo_mstr.wo_domain = global_domain and wo_nbr
         "  wo_nbr wo_nbr wo_nbr}

         if recno <> ? then do:
            nbr = wo_nbr.
            desc1 = "".
            find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part
            = wo_part
               no-lock no-error.
            if available pt_mstr then desc1 = pt_desc1.
            display wo_nbr wo_lot wo_part wo_status desc1
            with frame a.
         end.
         else do:
            nbr = input wo_nbr.
         end.

      end.

      else if frame-field = "wo_lot" then do:

         /* FIND NEXT/PREVIOUS RECORD */
         if input wo_nbr =  "" then do:
            {mfnp01.i wo_mstr wo_lot wo_lot wo_nbr  " wo_mstr.wo_domain =
            global_domain and wo_nbr "  wo_lot}
         end.
         else do:
            nbr = input wo_nbr.
            {mfnp01.i wo_mstr wo_lot wo_lot nbr  " wo_mstr.wo_domain =
            global_domain and wo_nbr "  wo_nbr}
         end.

         if recno <> ? then do:
            desc1 = "".
            wolot = wo_lot.
            find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part
            = wo_part
               no-lock no-error.
            if available pt_mstr then desc1 = pt_desc1.
            display wo_nbr wo_lot wo_part wo_status desc1
            with frame a.
         end.

      end.

      else do:
         status input.
         readkey.
         apply lastkey.
      end.

   end.

   assign
      wo-op
      {&WOWOIS-P-TAG10}
      eff_date fill_all fill_pick.
      {&WOWOIS-P-TAG11}

   if eff_date = ? then eff_date = today.

   /* CHECK EFFECTIVE DATE */
   nbr = input wo_nbr.
   if input wo_nbr <> "" then
if not can-find(first wo_mstr using  wo_nbr where wo_mstr.wo_domain =
global_domain ) then do:

      {pxmsg.i &MSGNUM=503 &ERRORLEVEL=3}
      undo, retry.
   end.

   if nbr = "" and input wo_lot = "" then undo, retry.

   if nbr <> "" and input wo_lot <> "" then
      find wo_mstr  where wo_mstr.wo_domain = global_domain and  wo_nbr = nbr
      using wo_lot no-lock no-error.

   if nbr = "" and input wo_lot <> "" then
find wo_mstr no-lock using  wo_lot where wo_mstr.wo_domain = global_domain
no-error.

   if nbr <> "" and input wo_lot = "" then
      find first wo_mstr  where wo_mstr.wo_domain = global_domain and  wo_nbr =
      nbr no-lock no-error.

   if not available wo_mstr then do:
      {pxmsg.i &MSGNUM=510 &ERRORLEVEL=3}
      /*  WORK ORDER DOES NOT EXIST.*/
      undo, retry.
   end.
   else do:
/*110106.1*/    if not(canAccessPart(wo_part)) then do:
/*110106.1*/        {pxmsg.i &msgnum = 90010}
/*110106.1*/        undo, retry.
/*110106.1*/    end.
   end.
   /*VALIDATE THE GL EFFECTIVE DATE */
   find si_mstr  where si_mstr.si_domain = global_domain and  si_site = wo_site
   no-lock.
   {gpglef1.i &module = ""WO""
      &entity = si_entity
      &date = eff_date
      &prompt = "eff_date"
      &frame = "a"
      &loop = "mainloop"}

   if input wo_lot <> "" then do:
      wolot = input wo_lot.
   end.
   else do:
      wolot = wo_lot.
   end.

   /* DON'T ALLOW PROJECT ACTIVITY RECORDING WORK ORDERS */
   if wo_fsm_type = "PRM" then do:
      {pxmsg.i &MSGNUM=3426 &ERRORLEVEL=3}    /* CONTROLLED BY PRM MODULE */
      undo, retry.
   end.

   if lookup(wo_status,"A,R") = 0 then do:
      /* ISSUES ONLY ALLOWED AGAINST ALLOCATED AND RELEASED ORDERS */
      {pxmsg.i &MSGNUM=541 &ERRORLEVEL=3}
      /* Current Work Order Status */
      {pxmsg.i &MSGNUM=525 &ERRORLEVEL=1 &MSGARG1=wo_status}
      undo, retry.
   end.

   /* DON'T ALLOW CALL ACTIVITY RECORDING WORK ORDERS */
   if wo_fsm_type = "FSM-RO" then do:
      {pxmsg.i &MSGNUM=7492 &ERRORLEVEL=3}    /* FIELD SERVICE CONTROLLED */
      undo, retry.
   end.

   if wo_type = "c" and wo_nbr = "" then do:
      {pxmsg.i &MSGNUM=5123 &ERRORLEVEL=3}
      undo, retry.
   end.

   /* Word Order type is flow */
   if wo_type = "w" then do:
      {pxmsg.i &MSGNUM=5285 &ERRORLEVEL=3}
      undo, retry.
   end.

   {gprun.i ""gpsiver.p""
      "(input wo_site, input ?, output return_int)"}
   if return_int = 0 then do:
      /* USER DOES NOT HAVE ACCESS TO SITE XXXX */
      {pxmsg.i &MSGNUM=2710 &ERRORLEVEL=1 &MSGARG1=wo_site}
      undo mainloop, retry.
   end.

   /* BASE PROCESS WORK ORDER PROCESSING FOR JOINT PRODUCTS  */
   if wo_joint_type <> "" then do:

      jp = yes. /* This is Joint Product/Base Work Order */

      if wo_joint_type = "5" then base = yes.
      else do:
         base = no.
         base_id = wo_base_id.
         parent_lot = wo_base_id.
         find wo_mstr  where wo_mstr.wo_domain = global_domain and  wo_lot =
         base_id no-lock no-error.
         if not available wo_mstr then do:
            /* Base Process Work Order not available */
            {pxmsg.i &MSGNUM=6530 &ERRORLEVEL=1}.
            undo, retry.
         end.
      end.

   end.

   if is_wiplottrace_enabled() and
      is_woparent_wiplot_traced(wo_lot)
   then do:
      if not can-find(wr_route  where wr_route.wr_domain = global_domain and
      wr_lot = wo_lot
         and wr_op = wo-op)
      then do:
         {pxmsg.i &MSGNUM=511 &ERRORLEVEL=1}
         /*WORK ORDER OPERATION DOES NOT EXIST*/
         {pxmsg.i &MSGNUM=8471 &ERRORLEVEL=1}
         /*WIP LOT TRACE IS IN EFFECT FOR THIS ORDER*/
         next-prompt wo-op with frame a.
         undo, retry.
      end.
   end.

   desc1 = "".
   find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part = wo_part
   no-lock no-error.
   if available pt_mstr then do:
      desc1 = pt_desc1.
   end.

   if not base and jp then do:
      find wo_mstr  where wo_mstr.wo_domain = global_domain and  wo_lot =
      parent_lot no-lock no-error.
      find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part =
      wo_part no-lock no-error.
      if available pt_mstr then desc1 = pt_desc1.
   end.

   display
      wo_nbr
      wo_part
      wo_lot
      wo_status
      desc1
   with frame a.

   if eff_date = ? then eff_date = today.

   assign
      wopart_wip_acct = wo_acct
      wopart_wip_sub = wo_sub
      wopart_wip_cc = wo_cc.

   wo_recno = recid(wo_mstr).

   find pl_mstr  where pl_mstr.pl_domain = global_domain and  pl_prod_line =
   pt_prod_line no-lock no-error.

   if available(pl_mstr) and wopart_wip_acct = "" then do:
      {gprun.i ""glactdft.p"" "(input ""WO_WIP_ACCT"",
                                input pl_prod_line,
                                input wo_site,
                                input """",
                                input """",
                                input no,
                                output wopart_wip_acct,
                                output wopart_wip_sub,
                                output wopart_wip_cc)"}
   end. /* FIND PL_MSTR WHERE PL_PROD_LINE */

   find first wo_mstr
      where wo_domain      = global_domain
      and   recid(wo_mstr) = wo_recno
   exclusive-lock no-error.
   if available wo_mstr
   then
      recno = recid(wo_mstr).

   {gprun.i ""wowoisb.p""
      "(wo_recno, wo-op, fill_all, fill_pick, output undo-input)"}

   if undo-input then next mainloop.

   {gprun.i ""xxwowoisc.p""
      "(input wo-op, output undo-input)"}
   if undo-input then next mainloop.

   if is_wiplottrace_enabled() and
      is_woparent_wiplot_traced(input wolot)
   then do:

      /* Identify context for QXtend */
      {gpcontxt.i
         &STACKFRAG = 'wlpl,wluigpwl,wlpl,wowois,wowois'
         &FRAME = 'yn' &CONTEXT = 'INFO2'}

      run get_wip_lot_trace_data
         (input wo-op, input wo_lot, input wo_site, output undo_stat).

      /* Clear context for QXtend */
      {gpcontxt.i
         &STACKFRAG = 'wlpl,wluigpwl,wlpl,wowois,wowois'
         &FRAME = 'yn'}

      if undo_stat then next mainloop.

      /* Identify context for QXtend */
      {gpcontxt.i
         &STACKFRAG = 'wlpl,wowois'
         &FRAME = 'yn' &CONTEXT = 'INFO3'}

      run get_is_all_info_correct in h_wiplottrace_procs (output yn).

      /* Clear context for QXtend */
      {gpcontxt.i
         &STACKFRAG = 'wlpl,wowois'
         &FRAME = 'yn'}

      if yn = no then next mainloop.
   end. /* if is_wiplottrace_enabled() */

   run wip_lot_trace_processing
      (input wo-op, input wo_lot, input wo_site, output ophist_recid).

   /* ADDED THIRD INPUT AND FOURTH OUTPUT PARAMETER. THESE TWO PARAMETER */
   /* WILL BE USED BY FLOW. INPUT PARAMETER IS LOT ID. OTHER THAN */
   /* FLOW IT WILL BE BLANK OUTPUT PARAMETER IS ACCUMLATED        */
   /* TRANSACTION AMOUNT. OTHER THAN FLOW IT WILL BE ALWAYS O     */
   {gprun.i ""wowoisa.p"" "(input no,
                            input ophist_recid,
                            input  """",
                            output dummy_gl_amt
                           )"}
   {&WOWOIS-P-TAG2}

end.

if is_wiplottrace_enabled() then
   delete PROCEDURE h_wiplottrace_procs no-error.
if is_wiplottrace_enabled() then
   delete PROCEDURE h_wiplottrace_funcs no-error.

PROCEDURE get_wip_lot_trace_data:
   define input parameter op_nbr like wod_op no-undo.
   define input parameter id_nbr like wo_lot no-undo.
   define input parameter v_site like wo_site no-undo.
   define output parameter o_undo_stat like mfc_logical no-undo.

   define variable undo_stat like mfc_logical no-undo.
   define variable result_status as character no-undo.

   o_undo_stat = true.

   if is_operation_queue_lot_controlled(id_nbr, op_nbr, INPUT_QUEUE)
   then do:

      run init_bkfl_input_wip_lot_temptable in h_wiplottrace_procs.

      run get_current_wkctr_mch_from_user in h_wiplottrace_procs
         (input id_nbr,
          input op_nbr,
          output move_to_wkctr,
          output move_to_mch,
          output undo_stat).

      if undo_stat then undo, leave.

      run get_iss_input_wip_lots_from_user in h_wiplottrace_procs
         (input id_nbr, input op_nbr, input v_site,
          input move_to_wkctr, input move_to_mch,
          output undo_stat).

      if undo_stat then undo, retry.

   end. /* if is_operation_queue_lot_controlled */

   if is_operation_queue_lot_controlled(id_nbr, op_nbr, OUTPUT_QUEUE)
   then do:

      run init_produced_wip_temptable in h_wiplottrace_procs.

      run get_produced_wip_lots_from_user in h_wiplottrace_procs
         (input part,
          input op_nbr,
          input id_nbr,
          output undo_stat).

      if undo_stat then undo, leave.

      /* CHECK FOR COMINGLED LOTS - INPUT WIP AND COMPONENTS
         TO A PARTICULAR OUTPUT WIP LOT*/
      run iss_check_for_combined_lots in h_wiplottrace_procs
         (input id_nbr,
          input op_nbr,
          input trans_conv,
          output result_status).

      if result_status = FAILED_EDIT then do:
         undo, leave.
      end.

      /* CHECK FOR SPLIT LOTS - OUTPUT WIP AND COMPONENTS
         TO A PARTICULAR INPUT WIP LOT*/

      consider_output_qty = no.

      run iss_check_for_split_lots in h_wiplottrace_procs
         (input id_nbr,
          input op_nbr,
          input trans_conv,
          input consider_output_qty,
          output result_status).

      if result_status = FAILED_EDIT then do:
         undo, leave.
      end.

   end. /* if is_operation_queue_lot_controlled */

   o_undo_stat = false.

END PROCEDURE.

PROCEDURE wip_lot_trace_processing:
   /* CREATE AN OP_HIST RECORD WITH A TYPE OF */
   /* ISSUE. THIS WILL BE USED SOLELY TO FOR */
   /* RECORDING TRACING RECORDS FOR WIP LOT TRACE */
   define input parameter op_nbr like wod_op no-undo.
   define input parameter id_nbr like wo_lot no-undo.
   define input parameter v_site like wo_site no-undo.
   define output parameter ophist_recid as recid no-undo.

   define variable trans_type as character initial "ISSUE" no-undo.

   if is_wiplottrace_enabled()
      and is_operation_queue_lot_controlled
      (id_nbr, op_nbr, OUTPUT_QUEUE)
   then do:

      {gprun.i ""reophist.p""
         "(input trans_type,
           input id_nbr, input op_nbr, input '',
           input move_to_wkctr, input move_to_mch,
           input '', input '', input eff_date,
           output ophist_recid)"}

      for first op_hist where recid(op_hist) = ophist_recid
      no-lock: end.

      do transaction:
         run iss_backflush_wip_lots in h_wiplottrace_procs
            (input op_trnbr,
             input id_nbr,
             input op_nbr,
             input trans_conv,
             input v_site,
             input move_to_wkctr,
             input move_to_mch).
      end. /* do transaction */

   end.

END PROCEDURE.
