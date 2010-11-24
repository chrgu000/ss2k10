/* woisrc02.p - WORK ORDER RECEIPT W/ SERIAL NUMBERS                          */
/* Copyright 1986-2006 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.44 $                                                               */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 6.0      LAST MODIFIED: 06/08/90    BY: emb                      */
/* REVISION: 6.0      LAST MODIFIED: 12/17/90    BY: wug *D619*               */
/* REVISION: 6.0      LAST MODIFIED: 09/12/91    BY: wug *D858*               */
/* REVISION: 6.0      LAST MODIFIED: 10/02/91    BY: alb *D887*               */
/* REVISION: 6.0      LAST MODIFIED: 11/08/91    BY: wug *D920*               */
/* REVISION: 6.0      LAST MODIFIED: 11/27/91    BY: ram *D954*               */
/* REVISION: 7.0      LAST MODIFIED: 01/28/92    BY: pma *F104*               */
/* REVISION: 7.0      LAST MODIFIED: 02/12/92    BY: pma *F190*               */
/* REVISION: 7.3      LAST MODIFIED: 09/22/92    BY: ram *G079*               */
/* REVISION: 7.3      LAST MODIFIED: 09/27/93    BY: jcd *G247*               */
/* REVISION: 7.3      LAST MODIFIED: 03/04/93    BY: ram *G782*               */
/* REVISION: 7.3      LAST MODIFIED: 05/07/93    BY: ram *GA79*               */
/* REVISION: 7.4      LAST MODIFIED: 07/22/93    BY: pcd *H039*               */
/* REVISION: 7.4      LAST MODIFIED: 12/20/93    BY: pcd *GH30*               */
/* REVISION: 7.2      LAST MODIFIED: 04/12/94    BY: pma *FN34*               */
/* Oracle changes (share-locks)      09/13/94    BY: rwl *GM56*               */
/* REVISION: 7.2      LAST MODIFIED: 09/22/94    BY: ljm *GM78*               */
/* REVISION: 8.5      LAST MODIFIED: 10/07/94    BY: TAF *J035*               */
/* REVISION: 7.2      LAST MODIFIED: 11/08/94    BY: ljm *GO33*               */
/* REVISION: 8.5      LAST MODIFIED: 10/27/94    BY: pma *J040*               */
/* REVISION: 8.5      LAST MODIFIED: 11/10/94    BY: TAF *J038*               */
/* REVISION: 8.5      LAST MODIFIED: 12/08/94    by: mwd *J034*               */
/* REVISION: 8.5      LAST MODIFIED: 12/28/94    by: ktn *J041*               */
/* REVISION: 8.5      LAST MODIFIED: 03/08/95    by: dzs *J046*               */
/* REVISION: 7.4      LAST MODIFIED: 03/23/95    by: srk *G0KT*               */
/* REVISION: 8.5      LAST MODIFIED: 06/07/95    by: sxb *J04D*               */
/* REVISION: 7.3      LAST MODIFIED: 06/26/95    by: qzl *G0R0*               */
/* REVISION: 8.5      LAST MODIFIED: 07/31/95    by: kxn *J069*               */
/* REVISION: 7.2      LAST MODIFIED: 08/17/95    BY: qzl *F0TC*               */
/* REVISION: 8.5      LAST MODIFIED: 11/29/95    by: kxn *J09C*               */
/* REVISION: 8.5      LAST MODIFIED: 03/18/96    by: jpm *J0F5*               */
/* REVISION: 8.5      LAST MODIFIED: 07/16/96    by: kxn *J0QX*               */
/* REVISION: 8.5      LAST MODIFIED: 07/27/96    by: jxz *J12C*               */
/* REVISION: 8.5      LAST MODIFIED: 08/06/96    BY: *G1YK*  Russ Witt        */
/* REVISION: 8.5      LAST MODIFIED: 08/17/97    BY: *J1Z9* Felcy D'Souza     */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.5      LAST MODIFIED: 04/15/98   BY: *J2K7* Fred Yeadon        */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 12/01/98   BY: *J35X* Thomas Fernandes   */
/* REVISION: 9.0      LAST MODIFIED: 03/05/99   BY: *J3C2* Vivek Gogte        */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 03/30/99   BY: *J39K* Sanjeev Assudani   */
/* REVISION: 9.1      LAST MODIFIED: 09/04/99   BY: *J3KM* G.Latha            */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 04/13/00   BY: *L0TJ* Jyoti Thatte       */
/* REVISION: 9.1      LAST MODIFIED: 09/05/00   BY: *N0RF* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0K2* Phil DeRogatis     */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.27     BY: Veena Lad          DATE: 11/30/00 ECO: *P008*       */
/* Revision: 1.27     BY: Irene D'Mello      DATE: 06/26/01 ECO: *P00X*       */
/* Revision: 1.30     BY: Irene D'Mello      DATE: 09/10/01 ECO: *M164*       */
/* Revision: 1.32     BY: Ashish Maheshwari  DATE: 07/17/02 ECO: *N1GJ*       */
/* Revision: 1.33     BY: Vandna Rohira      DATE: 09/17/02 ECO: *N1V4*       */
/* Revision: 1.34     BY: Anitha Gopal       DATE: 03/28/03 ECO: *P0PG*       */
/* Revision: 1.35     BY: Narathip W.        DATE: 04/29/03 ECO: *P0QN*       */
/* Revision: 1.37     BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00N*       */
/* Revision: 1.39     BY: Dorota Hohol       DATE: 08/25/03 ECO: *P112*       */
/* Revision: 1.40     BY: Kirti Desai        DATE: 10/22/03 ECO: *P16R*       */
/* Revision: 1.41     BY: Sukhad Kulkarni   DATE: 09/06/04 ECO: *P2J6*        */
/* Revision: 1.42     BY: Swati Sharma      DATE: 10/06/04 ECO: *P2N2*        */
/* Revision: 1.43     BY: Sukhad Kulkarni   DATE: 01/20/05 ECO: *P34N*         */
/* $Revision: 1.44 $   BY: Jean Miller     DATE: 01/10/06  ECO: *Q0PD*  */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{cxcustom.i "WOISRC02.P"}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE woisrc02_p_1 "Total Units"
/* MaxLen: Comment: */

