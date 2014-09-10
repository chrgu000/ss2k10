/* gltbrp1.i - GENERAL LEDGER TRIAL BALANCE REPORT SUBROUTINE TO              */
/*V8:ConvertMode=Report                                                       */
/***************************************************************************/

/* DISPLAY ACCOUNT AND AMOUNTS */
assign end_bal = beg_bal + per_act.

{&GLTBRP1-I-TAG1}
if et_report_curr <> rpt_curr then do:

   {gprunp.i "mcpl" "p" "mc-curr-conv"
      "(input rpt_curr,
        input et_report_curr,
        input et_rate1,
        input et_rate2,
        input beg_bal,
        input true,    /* ROUND */
        output et_beg_bal,
        output mc-error-number)"}

     if mc-error-number <> 0 then do:
        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
     end.

     {gprunp.i "mcpl" "p" "mc-curr-conv"
         "(input rpt_curr,
           input et_report_curr,
           input et_rate1,
           input et_rate2,
           input per_act,
           input true,    /* ROUND */
           output et_per_act,
           output mc-error-number)"}
     if mc-error-number <> 0 then do:
        {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
     end.
end.  /* if et_report_curr <> rpt_curr          */
else
   assign et_beg_bal = beg_bal
          et_per_act = per_act.
          et_end_bal = et_beg_bal + et_per_act.

{&GLTBRP1-I-TAG2}
if not zeroflag or beg_bal <> 0 or per_act <> 0 or end_bal <> 0
or et_beg_bal <> 0 or et_per_act <> 0 or et_end_bal <> 0
then do:

   if ac_active = yes or beg_bal <> 0 or per_act <> 0 or end_bal <> 0
   or et_beg_bal <> 0 or et_per_act <> 0 or et_end_bal <> 0
   then do:
      {&GLTBRP1-I-TAG3}

      if ccflag and subflag then do:
         {glacct.i &acc=asc_mstr.asc_acc &sub="""" &cc=""""
            &acct=account}
      end.
      else if ccflag then do:
         {glacct.i &acc=asc_mstr.asc_acc &sub=asc_mstr.asc_sub
            &cc="""" &acct=account}
      end.
      else if subflag then do:
         {glacct.i &acc=asc_mstr.asc_acc &sub="""" &cc=asc_mstr.asc_cc
            &acct=account}
      end.
      else do:
         {glacct.i &acc=asc_mstr.asc_acc &sub=asc_mstr.asc_sub
            &cc=asc_mstr.asc_cc &acct=account}
      end.

      {&GLTBRP1-I-TAG4}
      if first_acct then do:
/*         put                                        */
/*            "aSc_" + asc_acc at 2                   */
/*            ac_desc at 25.                          */
            create tmp88.
            assign t88_acct = asc_acc
                   t88_account = asc_acc
                   t88_desc = ac_desc.
         end.
      {&GLTBRP1-I-TAG5}
      if first_sub and asc_sub <> "" and co_use_sub
      then do:
         for first sb_mstr
         fields( sb_domain sb_desc sb_sub)
          where sb_mstr.sb_domain = global_domain and  sb_sub = asc_sub
         no-lock: end.
         {&GLTBRP1-I-TAG6}
         do:
/*         put                                                                             */
/*           "sbs_" + substring(account,1,(length(trim(asc_acc))+ 1 + length(asc_sub)))    */
/*               format "x(22)" at 2                                                       */
/*            sb_desc at 26.                                                               */
/*         {&GLTBRP1-I-TAG7}                                                               */
         create tmp88.
         assign t88_acct = asc_acc
                t88_sub = asc_sub
                t88_account =  substring(account,1,(length(trim(asc_acc))+ 1 + length(asc_sub)))
                t88_desc = sb_desc.
         end.
      end. /* sub-account desrp printed */

      if asc_cc <> "" and first_cc then do:
         for first cc_mstr
         fields( cc_domain cc_desc cc_ctr)
          where cc_mstr.cc_domain = global_domain and  cc_ctr = asc_cc no-lock:
          end.
         {&GLTBRP1-I-TAG8}
         do:
/*         put                                  */
/*            "acc_" + account at 2             */
/*            cc_desc at 27.                    */
/*         {&GLTBRP1-I-TAG9}                    */
         create tmp88.
         assign t88_acct = asc_acc
                t88_sub = asc_sub
                t88_cc = asc_cc
                t88_account = account
                t88_desc = cc_desc.
         end.
      end. /* cc descrp printed */
/*
      if ac_curr <> et_report_curr then put ac_curr at 51.
*/
      {&GLTBRP1-I-TAG10}
      /* ROUND IF NECESSARY */
      if prt1000 then do:
         assign
            beg_bal = round(beg_bal / 1000, 0)
            per_act = round(per_act / 1000, 0)
            end_bal = round(end_bal / 1000, 0)
            {&GLTBRP1-I-TAG11}
            et_beg_bal = round(et_beg_bal / 1000, 0)
            et_per_act = round(et_per_act / 1000, 0)
            et_end_bal = round(et_end_bal / 1000, 0).
         {&GLTBRP1-I-TAG12}
      end.

      /* CALCULATE TOTALS */
      assign
         beg_tot = beg_tot + beg_bal
         per_tot = per_tot + per_act
         end_tot = end_tot + end_bal
         {&GLTBRP1-I-TAG13}
         et_beg_tot = et_beg_tot + et_beg_bal
         et_per_tot = et_per_tot + et_per_act
         et_end_tot = et_end_tot + et_end_bal.

/*      put                                                           */
/*         string(et_beg_bal, prtfmt) format "x(20)" to 73            */
/*         string(et_per_act, prtfmt) format "x(20)" to 94            */
/*         string(et_end_bal, prtfmt) format "x(20)" to 115.          */
/*      {&GLTBRP1-I-TAG14}                                            */
      assign t88_beg = et_beg_bal
             t88_per = et_per_act
             t88_end = et_end_bal.
   end.  /* if ac_active = yes or beg_bal <> 0 ... */

   assign
      first_acct = no
      first_sub = no
      first_cc = no.

end.  /* if not zeroflag or beg_bal <> 0 ... */
