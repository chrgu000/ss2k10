/* rercvlst.p - REPETITIVE   SUBPROGRAM TO MODIFY FINISHED PART RECEIVE LIST  */
/* Copyright 1986-2009 QAD Inc., Santa Barbara, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* REVISION: 7.X      LAST MODIFIED: 10/31/94   BY: WUG *GN77*                */
/* REVISION: 8.5      LAST MODIFIED: 05/12/95   BY: pma *J04T*                */
/* REVISION: 7.2      LAST MODIFIED: 08/17/95   BY: qzl *F0TC*                */
/* REVISION: 8.5      LAST MODIFIED: 09/05/95   BY: kxn *J07P*                */
/* REVISION: 8.5      LAST MODIFIED: 09/11/95   BY: tjs *J060*                */
/* REVISION: 8.5      LAST MODIFIED: 10/30/95   BY: kxn *J095*                */
/* REVISION: 8.5      LAST MODIFIED: 03/11/96   BY: jpm *J0F5*                */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.5      LAST MODIFIED: 04/15/98   BY: *J2K7* Fred Yeadon        */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 03/25/99   BY: *J39K* Sanjeev Assudani   */
/* REVISION: 9.1      LAST MODIFIED: 09/04/99   BY: *J3KM* G.Latha            */
/* REVISION: 9.1      LAST MODIFIED: 10/25/99   BY: *N002* Bill Gates         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 07/25/00   BY: *N0GD* Peggy Ng           */
/* REVISION: 9.1      LAST MODIFIED: 08/28/00   BY: *N0PH* Dave Caveney       */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.8.2.8    BY: Kirti Desai  DATE: 11/01/01  ECO: *N151*          */
/* Revision: 1.8.2.9    BY: Kirti Desai  DATE: 02/08/02  ECO: *M1TV*          */
/* Revision: 1.8.2.11   BY: Ashish Maheshwari   DATE: 07/17/02  ECO: *N1GJ*   */
/* Revision: 1.8.2.14   BY: Narathip W.         DATE: 04/19/03  ECO: *P0Q7*   */
/* Revision: 1.8.2.16   BY: Paul Donnelly (SB)  DATE: 06/28/03  ECO: *Q00K*   */
/* Revision: 1.8.2.17   BY: Jean Miller         DATE: 01/10/06  ECO: *Q0PD*   */
/* Revision: 1.8.2.17.1.1  BY: Ashim Mishra     DATE: 02/15/07  ECO: *P5P1*   */
/* Revision: 1.8.2.17.1.2  BY: Ruma Bibra       DATE: 04/21/08  ECO: *P6R5*   */
/* Revision: 1.8.2.17.1.3 BY: Namita Patil      DATE: 07/16/08  ECO: *P6XP*   */
/* Revision: 1.8.2.17.1.4 BY: Ruma Bibra        DATE: 08/11/08  ECO: *P6YY*   */
/* Revision: 1.8.2.17.1.5 BY: Winnie Ouyang     DATE: 03/02/09  ECO: *Q2HR*   */
/* Revision: 1.8.2.17.1.6 BY: Ruchita Shinde    DATE: 05/05/09  ECO: *Q2SD*  */
/* $Revision: 1.8.2.17.1.7 $ BY: Nafees Khan       DATE: 10/21/09  ECO: *Q3JS*  */
/*-Revision end---------------------------------------------------------------*/
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*V8:ConvertMode=Maintenance                                                  */

/* TAKEN FROM reiscr02.p                                                      */

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{cxcustom.i "RERCVLST.P"}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE rercvlst_p_1 "Total Units"
/* MaxLen: Comment: */

&SCOPED-DEFINE rercvlst_p_3 "Ref"
/* MaxLen: Comment: */

&SCOPED-DEFINE rercvlst_p_4 "Conversion"
/* MaxLen: Comment: */

&SCOPED-DEFINE rercvlst_p_5 "Multi Entry"
/* MaxLen: Comment: */

&SCOPED-DEFINE rercvlst_p_8 "Chg Attributes"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define input parameter cumwo_lot as character.
define input parameter qty_rcv as decimal.
define output parameter undo_stat like mfc_logical no-undo.

define buffer rpsmstr for rps_mstr.
define new shared variable any_issued like mfc_logical.
define new shared variable cline as character.
define new shared variable comp like ps_comp.
define new shared variable conv like um_conv
   label {&rercvlst_p_4} no-undo.
