/* ardrmtf.p - AR DEBIT/CREDIT MEMO MAINTENANCE SUBROUTINE                  */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* $Revision: 1.15.1.17 $                                             */
/*V8:ConvertMode=Maintenance                                                */
/* REVISION: 8.5      LAST MODIFIED: 05/30/96   by: bxw                     */
/* REVISION: 8.5      LAST MODIFIED: 07/15/96   by: taf  *J0ZC*             */
/* REVISION: 8.6      LAST MODIFIED: 07/15/96   BY: bjl  *K001*             */
/* REVISION: 8.5      LAST MODIFIED: 07/29/96   BY: taf *J101*              */
/* REVISION: 8.6      LAST MODIFIED: 01/03/97   BY: *K03F*  Jeff Wootton    */
/* REVISION: 8.6      LAST MODIFIED: 01/07/97   BY: bjl *K01S*              */
/*                                   02/17/97   BY: *K01R* E. Hughart       */
/*                                   03/06/97   BY: *K06X* E. Hughart       */
/*                                   03/12/97   BY: *J1KQ* B. Milton        */
/*                                   04/17/97   BY: *J1P8* Robin McCarthy   */
/*                                   05/05/97   BY: *K0CX* E. Hughart       */
/* REVISION: 8.6      LAST MODIFIED: 07/09/97   by: *H1BQ* Irine D'mello    */
/* REVISION: 8.6      LAST MODIFIED: 11/21/97   BY: *J26T* Irine D'mello    */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan        */
/* REVISION: 8.6E     LAST MODIFIED: 06/02/98   BY: *L01K* Jaydeep Parikh    */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 10/22/99   BY: *N04P* Robert Jensen     */
/* REVISION: 9.1      LAST MODIFIED: 01/14/00   BY: *L0PK* Atul Dhatrak      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 06/16/00   BY: *L0ZN* A. Philips        */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn               */
/* REVISION: 9.1      LAST MODIFIED: 08/03/00   BY: *N0VV* Mudit Mehta       */
/* REVISION: 9.0      LAST MODIFIED: 02/13/01   BY: *N0X7* Ed van de Gevel   */
/* Old ECO marker removed, but no ECO header exists *F0PN*                   */
/* Revision: 1.15.1.13   BY: Vihang Talwalkar DATE: 10/22/01  ECO: *P01V*    */
/* Revision: 1.15.1.14   BY: Manjusha Inglay    DATE: 07/29/02  ECO: *N1P4*  */
/* $Revision: 1.15.1.17 $  BY: Orawan S.          DATE: 05/08/03  ECO: *P0RJ*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* Old ECO marker removed, but no ECO header exists *J053*                */
/* $Revision: 1.15.1.17 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00B* */
/*-Revision end---------------------------------------------------------------*/

/* SS - 20080830.1 By: Bill Jiang */
/* SS - 091014.1 By: Bill Jiang */

