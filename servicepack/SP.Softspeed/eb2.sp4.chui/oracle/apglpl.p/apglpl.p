/* apglpl.p - CREATE GENERAL LEDGER TRANSACTIONS FOR AP                      */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.17 $                      */
/* REVISION: 9.0            CREATED: 11/30/98   BY: *M00P* Jeff Wootton      */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladha  */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 05/27/99   BY: *N00D* Adam Harris       */
/* REVISION: 9.1      LAST MODIFIED: 08/13/99   BY: *N01L* Adam Harris       */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Robin McCarthy    */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn               */
/* REVISION: 9.1      LAST MODIFIED: 09/14/00   BY: *N0W0* Mudit Mehta       */
/* REVISION: 9.1      LAST MODIFIED: 02/08/01   BY: *N0WP* Chris Green       */
/* Revision: 1.15         BY: Paul Donnelly   DATE: 12/10/01  ECO: *N16J*    */
/* Revision: 1.16   BY: Manjusha Inglay  DATE: 07/29/02  ECO: *N1P4*  */
/* $Revision: 1.17 $  BY: Rafal Krzyminski DATE: 01/16/03  ECO: *P0LX*  */
/* $Revision: 1.17 $  BY: Bill Jiang DATE: 08/03/06  ECO: *SS - 20060803.1*  */

/* SS - 20060803.1 - B */
/*
1. APPLE基于SP4和N322修改
2. 试图解决使用ORACLE数据库时不同批处理生成了相同总账参考号的BUG,结果待验证
*/
/* SS - 20060803.1 - E */

/*V8:ConvertMode=Maintenance                                                 */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*****************************************************************************/

/*! THIS WAS CREATED TO REPLACE GPGL.I, GPGLCURR.I AND GPGLTDET.I. */

{mfdeclre.i}
{cxcustom.i "APGLPL.P"}

{gprunpdf.i "mcpl" "p"}

{gprunpdf.i "gpglpl" "p"}

{gprunpdf.i "nrm" "p"}

{pxpgmmgr.i}

/* ADDED FOLLOWING PREPROCESSOR CONSTANT SECTION */

&SCOPED-DEFINE detailed_journals 1
&SCOPED-DEFINE summarized_journals 2
&SCOPED-DEFINE one_tran_per_doc 3

/*------------------------------------------------------------------*/

