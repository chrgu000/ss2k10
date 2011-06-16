/* ap.p - AP Voucher REPORT                                           */
/* COPYRIGHT SoftSpeed ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */

/*版本控制*/

{mfdtitle.i "s+"}


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

&SCOPED-DEFINE gpbarp_i_8 "  贷方  !（原币）"
/* MaxLen: Comment: */

&SCOPED-DEFINE gpbarp_i_9 "  贷方  !（本币）"
/* MaxLen: Comment: */

&SCOPED-DEFINE gpbarp_i_10 "ERS"
/* MaxLen: Comment: */

&SCOPED-DEFINE gpbarp_i_11 "兑换率"
/* MaxLen: Comment: */


&SCOPED-DEFINE gpbarp_i_12 "承办人"
/* MaxLen: Comment: */

&SCOPED-DEFINE gpbarp_i_13 "过帐（Y/N）"
/* MaxLen: Comment: */

&SCOPED-DEFINE gpbarp_i_14 "借贷不平（Y/N)"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */
         define new shared variable ref like gltr_ref.
         define new shared variable ref1 like gltr_ref.
         define new shared variable cust like ap_vend.
         define new shared variable cust1 like ap_vend.
         define new shared variable batch like gltr_batch.
         define new shared variable batch1 like gltr_batch.
         define variable amt_open         like gltr_amt.          
         define new shared variable glref like gltr_ref.
         define variable unbalance like glt_unb init NO column-label {&gpbarp_i_13} .
         define variable post as logical init YES column-label {&gpbarp_i_14}.
         
          
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
  
         def var acdesc  like ac_desc no-undo.
     
	 def var subdesc  like ac_desc no-undo.
    
	 def var pjdesc  like pj_desc no-undo.
    
	 def var ccdesc  like cc_desc no-undo. 
         def var num as int format '999'.
   def var post_user like gltr_user .
   
   
    DEFINE TEMP-TABLE tmp_table NO-UNDO
      field tem_ref          like glt_ref
      field tmp_line         like glt_line   column-label {&gpbarp_i_1}
      field tmp_acct         like glt_acc   column-label {&gpbarp_i_2} format "x(24)"
      field tmp_acct_desc    like ac_desc     format "x(24)"
      field tmp_curr         like glt_curr    column-label {&gpbarp_i_3}
      field tmp_cc           like glt_cc     column-label {&gpbarp_i_4}  format "x(24)"
      field tmp_cc_desc      like cc_desc      format "x(24)"
      field tmp_sub_desc      like cc_desc       format "x(24)"
      field tmp_project      like glt_project column-label {&gpbarp_i_5}  format "x(24)"
      field tmp_pj_desc      like pj_desc           format "x(24)"         
      field tmp_dr1          like glt_amt    column-label {&gpbarp_i_6}
      field tmp_dr2          like glt_amt    column-label {&gpbarp_i_7}
      field tmp_cr1          like glt_amt    column-label {&gpbarp_i_8}
      field tmp_cr2          like glt_amt    column-label {&gpbarp_i_9}
      
      .           
                      

/*******mAGE**********检查控制文件****************

        find first gl_ctrl no-lock.***************/
        
/************定义搜索条件*************************************/

         form
