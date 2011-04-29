/* ardrmt.p - AR DEBIT/CREDIT MEMO MAINTENANCE                               */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.20.1.36 $                                                              */
/*V8:ConvertMode=Maintenance                                                 */
/* REVISION: 1.0      LAST MODIFIED: 07/11/86   by: PML                      */
/* REVISION: 6.0      LAST MODIFIED: 08/22/90   by: mlb *D055*               */
/*                                   09/06/90   by: mlb *D065*               */
/*                                   09/24/90   by: afs *D059*               */
/*                                   10/08/90   by: mlb *D079*               */
/*                                   02/28/91   by: afs *D387*               */
/*                                   03/12/91   by: mlb *D360*               */
/*                                   04/02/91   by: bjb *D507*               */
/*                                   04/19/91   by: mlv *D546*               */
/*                                   09/23/91   by: mlv *D860*               */
/* REVISION: 7.0      LAST MODIFIED: 11/07/91   by: mlv *F031*               */
/*                                   01/21/92   by: mlv *F090*               */
/*                                   02/05/92   by: tmd *F169*               */
/*                                   03/22/92   by: tmd *F302*               */
/*                                   03/27/92   by: dld *F322*               */
/*                                   04/11/92   by: afs *F356*               */
/*                                   06/02/92   by: jjs *F567*               */
/*                                   06/19/92   by: tmd *F458*   (rev only)  */
/*                                   06/24/92   by: jjs *F681*               */
/* REVISION: 7.3      LAST MODIFIED: 07/23/92   by: mpp *G003*               */
/*                                   10/12/92   by: jms *G163*               */
/*                                   11/10/92   by: mpp *G307*               */
/*                                   12/02/92   by: mpp *G385*               */
/*                                   01/05/93   by: mpp *G476*               */
/*                                   01/11/93   by: mpp *G534*               */
/*                                   01/25/93   by: mpp *G587* (rev only)    */
/*                                   03/29/93   by: jms *G697*               */
/*                                   02/18/93   by: jms *G699*               */
/*                                   02/26/93   by: skk *G753*               */
/*                                   03/10/93   by: bcm *G796*               */
/*                                   04/09/93   by: jms *G933* (rev only)    */
/*                                   04/21/93   by: skk *GA04*               */
/*                                   06/15/93   by: pcd *GC27* (rev only)    */
/* REVISION: 7.4      LAST MODIFIED: 07/08/93   by: wep *H021* (rev only)    */
/*                                   07/22/93   by: pcd *H039*               */
/*                                   09/08/93   by: bcm *H106* (rev only)    */
/*                                   09/15/93   by: pcd *H115*               */
/*                                   10/04/93   by: tjs *H070*               */
/*                                   11/23/93   by: bcm *H240*               */
/*                                   02/08/94   by: srk *GI33*               */
/*                                   03/29/94   by: wep *FL75*               */
/*                                   06/27/94   by: pmf *FP09*               */
/*                                   07/25/94   by: bcm *H458*               */
/* Oracle changes (share-locks)      09/11/94   by: rwl *FR14*               */
/*                                   09/15/94   by: ljm *GM57*               */
/*                                   02/17/95   by: wjk *H0BH*               */
/*                                   04/21/95   by: wjk *H0CS*               */
/*                                   01/24/96   by: jzw *H0J6*               */
/*                                   01/31/96   by: jzw *H0JK*               */
/*                                   01/30/96   by: ais *G1L8*               */
/* REVISION: 8.5      LAST MODIFIED: 12/19/95   by: taf *J053*               */
/*                                   05/30/96   by: bxw *J0Q0*               */
/*                                   07/15/96   by: *J0VY* M. Deleeuw        */
/* REVISION: 8.6      LAST MODIFIED: 06/18/96   BY: bjl *K001*               */
/*                                   07/15/96   by: taf *J0ZC*               */
/*                                   07/29/96   by: taf *J101*               */
/*                                   09/03/96   by: jzw *K00B*               */
/*                                   09/30/96   by: *G2G2* Aruna P. Patil    */
/*                                   12/30/96   by: *K03F* Jeff Wootton      */
/*                                   01/28/97   by: *J1FR* Robin McCarthy    */
/*                                   01/29/97   by: *K05F* Eugene Kim        */
/*                                   02/17/97   by: *K01R* E. Hughart        */
/*                                   04/17/97   by: *J1P8* Robin McCarthy    */
/* REVISION: 8.6      LAST MODIFIED: 07/09/97   by: *H1BQ* Irine D'mello     */
/* REVISION: 8.6      LAST MODIFIED: 12/17/97   BY: *J286* Prashanth Narayan */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan        */
/* REVISION: 8.6E     LAST MODIFIED: 06/02/98   BY: *L01K* Jaydeep Parikh    */
/* REVISION: 8.6E     LAST MODIFIED: 10/12/98   BY: *J31Y* Prashanth Narayan */
/* REVISION: 8.6E     LAST MODIFIED: 11/25/98   BY: *K1YB* Santhosh Nair     */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.0      LAST MODIFIED: 04/05/99   BY: *K207* Abbas Hirkani     */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Jeff Wootton      */
/* REVISION: 9.1      LAST MODIFIED: 10/22/99   BY: *N04P* Robert Jensen     */
/* REVISION: 9.1      LAST MODIFIED: 03/06/00   BY: *N05Q* Luke Pokic        */
/* REVISION: 9.1      LAST MODIFIED: 09/05/00   BY: *N0RF* Mark Brown        */
/* REVISION: 9.1      LAST MODIFIED: 09/26/00   BY: *M0RP* Veena Lad         */
/* REVISION: 9.1      LAST MODIFIED: 10/13/00   BY: *M0NV* Vihang Talwalkar  */
/* REVISION: 9.1      LAST MODIFIED: 09/22/00   BY: *N0VN* BalbeerS Rajput   */
/* REVISION: 9.0      LAST MODIFIED: 02/20/01   BY: *N0XL* Ed van de Gevel   */
/* Old ECO marker removed, but no ECO header exists *F0PN*                   */
/* Revision: 1.20.1.18     BY: Katie Hilbert    DATE: 04/01/01 ECO: *P002*   */
/* Revision: 1.20.1.19     BY: Vinod Nair       DATE: 06/08/01 ECO: *M18H*   */
/* Revision: 1.20.1.20     BY: Vinod Nair       DATE: 06/20/01 ECO: *M1BG*   */
/* Revision: 1.20.1.21     BY: Falguni Dalal    DATE: 10/12/01 ECO: *N14C*   */
/* Revision: 1.20.1.22     BY: Vihang Talwalkar DATE: 10/22/01 ECO: *P01V*   */
/* Revision: 1.20.1.23     BY: Saurabh C.       DATE: 05/15/02 ECO: *M1Y7*   */
/* Revision: 1.20.1.26     BY: Manjusha Inglay  DATE: 07/29/02 ECO: *N1P4*   */
/* Revision: 1.20.1.27     BY: Piotr Witkowicz  DATE: 03/18/03 ECO: *P0NP*   */
/* Revision: 1.20.1.28     BY: Vivek Gogte      DATE: 04/24/03 ECO: *N2DH*   */
/* Revision: 1.20.1.30     BY: Orawan S. DATE: 05/08/03 ECO: *P0RJ* */
/* Revision: 1.20.1.33     BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00B* */
/* Revision: 1.20.1.34     BY: Anitha Gopal       DATE: 08/02/03 ECO: *N2GW* */
/* Revision: 1.20.1.35     BY: K Paneesh          DATE: 08/08/03 ECO: *N2JT* */
/* $Revision: 1.20.1.36 $            BY: Annapurna V        DATE: 02/21/05 ECO: *P390* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* Logisitics processes Debit/Cedit memos received by          */
/* External systems.  These are processed via Q/LinQ           */
/* By batch processing.  User input in this case is            */
/* Disabled and data is read from temp tables.                 */