PROCEDURE apgl-create-all-glt:

   /* THIS PROCEDURE REPLACES GPGL.I */

   /* FOLLOWING WERE ARGUMENTS FOR GPGL.I */
   define input parameter p-disc           as decimal   no-undo.
   define input parameter p-gain           as decimal   no-undo.
   define input parameter p-curramt        as decimal   no-undo.
   define input parameter p-currdisc       as decimal   no-undo.
   define input parameter p-lineacct       as character no-undo.
   define input parameter p-linesub        as character no-undo.
   define input parameter p-linecc         as character no-undo.
   define input parameter p-lineproject    as character no-undo.
   define input parameter p-trans-ref      as character no-undo.
   define input parameter p-curr           as character no-undo.
   define input parameter p-tot-vtadj      as decimal   no-undo.
   define input-output parameter p-effdate as date      no-undo.
   define input parameter p-batch          as character no-undo.
   define input parameter p-mstracct       as character no-undo.
   define input parameter p-mstrsub        as character no-undo.
   define input parameter p-mstrcc         as character no-undo.
   define input parameter p-crentity       as character no-undo.
   define input parameter p-drentity       as character no-undo.
   define input parameter p-type           as character no-undo.
   define input parameter p-varacct        as character no-undo.
   define input parameter p-varsub         as character no-undo.
   define input parameter p-varcc          as character no-undo.
   define input parameter p-addr           as character no-undo.
   define input parameter p-exrate         as decimal   no-undo.
   define input parameter p-exrate2        as decimal   no-undo.
   define input parameter p-exratetype     as character no-undo.
   define input parameter p-exruseq        as integer   no-undo.
   define input parameter p-forcurr        as character no-undo.
   define input parameter p-forcurramt     as decimal   no-undo.
   define input parameter p-daybook        as character no-undo.
   define input parameter p-daybook-desc   as character no-undo.
   define input parameter p-discacct       as character no-undo.
   define input parameter p-discsub        as character no-undo.
   define input parameter p-disccc         as character no-undo.
   define input parameter p-tot-vtcurradj  as decimal   no-undo.

   /* FOLLOWING WERE VARIABLES FOR GPGL.I */
   define input parameter p-base-amt       as decimal   no-undo.
   define input parameter p-base-det-amt   as decimal   no-undo.
   define input parameter p-det-ex-rate    as decimal   no-undo.
   define input parameter p-det-ex-rate2   as decimal   no-undo.
   define input-output parameter p-jrnl    as character no-undo.
   define output parameter p-gl-ref        as character no-undo.
   define input parameter p-mstr-desc      as character no-undo.
   define input parameter p-gen-desc       as character no-undo.
   define input parameter p-det-desc       as character no-undo.

   /* FOLLOWING WERE VARIABLES FOR VAT-TAX FOR GPGL.I */
   define input parameter p-vtadj1         as decimal   no-undo.
   define input parameter p-vtadj2         as decimal   no-undo.
   define input parameter p-vtadj3         as decimal   no-undo.
   define input parameter p-vtcurradj1     as decimal   no-undo.
   define input parameter p-vtcurradj2     as decimal   no-undo.
   define input parameter p-vtcurradj3     as decimal   no-undo.
   define input parameter p-vtclass1       as character no-undo.
   define input parameter p-vtclass2       as character no-undo.
   define input parameter p-vtclass3       as character no-undo.
   define input parameter p-vt-date        as date      no-undo.

   /* FOLLOWING ARE SHARED DATA PASSED AS PARAMETERS         */
   /* BECAUSE THEY CANNOT BE SHARED IN AN INTERNAL PROCEDURE */
   define input parameter daybooks-in-use  as logical no-undo.
   define input-output parameter nrm-seq-num as character no-undo.
   {&APGLPL-P-TAG5}

   /* FOLLOWING WERE VARIABLES FOR GPGL.I */
   define variable acctcurr                as character no-undo.
   define variable acctcurr-curramt        as decimal   no-undo.
   define variable acctcurr-exrate         as decimal   no-undo.
   define variable acctcurr-exrate2        as decimal   no-undo.
   define variable acctcurr-exruseq        as integer   no-undo.
   define variable ico_acct                as character no-undo.
   define variable ico_sub                 as character no-undo.
   define variable ico_cc                  as character no-undo.
   define variable cr_ico_amt              as decimal   no-undo.
   define variable cr_ico_curr_amt         as decimal   no-undo.
   define variable gltline                 as integer   no-undo.
   define variable i                       as integer   no-undo.

   /* ARRAYS HERE BECAUSE ARRAYS CANNOT BE PASSED AS PARAMETERS */
   define variable vtadj                   as decimal   extent 3
      no-undo.
   define variable vtcurradj               as decimal   extent 3
      no-undo.
   define variable vtclass                 as character extent 3
      no-undo.

   /* LOCAL VARIABLES */
   define variable l-module                as character
      initial "AP"
      no-undo.

   define variable l-gl-sum    like apc_sum_lvl initial 1 no-undo.

/*---------------------------------------------------------------*/

   {&APGLPL-P-TAG2}
   /* CODE COPIED FROM GPGL.I */

   if p-base-amt + p-disc + p-gain <> 0 then do:

      for first apc_ctrl

         fields (apc_sum_lvl)
      no-lock:
      assign
         l-gl-sum = apc_sum_lvl.
      end.

      assign cr_ico_amt = 0.
      if p-effdate = ? then assign p-effdate = today.
      assign p-gl-ref = l-module
         + substring(string(year(p-effdate),"9999"),3,2)
         + string(month(p-effdate),"99")
         + string(day(p-effdate),"99")
         + string(integer(p-jrnl),"999999").

      /* CHECK THAT REF IS FOR THIS BATCH */
      repeat:
         for last glt_det
            fields
            (glt_batch
            glt_dy_code
            glt_dy_num
            glt_line
            glt_doc)
            where glt_ref = p-gl-ref
            use-index glt_ref
         no-lock:
         end.

         for last gltr_hist
            fields (gltr_ref)
            where gltr_ref = p-gl-ref
            use-index gltr_ref
         no-lock:
         end.

         if (not available glt_det or
            (glt_batch = p-batch and glt_dy_code = p-daybook
            and (glt_doc = p-trans-ref or l-gl-sum <> 3)
            ))
            and (not available gltr_hist) then leave.

         {&APGLPL-P-TAG6}
         assign p-jrnl = string(integer (p-jrnl) + 1).
         if integer(p-jrnl) > 999999 then assign p-jrnl = "1".
         /* Update apc_jrnl to match p-jrnl */

         /* SS - 20060803.1 - B */
