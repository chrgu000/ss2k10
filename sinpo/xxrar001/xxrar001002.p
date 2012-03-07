/* ss - 110801.1 by: jack */

{xxmfdtitle.i "2+ "}


DEFINE  SHARED   TEMP-TABLE tt  /* */
    FIELD tt_cat AS CHAR  /* 分类 */
    FIELD tt_dept AS CHAR 
    FIELD tt_deptname LIKE dpt_desc
    FIELD tt_vend LIKE po_vend
    FIELD tt_name LIKE ad_name
    FIELD tt_nbr LIKE vo_invoice
    FIELD tt_date AS DATE
    FIELD tt_part LIKE pt_part
    FIELD tt_desc1 LIKE pt_desc1
    FIELD tt_qty LIKE pod_qty_ord
    FIELD tt_cost LIKE prh_pur_cost
    FIELD tt_amt LIKE ap_amt
    FIELD tt_type AS CHAR /* 1 发出商品 2 应收金额 m/i 3 预收金额 u 4 预收票据 d*/
    .
/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE arcsrp02_p_1 "Show Master Comments"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp02_p_2 "Show Payment Detail"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp02_p_3 "Show Invoice Comments"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp02_p_4 "Show Customer PO"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp02_p_5 "Summary/Detail"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp02_p_6 "Column Days"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp02_p_7 "Aging Date"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp02_p_8 "Deduct Contested"
/* MaxLen: Comment: */

&SCOPED-DEFINE arcsrp02_p_9 "Customer Type"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/* THESE ARE NEEDED FOR FULL GUI REPORTS */
{gprunpdf.i "mcpl" "p"}
{gprunpdf.i "mcui" "p"}

define input parameter  i_cust               like ar_bill.
define input parameter  i_cust1              like ar_bill.
define input parameter  i_sub                like ar_sub.
define input parameter  i_sub1               like ar_sub.
define input parameter  i_cc                 like ar_cc.
define input parameter  i_cc1                like ar_cc.
define input parameter  i_age_date           like ar_due_date
   label {&arcsrp02_p_7} initial today.


define new shared variable cust               like ar_bill.
define new shared variable cust1              like ar_bill.
define new shared variable cust_type          like cm_type
   label {&arcsrp02_p_9}.
define new shared variable cust_type1         like cm_type.
define new shared variable ardate             like ar_date.
define new shared variable ardate1            like ar_date.
define new shared variable nbr                like ar_nbr.
define new shared variable nbr1               like ar_nbr.
define new shared variable slspsn             like sp_addr.
define new shared variable slspsn1            like slspsn.
define new shared variable acct               like ar_acct.
define new shared variable acct1              like ar_acct.
define new shared variable sub                like ar_sub.
define new shared variable sub1               like ar_sub.
define new shared variable cc                 like ar_cc.
define new shared variable cc1                like ar_cc.
define new shared variable age_date           like ar_due_date
   label {&arcsrp02_p_7} initial today.
define new shared variable summary_only       like mfc_logical
   label {&arcsrp02_p_5} initial no format {&arcsrp02_p_5}.
define new shared variable base_rpt           like ar_curr.
define new shared variable deduct_contest     like mfc_logical
   label {&arcsrp02_p_8} initial no.
define new shared variable show_po            like mfc_logical
   label {&arcsrp02_p_4} initial no.
define new shared variable show_pay_detail    like mfc_logical
   label {&arcsrp02_p_2} initial no.
define new shared variable show_comments      like mfc_logical
   label {&arcsrp02_p_3} initial no.
define new shared variable show_mstr_comments like mfc_logical
   label {&arcsrp02_p_1} initial no.
define new shared variable age_days           as integer extent 4
   label {&arcsrp02_p_6}.
define new shared variable mstr_type          like cd_type initial "AR".
define new shared variable mstr_lang          like cd_lang.
define new shared variable entity             like gl_entity.
define new shared variable entity1            like gl_entity.
define new shared variable lstype             like ls_type.
define new shared variable mc-rpt-curr        like ar_curr no-undo.

define            variable i                  as integer.
define            variable mc-dummy-fixed     like so_fix_rate no-undo.
define            variable l_batchid          like bcd_batch   no-undo.

{etrpvar.i &new = "new"}
{etvar.i   &new = "new"}
{eteuro.i}

