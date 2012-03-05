/* woworp05.p - WORK ORDER COST REPORT                                  */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* web convert woworp05.p (converter v1.00) Fri Oct 10 13:57:24 1997 */
/* web tag in woworp05.p (converter v1.00) Mon Oct 06 14:17:53 1997 */
/*F0PN*/ /*K0XV*/ /*V8#ConvertMode=WebReport                            */
/*V8:ConvertMode=FullGUIReport                                 */
/* REVISION: 1.0     LAST MODIFIED: 05/01/86    BY: emb                 */
/* REVISION: 2.1     LAST MODIFIED: 09/11/87    BY: wug *A94*           */
/* REVISION: 4.0     LAST MODIFIED: 02/24/88    BY: wug *A175*          */
/* REVISION: 4.0     LAST MODIFIED: 03/30/88    BY: rxl *A171*          */
/* REVISION: 4.0     LAST MODIFIED: 01/04/89    BY: flm *A579*          */
/* REVISION: 5.0     LAST MODIFIED: 01/24/90    BY: ftb *B531*          */
/* REVISION: 5.0     LAST MODIFIED: 02/12/90    BY: wug *B562*          */
/* REVISION: 5.0     LAST MODIFIED: 05/15/90    BY: ram *B688*          */
/* REVISION: 5.0     LAST MODIFIED: 01/08/91    BY: ram *B870*          */
/* REVISION: 6.0     LAST MODIFIED: 05/01/91    BY: ram *D611*          */
/* REVISION: 7.0     LAST MODIFIED: 10/23/91    BY: pma *F003*          */
/* REVISION: 7.3     LAST MODIFIED: 04/23/93    BY: ram *GA24*          */
/* REVISION: 7.3     LAST MODIFIED: 04/28/93    BY: pma *GA47*(rev only)*/
/* REVISION: 8.6     LAST MODIFIED: 10/14/97    BY: ays *K0XV*          */
/* REVISION: 7.4     LAST MODIFIED: 02/05/98    BY: *H1JC* Jean Miller      */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan       */
/* REVISION: 8.6E     LAST MODIFIED: 08/04/05   BY: *SS - 20050804* Bill Jiang       */
/* SS - 20050804 - B */
{a6woworp05.i}

define input parameter nbr   like wo_nbr.
define input parameter nbr1  like wo_nbr.
define input parameter lot   like wo_lot.
define input parameter lot1  like wo_lot.
define input parameter part  like wo_part.
define input parameter part1 like wo_part.
define input parameter due   like wo_due_date.
define input parameter due1  like wo_due_date.

define input parameter acct_close like wo_acct_close.
define input parameter CLOSE_date   like wo_close_date.
define input parameter close_date1  like wo_close_date.
define input parameter CLOSE_eff   like wo_close_eff.
define input parameter close_eff1  like wo_close_eff.

define input parameter so_job like wo_so_job.
define input parameter vend  like wo_vend.
define input parameter stat like wo_status.

define input parameter mtlyn like mfc_logical.
define input parameter lbryn like mfc_logical.
define input parameter bdnyn like mfc_logical.
define input parameter subyn like mfc_logical.

define input parameter skpage like mfc_logical.

/*
          /* DISPLAY TITLE */
/*GA24*/ {mfdtitle.i "e+ "} /*GA47*/
*/
/*GA24*/ {a6mfdtitle.i "e+ "} /*GA47*/
/* SS - 20050804 - E */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE woworp05_p_1 "转包成本"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp05_p_2 "物料成本"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp05_p_3 "按加工单分页"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp05_p_4 "附加费"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp05_p_5 "人工"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworp05_p_6 "D-明细/S-汇总"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */


    /* SS - 20050804 - B */
    /*
         define new shared variable nbr   like wo_nbr.
         define new shared variable nbr1  like wo_nbr.
         define new shared variable lot   like wo_lot.
         define new shared variable lot1  like wo_lot.
         define new shared variable part  like wo_part.
         define new shared variable part1 like wo_part.
         define new shared variable due   like wo_due_date.
         define new shared variable due1  like wo_due_date.
         define new shared variable vend  like wo_vend.
         define new shared variable so_job like wo_so_job.
/*F003*  define new shared variable parts like mfc_logical initial yes     */
/*F003*     label "Print Bill of Material Detail".                         */
/*F003*  define new shared variable operations like mfc_logical initial yes*/
/*F003*     label "Print Routing Detail".                                  */
         define new shared variable skpage like mfc_logical initial yes
            label {&woworp05_p_3}.
         define new shared variable stat like wo_status.