/* SS - 20080830.1 By: Bill Jiang */
/* SS - 081223.1 By: Bill Jiang */
/* SS - 091014.1 By: Bill Jiang */
/* SS - 100330.1  By: Roger Xiao */  /*参照ssapvomt.p修改,eco:091218.1,需求见call:ss-396,共四只程式全部需要修改*/





/* SS - 091014.1 - RNB
[091014.1]

应用了<27.24 应收帐控制 [arpm.p]>的以下字段:
  - 应收帐汇总层 [arc_sum_lvl]

[091014.1]

SS - 091014.1 - RNE */

/* DISPLAY TITLE */
/*
{mfdtitle.i "1+ "}
*/
{mfdtitle.i "100330.1"}

/* SS - 20080830.1 - B */
DEFINE NEW SHARED VARIABLE ref_glt LIKE glt_det.glt_ref.
DEFINE NEW SHARED VARIABLE user1_glt LIKE glt_det.glt_user1.
/* SS - 20080830.1 - E */
{cxcustom.i "ARDRMT.P"}
{gprunpdf.i "mcrndpl" "p"}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE ardrmt_p_1 "Batch"
/* MaxLen: Comment: */

&SCOPED-DEFINE ardrmt_p_2 "Memo Control"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

{gldydef.i new}
{gldynrm.i new}

define variable init-daybook like dy_dy_code.
define variable calcd_disc_date as date no-undo.
define variable calcd_due_date  as date no-undo.
define variable mc-error-number like msg_nbr no-undo.
{&ARDRMT-P-TAG1}
{&ARDRMT-P-TAG20}

/* RUN PROCESSING-LOGIC SUBPROGRAM */
define new shared variable h_rules as handle no-undo.
{gprun.i ""ardrmtpl.p"" "persistent set h_rules"}.

define new shared variable undo_header    like mfc_logical no-undo.
define new shared variable rndmthd        like rnd_rnd_mthd.
define new shared variable oldcurr        like ar_curr.
define new shared variable artotal_old    as character.
define new shared variable artotal_fmt    as character.
define new shared variable ar_amt_old    as character.
define new shared variable ar_amt_fmt    as character.
define new shared variable ar_sales_old    as character.
define new shared variable ar_sales_fmt    as character.
define new shared variable ar_recno       as recid.
define new shared variable ar1_recno       as recid.
define new shared variable ard_recno      as recid.
define new shared variable ba_recno       as recid.
define new shared variable cm_recno       as recid.
define new shared variable del-yn         like mfc_logical initial no.
define new shared variable do_tax         like mfc_logical.
define new shared variable undo_all       like mfc_logical.
define new shared variable first_in_batch like mfc_logical.
define new shared variable arnbr          like ar_nbr.
define new shared variable jrnl           like glt_ref.
define new shared variable batch          like ar_batch
   label {&ardrmt_p_1}.
define new shared variable artotal        like ar_amt
   label {&ardrmt_p_2}.
define new shared variable old_amt        like ar_amt.
define new shared variable ardnbr         like ard_nbr.
define new shared variable old_cust       like ar_bill.
define new shared variable old_effdate    like ar_effdate.
define new shared variable base_amt       like ar_amt.
define new shared variable gltline        like glt_line.
define new shared variable curr_amt       like glt_amt.
define new shared variable base_det_amt   like glt_amt.
define new shared variable bactrl         like ba_ctrl.
define new shared variable bamodule       like ba_module.

