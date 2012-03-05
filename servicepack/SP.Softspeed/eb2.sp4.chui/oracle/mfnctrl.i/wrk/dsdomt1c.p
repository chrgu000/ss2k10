/* dsdomt1c.p - DISTRIBUTION ORDER WORKBENCH SUBROUTINE                       */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.8.1.18 $                                                      */
/*                                                                            */
/* REVISION: 7.0      LAST MODIFIED: 06/01/92   BY: emb *F611*                */
/* REVISION: 7.0      LAST MODIFIED: 07/12/92   BY: emb *F758*                */
/* REVISION: 7.0      LAST MODIFIED: 07/13/92   BY: emb *F810*                */
/* REVISION: 7.0      LAST MODIFIED: 09/02/92   BY: emb *F868*                */
/* REVISION: 7.3      LAST MODIFIED: 09/27/93   BY: jcd *G247*                */
/* REVISION: 7.3      LAST MODIFIED: 05/11/93   BY: emb *G938*                */
/* REVISION: 7.3      LAST MODIFIED: 12/13/93   BY: pxd *GH96*                */
/* REVISION: 7.3      LAST MODIFIED: 12/15/93   BY: pxd *GI03*                */
/* REVISION: 7.3      LAST MODIFIED: 02/24/94   BY: emb *GI98*                */
/* REVISION: 7.3      LAST MODIFIED: 08/30/94   BY: rxm *GL46*                */
/* REVISION: 7.3      LAST MODIFIED: 10/27/94   BY: ame *FS98*                */
/* REVISION: 7.3      LAST MODIFIED: 03/29/95   BY: dzn *F0PN*                */
/* REVISION: 7.3      LAST MODIFIED: 11/16/95   BY: qzl *G1DK*                */
/* REVISION: 7.3      LAST MODIFIED: 02/26/97   BY: *G2L5* Murli Shastri      */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* Annasaheb Rahane   */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/14/98   BY: *K1XQ* Thomas Fernandes   */
/* REVISION: 9.1      LAST MODIFIED: 05/28/99   BY: *J3GH* G.Latha            */
/* REVISION: 9.1      LAST MODIFIED: 12/28/99   BY: *J3NC* Rajesh Kini        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* Jacolyn Neder      */
/* REVISION: 9.1      LAST MODIFIED: 09/07/00   BY: *N0MX* Jean Miller        */
/* REVISION: 9.1      LAST MODIFIED: 11/06/00   BY: *N0TN* Jean Miller        */
/* REVISION: 9.1      LAST MODIFIED: 09/21/00   BY: *N0W6* BalbeerS Rajput    */
/* Revision: 1.8.1.10    BY: Steve Nugent         DATE: 10/15/01  ECO: *P004* */
/* Revision: 1.8.1.14    BY: Robin McCarthy       DATE: 06/16/02  ECO: *P08P* */
/* Revision: 1.8.1.16    BY: Robin McCarthy       DATE: 07/03/02  ECO: *P08Q* */
/* Revision: 1.8.1.17    BY: Samir Bavkar         DATE: 07/07/02  ECO: *P0B0* */
/* $Revision: 1.8.1.18 $ BY: Robin McCarthy       DATE: 07/15/02  ECO: *P0BJ* */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*                                                                        */
/*V8:ConvertMode=Maintenance                                              */
/**************************************************************************/

{mfdeclre.i}
{cxcustom.i "DSDOMT1C.P"}
{gplabel.i}    /* EXTERNAL LABEL INCLUDE */
{apconsdf.i}   /* PRE-PROCESSOR CONSTANTS FOR LOGISTICS ACCOUNTING */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE dsdomt1c_p_1 "Cube"
/* MaxLen: Comment: */

&SCOPED-DEFINE dsdomt1c_p_2 "Comments"
/* MaxLen: Comment: */

/* MaxLen: Comment: */

&SCOPED-DEFINE dsdomt1c_p_4 "Target Cube"
/* MaxLen: Comment: */

&SCOPED-DEFINE dsdomt1c_p_5 "Ship-From"
/* MaxLen: Comment: */

