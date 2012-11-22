/* apvomth.p - AP VOUCHER MAINTENANCE Tax Calc. and Line Distribution         */
/* Copyright 1986-2006 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.8.2.29.1.1 $                                                              */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.4            CREATED: 07/13/93            BY: wep *H037*       */
/*                         MODIFIED: 09/29/93            BY: bcm *H143*       */
/*                                   11/29/93            BY: bcm *H244*       */
/*                                   03/24/94            BY: bcm *H303*       */
/*                                   06/14/94            BY: bcm *H383*       */
/*                                   09/08/94            BY: bcm *H509*       */
/*                                   12/02/94            BY: bcm *H606*       */
/*                                   04/20/95            by: srk *H0CG*       */
/* REVISION: 8.5     LAST MODIFIED:  10/12/95            by: mwd *J053*       */
/*                                   04/19/96  BY: *J0JP* Andrew Wasilczuk    */
/* REVISION: 8.6     LAST MODIFIED:  11/25/96            by: jzw *K01X*       */
/* REVISION: 8.6     LAST MODIFIED:  10/08/97  BY: *K0JV* Surendra Kumar      */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 07/23/98   BY: *L03K* Jeff Wootton       */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas  */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* Pre-86E commented code removed, view in archive revision 1.7               */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Murali Ayyagari    */
/* REVISION: 9.1      LAST MODIFIED: 02/24/00   BY: *M0K0* Ranjit Jain        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn                */
/* REVISION: 9.1      LAST MODIFIED: 09/27/00   BY: *J3Q9* Rajesh Lokre       */
/* REVISION: 9.1      LAST MODIFIED: 01/10/01   BY: *N0W0* Ed van de Gevel    */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.8.2.10       BY: Mamata samant     DATE: 03/25/02  ECO: *P04F* */
/* Revision: 1.8.2.11       BY: Ellen Borden      DATE: 04/17/02  ECO: *P043* */
/* Revision: 1.8.2.13     BY: Jean Miller         DATE: 05/22/02  ECO: *P074* */
/* Revision: 1.8.2.14     BY: Samir Bavkar        DATE: 05/14/02  ECO: *P04G* */
/* Revision: 1.8.2.15     BY: Samir Bavkar        DATE: 08/15/02  ECO: *P09K* */
/* Revision: 1.8.2.16     BY: Gnanasekar          DATE: 09/11/02  ECO: *N1PG* */
/* Revision: 1.8.2.18     BY: Jyoti Thatte        DATE: 02/21/03  ECO: *P0MX* */
/* Revision: 1.8.2.19     BY: Orawan S.           DATE: 04/21/03  ECO: *P0Q8* */
/* Revision: 1.8.2.20     BY: Orawan S.           DATE: 05/07/03  ECO: *P0RF* */
/* Revision: 1.8.2.22     BY: Paul Donnelly (SB)  DATE: 06/26/03  ECO: *Q00B* */
/* Revision: 1.8.2.23     BY: Jean Miller         DATE: 09/26/03  ECO: *Q03S* */
/* Revision: 1.8.2.28           BY: Rajaneesh S.        DATE: 01/08/04  ECO: *P1GK* */
/* Revision: 1.8.2.29  BY: Steve Nugent  DATE: 07/26/05 ECO: *P2PJ* */
/* $Revision: 1.8.2.29.1.1 $   BY: Ed van de Gevel  DATE: 08/29/06  ECO: *P53P* */
/*-Revision end---------------------------------------------------------------*/
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SOME OF THIS LOGIC ORIGINALLY EXISTED IN PROGRAM APVOMTB.P.  THIS LOGIC
   CONTROLS THE EDITING AND CALCULATION/RECALCULATION OF TAXES FOR THE
   VOD_DET RECORDS. THIS PROGRAM PROCESSES FOR THE NEW TAX MANAGEMENT ONLY.*/

{mfdeclre.i}
/* EXTERNAL LABEL INCLUDE */
{gplabel.i}
{cxcustom.i "APVOMTH.P"}
{apconsdf.i}

define new shared variable undo_txdist like mfc_logical.
define new shared variable no_taxrecs  like mfc_logical.
define new shared variable gtmconv     like mfc_logical no-undo.
define new shared variable l_txchg     like mfc_logical.