define new shared variable retval          as integer.
define new shared variable counter         as integer no-undo.
define new shared variable action          as character
   initial "2" format "x(1)".
define new shared variable valid_acct
   like mfc_logical initial no.
define new shared variable firstpass       like mfc_logical.
define new shared variable tax_tr_type
   like tx2d_tr_type initial "18".
define new shared variable tax_nbr
   like tx2d_nbr initial "".
define new shared variable ctrldiff        like ar_amt.
define new shared variable old_sold like ar_cust no-undo.
define new shared variable ref             like glt_ref.

/* VARIABLES ASSIGNED IN ARDRMTH.P, USED IN ARDRMTA.P */
{ardrmtha.i new}

/* DEFINE VARIABLES FOR GPGLEF.P (GL CALENDAR VALIDATION) */
{gpglefdf.i}

/* DEFINE SHARED FRAME A */
{ardrfma.i "new"}

/* Logistics external data definition */
{lgardefs.i &new = "new" &type = "lg"}

/* Is Logistics running this transaction? */
{gprun.i ""mgisact.p"" "(input 'lgarinv', output lgData)"}
/* If so, copy the Logistics data into local tables */
if lgData then do:
   {gprunmo.i &module = "LG"
      &program = "lgarcp.p"}
end.

find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock.
/* DEFINE SHARED FRAME B*/
{ardrfmb.i "new"}
/* INITIALIZE _OLD FORMAT VARIABLES */
assign
   artotal_old = artotal:format
   ar_amt_old = ar_amt:format
   ar_sales_old  = ar_sales_amt:format.

mainloop:
repeat with frame a:
   hide frame b.
   {gprun.i ""gldydft.p"" "(input ""AR"",
                            input ""M"",
                            input gl_entity,
                            output dft-daybook,
                            output daybook-desc)"}

   assign
      jrnl = ""
      init-daybook = dft-daybook.
   /* GET BATCH DATA */
   {gprun.i ""ardrmtd.p""}

   /* Since Logistics is running without a person. */
   /* Don't look for keystrokes. */

   if not lgData then do:
      if keyfunction(lastkey) = "END-ERROR"
         or keyfunction(lastkey) = "ENDKEY"
         or keyfunction(lastkey) = "." then leave.
   end.

   if ba_recno <> 0 then
      find ba_mstr where recid(ba_mstr) = ba_recno no-lock.

   {&ARDRMT-P-TAG2}
   loopb:
   repeat with frame b:
      {&ARDRMT-P-TAG3}

      clear frame b all no-pause.
      firstpass = true.

      release ar_mstr.

      view frame a.

      /* GET REFERENCE */
      {gprun.i ""ardrmte.p""}

      /* Since Logistics is running without a person. */
      /* Don't look for keystrokes. */

      if not lgData then do:
         if keyfunction(lastkey) = "END-ERROR"
            or keyfunction(lastkey) = "ENDKEY"
            or keyfunction(lastkey) = "." then leave.
      end.

      {&ARDRMT-P-TAG15}
      loopc_trans:
      {&ARDRMT-P-TAG4}
      do transaction on error undo, retry:
         {&ARDRMT-P-TAG5}

         /*RE-OBTAIN BA_MSTR TO PLACE EXCLUSIVE LOCK*/
         find ba_mstr  where ba_mstr.ba_domain = global_domain and  ba_batch =
         batch
            and ba_module = bamodule
            exclusive-lock no-error.

         display bactrl ba_total with frame a.

         /* ADD/MOD/DELETE  */