&SCOPED-DEFINE woisrc02_p_3 "Scrapped Qty"
/* MaxLen: Comment: */

&SCOPED-DEFINE woisrc02_p_4 "Close"
/* MaxLen: Comment: */

&SCOPED-DEFINE woisrc02_p_5 "L/S"
/* MaxLen: Comment: */

&SCOPED-DEFINE woisrc02_p_6 "Open Qty"
/* MaxLen: Comment: */

&SCOPED-DEFINE woisrc02_p_7 "Chg Attributes"
/* MaxLen: Comment: */

&SCOPED-DEFINE woisrc02_p_8 "Multi Entry"
/* MaxLen: Comment: */

&SCOPED-DEFINE woisrc02_p_9 "Conversion"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define output parameter trans_ok like mfc_logical.

define new shared variable transtype as character initial "RCT-WO".
define new shared variable total_lotserial_qty like sr_qty.
define new shared variable comp                like ps_comp.
define new shared variable qty                 like wo_qty_ord.
define new shared variable leadtime            like pt_mfg_lead.
define new shared variable prev_status         like wo_status.
define new shared variable prev_release        like wo_rel_date.
define new shared variable prev_due            like wo_due_date.
define new shared variable prev_qty            like wo_qty_ord.
define new shared variable del-yn              like mfc_logical.
define new shared variable deliv               like wod_deliver.
define new shared variable any_issued          like mfc_logical.

define new shared variable pl_recno    as recid.
define new shared variable reject_qty  like wo_rjct_chg
                                       label {&woisrc02_p_3} no-undo.
define new shared variable multi_entry like mfc_logical
                                       label {&woisrc02_p_8} no-undo.