/* l_txchg IS SET TO TRUE IN TXEDIT.P WHEN TAXES ARE BEING EDITED  */
/* AND NOT JUST VIEWED IN DR/CR MEMO MAINTENANCE                   */
define shared variable ap_recno     as   recid.
define shared variable vo_recno     as   recid.
define shared variable vd_recno     as   recid.
define shared variable ba_recno     as   recid.
define shared variable vod_recno    as   recid.
define shared variable base_det_amt like glt_amt.
define shared variable base_amt     like ap_amt.
define shared variable curr_amt     like glt_curr_amt.
define shared variable aptotal      like ap_amt      label "Control".
define shared variable undo_all     like mfc_logical.
define shared variable jrnl         like glt_ref.
define shared variable tax_flag     like mfc_logical.
define shared variable recalc_tax   like mfc_logical initial true.
define shared variable tax_tr_type  like tx2d_tr_type.
define shared variable rndmthd      like rnd_rnd_mthd.
define shared variable vod_amt_fmt  as   character.
define shared variable vchr_logistics_chrgs  like mfc_logical
       label "Voucher Logistics Charges" no-undo.
define shared variable new_vchr like mfc_logical.
define shared variable l_flag   like mfc_logical no-undo.


define variable last_ln       like vod_ln       no-undo.
define variable tax_nbr       like tx2d_nbr     no-undo.
define variable tax_lines     like tx2d_line    no-undo initial 0.
define variable tax_env       like txed_tax_env no-undo.
define variable tax_total     like tx2d_totamt  no-undo.
define variable looplabel     as   character    no-undo.
define variable tax_edit      like mfc_logical  no-undo.
define variable recalc_frame  like mfc_logical  no-undo.
define variable edit_frame    like mfc_logical  no-undo.
define variable undo_edittx   like mfc_logical  no-undo.
define variable undo_recalctx like mfc_logical  no-undo.
define variable recalc_flg    like mfc_logical  no-undo.
define variable edit_flg      like mfc_logical  no-undo.
define variable tax-edited    like mfc_logical  no-undo.
define variable tax-prompt    like mfc_logical  no-undo.
define variable rcpt_tr_type  like tx2d_tr_type no-undo.

{&APVOMTH-P-TAG1}

{txcalvar.i}

define new shared frame tax_dist.

/* DEFINE SHARED CURRENCY DEPENDENT FORMATTING VARIABLES */
{apcurvar.i}
{txcurvar.i "NEW"}

define shared frame c.

{&APVOMTH-P-TAG9}
/* DEFINE FORM TO CAPTURE EDIT AND RECALC FLAGS, */
/* USED ONLY WHEN UPDATING EXISTING VOUCHERS     */
form
   recalc_tax     colon 22 label "Recalculate Tax"
   tax_edit       colon 22 label "View/Edit Tax Detail"
   space(2)
with frame recalc_tax overlay centered
side-labels attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame recalc_tax:handle).

/* DEFINE FORM TO DISPLAY TAX DISTRIBUTION */
{apvofmtx.i}
/* DEFINE SHARED FRAME C FOR CONTROL TOTALS*/
{apvofmc.i}

for first ap_mstr
   fields(ap_domain ap_amt ap_base_amt ap_curr ap_ref)
   where recid(ap_mstr) = ap_recno
no-lock: end.

for first vo_mstr
   fields (vo_domain vo_curr vo_ex_rate vo_ex_rate2
           vo_ex_ratetype vo_ref vo_tax_date vo_tax_env)
   where recid(vo_mstr) = vo_recno
no-lock: end.

for first vd_mstr
   where recid(vd_mstr) = vd_recno
no-lock: end.

find ba_mstr where recid(ba_mstr) = ba_recno exclusive-lock no-error.

/* NOTE THESE FORMATS ARE NOT ACTUALLY USED UNTIL CALLED PROGRAM  */
/* APVOMTI.P (WITHIN REPEAT LOOP TXEDITCALC)                      */
assign
   vod_amt_fmt = vod_amt:format in frame tax_dist
   ap_amt_fmt  = ap_amt:format  in frame c.

{gprun.i ""gpcurfmt.p""
   "(input-output vod_amt_fmt,
     input rndmthd)"}