find ar_mstr using  ar_nbr where ar_mstr.ar_domain = global_domain
exclusive-lock no-error.


         /* IF AR_MSTR IS AVAILABLE THEN SET RNDMTHD AND FORMATS*/
         if available ar_mstr then do:

            if (oldcurr <> ar_curr) or (oldcurr = "") then do:

               if ar_curr = base_curr then
                  rndmthd = gl_rnd_mthd.
               else do:
                  /* GET ROUNDING METHOD FROM CURRENCY MASTER */
                  {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                     "(input ar_curr,
                       output rndmthd,
                       output mc-error-number)"}
                  if mc-error-number <> 0 then do:
                     {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
                     if lgData then return.
                     undo, retry.
                  end.
               end.
               artotal_fmt = artotal_old.
               {gprun.i ""gpcurfmt.p""
                  "(input-output artotal_fmt,
                    input rndmthd)"}
               artotal:format = artotal_fmt.
               ar_amt_fmt = ar_amt_old.
               {gprun.i ""gpcurfmt.p""
                  "(input-output ar_amt_fmt,
                    input rndmthd)"}
               ar_amt:format = ar_amt_fmt.
               ar_sales_fmt = ar_sales_old.
               {gprun.i ""gpcurfmt.p""
                  "(input-output ar_sales_fmt,
                    input rndmthd)"}
               ar_sales_amt:format = ar_sales_fmt.
               oldcurr = ar_curr.
            end.
         end. /* IF AVAILABLE AR_MSTR */

         {&ARDRMT-P-TAG6}
         if not available ar_mstr then do:
            create ar_mstr. ar_mstr.ar_domain = global_domain.
            assign ar_nbr    = arnbr
               ar_type    = "M"
               ar_batch   = batch
               ar_date    = today
               ar_effdate = today
               artotal    = 0
               ar_dy_code = init-daybook
               do_tax     = yes .
            {&ARDRMT-P-TAG7}
         end.
         else
            if firstpass then
               assign
                  artotal = ar_amt
                  old_effdate = ar_effdate
                  do_tax = no.

         {&ARDRMT-P-TAG21}
         display artotal ar_amt ar_bill ar_date ar_effdate ar_type
            ar_cr_term ar_disc_date ar_due_date ar_expt_date
            ar_slspsn[1] ar_slspsn[2]
            ar_comm_pct[1] ar_comm_pct[2]
            ar_slspsn[3] ar_slspsn[4]
            ar_comm_pct[3] ar_comm_pct[4]
            ar_dun_level
            ar_po ar_cust ar_ship
            ar_sales_amt ar_tax_date
            ar_acct
            ar_sub
            ar_cc ar_entity ar_batch
            ar_dy_code
            "" @ cm_sort ar_curr ar_print ar_contested
            {&ARDRMT-P-TAG22}
            ar_shipfrom when (ar_type = "M" or ar_type = "F").

         {&ARDRMT-P-TAG8}
         allow-gaps = no.
         if daybooks-in-use and ar_dy_code > "" then do:
            {gprunp.i "nrm" "p" "nr_can_void"
               "(input  ar_dy_code,
                 output allow-gaps)"}
         end. /* if daybooks-in-use and ar_dy_code > "" */

         /* CHECK THAT RECORD IS A MEMO OF FIN CHARGE OR INVOICE */
         if index("MFI",ar_type) = 0 then do:
            {pxmsg.i &MSGNUM=1154 &ERRORLEVEL=3}
            if lgData then return.
            undo loopb, retry.
         end.

         /* CHECK THAT MEMO IS IN BATCH */
         if batch <> "" and batch <> ar_batch then do:
            {pxmsg.i &MSGNUM=1152 &ERRORLEVEL=3}
            if lgData then return.
            undo loopb, retry.
         end.

         display ar_batch.
         assign
            old_amt = ar_amt - ar_applied
            old_cust = ar_bill
            old_sold = ar_cust
            recno = recid(ar_mstr)
            del-yn = no.
         if new ar_mstr then do:
            ststatus = stline[1].
            status input ststatus.
         end.
         else do:
            ststatus = stline[2].
            status input ststatus.
         end.
         display artotal ar_bill ar_type ar_date ar_effdate
            ar_tax_date.

         ar1_recno = recid(ar_mstr).

         /* SS - 20080829.1 - B */
         /* SS - 091014.1 - B
         {gprun.i ""ssgltrrefdocbq.p"" "(
            INPUT 'AR',
            INPUT 'M',
            INPUT (INPUT ar_nbr),
            INPUT (INPUT BATCH),
            OUTPUT ref_glt,
            OUTPUT user1_glt
            )"}

         /* New reference number for document # */
         IF ref_glt <> "" THEN DO:
            {pxmsg.i &MSGNUM=5733 &ERRORLEVEL=1 &MSGARG1=ref_glt}
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
                  INPUT (INPUT BATCH),
                  OUTPUT ref_glt,
                  OUTPUT user1_glt
                  )"}

               /* New reference number for document # */
               IF ref_glt <> "" THEN DO:
                  {pxmsg.i &MSGNUM=5733 &ERRORLEVEL=1 &MSGARG1=ref_glt}
               END.
            END.
         END.
         /* SS - 091014.1 - E */
         /* SS - 20080829.1 - E */

         billloop:
         do on error undo, retry:
            undo_header = yes.
            /* SS - 20080830.1 - B */
            /*
            {gprun.i ""ardrmtf.p""}
            */
            {gprun.i ""ssardrmtf.p""}
            /* SS - 20080830.1 - E */

            /* Since Logistics is running without a person. */
            /* Don't look for keystrokes. */

            if not lgData then do:
               if keyfunction(lastkey) = "END-ERROR"
                  or keyfunction(lastkey) = "ENDKEY"
                  or undo_header = yes
                  or keyfunction(lastkey) = "." then undo loopb, retry.
            end.
            else do:
               /* But do exit if error */
               if undo_header = yes then return.
               /* Set the application owner for this ar_mstr to */
               /* the Logistics system running this transaction. */
               {mgqqapp.i "ar_app_owner"}
            end.

            if ar_tax_date = ? then ar_tax_date = ar_effdate.
            display ar_tax_date with frame b.
            {&ARDRMT-P-TAG16}

            if del-yn then do:

               /* VERIFY GL CALENDAR FOR SPECIFIED ENTITY */
               /* (DON'T ALLOW DELETE IF CLOSED)          */
               {gpglef.i ""AR"" ar_entity ar_effdate "loopb"}

               /* CHECK FOR DAYBOOK */
               if daybooks-in-use
                  and ar_dy_code > ""
                  and not allow-gaps
               then do:
                  /* SEQUENCE DOES NOT ALLOW GAPS */
                  {pxmsg.i &MSGNUM=1349
                           &ERRORLEVEL=4}
                  undo loopb, retry.
               end. /* IF daybooks-in-use ... */

               /* CHECK FOR PAYMENT */
               if ar_applied <> 0 then do:
                  ardnbr = "".
                  find first ard_det  where ard_det.ard_domain = global_domain
                  and  ard_ref = ar_nbr no-lock
                     no-error.
                  if available ard_det then ardnbr = ard_nbr.
                  /* Delete not allowed.  Payment has been applied */
                  {pxmsg.i &MSGNUM=1166 &ERRORLEVEL=3 &MSGARG1=ardnbr}
                  if lgData then return.
                  undo,retry.
               end.
               {&ARDRMT-P-TAG9}

               /* CHECK FOR INVOICE DO NOT ALLOW DELETE */
               if ar_type = "I" then do:
                  {pxmsg.i &MSGNUM=1168 &ERRORLEVEL=3}
                  if lgData then return.
                  undo, retry.
               end.

               /* CHECK FOR PRM PREPAYMENTS */
               if ar_fsm_type = "PRM" and ar_prepayment then do:
                  /* DELETION OF PRM PREPAYMENT NOT ALLOWED */
                  {pxmsg.i &MSGNUM=3422 &ERRORLEVEL=3}
                  if lgData then return.
                  undo, retry.
               end.

               /* JOURNAL NUMBER GETS INCREMENTED AT DISTRIBUTION LINE LEVEL */
               if jrnl = ""
               then do :
                  /* GET NEXT JOURNAL REFERENCE NUMBER  */
                  {mfnctrl.i "arc_ctrl.arc_domain = global_domain"
                  "arc_ctrl.arc_domain" "glt_det.glt_domain = global_domain"
                  arc_ctrl arc_jrnl glt_det glt_ref jrnl}
                  release glt_det.
               end. /* IF jrnl = "" */

               for each ard_det exclusive-lock
                      where ard_det.ard_domain = global_domain and  ard_nbr =
                      ar_nbr:
                  /* CONVERT INTO BASE HERE. */
                  curr_amt = - ard_amt.

                  run calc_base_amt in h_rules
                     (- ard_amt,
                     buffer ar_mstr,
                     buffer gl_ctrl,
                     output base_amt).

                  ar_recno = recid(ar_mstr).
                  ard_recno = recid(ard_det).
                  undo_all = yes.
                  base_det_amt = base_amt.
                  {&ARDRMT-P-TAG19}
                  {gprun.i ""arargl.p""}
                  if undo_all then undo mainloop, leave.
                  delete ard_det.
               end.

               {&ARDRMT-P-TAG23}
               pause 0.
               /* DELETE TAX DETAIL RECORDS */
               {gprun.i ""txdelete.p"" "(input tax_tr_type,
                                         input ar_nbr,
                                         input tax_nbr)"}

               /* UPDATE CUSTOMER BALANCE */
               if old_amt <> 0 then do:

                  run calc_base_amt in h_rules
                     (- old_amt,
                     buffer ar_mstr,
                     buffer gl_ctrl,
                     output base_amt).

                  find cm_mstr  where cm_mstr.cm_domain = global_domain and
                  cm_addr = old_cust
                     exclusive-lock.
                  run update_cm_balance in h_rules
                     (base_amt,
                     buffer ar_mstr,
                     buffer cm_mstr).

                  run update_ba_total in h_rules
                     (- ar_amt,
                     buffer ba_mstr).

               end.
               {gprun.i ""gpardel.p"" "(input ar_nbr)"}
               /* MUST INCLUDE gprunpdf.i IN THE MAIN BLOCK OF THE  */
               /* PROGRAM SO THAT CALLS TO gprunp.i FROM ANY OF THE */
               /* INTERNAL PROCEDURES SKIPS DEFINITION OF SHARED    */
               /* VARS OF gprunpdf.i FOR FURTHER INFO REFER TO      */
               /* HEADER COMMENTS IN gprunp.i                       */

               if ar_curr <> base_curr
               then do:
                  {gprunpdf.i "gpglpl" "p"}
                  run p_round.
               end. /* IF ar_curr <> base_curr */

               {&ARDRMT-P-TAG24}
               /* DEL EXCHANGE RATE USAGE (exru_usage) RECORDS */
               run delete_rate_usage_records.
               /* SS - 20080829.1 - B */
               /* SS - 091014.1 - B
               {gprun.i ""ssgltrrefdocbd.p"" "(
                  INPUT 'AR',
                  INPUT 'M',
                  INPUT (INPUT ar_nbr),
                  INPUT (INPUT BATCH),
                  OUTPUT ref_glt,
                  OUTPUT user1_glt
                  )"}

               /* New reference number for document # */
               IF ref_glt <> "" THEN DO:
                  {pxmsg.i &MSGNUM=5733 &ERRORLEVEL=1 &MSGARG1=ref_glt}
               END.
               SS - 091014.1 - E */
               /* SS - 091014.1 - B */
