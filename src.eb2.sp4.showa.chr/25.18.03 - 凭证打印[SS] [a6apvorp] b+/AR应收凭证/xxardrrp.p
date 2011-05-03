/* ardrrp.p - AR DETAIL DR/CR MEMO AUDIT REPORT                         */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*K0QC*/
/*V8:ConvertMode=FullGUIReport                                 */
/* REVISION: 1.0      LAST MODIFIED: 07/16/86   BY: PML                 */
/* REVISION: 6.0      LAST MODIFIED: 08/27/90   BY: afs *D062*          */
/*                                   10/29/90   BY: MLB *D153*          */
/*                                   01/02/91   BY: afs *D283*          */
/*                                   02/28/91   BY: afs *D387*          */
/*                                   03/06/91   BY: bjb *D865*          */
/*                                   04/10/91   BY: bjb *D515*          */
/*                                   09/26/91   BY: WUG *D878*          */
/* REVISION: 7.0      LAST MODIFIED: 02/12/92   BY: jms *F201*          */
/*                                   03/04/92   BY: jms *F237*          */
/* REVISION: 7.0      LAST MODIFIED: 03/17/92   BY: TMD *F258*          */
/* REVISION: 7.0      LAST MODIFIED: 03/22/92   BY: TMD *F302*          */
/* REVISION: 7.0      LAST MODIFIED: 04/11/92   BY: afs *F356*          */
/* REVISION: 7.0      LAST MODIFIED: 05/29/92   BY: jjs *F559*          */
/* REVISION: 7.3      LAST MODIFIED: 08/03/92   BY: jms *G024*          */
/*                                   10/14/92   BY: jms *G177*          */
/*                                   09/27/93   BY: jcd *G247*          */
/*                                   05/13/93   BY: pcd *GA88*          */
/* REVISION: 7.4      LAST MODIFIED: 08/05/93   BY: bcm *H056*          */
/*                                   09/02/93   BY: wep *H102*          */
/*                                   09/02/93   BY: rxm *GL40*          */
/* REVISION: 7.4      LAST MODIFIED: 09/11/94   by: slm *GM15*          */
/* REVISION: 7.4      LAST MODIFIED: 11/08/94   by: jzs *GN61*          */
/* REVISION: 8.5      LAST MODIFIED: 12/12/95   by: taf & mwd *J053*    */
/*                                   04/08/96   by: jzw *G1T9*          */
/* REVISION: 8.5      LAST MODIFIED: 07/29/96   BY: taf *J101*          */
/* REVISION: 8.5      LAST MODIFIED: 12/20/96   BY: rxm *G2JR*          */
/* REVISION: 8.6      LAST MODIFIED: 02/18/97   BY: *K06Z* M. Madison   */
/* REVISION: 8.6      LAST MODIFIED: 10/10/97   BY: bvm *K0QC*          */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane    */
/* REVISION: 8.6E     LAST MODIFIED: 06/26/98   BY: *L01K* Jaydeep Parikh */
/* REVISION: 8.6E     LAST MODIFIED: 09/16/98   BY: *L098* G.Latha        */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/************************************************************************/

          {mfdtitle.i "f+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE ardrrp_p_1 "支付方式!催!帐!级"
/* MaxLen: Comment: */

&SCOPED-DEFINE ardrrp_p_2 "金额!已分配金额"
/* MaxLen: Comment: */

&SCOPED-DEFINE ardrrp_p_3 "财务费"
/* MaxLen: Comment: */

/*L01K* &SCOPED-DEFINE ardrrp_p_4 "Cur!Exch Rate" */
/*L01K*/ &SCOPED-DEFINE ardrrp_p_4 "币"
/* MaxLen: Comment: */

&SCOPED-DEFINE ardrrp_p_5 "基本货币报表合计"
/* MaxLen: Comment: */

&SCOPED-DEFINE ardrrp_p_6 "通知"
/* MaxLen: Comment: */

&SCOPED-DEFINE ardrrp_p_7 "日期!生效日期"
/* MaxLen: Comment: */

&SCOPED-DEFINE ardrrp_p_8 "票据开往!销往"
/* MaxLen: Comment: */

&SCOPED-DEFINE ardrrp_p_9 "发票"
/* MaxLen: Comment: */

&SCOPED-DEFINE ardrrp_p_10 " 报表合计"
/* MaxLen: Comment: */

&SCOPED-DEFINE ardrrp_p_11 "争议!定税日期"
/* MaxLen: Comment: */

&SCOPED-DEFINE ardrrp_p_12 " 合计"
/* MaxLen: Comment: */

&SCOPED-DEFINE ardrrp_p_13 " 批处理 "
/* MaxLen: Comment: */

/*L01K* &SCOPED-DEFINE ardrrp_p_14 "Name!PO" */
/*L01K*/ &SCOPED-DEFINE ardrrp_p_14 "名称!兑换率!采购单"
/* MaxLen: Comment: */

&SCOPED-DEFINE ardrrp_p_15 "打印总帐明细"
/* MaxLen: Comment: */

&SCOPED-DEFINE ardrrp_p_16 "参考类型"
/* MaxLen: Comment: */

&SCOPED-DEFINE ardrrp_p_17 "类型"
/* MaxLen: Comment: */

&SCOPED-DEFINE ardrrp_p_18 "S-汇总/D-明细"
/* MaxLen: Comment: */

/*L098*/ /* HARDCODED STRING "Base" HAS BEEN REPLACED BY PRE-PROCESSOR */
&SCOPED-DEFINE ardrrp_p_19 "基本"
/* MaxLen:4 Comment: */

/* ********** End Translatable Strings Definitions ********* */

          /* DEFINE NEW SHARED WORKFILE AP_WKFL FOR CURRENCY SUMMARY */
          {gpacctp.i "new"}

          define new shared variable rndmthd like rnd_rnd_mthd.
           /* OLD_CURR IS USED BY GPACCTP.P */
          define new shared variable old_curr like ar_curr.
          define variable oldsession   as character.
          define variable c_session   as character.
          define variable oldcurr      like ar_curr.
          define variable cust         like ar_bill.
          define variable cust1        like ar_bill.
          define variable nbr          like ar_nbr.
          define variable nbr1         like ar_nbr.
          define variable batch        like ar_batch.
          define variable batch1       like ar_batch.
          define variable entity       like ar_entity.
          define variable entity1      like ar_entity.
          define variable ardate       like ar_date.
          define variable ardate1      like ar_date.
          define variable effdate      like ar_effdate.
          define variable effdate1     like ar_effdate.
/*L01K*   define variable name         like ad_name format "x(27)". */
/*L01K*/  define variable name         like ad_name format "x(35)".
          define variable type         like ar_type format "X(4)"
             label {&ardrrp_p_17}.
          define variable select_type  like ar_type
             label {&ardrrp_p_16} initial " ".
          define variable gltrans      like mfc_logical initial no
             label {&ardrrp_p_15}.
          define variable summary      like mfc_logical format {&ardrrp_p_18}
             initial no label {&ardrrp_p_18}.
          define variable base_rpt     like ar_curr.
          define variable mixed_rpt    like mfc_logical initial no
            /* label {gpmixlbl.i} */ .
          define variable base_damt    like ard_amt
             format "->,>>>,>>>,>>9.99".
          define variable base_amt     like ar_amt
             format "->,>>>,>>>,>>9.99".
          define variable base_applied like ar_applied
             format "->,>>>,>>>,>>9.99".
          define variable disp_curr    as character format "x(1)" label "C".
          define variable batch_title  as character format "x(30)".
          define new shared variable undo_txdetrp like mfc_logical.
          define variable tax_tr_type  like tx2d_tr_type initial "18".
          define variable tax_nbr      like tx2d_nbr initial "".
          define variable page_break   as integer initial 0.
          define variable col-80       as logical initial false.
          define variable disp_amt     like base_amt.
          define variable disp_applied like base_applied.
          define variable base_amt_fmt as character.
          define variable curr_amt_fmt as character.
          define variable curr_amt_old as character.
/*L01K*/  define variable mc-error-number like msg_nbr no-undo.
/*L01K*/ define variable ex_rate_relation1 as character format "x(40)" no-undo.
/*L01K*/ define variable ex_rate_relation2 as character format "x(40)" no-undo.
         def var num as int format "999" .
         def var gltref like glt_ref .
         def var gltacc  like glt_acct .
         def var gltsub   like glt_sub .
         def var gltamt like glt_amt .
         def var gltcc like glt_cc .
         def var gltproject like glt_project .
         def var gltcurr like glt_curr .
/*apple*/ DEFINE TEMP-TABLE tmp_det NO-UNDO
                      field tmp_ref          like glt_ref
                      field tmp_cr_terms     like ar_cr_terms
                      field tmp_due_date     like ar_due_date
                      field tmp_cust         like ar_cust
                      field tmp_tax          like tx2_tax_pct
                      field tmp_balance      like cm_balance
                      field tmp_name         like ad_name
                      field tmp_inv_cr       like ar_inv_cr
                      field tmp_cr_limit     like cm_cr_limit
                      field tmp_type         like ar_type
                      field tmp_batch        like ar_batch
                      field tmp_nbr          like ar_nbr
                      field tmp_date         like ar_date
                      field tmp_ex_rate      like ar_ex_rate
                      field tmp_dun_level    like ar_dun_level
                      field tmp_effdate      like ar_effdate
                      field tmp_entity       like ar_entity
                      field tmp_rmks         like ar_po
                      field tmp_tax_date     like ar_tax_date
                      field tmp_aramt        like ar_amt
                      field tmp_item         as integer  format "999"
                      field tmp_acct         like ard_acct format "x(24)"
                      field tmp_desc2        like ac_desc format "x(24)"
                      field tmp_curr         like ar_curr
                      field tmp_cc           like ard_cc format "x(24)"
                      field tmp_desc         like ac_desc format "x(24)"
                      field tmp_project      like ard_project format "x(24)"
                      field tmp_desc3        like ac_desc  format "x(24)"
/*mage*/              field tmp_desc4        as  char  format "x(24)"
                      field tmp_ar_amt       like ard_amt  FORMAT "->>,>>>,>>>,>>9.99"
                      field tmp_ar_amt2      like ard_cur_amt  FORMAT "->>,>>>,>>>,>>9.99"
                      field tmp_ap_amt       like ard_amt  FORMAT "->>,>>>,>>>,>>9.99"
                      field tmp_ap_amt2      like ard_cur_amt FORMAT "->>,>>>,>>>,>>9.99"
                      field tmp_dy_code      like dy_dy_code
                      field tmp_char         as char format "x(1)"
                      .
         define variable first-page like mfc_logical initial yes.
         define variable tot_ar_amt       like ard_amt FORMAT "->>,>>>,>>>,>>9.99" . 
         define variable tot_ar_amt2      like ard_cur_amt FORMAT "->>,>>>,>>>,>>9.99" .
         define variable tot_ap_amt       like ard_amt FORMAT "->>,>>>,>>>,>>9.99" .
         define variable tot_ap_amt2      like ard_cur_amt FORMAT "->>,>>>,>>>,>>9.99" .
         define buffer tmp_det2 for tmp_det.
         def var page_num as int format "999" .
/*apple*/         define new shared variable ref like ar_nbr .
/*apple*/         define new shared variable ref1 like ar_nbr.
         define variable ii as integer format "999".


/*L01K*/ /* MUST INCLUDE gprunpdf.i IN THE MAIN BLOCK OF THE PROGRAM SO THAT */
/*L01K*/ /* CALLS TO gprunp.i FROM ANY OF THE INTERNAL PROCEDURES SKIPS  */
/*L01K*/ /* DEFINITION OF SHARED VARS OF gprunpdf.i */
/*L01K*/ /* FOR FURTHER INFO REFER TO HEADER COMMENTS IN gprunp.i */
/*L01K*/ {gprunpdf.i "mcpl" "p"}
/*L01K*/ {gprunpdf.i "mcui" "p"}

          {txcurvar.i "NEW"}
          form
         ref        colon 18  label  '参考'  ref1   colon 49 label {t001.i}  
          batch        colon 18 batch1   colon 49 label {t001.i}
         /* nbr          colon 18 nbr1     colon 49 label {t001.i}  */
          cust         colon 18 cust1    colon 49 label {t001.i}
          entity       colon 18 entity1  colon 49 label {t001.i}
          ardate       colon 18 ardate1  colon 49 label {t001.i}
          effdate      colon 18 effdate1 colon 49 label {t001.i}
          select_type  colon 18 skip (1)
          
          
 /*         summary      colon 25
          gltrans      colon 25
          base_rpt     colon 25
          mixed_rpt    colon 25*/
          with frame a side-labels width 80.

         form
             /*tmp_item      at 28    column-label "序!号" */
             num at 28  column-label '序!号'
             tmp_acct    at 32       column-label "账户和分账户!(代码+摘要)"
             tmp_curr      at 57        column-label "币别"
             tmp_cc      at 62       column-label "成本中心 !(代码+摘要)"
             tmp_project  at 87     column-label "项目  !(代码+摘要)"
             tmp_ar_amt   at 112     column-label "    借方     !(原币/本币)" FORMAT "->>,>>>,>>>,>>9.99"
             tmp_ap_amt  at 134     column-label  "    贷方     !(原币/本币)" FORMAT "->>,>>>,>>>,>>9.99"
             /*tmp_ap_amt        column-label "贷方 !(原币)"
             tmp_ap_amt2       column-label "贷方 !(本币)" */
         with frame c width 170 down.
           
         form
                     tmp_ref       at 28     label "AR总账参考号"    
                     tmp_cr_terms  at 82    label "支付方式"          
                     tmp_due_date  at 136   label "到期日"   
                    
                     tmp_cust      at 28     label "客户代码"
                     tmp_tax      at 82    label "税率"
                     tmp_balance     at 136   label "应收余额"
                   
                     tmp_name        at 28     label "客户名称"
                     tmp_inv_cr      at 82    label "发票号"
                     tmp_cr_limit    at 136   label "信用额度"
                     
                     tmp_type       at 28     label "类型"
                     tmp_batch      at 82    label "批处理"
                     tmp_nbr        at 136   label "DR/CR号"
                     
                     tmp_date       at 28     label "日期"
                     tmp_ex_rate    at 82    label "兑换率"
                     tmp_dun_level  at 136   label "催账级别"
                    
                     tmp_effdate    at 28     label "生效日期"
                     tmp_entity     at 82    label "会计单位"
                     tmp_rmks       at 136   label "备注"
                     
                     tmp_tax_date   at 28     label "定税日期"
                     tmp_aramt      at 82    label "应收金额"
                     
         with frame e width 300 side-labels.

          find first gl_ctrl no-lock.

/*          base_amt_fmt = base_amt:format in frame c.*/
          {gprun.i ""gpcurfmt.p"" "(input-output base_amt_fmt,
                                    input gl_rnd_mthd)"}
/*          curr_amt_old = base_amt:format in frame c.*/
          oldcurr = "".
          oldsession = SESSION:numeric-format.

          {wbrp01.i}

          repeat:

             find first ap_wkfl no-error.
             if available ap_wkfl then for each ap_wkfl EXCLUSIVE-LOCK:
                delete ap_wkfl.
             end.

             if ref1 = hi_char then ref1 = "".
             if batch1 = hi_char then batch1 = "".
             if nbr1 = hi_char then nbr1 = "".
             if cust1 = hi_char then cust1 = "".
             if entity1 = hi_char then entity1 = "".
             if ardate = low_date then ardate = ?.
             if ardate1 = hi_date then ardate1 = ?.
             if effdate = low_date then effdate = ?.
             if effdate1 = hi_date then effdate1 = ?.

             if c-application-mode <> 'web':u then
             update  ref ref1  batch batch1 /* nbr nbr1 */ cust cust1 entity entity1
                ardate ardate1 effdate effdate1 select_type  /*
                summary gltrans base_rpt
                 mixed_rpt*/
             with frame a.

         {wbrp06.i &command = update
                   &fields = "  batch batch1
                                 ref ref1  
                                cust cust1
                                entity entity1
                                ardate ardate1
                                effdate effdate1
                                select_type
                                "
                   &frm = "a"}  /* nbr nbr1 */

         if (c-application-mode <> 'web':u) or
         (c-application-mode = 'web':u and
         (c-web-request begins 'data':u)) then do:

             bcdparm = "".
             {mfquoter.i ref    }
             {mfquoter.i ref1   }  
             {mfquoter.i batch    }
             {mfquoter.i batch1   }
           /*  {mfquoter.i nbr      }
             {mfquoter.i nbr1     } */
             {mfquoter.i cust     }
             {mfquoter.i cust1    }
             {mfquoter.i entity   }
             {mfquoter.i entity1  }
             {mfquoter.i ardate   }
             {mfquoter.i ardate1  }
             {mfquoter.i effdate  }
             {mfquoter.i effdate1 }  
             {mfquoter.i select_type } 
             
             if ref1 = "" then ref1 = hi_char.
             if batch1 = "" then batch1 = hi_char.
             if nbr1 = "" then nbr1 = hi_char.
             if cust1 = "" then cust1 = hi_char.
             if entity1 = "" then entity1 = hi_char.
             if ardate = ? then ardate = low_date.
             if ardate1 = ? then ardate1 = hi_date.
             if effdate = ? then effdate = low_date.
             if effdate1 = ? then effdate1 = hi_date.
             /* VALIDATE SELECT TYPE */
             if select_type <> "" and (lookup(select_type,"M,I,F") = 0) then do:
                {mfmsg.i 1172 3}

                /*if c-application-mode = 'web':u then return.
                else next-prompt select_type with frame a.*/
                undo, retry.
             end.

         end.

             /* SELECT PRINTER */
             {mfselbpr.i "printer" 200}
             assign page_num  = 1 .
             {xxmfphead1.i}
              
   /*          form header
             skip(1)
             with frame a1 page-top width 200.
             view frame a1.
*/


             /* DELETE GL WORKFILE ENTRIES */
             if gltrans = yes then do:
                for each gltw_wkfl where gltw_userid = mfguser exclusive-lock:
/*L01K*/           {gprunp.i "mcpl" "p" "mc-delete-ex-rate-usage"
                             "(input gltw_wkfl.gltw_exru_seq)" }
                   delete gltw_wkfl.
                end.
             end.

           for each tmp_det:
               delete tmp_det.
           end.
           
            for each ar_mstr where (ar_nbr >= ref) and (ar_nbr <= ref1)
                                   and (ar_batch >= batch) and (ar_batch <= batch1) and
                                    (ar_nbr  >= nbr) and (ar_nbr <= nbr1) and
                                    (ar_bill >= cust) and (ar_bill <= cust1) and
                                    (ar_entity >= entity) and
                                    (ar_entity <= entity1) and
                                    (ar_date >= ardate) and
                                    (ar_date <= ardate1) and
                                    (ar_effdate >= effdate) and
                                    (ar_effdate <= effdate1) and
                                     ( ar_type = select_type or select_type = '' ) and
                                    (ar_type <> "P") and
                                    (ar_type <> "D") and
                                    (ar_type <> "U")  and
                                    (ar_type <> "A") 
                       /* and ((ar_curr = base_rpt)*/
                        no-lock ,
              each ard_det no-lock where ard_nbr = ar_nbr              
                        break by ar_nbr by ar_batch by ar_nbr:
                        if first-of(ar_batch) then ii = 2.
                    for first  glt_det where glt_batch = ar_batch and glt_doc = ar_nbr  no-lock:  assign gltref = glt_ref .  end.
                    for first gltr_hist where  gltr_batch = ar_batch and gltr_doc = ar_nbr no-lock: assign gltref = gltr_ref  .  end.
                        
                        if first-of(ar_nbr) then 
                        do:
                          create tmp_det.                        
                        assign
                          tmp_ref          = gltref 
                          tmp_cr_terms     = ar_cr_terms   
                          tmp_due_date     = ar_due_date   
                          tmp_cust         = ar_bill       
                          /*tmp_tax          ar            S
                          tmp_balance      = cm_balance    
                          tmp_name         = ad_name    */   
                          tmp_inv_cr       = ar_inv_cr     
                          /*tmp_cr_limit     = cm_cr_limit   */
                          tmp_type         = ar_type       
                          tmp_batch        = ar_batch      
                          tmp_nbr          = ar_nbr        
                          tmp_date         = ar_date       
                          tmp_ex_rate      = ar_ex_rate2 / ar_ex_rate   
                          tmp_dun_level    = ar_dun_level       
                          tmp_effdate      = ar_effdate    
                          tmp_entity       = ar_entity     
                          tmp_rmks         = ar_po         
                          tmp_tax_date     = ar_tax_date   
                          tmp_aramt        = ar_amt   

                          tmp_item         = ii
                          tmp_acct     = ar_acct
                          tmp_curr     = ar_curr
                          tmp_cc       = ar_cc
                          tmp_project  = ''
                          tmp_ar_amt   = ar_amt
                          tmp_ar_amt2  = ar_amt *  ar_ex_rate2 / ar_ex_rate
                          tmp_dy_code  = ar_dy_code
                          tmp_char     = "b"
                          /*tmp_ap_amt   =
                          tmp_ap_amt2  =*/
                          tmp_desc4 = ''
                          .
                        end.
                        create tmp_det.                        
                        assign
                          tmp_ref          = gltref 
                          tmp_cr_terms     = ar_cr_terms   
                          tmp_due_date     = ar_due_date   
                          tmp_cust         = ar_bill       
                          /*tmp_tax          ar            S
                          tmp_balance      = cm_balance    
                          tmp_name         = ad_name    */   
                          tmp_inv_cr       = ar_inv_cr     
                          /*tmp_cr_limit     = cm_cr_limit   */
                          tmp_type         = ar_type       
                          tmp_batch        = ar_batch      
                          tmp_nbr          = ar_nbr        
                          tmp_date         = ar_date       
                          tmp_ex_rate      = ar_ex_rate2 / ar_ex_rate   
                          tmp_dun_level    = ar_dun_level       
                          tmp_effdate      = ar_effdate    
                          tmp_entity       = ar_entity     
                          tmp_rmks         = ar_po         
                          tmp_tax_date     = ar_tax_date   
                          tmp_aramt        = ar_amt   

                          tmp_item         = ii
                          tmp_acct     = ard_acct
                          tmp_curr     = ar_curr
                          tmp_cc       = ard_cc
                          tmp_project  = ard_project
                          tmp_ap_amt   = ard_amt
                          tmp_ap_amt2  = ard_amt *  ar_ex_rate2 / ar_ex_rate
                          tmp_dy_code  = ar_dy_code
                          tmp_char     = "b"
                          /*tmp_ap_amt   =
                          tmp_ap_amt2  =*/
                          tmp_desc4 = ''
                          .
                          ii = ii + 1.
                          gltref = '' .
                     find first ac_mstr where ac_code = substring(tmp_acct,1,4) no-lock no-error.
                     if available ac_mstr then tmp_desc = ac_desc.
		                  find first sb_mstr where sb_sub = substring(tmp_acct,5,4) no-lock no-error.
                     if available sb_mstr then tmp_desc4 = sb_desc.
                     else tmp_desc4 = ''.
                      if trim(substring(tmp_acct,5,4)) = '' then tmp_desc4 = '' .
                     find first cc_mstr where cc_ctr = tmp_cc no-lock no-error.
                     if available cc_mstr then tmp_desc2 = cc_desc.
                     find first pj_mstr where pj_project = tmp_project no-lock no-error.
                     if available pj_mstr then tmp_desc3 = pj_desc.
                     /*find first ap_mstr where ap_bank = tmp_bank no-lock no-error.
                     if available ap_mstr then tmp_ckfrm = ap_ckfrm.*/
                     find first ad_mstr where ad_addr = tmp_cust no-lock no-error.
                     if available ad_mstr then tmp_name = ad_name.
                     find first cm_mstr where cm_addr = tmp_cust no-lock no-error.
                     if available cm_mstr then do:
                         tmp_balance =  cm_balance .
                         tmp_cr_limit = cm_cr_limit.
                     end.
                     find first tx2_mstr where tx2_tax_usage = ard_tax_usage no-lock no-error.
                     if available tx2_mstr then tmp_tax = tx2_tax_pct.

/*************************************************************************************************/

               if (oldcurr <> ar_curr) or (oldcurr = "") then do:
/*L01K*            {gpcurmth.i */
/*L01K*                 "ar_curr" */
/*L01K*                 "2" */
/*L01K*                 "next" */
/*L01K*                 "pause" } */
/*L01K*/           if ar_curr = gl_base_curr then
/*L01K*/              rndmthd = gl_rnd_mthd.
/*L01K*/           else do:
/*L01K*/              /* GET ROUNDING METHOD FROM CURRENCY MASTER */
/*L01K*/              {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
                       "(input ar_curr,
                         output rndmthd,
                         output mc-error-number)"}
                      if mc-error-number <> 0 then do:
/*L01K*/                 {mfmsg.i mc-error-number 2}
/*L01K*/                 if c-application-mode <> "WEB":U then
/*L01K*/                    next.
/*L01K*/                 pause.
/*L01K*/              end.
/*L01K*/           end.

                   /* DETERMINE CURRENCY DISPLAY AMERICAN OR EUROPEAN       */
                   find rnd_mstr where rnd_rnd_mthd = rndmthd no-lock no-error.
                   if not available rnd_mstr then do:
                      {mfmsg.i 863 2}    /* ROUND METHOD RECORD NOT FOUND */
                      if c-application-mode = 'web':u then return.
                      next.
                   end.
                   /* ASSUME START UP SESSION IS FOR BASE CURR */
                   if not (base_rpt = "" and not mixed_rpt)
                   then do:
                      /* IF RND_DEC_PT = COMMA FOR DECIMAL POINT */
                      /* THIS IS A EUROPEAN STYLE CURRENCY */
                      if (rnd_dec_pt = "," )
                      then
                         assign
                           c_session = "European"
                           SESSION:numeric-format = "European".
                      else
                         assign
                           c_session = "American"
                           SESSION:numeric-format = "American".
                   end.

                   oldcurr = ar_curr.
                   curr_amt_fmt = curr_amt_old.
                   {gprun.i ""gpcurfmt.p"" "(input-output curr_amt_fmt,
                                             input rndmthd)" }
                end.

                /* CONVERT CURRENCY TO BASE IF APPROPRIATE */
                if base_curr = ar_curr or base_rpt = ar_curr then do:
                   /* NO CONVERSION */
                   base_amt = ar_amt.
                   tmp_aramt = base_amt.
                   base_applied = ar_applied.
                   disp_curr = " ".
                end.
                else do:
                   /* CONVERSION */
/*L01K*            USE ar_base_amt FOR BASE EQUIVALENT OF ar_amt AND
*                      ar_base_applied FOR BASE EQUIVALENT OF ar_applied.
*                  base_amt = ar_amt / ar_ex_rate.
*                  base_applied = ar_applied / ar_ex_rate.
*                  /* ROUND PER BASE ROUND METHOD */
*                  {gprun.i ""gpcurrnd.p"" "(input-output base_amt,
*                     input gl_rnd_mthd)"}
*                  /* ROUND PER BASE ROUND METHOD */
*                  {gprun.i ""gpcurrnd.p"" "(input-output base_applied,
*                     input gl_rnd_mthd)"}
**L01K*/
                   assign base_amt = ar_base_amt.
                          base_applied = ar_base_applied.
                        tmp_aramt = base_amt.
                   disp_curr = "Y".
                end.

                if base_rpt = ""
                and mixed_rpt
                then disp_curr = "".

                /* BLOCK MOVED FROM BELOW */
                /* STORE TOTALS, BY CURRENCY, IN WORK FILE. */
                if base_rpt = ""
                and mixed_rpt
                then do:
                   find first ap_wkfl where ar_curr = apwk_curr no-error.
                   /* IF RECORD FOR THIS CURRENCY NON-EXISTENT, CREATE ONE */
                   if not available ap_wkfl then do:
                      create ap_wkfl.
                      apwk_curr = ar_curr.
                   end.

                   /* ACCUMULATE INDIVIDUAL CURRENCY TOTALS IN WORK FILE */
                   apwk_for = apwk_for + ar_amt.
                   if base_curr <> ar_curr then
                      apwk_base = apwk_base + base_amt.
                   else apwk_base = apwk_for.
                end.
                /* END BLOCK MOVE */

                accumulate base_amt (total by ar_batch).
                accumulate base_applied (total by ar_batch).

             /*   if first-of(ar_batch) then display ar_batch with frame b
                   side-labels.*/
                find ad_mstr where ad_addr = ar_bill no-lock no-wait no-error.
                if available ad_mstr then name = ad_name.
                else name = "".
                if ar_type = "M" then type = {&ardrrp_p_6}.
                else if ar_type = "I" then type = {&ardrrp_p_9}.
                else if ar_type = "F" then type = {&ardrrp_p_3}.
                else type = "".

             /*    display
                    ar_nbr
                    type
                    ar_bill
                    name
                    ar_date
                    ar_contested
                    ar_entity
                    ar_acct
                    ar_cc
                    ar_cr_terms
                    ar_curr
                    disp_curr
                 with frame c.*/

                /* IF BASE_RPT IS BLANK, AMOUNTS DISPLAYED IN ORIGINAL CURR   */
                /* ADDED DISP_BASE & DISP_APPLIED SO THAT THESE FIELDS COULD  */
                /* DISPLAY THE APPROPRIATE AMOUNTS WITHOUT OVERRIDING BASE_AMT*/
                /* AND BASE_APPLIED                                           */
                if base_rpt = ""
                and mixed_rpt
                then do:
                   /*base_amt:format in frame c = curr_amt_fmt.*/
                   disp_amt = ar_amt.
                   disp_applied = ar_applied.
                end.
                else do:
                  /* base_amt:format in frame c = base_amt_fmt.*/
                   disp_amt = base_amt.
                   disp_applied = base_applied.
                end.

              /*  display
                   disp_amt @ base_amt
                with frame c.
                down 1 with frame c.*/
                tmp_aramt = disp_amt.
/*L01K*          USE mc-ex-rate-output ROUTINE TO GET THE RATES FOR DISPLAY */
/*L01K*/         {gprunp.i "mcui" "p" "mc-ex-rate-output"
                    "(input ar_curr,
                      input base_curr,
                      input ar_ex_rate,
                      input ar_ex_rate2,
                      input ar_exru_seq,
                      output ex_rate_relation1,
                      output ex_rate_relation2)"}

/*L01K*         display ar_po @ name ar_effdate @ ar_date ar_ent_ex  @ ar_curr  */
/* /*L01K*/        display ex_rate_relation1 @ name ar_effdate @ ar_date
                   ar_cust @ ar_bill ar_tax_date @ ar_contested
                   disp_applied @ base_amt
                   string(ar_dun_level) @ ar_cr_terms
                with frame c.
                down 1 with frame c.
*/

/*L01K*/        if ex_rate_relation2 <> "" then
/*L01K*/           do:
/*L01K*/          /*   display ex_rate_relation2 @ name with frame c.
/*L01K*/             down 1 with frame c.*/
/*L01K*/           end.


/*L01K*/        if ar_po <>  "" then
/*L01K*/           do:
/*L01K*/          /*  display ar_po @ name with frame c.
/*L01K*/            down 1 with frame c.*/
/*L01K*/           end.

                if gltrans then do:
                   {gpnextln.i &ref=ar_bill &line=return_int}
                   create gltw_wkfl.
                   assign gltw_entity = ar_entity
                          gltw_acct = ar_acct
                          gltw_cc = ar_cc
                          gltw_ref = ar_bill
                          gltw_line = return_int
                          gltw_date = ar_date
                          gltw_effdate = ar_effdate
                          gltw_userid = mfguser
                          gltw_desc = ar_batch + " " + ar_type + " " + ar_nbr +
                             " " + ar_bill
                          gltw_amt = base_amt.
                   recno = recid(gltw_wkfl).
                end.

                /* GET AR DETAIL  */
/*                for each ard_det where ard_nbr = ar_nbr and
                                       ard_ref = "" no-lock
                                       by ard_acct with frame d width 200:*/

                   if ar_curr = base_curr or ar_curr = base_rpt then
                   do:
                     /* base_damt:format in frame d = curr_amt_fmt.*/
                      base_damt = ard_amt.
                   end.
                   else do:
/*L01K*               base_damt = ard_amt / ar_ex_rate. */
/*L01K*/              /* CONVERT FROM FOREIGN TO BASE CURRENCY */
/*L01K*/              {gprunp.i "mcpl" "p" "mc-curr-conv"
                       "(input ar_curr,
                         input base_curr,
                         input ar_ex_rate,
                         input ar_ex_rate2,
                         input ard_amt,
                         input true, /* ROUND */
                         output base_damt,
                         output mc-error-number)"}.
/*L01K*/                if mc-error-number <> 0 then do:
/*L01K*/                   {mfmsg.i mc-error-number 4}.
/*L01K*/                end.
/*L01K*               ROUNDING DONE BY mc-curr-conv
*                     /* ROUND PER BASE ROUND METHOD */
*                     {gprun.i ""gpcurrnd.p"" "(input-output base_damt,
*                        input gl_rnd_mthd)"}
**L01K*/
                 /*     base_damt:format in frame d = base_amt_fmt.*/
/*apple                   end.*/

                   if not summary then do:
                     /* display
                         ard_entity
                         ard_acct
                         ard_cc
                         ard_project
                      with frame d.*/

                      if base_rpt = ""
                      and mixed_rpt
                      then
                      do:
                        /* base_damt:format in frame d = curr_amt_fmt.
                         display ard_amt @ base_damt ard_desc
                         with frame d.*/
                      end.
                      else
                      do:
                        /* base_damt:format in frame d = base_amt_fmt.
                          display base_damt ard_desc
                         with frame d.*/
                      end.
                      /*down with frame d.*/
                   end.

                   if gltrans then do:
                      {gpnextln.i &ref=ar_bill &line=return_int}
                      create gltw_wkfl.
                      assign gltw_entity = ard_entity
                             gltw_acct = ard_acct
                             gltw_cc = ard_cc
                             gltw_project = ard_project
                             gltw_date = ar_date
                             gltw_ref = ar_bill
                             gltw_line = return_int
                             gltw_effdate = ar_effdate
                             gltw_userid = mfguser
                             gltw_desc = ar_batch + " " + ar_type + " " +
                                ar_nbr + " " + ar_bill
                             gltw_amt = - base_damt.
                      recno = recid(gltw_wkfl).
                   end.
                end.

                if {txnew.i} then do:
                   undo_txdetrp = true.
                   {gprun.i  ""txdetrp.p"" "(input tax_tr_type,
                                             input ar_nbr,
                                             input tax_nbr,
                                             input col-80,
                                             input page_break)" }
                   if undo_txdetrp = true then undo, leave.
                end.

   /*             if last-of(ar_batch) then do:
                   /* RESET SESSION TO BASE */
                   SESSION:numeric-format = oldsession.
                   /* DISPLAY BATCH TOTAL. */
                   if base_rpt = ""
                   and mixed_rpt
                   then
                   do:
                     /* ar_amt:format in frame e = base_amt_fmt.
                      ar_applied:format in frame e = base_amt_fmt.*/
                   end.
                   else
                   do:
                     /* ar_amt:format in frame e = curr_amt_fmt.
                      ar_applied:format in frame e = curr_amt_fmt.*/
                   end.

                 /*  if page-size - line-counter < 3 then page.

                   display
                           (if base_rpt = ""
/*L098**                    then "Base" */
/*L098*/                    then {&ardrrp_p_19}
                            else base_rpt)
                           + {&ardrrp_p_13} + ar_batch + {&ardrrp_p_12}
                           @ batch_title
                           accum total by ar_batch (base_amt) @ ar_amt
                           accum total by ar_batch (base_applied) @ ar_applied
                           with frame e.
