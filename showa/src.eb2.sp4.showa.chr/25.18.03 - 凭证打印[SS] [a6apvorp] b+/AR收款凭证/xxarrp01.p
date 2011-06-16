/* arparp.p - DETAIL PAYMENT AUDIT REPORT                               */
/* REVISION: 9.0      LAST MODIFIED: 04/27/05   BY: *apple* Apple Tam */

/* L00K* */ {mfdtitle.i "e+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE arparp_p_1 "S-汇总/D-明细"
/* MaxLen: Comment: */

&SCOPED-DEFINE arparp_p_2 "打印总帐明细"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

         /* DEFINE NEW SHARED WORKFILE AP_WKFL FOR CURRENCY SUMMARY */
         {gpacctp.i "new"}

         {gldydef.i new}
         {gldynrm.i new}

         define new shared variable rndmthd like rnd_rnd_mthd.
         /* DEFINE OLD_CURR FOR CALL TO GPACCTP.P */
         define new shared variable old_curr like ar_curr initial "".
/*apple*/         define new shared variable ref like ar_nbr.
/*apple*/         define new shared variable ref1 like ar_nbr.
         define new shared variable cust like ar_bill.
         define new shared variable cust1 like ar_bill.
         define new shared variable check_nbr like ar_check.
         define new shared variable check1 like ar_check.
         define new shared variable batch like ar_batch.
         define new shared variable batch1 like ar_batch.
         define new shared variable entity like ar_entity.
         define new shared variable entity1 like ar_entity.
         define new shared variable ardate like ar_date.
         define new shared variable ardate1 like ar_date.
         define new shared variable effdate like ar_effdate.
         define new shared variable effdate1 like ar_effdate.
         define new shared variable summary like mfc_logical
            format {&arparp_p_1} initial no label {&arparp_p_1}.
         define new shared variable gltrans like mfc_logical initial no
           label {&arparp_p_2}.
         define new shared variable base_rpt like ar_curr.
          define new shared variable mixed_rpt like mfc_logical initial no
            /*label {gpmixlbl.i} */ .
            

/*L00K*/ {etvar.i   &new = "new"}
/*L00K*/ {etrpvar.i &new = "new"}
/*L01K*
* /*L00K*/ {eteuro.i}
**L01K*/
         /*CHECK FOR VAT TAXES */
         find first gl_ctrl no-lock.
         form
/*apple*/   ref            colon 18
/*apple*/   ref1           label {t001.i} colon 49 skip
            batch          colon 18
            batch1         label {t001.i} colon 49 skip
            check_nbr      colon 18
            check1         label {t001.i} colon 49 skip
            cust           colon 18
            cust1          label {t001.i} colon 49 skip
            entity   colon 18
            entity1  label {t001.i} colon 49 skip
            ardate         colon 18
            ardate1        label {t001.i} colon 49 skip
            effdate        colon 18
            effdate1       label {t001.i} colon 49 skip (1)
/*apple            summary        colon 25
            gltrans        colon 25
            base_rpt       colon 25
            mixed_rpt      colon 25*/
         with frame a side-labels width 80.

         {wbrp01.i}

         repeat:

            find first ap_wkfl no-error.
            if available ap_wkfl then

               for each ap_wkfl exclusive-lock:
                   delete ap_wkfl.
               end.

            if batch1 = hi_char then batch1 = "".
            if check1 = hi_char then check1 = "".
            if ref1 = hi_char then ref1 = "".
            if cust1 = hi_char then cust1 = "".
            if entity1 = hi_char then entity1 = "".
            if ardate = low_date then ardate = ?.
            if ardate1 = hi_date then ardate1 = ?.
            if effdate = low_date then effdate = ?.
            if effdate1 = hi_date then effdate1 = ?.

            if c-application-mode <> 'web':u then
            update 
                   ref ref1
                   batch batch1
                   check_nbr check1
                   cust cust1
                   entity entity1
                   ardate ardate1
                   effdate effdate1
/*apple                   summary gltrans
                   base_rpt
                   mixed_rpt*/
            with frame a.

         {wbrp06.i &command = update
                   &fields = "  ref ref1 batch batch1 check_nbr check1
                                cust cust1 entity entity1 ardate ardate1
                                effdate effdate1 " &frm = "a"}

         if (c-application-mode <> 'web':u) or
         (c-application-mode = 'web':u and
         (c-web-request begins 'data':u)) then do:

            bcdparm = "".
            {mfquoter.i ref      }
            {mfquoter.i ref1     }
            {mfquoter.i batch    }
            {mfquoter.i batch1   }
            {mfquoter.i check_nbr}
            {mfquoter.i check1   }
            {mfquoter.i cust     }
            {mfquoter.i cust1    }
            {mfquoter.i entity   }
            {mfquoter.i entity1  }
            {mfquoter.i ardate   }
            {mfquoter.i ardate1  }
            {mfquoter.i effdate  }
            {mfquoter.i effdate1 }
            {mfquoter.i summary  }
            {mfquoter.i gltrans  }
            {mfquoter.i base_rpt}
           /* {mfquoter.i mixed_rpt} */

            if ref1 = "" then ref1 = hi_char.
            if batch1 = "" then batch1 = hi_char.
            if check1 = "" then check1 = hi_char.
            if cust1 = "" then cust1 = hi_char.
            if entity1 = "" then entity1 = hi_char.
            if ardate = ? then ardate = low_date.
            if ardate1 = ? then ardate1 = hi_date.
            if effdate = ? then effdate = low_date.
            if effdate1 = ? then effdate1 = hi_date.

         end.

            /* SELECT PRINTER */
            {mfselbpr.i "printer" 132}
            
/*
            if daybooks-in-use then
               {gprun.i ""nrm.p"" "persistent set h-nrm"}.

            /* DELETE GL WORKFILE ENTRIES */
            if gltrans = yes then do:
               for each gltw_wkfl exclusive-lock
                  where gltw_userid = mfguser:
                  delete gltw_wkfl.
               end.
            end.
*/
            /* PRINT BODY OF REPORT */
            {gprun.i ""xxarrpa.p""}

/*apple            /* PRINT GL DISTRIBUTION */
            if gltrans then do:
               page.
               {gprun.i ""gpglrp.p""}
            end.
*/
/*  Display Currency Totals.                                            */
/*apple*             if base_rpt = ""
             and mixed_rpt
             then
                 {gprun.i ""gpacctp.p""}. */

   /* REPORT TRAILER */
           /* {mfrtrail.i}*/
	       {mfreset.i}
           /* if daybooks-in-use then delete procedure h-nrm no-error.  *//*hillcheng*/

         end.

         {wbrp04.i &frame-spec = a}