/*apple*/   ref            colon 18
/*apple*/   ref1           label {t001.i} colon 49 skip
            batch          colon 18
            batch1         label {t001.i} colon 49 
            unbalance      colon 18
            post           colon 18  column-label {&gpbarp_i_14}
            post_user      colon 18  column-label '过帐用户'
            skip 
         with frame a side-labels width 80.

         form
                          num   at 28 column-label {&gpbarp_i_1}     
                          tmp_acct   at 32                                   
                          tmp_curr   at 57     
                          tmp_cc     at 62      
                          tmp_project at 87 
                          tmp_dr1    at 112  column-label {&gpbarp_i_6}
                          tmp_cr1    at 134  column-label {&gpbarp_i_7}
                          /*tmp_cr1    at 116  column-label {&gpbarp_i_8}
                          tmp_cr2    at 134   column-label {&gpbarp_i_9}   */
		with frame c width 200 down.
		 /*
		    tmp_line   at 28  
                           tmp_acct   at 32                                   
                          tmp_curr   at 57     
                          tmp_cc     at 62      
                          tmp_project at 87 
                           tmp_dr1     at 112  column-label {&gpbarp_i_6}  FORMAT "->>,>>>,>>>,>>9.99"
                            tmp_cr1       at 134  co
		 */
        {wbrp01.i}
        
        repeat:
        
          if batch1 = hi_char then batch1 = "".
      
          if ref1 = hi_char then ref1 = "".
   
          
           
          if c-application-mode <> 'web':u then
            update 
                   ref   ref1
                   batch batch1                   
                   unbalance
                   post
                   post_user
            with frame a.
     
         {wbrp06.i &command = update
                   &fields = "  ref ref1 batch batch1 unbalance  post post_user  " &frm = "a"}

         if (c-application-mode <> 'web':u) or
         (c-application-mode = 'web':u and
         (c-web-request begins 'data':u)) then 
         do:
                  
            {mfquoter.i ref      }
            {mfquoter.i ref1     }
            {mfquoter.i batch    }
            {mfquoter.i batch1   }            
            {mfquoter.i unbalance    }
            {mfquoter.i post   }
            {mfquoter.i post_user   }
            if ref1 = "" then ref1 = hi_char.
            if batch1 = "" then batch1 = hi_char.            
            if cust1 = "" then cust1 = hi_char.           

         end. /*if (c-application-mode <> 'web':u) or (c-application-mode = 'web':u and
         (c-web-request begins 'data':u)) */

            /* SELECT PRINTER */
            {mfselbpr.i "printer" 170}
    
            {xxmfphead1.i}  
            if post THEN do:
               for each gltr_hist where (gltr_ref >= ref or ref = '') 
                                   and (gltr_ref <= ref1 or ref1 = '')
                                   and (gltr_batch >= batch or batch = '')
                                   AND (gltr_batch <= batch1 or batch1 = '')
                                   and  gltr_unb = unbalance 
                                   and (gltr_user = post_user or post_user = '' )
                                   no-lock break by gltr_ref :
                  if gltr_amt >= 0 THEN do:
                      assign
                          dr_damt2 =  gltr_amt  
                          dr_damt1 =  gltr_curramt 
                          .
                      if dr_damt1 = 0 then   dr_damt1 = dr_damt2 .  
		          end.

                  if gltr_amt < 0 THEN do: 
                      assign cr_damt2= - gltr_amt   cr_damt1 = - gltr_curramt .
		              if cr_damt1 = 0 then   cr_damt1 = cr_damt2 . 
                  end. 
                 
                  find  pj_mstr where pj_project = gltr_project  no-lock  no-error.
                  if available pj_mstr then pjdesc = pj_desc .
               
/*mage*/	      find  ac_mstr where  ac_code =  gltr_acc  no-lock  no-error.                
/*mage*/ 	      if available ac_mstr then  acdesc = ac_desc . 

