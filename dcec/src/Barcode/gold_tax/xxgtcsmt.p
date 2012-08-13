/* xxgtcsmt.p - CUSTOMER MAINTENANCE for Golden Tax                       */
/* COPYRIGHT infopower.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* REVISION: 1.0     LAST MODIFIED: 09/21/2000   BY: *ifp006* Frankie Xu    */

         /* DISPLAY TITLE */
         {mfdtitle.i "e+ "}   /*L00R*/

         define new shared variable promo_old like cm_promo.
         define variable del-yn like mfc_logical.
         define variable cmnbr like cm_addr.
         define variable new_cust like mfc_logical no-undo.
         define new shared variable mult_slspsn like mfc_logical no-undo.
         define new shared variable tax_recno as recid.
         define variable tax_date like tax_effdate.
         define variable valid_acct like mfc_logical.
         define new shared variable cm_recno as recid.
         define new shared variable ad_recno as recid.
         define variable old_um like fr_um.
         define variable old_fr_list like cm_fr_list.
         define new shared variable undo_adcsmtc like mfc_logical.
         define            variable ec_ok        like mfc_logical.
         define new shared variable errfree like mfc_logical.
         define new shared variable new_cmmstr   like mfc_logical no-undo.
         define new shared frame a.
         define new shared frame b.
         define            variable regen_add    like mfc_logical initial no.
         define            variable cust_node    like anx_node.
         define buffer admstr for ad_mstr.
         define variable yn like mfc_logical no-undo.
         define variable reccm as recid.
         define variable recad as recid.
         define variable l_exit like mfc_logical.
         define variable vatreg like ad_pst_id format "x(16)".

         {etvar.i &new="new"}

         /* CHECK IF INTRA-EC IS INSATLLED  */
         {gprun.i ""txecck.p"" "( output ec_ok)" }
/*GUI*/  if global-beam-me-up then undo, leave.


         /* DECLARATIONS FOR gptxcval.i */
         {gptxcdec.i}

         {gpaud.i &uniq_num1 = 01  &uniq_num2 = 02
                  &db_field = cm_mstr &db_field = cm_addr}
         {gpaud.i &uniq_num1 = 03  &uniq_num2 = 04
                  &db_field = ad_mstr &db_field = ad_addr}

         /* DISPLAY SELECTION FORM */
         {xxcsmt02.i}

         find first gl_ctrl no-lock.
         do transaction on error undo, retry:
            find first adc_ctrl no-lock no-error.
            if not available adc_ctrl then create adc_ctrl.
            recno = recid(adc_ctrl).
         end.

         find first soc_ctrl no-lock no-error.

         /* DISPLAY */
         mainloop:
         repeat:
/*GUI*/ if global-beam-me-up then undo, leave.

            innerloop: repeat:
