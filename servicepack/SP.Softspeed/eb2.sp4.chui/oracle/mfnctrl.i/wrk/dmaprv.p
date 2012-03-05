/* dmaprv.p - DRAFT MANAGEMENT--CANCEL DRAFT APPROVAL                         */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.33 $                                           */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.0      LAST MODIFIED: 09/04/91   BY: jms   *F065*              */
/*                                   03/16/92   BY: jjs   *F198*              */
/*                                                 (major re-write)           */
/*                                   03/23/92   BY: jjs   *F310*              */
/* REVISION: 7.3      LAST MODIFIED: 09/27/93   BY: jcd   *G247*              */
/*                                   11/05/92   BY: jjs   *G279*              */
/*                                   11/05/92   BY: jjs   *G280*              */
/* REVISION: 7.4      LAST MODIFIED: 07/22/93   BY: pcd   *H051*              */
/*                                   08/24/94   BY: rxm   *GL40*              */
/*                                   10/05/94   BY: srk   *FS11*              */
/*                                   12/12/94   BY: str   *FU30*              */
/*                                   05/11/95   by: wjk   *F0RH*              */
/*                                   12/19/95   by: mys   *G1H1*              */
/* REVISION: 8.5      LAST MODIFIED: 12/12/95   BY: taf   *J053*              */
/* REVISION: 8.6      LAST MODIFIED: 06/14/96   BY: BJL   *K001*              */
/* REVISION: 8.5      LAST MODIFIED: 07/29/96   BY: taf   *J101*              */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton       */
/* REVISION: 8.6E     LAST MODIFIED: 06/11/98   BY: *L01K* Jaydeep Parikh     */
/* REVISION: 9.0      LAST MODIFIED: 11/30/98   BY: *M00P* Jeff Wootton       */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Paul Johnson       */
/* REVISION: 9.1      LAST MODIFIED: 06/29/99   BY: *N00D* Adam Harris        */
/* REVISION: 9.1      LAST MODIFIED: 08/13/99   BY: *N01L* Adam Harris        */
/* REVISION: 9.1      LAST MODIFIED: 01/27/00   BY: *M0J4* Jose Alex          */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 06/21/00   BY: *N0DB* Rajinder Kamra     */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn                */
/* REVISION: 9.1      LAST MODIFIED: 10/18/00   BY: *N0WP* Mudit Mehta        */
/* REVISION: 9.0      LAST MODIFIED: 01/08/01   BY: *N0X7* Shilpa Athalye     */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.31     BY: Vinod Nair          DATE: 04/17/01 ECO: *M152*      */
/* Revision: 1.32     BY: Kirti Desai         DATE: 02/20/02 ECO: *N19Q*      */
/* $Revision: 1.33 $       BY: Manjusha Inglay     DATE: 07/29/02 ECO: *N1P4*      */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE */
{mfdtitle.i "2+ "}
{cxcustom.i "DMAPRV.P"}

define variable mc-error-number like msg_nbr no-undo.

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE dmaprv_p_1 "Print Audit Trail"
/* MaxLen: Comment: */

{&DMAPRV-P-TAG1}

/* ********** End Translatable Strings Definitions ********* */

/* ADDED FOLLOWING PREPROCESSOR CONSTANT SECTION */

&SCOPED-DEFINE detailed_journals 1
&SCOPED-DEFINE summarized_journals 2
&SCOPED-DEFINE one_tran_per_doc 3

/* END OF ADDED SECTION */

{gldydef.i new}
{gldynrm.i new}

/* NOTE: mfrpchk.i was not added to this program because the report can */
/*       only be generated at the time the gl tranactions occur.        */

define new shared variable rndmthd like rnd_rnd_mthd.
define new shared variable jrnl like glt_ref.
define new shared variable ref like glt_ref.
define new shared variable rev_effdate like ar_effdate.
define new shared variable ar_recno as recid.
define new shared variable ardbuff_recno as recid.
define new shared variable arbuff_recno as recid.
define new shared variable base_amt like ar_amt.
define new shared variable base_det_amt like ar_amt.
define new shared variable disc_amt like ar_amt.
define new shared variable curr like ar_curr.
define new shared variable curr_amt like ar_amt.
define new shared variable curr_disc like ar_amt.
define new shared variable gltline like glt_line.
define new shared variable ard_recno as recid.
define new shared variable mstrdesc like ard_desc.
define new shared variable audit_yn like mfc_logical
   label {&dmaprv_p_1} initial yes.