define new shared variable lotserial_control as character.
define new shared variable site          like sr_site no-undo.
define new shared variable location      like sr_loc no-undo.
define new shared variable lotserial_qty like sr_qty no-undo.
define new shared variable cline            as character.
define new shared variable issue_or_receipt as character.
define new shared variable trans_um   like pt_um.
define new shared variable trans_conv like sod_um_conv.
define new shared variable lotref     like sr_ref format "x(8)" no-undo.

define shared variable lotserial like sr_lotser no-undo.
define shared variable conv like um_conv label {&woisrc02_p_9} no-undo.
define shared variable close_wo like mfc_logical label {&woisrc02_p_4}.
define shared variable wo_recno as recid.
define shared variable eff_date like glt_effdate.
define shared variable rmks   like tr_rmks.
define shared variable serial like tr_serial.
define shared variable reject_conv like conv no-undo.
define shared variable jp        like mfc_logical initial no.
define shared variable undo_all  like mfc_logical no-undo.
{&WOISRC02-P-TAG1}

define variable alm_recno as recid.

define variable yn        like mfc_logical.
define variable trans-ok  like mfc_logical.
define variable chg_attr  like mfc_logical label {&woisrc02_p_7} no-undo.

define variable lot       like ld_lot  no-undo.
define variable um        like pt_um   no-undo.
define variable reject_um like pt_um   no-undo.
define variable almr      like alm_pgm no-undo.

define variable nbr       like wo_nbr      no-undo.
define variable wonbr     like wo_nbr      no-undo.
define variable lotnext   like wo_lot_next no-undo.
define variable newlot    like wo_lot_next no-undo.
define variable lotprcpt  like wo_lot_rcpt no-undo.
define variable wolot     like wo_lot      no-undo.
define variable tot_units like wo_qty_chg  label {&woisrc02_p_1} no-undo.
define variable open_ref  like wo_qty_ord  label {&woisrc02_p_6} no-undo.

define variable i          as integer              no-undo.
define variable ii         as integer              no-undo.
define variable null_ch    as character initial "" no-undo.
define variable filename   as character            no-undo.
define variable field1     as character            no-undo.
define variable fas_wo_rec as character            no-undo.

{gpglefv.i}

/*DEFINE VARIABLES FOR CHANGE ATTRIBUTES FEATURE*/
{gpatrdef.i "shared"}

assign
   issue_or_receipt = getTermLabel("RECEIPT",8).

{&WOISRC02-P-TAG2}
form
   wo_rmks        colon 15
   open_ref       colon 15
   pt_um          colon 40
   pt_lot_ser     colon 57 label {&woisrc02_p_5}
   wo_batch       colon 15
   pt_auto_lot    colon 57
   skip(1)
   lotserial_qty  colon 15
   site           colon 57
   um             colon 15
   location       colon 57
   conv           colon 15
   lotserial      colon 57
   reject_qty     colon 15
   lotref         colon 57
   reject_um      colon 15
   multi_entry    colon 57
   reject_conv    colon 15
   chg_attr       colon 57
   tot_units      colon 57
   skip(1)
   rmks           colon 15
   close_wo       colon 40
with frame a side-labels width 80 attr-space.
{&WOISRC02-P-TAG3}

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

find first clc_ctrl  where clc_ctrl.clc_domain = global_domain no-lock no-error.
if not available clc_ctrl
then do:
   {gprun.i ""gpclccrt.p""}
   find first clc_ctrl  where clc_ctrl.clc_domain = global_domain no-lock.
end.

trans_ok = yes.

find wo_mstr no-lock
   where recid(wo_mstr) = wo_recno.

assign
   lotserial = ""
   lotnext   = ""
   newlot    = ""
   close_wo  = no.

if wo_type = "E" or wo_type = "R"
then
   assign
      wonbr = ""
      wolot = ""
      lotprcpt = no.

else
   assign
      wonbr = wo_nbr
      wolot = wo_lot
      lotprcpt = wo_lot_rcpt.

find pt_mstr
    where pt_mstr.pt_domain = global_domain and  pt_part = wo_part no-lock
    no-error.