define new shared variable deliv like wod_deliver.
define new shared variable issue_or_receipt as character.
define new shared variable leadtime like pt_mfg_lead.
define new shared variable location like sr_loc no-undo.
define new shared variable lotref like sr_ref format "x(8)" no-undo.
define new shared variable lotserial_control like pt_lot_ser.
define new shared variable lotserial_qty like sr_qty no-undo.
define new shared variable multi_entry like mfc_logical
   label {&rercvlst_p_5} no-undo.
define new shared variable pl_recno as recid.
define new shared variable prev_due like wo_due_date.
define new shared variable prev_qty like wo_qty_ord.
define new shared variable prev_release like wo_rel_date.
define new shared variable prev_status like wo_status.
define new shared variable qty like wo_qty_ord.
define new shared variable site like si_site no-undo.
define new shared variable total_lotserial_qty like sr_qty.
define new shared variable trans_conv like sod_um_conv.
define new shared variable trans_um like pt_um.
define new shared variable transtype as character initial "RCT-WO".
define new shared variable alloc_to_id as   character     no-undo.
define new shared variable alloc_to_op as   integer       no-undo.
define new shared variable prodby_op   as   integer       no-undo.
define new shared variable h_ui_proc   as   handle        no-undo.
define new shared variable queue       like wld_alloc_que no-undo.

define     shared variable lotserial like sr_lotser no-undo.
define     shared variable op          like ro_op         no-undo.
define     shared variable wkctr       like wc_wkctr      no-undo.
define     shared variable mch         like wc_mch        no-undo.

define variable del-yn like mfc_logical.
define variable fas_wo_rec as character.
define variable i as integer.
define variable loc like ld_loc.
define variable lot like ld_lot.
define variable lotqty like wo_qty_chg.
define variable nbr like wo_nbr.
define variable null_ch as character initial "".
define variable qty_left like tr_qty_chg.
define variable ref like glt_ref.
define variable rmks like tr_rmks.
define variable rpsnbr like mrp_nbr.
define variable rpsrecord like rps_record.
define variable serial like tr_serial.
define variable temp_qty like wo_qty_chg.
define variable tot_units like wo_qty_chg label {&rercvlst_p_1}.
define variable totlotqty like wo_qty_chg.
define variable trqty like tr_qty_chg.
define variable um like pt_um no-undo.
define variable yn like mfc_logical.
define variable l_loc   like wo_loc  no-undo.
{&RERCVLST-P-TAG1}

/*DEFINE VARIABLES FOR CHANGE ATTRIBUTES FEATURE*/
{gpatrdef.i "shared"}
define new shared variable chg_attr like mfc_logical
   label {&rercvlst_p_8} no-undo.
define variable trans-ok like mfc_logical.
define new shared variable lotnext like wo_lot_next .
define new shared variable lotprcpt like wo_lot_rcpt no-undo.
define variable newlot like pod_lot_next.
define variable alm_recno as recid.
define variable filename as character.
define variable almr like alm_pgm.
define variable ii as integer.
define shared variable eff_date like glt_effdate .
define shared variable h_wiplottrace_procs as handle no-undo.
define shared variable h_wiplottrace_funcs as handle no-undo.
{wlfnc.i} /* FUNCTION FORWARD DECLARATIONS */
{wlcon.i} /* CONSTANTS DEFINITIONS         */

assign
   issue_or_receipt = getTermLabel("RECEIPT",10)
   undo_stat        = yes.

find wo_mstr
    where wo_mstr.wo_domain = global_domain and  wo_lot = cumwo_lot no-lock.

find first clc_ctrl  where clc_ctrl.clc_domain = global_domain no-lock no-error.
if not available clc_ctrl
then do:
   {gprun.i ""gpclccrt.p""}
   find first clc_ctrl  where clc_ctrl.clc_domain = global_domain no-lock
   no-error.
end.

assign
   h_ui_proc           = this-procedure
   alloc_to_id         = cumwo_lot
   alloc_to_op         = op
   total_lotserial_qty = qty_rcv.