/*GUI*/     if global-beam-me-up then undo, leave.

               new_cust = false.

             /* IF WE'VE ADDED A NEW CUSTOMER & AUTOGEN IS ON, ADD IT TO ANX */
               find first pic_ctrl no-lock no-error.
               if available pic_ctrl then
                  if pic_cust_regen and regen_add then do:
                     {gprun.i ""adcsgen.p"" "(input ""9"", input cust_node)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                     regen_add = no.
                  end.

               assign reccm = recid(cm_mstr)
               recad = recid(ad_mstr).

               run p-upd-frameb(input-output reccm,
                                input-output recad,
                                output l_exit).

               find cm_mstr where recid(cm_mstr) = reccm no-lock no-error.
               find ad_mstr where recid(ad_mstr) = recad no-lock no-error.

               if l_exit then undo, leave mainloop.

               loopa:
               do transaction with frame a on endkey undo, leave loopa:
/*GUI*/ if global-beam-me-up then undo, leave.

                  /* ADD/MOD/DELETE  */
                  find ad_mstr where ad_addr = cmnbr no-error.
                  if not available ad_mstr then do:
                     create ad_mstr.
                     assign ad_addr = cmnbr.
                     ad_type = "customer".
                     ad_date = today.
                     ad_format = adc_format.
                     new_cust = true.
                     recno = recid(ad_mstr).
                  end.


                  /* STORE MODIFY DATE AND USERID */
                  ad_mod_date = today.
                  ad_userid = global_userid.

                  new_cmmstr = no.
                  find cm_mstr where cm_addr = ad_addr no-error.
                  if not available cm_mstr then do:
                     {mfmsg.i 1 1}
                     create cm_mstr.
                     assign cm_addr = cmnbr
                     cm_sort = ad_name.
                      new_cmmstr = yes.
                     recno = recid(cm_mstr).
                     create ls_mstr.
                     assign ls_addr = cm_addr.
                     ls_type = "customer".
                     recno = recid(ls_mstr).
                     if available gl_ctrl then do:
                        cm_ar_acct = gl_ar_acct.
                        cm_ar_cc = gl_ar_cc.
                        cm_curr = gl_base_curr.
                     end.
                     regen_add = yes.     /* we have a record so we can add  */
                     cust_node = cm_addr. /* this customer (node) to anx_det. */
                  end.

                  promo_old = cm_promo.

                  /* STORE MODIFY DATE AND USERID */
                  cm_mod_date = today.
                  cm_userid = global_userid.
                  {gpaud1.i &uniq_num1 = 01  &uniq_num2 = 02
                            &db_file = cm_mstr &db_field = cm_addr}
                  {gpaud1.i &uniq_num1 = 03  &uniq_num2 = 04
                            &db_file = ad_mstr &db_field = ad_addr}
/***
                  if {txnew.i} then
                     display ad_taxable @ cm_taxable with frame b.
***/
                  del-yn = no.
                  recno = recid(ad_mstr).

                  ststatus = stline[2].
                  status input ststatus.
                  
                  if ad_vat_reg = ""  then 
                     ad_vat_reg = substring(ad_pst_id,3,18) .
                     
                  display cm_addr LABEL "客户"
                     ad_name ad_line1 ad_line2 ad_line3
                     ad_zip ad_format 
                     ad_attn ad_phone ad__chr01 ad_vat_reg .

                  set1:
                  do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

                     set ad_name FORMAT "x(70)"  LABEL "名称"
                         ad_line1 FORMAT "x(70)" LABEL "地址1"
                         ad_line2 FORMAT "x(70)" LABEL "地址2"
                         ad_line3 FORMAT "x(70)" LABEL "地址3"                           /*yangxing030905增加ad_name存储长度*/
                         ad_format 
                         ad_zip   LABEL "邮政编码"
                         ad_attn  LABEL "联系人"
                         ad_phone LABEL "电话"
                         ad__chr01 format "x(70)" 
                         ad_vat_reg FORMAT "x(20)" LABEL "税号".           /*yangxing030905增加ad__chr01,ad_vat_reg存储长度*/

                     if ad_format <> 0 then do:
                        find first code_mstr where code_fldname = "ad_format"
                        and code_value = string(ad_format) no-lock no-error.
                        if not available code_mstr then do:
                           {mfmsg.i 716 4}
                           /* Value must exist in generalized codes */
                           next-prompt ad_format. undo.
                        end.
                     end.
                     assign ad_pst_id = substring(ad_pst_id,1,2) + ad_vat_reg .
                     assign ad__chr04 = "No" 
                            ad__chr05 = "No".
                                                 
                  end.
/*GUI*/ if global-beam-me-up then undo, leave.

                  status input.

                  run p-call-apm
                      (input cm_promo,
                       input cm_addr,
                       input promo_old,
                       input del-yn).
               end.
/*GUI*/ if global-beam-me-up then undo, leave.
               /* END LOOP A  */

               if keyfunction(lastkey) = "END-ERROR" then
                  next mainloop.

               /* Get Tax data */
               ad_recno = recid(ad_mstr).

               /* Updates to frame b moved to adcsmtp.p */
               cm_recno = recid (cm_mstr).
               ad_recno = recid (ad_mstr).
               errfree  = false.

               run p-call-apm
                   (input cm_promo,
                    input cm_addr,
                    input promo_old,
                    input del-yn).

               /* Frame p for Promotion Data update **/
               if soc_apm then
                  promo_loop:
                  do with frame p on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

                     display cm_promo.
                     update cm_promo.
                  end.
/*GUI*/ if global-beam-me-up then undo, leave.


               run p-call-apm
                   (input cm_promo,
                    input cm_addr,
                    input promo_old,
                    input del-yn).
               leave innerloop.

            end.
/*GUI*/ if global-beam-me-up then undo, leave.

 /*innerloop*/

            /* AUDIT TRAIL SECTION */
            {gpaud2.i &uniq_num1 = 01  &uniq_num2 = 02
                      &db_file = cm_mstr &db_field = cm_addr &db_field1 = """"}
            {gpaud2.i &uniq_num1 = 03  &uniq_num2 = 04
                      &db_file = ad_mstr &db_field = ad_addr &db_field1 = """"}

         end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /*mainloop*/

         procedure p-call-apm:
            /* -----------------------------------------------------------
            Purpose:     Call the appropriate external APM program to
                         handle the condition
            Parameters:
                 input:  promo_flag  Promotion Flag
                 input:  address     Customer Address
                 input:  promo_old
                 input:  del-yn      Delete Flag
            Notes:       Because of the oracle compile size we have to
                         use this internal procedure to call APM
            -------------------------------------------------------------*/
            define input parameter promo_flag like cm_promo.
            define input parameter address like cm_addr.
            define input parameter promo_old like cm_promo.
            define input parameter del-yn like mfc_logical.
            define variable apm-ex-prg as character format "x(10)" no-undo.
            define variable apm-ex-sub as character format "x(24)" no-undo.

            find first soc_ctrl no-lock no-error.
            if del-yn then do:
               if soc_apm and (promo_old <> "" or promo_flag <> "") then do:
                  /* Future logic will go here to determine subdirectory*/
                  apm-ex-prg = "ifcustd.p".
                  apm-ex-sub = "if/".
                  {gprunex.i
                      &module   = 'APM'
                      &subdir   = apm-ex-sub
                      &program  = 'ifcustd.p'
                      &params   = "(input address)" }
               end.
            end.
            else do:
               if soc_apm and (promo_old <> "" or promo_flag <> "") then do:
                  /* Future logic will go here to determine subdirectory*/
                  apm-ex-prg = "ifcust.p".
                  apm-ex-sub = "if/".
                  {gprunex.i
                      &module   = 'APM'
                      &subdir   = apm-ex-sub
                      &program  = 'ifcust.p'
                      &params   = "(input address)" }
               end.
            end.

         end procedure. /* p-call-apm */

         {gpaud3.i &uniq_num1 = 01  &uniq_num2 = 02
                      &db_file = cm_mstr &db_field = cm_addr}
         {gpaud3.i &uniq_num1 = 03  &uniq_num2 = 04
                      &db_file = ad_mstr &db_field = ad_addr}
         status input.

         procedure p-upd-frameb:
            define input-output parameter reccm as recid.
            define input-output parameter recad as recid.
            define output parameter l_exit like mfc_logical.

            find cm_mstr where recid(cm_mstr) = reccm no-lock no-error.
            find ad_mstr where recid(ad_mstr) = recad no-lock no-error.
            for first et_ctrl no-lock: end.

            assign l_exit = true.

            do transaction with frame a on endkey undo, leave /*mainloop*/:
/*GUI*/ if global-beam-me-up then undo, leave.

               view frame a.

               prompt-for cm_mstr.cm_addr editing:

                  /* FIND NEXT/PREVIOUS RECORD */
                  {mfnp.i cm_mstr cm_addr cm_addr cm_addr cm_addr cm_addr}

                  if recno <> ? then do:
                     find ad_mstr where ad_addr = cm_addr no-lock no-error.
                     display cm_addr ad_name ad_line1 ad_line2 ad_line3
                        ad_zip ad_format 
                        ad_attn ad_phone ad__chr01 
                        substring(ad_pst_id,3,18) @ ad_vat_reg.                     
                  end.
               end.

               find cm_mstr where cm_addr = input cm_addr no-lock no-error.
               if not available cm_mstr then do:
/*                {mfmsg.i 861 3} /* COUNTRY CODE DOES NOT EXIST */ */
                  next-prompt cm_addr with frame a.
                  undo , retry.                              
               end.
               
               if input cm_addr = " " then do:
                  {mfmsg.i 906 3} /* COUNTRY CODE DOES NOT EXIST */
                  next-prompt cm_addr with frame a.
                  undo , retry.
/*
                  {mfactrl.i cmc_ctrl cmc_nbr ad_mstr ad_addr cmnbr}
                  cmnbr = string(integer(cmnbr),"99999999").
**/
               end.
               if input cm_addr <> "" then cmnbr = input cm_addr.
                  assign l_exit = false.

            end.
/*GUI*/ if global-beam-me-up then undo, leave.

            assign reccm = recid(cm_mstr)
                   recad = recid(ad_mstr).
         end procedure.