/*F003*/ define new shared variable mtlyn like mfc_logical initial yes
/*F003*/    label {&woworp05_p_2}     format {&woworp05_p_6}.
/*F003*/ define new shared variable lbryn like mfc_logical initial yes
/*F003*/    label {&woworp05_p_5}        format {&woworp05_p_6}.
/*F003*/ define new shared variable bdnyn like mfc_logical initial yes
/*F003*/    label {&woworp05_p_4}       format {&woworp05_p_6}.
/*F003*/ define new shared variable subyn like mfc_logical initial yes
/*F003*/    label {&woworp05_p_1}  format {&woworp05_p_6}.
*/
/* SS - 20050804 - E */

         form
            nbr         colon 15
            nbr1        label {t001.i} colon 49 skip
            lot         colon 15
            lot1        label {t001.i} colon 49 skip
            part        colon 15
            part1       label {t001.i} colon 49 skip
            due         colon 15
            due1        label {t001.i} colon 49 skip (1)
            so_job      colon 30 skip
            vend        colon 30 skip
            stat        colon 30 skip (1)
/*F003*     parts       colon 30  */
/*F003*     operations  colon 30  */
/*F003*/    mtlyn       colon 30 skip
/*F003*/    lbryn       colon 30 skip
/*F003*/    bdnyn       colon 30 skip
/*F003*/    subyn       colon 30 skip
            skpage      colon 30
         with frame a side-labels width 80 attr-space.

/*K0XV*/ {wbrp01.i}

    /* SS - 20050804 - B */
    /*
         repeat on error undo, retry:
             */
             /* SS - 20050804 - E */

            if nbr1 = hi_char then nbr1 = "".
            if lot1 = hi_char then lot1 = "".

            /* SS - 20050804 - B */
            /*
/*K0XV*/    if c-application-mode <> "WEB":U then
            update
               nbr      nbr1
               lot      lot1
               part     part1
               due      due1
               so_job
               vend
               stat
/*F003*        parts operations */
/*F003*/       mtlyn lbryn bdnyn subyn
              skpage
            with frame a.

/*K0XV*/    {wbrp06.i &command = update &fields = "  nbr nbr1 lot lot1
             part part1 due due1 so_job vend stat   mtlyn lbryn bdnyn subyn
             skpage" &frm = "a"}
    */
    /* SS - 20050804 - E */

/*K0XV*/    if (c-application-mode <> "WEB":U) or
/*K0XV*/       (c-application-mode = "WEB":U and
/*K0XV*/       (c-web-request begins "DATA":U)) then do:

               bcdparm = "".
               {mfquoter.i nbr     }
               {mfquoter.i nbr1    }
               {mfquoter.i lot     }
               {mfquoter.i lot1    }
               {mfquoter.i part    }
               {mfquoter.i part1   }
               {mfquoter.i due     }
               {mfquoter.i due1    }
               {mfquoter.i so_job  }
               {mfquoter.i vend    }
               {mfquoter.i stat    }
/*F003*        {mfquoter.i parts   }   */
/*F003*        {mfquoter.i operations} */
/*F003*/       {mfquoter.i mtlyn   }
/*F003*/       {mfquoter.i lbryn   }
/*F003*/       {mfquoter.i bdnyn   }
/*F003*/       {mfquoter.i subyn   }
               {mfquoter.i skpage  }

/*H1JC*/       /* Add this do loop so the converter wont create an 'on leave' */
/*H1JC*/       do:

/*GA24*           if index("FEARCB",stat) = 0 and stat <> "" */
/*GA24*/          if index("PFEARCB",stat) = 0 and stat <> ""
                  then do with frame a:
                     {mfmsg.i 19 3} /* INVALID STATUS */
/*K0XV*/             if c-application-mode = "WEB":U then return.
/*K0XV*/             else
                        next-prompt stat with frame a.
                     undo, retry.
                  end.
/*H1JC*/       end.

/*K0XV*/    end. /* if c-application-mode */

/* SS - 20050804 - B */
/*
            /* SELECT PRINTER */
            {mfselbpr.i "printer" 132}
            {mfphead.i}
                */
                /* SS - 20050804 - E */

            if nbr1 = "" then nbr1 = hi_char.
            if lot1 = "" then lot1 = hi_char.

            /* SS - 20050804 - B */
            {gprun.i ""a6woworp5a.p"" "(
                INPUT nbr,
                INPUT nbr1,
                INPUT lot,
                INPUT lot1,
                INPUT part,
                INPUT part1,
                INPUT due,
                INPUT due1,

                INPUT acct_close,
                INPUT CLOSE_date,
                INPUT CLOSE_date1,
                INPUT CLOSE_eff,
                INPUT CLOSE_eff1,

                INPUT so_job,
                INPUT vend,
                INPUT stat,

                INPUT mtlyn,
                INPUT lbryn,
                INPUT bdnyn,
                INPUT subyn,

                INPUT skpage
                )"}
            /*
            {gprun.i ""woworp5a.p""}

            {mfrtrail.i}

         end. /* repeat */
            */
            /* SS - 20050804 - E */

/*K0XV*/ {wbrp04.i &frame-spec = a}