{gprun.i ""gpcurfmt.p""
   "(input-output  ap_amt_fmt,
     input rndmthd)"}

/* LOOP TO PERFORM NEW TAX MANAGEMENT EVENTS ON DETAIL LINE ITEMS.
   TWO FLAGS ARE USED TO CONTROL THE FOLLOWING POP-UP WINDOWS THAT ARE
   USED TO DETERMINE THE PROCESSING IF A NEW VOUCHER IS BEING ADDED,
   THE USER HAS THE OPPORTUNITY OF VIEWING THE TAX DETAIL; TAX LINES WILL
   AUTOMATICALLY BE CALCULATED.  IF THE EXISTING VOUCHER IS BEING UPDATED,
   THE USER HAS THE OPPORTUNITY OF RECALCULATING TAXES AND TO VIEW THE
   TAX DETAIL.

   CHECK FOR EXISTING TAX LINES IN VOD.  IF NO RECORDS ARE FOUND, THIS MEANS
   IT IS A NEW VOUCHER.  OTHERWISE, THE EXISTING VOUCHER IS BEING UPDATED.
*/

/* IF THIS IS LOGISTICS CHARGE VOUCHER AND THE USER SETS THE   */
/* vchr_logistics_chrgs FLAG TO FALSE THEN LEAVE THIS ROUTINE  */

if not new_vchr then do:

   for first vph_hist
      fields(vph_domain vph_pvo_id)
       where vph_domain = global_domain and
             vph_ref = vo_ref
       and can-find(first pvo_mstr where pvo_domain = global_domain
                                     and pvo_id = vph_pvo_id
                                     and pvo_lc_charge <> "")
   no-lock: end.

   if available vph_hist and (not vchr_logistics_chrgs) then
      return.

end. /* IF NOT NEW_VCHR */


for first vod_det
   fields(vod_domain vod_acct vod_amt vod_base_amt vod_cc vod_desc vod_entity
          vod_project vod_ref vod_sub vod_tax)
    where vod_domain = global_domain
      and vod_ref = vo_ref
      and vod_tax = "t"
no-lock: end.

if available vod_det then
   recalc_flg = true.
else
   assign
      edit_flg   = true  
      tax-edited = no
      tax-prompt = yes.

/* INITIALIZE TAX FIELDS FOR CALLING TAX PROGRAMS */
tax_nbr = "*".       /* WILDCARD - FOR ALL RECEIPTS */

