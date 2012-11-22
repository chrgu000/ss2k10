/* apvomtb1.p - AP VOUCHER MAINTENANCE - Hold/Confirmation Panel              */
/* Copyright 1986-2008 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.7.1.16.1.1 $                                         */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.4                      CREATED: 06/26/95  by: jzw *G0Q7*       */
/* (Split out from apvomtb.p)                                                 */
/*                                   MODIFIED: 08/28/95  by: jzw *H0FN*       */
/*                                             01/02/96  by: jzs *H0J0*       */
/* REVISION: 8.5                LAST MODIFIED: 02/07/96  by: mwd *J053*       */
/*                                             01/31/97  by: bkm *H0RY*       */
/*                                             03/06/97  by: bkm *H0TC*       */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 07/23/98   BY: *L03K* Jeff Wootton       */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas  */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* Pre-86E commented code removed, view in archive revision 1.6               */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn                */
/* REVISION: 9.1      LAST MODIFIED: 09/13/00   BY: *N0W0* BalbeerS Rajput    */
/* REVISION: 9.1      LAST MODIFIED: 02/08/01   BY: *M11K* Vinod Nair         */
/* Revision: 1.7.1.7     BY: Manisha Sawant       DATE: 10/10/01  ECO: *N141* */
/* Revision: 1.7.1.8     BY: Jean Miller          DATE: 12/10/01  ECO: *P03H* */
/* Revision: 1.7.1.9     BY: Gnanasekar           DATE: 09/11/02  ECO: *N1PG* */
/* Revision: 1.7.1.10    BY: Anitha Gopal         DATE: 01/29/03  ECO: *N25J* */
/* Revision: 1.7.1.12    BY: Paul Donnelly (SB)   DATE: 06/26/03  ECO: *Q00B* */
/* Revision: 1.7.1.13    BY: Sachin Deshmukh      DATE: 10/13/04  ECO: *P2G6* */
/* Revision: 1.7.1.14    BY: Ed van de Gevel      DATE: 10/13/04  ECO: *P2KS* */
/* Revision: 1.7.1.15    BY: Pankaj Goswami       DATE: 02/15/05  ECO: *P36R* */
/* Revision: 1.7.1.16    BY: Shivanand H          DATE: 06/15/05  ECO: *P3PH* */
/* $Revision: 1.7.1.16.1.1 $ BY: Ed van de Gevel  DATE: 03/20/08 ECO: *P6P9* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{cxcustom.i "APVOMTB1.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

define shared variable base_amt     like ap_amt.
define shared variable old_amt      like ap_amt.
define shared variable new_vchr     like mfc_logical.
define shared variable ap_recno     as recid.
define shared variable vo_recno     as recid.
define shared variable vd_recno     as recid.
define shared variable old_vend     like ap_vend.
define shared variable totinvdiff   like ap_amt.
define shared variable rndmthd      like rnd_rnd_mthd.
define shared variable l_flag       like mfc_logical no-undo.
define shared variable close_pvo    like mfc_logical label "Close Line".

{&APVOMTB1-P-TAG6}
define variable apc_approv          like mfc_logical.
define variable old_confirmed       like mfc_logical.
define variable retval              as   integer.
define variable mc-error-number     like msg_nbr no-undo.
define variable rndamt              like ap_amt no-undo.
define variable l_voucher_open      like mfc_logical no-undo.

/* DEFINE SHARED CURRENCY DEPENDENT FORMATTING VARIABLES */
{apcurvar.i}

/* DEFINE VARIABLES FOR gpglef.p (GL CALENDAR VALIDATION) */
{gpglefdf.i}

form
   vo_hold_amt     colon 15
   vo_confirmed    colon 15
   vo__qad01       colon 15        label "Assigned-To"
with frame votrail side-labels width 80 no-attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame votrail:handle).

/* GET VALUE OF apc_ctrl FLAG */
find first mfc_ctrl  where mfc_ctrl.mfc_domain = global_domain and  mfc_field =
"apc_approv"
no-lock no-error.

