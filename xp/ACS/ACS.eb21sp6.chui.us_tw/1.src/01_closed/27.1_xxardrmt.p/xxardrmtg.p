/* ardrmtg.p - AR DEBIT/CREDIT MEMO MAINTENANCE SUBROUTINE                   */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.15.1.18 $                                                   */
/*V8:ConvertMode=Maintenance                                                 */
/* REVISION: 8.5      LAST MODIFIED: 05/30/96   by: bxw                      */
/* REVISION: 8.5      LAST MODIFIED: 07/15/96   by: taf  *J0ZC*              */
/* REVISION: 8.6      LAST MODIFIED: 09/03/96   by: jzw  *K00B*              */
/* REVISION: 8.6      LAST MODIFIED: 09/30/96   by: *G2G2* Aruna P. Patil    */
/* REVISION: 8.6      LAST MODIFIED: 01/28/97   by: *J1FR* Robin McCarthy    */
/* REVISION: 8.6      LAST MODIFIED: 03/06/97   by: *K06X* E. Hughart        */
/* REVISION: 8.6      LAST MODIFIED: 04/17/97   by: *J1P8* Robin McCarthy    */
/*                                   05/05/97   by: *K0CX* E. Hughart        */
/* REVISION: 8.6      LAST MODIFIED: 07/09/97   by: *H1BQ* Irine D'mello     */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan        */
/* REVISION: 8.6E     LAST MODIFIED: 06/02/98   BY: *L01K* Jaydeep Parikh    */
/* REVISION: 8.6E     LAST MODIFIED: 01/15/99   BY: *J38H* Hemali Desai      */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Jeff Wootton      */
/* REVISION: 9.1      LAST MODIFIED: 10/22/99   BY: *N04P* Robert Jensen     */
/* REVISION: 9.1      LAST MODIFIED: 01/19/00   BY: *N077* Vijaya Pakala     */
/* REVISION: 9.1      LAST MODIFIED: 02/23/00   BY: *L0S2* Sandeep Rao       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn               */
/* REVISION: 9.1      LAST MODIFIED: 09/22/00   BY: *N0VV* Mudit Mehta       */
/* Old ECO marker removed, but no ECO header exists *F0PN*                   */
/* Revision: 1.15.1.12 BY: Vihang Talwalkar     DATE: 10/22/01  ECO: *P01V*  */
/* Revision: 1.15.1.13 BY: Saurabh C.           DATE: 05/05/02  ECO: *M1Y7*  */
/* Revision: 1.15.1.14 BY: Orawan S.          DATE: 05/08/03  ECO: *P0RJ*  */
/* Old ECO marker removed, but no ECO header exists *GM57*                */
/* Revision: 1.15.1.16  BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00B* */
/* Revision: 1.15.1.17  BY: Ed van de Gevel DATE: 08/05/03 ECO: *Q00R* */
/* $Revision: 1.15.1.18 $ BY: Abhishek Jha DATE: 11/22/04 ECO: *P2VK* */
/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 110114.1  By: Roger Xiao */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{cxcustom.i "ARDRMTG.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE ardrmtg_p_1 "Batch"
/* MaxLen: Comment: */

&SCOPED-DEFINE ardrmtg_p_2 "Memo Control"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

{gldydef.i}
{gldynrm.i}

/* DEFINE VARIABLES FOR GPGLEF.P (GL CALENDAR VALIDATION) */
{gpglefdf.i}

{xxgpdescm1.i  }     /* SS - 110114.1 */


define variable undo_exch             as logical       no-undo.
define variable undo_dybk             as logical       no-undo.
define variable mc-error-number       like msg_nbr     no-undo.
define variable fixed_rate            like mfc_logical no-undo.

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
define shared variable batch          like ar_batch
   label {&ardrmtg_p_1}.
define shared variable artotal        like ar_amt
   label {&ardrmtg_p_2}.
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
define shared variable action         as character
   initial "2" format "x(1)".
define shared variable valid_acct     like mfc_logical initial no.
define shared variable firstpass      like mfc_logical.
define shared variable tax_tr_type    like tx2d_tr_type initial "18".
define shared variable tax_nbr        like tx2d_nbr initial "".
define shared variable ctrldiff       like ar_amt.
define shared variable old_sold       like ar_cust no-undo.
define variable entity_ok             like mfc_logical no-undo.

{&ARDRMTG-P-TAG3}
/* Logistics tables */
{lgardefs.i &type = "lg"}

{ardrfmb.i}

/* GET ENTITY SECURITY INFORMATION */
{glsec.i}

find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock no-error.

find first ar_mstr
   where recid(ar_mstr) = ar1_recno
   no-error.

do with frame b:

   /* cm_site IS ASSIGNED TO ar_shipfrom */
   if (ar_type = "M"
      or ar_type = "F")
   then do:
      if new ar_mstr
      then do:
         for first cm_mstr
            fields( cm_domain cm_site)
             where cm_mstr.cm_domain = global_domain and  cm_addr = ar_bill
            no-lock:
            ar_shipfrom = cm_site.
         end. /* FOR FIRST cm_mstr */
      end. /* IF NEW ar_mstr */

      display ar_shipfrom with frame b.
   end. /* IF ar_type = "M" OR "F" */

   /* ALLOW UPDATE OF REMAINING VARIABLES IN FRAME */
   sete:
   do on error undo, retry:

      /* IF NOT LOGISTICS, PROCESS NORMALLY */
      if not lgData
      then do:
         set
            artotal
            ar_sales_amt
            ar_cr_term
            ar_disc_date
            ar_due_date
            ar_expt_date
            /** ar_po  ** SS - 110114.1 */
            {&ARDRMTG-P-TAG4}
            ar_slspsn[1]   when (ar_type <> "I")
            ar_comm_pct[1] when (ar_type <> "I")
            ar_slspsn[2]   when (ar_type <> "I")
            ar_comm_pct[2] when (ar_type <> "I")
            ar_slspsn[3]   when (ar_type <> "I")
            ar_comm_pct[3] when (ar_type <> "I")
            ar_slspsn[4]   when (ar_type <> "I")
            ar_comm_pct[4] when (ar_type <> "I")
            ar_dun_level
            ar_acct when (new ar_mstr)
            ar_sub when (new ar_mstr)
            ar_cc when (new ar_mstr)
            ar_entity when (new ar_mstr)
            ar_cust
            ar_ship
            ar_contested
            ar_shipfrom when (ar_type = "M" or ar_type = "F").
      end. /* if not lgData */

      /* ELSE SET THE LOGISTICS INPUTS */
      else run SetLogData.

      /*  DO NOT ALLOW MODIFICATION OF SOLD-TO CUSTOMER */
      /*  IF TRANSACTION HISTORY EXISTS                 */
      if not new ar_mstr
         and ar_cust <> old_sold
      then do:
         {&ARDRMTG-P-TAG1}
         find first tr_hist
             where tr_hist.tr_domain = global_domain and  tr_addr = old_sold
            and   tr_nbr  = ar_so_nbr
            and   tr_type = "ISS-SO"
            no-lock no-error.
         {&ARDRMTG-P-TAG2}
         if available tr_hist
         then do:
            /* CAN'T MODIFY CUSTOMER, TR_HIST EXISTS */
            {pxmsg.i &MSGNUM=3040 &ERRORLEVEL=3}
            if lgData
            then
               return.
            ar_cust = old_sold.
            display
               ar_cust
            with frame b.
            next-prompt ar_cust.
            undo sete, retry.
         end. /* IF AVAILABLE tr_hist */
      end. /* IF NOT NEW ar_mstr ... */

      if (artotal <> 0)
      then do:
         {gprun.i ""gpcurval.p"" "(input  artotal,
                                   input  rndmthd,
                                   output retval)"}

         if retval <> 0
         then do:
            if lgData
            then
               return.
            undo sete, retry sete.
         end.
      end.

      /* CODE REMOVED FROM HERE AND MOVED BELOW */

      if (ar_sales_amt <> 0)
      then do:
         {gprun.i ""gpcurval.p"" "(input  ar_sales_amt,
                                   input  rndmthd,
                                   output retval)"}
         if retval <> 0
         then do:
            if lgData
            then
               return.
            next-prompt ar_sales_amt.
            undo sete, retry sete.
         end.
      end.

      /* GET EXCHANGE RATE IF NEW NON-BASE MEMO */
      if new ar_mstr
      then do:
         assign
            ar_ex_rate  = 1
            ar_ex_rate2 = 1.
         if base_curr <> ar_curr
         then do:
            /* EXCHANGE RATE CHECK MADE ONLY */
            /* VALIDATE EXCHANGE RATE        */

            /* GET EXCHANGE RATE AND ALSO CREATE THE  */
            /* RATE USAGE RECORD IF TRIANGULATED RATE */
            {gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
                                 "(input ar_curr,
                                   input base_curr,
                                   input ar_ex_ratetype,
                                   input ar_effdate,
                                   output ar_ex_rate,
                                   output ar_ex_rate2,
                                   output ar_exru_seq,
                                   output mc-error-number)"}
            if mc-error-number <> 0
            then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
               if lgData
               then
                  return.
               undo, retry.
            end.

            /* ACCOUNT MUST EITHER BE BASE  */
            /* OR EQUAL TO VOUCHER CURRENCY */
            find ac_mstr  where ac_mstr.ac_domain = global_domain and  ac_code
            = ar_acct
               no-lock no-error.
            if available ac_mstr
               and ac_curr <> ar_curr
               and ac_curr <> base_curr
            then do:
               {pxmsg.i &MSGNUM=134 &ERRORLEVEL=3}
               /* ACCT CURRENCY MUST MATCH     */
               /* TRANSACTION OR BASE CURRENCY */
               if lgData
               then
                  return.
               next-prompt
                  ar_acct
               with frame b.
               undo sete, retry.
            end. /* if available ac_mstr */
         end. /* if base_curr <> ar_curr */
      end. /* if new ar_mstr */

      if ar_cr_terms > ""
      then do:
         find ct_mstr
             where ct_mstr.ct_domain = global_domain and  ct_code = input
             ar_cr_terms
            no-lock no-error.
         if not available ct_mstr
         then do:
            {pxmsg.i &MSGNUM=619 &ERRORLEVEL=3}
            if lgData
            then
               return.
            next-prompt
               ar_cr_terms
            with frame b.
            undo sete, retry.
         end.
      end. /* if ar_cr_terms */

      {&ARDRMTG-P-TAG5}
      do counter = 1 to 4:
         if ar_slspsn[counter] > ""
         then do:
            find sp_mstr
                where sp_mstr.sp_domain = global_domain and  sp_addr = input
                ar_slspsn[counter]
               no-lock no-error.
            if not available sp_mstr
            then do:
               {pxmsg.i &MSGNUM=612 &ERRORLEVEL=3}
               if lgData
               then
                  return.
               next-prompt
                  ar_slspsn[counter]
               with frame b.
               undo sete, retry.
            end.
         end. /* if ar_slsprsn */
      end. /* do counter */

      /* INITIALIZE SETTINGS */
      {gprunp.i "gpglvpl" "p" "initialize"}

      /* SET PROJECT VERIFICATION TO NO */
      {gprunp.i "gpglvpl" "p" "set_proj_ver" "(input false)"}

      /* ACCT/SUB/CC VALIDATION */
      {gprunp.i "gpglvpl" "p" "validate_fullcode"
                              "(input  ar_acct,
                                input  ar_sub,
                                input  ar_cc,
                                input  """",
                                output valid_acct)"}
      if not valid_acct
      then do:
         if lgData
         then
            return.
         next-prompt
            ar_acct
         with frame b.
         undo, retry.
      end.

      /* VERIFY ENTITY*/
      if new ar_mstr
      then do:
         find en_mstr
             where en_mstr.en_domain = global_domain and  en_entity =
             ar_entity
            no-lock no-error.
         if not available en_mstr
         then do:
            {pxmsg.i &MSGNUM=3061 &ERRORLEVEL=3}  /*INVALID ENTITY*/
            if lgData
            then
               return.
            next-prompt
               ar_entity
            with frame b.
            undo, retry.
         end.
         else if en_consolidation then do:
            /* Consolidation entity */
            {pxmsg.i &MSGNUM=6183 &ERRORLEVEL=3}
            if lgData then return.
            else next-prompt ar_entity with frame b.
            undo, retry.
         end. /* if en_consolidation */
      end.

      /* CHECK ENTITY SECURITY */
      {glenchk.i &entity=ar_entity &entity_ok=entity_ok}
      if not entity_ok
      then do:
         if lgData
         then
            return.
         next-prompt
            ar_entity
         with frame b.
         undo, retry.
      end.

      /* VERIFY GL CALENDAR FOR SPECIFIED ENTITY */
      if new ar_mstr
      then do:
         /* CHANGED &loop FROM SETC TO SETE*/
         {gpglef02.i &module = ""AR""
                     &entity = ar_entity
                     &date   = ar_effdate
                     &prompt = "ar_entity"
                     &frame  = "b"
                     &loop   = "sete"}
      end.

      if (ar_type = "M"
         or ar_type = "F")
      then do:
         if not can-find(first ls_mstr
                                  where ls_mstr.ls_domain = global_domain and
                                  ls_addr = ar_shipfrom
                                 and   ls_type = "company")
         then do:
            /* NOT A VALID COMPANY */
            {pxmsg.i &MSGNUM=28 &ERRORLEVEL=3}
            next-prompt ar_shipfrom with frame b.
            undo sete, retry sete.
         end. /* IF NOT CAN-FIND FIRST ls_mstr */

      end. /* IF ar_type = "M" OR "F" */

    /* SS - 110114.1 - B */
    {gprun.i ""xxgpdescm.p""
        "(input        frame-row(b) + 2,
          input-output ar_po)"}
    if keyfunction(lastkey) = "end-error" or keyfunction(lastkey) = "." then undo sete, retry.     

    {xxgpdescm2.i &table=ar_mstr &desc=ar_po}
    
    
    disp ar_po with frame b .
    /* SS - 110114.1 - E */

      /* DAYBOOK VALIDATION */
      if daybooks-in-use and new ar_mstr
      then do:
         {gprun.i ""gldydft.p"" "(input  ""AR"",
                                  input  ar_type,
                                  input  ar_entity,
                                  output dft-daybook,
                                  output daybook-desc)"}
         ar_dy_code = dft-daybook.
         display
            ar_dy_code
         with frame b.

         setdy:
         do on error undo, retry:
            undo_dybk = yes.
            if not lgData
            then
               set
                  ar_dy_code
               with frame b.

            if not can-find(dy_mstr  where dy_mstr.dy_domain = global_domain
            and  dy_dy_code = input ar_dy_code)
            then do:
               /* ERROR: INVALID DAYBOOK */
               {pxmsg.i &MSGNUM=1299 &ERRORLEVEL=3}
               if lgData
               then
                  return.
               next-prompt
                  ar_dy_code
               with frame b.
               undo setdy, retry setdy.
            end.
            else do:
               {gprun.i ""gldyver.p"" "(input  ""AR"",
                                        input  ar_type,
                                        input  input ar_dy_code,
                                        input  ar_entity,
                                        output daybook-error)"}
               if daybook-error
               then do:
                  /* WARNING: DAYBOOK DOES NOT MATCH ANY DEFAULT */
                  {pxmsg.i &MSGNUM=1674 &ERRORLEVEL=2}
                  if not batchrun
                  then
                     pause.
               end.
               {gprunp.i "nrm" "p" "nr_can_dispense"
                  "(input ar_mstr.ar_dy_code,
                    input ar_effdate)" }
               {gprunp.i "nrm" "p" "nr_check_error"
                  "(output daybook-error,
                    output return_int)"}
               if daybook-error
               then do:
                  {pxmsg.i &MSGNUM = return_int &ERRORLEVEL=3}
                  next-prompt
                     ar_dy_code
               with frame b.
               undo setdy, retry setdy.
               end. /* IF daybook-error  */
            end.
            undo_dybk = no.
         end.  /* SETDY */
      end.  /* IF DAYBOOKS IN USE */

      undo_exch = no.

      /*SET EXCHANGE RATE*/
      if new ar_mstr
         and ar_curr <> base_curr
      then
         setc_sub:
         do on error undo, retry:
            undo_exch = yes.

            /* PROCEDURE mc-ex-rate-input IN PLACE OF INPUT FRAME */
            /* setc_sub TO PROMPT THE USER FOR EXCHANGE RATE      */

            {gprunp.i "mcui" "p" "mc-ex-rate-input"
                                 "(input        ar_curr,
                                   input        base_curr,
                                   input        ar_effdate,
                                   input        ar_exru_seq,
                                   input        false, /* DO NOT ASK FOR */
                                                       /* Fixed (Y/N)    */
                                   input        frame b:row + 4,
                                   input-output ar_ex_rate,
                                   input-output ar_ex_rate2,
                                   input-output fixed_rate)"}

         if mc-error-number <> 0
         then do:
            {pxmsg.i &MSGNUM=999 &ERRORLEVEL=3} /*INVALID RATE*/
            if lgData
            then
               return.
            undo setc_sub, retry.
         end.

         if ar_ex_rate = 0
            or ar_ex_rate2 = 0
         then do:
            {pxmsg.i &MSGNUM=317 &ERRORLEVEL=3} /*ZERO NOT ALLOWED*/
            if lgData
            then
               return.
            undo setc_sub, retry.
         end.

         undo_exch = no.
      end. /* setc_sub */

      if undo_exch = no
         and undo_dybk = no
      then
         undo_header = no.
   end. /* sete */
end. /* do with frame b */

/* NEW PROCEDURE TO GET LOGISTICS DATA INTO THE MEMO */
PROCEDURE SetLogData:
   for first lgm_lgmstr no-lock:
      assign
         artotal = lgm_ar_amt
         ar_mstr.ar_cr_term = lgm_ar_cr_term when (lgm_ar_cr_term <> "").
      if lgm_ar_disc_date <> date("")
      then
         ar_disc_date = lgm_ar_disc_date.
      if lgm_ar_due_date <> date("")
      then
         ar_due_date = lgm_ar_due_date.
      if lgm_ar_entity <> ""
      then
         ar_entity = lgm_ar_entity.
      if lgm_ar_comm_pct[1] >= 0
         or lgm_ar_comm_pct[2] >= 0
         or lgm_ar_comm_pct[3] >= 0
         or lgm_ar_comm_pct[4] >= 0
      then
         assign
            ar_slspsn[1]   = lgm_ar_slspsn[1]
            ar_slspsn[2]   = lgm_ar_slspsn[2]
            ar_slspsn[3]   = lgm_ar_slspsn[3]
            ar_slspsn[4]   = lgm_ar_slspsn[4]
            ar_comm_pct[1] = if lgm_ar_comm_pct[1] >= 0
                             then lgm_ar_comm_pct[1]
                             else 0
            ar_comm_pct[2] = if lgm_ar_comm_pct[2] >= 0
                             then lgm_ar_comm_pct[2]
                             else 0
            ar_comm_pct[3] = if lgm_ar_comm_pct[3] >= 0
                             then lgm_ar_comm_pct[3]
                             else 0
            ar_comm_pct[4] = if lgm_ar_comm_pct[4] >= 0
                             then lgm_ar_comm_pct[4]
                             else 0.

      /* REFRESH DISPLAY TO GET THE NEW VALUES INTO THE */
      /* SCREEN BUFFER */
      display
         ar_cr_terms
         ar_disc_date
         ar_due_date
         ar_entity
         ar_slspsn[1]
         ar_slspsn[2]
         ar_slspsn[3]
         ar_slspsn[4]
         ar_comm_pct[1]
         ar_comm_pct[2]
         ar_comm_pct[3]
         ar_comm_pct[4]
      with frame b.
   end.
END PROCEDURE.