/* SS - 100330.1 - B 
               FIND FIRST arc_ctrl
                  WHERE arc_domain = GLOBAL_domain
                  NO-LOCK NO-ERROR.
               IF AVAILABLE arc_ctrl THEN DO:
                  IF arc_sum_lvl = 3 THEN DO:
                     {gprun.i ""ssgltrrefdocbd.p"" "(
                        INPUT 'AR',
                        INPUT 'M',
                        INPUT (INPUT ar_nbr),
                        INPUT (INPUT BATCH),
                        OUTPUT ref_glt,
                        OUTPUT user1_glt
                        )"}

                     /* New reference number for document # */
                     IF ref_glt <> "" THEN DO:
                        {pxmsg.i &MSGNUM=5733 &ERRORLEVEL=1 &MSGARG1=ref_glt}
                     END.
                  END.
               END.
               /* SS - 091014.1 - E */
   SS - 100330.1 - E */
/* SS - 100330.1 - B */
    {gprun.i ""ssgltrrefdocbd.p"" "(
            INPUT 'AR',
            INPUT 'M',
            INPUT (INPUT ar_nbr),
            INPUT (INPUT BATCH),
            OUTPUT ref_glt,
            OUTPUT user1_glt
            )"}

    /* New reference number for document # */
    IF ref_glt <> "" THEN DO:
    {pxmsg.i &MSGNUM=5733 &ERRORLEVEL=1 &MSGARG1=ref_glt}
    END.