/* wo_lot_next HOLDS THE LOT NUMBER FOR A PARTICULAR WORK ORDER.  */
/* WHEN THE PARENT ITEM IS LOT CONTROLLED AND LOT GROUP IS BLANK, */
/* wo_lot_next SHOULD BE ASSIGNED THE WORK ORDER ID.              */
do transaction:

   find wo_mstr
      where recid(wo_mstr) = wo_recno
      exclusive-lock no-error.

   if  pt_auto_lot = yes
   and pt_lot_ser = "L"
   and pt_lot_grp = " "
   then do:
      if (wo_lot_next = "")
      then
         wo_lot_next =   wo_lot.
   end. /* IF PT_AUTO_NEXT = YES THEN */

end. /* DO TRANSACTION */

if (pt_lot_ser = "L")
   and (not pt_auto_lot or (index("ER", wo_type) > 0))
then
   lotserial = wo_lot_next.

if (pt_lot_ser = "L"
   and pt_auto_lot = yes
   and pt_lot_grp <> "")
   and (index("ER",wo_type) = 0 )
then do:

   find alm_mstr
       where alm_mstr.alm_domain = global_domain and  alm_lot_grp = pt_lot_grp
        and alm_site = wo_site
      no-lock no-error.

   if not available alm_mstr
   then
      find alm_mstr
          where alm_mstr.alm_domain = global_domain and  alm_lot_grp =
          pt_lot_grp
           and alm_site = ""
         no-lock no-error.

   if not available alm_mstr
   then do:

      /* LOT FORMAT RECORD DOES NOT EXIST */
      {pxmsg.i &MSGNUM=2737 &ERRORLEVEL=3}
      trans_ok = no.
      return.
   end.

   else do:

      if (search(alm_pgm) = ?)
      then do:

         ii = index(alm_pgm,".p").
         almr = global_user_lang_dir + "/"
                + substring(alm_pgm, 1, 2) + "/"
                + substring(alm_pgm,1,ii - 1) + ".r".

         if (search(almr)) = ?
         then do:

            /* Auto Lot Program not found */
            {pxmsg.i &MSGNUM=2732 &ERRORLEVEL=4 &MSGARG1=alm_pgm}
            trans_ok = no.
            return.
         end.
      end.
   end.

   find first sr_wkfl
       where sr_wkfl.sr_domain = global_domain and  sr_userid = mfguser
        and sr_lineid = cline
      no-lock no-error.

   if available sr_wkfl
   then
      lotserial = sr_lotser.

   if newlot = ""
   then do:

      assign
         alm_recno = recid(alm_mstr)
         filename = "mwo_mstr".

      if false
      then do:

         {gprun.i ""gpauto01.p""
            "(input alm_recno,
              input wo_recno,
              input "filename",
              output newlot,
              output trans-ok)"}
      end.

      {gprun.i alm_pgm
         "(input alm_recno,
           input wo_recno,
           input "filename",
           output newlot,
           output trans-ok)"}

      if not trans-ok
      then do:

         /* LOT FORMAT RECORD DOES NOT EXIST */
         {pxmsg.i &MSGNUM=2737 &ERRORLEVEL=3}
         trans_ok = no.
         return.
      end.

      lotserial = newlot.

      release alm_mstr.

   end.  /* IF newlot = "" */

end.  /* IF pt_lot_ser = "L" */

display
   lotserial
with frame a.