*/
                end.
*/
  /*              {mfrpexit.i}*/

                /* DISPLAY REPORT TOTAL */
              /*  if last(ar_nbr) then do:
                   /* RESET SESSION TO BASE */
                   SESSION:numeric-format = oldsession.
                   /*down with frame e.
                   if page-size - line-counter < 2 then page.
                   display
                           (if base_rpt = ""
                            then {&ardrrp_p_5}
                            else base_rpt + {&ardrrp_p_10})
                           @ batch_title
                           accum total (base_amt) @ ar_amt
                           accum total (base_applied) @ ar_applied
                           with frame e.*/
                end.*/
                if (base_rpt <> "") then
                   SESSION:numeric-format = c_session.
             end. /* FOR EACH AR_MSTR */
/***********************/
/*************************************************************************************************
            first-page = yes.
            for each tmp_det :
               find first glt_det where glt_batch = tmp_det.tmp_batch and ( glt_tr_type = "AR" or glt_tr_type = "so" ) and glt_doc = tmp_det.tmp_nbr and glt_amt < 0 no-lock no-error.
               if available glt_det then assign gltref = glt_ref  gltacc = glt_acct gltsub = glt_sub gltamt = glt_amt .
               find first gltr_hist where gltr_batch = tmp_det.tmp_batch and ( gltr_tr_type = "AR" or gltr_tr_type = "SO" ) and gltr_doc = tmp_det.tmp_nbr and gltr_amt < 0 no-lock no-error.
               if available gltr_hist then assign gltref = gltr_ref  gltacc = gltr_acc gltsub = gltr_sub gltamt = gltr_amt .
                   if available glt_det or available gltr_hist then do:
                       tmp_det.tmp_ref = gltref.
                       tmp_det.tmp_acct = gltacc + gltsub.
                     find first ac_mstr where ac_code = gltacc no-lock no-error.
                     if available ac_mstr then tmp_desc = ac_desc.
                   end.
            end.
            for each tmp_det break by tmp_ref:
              if first-of(tmp_ref) then do:
              find first glt_det where glt_batch = tmp_det.tmp_batch and (glt_tr_type = "AR" or glt_tr_type = 'SO')and  glt_doc = tmp_det.tmp_nbr  and glt_amt > 0 no-lock no-error.
              if available glt_det then assign gltref = glt_ref  gltacc = glt_acct gltsub = glt_sub gltamt = glt_amt gltcc = glt_cc 
                   gltproject = glt_project   .
              find first gltr_hist where gltr_batch = tmp_det.tmp_batch and (gltr_tr_type = "AR" or gltr_tr_type = 'SO') and gltr_doc = tmp_det.tmp_nbr and gltr_amt > 0 no-lock no-error.
              if available gltr_hist then assign gltref = gltr_ref  gltacc = gltr_acc gltsub = gltr_sub gltamt = gltr_amt 
              gltcc = gltr_ctr      gltproject = gltr_project .
                  if available glt_det  or available gltr_hist  then do:
                        create tmp_det2.
                        assign
                          tmp_det2.tmp_ref          = gltref
                          tmp_det2.tmp_cr_terms     = tmp_det.tmp_cr_terms   
                          tmp_det2.tmp_due_date     = tmp_det.tmp_due_date   
                          tmp_det2.tmp_cust         = tmp_det.tmp_cust       
                          tmp_det2.tmp_tax          = tmp_det.tmp_tax        
                          tmp_det2.tmp_balance      = tmp_det.tmp_balance    
                          tmp_det2.tmp_name         = tmp_det.tmp_name       
                          tmp_det2.tmp_inv_cr       = tmp_det.tmp_inv_cr     
                          tmp_det2.tmp_cr_limit     = tmp_det.tmp_cr_limit   
                          tmp_det2.tmp_type         = tmp_det.tmp_type       
                          tmp_det2.tmp_batch        = tmp_det.tmp_batch      
                          tmp_det2.tmp_nbr          = tmp_det.tmp_nbr        
                          tmp_det2.tmp_date         = tmp_det.tmp_date       
                          tmp_det2.tmp_ex_rate      = tmp_det.tmp_ex_rate    
                          tmp_det2.tmp_dun_level    = tmp_det.tmp_dun_level  
                          tmp_det2.tmp_effdate      = tmp_det.tmp_effdate    
                          tmp_det2.tmp_entity       = tmp_det.tmp_entity     
                          tmp_det2.tmp_rmks         = tmp_det.tmp_rmks       
                          tmp_det2.tmp_tax_date     = tmp_det.tmp_tax_date   
                          tmp_det2.tmp_aramt        = tmp_det.tmp_aramt     
                          tmp_det2.tmp_item         = 1
                          tmp_det2.tmp_desc4 ='' 
                          .                                                 

                     find first ac_mstr where ac_code = gltacc no-lock no-error.
                     if available ac_mstr then tmp_det2.tmp_desc = ac_desc.
                     find first sb_mstr where sb_sub = gltsub no-lock no-error.
                     if available sb_mstr then tmp_det2.tmp_desc4 = sb_desc.
                     else  tmp_det2.tmp_desc4 = '' .
                     /* if trim(glt_acct) = '' then tmp_det2.tmp_desc4 = '' . */
                     find first cc_mstr where cc_ctr = gltcc no-lock no-error.
                     if available cc_mstr then tmp_det2.tmp_desc2 = cc_desc.
                     find first pj_mstr where pj_project = gltproject no-lock no-error.
                     if available pj_mstr then tmp_det2.tmp_desc3 = pj_desc.
                     find first ad_mstr where ad_addr = tmp_det2.tmp_cust no-lock no-error.
                     if available ad_mstr then tmp_det2.tmp_name = ad_name.
                     find first cm_mstr where cm_addr = tmp_det2.tmp_cust no-lock no-error.
                     if available cm_mstr then do:
                         tmp_det2.tmp_balance =  cm_balance .
                         tmp_det2.tmp_cr_limit = cm_cr_limit.
                     end.
                     find first tx2_mstr where tx2_tax_usage = ard_tax_usage no-lock no-error.
                     if available tx2_mstr then tmp_det2.tmp_tax = tx2_tax_pct.
                       assign
                          tmp_det2.tmp_acct     = gltacc + gltsub
                          tmp_det2.tmp_curr     = gltcurr
                          tmp_det2.tmp_cc       = gltcc
                          tmp_det2.tmp_project  = gltproject
                          tmp_det2.tmp_ar_amt   = gltamt / tmp_det2.tmp_ex_rate
                          tmp_det2.tmp_ar_amt2  = gltamt
                          .

                   end.                 
              end.
            end.