{mfdeclre.i}
{cxcustom.i "ARDRMTF.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE ardrmtf_p_1 "Memo Control"
/* MaxLen: Comment: */

&SCOPED-DEFINE ardrmtf_p_2 "Batch"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

{gldydef.i}
{gldynrm.i}

/* DEFINE VARIABLES FOR GPGLEF.P (GL CALENDAR VALIDATION) */
{gpglefdf.i}

/* SS - 20080830.1 - B */
DEFINE SHARED VARIABLE ref_glt LIKE glt_det.glt_ref.
DEFINE SHARED VARIABLE user1_glt LIKE glt_det.glt_user1.
/* SS - 20080830.1 - E */

define variable undo_all2             as logical no-undo.
define variable mc-error-number       like msg_nbr no-undo.
define variable l_tmp_bill            like ar_bill no-undo.

define shared variable undo_header    like mfc_logical no-undo.
define shared variable rndmthd        like rnd_rnd_mthd.
define shared variable oldcurr        like ar_curr.
define shared variable artotal_old    as character.
define shared variable artotal_fmt    as character.
define shared variable ar_amt_old     as character.
define shared variable ar_amt_fmt     as character.
define shared variable ar_sales_old   as character.
define shared variable ar_sales_fmt   as character.
define shared variable ar_recno       as recid.
define shared variable ar1_recno      as recid.
define shared variable ard_recno      as recid.
define shared variable ba_recno       as recid.
define shared variable del-yn         like mfc_logical initial no.
define shared variable do_tax         like mfc_logical.
define shared variable undo_all       like mfc_logical.
define shared variable first_in_batch like mfc_logical.
define shared variable arnbr          like ar_nbr.
define shared variable jrnl           like glt_ref.
define shared variable batch          like ar_batch label {&ardrmtf_p_2}.
define shared variable artotal        like ar_amt label {&ardrmtf_p_1}.
define shared variable old_amt        like ar_amt.
define shared variable ardnbr         like ard_nbr.
define shared variable old_cust       like ar_bill.
define shared variable old_effdate    like ar_effdate.
define shared variable base_amt       like ar_amt.
define shared variable gltline        like glt_line.
define shared variable curr_amt       like glt_amt.
define shared variable base_det_amt   like glt_amt.
define shared variable bactrl         like ba_ctrl.
define shared variable bamodule       like ba_module.
define shared variable retval         as integer.
define shared variable counter        as integer no-undo.
define shared variable action         as character initial "E" format "x(1)".
define shared variable valid_acct     like mfc_logical initial no.
define shared variable firstpass      like mfc_logical.
define shared variable tax_tr_type    like tx2d_tr_type initial "18".
define shared variable tax_nbr        like tx2d_nbr initial "".
define shared variable ctrldiff       like ar_amt.
define shared variable old_sold       like ar_cust no-undo.

{&ARDRMTF-P-TAG9}
/* Logistics shared tables */
{lgardefs.i &type="lg"}

find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock no-error.
/* DEFINE SHARED FRAME B*/
{ardrfmb.i}

find first ar_mstr
   where recid(ar_mstr) = ar1_recno
   no-error.
l_tmp_bill = ar_bill.
do with frame b:
   seta:
   do on error undo, retry:

      /* IF NOT LOGISTICS, PROCESS NORMALLY */
      if not lgData
      then do:
         set
            ar_bill
            go-on ("F5" "CTRL-D")
         with frame b
         editing:

            if frame-field = "ar_bill"
               and new ar_mstr
            then do:
               {mfnp.i cm_mstr ar_bill  " cm_mstr.cm_domain = global_domain and
               cm_addr "  ar_bill
                       cm_addr cm_addr}
               if recno <> ?
               then
                  display
                     cm_addr @ ar_bill
                     cm_sort
                     cm_curr @ ar_curr.
               {&ARDRMTF-P-TAG1}
            end.
            else do:
               readkey.
               apply lastkey.
            end.
         end.   /* set with frame editing */

         /* DELETE */
         if not new ar_mstr
            and (lastkey = keycode("F5")
            or   lastkey = keycode("CTRL-D"))
         then do:
            del-yn = yes.
            {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1
                     &CONFIRM=del-yn &CONFIRM-TYPE='LOGICAL'}
            if del-yn = no
            then
               undo seta.
            else do:
               undo_header = no.
               return.
            end.
         end.
      end. /* if not lgData */
      else do:
         /* READ IN DATA FROM THE LOGISTCIS TABLES */
         for first lgm_lgmstr no-lock:
            ar_bill = lgm_ar_bill.

         /* PUT INTO THE 'input' VARIABLE AS WELL */
            display
               ar_bill
            with frame b.
         end.
      end.

      global_addr = ar_bill.

      /* VALIDATE BILL-TO */
      if not new ar_mstr
         and l_tmp_bill <> input ar_bill
         and ar_applied <> 0
      then do:
         {pxmsg.i &MSGNUM=4093 &ERRORLEVEL=3}
         /* PAYMENT APPLIED. MODIFICATION */
         /* TO BILL-TO NOT ALLOWED        */
         display
            l_tmp_bill @ ar_bill.
         next-prompt
            ar_bill.
         undo, retry.
      end. /* IF NOT NEW AR_MSTR */
      if not can-find(cm_mstr  where cm_mstr.cm_domain = global_domain and
      cm_addr = ar_bill)
      then do:
         {pxmsg.i &MSGNUM=3 &ERRORLEVEL=3} /* NOT A VALID CUSTOMER */
         /* NO RETRY FOR LOGISTICS, exit IF BAD */
         if lgData
         then
            return.
         next-prompt ar_bill.
         undo, retry.
      end.

      if new ar_mstr
      then do:
         find cm_mstr
             where cm_mstr.cm_domain = global_domain and  cm_addr = ar_bill
            no-lock no-error.
         {&ARDRMTF-P-TAG2}
         ar_curr = cm_curr.
         display
            cm_sort
            ar_curr
         with frame b.
         {&ARDRMTF-P-TAG3}
      end.

      /* SS - 20080830.1 - B */
      /* SS - 091014.1 - B
      {gprun.i ""ssgltrrefdocbq.p"" "(
         INPUT 'AR',
         INPUT 'M',
         INPUT (INPUT ar_nbr),
         INPUT (BATCH),
         OUTPUT ref_glt,
         OUTPUT user1_glt
         )"}

      IF ref_glt <> "" THEN DO:
         /* Update not allowed */
         {pxmsg.i &MSGNUM=171 &ERRORLEVEL=1}
         next-prompt
            ar_bill.
         undo, retry.
      END.
      SS - 091014.1 - E */
      /* SS - 091014.1 - B */
      FIND FIRST arc_ctrl
         WHERE arc_domain = GLOBAL_domain
         NO-LOCK NO-ERROR.
      IF AVAILABLE arc_ctrl THEN DO:
         IF arc_sum_lvl = 3 THEN DO:
            {gprun.i ""ssgltrrefdocbq.p"" "(
               INPUT 'AR',
               INPUT 'M',
               INPUT (INPUT ar_nbr),
               INPUT (BATCH),
               OUTPUT ref_glt,
               OUTPUT user1_glt
               )"}

            IF ref_glt <> "" THEN DO:
               /* Update not allowed */
               {pxmsg.i &MSGNUM=171 &ERRORLEVEL=1}
               next-prompt
                  ar_bill.
               undo, retry.
            END.
         END.
      END.
      /* SS - 091014.1 - E */
      /* SS - 20080830.1 - E */

      if del-yn = no
      then do:
         undo_all2 = yes.
         {&ARDRMTF-P-TAG4}
         setb:
         do on error undo, retry:

            /* IF NOT LOGISTICS, PROCESS NORMALLY */
            if not lgData
            then do:
               set
                  ar_curr when (new ar_mstr)
                  ar_type when (new ar_mstr)
                  {&ARDRMTF-P-TAG5}
                  ar_date
                  ar_effdate when (new ar_mstr)
                  ar_tax_date
                  {&ARDRMTF-P-TAG6}
                  go-on ("F5" "CTRL-D") with frame b.
               {&ARDRMTF-P-TAG7}
               /* DELETE */
               if not new ar_mstr
                  and (lastkey = keycode("F5")
                  or lastkey = keycode("CTRL-D"))
               then do:
                  del-yn = yes.
                  {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1
                           &CONFIRM=del-yn &CONFIRM-TYPE='LOGICAL'}
                  if del-yn = no
                  then
                     undo seta.
                  else do:
                     undo_header = no.
                     return.
                  end.
               end.
            end. /* if not lgData */
            else do:
               /* READ FROM LOGISTICS TABLES */
               for first lgm_lgmstr no-lock:
                  assign
                     ar_type = "M"
                     ar_curr = lgm_ar_curr
                     ar_date = lgm_ar_date.
               end.
            end.

            /* NEW INVOICES CANNOT BE CREATED WITH THIS COMMAND */
            if new ar_mstr and ar_type = "I"
            then do:
               {pxmsg.i &MSGNUM=1175 &ERRORLEVEL=3}
               if lgData
               then
                  return.
               next-prompt ar_type.
               undo, retry.
            end.

            /* CHECK THAT RECORD IS A MEMO, FIN CHARGE OR INV */
            if index("MFI",ar_type) = 0
            then do:
               {pxmsg.i &MSGNUM=1172 &ERRORLEVEL=3}
               if lgData
               then
                  return.
               next-prompt ar_type.
               undo,retry.
            end.

            /* DEFAULT DAYBOOK IS ALREADY BEEN OBTAINED BY MAIN    */
            /* PROGRAM THEREFORE NO NEED TO OBTAIN AGAIN TO AVOID  */
            /* OVER-WRITTEN OF USER-ENTERED DAYBOOK WITH DEFAULT   */
            /* DAYBOOK WHEN EXISTING DR/CR MEMO IS RETRIEVED AGAIN */

            {&ARDRMTF-P-TAG8}

            display ar_dy_code with frame b.

            /* VALIDATE THE CURRENCY ENTERED AND SET RNDMTHD */
            if (oldcurr <> ar_curr)
               or (ar_curr = "")
            then do:

               if ar_curr = base_curr
               then
                  rndmthd = gl_rnd_mthd.
               else do:
                  /* GET ROUNDING METHOD FROM CURRENCY MASTER */
                  {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                                       "(input  ar_curr,
                                         output rndmthd,
                                         output mc-error-number)"}
                  if mc-error-number <> 0
                  then do:
                     {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
                     if lgData
                     then
                        return.
                     undo, retry.
                  end.
               end.
               artotal_fmt = artotal_old.
               {gprun.i ""gpcurfmt.p"" "(input-output artotal_fmt,
                                         input        rndmthd)"}
               assign
                  artotal:format = artotal_fmt
                  ar_amt_fmt     = ar_amt_old.

               {gprun.i ""gpcurfmt.p"" "(input-output ar_amt_fmt,
                                         input        rndmthd)"}

               assign
                  ar_amt:format = artotal_fmt
                  ar_sales_fmt  = ar_sales_old.

               {gprun.i ""gpcurfmt.p"" "(input-output ar_sales_fmt,
                                         input        rndmthd)"}

               assign
                  ar_sales_amt:format = artotal_fmt
                  oldcurr             = ar_curr.

            end.   /* IF OLDCURR <> AR_CURR */

            /* VERIFY GL EFFECTIVE DATE FOR PRIMARY ENTITY
               (USE PRIMARY SINCE THEY CAN EDIT ENITY FIELD IN
               THE NEXT FRAME - USE WARNING IF POSSIBLE) */


            if new ar_mstr
            then do:
               {gpglef01.i ""AR"" glentity ar_effdate}
               if gpglef > 0
               then do:
                  /* IF PERIOD CLOSED THEN WARNING ONLY */
                  if gpglef = 3036
                  then do:
                     {pxmsg.i &MSGNUM=3005 &ERRORLEVEL=2}
                     /* OTHERWISE REGULAR ERROR MESSAGE */
                  end.
                  else
                  if gpglef <> 3036
                     then do:
                     {pxmsg.i &MSGNUM=gpglef &ERRORLEVEL=3}
                     if lgData
                     then
                        return.
                     next-prompt
                        ar_effdate
                     with frame b.
                     undo seta, retry.
                  end.
               end.
            end.

            /* VALIDATE DAYBOOK */
            if daybooks-in-use
               and new ar_mstr
            then do:

               {gprunp.i "nrm" "p" "nr_can_dispense"
                  "(input ar_dy_code,
                    input ar_effdate)"}
               {gprunp.i "nrm" "p" "nr_check_error"
                  "(output daybook-error,
                    output return_int)"}

               if daybook-error
               then do:
                  {pxmsg.i &MSGNUM=return_int &ERRORLEVEL=3}
                  if lgData
                  then
                     return.
                  next-prompt ar_dy_code.
                  undo seta, retry.
               end.

               find dy_mstr
                   where dy_mstr.dy_domain = global_domain and  dy_dy_code =
                   ar_dy_code
                  no-lock no-error.
               if available dy_mstr
               then
                  assign
                     daybook-desc = dy_desc
                     dft-daybook  = ar_dy_code.
            end.  /* IF DBKS IN USE */

            undo_all2 = no.
         end. /* SETB*/
      end. /* IF DEL-YN = NO */
      if undo_all2 = no
      then
         undo_header = no.
   end. /*seta*/
end. /* do with frame b */
