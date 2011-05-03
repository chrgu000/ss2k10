/* ap.p - AP Voucher REPORT                                           */

/* COPYRIGHT SoftSpeed ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*  REVISION: eb2         LAST EDIT: 05/10/06   BY: *SS - Micho - 20060510* Micho Yang     */
/*版本控制*/

{mfdtitle.i "s+ 1"}


/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE gpbarp_i_1 "序!号"
/* MaxLen: Comment: */

&SCOPED-DEFINE gpbarp_i_2 "帐户和分账户!（代码+摘要）"
/* MaxLen: Comment: */

&SCOPED-DEFINE gpbarp_i_3 "币别"
/* MaxLen: Comment: */

&SCOPED-DEFINE gpbarp_i_4 "   成本中心   !（代码+摘要）"
/* MaxLen: Comment: */

&SCOPED-DEFINE gpbarp_i_5 "     项目     !（代码+摘要）"
/* MaxLen: Comment: */

&SCOPED-DEFINE gpbarp_i_6 "    借方     !（原币/本币）"
/* MaxLen: Comment: */

&SCOPED-DEFINE gpbarp_i_7 "    贷方     !（原币/本币）"
/* MaxLen: Comment: */

&SCOPED-DEFINE gpbarp_i_8 "   贷方  !（原币/本币）"
/* MaxLen: Comment: */

&SCOPED-DEFINE gpbarp_i_9 "  贷方  !（本币）"
/* MaxLen: Comment: */

&SCOPED-DEFINE gpbarp_i_10 "ERS"
/* MaxLen: Comment: */

&SCOPED-DEFINE gpbarp_i_11 "兑换率"
/* MaxLen: Comment: */


&SCOPED-DEFINE gpbarp_i_12 "承办人："
/* MaxLen: Comment: */
/*
&SCOPED-DEFINE apvorpa_p_1 "仅为未结"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvorpa_p_2 "打印已确认的凭证"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvorpa_p_3 "打印采购收货"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvorpa_p_4 "打印未确认的"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvorpa_p_5 "打印总帐明细"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvorpa_p_6 "采购单号"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvorpa_p_7 "供应商类型"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvorpa_p_8 "S-汇总/D-明细"
/* MaxLen: Comment: */

&SCOPED-DEFINE apvorpa_p_9 "按供应商排序"
/* MaxLen: Comment: */
*/
/* ********** End Translatable Strings Definitions ********* */
         /*define new shared variable ref like vo_ref.
         define new shared variable ref1 like vo_ref.
         define new shared variable vend like ap_vend.
         define new shared variable vend1 like ap_vend.
         define new shared variable batch like ap_batch.
         define new shared variable batch1 like ap_batch.
         */
         
         /*hill-b*/
            define  variable vend like ap_vend.
         define  variable vend1 like ap_vend.
         define  variable ref like ap_ref.
         define  variable ref1 like ap_ref.
         define  variable batch like ap_batch.
         define  variable batch1 like ap_batch.
         define  variable apdate like ap_date.
         define  variable apdate1 like ap_date.
         define  variable effdate like ap_effdate.
         define  variable effdate1 like ap_effdate.
         define  variable only_ers as logical.
        
         define 
            variable open_only like ap_open  initial no.
         define  variable gltrans like mfc_logical initial no .
         define  variable base_rpt like ap_curr.
         define  variable mixed_rpt like mfc_logical.
         define  variable entity like ap_entity.
         define  variable entity1 like ap_entity.
         define  variable show_vph like mfc_logical
            .
         define 
            variable show_unconf like mfc_logical .
         define 
            variable show_conf like mfc_logical
            initial yes.
         define  variable votype like vo_type.
         define  variable votype1 like votype.
         define 
            variable sort_by_vend like mfc_logical .
         /*hill-e*/
         
         
          define variable amt_open         like ap_amt.
          define var tac_usage like ad_tax_usage .
          define  variable glref like gltr_ref.
          
           def var dr1 as char format  "x(16)" .
           def var dr2 as char format  "x(16)".
           def var cr1 as char format  "x(16)".
           def var cr2 as char format  "x(16)".
           
         def  var dr_damt1 like vod_amt no-undo.
         
	 def  var dr_damt2 like vod_amt no-undo.
         
	 def  var cr_damt1 like vod_amt no-undo.
         
	 def  var cr_damt2 like vod_amt no-undo.
         
       
	 def  var to_dr_damt1 like vod_amt no-undo.
        
	 def  var to_dr_damt2 like vod_amt no-undo.
        
	 def  var to_cr_damt1 like vod_amt no-undo.
      
	 def  var to_cr_damt2 like vod_amt no-undo.
     
	 