/*apple****************************/
         find first apc_ctrl no-lock no-error.

     if apc_jrnl  <= integer(p-jrnl)
        or p-jrnl = "1"
     then
        do transaction:
        find first apc_ctrl exclusive-lock.
        assign apc_jrnl = integer(p-jrnl) + 1.
        /* SS - 20060803.1 - B */
        if dbtype("qaddb") <> "Progress" then
            validate apc_ctrl no-error.
        /* SS - 20060803.1 - E */
         end.

         release apc_ctrl.

/*apple**************************/
         /* SS - 20060803.1 - E */

         {&APGLPL-P-TAG7}
         assign p-gl-ref = l-module
            + substring(string(year(p-effdate),"9999"),3,2)
            + string(month(p-effdate),"99")
            + string(day(p-effdate),"99")
            + string(integer(p-jrnl),"999999").
      end.
      {&APGLPL-P-TAG1}
      if not available glt_det then assign gltline = 1.
      else
      assign gltline = glt_line + 1
         nrm-seq-num = glt_dy_num.

      if gltline = 1 and daybooks-in-use
      then do:
         {gprunp.i "nrm" "p" "nr_dispense"
            "(input  p-daybook,
              input  p-effdate,
              output nrm-seq-num)"}
      end. /* IF gltline = 1 AND ... */

/*-------------------------------------------------------------*/

      /* CREATE p-mstracct (ALWAYS IN SUMMARY) */
      if p-base-amt <> 0 then do:
         /* IF TRANSACTION IN BASE BUT HEADER ACCT IS FOREIGN   */
         /* THEN STORE THE CALC CURRENCY AMOUNT IN GLT_CURR_AMT */

         assign
            acctcurr = p-curr
            acctcurr-curramt = p-curramt
            acctcurr-exrate = p-exrate
            acctcurr-exrate2 = p-exrate2
            acctcurr-exruseq = p-exruseq.

         {gprunp.i "gpglpl" "p" "gpgl-convert-to-account-currency"
            "(input p-curr,
              input p-mstracct,
              input-output acctcurr,
              input p-effdate,
              input-output acctcurr-curramt,
              input p-forcurramt,
              input p-forcurr,
              input p-exratetype,
              input-output acctcurr-exrate,
              input-output acctcurr-exrate2,
              input-output acctcurr-exruseq
              )"}.

         /* REPLACED false with {&detailed_journals} for detail */
         /* REPLACED {&detailed_journals} with {&summarized_journals} */

         /* DELETED PARAMETER h-nrm                          */
         {gprunp.i "gpglpl" "p" "gpgl-create-one-glt"
            "(input p-crentity, /* entity for GL transaction */
              input p-crentity, /* entity to compare to en_entity */
              input p-mstracct, /* acct */
              input p-mstrsub, /* sub-acct */
              input p-mstrcc,
              input """", /* project */
              input - p-base-amt,
              input - acctcurr-curramt,
              input acctcurr, /* currency for GL transaction */
              input acctcurr, /* currency to compare to en_curr */
              input acctcurr-exrate,
              input acctcurr-exrate2,
              input p-exratetype,
              input acctcurr-exruseq,
              input p-gl-ref,
              input p-effdate,
              input """", /* match glt_desc */
              input p-mstr-desc, /* desc */
              input p-mstr-desc, /* mstr_desc */
              input p-gen-desc, /* gen_desc */
              input p-batch,
              input-output gltline,
              input l-module,
              input {&summarized_journals}, /* detail */
              input false, /* audit */
              input p-addr,
              input p-trans-ref, /* docnbr */
              input p-type, /* doctype */
              input p-daybook,
              input p-daybook-desc,
              input 1, /* variant = old gpgl.i */
              input daybooks-in-use,
              input-output nrm-seq-num
              {&APGLPL-P-TAG8}
              )"}.

         /* CAPTURE THE INTERCOMPANY AMOUNT (IF ANY) */
         if p-crentity <> p-drentity then
         assign
            cr_ico_amt
            = cr_ico_amt
            - p-base-amt
            cr_ico_curr_amt
            = cr_ico_curr_amt
            - p-curramt.

      end. /* IF BASE_AMT <> 0 */