&SCOPED-DEFINE dsdomt1c_p_6 "Target Weight"
/* MaxLen: Comment: */

&SCOPED-DEFINE dsdomt1c_p_7 "Weight"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define input parameter src_site like ds_shipsite.
define input parameter rec_site like ds_site.
define input parameter trans_id like ds_trans_id.
define input parameter shipdate like ds_shipdate.

define new shared variable first-index as integer no-undo.
define new shared variable last-index as integer.
define new shared variable first-time as logical initial yes no-undo.
define new shared variable qty_to_all like wod_qty_all.
define new shared variable weight_um like tm_weight_um.
define new shared variable cube_um like tm_cube_um.
define new shared variable del-yn like mfc_logical.
define new shared variable dss_recno as recid.
define new shared variable new_order like mfc_logical initial no.
define new shared variable cmtindx like dss_cmtindx.
define new shared variable ds_recno as recid.
define new shared variable ds_db like dc_name.
define new shared variable undo-all like mfc_logical.
define new shared variable target_weight like tm_maxweight
   label {&dsdomt1c_p_6}.
define new shared variable target_cube   like tm_maxcube
   label {&dsdomt1c_p_4}.
define new shared variable calc_fr like mfc_logical label "Calculate Freight"
   no-undo.
define new shared variable disp_fr like mfc_logical label "Display Weight"
   no-undo.
define new shared variable rndmthd like rnd_rnd_mthd.
define new shared variable undo_dsdomtp    like mfc_logical no-undo.
define new shared variable freight_ok      like mfc_logical no-undo.

define shared variable backord as logical.
define shared variable found as integer no-undo.
define shared variable allocate like mfc_logical.

define variable temp-recno as recid no-undo.
define variable temp-sort as character no-undo.
define variable ii as integer.
define variable jj as integer.
define variable kk as integer.
define variable ds-order-cat like ds_order_category no-undo.
define variable new-rec as logical initial no no-undo.
define variable totallqty like wod_qty_all.
define variable totpkqty like wod_qty_pick.
define variable open_qty like ds_qty_ord.
define variable site like ds_site.
define variable weight_conv like um_conv.
define variable cube_conv like um_conv.
define variable i as integer.
define variable cum_weight like pt_ship_wt column-label {&dsdomt1c_p_7}
   no-undo.
define variable cum_cube like pt_size column-label {&dsdomt1c_p_1}.
define variable item_count as integer.
define variable blank-char as character.
define variable donbr like dss_nbr.
define variable yn like mfc_logical initial yes.
define variable dsscmmts like drp_dcmmts label {&dsdomt1c_p_2}.
define variable comment_type like dss_lang.
define variable ds-cmmts like drp_dcmmts label {&dsdomt1c_p_2}.
define variable dssshipdate like dss_shipdate.
define variable dssduedate like dss_due_date.
define variable qadkey1 as character initial "DSDOMT01" no-undo.
define variable use-log-acctg as logical no-undo.
define variable last_dsline like ds_line no-undo.

{dsdowkf2.i "shared"}

/* TEMP TABLE tt-frcalc DEFINITION FOR CREATING PVO_MSTR, PVOD_DET */
{lafrttmp.i "new"}

define buffer temp-work1 for dsdet.
define buffer b_dsdet for ds_det.

{&DSDOMT1C-P-TAG1}
/* DISPLAY SELECTION FORM */
form
   space(1)
   dss_nbr
   dss_shipsite label {&dsdomt1c_p_5}
   dss_rec_site
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
   dss_created      colon 15 dss_rmks     colon 35
   dss_shipdate     colon 15 dss_lang     colon 35
   dss_due_date     colon 15 dsscmmts     colon 35
   skip(1)
   dss_po_nbr       colon 15
   dss_shipvia      colon 52
   dss_fob          colon 15
   dss_bol          colon 52
   ds-order-cat     colon 15
   skip(1)
   target_weight    colon 15
   tm_weight_um no-label no-attr-space
   tm_maxweight     colon 52
   target_cube      colon 15
   tm_cube_um no-label no-attr-space
   tm_maxcube       colon 52