/* WHEN WIP LOT TRACE IS ON, SET QUEUE AND OPERATION */
if is_wiplottrace_enabled()
then do:

   /* FOR BACKFLUSH TRANSACTION, WIP LOTS EXISTS IN THE INPUT QUEUE OF THE */
   /* PREVIOUS OPERATION. AND FOR MOVE TRANSACTION, WIP LOTS EXISTS IN THE */
   /* OUTPUT QUEUE OF THE SAME OPERATION                                   */

   if execname = "rebkfl.p"
   then
      assign
         queue     = INPUT_QUEUE
         prodby_op = prev_milestone_operation(cumwo_lot,op).
   else
      assign
         queue     = OUTPUT_QUEUE
         prodby_op = op.

end. /* IF is_wiplottrace_enabled() */

{&RERCVLST-P-TAG2}
form
   pt_desc1       colon 15
   pt_lot_ser
   pt_desc2       at 17 no-label skip (1)
   lotserial_qty  colon 15
   um
   conv           colon 50
   site           colon 15
   tot_units      colon 50
   pt_um          no-label
   location       colon 15
   lotserial      colon 15
   lotref         colon 15
   multi_entry    colon 15
   chg_attr       colon 50
with frame a side-labels width 80 attr-space
   title color normal (getFrameTitle("RECEIPT_DATA_INPUT",26)).
{&RERCVLST-P-TAG3}

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/*FIND NEXT PRE-ASSIGNED OR AUTO-ASSIGNED LOT NUMBER*/
find pt_mstr
    where pt_mstr.pt_domain = global_domain and  pt_part = wo_part no-lock
    no-error.
lotprcpt = wo_lot_rcpt.
if  pt_lot_ser = "L"
and not pt_auto_lot
then
   lotserial = wo_lot_next.
else
if (pt_lot_ser = "L"
and pt_auto_lot = yes
and pt_lot_grp <> "")
then do:
   find alm_mstr
       where alm_mstr.alm_domain = global_domain and  alm_lot_grp = pt_lot_grp
      and   alm_site    = wo_site
      no-lock no-error.
   if not available alm_mstr
   then
      find alm_mstr
          where alm_mstr.alm_domain = global_domain and  alm_lot_grp =
          pt_lot_grp
         and   alm_site    = ""
         no-lock no-error.
      if not available alm_mstr
      then do:
         /* LOT FORMAT RECORD DOES NOT EXIST */
         {pxmsg.i &MSGNUM=2737 &ERRORLEVEL=3}
         return.
      end.
   else do:
      if (search(alm_pgm) = ?)
      then do:

         assign
            ii   = index(alm_pgm,".p")
            almr = global_user_lang_dir + "/"
                   + substring(alm_pgm, 1, 2) + "/"
                   + substring(alm_pgm,1,ii - 1) + ".r".
         if (search(almr)) = ?
         then do:
            /* AUTO LOT PROGRAM NOT FOUND */
            {pxmsg.i &MSGNUM=2732 &ERRORLEVEL=4 &MSGARG1=alm_pgm}
            return.
         end.
      end.
   end.
   find first sr_wkfl
       where sr_wkfl.sr_domain = global_domain and  sr_userid = mfguser
      and   sr_lineid = cline
      no-lock no-error.

   if available sr_wkfl
   then
      lotserial = sr_lotser.

   filename = "wo_mstr".

   if newlot = ""
   then do:
      alm_recno = recid(alm_mstr).

      if false
      then do:

         {gprun.i ""gpauto01.p"" "(alm_recno,
                                   recid(wo_mstr),
                                   "filename",
                                   output newlot,
                                   output trans-ok)"
          }
      end.

      {gprun.i alm_pgm "(alm_recno,
                         recid(wo_mstr),
                         "filename",
                         output newlot,
                         output trans-ok)"
      }

      if not trans-ok
      then
         return.

      lotserial = newlot.
      release alm_mstr.
   end.
end.

if is_wiplottrace_enabled()
and is_woparent_wiplot_traced(cumwo_lot)
and lotserial = ''
then do:
   if not
   (
      available pt_mstr
      and pt_auto_lot
      and pt_lot_ser = "L"
      and pt_lot_grp <> ""
   )
   then do:
      assign
         cline = "+" + wo_part
         i     = 0.
      for each sr_wkfl no-lock
          where sr_wkfl.sr_domain = global_domain and  sr_userid = mfguser
         and   sr_lineid = cline:
         i = i + 1.

         if i > 1
         then
            leave.
      end.

      if i = 1
      then do:

         find first sr_wkfl
             where sr_wkfl.sr_domain = global_domain and  sr_userid = mfguser
            and   sr_lineid = cline no-lock.

         assign
            site      = sr_site
            location  = sr_loc
            lotserial = sr_lotser
            lotref    = sr_ref.
      end.
   end.