/*-------------------------------------------------------------*/

      /* CREATE DISCOUNT (ALWAYS IN SUMMARY) */
      if p-disc <> 0 then do:
         {&APGLPL-P-TAG3}
         /* REPLACED false with {&detailed_journals} for detail */
         /* REPLACED {&detailed_journals} with {&summarized_journals} */

         /* DELETED PARAMETER h-nrm                          */
         {gprunp.i "gpglpl" "p" "gpgl-create-one-glt"
            "(input p-drentity, /* entity for GL transaction */
              input p-crentity, /* entity to compare to en_entity */
              input p-discacct, /* acct */
              input p-discsub, /* sub-acct */
              input p-disccc,
              input """", /* project */
              input - p-disc,
              input - p-currdisc,
              input p-curr, /* currency for GL transaction */
              input p-curr, /* currency to compare to en_curr */
              input p-exrate,
              input p-exrate2,
              input p-exratetype,
              input p-exruseq,
              input p-gl-ref,
              input p-effdate,
              input """", /* match glt_desc */
              input p-mstr-desc, /* desc */
              input p-mstr-desc, /* mstr_desc */
              input p-gen-desc, /* gen_desc */
              input p-batch,
              input-output gltline,
              input l-module,
              input {&summarized_journals}, /* detail */
              input false, /* audit */
              input p-addr,
              input p-trans-ref, /* docnbr */
              input p-type, /* doctype */
              input p-daybook,
              input p-daybook-desc,
              input 1, /* variant = old gpgl.i */
              input daybooks-in-use,
              input-output nrm-seq-num
              {&APGLPL-P-TAG9}
              )"}.
         {&APGLPL-P-TAG4}

      end.