if available mfc_ctrl then
   apc_approv = mfc_logical.


find ap_mstr where recid(ap_mstr) = ap_recno no-lock no-error.
find vo_mstr where recid(vo_mstr) = vo_recno no-lock no-error.
find vd_mstr where recid(vd_mstr) = vd_recno no-lock no-error.
{&APVOMTB1-P-TAG9}
find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock.
find first apc_ctrl  where apc_ctrl.apc_domain = global_domain no-lock.

do on endkey undo, leave:

   vo_holdamt_fmt = vo_hold_amt:format in frame votrail.
   /* SET FORMAT FOR VOUCHER HOLD AMT */
   /* NOTE RNDMTHD HAS ALREADY BEEN SET TO vo_curr RNDMTHD */
   {gprun.i ""gpcurfmt.p"" "(input-output vo_holdamt_fmt,
                             input rndmthd)"}

   {&APVOMTB1-P-TAG8}
   if vd_hold
      and vo_hold_amt <> ap_amt
   then do:
      /* Supplier on Payment Hold */
      {pxmsg.i &MSGNUM=162 &ERRORLEVEL=2}
      if vo_hold_amt = 0 then
         assign
            vo_hold_amt = ap_amt
            vo_base_hold_amt = ap_base_amt.
   end.
   else
      if totinvdiff > 0
      then do:
         /* Extended Invoice Cost greater than extended PO Cost */
         {pxmsg.i &MSGNUM=5 &ERRORLEVEL=2}
         if vo_hold_amt = 0
         then do:

            /* CONVERT FROM FOREIGN TO BASE CURRENCY */
            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input vo_curr,
                 input base_curr,
                 input vo_ex_rate,
                 input vo_ex_rate2,
                 input totinvdiff,
                 input true, /* ROUND */
                 output rndamt,
                 output mc-error-number)"}.
            if mc-error-number <> 0
            then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
            end.

            assign
               vo_hold_amt = totinvdiff
               vo_base_hold_amt = rndamt.
         end.
      end.

   {&APVOMTB1-P-TAG1}
   /* THIS VALUE (vo_holdamt_fmt) WAS SET IN CALLING PGM apvomtb.p */
   vo_hold_amt:format in frame votrail = vo_holdamt_fmt.

   {&APVOMTB1-P-TAG7}
   display
      vo_hold_amt
      vo_confirmed
      vo__qad01
   with frame votrail.

   old_confirmed = vo_confirmed.

   set-votrail:
      repeat with frame votrail:

         /* IF l_flag IS TRUE RETURN TO THE CALLING */
         /* PROCEDURE WITHOUT PROCEEDING FURTHER */
         if l_flag = true
         then
            return.

         if batchrun
         then
            l_flag = true.

         vo_hold_amt:format in frame votrail = vo_holdamt_fmt.
         /* lambert 20121105 */
         if new_vchr then vo_confirmed = no.
         /* lambert 20121105 */
         set
            vo_hold_amt
            {&APVOMTB1-P-TAG2}
            vo_confirmed   when (new_vchr)
            {&APVOMTB1-P-TAG3}
            /* ALLOW USE OF ASSIGNED-TO WHEN CONFIRMED OR UNCONFIRMED */
            vo__qad01
            go-on (F4 PF4 CTRL-E ESC END-ERROR).

         /* IF NO ERROR IS ENCOUNTERED SET */
         /* l_flag TO false IN BATCH MODE  */
         if batchrun
         then
            l_flag = false.

         if vo_hold_amt <> 0
         then do:
            {gprun.i ""gpcurval.p"" "(input vo_hold_amt,
                                      input rndmthd,
                                      output retval)"}
            if retval <> 0
            then do:

               /* IF AN ERROR IS ENCOUNTERED IN    */
               /* BATCH MODE l_flag IS SET TO true */
               if batchrun
               then
                  l_flag = true.

               next-prompt vo_hold_amt.
               undo set-votrail, retry set-votrail.
            end.
         end.

         if vo_hold_amt < 0
            and ap_amt  > 0
         then do:
            /* CANNOT BE NEG FOR POS VOUCHER */
            {pxmsg.i &MSGNUM=1244 &ERRORLEVEL=3}

            if batchrun
            then
               l_flag = true.

            next-prompt vo_hold_amt.
            undo set-votrail, retry.
         end.
         if vo_hold_amt > 0
            and ap_amt  < 0
         then do:
            /* CANNOT BE POS FOR NEG VOUCHER */
            {pxmsg.i &MSGNUM=1245 &ERRORLEVEL=3}

            if batchrun
            then
               l_flag = true.

            next-prompt vo_hold_amt.
            undo set-votrail, retry.
         end.

         /* CONVERT FROM FOREIGN TO BASE CURRENCY */
         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input vo_curr,
              input base_curr,
              input vo_ex_rate,
              input vo_ex_rate2,
              input vo_hold_amt,
              input true, /* ROUND */
              output vo_base_hold_amt,
              output mc-error-number)"}.
         if mc-error-number <> 0
         then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
         end.

         if ( (vo_hold_amt > (ap_amt - vo_applied) and ap_amt > 0)
              or (vo_hold_amt < (ap_amt - vo_applied) and ap_amt < 0) )
            and (vo_recur = no)
         then do:
            /* VOUCHER HOLD AMOUNT CHANGED TO VOUCHER TOTAL */
            {pxmsg.i &MSGNUM=2202 &ERRORLEVEL=4}

            if batchrun
            then
               l_flag = true.

            assign
               vo_hold_amt = ap_amt - vo_applied
               vo_base_hold_amt = ap_base_amt - vo_base_applied
               vo_hold_amt:format in frame votrail = vo_holdamt_fmt.

            display
               vo_hold_amt.
            next-prompt vo_hold_amt.
            undo set-votrail, retry.
         end.

         repeat:
            /* TRAP UNDO */
            if (vo_ndisc_amt > ap_amt and ap_amt > 0)
            or (vo_ndisc_amt < ap_amt and ap_amt < 0)
            then do:
               /* Voucher non-discount amount changed to voucher total */
               {pxmsg.i &MSGNUM=2203 &ERRORLEVEL=2}
               if not batchrun
               then
                  pause.
            end.
            leave.
         end.

         if (vo_ndisc_amt > ap_amt and ap_amt > 0)
            or (vo_ndisc_amt < ap_amt and ap_amt < 0)
         then
            assign
               vo_ndisc_amt = ap_amt
               vo_base_ndisc = ap_base_amt.

         /* CHECK THAT ALL INVOLVED ENTITIES HAVE OPEN GL PERIODS */
         if old_confirmed = no  /* VOUCHER WAS CREATED UNCONFIRMED */
            and vo_confirmed /* VOUCHER HAS BEEN CONFIRMED IN THIS PANEL */
            and vo_recur = no
         then do:
            /* NO GL PERIOD CHECKS WERE DONE DURING THE */
            /* CREATION EDITS, BECAUSE THE VOUCHER WAS  */
            /* UNCONFIRMED UP TO THIS POINT             */

            {&APVOMTB1-P-TAG10}
            /* VERIFY GL CALENDAR FOR AP ENTITY */
            {gpglef02.i &module = ""AP""
                        &entity = ap_entity
                        &date   = ap_effdate
                        &prompt = "vo_confirmed"
                        &frame  = "votrail"
                        &loop   = "set-votrail"}
            {&APVOMTB1-P-TAG11}
            for each vod_det
                where vod_det.vod_domain = global_domain and  vod_ref = vo_ref
            no-lock:
               /* VERIFY GL CALENDAR FOR VOUCHER DETAIL ENTITY */
               if vod_entity <> ap_entity
                  and vod_amt <> 0
               then do:
                  {&APVOMTB1-P-TAG12}
                  {gpglef02.i &module = ""AP""
                              &entity = vod_entity
                              &date   = ap_effdate
                              &prompt = "vo_confirmed"
                              &frame  = "votrail"
                              &loop   = "set-votrail"}
                  {&APVOMTB1-P-TAG13}
               end.
            end. /* FOR EACH vod_det */
         end. /* IF old_confirmed = NO */

         /* VALIDATE AUTHORIZED BY FIELD */
         /*  /* lambert 20121105 */
         if apc_approv and
            not vo_confirmed and
            {&APVOMTB1-P-TAG4}
            vo__qad01 = ""
         then do:
            {&APVOMTB1-P-TAG5}
            {pxmsg.i &MSGNUM=40 &ERRORLEVEL=3} /* BLANK NOT ALLOWED */
            if not batchrun
            then do:
               next-prompt vo__qad01.
               next set-votrail.
            end.
            else
               l_flag = true.
         end.
         if vo__qad01 <> "" and
            not can-find (first emp_mstr
                           where emp_mstr.emp_domain = global_domain and
                           emp_addr = vo__qad01)
         then do:
            /* Invalid Employee Code */
            {pxmsg.i &MSGNUM=4006 &ERRORLEVEL=3}
            if not batchrun
            then do:
               next-prompt vo__qad01.
               next set-votrail.
            end.
            else
               l_flag = true.
         end.  /* lambert 20121105 */
         */

         if vo_confirmed
            and new_vchr
         then
            vo_conf_by = global_userid.

         leave.

      end. /* set-votrail */

      /* IF l_flag IS true RETURN TO THE CALLING */
      /* PROGRAM WITHOUT PROCEEDING FURTHER      */
      if l_flag = true
      then
         return.

   /* CHECK IF MEMO IS OPEN */
   if vo_recur = no
   then do:

      /* INITIALIZING l_voucher_open */
      l_voucher_open = yes.

      if ap_amt - vo_applied <> 0
      then
         ap_open = yes.
      else do:
         if vo_applied = 0
            and ap_amt = 0
         then do:

            /* VOUCHER TOTAL = ZERO. KEEP VOUCHER */
            /* OPEN TO RE-ACCESS IT ? */
            if batchrun = no then do:
               {pxmsg.i &MSGNUM=5886
                        &ERRORLEVEL=1
                        &CONFIRM=l_voucher_open}
						end.
            ap_open = if l_voucher_open
                      then
                         yes
                      else
                         no.

         end. /* IF ap_amt = 0 */
         else
            ap_open = no.

      end. /* ELSE DO */

      /* UPDATE VENDOR BALANCE */
      if vo_confirmed
         and ( old_amt <> (ap_amt - vo_applied)
             or ap_vend <> old_vend)
      then do:
         find vd_mstr
             where vd_mstr.vd_domain = global_domain and  vd_addr = old_vend
            exclusive-lock
         no-error.
         base_amt = old_amt.
         if ap_curr <> base_curr
         then do:
            /* CONVERT FROM FOREIGN TO BASE CURRENCY */
            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input ap_curr,
                 input base_curr,
                 input ap_ex_rate,
                 input ap_ex_rate2,
                 input old_amt,
                 input true, /* ROUND */
                 output base_amt,
                 output mc-error-number)"}.
            if mc-error-number <> 0
            then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
            end.
         end.

         vd_balance = vd_balance - base_amt.
         if ap_vend <> old_vend
         then
            find vd_mstr
                where vd_mstr.vd_domain = global_domain and  vd_addr = ap_vend
            exclusive-lock
            no-error.

         assign
            base_amt = ap_base_amt - vo_base_applied
            vd_balance = vd_balance + base_amt.

      end. /* IF vo_confirmed.... */
   end. /* IF vo_recur = NO */
end. /* DO ON ENDKEY UNDO, LEAVE */

hide frame votrail no-pause.