/* BEGIN LOOP */
txeditcalc:
repeat:

   /* IF l_flag IS true RETURN TO THE CALLING */
   /* PROGRAM WITHOUT PROCEEDING FURTHER      */
   if l_flag = true then
      return.

   /* IF UPDATING A VOUCHER - TAX DETAIL RECORDS EXIST */
   /* THIS POP-UP IS ONLY PERFORMED THE FIRST TIME     */
   {&APVOMTH-P-TAG2}
   if recalc_flg
   then do:
      {&APVOMTH-P-TAG3}
      /*DISPLAY POP-UP TO OBTAIN RECALC OR VIEW/EDIT TAX INFO*/
      undo_recalctx = true.

      if batchrun then
         l_flag = true.

      recalc:
      do on endkey undo, leave recalc:

         {&APVOMTH-P-TAG10}
         update
            recalc_tax
            tax_edit
         with frame recalc_tax.

         undo_recalctx = false.

         /* IF NO ERROR IS ENCOUNTERED SET l_flag */
         /* TO false IN BATCH MODE                */
         if batchrun then
            l_flag = false.

      end. /* RECALC */

      hide frame recalc_tax no-pause.

      if undo_recalctx then
         return.

      /*IF THE COMBINATION OF RECALC = "YES" AND VIEW/EDIT = "NO*/
      /*SET EDIT_FLG SO MESSAGE WILL BE DISPLAYED AFTER RECALC  */
      if recalc_tax and
         tax_edit = no 
      then
         edit_flg = true.

      recalc_flg = false.

   end. /* IF recalc_flg */
   {&APVOMTH-P-TAG14}

   /* RECALULATE TAXES.  THIS IS DONE FOR "NEW VOUCHERS" AND */
   /* FOR EXISTING VOUCHERS IF THE RECALC_TAX FLAG IS TRUE   */
   if recalc_tax
   then do:
      {&APVOMTH-P-TAG4}

      /* DELETE THE OLD TAX VOD LINES */
      {apdeltx.i &looplabel = "deltax"}
      {&APVOMTH-P-TAG5}

      {&APVOMTH-P-TAG11}
      /* CHECK PREVIOUS DETAIL FOR EDITED VALUES */
      for first tx2d_det
         fields(tx2d_domain tx2d_edited tx2d_ref tx2d_tr_type)
         where tx2d_domain = global_domain
           and tx2d_ref = vo_ref
           and tx2d_tr_type = tax_tr_type
           and tx2d_edited
      no-lock: end.

      if available tx2d_det
      then do:
         /* PREVIOUS TAX VALUES EDITED.  RECALCULATE */
         {pxmsg.i &MSGNUM=917 &ERRORLEVEL=2 &CONFIRM=recalc_tax}
      end. /* IF AVAILABLE tx2d_det */

      if recalc_tax
      then do:
         /* DELETE TX2D_DET RECORDS */
         /* NOTE nbr FIELD BLANK UNTIL I KNOW HOW TO USE IT */
         /* ADDED TWO PARAMETERS TO TXCALC.P,            */
         /* INPUT PARAMETER VQ-POST                      */
         /* AND OUTPUT PARAMETER RESULT-STATUS.          */
         /* THE POST FLAG IS SET TO 'NO'                 */
         /* BECAUSE WE ARE NOT CREATING QUANTUM REGISTER */
         /* RECORDS FROM THIS CALL TO TXCALC.P           */
         {gprun.i ""txcalc.p""
            "(input  tax_tr_type,
              input  vo_ref,
              input  tax_nbr,
              input  tax_lines /*ALL LINES*/,
              input  no,
              output result-status)"}
      end. /* IF recalc_tax */

      if tax-prompt and
         tax-edited = no
      then do:

         if (not vchr_logistics_chrgs) then  /* IF VOUCHERING PO RECEIPTS */
         srchloop:

            for each vph_hist no-lock
               where vph_domain = global_domain
                 and vph_ref = vo_ref
                 and vph_pvo_id <> 0
                 and vph_pvod_id_line > 0,
                each pvo_mstr no-lock
               where pvo_domain = global_domain
                 and pvo_id = vph_pvo_id
                 and pvo_lc_charge   = ""
                 and pvo_internal_ref_type = {&TYPE_POReceiver}
            break by pvo_internal_ref:

               /* FIND THE PRH RECORD IF IT EXISTS */
            for each prh_hist where
                     prh_domain = global_domain and
                     prh_receiver = pvo_internal_ref
            no-lock break by prh_receiver:

               if first-of(prh_receiver)
               then do:

                  if prh_rcp_type = "R"
                  then
                     rcpt_tr_type = '25'.
                  else
                     rcpt_tr_type = '21'.

                  {gprun.i ""txedtchk.p""
                     "(input  rcpt_tr_type       /* SOURCE TR  */,
                       input  pvo_internal_ref   /* SOURCE REF */,
                       input  '*'                /* SOURCE NBR */,
                       input  0                  /* ALL LINES  */,
                       output tax-edited)" }     /* RETURN VAL */

                  if tax-edited
                  then
                     leave srchloop.

               end. /* IF FIRST-OF(pvo_internal_ref ) */
               end. /* FOR EACH prh_hist */
            end. /* SRCHLOOP */
         else  /* VOUCHERING LOGISTICS CHARGES */
            srchloopa:
            for each vph_hist no-lock  where
                     vph_domain = global_domain
                and  vph_ref = vo_ref,
                each pvo_mstr no-lock where
                     pvo_domain = global_domain
                 and pvo_id = vph_pvo_id
                 and pvo_lc_charge  <> "",
                each pvod_det no-lock where
                     pvod_domain = global_domain
                 and pvod_id = pvo_id
                 and pvod_id_line = vph_pvod_id_line:

               if pvo_internal_ref_type = {&TYPE_POReceiver} then
                  rcpt_tr_type = '27'.
               else
               if (pvo_internal_ref_type = {&TYPE_SOShipment}  or
                   pvo_internal_ref_type = {&TYPE_SOShipper}) then
                  rcpt_tr_type = '43'.
               else
               if (pvo_internal_ref_type = {&TYPE_DOShipment} or
                   pvo_internal_ref_type = {&TYPE_DOShipper}) then
                  rcpt_tr_type = '45'.

               {gprun.i ""txedtchk.p""
                  "(input  rcpt_tr_type       /* SOURCE TR  */,
                    input  string(pvo_id)     /* SOURCE REF */,
                    input  '*'                /* SOURCE NBR */,
                    input  0                  /* ALL LINES  */,
                    output tax-edited)" }     /* RETURN VAL */

               if tax-edited
               then
                  leave srchloopa.

            end. /* FOR EACH vph_hist */

         if  tax-prompt
         and tax-edited
         then do:
            tax-edited = no.
            /* COPY EDITED TAX VALUES */
            {pxmsg.i &MSGNUM=935 &ERRORLEVEL=2 &CONFIRM=tax-edited}
            tax-prompt = no.
         end. /* IF tax-prompt AND tax-edited */
      end. /* IF tax-prompt AND tax-edited = no */

      /* COPY EDITED RECORDS IF SPECIFIED BY USER */
      if tax-edited
      then do:

         if (not vchr_logistics_chrgs) then  /* IF VOUCHERING PO RECEIPTS */
         updtloop:
         for each vph_hist no-lock
            where vph_domain = global_domain
              and vph_ref = vo_ref
              and vph_pvo_id <> 0
              and vph_pvod_id_line > 0,
             each pvo_mstr no-lock
            where pvo_domain = global_domain
              and pvo_id = vph_pvo_id
              and pvo_lc_charge   = ""
              and pvo_internal_ref_type = {&TYPE_POReceiver}
         break by pvo_internal_ref:

            /* FIND THE PRH RECORD IF IT EXISTS */
            for each prh_hist where prh_domain = global_domain and
                                    prh_receiver = pvo_internal_ref
            no-lock break by prh_receiver:

               if first-of(prh_receiver)
               then do:

                  if prh_rcp_type = "R"
                  then
                     rcpt_tr_type = '25'.
                  else
                     rcpt_tr_type = '21'.

                  {gprun.i ""txedtcpy.p""
                     "(input  rcpt_tr_type       /* SOURCE TR  */,
                       input  pvo_internal_ref   /* SOURCE REF */,
                       input  '*'                /* SOURCE NBR */,
                       input  '22'               /* TARGET TR  */,
                       input  vo_ref             /* TARGET REF */,
                       input  pvo_internal_ref   /* TARGET NBR */,
                       input  0)"    }           /* ALL LINES  */

               end. /* IF FIRST-OF(pvo_internal_ref ) */

            end. /* FOR EACH prh_hist */

         end. /* UPDTLOOP */

         else  /* VOUCHERING LOGISTICS CHARGES */
         updtloopa:
         for each vph_hist no-lock
            where vph_domain = global_domain
              and vph_ref = vo_ref,
             each pvo_mstr no-lock
            where pvo_domain = global_domain
              and pvo_id = vph_pvo_id
              and pvo_lc_charge  <> "",
             each pvod_det no-lock
            where pvod_domain = global_domain
              and pvod_id = pvo_id
              and pvod_id_line = vph_pvod_id_line:

               if pvo_internal_ref_type = {&TYPE_POReceiver}
               then
                  rcpt_tr_type = '27'.
               else
               if (pvo_internal_ref_type = {&TYPE_SOShipment}  or
                   pvo_internal_ref_type = {&TYPE_SOShipper})
               then
                  rcpt_tr_type = '43'.
               else
               if (pvo_internal_ref_type = {&TYPE_DOShipment} or
                   pvo_internal_ref_type = {&TYPE_DOShipper})
               then
                  rcpt_tr_type = '45'.

               {gprun.i ""txedtcpy.p""
                  "(input  rcpt_tr_type       /* SOURCE TR  */,
                    input  string(pvo_id)     /* SOURCE REF */,
                    input  '*'                /* SOURCE NBR */,
                    input  '22'               /* TARGET TR  */,
                    input  vo_ref             /* TARGET REF */,
                    input  string(pvo_id)     /* TARGET NBR */,
                    input  0)"    }           /* ALL LINES  */

               if tax-edited then
                  leave updtloopa.

         end. /* FOR EACH vph_hist */

      end. /* IF tax-edited */

      /*DON'T DISPLAY TAX DISTRIBUTION SCREEN IF THE TAX EDIT IS */
      /*GOING TO BE DISPLAYED FIRST                              */
      if tax_edit = no
      then do:
         clear frame tax_dist all no-pause.
         /* IF VOUCHERING PO RECEIPTS */
         if (not vchr_logistics_chrgs) then do:
            {gprun.i ""xxapvomti.p""}
            {&APVOMTH-P-TAG12}
         end.
         else do:
            {gprunmo.i &module="LA" &program="apvolai.p"}
         end.
         {&APVOMTH-P-TAG6}
         pause 0.

      end. /* IF tax_edit = no */

      recalc_tax = false.

   end. /*  IF recalc_tax */

   /* IF NEW VOUCHER, OR IF VIEW/EDIT MESSAGE FLAG IS SET*/
   /* DISPLAY MESSAGE TO ALLOW FOR TAX LINE VIEW/EDIT    */
   {&APVOMTH-P-TAG7}
   if edit_flg
   then do:

      {&APVOMTH-P-TAG8}
      undo_edittx = true.

      if batchrun then
         l_flag = true.

      edittx:
      do on endkey undo, leave:
         /* VIEW/EDIT TAX DETAIL */
         if batchrun then assign tax_edit = no.
         if not batchrun then do:
         		{pxmsg.i &MSGNUM=932 &ERRORLEVEL=1 &CONFIRM=tax_edit}
         end.
         /*V8!
         if tax_edit = ? then
            undo, leave.
         */
         undo_edittx = false.

         /* IF NO ERROR IS ENCOUNTERED SET */
         /* l_flag TO false IN BATCH MODE  */
         if batchrun then
            l_flag = false.

      end. /* EDITTX */

      if undo_edittx then
         return.

   end. /* IF edit_flg */

   /* TRY AND GET OUT - IF BOTH FLAGS ARE SET TO FALSE*/
   if recalc_tax = no and
      tax_edit = no
   then
      return.

   /* DISPLAY TAX EDIT DETAIL WINDOW */
   if tax_edit
   then do:

      /* ADDED vo_curr,vo_ex_ratetype,vo_ex_rate,vo_ex_rate2         */
      /* AND vo_tax_date OR today (CONDITIONALLY) AS SIXTH, SEVENTH, */
      /* EIGTH, NINTH AND TENTH INPUT PARAMETER RESPECTIVELY.        */

      {gprun.i ""txedit.p""
         "(input  tax_tr_type,
           input  vo_ref,
           input  '*',       /* ALL RECEIVERS */
           input  tax_lines, /* ALL LINES     */
           input  vo_tax_env,
           input  vo_curr,
           input  vo_ex_ratetype,
           input  vo_ex_rate,
           input  vo_ex_rate2,
           input  if vo_tax_date <> ?
                  then
                     vo_tax_date
                  else
                     today,
           output tax_total)"}

      /* CALCULATE TOTALS */
      {gprun.i ""txtotal.p""
         "(input  tax_tr_type,
           input  vo_ref,
           input  '*',       /* ALL RECEIVERS */
           input  tax_lines, /* ALL LINES     */
           output tax_total)"}

      view frame c.

      /* CREATE VOD TAX DISTRIBUTION RECORDS, DISPLAY TAX */
      /* DISTRIBUTION FORM                               */
      /* FIRST, DELETE THE OLD TAX VOD LINES             */
      {apdeltx.i &looplabel = "taxdel"}

      if (not vchr_logistics_chrgs) then do: /* IF VOUCHERING PO RECEIPTS */
         {gprun.i ""xxapvomti.p""}
         {&APVOMTH-P-TAG13}
      end.
      else do:
         {gprunmo.i  &module="LA" &program="apvolai.p"}
      end.
      pause 0.

      tax_edit = false.

   end. /* IF tax_edit */

   assign
      recalc_flg = false
      edit_flg   = true.

end. /* TXEDITCALC */