********************************************************************************************/
            for each tmp_det break by tmp_batch  by tmp_ref by tmp_char  by abs(tmp_ap_amt) :
               if first-of(tmp_ref) then do:
                  put  
                  "AR应收凭证" at  88 
                  "日期："        to 146
                  today  
                  skip
                  "页号:"       at 27
                  string(page_num) format "X(8)"
                  co_name        at 79
                 '时间：'        to 146
                  string         (Time,"hh:mm:ss")
                  .
               assign num = 0.
                 /* if first-page = no then page. */
                      display 
                          tmp_ref      
                          tmp_cr_terms 
                          tmp_due_date 
                          tmp_cust     
                          tmp_tax      
                          tmp_balance  
                          tmp_name     
                          tmp_inv_cr   
                          tmp_cr_limit 
                          tmp_type     
                          tmp_batch    
                          tmp_nbr      
                          tmp_date     
                          tmp_ex_rate  
                          tmp_dun_level
                          tmp_effdate  
                          tmp_entity   
                          tmp_rmks     
                          tmp_tax_date 
                          tmp_aramt    
                          with frame e.
                     first-page = no.

               end. /* first-of(tmp-ref)*/
                     assign  num = num + 1 .

                     display
                           num      
                           tmp_acct      
                           tmp_curr      
                           tmp_cc        
                           tmp_project   
                        /*   tmp_ar_amt    
                           tmp_ar_amt2   
                           tmp_ap_amt    
                           tmp_ap_amt2   */
                        with frame c .        
                        if tmp_ar_amt <> 0 then  display tmp_ar_amt with frame c.
                        else display "" @ tmp_ar_amt with frame c . 
                         
                      /*  if tmp_ar_amt2 = 0 then display "" @ tmp_ar_amt2 with frame c. */
                        if tmp_ap_amt <> 0 then  display tmp_ap_amt with frame c.
                        else  display  "" @ tmp_ap_amt  with frame c.
                        
                       /* if tmp_ap_amt2 = 0 then display "" @ tmp_ap_amt2 with frame c. */
                      /*  down 1 with frame c.  */
                      /*if (tmp_desc) <> '' then  */ put     tmp_desc at 32  
                      /*if (tmp_desc2) <> '' then   put  */ tmp_desc2 at 62 
                     /* if (tmp_desc3)  <> '' then   put */   tmp_desc3     at 87.
                               
                           /*
            tmp_line   at 28  
                           tmp_acct   at 32                                   
                          tmp_curr   at 57     
                          tmp_cc     at 62      
                          tmp_project at 87 
                           tmp_dr1     at 112  column-label {&gpbarp_i_6}  FORMAT "->>,>>>,>>>,>>9.99"
                            tmp_cr1       at 134
            */      
                        if tmp_ar_amt2 <> 0 then put tmp_ar_amt2 at 112  .    
                        else put  tmp_ar_amt at 112.
                        if tmp_ap_amt2 <> 0  then put tmp_ap_amt2 at 134  . 
                        else put tmp_ap_amt at 134 .
                       
                         /* if (tmp_desc4)  <> '' then */  put  tmp_desc4 at 32 . 
				 /*down 1 with frame c . */
                     tot_ar_amt     = tot_ar_amt   + tmp_ar_amt   .
                     tot_ar_amt2    = tot_ar_amt2  + tmp_ar_amt2  .
                     tot_ap_amt     = tot_ap_amt   + tmp_ap_amt   .
                     tot_ap_amt2    = tot_ap_amt2  + tmp_ap_amt2  .
                     

                if last-of(tmp_ref) then do:
                
               
                   
                  put "---" at 28.
                  put "------------------    ------------------" at 112.
                 /*display 
                      tot_ar_amt @ tmp_ar_amt 
                       tot_ar_amt2 @ tmp_ar_amt2 
                       tot_ap_amt  @ tmp_ap_amt  
                       tot_ap_amt2 @ tmp_ap_amt2 
                       with frame c.
                  */
                
                  put "合计"  at 28
                      tot_ar_amt at 112
                      tot_ap_amt at 134
                      tot_ar_amt2 at 112
                      tot_ap_amt2 at 134
                      
                      .
                        do while page-size - line-counter > 4:
                     put skip(1).
                  end.
               if page-size - line-counter < 4 then page.
               
                  assign  page_num = page_num + 1.
                   put "财务经理:" at 28.
                   put "经办人:"   at 126.
                   put skip(0).
                   page.
                   tot_ar_amt     = 0.
                   tot_ar_amt2    = 0.
                   tot_ap_amt     = 0.
                   tot_ap_amt2    = 0.
                end.
                
                     
           end. /* for each tmp_det*/

/**********************/

           

             /* REPORT TRAILER */

	       {mfreset.i}
end.
             SESSION:numeric-format = oldsession.

         {wbrp04.i &frame-spec = a}