/*-------------------------------------------------------------*/

      /* CREATE ADJUSTMENT TO VAT ACCTS IF DISCOUNT TAKEN */
      if p-tot-vtadj <> 0
      then do:
         assign
            vtadj[1] = p-vtadj1
            vtadj[2] = p-vtadj2
            vtadj[3] = p-vtadj3
            vtcurradj[1] = p-vtcurradj1
            vtcurradj[2] = p-vtcurradj2
            vtcurradj[3] = p-vtcurradj3
            vtclass[1] = p-vtclass1
            vtclass[2] = p-vtclass2
            vtclass[3] = p-vtclass3.

         do i = 1 to 3:
            if vtadj[i] <> 0 then do:

               for last vt_mstr
                  fields
                  (vt_ap_acct vt_ap_cc
                  vt_class
                  vt_end vt_start vt_tax_pct)
                  where vt_class = vtclass[i]
                  and vt_start <= p-vt-date
                  and vt_end >= p-vt-date
               no-lock:
               end.

               if available vt_mstr then do:
                  /* POST DISCOUNT AMOUNT TO VAT STATISTICAL ACCOUNT */

                  for first ac_mstr
                     fields (ac_code ac_curr ac_stat_acc)
                     where ac_code

                     = vt_ap_acct
                  no-lock:
                  end.

                  if available ac_mstr
                     and ac_stat_acc <> ""
                  then do:
                     /* REPLACED false with {&detailed_journals} for detail */
                     /* REPLACED {&detailed_journals} with {&summarized_journals} */
                     /* DELETED PARAMETER h-nrm                          */
                     {gprunp.i "gpglpl" "p" "gpgl-create-one-glt"
                        "(input p-drentity, /* entity for GL trans */
                          input p-crentity, /* entity to compare en_ */
                          input ac_stat_ac, /* acct&sub for acct */
                          input vt_ap_acct, /* acct&sub for sub */
                          input vt_ap_cc,
                          input """", /* project */
                          input - p-disc,
                          input - p-currdisc,
                          input p-curr, /* currency for GL trans */
                          input p-curr, /* currency to compare en_ */
                          input p-exrate,
                          input p-exrate2,
                          input p-exratetype,
                          input p-exruseq,
                          input p-gl-ref,
                          input p-effdate,
                          input """", /* match glt_desc */
                          input p-mstr-desc, /* desc */
                          input p-mstr-desc, /* mstr_desc */
                          input p-gen-desc, /* gen_desc */
                          input p-batch,
                          input-output gltline,
                          input l-module,
                          input {&summarized_journals}, /* detail */
                          input false, /* audit */
                          input p-addr,
                          input p-trans-ref, /* docnbr */
                          input p-type, /* doctype */
                          input p-daybook,
                          input p-daybook-desc,
                          input 1, /* variant = old gpgl.i */
                          input daybooks-in-use,
                          input-output nrm-seq-num
                          {&APGLPL-P-TAG10}
                          )"}.
                     /* GPGL.I HAD THE FOLLOWING INCONSISTENCY: */
                     /* IN FIND FIRST WHERE GLT_AMT < 0,        */
                     /*   USED P-DRENTITY;                      */
                     /* IN FIND FIRST WHERE GLT_AMT >= 0,       */
                     /*   USED P-CRENTITY;                      */
                     /* WHEN CREATING GLT_DET,                  */
                     /*   USED P-DRENTITY.                      */
                     /* CHANGED ABOVE TO USE P-DRENTITY.        */
                  end.

                  /* WHEN USING FOREIGN CURRENCIES,                  */
                  /* VAT DISCOUNT AT PAYMENT IS CALCULATED           */
                  /* USING THE VOUCHER EXCHANGE RATE IN AP           */
                  /* OR THE EXCHANGE RATE EFFECTIVE AT INVOICE/MEMO  */
                  /* CREATION IN AR.                                 */
                  /* DET_EX_RATE CONTAINS VOUCHER EXCHANGE RATE IN AP*/
                  /* OR INVOICE/MEMO EXCHANGE RATE IN AR             */
                  /* (SET IN THE RESPECTIVE CALLING PROGRAMS)        */

                  /* REPLACED false with {&detailed_journals} for detail */
                  /* REPLACED {&detailed_journals} with {&summarized_journals} */
                  /* DELETED PARAMETER h-nrm                          */
                  {gprunp.i "gpglpl" "p" "gpgl-create-one-glt"
                     "(input p-drentity, /* entity for GL trans */
                       input p-crentity, /* entity to compare en_ */
                       input vt_ap_acct, /* acct&sub for acct */
                       input vt_ap_acct, /* acct&sub for sub */
                       input vt_ap_cc,
                       input """", /* project */
                       input - vtadj[i],
                       input - vtcurradj[i],
                       input p-curr, /* currency for GL trans */
                       input p-curr, /* currency to compare en_ */
                       input p-det-ex-rate,
                       input p-det-ex-rate2,
                       input p-exratetype,
                       input p-exruseq,
                       input p-gl-ref,
                       input p-effdate,
                       input """", /* match glt_desc */
                       input p-mstr-desc, /* desc */
                       input p-mstr-desc, /* mstr_desc */
                       input p-gen-desc, /* gen_desc */
                       input p-batch,
                       input-output gltline,
                       input l-module,
                       input {&summarized_journals}, /* detail */
                       input false, /* audit */
                       input p-addr,
                       input p-trans-ref, /* docnbr */
                       input p-type, /* doctype */
                       input p-daybook,
                       input p-daybook-desc,
                       input 1, /* variant = old gpgl.i */
                       input daybooks-in-use,
                       input-output nrm-seq-num
                       {&APGLPL-P-TAG11}
                       )"}.

               end. /* If available vt_mstr */
               release glt_det.
            end. /* If vtadj[i] <> 0 */
         end. /* do i = 1 to 3*/
      end. /* if p-vt-adj <> 0 */