def var acct1   as char format "x(32)" no-undo.
       
	 def var acdesc  as char format "x(18)" no-undo.
   
	 def var subdesc  as char format "x(14)"no-undo.
    
	 def var pjdesc  as char  format "x(14)" no-undo.
     
	 def var ccdesc  as char  format "x(14)" no-undo. 
         def var num as int format '999'.

    DEFINE TEMP-TABLE tmp_table NO-UNDO
      field tem_ref          like ap_ref
      field tmp_line         as int format '999'   column-label {&gpbarp_i_1}
      field tmp_acct         like vod_acct   column-label {&gpbarp_i_2}  format "x(24)"
      field tmp_acct_desc    as char  format "x(24)"  
      field tmp_curr         like ap_curr    column-label {&gpbarp_i_3}
      field tmp_cc           like vod_cc    column-label {&gpbarp_i_4} format "x(24)"
      field tmp_cc_desc      as char format "x(24)"  
      field tmp_sub_desc      as char  format "x(24)"   
      field tmp_project      like vod_project column-label {&gpbarp_i_5} format 'x(24)'
      field tmp_pj_desc      as char format "x(24)"                
      field tmp_dr1          like vod_amt    column-label {&gpbarp_i_6}
      field tmp_dr2          like vod_amt    column-label {&gpbarp_i_7}
      field tmp_cr1          like vod_amt    column-label {&gpbarp_i_8}
      field tmp_cr2          like vod_amt    column-label {&gpbarp_i_9}
      
      .           
                      

/***** mage ************检查控制文件*******

        find first gl_ctrl no-lock.************************/
        