/* THE NEXT 2 VARIABLES ARE NEEDED FOR DMDMGL1.P AND DMGL.I */

define new shared variable summary like arc_sum_lvl initial 2.
define new shared variable gendesc like ard_desc.

define new shared variable draft_batch like ar_batch.

define variable oldsession as character.
define variable ar_amt_old as character.
define variable ar_amt_fmt as character.
define variable bank like bk_code.
define variable yes-no like mfc_logical.
define variable disc_ex_rate like ar_ex_rate.
define variable disc_ex_rate2 like ar_ex_rate2.
define variable disc_ex_ratetype like ar_ex_ratetype.
define variable disc_exru_seq like ar_exru_seq.
define variable disc_effdate like ar_effdate.

define variable disc_curr like ar_curr.
define variable nbr like ar_nbr format "x(8)".
define variable rpt_name like ad_name.
define variable rpt_title as character format "x(40)".
define variable somethingreversed like mfc_logical.
{&DMAPRV-P-TAG2}

define buffer arddet for ard_det.
define buffer armstr for ar_mstr.

{gpglefdf.i}

assign gendesc = getTermLabel("DRAFT_APPROVAL_REVERSAL",24).

/* DEFINE FORMS */

{&DMAPRV-P-TAG3}
form
   nbr       colon 17  ar_bill      colon 49
   cm_sort at 51 no-label
   rev_effdate  colon 17  ar_date      colon 49
   ar_due_date  colon 17  ar_expt_date colon 49
   ar_amt       colon 17  ar_curr no-label
with frame b side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).
{&DMAPRV-P-TAG4}

ar_amt_old = ar_amt:format.
oldsession = SESSION:numeric-format.

/* READ CONTROL FILES */
find first gl_ctrl no-lock.
rev_effdate = today.

/* DELETE ANY EXISTING gltw_wkfl RECORDS */
for each gltw_wkfl
   where gltw_userid = mfguser
   exclusive-lock:
   delete gltw_wkfl.
end. /* FOR EACH gltw_wkfl... */