form
   cust           colon 15
   cust1          label {t001.i} colon 49 skip
   cust_type      colon 15
   cust_type1     label {t001.i} colon 49 skip
   ardate         colon 15
   ardate1        label {t001.i} colon 49 skip
   nbr            colon 15
   nbr1           label {t001.i} colon 49 skip
   slspsn         colon 15
   slspsn1        label {t001.i} colon 49 skip
   acct           colon 15
   acct1          label {t001.i} colon 49 skip
   sub            colon 15
   sub1           label {t001.i} colon 49 skip
   cc             colon 15
   cc1            label {t001.i} colon 49 skip
   entity         colon 15
   entity1        label {t001.i} colon 49
   lstype         colon 15
   skip
   age_date        colon 22  show_po            colon 58
   summary_only    colon 22  show_pay_detail    colon 58
   base_rpt        colon 22  show_comments      colon 58
   et_report_curr  colon 22
   deduct_contest     colon 58
   mstr_lang
   show_mstr_comments  colon 58
   mstr_type
   skip
   space(1)
   age_days[1]
   age_days[2]    label "[2]"
   age_days[3]    label "[3]"
with frame a side-labels no-attr-space width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).


    ASSIGN
    
     cust = i_cust 
     cust1 = i_cust1 
     sub =  i_sub 
     sub1 = i_sub1 
     cc =  i_cc    
     cc1 = i_cc1   
     age_date =  i_age_date          
        .


   if cust1 = hi_char
   then
      cust1 = "".

   if cust_type1 = hi_char
   then
      cust_type1 = "".

   if ardate = low_date
   then
      ardate = ?.

   if ardate1 = hi_date
   then
      ardate1 = ?.

   if nbr1 = hi_char
   then
      nbr1 = "".

   if slspsn1 = hi_char
   then
      slspsn1 = "".

   if acct1 = hi_char
   then
      acct1 = "".

   if sub1 = hi_char
   then
      sub1 = "".

   if cc1 = hi_char
   then
      cc1 = "".

   if entity1 = hi_char
   then
      entity1 = "".

   do i = 1 to 4:
      if age_days[i] = 0
      then
         age_days[i] = (i * 30).
   end. /* DO i = 1 to 4 */

/*    update                             */
/*       cust                            */
/*       cust1                           */
/*       cust_type                       */
/*       cust_type1                      */
/*       ardate                          */
/*       ardate1                         */
/*       nbr                             */
/*       nbr1                            */
/*       slspsn                          */
/*       slspsn1                         */
/*       acct                            */
/*       acct1                           */
/*       sub                             */
/*       sub1                            */
/*       cc                              */
/*       cc1                             */
/*       entity                          */
/*       entity1                         */
/*       lstype                          */
/*       age_date                        */
/*       summary_only                    */
/*       base_rpt                        */
/*       et_report_curr                  */
/*       show_po                         */
/*       show_pay_detail                 */
/*       show_comments                   */
/*       deduct_contest                  */
/*       show_mstr_comments              */
/*       mstr_lang                       */
/*       mstr_type                       */
/*       age_days[1 for 3] with frame a. */

   do:
      bcdparm = "".
      {mfquoter.i cust         }
      {mfquoter.i cust1        }
      {mfquoter.i cust_type    }
      {mfquoter.i cust_type1   }
      {mfquoter.i ardate       }
      {mfquoter.i ardate1      }
      {mfquoter.i nbr          }
      {mfquoter.i nbr1         }
      {mfquoter.i slspsn       }
      {mfquoter.i slspsn1      }
      {mfquoter.i acct         }
      {mfquoter.i acct1        }
      {mfquoter.i sub          }
      {mfquoter.i sub1         }
      {mfquoter.i cc           }
      {mfquoter.i cc1          }
      {mfquoter.i entity       }
      {mfquoter.i entity1      }
      {mfquoter.i lstype }
      {mfquoter.i age_date     }
      {mfquoter.i summary_only }
      {mfquoter.i base_rpt     }
      {mfquoter.i et_report_curr }
      {mfquoter.i show_po      }
      {mfquoter.i show_pay_detail}
      {mfquoter.i show_comments}
      {mfquoter.i deduct_contest}
      {mfquoter.i show_mstr_comments}
      {mfquoter.i mstr_lang   }
      {mfquoter.i mstr_type    }
      {mfquoter.i age_days[1]  }
      {mfquoter.i age_days[2]  }
      {mfquoter.i age_days[3]  }

      if cust1 = ""
      then
         cust1 = hi_char.

      if cust_type1 = ""
      then
         cust_type1 = hi_char.

      if ardate = ?
      then
         ardate = low_date.

      if ardate1 = ?
      then
         ardate1 = hi_date.

      if nbr1 = ""
      then
         nbr1 = hi_char.

      if slspsn1 = ""
      then
         slspsn1 = hi_char.

      if acct1 = ""
      then
         acct1 = hi_char.

      if sub1 = ""
      then
         sub1 = hi_char.

      if cc1 = ""
      then
         cc1 = hi_char.

      if entity1 = ""
      then
         entity1 = hi_char.

      et_eff_date = age_date.

      /* Validate currency */
      run ip-chk-valid-curr
         (input  base_rpt,
         output mc-error-number).

      if mc-error-number <> 0
      then do:
         next-prompt base_rpt with frame a.
         undo, retry.
      end. /* IF mc-error-number <> 0 */

      /* Validate reporting currency */
      run ip-chk-valid-curr
         (input  et_report_curr,
         output mc-error-number).

      if mc-error-number = 0
      then do:

         /* Default currencies if blank */
         mc-rpt-curr = if base_rpt = ""
                       then
                          base_curr
                       else
                          base_rpt.

         if et_report_curr = ""
         then
            et_report_curr = mc-rpt-curr.

         /* Prompt for exchange rate and format for output */
         run ip-ex-rate-setup
            (input  et_report_curr,
            input  mc-rpt-curr,
            input  " ",
            input  et_eff_date,
            output et_rate2,
            output et_rate1,
            output mc-exch-line1,
            output mc-exch-line2,
            output mc-error-number).

      end.  /* IF mc-error-number = 0 */

      if mc-error-number <> 0
      then do:
         next-prompt et_report_curr with frame a.
         undo, retry.
      end. /* IF mc-error-number <> 0 */

   end. /* DO */

   /* OUTPUT DESTINATION SELECTION */

    on go anywhere
    do:
       if frame-field = "batch_id":U
       then
          l_batchid = frame-value.

       /* TO CHECK NON-BLANK VALUE OF BATCH ID WHEN CURSOR IS */
       /* IN BATCH ID OR OUTPUT FIELD                         */
       if ((frame-field       =  "batch_id":U
            and frame-value   <> "")
            or (frame-field   =  "dev":U
               and l_batchid <> ""))
               and (mc-rpt-curr  <> et_report_curr)
       then do:
          /* USER-INPUT EXCHANGE RATE WILL BE IGNORED IN BATCH MODE */
          {pxmsg.i &MSGNUM=4629 &ERRORLEVEL=2}
          pause.
       end. /* IF FRAME-FIELD = "batch_id" AND ... */
    end. /* ON GO ANYWHERE */

   
   
   {gprun.i ""xxrar001002a.p""}

  