/************定义搜索条件*************************************/

         form
         /*
   ref            colon 18
   ref1           label {t001.i} colon 49 skip
            batch          colon 18
            batch1         label {t001.i} colon 49 skip           
            vend           colon 18
            vend1          label {t001.i} colon 49 skip
            

   */
   
             batch          colon 15
            batch1         label {t001.i} colon 49 skip
            ref            colon 15
            ref1           label {t001.i} colon 49 skip
            votype         colon 15
            votype1        label {t001.i} colon 49 skip
            entity         colon 15
            entity1        label {t001.i} colon 49 skip
            vend           colon 15
            vend1          label {t001.i} colon 49 skip          
            apdate         colon 15
            apdate1        label {t001.i} colon 49
            effdate        colon 15
            effdate1       label {t001.i} colon 49 skip
            skip
            open_only      colon 15           
            
            sort_by_vend   colon 49  label '按供应商排序' skip
            show_conf      colon 15  label '打印已确认的凭证'
       
            show_unconf    colon 15  label '打印未确认的'
            
            skip         
         with frame a side-labels width 80.
         setFrameLabels(frame a:handle).

         form
                          tmp_line   at 28  
                           tmp_acct   at 32                                   
                          tmp_curr   at 57     
                          tmp_cc     at 62      
                          tmp_project at 87 
                           tmp_dr1     at 112  column-label {&gpbarp_i_6}  FORMAT "->>,>>>,>>>,>>9.99"
                            tmp_cr1       at 134  column-label {&gpbarp_i_7}  FORMAT "->>,>>>,>>>,>>9.99"
                            /*
                            tmp_cr1        at 153  column-label {&gpbarp_i_8}  FORMAT "->>,>>>>>>,>>>,>>9.99"
                            tmp_cr2        at 11   column-label {&gpbarp_i_9}  FORMAT "->>,>>>>>>,>>>,>>9.99"     
                            */
         with frame c width 200 down.
  setFrameLabels(frame c:handle).
        {wbrp01.i}
        
        repeat:
        
          if batch1 = hi_char then batch1 = "".
      
          if ref1 = hi_char then ref1 = "".
          if vend1 = hi_char then vend1 = "".
          
           
         if c-application-mode <> 'web':u then
            update 
                  /* ref   ref1
                   batch batch1                   
                   vend  vend1  */
                       
           batch          
            batch1         
            ref            
            ref1           
            votype         
            votype1        
            entity         
            entity1        
            vend           
            vend1                    
            apdate         
            apdate1        
            effdate        
            effdate1       
           
            open_only     
           
            
            sort_by_vend 
            show_conf      
       
            show_unconf      
                   
            with frame a.
     
         {wbrp06.i &command = update
                   &fields = "  
           batch          
            batch1                
            ref            
            ref1           
            votype         
            votype1        
            entity         
            entity1        
            vend           
            vend1                    
            apdate         
            apdate1        
            effdate        
            effdate1       
        
            open_only     
           
            
            sort_by_vend 
            show_conf      
       
            show_unconf  
            " &frm = "a"}

         if (c-application-mode <> 'web':u) or
         (c-application-mode = 'web':u and
         (c-web-request begins 'data':u)) then 
         do:
                  
             /* {mfquoter.i batch    }      
           {mfquoter.i batch1     }    
           {mfquoter.i ref       }     
           {mfquoter.i ref1    }       
           {mfquoter.i votype  }       
           {mfquoter.i votype1 }       
           {mfquoter.i entity  }       
           {mfquoter.i entity1}        
           {mfquoter.i vend    }       
           {mfquoter.i vend1  }                  
           {mfquoter.i apdate  }       
           {mfquoter.i apdate1 }       
           {mfquoter.i effdate }       
           {mfquoter.i effdate1  }     
          
           {mfquoter.i open_only   }  
           
            
           {mfquoter.i sort_by_vend }
           {mfquoter.i show_conf      }
       
            {mfquoter.i show_unconf }
            */
            if ref1 = "" then ref1 = hi_char.
            if batch1 = "" then batch1 = hi_char.            
            if vend1 = "" then vend1 = hi_char.           

         end. /*if (c-application-mode <> 'web':u) or (c-application-mode = 'web':u and
         (c-web-request begins 'data':u)) */

            /* SELECT PRINTER */
            {mfselbpr.i "printer" 200}
       
            {xxmfphead1.i}  
            
          
           for each ap_mstr 
           where /*( ap_ref >= ref or ref = '' )
           and   ( ap_ref <= ref1 or ref1 = '' )
           and   ( ap_batch >= batch or batch = '' )
           and   ( ap_batch <= batch1 or batch1 = '' )
           and   ( ap_vend >= vend or vend = '' )
           and   ( ap_vend <= vend1 or vend1 = '' )
           and   (ap_type = 'VO' )  */
          ( ap_batch >= batch)
            and (ap_batch <= batch1)
            and (ap_ref >= ref or ref = '' )
            and (ap_ref <= ref1 or ref1 = '' )
            and (ap_vend >= vend or vend = '' )
            and (ap_vend <= vend1 or vend1 = '' )
            and (ap_date >= apdate or apdate = ? )
            and (ap_date <= apdate1 or apdate1 = ?  )
            and (ap_effdate >= effdate or effdate = ? )
            and (ap_effdate <= effdate1 or effdate1 = ?  )
            and (ap_entity >= entity or entity = '' )
            and (ap_entity <= entity1 or entity1 = '' )
            and (ap_type = "VO")
            and (ap_open = yes or open_only = no)   
           no-lock ,
             each vo_mstr where vo_ref = ap_ref
            and (vo_confirmed = yes or show_unconf = yes)
            and (vo_type >= votype and vo_type <= votype1)
            and (vo_is_ers = yes or only_ers = no)
            and (vo_confirmed = no  or show_conf = yes) no-lock,
            each vd_mstr where vd_addr = ap_vend 
           by ap_batch by ap_ref :
               assign acdesc = "" ccdesc = "" pjdesc ="" 
               to_dr_damt1 = 0  to_dr_damt2 =0  to_cr_damt1 = 0 to_cr_damt2 =0
               . 
              
             assign  glref  = '' .
               /*find vd_mstr where vd_addr = ap_vend no-lock no-error.*/
 
	       /*  find vo_mstr where vo_ref = ap_ref  no-lock no-error.  */
                

                /****************************** Add by SS - Micho - 20060510 B ******************************/ 
                 /*
                 for last glt_det where trim(glt_tr_type) = 'AP' and trim(glt_batch) = trim(ap_batch) and trim(glt_doc) = trim(ap_ref)  no-lock  : end.
                 if available glt_det then
                 do:
                  assign  glref = glt_ref .
                 end.
                 
                if trim(glref) = '' then 
                 do:
                    for last gltr_hist where trim(gltr_tr_type) = 'AP' and trim(gltr_batch) = trim(ap_batch)  and trim(gltr_doc) = trim(ap_ref)  no-lock  :
                      assign  glref = gltr_ref .
                     end.
                 end.
                 */
                 
                 for last glt_det USE-INDEX glt_batch where glt_tr_type = 'AP' and glt_batch = ap_batch and glt_doc = ap_ref  no-lock  : end.
                 if available glt_det then
                 do:
                  assign  glref = glt_ref .
                 end.

                 if trim(glref) = '' then 
                 do:
                    for last gltr_hist USE-INDEX gltr_batch  where gltr_tr_type = 'AP' and gltr_batch = ap_batch  and gltr_doc = ap_ref  no-lock  :
                      assign  glref = gltr_ref .
                     end.
                 end.
                 
                /****************************** Add by SS - Micho - 20060510 E ******************************/ 

             
             
              /* find  glt_det where glt_doc = ap_ref  no-error.
               if available glt_det then glref = glt_ref.
                        
               display "AP应付凭证" at 60  skip(1). */  
                  
               put  
                "AP应付凭证" at  88 
               "日期："        to 146
                today  
                skip
                "页号:"       at 27
               string         (page-number {2}) format "X(8)"
               co_name        at 79
               '时间：'        to 146
                string         (Time,"hh:mm:ss")
                .
               if ap_curr = 'CNY'  then
               assign  amt_open =  ap_base_amt - vo_base_applied  .
               else  amt_open = ap_amt  - vo_applied .
               
               find  ad_mstr where ad_addr = ap_vend no-error.
               if available  ad_mstr then 
               do:
                if ad_tax_usage  <> '' then       tac_usage = ad_tax_usage .
                if ad_tax_usage = '' then       tac_usage  = string(vo_tax_pct[1]) .
               end.
             
	      display
                    glref at 28  label  "AP总帐参考号"
               
	      ap_batch at 82  label '批处理'
                  
	      ap_ref at 136    label  "AP凭证号"
                 
	      ap_vend at 28   label  "供应商代码"
                   
              vo_cr_terms at 82   label  '支付方式'
               
	      vo_due_date at 136    label  '到期日'
                
	      vd_sort when available vd_mstr at 28  label  "供应商名称"
            
	      tac_usage  at 82 label  "税率"
                 
	      vo_prepay at 136  label   '预付金额'
                 
	      vo_invoice at 28  label  "发票号"
                 
	      vo_rv_nbr at 82   label '周期性凭证'
                 
	      vo_is_ers at 136 label {&gpbarp_i_10}  
       
	      ap_date at 28   label  '日期'
            
	      vo_type at 82   label  '类型'
                  
	      vo_base_hold_amt at 136   label  "暂留金额"
          
	      ap_effdate at 28   label '生效日期'
                
	      (  ap_ex_rate2 / ap_ex_rate) @ ap_ex_rate  
          
	      at 82 label {&gpbarp_i_11}  
               
	      amt_open at 136  label  "未结金额"
           
	      ap_entity at 28    label  "会计单位"
                
	      ap_bank at 82  label  "银行代码"
        
	      ap_ckfrm at 136    label  '支票格式'
                
	      ap_rmk  at 28    label '备注'
                 
	      vo__qad01 at 82 label {&gpbarp_i_12}   
    
	      vo_conf_by at 136      label '确认人'         
      
 
	      with frame d side-labels width 200.  
             
                        
             for each vod_det where vod_ref = ap_ref no-lock  :
                 assign acdesc = "" ccdesc = "" pjdesc ="" subdesc = "" . 
                 find  pj_mstr where pj_project = vod_project  no-lock   no-error.
      
		 if available pj_mstr then pjdesc = pj_desc .
                  
            
/*mage*/	 find  ac_mstr where  ac_code =  vod_acct  /* substring(vod_acct,1,4)*/   no-lock  no-error.                
/*mage*/ 	 if available ac_mstr then  acdesc = ac_desc . 
/*mage*/         find  sb_mstr where  sb_sub = vod_sub  /* substring(vod_acct,5,4)*/  no-lock  no-error.                
 /*mage*/ 	 if available sb_mstr then  subdesc =   sb_desc. 

                 find  cc_mstr where cc_ctr = vod_cc  no-lock   no-error.
                
		 if available cc_mstr then ccdesc = cc_desc .
                 
                 if vod_base_amt >= 0 then
                 do:
      
		 assign dr_damt1 =  vod_amt  dr_damt2 =   vod_base_amt .
      
		 end.
  
		 if vod_base_amt < 0 then
                 do:
       
		 assign cr_damt1 = - vod_amt   cr_damt2 = - vod_base_amt .
                 end.
                create tmp_table.
                        assign
                          tem_ref         = vod_ref
                          tmp_line         =  vod_ln 
                          tmp_acct         = vod_acct + vod_sub 
                          tmp_acct_desc    = acdesc
                          tmp_curr         = ap_curr
                          tmp_cc           = vod_cc 
                          tmp_cc_desc      = ccdesc
			  tmp_sub_desc      = subdesc
                          tmp_project      = vod_project 
                          tmp_pj_desc      = pjdesc                    
                          tmp_dr1          = dr_damt1
                          tmp_dr2          = dr_damt2
                          tmp_cr1          = cr_damt1
                          tmp_cr2          = cr_damt2
                          .
                  num =  vod_ln .    
                  to_dr_damt1 = to_dr_damt1 + dr_damt1.
 
		  to_dr_damt2 = to_dr_damt2 + dr_damt2.
  
		  to_cr_damt1 = to_cr_damt1 + cr_damt1.
  
		  to_cr_damt2 = to_cr_damt2 + cr_damt2. 
                   
                  dr_damt1  = 0.
                  dr_damt2  = 0.
                  cr_damt1  = 0.
                  cr_damt2  = 0.
                  
                          
             end. /*for each vod_det*/   
             
               /*   find  pj_mstr where pj_project = ap_project   no-error.
  
	       if available pj_mstr then pjdesc = pj_desc .
                  */
    
/*mage*/	        assign acdesc = "" ccdesc = "" pjdesc =""  subdesc = "". 
	       find  ac_mstr where  ac_code = /* substring(ap_acct,1,4) */ ap_acct  no-lock  no-error.                
 
/*mage*/ 	       if available ac_mstr then  acdesc = ac_desc . 
/*mage*/               find  sb_mstr where  sb_sub =  /* substring(ap_acct,5,4) */ ap_sub  no-lock  no-error.                
 /*mage*/ 	       if available sb_mstr then  subdesc =   sb_desc. 

	       if available ac_mstr then  acdesc = ac_desc . 
               find  cc_mstr where cc_ctr = ap_cc  no-lock  no-error.
       
	       if available cc_mstr then ccdesc = cc_desc .
                              
                create tmp_table.
                        assign
                          tem_ref         = ap_ref
                          tmp_line         = num + 1
                          tmp_acct         =  ap_acct  + ap_sub 
                          tmp_acct_desc    =  acdesc
                          tmp_curr         =  ap_curr
                          tmp_cc           =  ap_cc 
                          tmp_cc_desc      =  ccdesc
			   tmp_sub_desc      =  subdesc

                         /* tmp_project      =  ap_project  */
                          tmp_pj_desc      =  pjdesc                    
                          tmp_dr1          =  0
                          tmp_dr2          =  0
                          tmp_cr1          = ap_amt
                          tmp_cr2          = ap_base_amt
                          .
                          
                assign  to_cr_damt1 = to_cr_damt1 + ap_amt
   
		to_cr_damt2 = to_cr_damt2 + ap_base_amt
                        num = 0
                        .
                        
             /*display item begin*/
              for each tmp_table no-lock  break by tem_ref with frame c width 200 :
                 if tmp_dr1 <> 0 then 
                 do:
                 dr1 = string(tmp_dr1).
                 end.
                 else  
                 do:
                 dr1 = "" . 
                end.
                 if tmp_dr2 <> 0 then dr2 = string(tmp_dr2).
                          else  dr2 = "" .
                          
                 if tmp_cr1 <> 0 then cr1 = string(tmp_cr1).
                          else  cr1 = "" .
                 if tmp_cr2 <> 0 then cr2 = string(tmp_cr2).
                          else  cr2 = "" .                                 
                   
                display 
                         /* tmp_line   at 2      
                          tmp_acct   at 20                                   
                          tmp_curr   at 38      
                          tmp_cc     at 56      
                          tmp_project at 74  
                          dr1    at 92  column-label {&gpbarp_i_6}
                           dr2    at 110  column-label {&gpbarp_i_7}
                            cr1    at 128  column-label {&gpbarp_i_8}
                             cr2    at 146   column-label {&gpbarp_i_9} 
                           */
                            tmp_line   at 28 
                           tmp_acct   at 32                                   
                          tmp_curr   at 57     
                          tmp_cc     at 62      
                          tmp_project at 87 with frame c  .
  /*tmp_line   at 28  
                           tmp_acct   at 32                                   
                          tmp_curr   at 49     
                          tmp_cc     at 55      
                          tmp_project at 71 
                           tmp_dr1     at 87  column-label {&gpbarp_i_6}  FORMAT "->>>,>>>,>>9.99"
                            tmp_dr2       at 105  column-label {&gpbarp_i_7}  FORMAT "->>>,>>>,>>9.99"
                            tmp_cr1        at 122  column-label {&gpbarp_i_8}  FORMAT "->>>,>>>,>>9.99"
                            tmp_cr2        at 140   co*/
                         if tmp_dr1 <> 0  then  display   tmp_dr1 with frame c .   else  display   "" @ tmp_dr1 with frame c .
                        /* if tmp_dr2 <> 0  then  display   tmp_dr2 with frame c .   else   display "" @  tmp_dr2 with frame c .*/
                          if tmp_cr1 <> 0  then  display   tmp_cr1 with frame c .   else   display "" @  tmp_cr1 with frame c.
                         /* if tmp_cr2 <> 0  then   display  tmp_cr2  with frame c.    else  display   "" @     tmp_cr2 with frame c .                               
                       */
                     /*  if tmp_dr1 <> 0 then put tmp_dr1 at 114.
                       if tmp_cr1 <> 0 then put tmp_cr1 at 136. */
                          down.
                  /*
                   tmp_line   at 28  
                           tmp_acct   at 32                                   
                          tmp_curr   at 57     
                          tmp_cc     at 66      
                          tmp_project at 91 
                           tmp_dr1     at 115  column-label {&gpbarp_i_6}  FORMAT "->>>,>>>,>>9.99"
                            tmp_dr2       at 131  column-label {&gpbarp_i_7}  FORMAT "->>>,>>>,>>9.99"
                            tmp_cr1        at 147  column-label {&gpbarp_i_8}  FORMAT "->>>,>>>,>>9.99"
                            tmp_cr2        at 163   column-label {
                  */
                        put 
                          tmp_acct_desc  at 32   
                          tmp_cc_desc     at 62 
                          .
                      if tmp_project = '' then put '' at 87 .
                      else put    tmp_pj_desc     at 87                           
                         .  
                          if tmp_dr2 <> 0 then put tmp_dr2 at 114.
                       if tmp_cr2 <> 0 then put tmp_cr2 at 136. 
			                   put tmp_sub_desc at 32 			                    
			                    .
                          
                             
                          . 
                  if last-of(tem_ref) then
             do:
                put "----" at 28  "------------------    ------------------" at 112.
                put                
                 "合计"      at 28   
                 to_dr_damt1    at 114   
                 
                 to_cr_damt1    at 136  
                                 
                 .         
                 put to_dr_damt2  at 114    to_cr_damt2  at 136 .
                  do while page-size - line-counter > 4 :                  
                     put skip(1).                                  
                  end. 
                  if page-size - line-counter < 4 then  do: page.   end.
                       
                  
                      put "财务总监:" at 28.
                      put "财务经理:" at 82.
                      put "经办人:"   at 134.
                      put skip(0).
                      page. 
                       
               
                 
                   
                  
            
            end.      
                        
              end. /*for each tem_table*/             
             /*display item end*/    
                
          for each tmp_table :                 
            delete   tmp_table .
          end. 
                 
           end. /*for each ap_mstr*/
               
                                     
              for each tmp_table :                 
            delete   tmp_table .
          end. 
                     
        {mfreset.i}
      
     end. /*repeat*/  
  