end.

mainloop:
do transaction on error undo , retry with frame a:
{mfdel.i sr_wkfl " where sr_wkfl.sr_domain = global_domain and  sr_userid =
mfguser
                     and sr_lineid begins ""+"""}
   {gprun.i ""gplotwdl.p""}
   nbr = wo_nbr.

   status input.

   assign
      um                = ""
      lotserial_control = ""
      conv              = 1.

   if available pt_mstr
   then do:
      assign
         um                = pt_um
         lotserial_control = pt_lot_ser.

      display
         pt_desc1
         pt_desc2
         pt_lot_ser
         lotserial
      with frame a.
   end.
   else do:
      display
         "" @ pt_desc1
         "" @ pt_desc2
         "" @ pt_lot_ser
      with frame a.
   end.

   setd:
   repeat on endkey undo mainloop , leave mainloop:
      assign
         location      = ""
         lotserial_qty = total_lotserial_qty
         cline         = "+" + wo_part
         global_part   = wo_part
         i             = 0.
      for each sr_wkfl no-lock
          where sr_wkfl.sr_domain = global_domain and  sr_userid = mfguser
         and   sr_lineid = cline:
         i = i + 1.

         if i > 1
         then
            leave.
      end.

      if i = 0
      then do:
         if available pt_mstr
         then
            location = pt_loc.

         for first in_mstr
            where in_domain  = wo_domain
            and   in_part    = wo_part
            and   in_site    = wo_site
            and   in_loc    <> ""
         no-lock:
            location = in_loc.
         end. /* FOR FIRST in_mstr */
      end. /* IF i = 0 */
      else
      if i = 1
      then do:
         find first sr_wkfl
             where sr_wkfl.sr_domain = global_domain and  sr_userid = mfguser
            and   sr_lineid = cline no-lock.
         assign
            site      = sr_site
            location  = sr_loc
            lotserial = sr_lotser
            lotref    = sr_ref.
      end.

      if i = 0
      then
         site = wo_site.

      locloop:
      do on error undo, retry on endkey undo mainloop, leave mainloop:

         update
            lotserial_qty
            um
            conv
            site
            location
            lotserial when (not (available pt_mstr
                                 and pt_auto_lot
                                 and pt_lot_ser = "L"
                                 and pt_lot_grp <> ""))
            {&RERCVLST-P-TAG4}
            lotref
            multi_entry
            chg_attr
         with frame a
         editing:
            assign
               global_site = input site
               global_loc  = input location
               global_lot  = input lotserial
               ststatus    = stline[3].
            status input ststatus.
            readkey.
            apply lastkey.
         end.
         {&RERCVLST-P-TAG5}

         if available pt_mstr
         then do:

            if um <> pt_um
            then do:

               if  um entered
               and not conv entered
               then do:
                  {gprun.i ""gpumcnv.p"" "(input  um,
                                           input  pt_um,
                                           input  wo_part,
                                           output conv)"}

                  if conv = ?
                  then do:
                     {pxmsg.i &MSGNUM=33 &ERRORLEVEL=2}
                     conv = 1.
                  end.

                  display
                     conv
                  with frame a.
               end.
            end.
         end.

         /*IF SINGLE LOT PER RECEIPT THEN VERIFY IF LOT IS USED */
         if  (lotprcpt     = yes)
         and (pt_lot_ser   = "L")
         and (clc_lotlevel <> 0)
         then do:
            find first lot_mstr
                where lot_mstr.lot_domain = global_domain and  lot_serial =
                lotserial
               and   lot_part   = pt_part
               and   lot_nbr    = wo_nbr
               and   lot_line   = wo_lot
               no-lock no-error.

            if available lot_mstr
            then do:
               /* LOT IS IN USE */
               {pxmsg.i &MSGNUM=2759 &ERRORLEVEL=3}
               next-prompt lotserial with frame a.
               undo locloop, retry.
            end.

            find first lotw_wkfl
                where lotw_wkfl.lotw_domain = global_domain and  lotw_lotser  =
                 lotserial
               and   lotw_mfguser <> mfguser
               and   lotw_part    <> pt_part
               no-lock no-error.

            if available lotw_wkfl
            then do:
               /* LOT IS IN USE */
               {pxmsg.i &MSGNUM=2759 &ERRORLEVEL=3}
               next-prompt lotserial with frame a.
               undo locloop, retry.
            end.
         end.

         if (clc_lotlevel = 1)
         and (lotserial   <> "")
         then do:

            find first lot_mstr
                where lot_mstr.lot_domain = global_domain and  lot_serial =
                lotserial
               and   lot_part   = pt_part
               no-lock no-error.

            if available lot_mstr
            and (lotprcpt = yes or lot_line <> wo_lot)
            then do:
               /* LOT IS IN USE */
               {pxmsg.i &MSGNUM=2759 &ERRORLEVEL=3}
               next-prompt lotserial with frame a.
               undo locloop, retry.
            end.

            find first lotw_wkfl
                where lotw_wkfl.lotw_domain = global_domain and  lotw_lotser  =
                lotserial
               and   lotw_mfguser <> mfguser
               and   lotw_part    <> pt_part
               no-lock no-error.

            if available lotw_wkfl
            then do:
               /* LOT IS IN USE */
               {pxmsg.i &MSGNUM=2759 &ERRORLEVEL=3}
               next-prompt lotserial with frame a.
               undo locloop, retry.
            end.
         end. /* if clc_lotlevel = 1 */

         if  (clc_lotlevel = 2)
         and (lotserial    <> "")
         then do:
            find first lot_mstr
                where lot_mstr.lot_domain = global_domain and  lot_serial =
                lotserial
               no-lock no-error.

            if available lot_mstr
            and (lotprcpt    = yes
                 or lot_line <> wo_lot)
            then do:
               /* LOT IS IN USE */
               {pxmsg.i &MSGNUM=2759 &ERRORLEVEL=3}
               next-prompt lotserial with frame a.
               undo locloop, retry.
            end.

            find first lotw_wkfl
                where lotw_wkfl.lotw_domain = global_domain and  lotw_lotser  =
                 lotserial
               and   lotw_mfguser <> mfguser
               no-lock no-error.

            if available lotw_wkfl
            then do:
               /* LOT IS IN USE */
               {pxmsg.i &MSGNUM=2759 &ERRORLEVEL=3}
               next-prompt lotserial with frame a.
               undo locloop, retry.
            end.
         end. /* if clc_lotlevel = 2 */

         /*CHANGE ATTRIBUTES*/
         /*INITIALIZE ATTRIBUTE VARIABLES WITH CURRENT SETTINGS*/

         assign
            chg_assay   = wo_assay
            chg_grade   = wo_grade
            chg_expire  = wo_expire
            chg_status  = wo_rctstat
            assay_actv  = yes
            grade_actv  = yes
            expire_actv = yes
            status_actv = yes.

         if wo_rctstat_active = no
         then do:
            find in_mstr
                where in_mstr.in_domain = global_domain and  in_part = wo_part
               and   in_site = wo_site
               no-lock no-error.

            if available in_mstr
            and in_rctwo_active = yes
            then
               chg_status = in_rctwo_status.
            else
            if available pt_mstr
            and pt_rctwo_active = yes
            then
               chg_status = pt_rctwo_status.
            else do:
               assign
                  chg_status  = ""
                  status_actv = no.
            end.
         end.

         /*SET AND UPDATE INVENTORY DETAIL ATTRIBUTES*/
         pause 0.
         if chg_attr
         then do:
            /* ADDED THIRD PARAMETER EFF_DATE */
            {gprun.i ""worcat02.p"" "(input        recid(wo_mstr),
                                      input        chg_attr,
                                      input        eff_date,
                                      input-output chg_assay,
                                      input-output chg_grade,
                                      input-output chg_expire,
                                      input-output chg_status,
                                      input-output assay_actv,
                                      input-output grade_actv,
                                      input-output expire_actv,
                                      input-output status_actv)"}

            /* Check Inventory Status Value */
            if (status_actv or
                chg_status <> "")
            and not can-find (is_mstr where is_domain = global_domain
                                      and   is_status = chg_status)
            then do:
                next-prompt chg_attr with frame a.
                undo locloop, retry.
            end. /* IF (status_actv OR chg_status <> "") */

         end.

         i = 0.
         for each sr_wkfl no-lock
             where sr_wkfl.sr_domain = global_domain and  sr_userid = mfguser
            and   sr_lineid = cline:
            i = i + 1.

            if i > 1
            then do:
               multi_entry = yes.
               leave.
            end.
         end.

         assign
            trans_um   = um
            trans_conv = conv
            temp_qty   = lotserial_qty.

         if multi_entry
         then do:
            if i >= 1
            then do:
               assign
                  site     = ""
                  location = ""
                  lotref   = "".
            end.

            if (lotprcpt = yes)
            then
               lotnext = lotserial.

            /*ADDED BLANKS FOR INPUTS TRNBR AND TRLINE  */
            /*TO ICSRUP.P CALL BELOW                    */
            /* ADDED SIXTH INPUT PARAMETER AS NO        */

            /* Identify context for QXtend */
            {gpcontxt.i
               &STACKFRAG = 'icsrup,rercvlst,rebkfl'
               &FRAME = 'a'
               &CONTEXT = 'RECEIPT'}

            {gprun.i ""icsrup.p"" "(input        wo_site,
                                    input        """",
                                    input        """",
                                    input-output lotnext,
                                    input        lotprcpt,
                                    input        no)"}

            /* Clear context for QXtend */
            {gpcontxt.i
               &STACKFRAG = 'icsrup,rercvlst,rebkfl'
               &FRAME = 'a'}

         end.

         else do:

            {gprun.i ""icedit.p"" "(""RCT-WO"",
                                      site,
                                      location,
                                      wo_part,
                                      lotserial,
                                      lotref,
                                      lotserial_qty * trans_conv,
                                      trans_um,
                                      """",
                                      """",
                                      output yn)"
            }
            if yn
               and not batchrun
            then
               undo locloop, retry.
            else if yn
               and batchrun
            then
               undo mainloop , leave mainloop.
            if wo_site <> site
            then do:

                  if available in_mstr
                  then
                     l_loc = in_loc.
                  else
                     l_loc = pt_loc.

               {gprun.i ""icedit4.p"" "(input ""RCT-WO"",
                                        input   wo_site,
                                        input   site,
                                        input   l_loc,
                                        input   location,
                                        input   wo_part,
                                        input   lotserial,
                                        input   lotref,
                                        input   lotserial_qty * trans_conv,
                                        input   trans_um,
                                        input   """",
                                        input   """",
                                        output  yn)"
               }
            if yn
               and not batchrun
            then
               undo locloop, retry.
            else if yn
               and batchrun
            then
               undo mainloop , leave mainloop.

            end.

            find first sr_wkfl
                where sr_wkfl.sr_domain = global_domain and  sr_userid = mfguser
               and   sr_lineid = cline no-error.

            if lotserial_qty = 0
            then do:
               if available sr_wkfl
               then do:
                  total_lotserial_qty = total_lotserial_qty - sr_qty.
                  delete sr_wkfl.
               end.
           else
              total_lotserial_qty = 0.

               {gprun.i ""gplotwdl.p""}
            end.
            else do:
               if available sr_wkfl
               then do:
                  assign
                     total_lotserial_qty = total_lotserial_qty - sr_qty
                                           + lotserial_qty
                     sr_site             = site
                     sr_loc              = location
                     sr_lotser           = lotserial
                     sr_ref              = lotref
                     sr_qty              = lotserial_qty.
               end.

               else do:
                  create sr_wkfl. sr_wkfl.sr_domain = global_domain.
                  assign
                     sr_userid           = mfguser
                     sr_lineid           = cline
                     sr_site             = site
                     sr_loc              = location
                     sr_lotser           = lotserial
                     sr_ref              = lotref
                     sr_qty              = lotserial_qty
                     total_lotserial_qty = lotserial_qty.
               end.
            end.
         end.

         /*TEST FOR ATTRIBUTE CONFLICTS*/
         for each sr_wkfl
             where sr_wkfl.sr_domain = global_domain and  sr_userid = mfguser
            and   sr_lineid = "+" + wo_part no-lock:

            /* ADDED SIXTH PARAMETER EFF_DATE */
            /* ADDED SEVENTH PARAMETER sr_qty * trans_conv */
            {gprun.i ""worcat01.p"" "(input        recid(wo_mstr),
                                      input        sr_site,
                                      input        sr_loc,
                                      input        sr_ref,
                                      input        sr_lotser,
                                      input        eff_date,
                                      input        sr_qty * trans_conv,
                                      input-output chg_assay,
                                      input-output chg_grade,
                                      input-output chg_expire,
                                      input-output chg_status,
                                      input-output assay_actv,
                                      input-output grade_actv,
                                      input-output expire_actv,
                                      input-output status_actv,
                                      output       trans-ok)"}

            if not trans-ok
            then do:

               /* MOVED STATUS CONFLICT MESSAGE TO worcat01.p     */
               /*ATTRIBUTES DO NOT MATCH LD_DET*/

               next-prompt site.
               undo locloop, retry.
            end.
         end. /*for each sr_wkfl*/
      end.

      tot_units = total_lotserial_qty * conv.
      display
         tot_units
         pt_um
      with frame a.
      i = 0.

      for each sr_wkfl no-lock
          where sr_wkfl.sr_domain = global_domain and  sr_userid = mfguser
         and   sr_lineid = cline:
         i = i + 1.
         if i > 1
         then
            leave.
      end.

      if i > 1
      then do on endkey undo mainloop , retry mainloop:
         yn = yes.
         /*DISPLAY ITEM & LOT/SERIAL DETAIL*/
         {pxmsg.i &MSGNUM=359 &ERRORLEVEL=1 &CONFIRM=yn}

         if yn
         then do:
            hide frame a.

            for each sr_wkfl no-lock
                where sr_wkfl.sr_domain = global_domain and  sr_userid = mfguser
               and   sr_lineid = cline
               with frame b width 80 no-attr-space
               title (getFrameTitle("RECEIPT_DATA_REVIEW",28)):

               setFrameLabels(frame b:handle).
               display
                  sr_site
                  sr_loc
                  sr_lotser
                  sr_ref format "x(8)" column-label {&rercvlst_p_3}
                  sr_qty um.
            end.
         end.
      end.

      do on endkey undo mainloop , retry mainloop:
         if temp_qty <> total_lotserial_qty
         then do:
            display
               total_lotserial_qty @ lotserial_qty
            with frame a.
            {pxmsg.i &MSGNUM    =300
                     &ERRORLEVEL=2
                     &MSGARG1   =total_lotserial_qty
                     &MSGARG2   =um
                     &MSGARG3   =""""}
         end.

         yn = yes.
         /*IS ALL INFORMATION CORRECT*/
         {pxmsg.i &MSGNUM=12 &ERRORLEVEL=1 &CONFIRM=yn}

         if yn
         then do:
            if index("LS",lotserial_control) > 0
            then
               for each sr_wkfl no-lock
                   where sr_wkfl.sr_domain = global_domain and  sr_userid =
                   mfguser
                  and   sr_lineid = cline
                  and   sr_lotser = "":
                  {pxmsg.i &MSGNUM=1119 &ERRORLEVEL=3}
                  next setd.
               end.

            if conv <> 1
            then
               for each sr_wkfl
                   where sr_wkfl.sr_domain = global_domain and  sr_userid =
                   mfguser
                  and   sr_lineid = cline:
                  sr_qty = sr_qty * conv.
               end.

               if total_lotserial_qty * conv <> qty_rcv
               then do:
                  {pxmsg.i &MSGNUM    =5109
                           &ERRORLEVEL=3
                           &MSGARG1   ="string(total_lotserial_qty) + "" ""
                                        + string(qty_rcv / conv)"}
                  next setd.
               end.

               assign
                  undo_stat           = no
                  total_lotserial_qty = total_lotserial_qty * conv.
               leave setd.
         end.
      end.
   end.

   hide frame a.
   hide frame b.
end.

/* PROCEDURE TO DISPLAY THE VALUES IN THE FRAME FROM WINDOW HELP */

PROCEDURE return_updateframe_values:

   define input parameter ip_lotserial like wld_lotser no-undo.
   define input parameter ip_lotref    like wld_ref    no-undo.

   display
      ip_lotserial @ lotserial
      ip_lotref    @ lotref
   with frame a.

END PROCEDURE. /* return_updateframe_values */