PROCEDURE ip-chk-valid-curr:

   define input  parameter i_curr  as character no-undo.
   define output parameter o_error as integer   no-undo initial 0.

   if i_curr <> ""
   then do:

      {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
         "(input  i_curr,
           output o_error)" }

      if o_error <> 0
      then do:
         {pxmsg.i &MSGNUM=o_error &ERRORLEVEL=3}
      end. /* IF o_error <> 0 */

   end.  /* IF i_curr */

END PROCEDURE.  /* PROCEDURE ip-chk-valid-curr */

PROCEDURE ip-ex-rate-setup:

   define input  parameter i_curr1      as character no-undo.
   define input  parameter i_curr2      as character no-undo.
   define input  parameter i_type       as character no-undo.
   define input  parameter i_date       as date      no-undo.

   define output parameter o_rate       as decimal   no-undo initial 1.
   define output parameter o_rate2      as decimal   no-undo initial 1.
   define output parameter o_disp_line1 as character no-undo
      initial "".
   define output parameter o_disp_line2 as character no-undo
      initial "".
   define output parameter o_error      as integer   no-undo initial 0.

   define variable v_seq                as integer   no-undo.
   define variable v_fix_rate           as logical no-undo.

   do transaction:

      /* Get exchange rate and create usage records */
      {gprunp.i "mcpl" "p" "mc-create-ex-rate-usage"
         "(input  i_curr1,
           input  i_curr2,
           input  i_type,
           input  i_date,
           output o_rate,
           output o_rate2,
           output v_seq,
           output o_error)" }

      if o_error = 0
      then do:

         /* Prompt user to edit exchange rate */
         if not batchrun
         then do:
            {gprunp.i "mcui" "p" "mc-ex-rate-input"
               "(input        i_curr1,
                 input        i_curr2,
                 input        i_date,
                 input        v_seq,
                 input        false,
                 input        5,
                 input-output o_rate,
                 input-output o_rate2,
                 input-output v_fix_rate)" }
         end. /*IF NOT batchrun */

         /* Format exchange rate for output */
         {gprunp.i "mcui" "p" "mc-ex-rate-output"
            "(input  i_curr1,
              input  i_curr2,
              input  o_rate,
              input  o_rate2,
              input  v_seq,
              output o_disp_line1,
              output o_disp_line2)" }

         /* Delete usage records */
         {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
            "(input v_seq)" }

      end.  /* IF o_error */

      else do:
         {pxmsg.i &MSGNUM=o_error &ERRORLEVEL=3}
      end. /* ELSE DO */

   end.  /* DO TRANSACTION */

END PROCEDURE.  /* PROCEDURE ip-ex-rate-setup */