/* DISPLAY */
mainloop:
do on error undo, retry with frame a:

   for each sr_wkfl
      where sr_wkfl.sr_domain = global_domain and  sr_userid = mfguser
       and sr_lineid = ""
     exclusive-lock:

      delete sr_wkfl.
   end.

   assign
      total_lotserial_qty = 0
      nbr = wo_nbr.

   status input.

   open_ref = wo_qty_ord - wo_qty_comp - wo_qty_rjct.

   {&WOISRC02-P-TAG4}
   display
      wo_rmks
      open_ref
      wo_batch
   with frame a.

   assign
      um = ""
      conv = 1.

   if available pt_mstr
   then do:
      um = pt_um.
      display
         pt_um
         pt_lot_ser
         pt_auto_lot
      with frame a.
   end.

   else do:
      display
         "" @ pt_um
         "" @ pt_lot_ser
         "" @ pt_auto_lot
      with frame a.
   end.

   assign
      prev_status  = wo_status
      prev_release = wo_rel_date
      prev_due     = wo_due_date
      prev_qty     = wo_qty_ord
      total_lotserial_qty = open_ref
      reject_qty   = 0
      um           = ""
      reject_um    = "".

   if available pt_mstr
   then do:
      um = pt_um.
      reject_um = pt_um.
   end.

   assign
      conv = 1
      reject_conv = 1
      lotserial_control = "".

   if available pt_mstr
   then
      lotserial_control = pt_lot_ser.

   setd:
   repeat on endkey undo mainloop, leave mainloop:

      assign
         site = ""
         location = ""
         lotref = ""
         lotserial_qty = total_lotserial_qty
         total_lotserial_qty = 0.

      if wo_joint_type <> ""
         and wo_joint_type <> "5"
      then
         cline = "RCT" + wo_part.

      else
         cline = "".

      global_part = wo_part.
      i = 0.

      for each sr_wkfl no-lock
          where sr_wkfl.sr_domain = global_domain and  sr_userid = mfguser
           and sr_lineid = cline:

         i = i + 1.
         if i > 1 then leave.
      end.

      if i = 0
      then do:

         assign
            site = wo_site
            location = wo_loc.

         if location = ""
            and available pt_mstr
         then
            location = pt_loc.
      end.

      else if i = 1
      then do:

         find first sr_wkfl
             where sr_wkfl.sr_domain = global_domain and  sr_userid = mfguser
              and sr_lineid = cline no-lock.

         assign
            site = sr_site
            location = sr_loc
            lotserial = sr_lotser
            lotref = sr_ref.
      end.

      /*INITIALIZE ATTRIBUTE VARIABLES WITH CURRENT SETTINGS*/
      assign
         chg_assay   = wo_assay
         chg_grade   = wo_grade
         chg_expire  = wo_expire
         chg_status  = wo_rctstat
         assay_actv  = yes
         grade_actv  = yes
         expire_actv = yes
         status_actv = wo_rctstat_active
         resetattr   = no.

      locloop:
      do on error undo, retry
         on endkey undo mainloop, leave mainloop:

         if available pt_mstr
            and pt_auto_lot
         then do:

            if pt_lot_grp = ""
            then
               lotserial = wo_lot_next.

            multi_entry = no.

            display
               lotserial
               multi_entry
            with frame a.

            update
               lotserial_qty
               um
               conv
               reject_qty
               reject_um
               reject_conv
               site
               location
               lotref
               multi_entry
               chg_attr
            with frame a editing:

               assign
                  global_site = input site
                  global_loc  = input location.

               readkey.
               apply lastkey.
            end.

         end.

         else do:

            update
               lotserial_qty
               um
               conv
               reject_qty
               reject_um
               reject_conv
               site
               location
               lotserial
               lotref
               multi_entry
               chg_attr
            with frame a editing:

               assign
                  global_site = input site
                  global_loc  = input location
                  global_lot  = input lotserial
                  global_ref  = input lotref.

               readkey.
               apply lastkey.
            end.
         end.

         {&WOISRC02-P-TAG8}

         if reject_qty <> 0
         then do:
            if can-find(first isd_det
               where isd_domain  = global_domain
               and   isd_status  = string(pt_status,"x(8)") + "#"
               and   isd_tr_type = "RJCT-WO")
            then do:
               /* RESTRICTED PROCEDURE FOR ITEM STATUS CODE */
               {pxmsg.i &MSGNUM=358
                  &ERRORLEVEL=3
                  &MSGARG1=pt_status}
               undo locloop, retry locloop.
            end. /* IF CAN-FIND(FIRST isd_det)... */
         end. /* IF reject_qty > 0 */

         if available pt_mstr
         then do:

            if um <> pt_um
            then do:

               if not conv entered
               then do:

                  {gprun.i ""gpumcnv.p""
                     "(input um,
                       input pt_um,
                       input wo_part,
                       output conv)"}

                  if conv = ?
                  then do:

                     /* No Unit of Measure Conversion */
                     {pxmsg.i &MSGNUM=33 &ERRORLEVEL=2}
                     conv = 1.
                  end.

                  display conv with frame a.
               end.
            end.

            if reject_um <> pt_um
            then do:

               if not reject_conv entered
               then do:

                  {gprun.i ""gpumcnv.p""
                     "(input reject_um,
                       input pt_um,
                       input wo_part,
                       output reject_conv)"}

                  if reject_conv = ?
                  then do:

                     /* No Unit of Measure Conversion exists */
                     {pxmsg.i &MSGNUM=33 &ERRORLEVEL=2}
                     reject_conv = 1.
                  end.

                  display
                     reject_conv
                  with frame a.
               end.
            end.

            /* IF SINLE LOT PER WO RECEIPTS THEN VERIFY IF IT IS */
            /* GOOD                                              */
            if (lotprcpt = yes)   and
               (pt_lot_ser = "L") and
               (clc_lotlevel <> 0)
            then do:

               find first lot_mstr
                   where lot_mstr.lot_domain = global_domain and  lot_serial =
                   lotserial
                    and lot_part = wo_part
                    and lot_nbr = wo_nbr
                    and lot_line = wo_lot
               no-lock no-error.

               if available lot_mstr
               then do:

                  /* LOT IS IN USED */
                  {pxmsg.i &MSGNUM=2759 &ERRORLEVEL=3}
                  next-prompt lotserial with frame a.
                  undo, retry .
               end.

               find first lotw_wkfl
                   where lotw_wkfl.lotw_domain = global_domain and  lotw_lotser
                   = lotserial
                    and lotw_mfguser <> mfguser
                    and lotw_part <> pt_part
               no-lock no-error.

               if available lotw_wkfl
               then do:

                  /* LOT IS IN USED */
                  {pxmsg.i &MSGNUM=2759 &ERRORLEVEL=3}
                  next-prompt lotserial with frame a.
                  undo , retry .
               end.

            end.

         end.   /* IF AVAILABLE pt_mstr */

         i = 0.
         for each sr_wkfl
             where sr_wkfl.sr_domain = global_domain and  sr_userid = mfguser
              and sr_lineid = cline
         no-lock:

            i = i + 1.
            if i > 1
            then do:
               multi_entry = yes.
               leave.
            end.
         end.

         trans_um = um.
         trans_conv = conv.

         if multi_entry
         then do:

            if i >= 1
            then do:

               assign
                  site     = ""
                  location = ""
                  lotref   = "".
            end.

            if (lotprcpt = yes) then
               lotnext = lotserial.

            /* ADDED SIXTH INPUT PARAMETER AS NO */
            {gprun.i ""icsrup.p""
               "(input wo_site,
                 input wo_nbr,
                 input wo_lot,
                 input-output lotnext,
                 input lotprcpt,
                 input no)"}

         end. /* if multi_entry then do */

         else do:

            if lotserial_qty <> 0
            then do:

               {gprun.i ""icedit.p""
                  "(input transtype,
                    input site,
                    input location,
                    input global_part,
                    input lotserial,
                    input lotref,
                    input (lotserial_qty * trans_conv),
                    input trans_um,
                    input wonbr,
                    input wolot,
                    output yn )" }
               if yn then undo locloop, retry.

            end. /* IF lotserial_qty <> 0 */

            if wo_site <> site
            then do:

               if lotserial_qty <> 0
               then do:

                  {gprun.i ""icedit4.p""
                     "(input ""RCT-WO"",
                       input wo_site,
                       input site,
                       input pt_loc,
                       input location,
                       input global_part,
                       input lotserial,
                       input lotref,
                       input lotserial_qty * trans_conv,
                       input trans_um,
                       input wonbr,
                       input wolot,
                       output yn)"}

                  if yn then undo locloop, retry.
               end. /* IF lotserial_qty <> 0 */
            end. /* if wo_site <> site */

            total_lotserial_qty = 0.

            for each sr_wkfl
                where sr_wkfl.sr_domain = global_domain and  sr_userid = mfguser
                 and sr_lineid = cline
            no-lock:

               total_lotserial_qty = total_lotserial_qty + sr_qty.
            end.

            find first sr_wkfl
                where sr_wkfl.sr_domain = global_domain and  sr_userid = mfguser
                 and sr_lineid = cline no-error.

            if lotserial_qty = 0
            then do:

               if available sr_wkfl
               then do:

                  total_lotserial_qty = total_lotserial_qty - sr_qty.
                  delete sr_wkfl.
               end.
            end.

            else do:

               if available sr_wkfl
               then do:

                  assign
                     total_lotserial_qty = total_lotserial_qty - sr_qty
                                           + lotserial_qty
                     sr_site = site
                     sr_loc = location
                     sr_lotser = lotserial
                     sr_ref = lotref
                     sr_qty = lotserial_qty.
               end.
               else do:
                  create sr_wkfl. sr_wkfl.sr_domain = global_domain.
                  assign
                     sr_userid = mfguser
                     sr_lineid = cline
                     sr_site = site
                     sr_loc = location
                     sr_lotser = lotserial
                     sr_ref = lotref
                     sr_qty = lotserial_qty.
                     total_lotserial_qty = total_lotserial_qty
                                           + lotserial_qty.
               end.
            end.

         end.

         /*SET AND UPDATE INVENTORY DETAIL ATTRIBUTES*/
         {gprun.i ""worcat02.p""
            "(input  recid(wo_mstr),
              input  chg_attr,
              input  eff_date,
              input-output chg_assay,
              input-output chg_grade,
              input-output chg_expire,
              input-output chg_status,
              input-output assay_actv,
              input-output grade_actv,
              input-output expire_actv,
              input-output status_actv)"}

         /*TEST FOR ATTRIBUTE CONFLICTS*/
         for each sr_wkfl
             where sr_wkfl.sr_domain = global_domain and  sr_userid = mfguser
              and sr_lineid = cline
         no-lock with frame a:

            {gprun.i ""worcat01.p""
               "(input recid(wo_mstr),
                 input sr_site,
                 input sr_loc,
                 input sr_ref,
                 input sr_lotser,
                 input eff_date,
                 input sr_qty * trans_conv,
                 input-output chg_assay,
                 input-output chg_grade,
                 input-output chg_expire,
                 input-output chg_status,
                 input-output assay_actv,
                 input-output grade_actv,
                 input-output expire_actv,
                 input-output status_actv,
                 output trans-ok)"}

            if not trans-ok then do with frame a:
               /*ATTRIBUTES DO NOT MATCH LD_DET*/
               next-prompt site.
               undo locloop, retry.
            end.

         end. /*FOR EACH sr_wkfl*/

      end. /*LOCLOOP*/

      tot_units = total_lotserial_qty * conv + reject_qty * reject_conv.

      if ((total_lotserial_qty * conv > 0)
         and (reject_qty * reject_conv < 0))
          or ((total_lotserial_qty * conv < 0)
             and (reject_qty * reject_conv > 0))
      then do:

         /* Good & Scrapped must have same sign*/
         {pxmsg.i &MSGNUM=502 &ERRORLEVEL=3}
         reject_qty = 0.
         undo, retry.
      end.

      /* CHECK FOR lotserial_qty ENTERED */
      if (wo_qty_ord > 0 and
         (wo_qty_comp + (total_lotserial_qty * conv)) < 0)
      or (wo_qty_ord < 0 and (wo_qty_comp + (total_lotserial_qty * conv)) >  0)
      then do:
         /*REVERSE RCPT MAY NOT EXCEED PREV RCPT*/
         {pxmsg.i &MSGNUM=556 &ERRORLEVEL=3}
         reject_qty = 0.
         undo, retry.
      end.

      /* CHECK FOR reject_qty ENTERED */
      if (wo_qty_ord > 0 and (wo_qty_rjct + (reject_qty * reject_conv)) < 0)
      or (wo_qty_ord < 0 and (wo_qty_rjct + (reject_qty * reject_conv)) >  0)
      then do:
         /*REVERSE SCRAP MAY NOT EXCEED PREV SCRAP*/
         {pxmsg.i &MSGNUM=1373 &ERRORLEVEL=3}
         reject_qty = 0.
         undo, retry.
      end.

      display
         tot_units
      with frame a.

      if available pt_mstr and not jp then
      do on endkey undo mainloop, retry mainloop:

         seta:
         do on error undo:
            {&WOISRC02-P-TAG5}
            update rmks close_wo  with frame a.
            {&WOISRC02-P-TAG6}
         end. /* seta */
      end.

      /* CLOSING FOR A SINGLE JOINT PRODUCT RECEIPT   */
      /* RESULTS IN CLOSING ALL RELATED JOINT PRODUCT */
      /* WORK ORDERS                                  */
      if jp then
      do on endkey undo setd, retry:
         setb:
         do on error undo:
            update
               rmks
               close_wo
            with frame a.
         end. /* setb */
      end.

      /*MAKE SURE THAT ALL JOINT ORDERS USE THE SAME COST SETS*/
      if close_wo and jp
      then do:

         /* All Joint WOs will close */
         {pxmsg.i &MSGNUM=6554 &ERRORLEVEL=2}
         {gprun.i ""woavgck1.p""
            "(input  wo_nbr, output undo_all)"}

         if undo_all
         then do:

            /*Cost set assign incomplete*/
            {pxmsg.i &MSGNUM=6553 &ERRORLEVEL=4}
            close_wo = no.
            next-prompt close_wo with frame a.
         end.
      end.

      do on endkey undo mainloop, retry mainloop:

         yn = yes.
         /* Display lotserials being received ? */
          {pxmsg.i &MSGNUM=359 &ERRORLEVEL=1 &CONFIRM=yn
                   &CONFIRM-TYPE='LOGICAL'}

         if yn
         then do:

            /*V8! hide frame a no-pause. */
            for each sr_wkfl
                where sr_wkfl.sr_domain = global_domain and  sr_userid = mfguser
                 and sr_lineid = ""
            no-lock with frame frm_srwkfl width 80:

               setFrameLabels(frame frm_srwkfl:handle).
               display
                  sr_site
                  sr_loc
                  sr_lotser
                  sr_ref
                  sr_qty.
            end.
         end.
      end.

       do on endkey undo mainloop, retry mainloop:
          yn = yes.
          /* Is all information correct? */
          /*V8-*/
          {pxmsg.i &MSGNUM=12 &ERRORLEVEL=1 &CONFIRM=yn
                   &CONFIRM-TYPE='LOGICAL'}
          /*V8+*/
          /*V8!
          /* IS ALL INFORMATION CORRECT? */
          {mfgmsg10.i 12 1 yn}
          */

          if yn
          then do:
             for each sr_wkfl
                fields( sr_domain sr_lineid sr_loc sr_lotser sr_qty sr_ref
                        sr_site   sr_userid)
                where sr_domain = global_domain
                and   sr_userid = mfguser
                and   sr_lineid = cline
             no-lock:

             {gprun.i ""worcat01.p""
                "(input        recid(wo_mstr),
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
                then
                   undo setd, retry setd.
             end. /* FOR EACH sr_wkfl */

             leave setd.

          end. /* IF yn THEN */
       end.
   end.

   if conv <> 1 then
   for each sr_wkfl  where sr_wkfl.sr_domain = global_domain and  sr_userid =
   mfguser
      and sr_lineid = ""
   exclusive-lock:
      sr_qty = sr_qty * conv.
   end.

   assign
      total_lotserial_qty = total_lotserial_qty * conv.
      {&WOISRC02-P-TAG7}
      wo_qty_chg = total_lotserial_qty.
      wo_rjct_chg = reject_qty * reject_conv.

end.