/* SS - 100330.1 - E */
               /* SS - 20080829.1 - E */
               delete ar_mstr.
               {&ARDRMT-P-TAG10}
               clear frame b.
               del-yn = no.
               next loopb.
            end.  /* if delete */

            find cm_mstr  where cm_mstr.cm_domain = global_domain and  cm_addr
            = input ar_bill no-lock.
            display cm_sort.
            if new ar_mstr then do:
               assign
                  old_cust     = ar_bill
                  ar_cust      = ar_bill
                  ar_acct      = cm_ar_acct
                  ar_sub       = cm_ar_sub
                  ar_cc        = cm_ar_cc
                  {&ARDRMT-P-TAG17}
                  ar_entity    = gl_entity
                  {&ARDRMT-P-TAG18}
                  ar_slspsn[1] = cm_slspsn[1]
                  ar_slspsn[2] = cm_slspsn[2]
                  ar_slspsn[3] = cm_slspsn[3]
                  ar_slspsn[4] = cm_slspsn[4] .

               do counter = 1 to 4:
                  if ar_slspsn[counter] <> "" then do:
                     find sp_mstr  where sp_mstr.sp_domain = global_domain and
                     sp_addr = ar_slspsn[counter]
                        no-lock no-error.
                     if available sp_mstr then
                        ar_comm_pct[counter] = sp_comm_pct.
                  end.
               end.

               if artotal >= 0 then ar_cr_terms = cm_cr_terms.

               /* Set exchange rate if non-base currency */

               assign
                  ar_ex_rate = 1
                  ar_ex_rate2 = 1.

            end. /* if new ar_mstr */

            {&ARDRMT-P-TAG25}
            display
               ar_cr_term ar_disc_date ar_due_date
               ar_expt_date ar_po ar_slspsn[1]
               ar_slspsn[2] ar_comm_pct[1] ar_comm_pct[2]
               ar_slspsn[3] ar_slspsn[4] ar_comm_pct[3] ar_comm_pct[4]
               ar_dun_level
               ar_sales_amt ar_acct
               ar_sub
               ar_cc ar_entity
               ar_cust ar_ship ar_curr ar_print ar_contested
               {&ARDRMT-P-TAG26}
               ar_shipfrom when (ar_type = "M" or ar_type = "F")
            with frame b.

            ststatus = stline[3].
            status input ststatus.

            undo_header = yes.
            {gprun.i ""ardrmtg.p""}

            ststatus = stline[2].
            status input ststatus.

            /* Since Logistics is running without a person. */
            /* Don't look for keystrokes. */

            if not lgData then do:
               if keyfunction(lastkey) = "END-ERROR"
                  or keyfunction(lastkey) = "ENDKEY"
                  or keyfunction(lastkey) = "." then undo billloop, retry.
               if undo_header = yes then undo loopc_trans, retry.
            end.
            else do:
               /* But do exit on error */
               if undo_header = yes then undo loopc_trans, return.
            end.
         end. /* BILLLOOP*/

         if ar_disc_date = ? or ar_due_date = ? then do:

            /*CALCULATE CREDIT TERMS */
            ar_recno = recid(ar_mstr).

            /* CHECK THE TYPE OF CREDIT TERM WHETHER MULTI-LEVEL OR NOT */
            find ct_mstr  where ct_mstr.ct_domain = global_domain and  ct_code
            = ar_cr_terms no-lock no-error.
            if not available ct_mstr or ct_dating = no then do:
               {gprun.i ""adctrms.p""
                  "(input ar_date,
                    input ar_cr_terms,
                    output calcd_disc_date,
                    output calcd_due_date)"}
            end. /* IF not available ct_mstr or ... */
            else do:
               /* IF MULTI-LEVEL CREDIT TERM, GET THE LAST DUE DATE */
               find last ctd_det  where ctd_det.ctd_domain = global_domain and
               ctd_code = ar_cr_terms
                  no-lock no-error.
               /* CALCULATE DATES USING THE LAST CREDIT TERMS RECORD */
               if available ctd_det then do:
                  {gprun.i ""adctrms.p""
                     "(input ar_date,
                       input ctd_date_cd,
                       output calcd_disc_date,
                       output calcd_due_date)"}
               end. /* IF available ctd_det */
            end. /* IF available ct_mstr or ... */

            /* REPLACE ONLY UNKNOWN DATES, NOT USER-ENTERED DATES */
            if ar_disc_date = ? then ar_disc_date = calcd_disc_date.
            if ar_due_date  = ? then ar_due_date  = calcd_due_date.

            display ar_disc_date ar_due_date with frame b.
         end. /* if ar_disc_date = ? ... */

         if ar_ship = "" then do:
            ar_ship = ar_cust.
            display ar_ship with frame b.
         end.

         /* CHECK FOR PAYMENT */
         if ar_applied <> 0 then do:
            ardnbr = "".
            find first ard_det  where ard_det.ard_domain = global_domain and
            ard_ref = ar_nbr
               no-lock no-error.
            if available ard_det then ardnbr = ard_nbr.
            /* Modification not allowed.  Payment has been applied */
            {pxmsg.i &MSGNUM=1167 &ERRORLEVEL=2 &MSGARG1=ardnbr}
            if not batchrun then
               pause.
            next loopb.
         end.

         /* CHECK IF INVOICE */
         if ar_type = "I" then do:
            {pxmsg.i &MSGNUM=1169 &ERRORLEVEL=2}
            /* MODIFICATION TO INVOICE DISTRIBUTION NOT ALLOWED */
            if not batchrun then
               pause.
         end.

         /* CHECK FOR PRM PREPAYMENTS */
         if ar_fsm_type = "PRM" and ar_prepayment then do:
            {pxmsg.i &MSGNUM=3423 &ERRORLEVEL=3}
            /* CANNOT MODIFY DISTRIBUTION LINES */
            /* ON PRM PREPAYMENT MEMOS */
            if not batchrun then
               pause.
         end.

         /* IF CUSTOMER CHANGED, MOVE BALANCE TO NEW CUSTOMER */
         if old_cust <> ar_bill
         then do:

            /* BILL-TO MODIFIED. CERTAIN CUSTOMER DATA */
            /* WILL NOT BE UPDATED                     */
            {pxmsg.i &MSGNUM=4158 &ERRORLEVEL=2}
            if not batchrun
            then
               pause.

            run calc_base_amt in h_rules
               (- old_amt,
               buffer ar_mstr,
               buffer gl_ctrl,
               output base_amt).

            find cm_mstr  where cm_mstr.cm_domain = global_domain and  cm_addr
            = old_cust
               exclusive-lock.
            run update_cm_balance in h_rules
               (base_amt,
               buffer ar_mstr,
               buffer cm_mstr).

            run calc_base_amt in h_rules
               ((ar_amt - ar_applied),
               buffer ar_mstr,
               buffer gl_ctrl,
               output base_amt).

            find cm_mstr  where cm_mstr.cm_domain = global_domain and  cm_addr
            = ar_bill
               exclusive-lock.
            run update_cm_balance in h_rules
               (base_amt,
               buffer ar_mstr,
               buffer cm_mstr).

         end. /* if old_cust <> ar_bill */

         if ar_type = "I" then
            next loopb.

         if ar_fsm_type = "PRM" and ar_prepayment then
            next loopb.

         ar_recno = recid(ar_mstr).
         pause 0.

         undo_header = true.

         /* GET HEADER TAX DATA */
         {gprun.i ""ardrmth.p""}

         if lgData and undo_header then return.
         if undo_header then undo loopc_trans, retry.

      end. /* loopc_trans: transaction */

      /* PROCESS ALL DETAIL LINES AND TAX DISTRIBUTION LINES */
      /* SS - 20080830.1 - B */
      /*
      {gprun.i ""ardrmta.p""}
      */
      {gprun.i ""ssardrmta.p""}
      /* SS - 20080830.1 - E */

      if  available ar_mstr
      and ar_curr <> base_curr
      then
         run p_round.

      if not can-find(first ard_det
          where ard_det.ard_domain = global_domain and  ard_nbr =
          ar_mstr.ar_nbr)
         and (ar_amt - ar_applied = 0) then
            {&ARDRMT-P-TAG11}
      do transaction:
         {pxmsg.i &MSGNUM=1159 &ERRORLEVEL=2} /* DELETING REFERENCE */
         /* DEL EXCHANGE RATE USAGE (exru_usage) RECORDS */
         run delete_rate_usage_records.
         {&ARDRMT-P-TAG12}

         if ar_curr <> base_curr
         then
            run p_round.
         delete ar_mstr.
         do on endkey undo, leave:
            if not batchrun then
               pause.
         end.
      end.

      if available ar_mstr and artotal <> 0
         and artotal <> ar_amt
      then do:

         ctrldiff = artotal - ar_amt.
         /* Control: #  Distribution: #  Difference: */
         {pxmsg.i &MSGNUM=1163 &ERRORLEVEL=2
                  &MSGARG1=artotal
                  &MSGARG2=ar_amt
                  &MSGARG3=ctrldiff}

         /* MEMO CONTROL AMOUNT HAS BEEN SET TO */
         /* THE DISTRIBUTION AMOUNT.            */
         {pxmsg.i &MSGNUM = 4887 &ERRORLEVEL = 1}

         if not batchrun
         then
            pause.

      end. /* available ar_mstr */
      {&ARDRMT-P-TAG13}

      /* For Logistics, no one is at the wheel. */
      /* Leave when transaction is done. */
      if lgData then leave loopb.

   end. /* loopb */

   do transaction:
      find ba_mstr  where ba_mstr.ba_domain = global_domain and  ba_batch =
      batch
         and ba_module = bamodule
         no-error.
      if available ba_mstr then do:
         if can-find(first ar_mstr  where ar_mstr.ar_domain = global_domain and
          ar_batch = ba_batch) then do:
            if ba_ctrl <> ba_total then do:
               ba_status = "UB".       /* UNBALANCED */
               if ba_ctrl <> 0 then do:
                  {pxmsg.i &MSGNUM=1151 &ERRORLEVEL=2}
                  do on endkey undo, leave:
                     if not batchrun then
                        pause.
                  end.
               end. /* if ba_ctrl <> 0 */
            end. /* if ba_ctrl <> ba_total */
            else
               ba_status = "".         /* OPEN & BALANCED */
         end.  /* if can-find */
         else   /* EMPTY BATCH */
         assign
            ba_status = "NU"           /* NOT USED */
            ba_ctrl = 0.                /* RESET CONTROL VALUE */
         release ba_mstr.
      end. /* if available ba_mstr */
   end. /* do transaction */

   /* SS - 091014.1 - B */
   FIND FIRST arc_ctrl
      WHERE arc_domain = GLOBAL_domain
      NO-LOCK NO-ERROR.
   IF AVAILABLE arc_ctrl THEN DO:
      IF arc_sum_lvl <> 3 THEN DO TRANSACTION:
         {gprun.i ""ssgltrrefbatch.p"" "(
            INPUT 'AR',
            INPUT 'M',
            INPUT (BATCH),
            OUTPUT ref_glt,
            OUTPUT user1_glt
            )"}

         /* New reference number for document # */
         IF ref_glt <> "" THEN DO:
            {pxmsg.i &MSGNUM=5733 &ERRORLEVEL=1 &MSGARG1=ref_glt}
         END.
      END.
   END.
   /* SS - 091014.1 - E */

   /* No one is at the wheel.  Leave when done. */
   if lgData then leave mainloop.