with frame d side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame d:handle).

/* CHECK IF LOGISTICS ACCOUNTING IS ENABLED */
{gprun.i ""lactrl.p"" "(output use-log-acctg)"}

pause 0.

display
   src_site @ dss_shipsite
   rec_site @ dss_rec_site
with frame a.

assign
   ds-order-cat = ""
   dssshipdate = max(today,shipdate).

for each qad_wkfl exclusive-lock where qad_key1 = qadkey1 + mfguser:
   do ii = 1 to 15:
      if qad_charfld[ii] <> "" then do:
         find ds_det no-lock
            where recid(ds_det) = integer(qad_charfld[ii])
            and ds_shipsite = src_site
            and ds_site = rec_site
            and ds_trans_id = trans_id
            and ds_shipdate <= shipdate no-error.
         if available ds_det then do:
            if ds_shipdate < dssshipdate
            then do:
               assign
                  dssshipdate = ds_shipdate
                  dssduedate = ds_due_date.
            end.
         end.

         create dsdet.
         assign
            dsrecno = integer(qad_charfld[ii])
            dsqty_chg = qad_decfld[ii]
            dsbackord = backord.
      end.
   end.
   delete qad_wkfl.
end.

{gprun.i ""dsdate04.p""
   "(src_site,rec_site,trans_id,
          input-output dssshipdate, output dssduedate)"}

display
   today @ dss_created
   dssshipdate @ dss_shipdate
   dssduedate @ dss_due_date
with frame d.

assign
   target_weight = 0
   target_cube = 0
   weight_um = ""
   cube_um = "".

find tm_mstr no-lock where tm_code = trans_id no-error.
if available tm_mstr then do:
   display
      tm_maxweight
      tm_weight_um
      tm_maxcube
      tm_cube_um
   with frame d.

   assign
      cube_um = tm_cube_um
      weight_um = tm_weight_um
      target_weight = tm_maxweight
      target_cube = tm_maxcube.
end.

display
  trans_id @ dss_shipvia
   target_weight when (target_weight <> 0)
   target_cube when (target_cube <> 0)
with frame d.