/*mage*/          find  sb_mstr where  sb_sub =  gltr_sub  no-lock  no-error.                
 /*mage*/ 	      if available sb_mstr then  subdesc =   sb_desc. 

                  find  cc_mstr where cc_ctr = gltr_ctr no-lock no-error.
                  if available cc_mstr then ccdesc = cc_desc .

                  create tmp_table.
                  assign
                      tem_ref         = gltr_ref
                      tmp_line         = num + 1
                      tmp_acct         =  trim(gltr_acc) + trim(gltr_sub)
                      tmp_acct_desc    =  acdesc
                      tmp_curr         =  gltr_curr
                      tmp_cc           =  gltr_ctr 
                      tmp_cc_desc      =  ccdesc
                      tmp_project      =  gltr_project  
                            tmp_sub_desc     =  subdesc
                      tmp_pj_desc      =  pjdesc                    
                      tmp_dr1          = dr_damt1
                      tmp_dr2          = dr_damt2
                      tmp_cr1          = cr_damt1
                      tmp_cr2          = cr_damt2
                      .
                          
                  to_dr_damt1 = to_dr_damt1 + dr_damt1.
                  to_dr_damt2 = to_dr_damt2 + dr_damt2.
                  to_cr_damt1 = to_cr_damt1 + cr_damt1.
                  to_cr_damt2 = to_cr_damt2 + cr_damt2. 
                  dr_damt1  = 0.
                  dr_damt2  = 0.
                  cr_damt1  = 0.
                  cr_damt2  = 0.
                  
                  if first-of(gltr_ref) THEN do:
                     put  
                         "总账凭证列印" at  88 
                         "日期："        to 146
                         today  
                         skip
                         "页号:"       at 27
                         string         (page-number {2}) format "X(8)" 
                         co_name        at 79
                         '时间：'        to 146
                         string         (Time,"hh:mm:ss")
                         .
         
                     display 
                       gltr_ref at 30
                       gltr_batch at 80
                       "备注："  at  130
                 
                       gltr_tr_type at 30
                       gltr_entity at 80
                       ( gltr_ex_rate2 / gltr_ex_rate )   gltr_ex_rate
                        at 130  label {&gpbarp_i_11} 
                        
                       gltr_ent_dt at 30
                       gltr_eff_dt at 80
                       post  at  130   column-label {&gpbarp_i_14}
                      with frame d side-labels width 170.
                  end.
                    
                  if last-of (gltr_ref ) then do:
                     for each tmp_table no-lock  break by tem_ref by tmp_cr1 with frame c width 170 :
                         if tmp_dr1 <> 0 then do:
                             dr1 = string(tmp_dr1).
                         end.
                         else do:
                             dr1 = "" . 
                         end.

                         if tmp_dr2 <> 0 then dr2 = string(tmp_dr2).
                                         else  dr2 = "" .
                         if tmp_cr1 <> 0 then cr1 = string(tmp_cr1).
                                         else  cr1 = "" .
                         if tmp_cr2 <> 0 then cr2 = string(tmp_cr2).
                                         else  cr2 = "" .                                 
                         num = num + 1.

                         display 
                          num   at 28 column-label {&gpbarp_i_1}     
                          tmp_acct   at 32                                   
                          tmp_curr   at 57     
                          tmp_cc     at 62      
                          tmp_project at 87  with frame c.
     
                         if tmp_dr1 <> 0  then  display   tmp_dr1 with frame c .   else  display   ""  @ tmp_dr1 with frame c .
                         if tmp_cr1 <> 0  then  display   tmp_cr1 with frame c .   else   display ""  @  tmp_cr1 with frame c.
                         down.
                         put 
                            tmp_acct_desc  at 32
                            tmp_cc_desc   at 62 
                            tmp_pj_desc   at 87
                            .
                         
                         if tmp_dr2 <> 0  then  put tmp_dr2 at 112.
                         if tmp_cr2 <> 0  then  put tmp_cr2 at 134.
                         PUT tmp_sub_desc  at 32 .

                         if last-of(tem_ref) THEN do:
                            put "----" at 28  "------------------    ------------------" at 112.
                            put                
                                 "合计"      at 28   
                                 to_dr_damt1     at 114
                                  to_cr_damt1    at 136   
                                 to_dr_damt2     at 114  
                                 to_cr_damt2     at 136                    
                                 .         
                 
                            assign 
                             num = 0 
                             dr_damt1  = 0
                             dr_damt2  = 0
                             cr_damt1  = 0
                             cr_damt2  = 0
                             acdesc = "" 
                             ccdesc = "" 
                             pjdesc ="" 
                             to_dr_damt1 = 0  
                             to_dr_damt2 =0  
                             to_cr_damt1 = 0 
                             to_cr_damt2 =0
                              .                 
                               
                            if page-size - line-counter < 4 then page.
                            do while page-size - line-counter > 4:
                                 put skip(1).
                            end.
                            put skip(2).
                            put "财务经理:" at 22.
                            put "经办人:"   at 72.
                            put skip(0).
                            page.
                         end.  
                     end. /*for each tem_table*/    
                   
                     for each tmp_table :                 
                       delete   tmp_table .
                     end. 
                   end.
              end. /* if last-of (gltr_ref ) then do: */
            end.  /* if post = yes */
            else do:
               for each glt_Det where (glt_ref >= ref or ref = '') 
                                  and (glt_ref <= ref1 or ref1 = '')
                                  AND (glt_batch >= batch or batch = '') 
                                  AND (glt_batch <= batch1 or batch1 = '')
                                  AND glt_unb = unbalance  no-lock break by glt_ref :
                   if glt_amt >= 0 THEN do:
                       assign dr_damt2 =  glt_amt  dr_damt1 =   glt_curr_amt .
                       if dr_damt1 = 0 then   dr_damt1 = dr_damt2 .  
		           end.
               
		           if glt_amt < 0 THEN do:
                      assign cr_damt2 = - glt_amt   cr_damt1 = - glt_curr_amt .
                      if cr_damt1 = 0 then   cr_damt1 = cr_damt2 .  
                   end. 
                 
                   find  pj_mstr where pj_project = glt_project  no-lock  no-error.
                   if available pj_mstr then pjdesc = pj_desc .
             
/*mage*/	       FIND ac_mstr where  ac_code =  glt_acct  no-lock  no-error.                
/*mage*/ 	       if available ac_mstr then  acdesc = ac_desc . 