end. /* mainloop */

status input.
delete PROCEDURE h_rules no-error.

PROCEDURE delete_rate_usage_records:

   /* DELETE EXCHANGE RATE USAGE (exru_usage) RECORDS */
   if ar_mstr.ar_exru_seq <> 0 then
   do:
      {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
         "(input ar_mstr.ar_exru_seq)"}
   end.
   if ar_mstr.ar_dd_exru_seq <> 0 then
   do:
      {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
         "(input ar_mstr.ar_dd_exru_seq)"}
   end.
END PROCEDURE.
{&ARDRMT-P-TAG14}
/* THIS PROCEDURE WILL ROUND THE BASE CURRENCY AMOUNTS AND      */
/* CALCULATE ANY ROUNDING DIFFERENCES BETWEEN DEBIT AND CREDIT  */
/* AMOUNTS OF THE MEMO LINES, WHEN MEMO IS IN FOREIGN CURRENCY  */
/* AND POST THE AMOUNT TO EXCHANGE ROUNDING ACCOUNT             */

PROCEDURE p_round:

   define variable l_dramt   like glt_amt                no-undo.
   define variable l_cramt   like glt_amt                no-undo.
   define variable l_gltline like glt_line               no-undo.
   define variable l_module  as character initial "AR" no-undo.
   define variable round_acct like acdf_acct  no-undo.
   define variable round_sub  like acdf_sub   no-undo.
   define variable round_cc   like acdf_cc    no-undo.
   define variable round_proj like glt_project no-undo.
   define variable round_desc like ac_desc     no-undo.

   for first cu_mstr
      fields(cu_rnd_mthd)
      where cu_curr = base_curr
      no-lock:
   end. /* FOR FIRST cu_mstr... */

   for each glt_det
       where glt_det.glt_domain = global_domain
       and   glt_ref = ref
      exclusive-lock:
      {gprunp.i "mcpl" "p" "mc-curr-rnd"
         "(input-output glt_amt,
           input        cu_mstr.cu_rnd_mthd,
           output       mc-error-number)"
      }

      if mc-error-number <> 0
      then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
      end. /* IF mc-error-number <> 0 */

      if glt_amt > 0
      then
         l_dramt = l_dramt + glt_amt.
      else
         l_cramt = l_cramt + glt_amt.

   end. /* FOR EACH glt_det ... */

   if absolute(l_dramt) <> absolute(l_cramt)
   then do:

      for first cm_mstr
          where cm_mstr.cm_domain = global_domain and  cm_addr = ar_mstr.ar_bill
         exclusive-lock:
      end. /* FOR FIRST cm_mstr */

      run update_cm_balance in h_rules
         ((l_dramt + l_cramt),
         buffer ar_mstr,
         buffer cm_mstr).

      for last glt_det
         fields( glt_domain glt_ref glt_line)
          where glt_det.glt_domain = global_domain
          and   glt_ref = ref
         no-lock:
            l_gltline = glt_line + 1.
      end. /* FOR LAST glt_det ... */

      for first en_mstr
         fields( en_domain en_entity en_curr)
          where en_mstr.en_domain = global_domain and  en_entity =
          ar_mstr.ar_entity
         no-lock:
      end. /* FOR FIRST en_mstr ... */

      {gprunp.i "mcrndpl" "p" "mc-ex-rounding-det"
         " (input ar_mstr.ar_curr,
            output round_acct,
            output round_sub,
            output round_cc,
            output round_proj,
            output round_desc)"}

      for first ac_mstr
         fields( ac_domain ac_code ac_desc)
          where ac_mstr.ac_domain = global_domain and  ac_code = round_acct
         no-lock:
      end. /* FOR FIRST ac_mstr .. */

      for first arc_ctrl
         fields( arc_domain arc_gl_sum)
          where arc_ctrl.arc_domain = global_domain no-lock:
      end. /* FOR FIRST arc_ctrl */

      /* DELETED PARAMETER h-nrm */
      /* CHANGED FIFTEENTH INPUT PARAMETER FROM l_ref TO ref */
      {gprunp.i "gpglpl" "p" "gpgl-create-one-glt"
         "(input ar_mstr.ar_entity,
           input ar_mstr.ar_entity,
           input round_acct,
           input round_sub,
           input round_cc,
           input """",
           input -(l_cramt + l_dramt),
           input 0,
           input ar_mstr.ar_curr,
           input en_curr,
           input ar_mstr.ar_ex_rate,
           input ar_mstr.ar_ex_rate2,
           input ar_mstr.ar_ex_ratetype,
           input ar_mstr.ar_exru_seq,
           input ref,
           input ar_mstr.ar_effdate,
           input """",
           input if available ac_mstr then ac_desc
                 else """",
           input ar_mstr.ar_po,
           input ""AR Memo"",
           input ar_mstr.ar_batch,
           input-output l_gltline ,
           input l_module,
           input arc_ctrl.arc_gl_sum,
           input false,
           input ar_mstr.ar_bill,
           input ar_mstr.ar_nbr,
           input ar_mstr.ar_type,
           input ar_mstr.ar_dy_code,
           input daybook-desc,
           input 1,
           input daybooks-in-use,
           input-output nrm-seq-num
          )"}
   end. /* IF ABS(l_dramt) <> ABS(l_cramt) */
END PROCEDURE. /* PROCEDURE p_round */