/*-------------------------------------------------------------*/

      /* CREATE GAIN /LOSS */
      if p-gain <> 0 then do:
         /* REPLACED false with {&detailed_journals} for detail */
         /* REPLACED {&detailed_journals} with {&summarized_journals} */

         /* DELETED PARAMETER h-nrm                          */
         {gprunp.i "gpglpl" "p" "gpgl-create-one-glt"
            "(input p-crentity, /* entity for GL transaction */
              input p-crentity, /* entity to compare to en_entity */
              input p-varacct, /* acct */
              input p-varsub,  /* sub-acct */
              input p-varcc,
              input """", /* project */
              input - p-gain,
              input 0, /* curramt */
              input base_curr, /* currency for GL transaction */
              input p-curr,    /* currency to compare to en_curr */
              input 1, /* exrate */
              input 1, /* exrate2 */
              input p-exratetype, /* exratetype */
              input 0, /* exruseq */
              input p-gl-ref,
              input p-effdate,
              input """", /* match glt_desc */
              input p-mstr-desc, /* desc */
              input p-mstr-desc, /* mstr_desc */
              input p-gen-desc, /* gen_desc */
              input p-batch,
              input-output gltline,
              input l-module,
              input {&summarized_journals}, /* detail */
              input false, /* audit */
              input p-addr,
              input p-trans-ref, /* docnbr */
              input p-type, /* doctype */
              input p-daybook,
              input p-daybook-desc,
              input 1, /* variant = old gpgl.i */
              input daybooks-in-use,
              input-output nrm-seq-num
              {&APGLPL-P-TAG12}
              )"}.

         /* CAPTURE THE INTERCOMPANY AMOUNT (IF ANY) */
         if p-crentity <> p-drentity then
         assign cr_ico_amt
            = cr_ico_amt
            - p-gain
            + p-tot-vtadj.

      end. /* If p-gain <> 0 */