/*mage*/           find  sb_mstr where  sb_sub =  glt_sub  no-lock  no-error.                
 /*mage*/ 	       if available sb_mstr then  subdesc =   sb_desc. 
               
                   find  cc_mstr where cc_ctr = glt_cc no-lock no-error.
                   if available cc_mstr then ccdesc = cc_desc .

                   create tmp_table.
                   assign
                      tem_ref         = glt_ref
                      tmp_line         = num + 1
                      tmp_acct         =  glt_acct  + glt_sub 
                      tmp_acct_desc    =  acdesc
                      tmp_curr         =  glt_curr
                      tmp_cc           =  glt_cc 
                      tmp_cc_desc      =  ccdesc
                      tmp_project      =  glt_project   
                      tmp_sub_desc     = subdesc
                      tmp_pj_desc      =  pjdesc                    
                      tmp_dr1          = dr_damt1
                      tmp_dr2          = dr_damt2
                      tmp_cr1          = cr_damt1
                      tmp_cr2          = cr_damt2
                      .
                          
                   to_dr_damt1 = to_dr_damt1 + dr_damt1.
                   to_dr_damt2 = to_dr_damt2 + dr_damt2.
                   to_cr_damt1 = to_cr_damt1 + cr_damt1.
                   to_cr_damt2 = to_cr_damt2 + cr_damt2. 
                   dr_damt1  = 0.
                   dr_damt2  = 0.
                   cr_damt1  = 0.
                   cr_damt2  = 0.
                  
                   if first-of(glt_ref) THEN do:
                      put  
                         "总账凭证列印" at  88 
                         "日期："        to 146
                         today  
                         skip
                         "页号:"       at 27
                         string         (page-number {2}) format "X(8)"
                         co_name        at 79
                       '时间：'        to 146
                        string         (Time,"hh:mm:ss")
                        .
                     
                      display 
                           glt_ref at 30  column-label "总账参考号："
                           glt_batch at 80  column-label "批处理："
                           "备注："  at  130  
                           glt_tr_type at 30  column-label "事务类型："
                           glt_entity at 80  column-label "会计单位："
                           (glt_ex_rate2 / glt_ex_rate) @ glt_ex_rate at 130  column-label {&gpbarp_i_11} 
                           glt_date at 30  column-label "日期："
                           glt_effdate at 80 column-label "生效日期："
                           post  at  130   column-label {&gpbarp_i_14}
                           with frame xxd side-labels width 170.
                   end. /* if first-of(glt_ref) THEN do: */
                    
                   if last-of (glt_ref ) then do:
                      for each tmp_table no-lock  break by tem_ref by tmp_cr1 with frame xxc width 170 :
                          if tmp_dr1 <> 0 then do:
                             dr1 = string(tmp_dr1).
                          end.
                          else do:
                             dr1 = "" . 
                          end.

                          if tmp_dr2 <> 0 then dr2 = string(tmp_dr2).
                                          ELSE dr2 = "" .
                          
                          if tmp_cr1 <> 0 then cr1 = string(tmp_cr1).
                                          else cr1 = "" .

                          if tmp_cr2 <> 0 then cr2 = string(tmp_cr2).
                                          else  cr2 = "" .                                 
                          num = num + 1.

                          display 
                               num   at    28 column-label {&gpbarp_i_1}     
                               tmp_acct   at 32                                   
                               tmp_curr   at 57     
                               tmp_cc     at 62      
                               tmp_project at 87 with frame c. 

                          if tmp_dr1 <> 0  then  display   tmp_dr1 with frame c .   else  display   "" @ tmp_dr1 with frame c .

                          if tmp_cr1 <> 0  then  display   tmp_cr1 with frame c .   else   display "" @  tmp_cr1 with frame c.
                         
                          down.
                          
                          put 
                              tmp_acct_desc  at 32
                              tmp_cc_desc   at 62 
                              tmp_pj_desc   at 87 .
                          
                          if tmp_dr2 <> 0  then  put tmp_dr2 at 112.
                          if tmp_cr2 <> 0  then  put tmp_cr2 at 134.  
			                
                          put   tmp_sub_desc  at 32 .
                          
                          if last-of(tem_ref) THEN do:
                             put "----" at 28  "------------------    ------------------" at 112.
                             put                
                                 "合计"      at 28   
                                 to_dr_damt1    at 114
                                 to_cr_damt1    at 136     
                                 to_dr_damt2  at   114                   
                                 to_cr_damt2  at 136                          
                                 .         
                             assign 
                                 num = 0 
                                 dr_damt1  = 0
                                 dr_damt2  = 0
                                 cr_damt1  = 0
                                 cr_damt2  = 0
                                 acdesc = "" 
                                 ccdesc = "" 
                                 pjdesc ="" 
                                 to_dr_damt1 = 0 
                                 to_dr_damt2 =0  
                                 to_cr_damt1 = 0 
                                 to_cr_damt2 =0
                                 .                 
                             do while page-size - line-counter > 4:
                                put skip(1).
                             end.                 

                             if (page-size) - line-counter < 4 then page.
                             put "财务经理:" at 22.
                             put "经办人:"   at 98.
                             put skip(0).
                             page.
                          end.      
                      end. /*for each tem_table*/    
                   
                      for each tmp_table :                 
                          delete   tmp_table .
                      end. 
                   end.   /* if last-of(glt_ref) */
               end. /* for each glt_det */
            end.  /* else do: */
            
         {mfreset.i}
      
     end. /*repeat*/  
  