main1:
repeat:
   somethingreversed = false.

   view frame b.
   mainloop:
   repeat with frame b:
      {&DMAPRV-P-TAG23}
      do transaction with frame b:
         /* ENTER DRAFT NUMBER */
         update nbr
         editing:
            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp07.i ar_mstr nbr ar_nbr ""D"" ar_type
               true ar_open true ar_draft ar_nbr}
            if recno <> ? then do:

               if ar_curr = gl_base_curr then
                  rndmthd = gl_rnd_mthd.
               else do:
                  /* GET ROUNDING METHOD FROM CURRENCY MASTER */
                  {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                     "(input ar_curr,
                       output rndmthd,
                       output mc-error-number)"}
                  if mc-error-number <> 0 then do:
                     {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
                     undo mainloop, retry.
                  end.
               end.

               /* DETERMINE CURRENCY DISPLAY AMERICAN OR EUROPEAN    */
               find rnd_mstr where rnd_rnd_mthd = rndmthd
                  no-lock no-error.
               if not available rnd_mstr then do:
                  {pxmsg.i &MSGNUM=863 &ERRORLEVEL=3}
                  /* ROUND METHOD RECORD NOT FOUND */
                  undo mainloop, retry.
               end.
               /* IF RND_DEC_PT = COMMA FOR DECIMAL POINT */
               /* THIS IS A EUROPEAN STYLE CURRENCY */
               if (rnd_dec_pt = "," )
                  then SESSION:numeric-format = "European".
               else SESSION:numeric-format = "American".

               ar_amt_fmt = ar_amt_old.
               {gprun.i ""gpcurfmt.p"" "(input-output ar_amt_fmt,
                                                input rndmthd)"}
               ar_amt:format = ar_amt_fmt.

               {&DMAPRV-P-TAG5}
               display ar_nbr @ nbr ar_bill
                  rev_effdate ar_date
                  ar_amt ar_curr
                  ar_due_date ar_expt_date
               with frame b.
               find cm_mstr where cm_addr = ar_bill no-lock no-error.
               if available cm_mstr then display cm_sort with frame b.
               else display " " @ cm_sort with frame b.
            end.  /* RECNO <> ? */
         end. /* EDITING */

         /* GET DRAFT RECORD */
         find ar_mstr where ar_nbr = nbr no-error.
         if not available ar_mstr then do:
            {pxmsg.i &MSGNUM=3500 &ERRORLEVEL=3}  /* DRAFT NOT FOUND */
            undo mainloop.
         end.
         if ar_type <> "D" then do:
            {pxmsg.i &MSGNUM=3502 &ERRORLEVEL=3} /* RECORD IS NOT A DRAFT */
            undo mainloop.
         end.
         if not ar_draft and ar_open then do:
            {pxmsg.i &MSGNUM=3506 &ERRORLEVEL=3} /* DRAFT NOT YET APPROVED */
            undo mainloop.
         end.
         if not ar_open then do:
            {pxmsg.i &MSGNUM=3508 &ERRORLEVEL=3} /* DRAFT IS NO LONGER OPEN */
            undo mainloop.
         end.
         if ar_applied <> 0 then do:
            {pxmsg.i &MSGNUM=3510 &ERRORLEVEL=3} /* CANNOT REVERSE APPROVAL ON
                                                    PARTIALLY PAID DRAFT */
            undo mainloop.
         end.
         {&DMAPRV-P-TAG6}

         if ar_curr = gl_base_curr then
            rndmthd = gl_rnd_mthd.
         else do:
            /* GET ROUNDING METHOD FROM CURRENCY MASTER */
            {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
               "(input ar_curr,
                 output rndmthd,
                 output mc-error-number)"}
            if mc-error-number <> 0 then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
               undo mainloop, retry.
            end.
         end.

         /* DETERMINE CURRENCY DISPLAY AMERICAN OR EUROPEAN    */
         find rnd_mstr where rnd_rnd_mthd = rndmthd
            no-lock no-error.
         if not available rnd_mstr then do:
            {pxmsg.i &MSGNUM=863 &ERRORLEVEL=3}
            /* ROUND METHOD RECORD NOT FOUND */
            undo mainloop, retry.
         end.
         /* IF RND_DEC_PT = COMMA FOR DECIMAL POINT */
         /* THIS IS A EUROPEAN STYLE CURRENCY */
         if (rnd_dec_pt = "," )
            then SESSION:numeric-format = "European".
         else SESSION:numeric-format = "American".

         ar_amt_fmt = ar_amt_old.
         {gprun.i ""gpcurfmt.p"" "(input-output ar_amt_fmt,
                                   input rndmthd)"}
         ar_amt:format = ar_amt_fmt.

         {&DMAPRV-P-TAG7}
         /* DISPLAY RECORD */
         display ar_nbr @ nbr ar_bill
            rev_effdate ar_date
            ar_amt ar_curr
            ar_due_date ar_expt_date
         with frame b.
         find cm_mstr where cm_addr = ar_bill no-lock no-error.
         if available cm_mstr then display cm_sort with frame b.
         else display " " @ cm_sort with frame b.

         loopc:
         do on error undo, retry:
            update rev_effdate with frame b.

            /* CHECK EFFECTIVE DATE AGAINST GL CALENDAR */
            if available gl_ctrl and gl_verify = yes then do:
               {&DMAPRV-P-TAG8}

               /* CHANGED FIRST PARAMETER FROM 'AP' TO 'AR' AND */
               /* SECOND PARAMETER FROM glentity TO ar_entity   */
               {gpglef.i ""AR"" ar_entity rev_effdate "mainloop"}
               {&DMAPRV-P-TAG9}
            end.
         end.  /* LOOPC */
         {&DMAPRV-P-TAG10}

         /* VERIFY REVERSAL OF APPROVAL */
         yes-no = no.
         {mfmsg01.i 3507 1 yes-no} /* CONTINUE WITH REVERSAL
                                      OF APPROVAL? */
         if not yes-no then undo mainloop.

      end.   /* TRANSACTION */

      {&DMAPRV-P-TAG24}
      somethingreversed = true.
      /* REVERSE THE DRAFT */
      do transaction:
         {&DMAPRV-P-TAG11}
         /* GET NEXT JOURNAL REFERENCE NUMBER  */
         {mfnctrl.i arc_ctrl arc_jrnl glt_det glt_ref jrnl}
         /* GET JOURNAL ENTRY REFERENCE NUMBER */
         /* JRNL IS CONVERTED TO AN INTEGER IN ORDER TO GET */
         /* THE CORRECT 6 CHARACTER FORMAT                  */
         ref = "AR" + substring(string(year(today),"9999"),3,2)
                    + string(month(today),"99")
                    + string(day(today),"99")
                    + string(integer(jrnl),"999999").

         mstrdesc = getTermLabel("REVERSAL_OF_DRAFT",15) + " " + ar_nbr.
         gendesc = mstrdesc.
         {&DMAPRV-P-TAG12}

         ar_recno = recid(ar_mstr).

         assign
            disc_ex_rate = ar_dd_ex_rate
            disc_ex_rate2 = ar_dd_ex_rate2
            disc_curr = ar_dd_curr
            disc_effdate = ar_tax_date.

         /* REVERSE DISCOUNTING OF DRAFT */
         /* CASH AMOUNT */
         find first ard_det where ard_ref = ar_nbr and ard_type = "C1"
            no-error.
         if available ard_det then do:

            /* CONVERT INTO BASE */
            /* THE ENTIRE DRAFT AMOUNT SHOULD BE BACKED OUT OF THE   */
            /* CASH ACCOUNT.  THIS IS WHAT THE BANK IS GOING TO TAKE */
            /* REGARDLESS OF HOW MUCH CASH WAS ACTUALLY RECEIVED.    */
            base_amt = - (ar_amt - ar_applied).
            curr_amt = - (ar_amt - ar_applied).
            if disc_curr <> base_curr then do:

               /* CONVERT FROM FOREIGN TO BASE CURRENCY */
               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input disc_curr,
                    input base_curr,
                    input disc_ex_rate,
                    input disc_ex_rate2,
                    input base_amt,
                    input true, /* ROUND */
                    output base_amt,
                    output mc-error-number)"}.
               if mc-error-number <> 0 then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}.
               end.

            end.

            gltline = 0.
            if ar_dy_code > "" then do:
               find first dy_mstr where dy_dy_code = ar_dy_code
                  no-lock no-error.
               daybook-desc = if available dy_mstr then dy_desc else "".
            end. /* if ar_dy_code > "" */

            /* CHANGED true TO {&summarized_journals} FOR sum_lvl */
            /* CHANGED {&summarized_journals} TO {&detailed_journals}  */
            /* DELETED PARAMETER h-nrm                                 */
            {gprunp.i "gpglpl" "p" "gpgl-create-one-glt"
               "(input ar_entity, /* entity for GL transaction */
                 input ar_entity, /* entity to compare to en_entity */
                 input ard_acct, /* acct */
                 input ard_sub, /* sub-account */
                 input ard_cc,
                 input """", /* project */
                 input base_amt,
                 input curr_amt,
                 input disc_curr, /* currency for GL transaction */
                 input disc_curr, /* currency to compare to en_curr */
                 input disc_ex_rate,
                 input disc_ex_rate2,
                 input disc_ex_ratetype,
                 input disc_exru_seq,
                 input ref,
                 input rev_effdate,
                 input """", /* match glt_desc */
                 input mstrdesc, /* desc */
                 input """", /* mstr_desc */
                 input """", /* gen_desc */
                 input """", /* batch */
                 input-output gltline,
                 input ""AR"", /* module */
                 input {&detailed_journals}, /* sum_lvl */
                 input true, /* audit */
                 input ar_bill, /* addr */
                 input ar_nbr, /* docnbr */
                 input ar_type, /* doctype */
                 input ar_dy_code,
                 input daybook-desc,
                 input 2, /* variant = old gpgltdet.i */
                 input daybooks-in-use,
                 input-output nrm-seq-num
                 )"}.

            {&DMAPRV-P-TAG13}
            ar_open = false.      /* VOID DRAFT */
            {&DMAPRV-P-TAG14}
         end.

         /* BANK CLEARING AMOUNT */

         find first ard_det where ard_ref = ar_nbr and ard_type = "C3"
            no-error.
         if available ard_det then do:

            /* CONVERT INTO BASE */
            /* THE NEGATIVE WILL CONVERT THE ARD_AMT TO A POSITIVE.  */
            /* IT IS STORED AS A NEGATIVE.                           */
            base_amt = - ard_amt.
            curr_amt = - ard_amt.
            if disc_curr <> base_curr then do:

               /* CONVERT FROM FOREIGN TO BASE CURRENCY */
               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input disc_curr,
                    input base_curr,
                    input disc_ex_rate,
                    input disc_ex_rate2,
                    input base_amt,
                    input true, /* ROUND */
                    output base_amt,
                    output mc-error-number)"}.
               if mc-error-number <> 0 then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}.
               end.

            end.

            gltline = 0.

            if ar_dy_code > "" then do:
               find first dy_mstr where dy_dy_code = ar_dy_code
                  no-lock no-error.
               daybook-desc = if available dy_mstr then dy_desc else "".
            end. /* if ar_du_code > "" */

            /* CHANGED true TO {&summarized_journals} FOR sum_lvl */
            /* CHANGED {&summarized_journals} TO {&detailed_journals}  */
            /* DELETED PARAMETER h-nrm                                 */
            {gprunp.i "gpglpl" "p" "gpgl-create-one-glt"
               "(input ar_entity, /* entity for GL transaction */
                 input ar_entity, /* entity to compare to en_entity */
                 input ard_acct, /* acct */
                 input ard_sub, /* sub-account */
                 input ard_cc,
                 input """", /* project */
                 input base_amt,
                 input curr_amt,
                 input disc_curr, /* currency for GL transaction */
                 input disc_curr, /* currency to compare to en_curr */
                 input disc_ex_rate,
                 input disc_ex_rate2,
                 input disc_ex_ratetype,
                 input disc_exru_seq,
                 input ref,
                 input rev_effdate,
                 input """", /* match glt_desc */
                 input mstrdesc, /* desc */
                 input """", /* mstr_desc */
                 input """", /* gen_desc */
                 input """", /* batch */
                 input-output gltline,
                 input ""AR"", /* module */
                 input {&detailed_journals}, /* sum_lvl */
                 input true, /* audit */
                 input ar_bill, /* addr */
                 input ar_nbr, /* docnbr */
                 input ar_type, /* doctype */
                 input ar_dy_code,
                 input daybook-desc,
                 input 2, /* variant = old gpgltdet.i */
                 input daybooks-in-use,
                 input-output nrm-seq-num
                 )"}.

            {&DMAPRV-P-TAG15}
            ar_open = false.      /* VOID DRAFT */
            {&DMAPRV-P-TAG16}
         end.

         {&DMAPRV-P-TAG17}
         if ar_dy_code > ""
         then do:
            assign
               dft-daybook = ar_dy_code.

            for first dy_mstr
               fields(dy_dy_code dy_desc)
               where dy_dy_code = ar_dy_code
               no-lock:
            end. /* FOR FIRST DY_MSTR */
            if available dy_mstr
               then
            assign
               daybook-desc = dy_desc.
         end. /* IF AR_DY_CODE > "" */

         /* CYCLE THROUGH INVOICES ATTACHED TO DRAFT */
         /* REVERSE APPROVAL OF DRAFT */
         {&DMAPRV-P-TAG18}
         for each ard_det where ard_ref = ar_nbr and (ard_type = "I"
            or ard_type = "M"):
            {&DMAPRV-P-TAG19}
            ard_recno = recid(ard_det).
            {gprun.i ""dmaprva.p""}
         end.

         {&DMAPRV-P-TAG20}
         /* IF THE DRAFT HAD BEEN DISCOUNTED IT WILL BE VOIDED, IF */
         /* IT WAS ONLY APPROVED IT CAN BE REAPPROVED OR DELETED   */
         /* THE ABOVE 2 LINES ARE INCORRECT - NO MATTER IF THE DRAFT */
         /* HAD BEEN DISCOUNTED OR ONLY APPROVED, THE REVERSAL WILL  */
         /* VOID THE DRAFT AND REOPEN THE INVOICES/MEMOD ATTACHED    */
         /* AND A NEW DRAFT WILL NEED TO BE CREATED.  THIS FOLLOWS   */
         /* THE PROCEDURE HELP TEXT                                  */
         ar_mstr.ar_open  = false.
         ar_mstr.ar_draft = false.
         {&DMAPRV-P-TAG21}
      end.  /* TRANSACTION */
      {&DMAPRV-P-TAG25}
   end.  /* MAINLOOP */

   if not somethingreversed then leave.

   {gprun.i ""dmaprvrp.p""}

end. /* MAIN1 */
SESSION:numeric-format = oldsession.
{&DMAPRV-P-TAG22}