/*-------------------------------------------------------------*/

      /* CREATE line acct (IF DETAIL ONLY) */
      /* IF TRANSACTION IN BASE BUT IS A FOREIGN CURR ACCOUNT */
      /* THEN STORE THE CALC CURRENCY AMOUNT IN GLT_CURR_AMT */

      assign
         acctcurr = p-curr
         acctcurr-curramt = p-curramt + p-currdisc + p-tot-vtcurradj
         acctcurr-exrate = p-exrate
         acctcurr-exrate2 = p-exrate2
         acctcurr-exruseq = p-exruseq.

      {gprunp.i "gpglpl" "p" "gpgl-convert-to-account-currency"
         "(input p-curr,
           input p-lineacct,
           input-output acctcurr,
           input p-effdate,
           input-output acctcurr-curramt,
           input p-forcurramt,
           input p-forcurr,
           input p-exratetype,
           input-output acctcurr-exrate,
           input-output acctcurr-exrate2,
           input-output acctcurr-exruseq
           )"}.

      /* CHANGED (if l-gl-sum  TO  l-gl-sum    */
      /*          then false                   */
      /*          else true)                   */

      /* DELETED PARAMETER h-nrm                          */
      {gprunp.i "gpglpl" "p" "gpgl-create-one-glt"
         "(input p-drentity, /* entity for GL transaction */
           input p-crentity, /* entity to compare to en_entity */
           input p-lineacct, /* acct */
           input p-linesub,  /* sub-acct */
           input p-linecc,
           input p-lineproject,
           input p-base-det-amt,
           input acctcurr-curramt,
           input acctcurr, /* currency for GL transaction */
           input acctcurr, /* currency to compare to en_curr */
           input acctcurr-exrate,
           input acctcurr-exrate2,
           input p-exratetype,
           input acctcurr-exruseq,
           input p-gl-ref,
           input p-effdate,
           input """", /* match glt_desc */
           input p-det-desc, /* desc */
           input p-mstr-desc, /* mstr_desc */
           input p-gen-desc, /* gen_desc */
           input p-batch,
           input-output gltline,
           input l-module,
           input l-gl-sum, /* detail */
           input false, /* audit */
           input p-addr,
           input p-trans-ref, /* docnbr */
           input p-type, /* doctype */
           input p-daybook,
           input p-daybook-desc,
           input 1, /* variant = old gpgl.i */
           input daybooks-in-use,
           input-output nrm-seq-num
           {&APGLPL-P-TAG13}
           )"}.

/*-------------------------------------------------------------*/

      /* MAKE THE INTERCOMPANY REVERSAL POSTINGS (ALWAYS IN SUMMARY) */
      if p-crentity <> p-drentity
      then do:
          /* FIRST GET ICO ACCOUNT */
          {glenacex.i &entity=p-drentity
            &type='"DR"'
            &module='"AP"'
            &acct=ico_acct
            &sub=ico_sub
            &cc=ico_cc }

         /* INTERCOMPANY CREDIT */
         /* REPLACED {&detailed_journals} with {&summarized_journals} */
         /* REPLACED false with {&detailed_journals} for detail */

         /* DELETED PARAMETER h-nrm                          */
         {gprunp.i "gpglpl" "p" "gpgl-create-one-glt"
            "(input p-crentity, /* entity for GL transaction */
              input p-crentity, /* entity to compare to en_entity */
              input ico_acct, /* acct */
              input ico_sub,  /* sub-acct */
              input ico_cc,
              input """", /* project */
              input - cr_ico_amt,
              input - cr_ico_curr_amt,
              input p-curr, /* currency for GL transaction */
              input p-curr, /* currency to compare to en_curr */
              input p-exrate,
              input p-exrate2,
              input p-exratetype,
              input p-exruseq,
              input p-gl-ref,
              input p-effdate,
              input """", /* match glt_desc */
              input p-mstr-desc, /* desc */
              input p-mstr-desc, /* mstr_desc */
              input p-gen-desc, /* gen_desc */
              input p-batch,
              input-output gltline,
              input l-module,
              input {&summarized_journals}, /* detail */
              input false, /* audit */
              input p-addr,
              input p-trans-ref, /* docnbr */
              input p-type, /* doctype */
              input p-daybook,
              input p-daybook-desc,
              input 1, /* variant = old gpgl.i */
              input daybooks-in-use,
              input-output nrm-seq-num
              {&APGLPL-P-TAG14}
              )"}.

         /* INTERCOMPANY DEBIT */
         /* REPLACED false with {&detailed_journals} for detail */
         /* REPLACED {&detailed_journals} with {&summarized_journals} */

         {glenacex.i &entity=p-crentity
            &type='"CR"'
            &module='"AP"'
            &acct=ico_acct
            &sub=ico_sub
            &cc=ico_cc }
         /* DELETED PARAMETER h-nrm                          */
         {gprunp.i "gpglpl" "p" "gpgl-create-one-glt"
            "(input p-drentity, /* entity for GL transaction */
              input p-crentity, /* entity to compare to en_entity */
              input ico_acct, /* acct */
              input ico_sub,  /* sub-acct */
              input ico_cc,
              input """", /* project */
              input cr_ico_amt,
              input cr_ico_curr_amt,
              input p-curr, /* currency for GL transaction */
              input p-curr, /* currency to compare to en_curr */
              input p-exrate,
              input p-exrate2,
              input p-exratetype,
              input p-exruseq,
              input p-gl-ref,
              input p-effdate,
              input """", /* match glt_desc */
              input p-mstr-desc, /* desc */
              input p-mstr-desc, /* mstr_desc */
              input p-gen-desc, /* gen_desc */
              input p-batch,
              input-output gltline,
              input l-module,
              input {&summarized_journals}, /* detail */
              input false, /* audit */
              input p-addr,
              input p-trans-ref, /* docnbr */
              input p-type, /* doctype */
              input p-daybook,
              input p-daybook-desc,
              input 1, /* variant = old gpgl.i */
              input daybooks-in-use,
              input-output nrm-seq-num
              {&APGLPL-P-TAG15}
              )"}.

      end.  /* Intercompany posting */

   end. /* If p-base-amt + p-disc + p-gain <> 0 */

END PROCEDURE.

/*------------------------------------------------------------------*/