mainloop:
repeat with frame a:

   clear frame freight_data all.
   hide frame  freight_data no-pause.

   do transaction on error undo, retry:

      prompt-for dss_nbr with frame a
      editing:

         if frame-field = "dss_nbr" then do:
            /* FIND NEXT/PREVIOUS  RECORD */
            {mfnp.i dss_mstr dss_nbr dss_nbr dss_nbr dss_nbr dss_nbr}

            if recno <> ? then do:

               {&DSDOMT1C-P-TAG2}
               display dss_nbr dss_rec_site dss_shipsite with frame a.

               for first ds_det where ds_nbr = dss_nbr no-lock:
               end.
               if available ds_det then ds-order-cat = ds_order_category.
               else ds-order-cat = "".

               display dss_created dss_shipdate dss_due_date dss_po_nbr
                  dss_fob dss_shipvia dss_rmks dsscmmts dss_lang
                  dss_bol
                  ds-order-cat
               with frame d.
               {&DSDOMT1C-P-TAG3}

               if dss_cmtindx <> 0 then display true @ dsscmmts with frame d.
            end.
         end.
         else do:
            readkey.
            apply lastkey.
         end.
      end.

      if input dss_nbr = "" then do:
         find first drp_ctrl no-lock no-error.
         if not available drp_ctrl or not drp_auto_nbr then undo, retry.

         {mfnctrl.i drp_ctrl drp_nbr dss_mstr dss_nbr donbr}
      end.
      if input dss_nbr <> donbr then first-time = yes.
      if input dss_nbr <> "" then donbr = input dss_nbr.
      assign new-rec = no.
   end.  /* TRANSACTION */

   do transaction on error undo, retry:

      find dss_mstr exclusive-lock using dss_nbr
         where dss_shipsite = src_site
         and dss_rec_site = rec_site
         no-error.
      if available dss_mstr then do:
         for first ds_det where ds_nbr = dss_nbr no-lock:
         end.
         if available ds_det then ds-order-cat = ds_order_category.
      end. /* IF AVAILABLE dss_mstr */
      if not available dss_mstr then do:

         if can-find (dss_mstr where dss_nbr = input dss_nbr
            and dss_shipsite = src_site) then do:
            {pxmsg.i &MSGNUM=1616 &ERRORLEVEL=3}
            /* Order number already exists for different ship-to */
            undo mainloop, retry mainloop.
         end.

         {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}

         find first drp_ctrl no-lock no-error.
         dsscmmts = drp_dcmmts.

         create dss_mstr.
         assign dss_nbr = donbr
            dss_shipsite = src_site
            dss_rec_site = rec_site
            dss_created = today
            dss_shipdate = dssshipdate
            dss_due_date = dssduedate
            dss_shipvia = trans_id
            new_order = true
            first-time = yes
            new-rec = yes.
      end.
      else do:
         if dss_cmtindx <> 0 then dsscmmts = yes.
         else dsscmmts = no.
      end.

      recno = recid(dss_mstr).
      dss_recno = recid(dss_mstr).

      {&DSDOMT1C-P-TAG4}
      display  dss_nbr dss_shipsite dss_rec_site
      with frame a.

      assign dss_shipsite.
      global_addr = dss_shipsite.

      order-header:
      do on error undo, retry with frame d:

         ststatus = stline[2].
         status input ststatus.
         del-yn = no.

         display dss_created dss_shipdate dss_due_date dss_po_nbr
            dss_fob dss_shipvia dss_rmks dss_lang dsscmmts
            dss_bol
            ds-order-cat
         with frame d.
         {&DSDOMT1C-P-TAG5}

         setb:
         do on error undo, retry:
            {&DSDOMT1C-P-TAG6}
            set dss_created dss_shipdate dss_due_date
               dss_rmks dss_lang dsscmmts
               dss_po_nbr dss_fob dss_shipvia
               dss_bol
               ds-order-cat
               target_weight target_cube
               go-on ("F5" "CTRL-D").
            {&DSDOMT1C-P-TAG7}

            /* DELETE */
            if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
            then do:

               del-yn = yes.
               {mfmsg01.i 11 1 del-yn}
               if not del-yn then undo, retry.
            end.
            if del-yn then do:

               /*** Delete Order ***/
               for each ds_det
                     exclusive-lock use-index ds_nbr
                     where ds_nbr = dss_nbr
                     and ds_shipsite = dss_shipsite
                     and ds_site = dss_rec_site:

                  /* UPDATE dsd_det RECORD FOR REQUESTING SITE */
                  assign
                     ds_nbr = ""
                     ds_line = 0
                     ds_recno = recid(ds_det)
                     ds_db = global_db
                     undo-all = true.

                  {gprun.i ""dsdmmtv1.p""}
                  if undo-all then undo.

               end.

               for each cmt_det
                     exclusive-lock
                     where cmt_indx = dss_cmtindx:
                  delete cmt_det.
               end.

               delete dss_mstr.

               leave mainloop.
            end.
            else do:

               if dss_shipdate = ? and dss_due_date = ? then do:
                  dss_shipdate = today.

                  {gprun.i ""dsdate04.p""
                     "(dss_shipsite,dss_rec_site,dss_shipvia,
                       input-output dss_shipdate, output dss_due_date)"}
               end.

               if dss_due_date = ? and dss_shipdate <> ? then do:
                  {gprun.i ""dsdate03.p""
                     "(dss_shipsite,dss_rec_site,dss_shipvia,
                       blank-char,dss_shipdate,
                       output dss_due_date)"}
               end.

               if dss_shipdate = ? and dss_due_date <> ? then do:
                  {gprun.i ""dsdate02.p""
                     "(dss_shipsite,dss_rec_site,dss_shipvia,
                       blank-char,dss_due_date,
                       input-output dss_shipdate)"}

               end.
               display dss_shipdate dss_due_date.
               pause 0.
            end.

            /* VALIDATE ds_order_category AGAINST GENERALIZED CODES */
            if ds-order-cat <> "" then do:
               if not ({gpcode.v ds-order-cat "line_category"}) then do:
                  {pxmsg.i &MSGNUM=716 &ERRORLEVEL=3}
                  /* VALUE MUST EXIST IN GENERALIZED CODES */
                  next-prompt ds-order-cat with frame d.
                  undo, retry.
               end. /* IF NOT gpcode.v ds-order-cat */
            end. /* IF ds-order-cat <> "" */

         end. /*setb*/
      end. /*order header*/

      /* COMMENTS */
      global_lang = dss_lang.
      global_type = "".
      if dsscmmts then do:
         cmtindx = dss_cmtindx.
         global_ref = dss_rec_site.
         {gprun.i ""gpcmmt01.p"" "(input ""dss_mstr"")"}
         dss_cmtindx = cmtindx.
      end.

      if use-log-acctg then do:
         hide frame d no-pause.

         assign
            calc_fr = true
            disp_fr = true
            undo_dsdomtp = true.

         /* PROMPT FOR FREIGHT DATA */
         {gprunmo.i &module = "LA" &program = "dsdomtp.p"
                    &param  = """(input recid(dss_mstr),
                                 input true)"""}

         if undo_dsdomtp then
            undo, retry.
      end. /* IF use-log-acctg */

   end.   /* TRANSACTION */

   do transaction:
      hide frame d.

      {gprun.i ""dsdomt1d.p""
         "(dss_recno,shipdate,trans_id,output undo-all)"}

      if undo-all  then do:
         if new-rec and not can-find (first ds_det where ds_nbr = dss_nbr) then
            delete dss_mstr.
         leave mainloop.
         undo, leave mainloop.
      end.

   end.

   last_dsline = 0.

   for each dsdet
         where dsqty_chg > 0,
         each ds_det exclusive-lock where recid(ds_det) = dsrecno
         and ds_shipsite = src_site
         and ds_site = rec_site
         and ds_trans_id = trans_id:

      ds_qty_chg = dsqty_chg.

      /* Create backorder intersite request for requests
       * confirmed in workbench for less than requested quantity */
      if ds_qty_ord > ds_qty_chg + ds_qty_ship
         and dsbackord then do:
         assign
            ds_recno = recid(ds_det)
            undo-all = true.

         {gprun.i ""dsdomt1f.p""}

         if undo-all then undo.

         ds_qty_ord = min(ds_qty_ord,ds_qty_chg + ds_qty_ship).
      end.

      ds_order_category = ds-order-cat.

      if ds_qty_chg <> 0 then do:
         do for b_dsdet:
            for last b_dsdet fields(ds_nbr ds_shipsite ds_line)
            where b_dsdet.ds_nbr = dss_nbr
            and b_dsdet.ds_shipsite = dss_shipsite
            and b_dsdet.ds_line = last_dsline
            no-lock
            use-index ds_nbr:
               last_dsline = b_dsdet.ds_line + 1.
            end.

            if not available b_dsdet then
               last_dsline = 1.
         end. /* DO FOR b_dsdet */

         assign
            ds_nbr      = dss_nbr
            ds_line     = last_dsline
            ds_fr_list  = dss_fr_list
            ds_qty_conf = ds_qty_chg + ds_qty_ship.

         for first pt_mstr
            fields (pt_desc1 pt_um pt_loc pt_fr_class
                    pt_ship_wt pt_ship_wt_um)
            where pt_part = ds_part no-lock:
         end.

         /* INITIALIZE FREIGHT VALUES */
         if available pt_mstr then do:
            assign
               ds_fr_class = pt_fr_class
               ds_fr_wt_um = pt_ship_wt_um.

            if calc_fr then
               ds_fr_wt = pt_ship_wt.
         end. /* IF AVAILABLE pt_mstr */

      end. /* IF ds_qty_chg <> 0  */

      else
         assign
            ds_line = 0
            ds_nbr = "".

      if allocate
         and ds_qty_chg > 0
      then do:
         assign
            totpkqty = 0
            totallqty = 0.

         for each lad_det
               no-lock
               where lad_dataset = "ds_det"
               and lad_nbr = ds_req_nbr
               and lad_line = ds_site
               and lad_part = ds_part
               and lad_site = ds_shipsite:
            totallqty = totallqty + lad_qty_all.
            totpkqty = totpkqty + lad_qty_pick.
         end.

         /* TO CALCULATE qty_to_all CORRECTLY WHEN PICKED QUANTITY EXISTS */
         qty_to_all = max(ds_qty_conf - max(totallqty + totpkqty,0),0).

         if qty_to_all > 0
         then do:
            ds_recno = recid(ds_det).
            {gprun.i ""dspkall.p""}
         end.
      end.

      if ds_qty_ord >= 0 then
         open_qty = max(ds_qty_conf - max(ds_qty_ship,0),0).
      else
         open_qty = min(ds_qty_conf - min(ds_qty_ship,0),0).

      if index("PFE",ds_status) <> 0
         and ds_qty_chg <> 0
         then ds_status = "A".
      if ds_qty_chg = 0 then ds_status = "E".

      if ds_status = "C" then open_qty = 0.

      /* Changed pre-processor to Term */
      {mfmrw.i "ds_det" ds_part ds_req_nbr ds_shipsite
         ds_site ? ds_shipdate open_qty "DEMAND"
         INTERSITE_DEMAND ds_shipsite}

      /* UPDATE dsd_det RECORD FOR REQUESTING SITE */
      assign
         ds_recno = recid(ds_det)
         ds_db = global_db
         undo-all = true.

      {gprun.i ""dsdmmtv1.p""}
      if undo-all then undo.
      {&DSDOMT1C-P-TAG8}

   end. /* FOR EACH dsdet */

   if use-log-acctg      and
      dss_fr_list  <> "" and
      dss_fr_terms <> "" and
      can-find (first ds_det where ds_nbr = dss_nbr and ds_fr_list <> "" )
   then do transaction on error undo, retry:

      for first ft_mstr
         fields (ft_lc_charge ft_accrual_level)
         where ft_terms = dss_fr_terms
        no-lock:

         if (ft_accrual_level = {&LEVEL_Shipment} or
             ft_accrual_level = {&LEVEL_Line})
         then do:
            /* DISPLAY LOGISTICS CHARGE CODE DETAIL */
            {gprunmo.i  &module  = "LA" &program = "laosupp.p"
                        &param   = """(input 'ADD',
                                       input '{&TYPE_DO}',
                                       input dss_nbr,
                                       input dss_shipsite,
                                       input ft_lc_charge,
                                       input ft_accrual_level,
                                       input yes,
                                       input yes)"""}
         end. /* IF ft_accrual_level */
      end. /* FOR FIRST ft_mstr */

      /* FREIGHT CALCULATION */
      {gprunmo.i  &module = "LA" &program = "dsfrcalc.p"
                  &param  = """(input dss_recno)"""}

      /* CREATE TAX RECORDS FOR FREIGHT ACCRUAL */
      {gprunmo.i  &module = "LA" &program = "lafrtax.p"
                  &param  = """(input dss_shipsite,
                                input '{&TYPE_DO}',
                                input (if dss_due_date <> ? then
                                          dss_due_date
                                       else dss_created),
                                input (if dss_due_date <> ? then
                                          dss_due_date
                                       else dss_created),
                                input base_curr,
                                input 1,
                                input 1,
                                input ' ',  /* EX_RATE_TYPE */
                                input 0,    /* EXRU_SEQ */
                                input no)"""}

   end. /* IF use-log-acctg */

   if new-rec and not can-find (first ds_det where ds_nbr = dss_nbr) then
   do transaction:

      if use-log-acctg then do:
         /* DELETE lacd_det RECORD FOR THIS DO */
         {gprunmo.i &module = "LA" &program = "laosupp.p"
                    &param = """(input 'DELETE',
                                 input '{&TYPE_DO}',
                                 input dss_nbr,
                                 input ' ',
                                 input ' ',
                                 input ' ',
                                 input no,
                                 input no)"""}
      end. /* IF use-log-acctg */

      delete dss_mstr.
   end.

   leave.
end. /* mainloop */

hide frame d.
hide frame a.

status input.
