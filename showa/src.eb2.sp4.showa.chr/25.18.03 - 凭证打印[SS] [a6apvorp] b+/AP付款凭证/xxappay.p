/* ap.p - AP Voucher REPORT                                           */
/* COPYRIGHT SoftSpeed ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*  REVISION: eb2         LAST EDIT: 05/10/06   BY: *SS - Micho - 20060510* Micho Yang     */

/*版本控制*/

{mfdtitle.i "s+ "}


/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE gpbarp_i_1 "批处理号!凭证号"
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

&SCOPED-DEFINE gpbarp_i_10 "ERS:"
/* MaxLen: Comment: */

&SCOPED-DEFINE gpbarp_i_11 "兑换率："
/* MaxLen: Comment: */


&SCOPED-DEFINE gpbarp_i_12 "承办人："
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */
        define new shared variable ref like ap_ref. 
         define new shared variable ref1 like ap_ref.  
         
         /*hill-b*/
          define variable apdate       like ap_date.  
          define variable apdate1      like ap_date.
          define variable effdate      like ap_effdate.
          define variable effdate1     like ap_effdate.
          define variable bank         like ck_bank.
          define variable bank1        like ck_bank.
          define variable nbr          like ck_nbr.
          define variable nbr1         like ck_nbr.
          define variable entity       like ap_entity.
          define variable entity1      like ap_entity.
          define variable ckfrm        like ap_ckfrm.
          define variable ckfrm1       like ap_ckfrm. 
          define variable vdtype       like vd_type
          label '供应商类型'.
         define variable vdtype1      like vdtype.
         define variable sort_by_vend like mfc_logical init no  .
        /*hill-e*/
         
         
         define variable vendx like ap_vend.
       /*  define variable ref like vo_ref. */
         define variable po          like vpo_po.
         define variable base_rpt like ap_curr.
         define variable votype like vo_type.
         define variable curr as character format "x(4)".
         
         define new shared variable vend like ap_vend.
         define new shared variable vend1 like ap_vend.
         define new shared variable batch like ap_batch.
         define new shared variable batch1 like ap_batch.
          define variable amt_open         like ap_amt.
          
          define new shared variable glref like gltr_ref.
          define buffer apmstr01 for ap_mstr .
          
           def var dr1 as char format  "x(16)" .
           def var dr2 as char format  "x(16)".
           def var cr1 as char format  "x(16)".
           def var cr2 as char format  "x(16)".
           
         def  var dr_damt1 like ckd_amt no-undo.
     
	 def  var dr_damt2 like ckd_amt no-undo.
      
	 def  var cr_damt1 like ckd_amt no-undo.
     
	 def  var cr_damt2 like ckd_amt no-undo.
    
	 
         def  var to_dr_damt1 like ckd_amt no-undo.
    
	 def  var to_dr_damt2 like ckd_amt no-undo.
      
	 def  var to_cr_damt1 like ckd_amt no-undo.
  
	 def  var to_cr_damt2 like ckd_amt no-undo.
      
	 
          
         def var acct1   as char format "x(32)" no-undo.
   
	 def var acdesc  as char format "x(24)"  no-undo.
     
	 def var subdesc  as char format "x(24)" no-undo.
   
	 def var pjdesc  as char format "x(24)"  no-undo.
     
	 def var ccdesc  as char format "x(24)"  no-undo. 
         def var num as int.
 
    DEFINE TEMP-TABLE tmp_table NO-UNDO
       field tem_ref          like ap_ref
      field tmp_vo_num       like ckd_voucher   
      field tmp_acct         like ckd_acct   column-label {&gpbarp_i_2} format "x(24)"
      field tmp_acct_desc    as char    format "x(24)"
      field tmp_curr         like ap_curr    column-label {&gpbarp_i_3}
      field tmp_cc           like ckd_cc     column-label {&gpbarp_i_4} format "x(24)"
      field tmp_cc_desc      as char    format "x(24)"
      field tmp_sub_desc      as char    format "x(24)"
      field tmp_project      like ckd_project column-label {&gpbarp_i_5} format "x(24)"
      field tmp_pj_desc      as char      format "x(14)"            
      field tmp_dr1          like ckd_amt    column-label {&gpbarp_i_6}
      field tmp_dr2         like ckd_amt    column-label {&gpbarp_i_7}
     
     field tmp_cr1          like ckd_amt    column-label {&gpbarp_i_8} 
      field tmp_cr2          like ckd_amt    column-label {&gpbarp_i_9} 
      field tmp_batch       like ap_batch   column-label {&gpbarp_i_1}
      .           
                      

/********mage*********检查控制文件******************

        find first gl_ctrl no-lock.*************/
        
/************定义搜索条件*************************************/

       form
            /*ref            colon 18
            ref1           label {t001.i} colon 49 skip
            batch          colon 18
            batch1         label {t001.i} colon 49 skip           
            vend           colon 18
            vend1          label {t001.i} colon 49 skip
            */
           batch   colon 18
           batch1  label {t001.i} colon 49 skip           
           nbr     colon 18       
           nbr1    label {t001.i} colon 49 skip            
           bank    colon 18      
           bank1   label {t001.i} colon 49 skip            
           ckfrm   colon 18       
           ckfrm1  label {t001.i} colon 49 skip            
           entity  colon 18       
           entity1 label {t001.i} colon 49 skip            
           vend    colon 18       
           vend1   label {t001.i} colon 49 skip            
           vdtype  colon 18        
           vdtype1 label {t001.i} colon 49 skip            
           apdate  colon 18       
           apdate1 label {t001.i} colon 49 skip            
           effdate colon 18       
           effdate1 label {t001.i} colon 49 skip       
           /*sort_by_vend  colon 18  label '按供应商排序' */
           skip
         with frame a side-labels width 80.
  setFrameLabels(frame a:handle).
            form                     tmp_batch   at 28     
                          tmp_acct   at 38                                  
                          tmp_curr   at 63      
                          tmp_cc     at 68      
                          tmp_project at 93
                           tmp_dr1      at 118  column-label {&gpbarp_i_6}  FORMAT "->>,>>>,>>>,>>9.99"
                           tmp_cr1       at 140  column-label {&gpbarp_i_7}  FORMAT "->>,>>>,>>>,>>9.99"
                           /* tmp_cr1       at 122  column-label {&gpbarp_i_8}  FORMAT "->>>,>>>,>>9.99"
                           tmp_cr2         at 139   column-label {&gpbarp_i_9}  FORMAT "->>>,>>>,>>9.99" */
                          /*
                          tmp_acct   at 32                                   
                          tmp_curr   at 57     
                          tmp_cc     at 62      
                          tmp_project at 87 
                           tmp_dr1     at 112  column-label {&gpbarp_i_6}  FORMAT "->>,>>>,>>>,>>9.99"
                            tmp_cr1       at 134  column-label {&gpbarp_i_7}  FORMAT "->>,>>>,>>>,>>9.99"
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
                   /*ref   ref1
                   batch batch1                   
                   vend  vend1  */
           batch   
           batch1         
           nbr           
           nbr1           
           bank         
           bank1          
           ckfrm          
           ckfrm1         
           entity        
           entity1        
           vend          
           vend1          
           vdtype         
           vdtype1        
           apdate         
           apdate1        
           effdate       
           effdate1   
           /*sort_by_vend */
            with frame a.
            /*
                   if frame-field = "ref" then do for ap_mstr:
                     /* FIND NEXT/PREVIOUS RECORD */
                     {mfnp01.i ap_mstr ref ap_ref ap_type aptype ap_type_ref }
                     if recno <> ? then do:
                        ref = ap_ref.
                        find vd_mstr where vd_addr = ap_vend no-lock no-error.
                        if available vd_mstr then
                           display
  
		   ref
                              vd_addr @ vendx
                           with frame a.
    
		   find vo_mstr where vo_ref = ap_ref no-lock no-error.

               
		   if available vo_mstr then do:
                      
		   find first vpo_det where vpo_ref = vo_ref
             
		   no-lock no-error.
                           if available vpo_det then
                              display vpo_po @ po with frame a.
                           else
                              display ""     @ po with frame a.

                           display
                              vo_invoice  @ invoice
                              base_rpt
                              vo_type     @ votype
                           with frame a.
                        end.

                        recno = ?.
                     end.
                  end.
                  else do:
                     status input.
                     readkey.
                     apply lastkey.
                  end.
     */
         {wbrp06.i &command = update
                   &fields = "            batch   
           batch1         
           nbr           
           nbr1           
           bank         
           bank1          
           ckfrm          
           ckfrm1         
           entity        
           entity1        
           vend          
           vend1          
           vdtype         
           vdtype1        
           apdate         
           apdate1        
           effdate       
           effdate1   
          /* sort_by_vend */ " &frm = "a"}

         if (c-application-mode <> 'web':u) or
         (c-application-mode = 'web':u and
         (c-web-request begins 'data':u)) then 
         do:
                  
           /* {mfquoter.i ref      }
            {mfquoter.i ref1     } 
            {mfquoter.i batch    }
            {mfquoter.i batch1   }            
            {mfquoter.i vend     }
            {mfquoter.i vend1    }
            */
         {mfquoter.i batch   }
         {mfquoter.i  batch1  }       
         {mfquoter.i  nbr      }     
         {mfquoter.i  nbr1      }     
         {mfquoter.i  bank       }  
         {mfquoter.i  bank1    }      
         {mfquoter.i  ckfrm    }      
         {mfquoter.i  ckfrm1   }      
         {mfquoter.i  entity   }     
         {mfquoter.i  entity1  }      
         {mfquoter.i  vend     }     
         {mfquoter.i  vend1    }      
         {mfquoter.i  vdtype   }      
         {mfquoter.i  vdtype1  }      
         {mfquoter.i  apdate   }      
         {mfquoter.i  apdate1  }      
         {mfquoter.i  effdate  }     
         {mfquoter.i  effdate1 }  
        /* {mfquoter.i  sort_by_vend  } */

            if ref1 = "" then ref1 = hi_char.
            /*if batch1 = "" then batch1 = hi_char.            
            if vend1 = "" then vend1 = hi_char.  */
            
       if nbr     = 999999   then nbr     = 0.
       if nbr1     = 999999   then nbr1     = 0.
       if batch    = hi_char  then batch   = "".
       if batch1   = hi_char  then batch1   = "".
       if bank    = hi_char  then bank    = "".
       if bank1    = hi_char  then bank1    = "".
       if vend    = hi_char  then vend    = "".
       if vend1    = hi_char  then vend1    = "".
       if apdate   = low_date then apdate   = ?.
       if apdate1  = hi_date  then apdate1  = ?.
       if effdate  = low_date then effdate  = ?.
       if effdate1 = hi_date  then effdate1 = ?.
        if entity  = hi_char  then entity  = "".
       if entity1  = hi_char  then entity1  = "".
       if vdtype  = hi_char  then vdtype  = "".
       if vdtype1  = hi_char  then vdtype1  = "".
        if ckfrm   = hi_char  then ckfrm   = "".  
       if ckfrm1   = hi_char  then ckfrm1   = "".         

         end. /*if (c-application-mode <> 'web':u) or (c-application-mode = 'web':u and
         (c-web-request begins 'data':u)) */

            /* SELECT PRINTER */
            {mfselbpr.i "printer" 200}
            {xxmfphead1.i}  
            
          
          /* for each ap_mstr 
           where ( ap_ref >= ref or ref = '' )
           and   ( ap_ref <= ref1 or ref1 = '' )
           and   ( ap_batch >= batch or batch = '' )
           and   ( ap_batch <= batch1 or batch1 = '' )
           and   ( ap_vend >= vend or vend = '' )
           and   ( ap_vend <= vend1 or vend1 = '' )
           and   (ap_type = 'CK' ) 
           no-lock by  ap_batch  by ap_ref : */
           
    /*hill-b*/
    for each ap_mstr where ap_type = "CK"
    no-lock,
    each ck_mstr no-lock where
    ck_ref = ap_ref
    and (ap_batch >= batch or batch = '' ) and ( ap_batch <= batch1 or batch1 = '' ) 
    and (ck_nbr >= nbr  or nbr = 0 )and (ck_nbr <= nbr1 or nbr1 = 0 ) 
    and (ck_bank >= bank or bank = '' ) and ( ck_bank <= bank1 or bank1 = '' )
    and (ap_vend >= vend  or vend = '') and ( ap_vend <= vend1  or vend1 = '' ) 
    and (ap_entity >= entity or entity = '' ) and ( ap_entity <= entity1  or entity1 = '' )
    and (ap_ckfrm >= ckfrm or ckfrm = '' ) and (ap_ckfrm <= ckfrm1 or ckfrm1 = '' )
    and (((ap_date >= apdate or apdate =? ) and ( ap_date <= apdate1 or apdate1 = ? ) and
       ( ap_effdate >= effdate or effdate = ? ) and ( ap_effdate <= effdate1 or effdate1 = ? ))
    or ((ck_voiddate >= apdate or apdate = ? ) and ( ck_voiddate <= apdate1 or apdate1 = ?)  and
       (ck_voideff >= effdate or effdate = ? )  and ( ck_voideff <= effdate1 or effdate1 = ?) 
       and ck_voiddate <> ? and ck_voideff <> ?)) 
  ,
    each vd_mstr where vd_addr = ap_vend and
    (vd_type >= vdtype or vdtype = '' ) and ( vd_type <= vdtype1 or vdtype1 = '' )
    no-lock by ap_batch  by ap_ref :
           
     /*hill-e*/      
               assign acdesc = "" ccdesc = "" pjdesc ="" 
               to_dr_damt1 = 0  to_dr_damt2 =0  to_cr_damt1 = 0 to_cr_damt2 =0
               . 
              
              
             /*   find vd_mstr where vd_addr = ap_vend no-lock no-error. */
              
                assign glref = '' .
                 for first glt_det USE-INDEX glt_batch where glt_tr_type = 'AP' and glt_batch = ap_batch  and glt_doc = ap_ref no-lock:
                 if available glt_det then
                 do:
                  assign  glref = glt_ref .
                 end.
                  end.
                 if glref = '' then
                 do:
                    for first gltr_hist USE-INDEX gltr_batch where gltr_tr_type = 'AP' and gltr_batch = ap_batch and gltr_doc = ap_ref no-lock :
                      assign  glref = gltr_ref .
                     end.
                 end.
             
             
              /*  find ck_mstr where ck_ref = ap_ref  no-lock no-error.  */
              /* find  glt_det where glt_doc = ap_ref  no-error.
               if available glt_det then glref = glt_ref.
            
               
               display "AP付款凭证" at 60  skip(1). 
               
                  */
                   put  
               
                
                "AP付款凭证" at  88 
               "日期："        to 146
                today  
                skip
                "页号:"       at 28
               string         (page-number {2}) format "X(8)"
               co_name        at 79
               '时间：'        to 146
                string         (Time,"hh:mm:ss")
                .
         
                display
                   glref at 28    label "AP总账参考号"
  
	   ap_batch at 82  label "批处理"
            
	   ck_nbr at 136  when available ck_mstr label "支票号"
      
	   ap_vend at 28  label "供应商代码"
    
	   vd_sort at 82  when available vd_mstr  label "供应商名称"
   
	   ap_entity at 136  label "会计单位"

                    
                    ap_date at 28   label "日期"     
		    
                    ck_bank  at 82    when available ck_mstr  label "银行代码"    
		    
                    ap_ckfrm at 136   label "支票格式"

                              
                    ap_effdate at 28  label "生效日期"     
			      
                    ck_type at 82     when available ck_mstr label "类型"

                    (  ap_ex_rate2 / ap_ex_rate) @ ap_ex_rate
                   
		    at 136  label {&gpbarp_i_11}
                    
                    ap_rmk at 28  label "备注"
       
		    ck_status at 82   when available ck_mstr label "状态"
 
		    ap_user1 at 136  label {&gpbarp_i_12}    
      
                 with frame d side-labels width 200.  
          
          
                 find  ac_mstr where  ac_code =  ap_acct /*substring(ap_acct,1,4)*/  no-lock no-error.                
/*mage*/ 	       if available ac_mstr then  acdesc = ac_desc . 
/*mage*/               find  sb_mstr where  sb_sub =  ap_sub /* substring(ap_acct,5,4) */  no-lock no-error.                
 /*mage*/ 	       if available sb_mstr then  subdesc =    sb_desc. 

               
               find  cc_mstr where cc_ctr = ap_cc no-lock  no-error.
  
	       if available cc_mstr then ccdesc = cc_desc .
               
                if ap_amt <= 0 then
                 do:
    
		assign cr_damt1 =   - ap_amt  cr_damt2 =  - ap_base_amt .
      
		end.
                 if ap_amt > 0 then
                 do:
    
		assign dr_damt1 =   ap_amt   dr_damt2 =   ap_base_amt .
                 end.              
                create tmp_table.
                        assign
                          tem_ref         = ap_ref
                          tmp_vo_num         = ""
                          tmp_acct         =  ap_acct  + ap_sub 
                          tmp_acct_desc    =  acdesc
                          tmp_curr         =  ap_curr
                          tmp_cc           =  ap_cc 
                          tmp_cc_desc      =  ccdesc
                         tmp_sub_desc      =  subdesc
                         /* tmp_project      =  ap_project  */
                          tmp_pj_desc      =  pjdesc                    
                          tmp_dr1          = dr_damt1
                          tmp_dr2          = dr_damt2
                          tmp_cr1          = cr_damt1
                          tmp_cr2          = cr_damt2
                          tmp_batch        = ''
                          .
                          
                  to_dr_damt1 = to_dr_damt1 + dr_damt1.
     
		  to_dr_damt2 = to_dr_damt2 + dr_damt2.
        
		  to_cr_damt1 = to_cr_damt1 + cr_damt1.
       
		  to_cr_damt2 = to_cr_damt2 + cr_damt2. 
                        
                  dr_damt1  = 0.
                  dr_damt2  = 0.
                  cr_damt1  = 0.
                  cr_damt2  = 0.
                        
             for each ckd_det where ckd_ref = ap_ref no-lock :
             find first  vo_mstr where vo_ref = ckd_voucher no-error .
               
                 assign acdesc = "" ccdesc = "" pjdesc ="" . 
                 find  pj_mstr where pj_project = ckd_project no-lock   no-error.
     
		 if available pj_mstr then pjdesc = pj_desc .
                  
            
		       find  ac_mstr where  ac_code =  ckd_acct /* substring(ckd_acct,1,4) */ no-lock  no-error.                
/*mage*/ 	       if available ac_mstr then  acdesc = ac_desc . 
/*mage*/               find  sb_mstr where  sb_sub = ckd_sub  /* substring(ckd_acct,5,4)*/  no-lock no-error.                
 /*mage*/ 	       if available sb_mstr then  subdesc =  sb_desc. 
                 find  cc_mstr where cc_ctr = ckd_cc no-lock no-error.
      
		        if available cc_mstr then ccdesc = cc_desc .
                assign  dr_damt1 = 0 dr_damt2 = 0 cr_damt1 = 0 cr_damt2 = 0 .       
                 if ckd_amt <= 0 then
                 do:
		           assign cr_damt1 =   - ckd_amt  .
		           if available vo_mstr then cr_damt2 =  - (ckd_amt / (vo_ex_rate / vo_ex_rate2)) .
		           else cr_damt2 =  - (ckd_amt / (ap_ex_rate / ap_ex_rate2))  .
	       	 end.
           else    
		       do:   
		       assign dr_damt1 =   ckd_amt   .
		       /* dr_damt2 =   ( ckd_amt / (vo_ex_rate / vo_ex_rate2) ) */ .
		        if available vo_mstr then dr_damt2 = abs( - (ckd_amt / (vo_ex_rate / vo_ex_rate2)) ) .
		           else dr_damt2 =  abs (- (ckd_amt / (ap_ex_rate / ap_ex_rate2)) )  .
           end.
                 
                
                
                create tmp_table.
                        assign
                          tem_ref         = ckd_ref
                          tmp_vo_num         =  ckd_voucher 
                          tmp_acct         = ckd_acct + ckd_sub 
                          tmp_acct_desc    = acdesc
                          tmp_curr         = ap_curr
                          tmp_cc           = ckd_cc 
                          tmp_cc_desc      = ccdesc
                          tmp_sub_desc      = subdesc
                          tmp_project      = ckd_project 
                          tmp_pj_desc      = pjdesc                    
                          tmp_dr1          = dr_damt1
                          tmp_dr2          = dr_damt2
                          tmp_cr1          = cr_damt1
                          tmp_cr2          = cr_damt2.
                      
                find first apmstr01  where apmstr01.ap_ref  = ckd_det.ckd_voucher no-lock no-error .     
                if available apmstr01 then assign     tmp_batch = apmstr01.ap_batch  .
                    
                  to_dr_damt1 = to_dr_damt1 + dr_damt1.
      
		  to_dr_damt2 = to_dr_damt2 + dr_damt2.
      
		  to_cr_damt1 = to_cr_damt1 + cr_damt1.
      
		  to_cr_damt2 = to_cr_damt2 + cr_damt2. 
                   
                  dr_damt1  = 0.
                  dr_damt2  = 0.
                  cr_damt1  = 0.
                  cr_damt2  = 0.
                  
                          
             end. /*for each ckd_det*/   
             
               /*   find  pj_mstr where pj_project = ap_project   no-error.
               if available pj_mstr then pjdesc = pj_desc .
                  */
              /*hill-added汇兑损益－－－begin*/
           /* for each ckd_det where ckd_ref = ap_ref no-lock 
            ,first gltr_hist where gltr_tr_type = 'AP' and gltr_doc = ckd_ref and gltr_batch = ap_batch
                  and ( gltr_acc <> substring(ckd_acct,1,4) and gltr_sub <> substring(ckd_acct,5,4) )
                  and ( gltr_acc <> substring(ap_acct,1,4) and gltr_sub <> substring(ap_acct,5,4) )
             : */
             
         if can-find ( first  glt_det USE-INDEX glt_batch where glt_tr_type = 'AP' and glt_doc = ap_ref and glt_batch = ap_batch  and glt_doc_type = 'CK'
                 and ( glt_acct = ap_acct  /* substring(ap_acct,1,4)*/ and glt_sub =  ap_sub /*substring(ap_acct,5,4) )*/ ) ) then
                 do:    
             for each glt_det USE-INDEX glt_batch where glt_tr_type = 'AP' and glt_doc = ap_ref and glt_batch = ap_batch  and glt_doc_type = 'CK'
                 and ( glt_acct <> ap_acct  /* substring(ap_acct,1,4)*/ and glt_sub <>  ap_sub /*substring(ap_acct,5,4) )*/ )  no-lock 
             , each ckd_det where ckd_ref = ap_ref 
               and (  /*substring(ckd_acct,1,4) */ ckd_acct <> glt_acct and /*substring(ckd_acct,5,4) */ ckd_sub  <> glt_sub ) no-lock :
                
                 if can-find( first tmp_table where tem_ref = ap_ref and tmp_acct = ( glt_acc + glt_sub ) ) then leave .
             /* message ckd_amt . 
             pause.*/
                 assign acdesc = "" ccdesc = "" pjdesc ="" . 
                 find  pj_mstr where pj_project = glt_project no-lock   no-error.
     
		 if available pj_mstr then pjdesc = pj_desc .
                  
            
		       find  ac_mstr where  ac_code =  glt_acc no-lock  no-error.                
/*mage*/ 	       if available ac_mstr then  acdesc = ac_desc . 
/*mage*/               find  sb_mstr where  sb_sub =  glt_sub no-lock no-error.                
 /*mage*/ 	       if available sb_mstr then  subdesc =  sb_desc. 
                 find  cc_mstr where cc_ctr = glt_cc no-lock no-error.
      
		 if available cc_mstr then ccdesc = cc_desc .
                 
                 if glt_amt <= 0 then
                 do:
      
		 assign cr_damt1 =   0   cr_damt2 = - glt_amt  .
   
		 end.
               
		 if glt_amt > 0 then
                 do:
   
		 assign dr_damt1 = 0    dr_damt2 =    glt_amt   .
                 end.
                create tmp_table.
                        assign
                          tem_ref         = ckd_ref
                          tmp_vo_num         =  '' 
                          tmp_acct         = ( glt_acc + glt_sub )
                          tmp_acct_desc    = acdesc
                          tmp_curr         = 'CNY'
                          tmp_cc           = glt_cc
                          tmp_cc_desc      = ccdesc
                          tmp_sub_desc      = subdesc
                          tmp_project      = glt_project 
                          tmp_pj_desc      = pjdesc                    
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
                    
                 
              end.
      end.
      else
      do:        
              for each gltr_hist USE-INDEX gltr_batch where gltr_tr_type = 'AP' and gltr_doc = ap_ref and gltr_batch = ap_batch  and gltr_doc_typ = 'CK'
                 and ( gltr_acc <> ap_acct  /* substring(ap_acct,1,4)*/ and gltr_sub <>  ap_sub /*substring(ap_acct,5,4) )*/ )  no-lock 
             , each ckd_det where ckd_ref = ap_ref 
               and (  /*substring(ckd_acct,1,4) */ ckd_acct <> gltr_acc and /*substring(ckd_acct,5,4) */ ckd_sub  <> gltr_sub ) no-lock :
               
               if can-find( first tmp_table where tem_ref = ap_ref and tmp_acct = ( gltr_acc + gltr_sub ) ) then leave .
             /* message ckd_amt . 
             pause.*/
                 assign acdesc = "" ccdesc = "" pjdesc ="" . 
                 find  pj_mstr where pj_project = gltr_project no-lock   no-error.
     
		 if available pj_mstr then pjdesc = pj_desc .
                  
            
		       find  ac_mstr where  ac_code =  gltr_acc no-lock  no-error.                
/*mage*/ 	       if available ac_mstr then  acdesc = ac_desc . 
/*mage*/               find  sb_mstr where  sb_sub =  gltr_sub no-lock no-error.                
 /*mage*/ 	       if available sb_mstr then  subdesc =  sb_desc. 
                 find  cc_mstr where cc_ctr = gltr_ctr no-lock no-error.
      
		 if available cc_mstr then ccdesc = cc_desc .
                 
                 if gltr_amt <= 0 then
                 do:
      
		 assign cr_damt1 =   0   cr_damt2 = - gltr_amt  .
   
		 end.
               
		 if gltr_amt > 0 then
                 do:
   
		 assign dr_damt1 = 0    dr_damt2 =    gltr_amt   .
                 end.
                create tmp_table.
                        assign
                          tem_ref         = ckd_ref
                          tmp_vo_num         =  '' 
                          tmp_acct         = ( gltr_acc + gltr_sub )
                          tmp_acct_desc    = acdesc
                          tmp_curr         = 'CNY'
                          tmp_cc           = gltr_ctr 
                          tmp_cc_desc      = ccdesc
                          tmp_sub_desc      = subdesc
                          tmp_project      = gltr_project 
                          tmp_pj_desc      = pjdesc                    
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
                  
                          
             end.     /*for each gltr*/
         end.
            /* hill-added汇兑损益－－－end*/    
                  
                  
                  
              
             /*display item begin*/
              for each tmp_table no-lock  break by tem_ref  by tmp_cr1   with frame c width 200 :
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
                   /*
                   
                   38                                  
                          tmp_curr   at 52      
                          tmp_cc     at 58       
                          tmp_project at 73 
                           tmp_dr1      at 88  column-label {&gpbarp_i_6}  FORMAT "->>>,>>>,>>9.99"
                           tmp_dr2       at 105  column-label {&gpbarp_i_7}  FORMAT "->>>,>>>,>>9.99"
                           tmp_cr1       at 122  column-label {&gpbarp_i_8}  FORMAT "->>>,>>>,>>9.99"
                           tmp_cr2         at 139
                   */
                   
               if  not ( (tmp_dr1 + tmp_dr2) = 0  and  ( tmp_cr1 + tmp_cr2 ) = 0 ) then
               do: 
                display 
                          tmp_batch  at 28      
                          tmp_acct   at 38                                   
                          tmp_curr   at 63      
                          tmp_cc     at 68      
                          tmp_project at 93  with frame c.
                          /*
                          tmp_acct   at 38                                  
                          tmp_curr   at 63      
                          tmp_cc     at 68      
                          tmp_project at 93
                           tmp_dr1      at 116  column-label {&gpbarp_i_6}  FORMAT "->>,>>>,>>>,>>9.99"
                           tmp_dr2       at 140  column-label {&gpbarp_i_7}  FORMAT "->>,>>>,>>>,>>9.99"
                          */
                          if tmp_dr1 <> 0  then  display   tmp_dr1 with frame c .   else  display   "" @ tmp_dr1 with frame c .
                         /* if tmp_dr2 <> 0  then  display   tmp_dr2 with frame c .   else  display  "" @  tmp_dr2 with frame c . */
                          if tmp_cr1 <> 0  then  display   tmp_cr1 with frame c .   else   display  "" @  tmp_cr1 with frame c.
                         /* if tmp_cr2 <> 0  then   display  tmp_cr2  with frame c.    else  display  "" @     tmp_cr2 with frame c . */    
                          down.
                put
                          tmp_vo_num     at 28
                          tmp_acct_desc  at 38  
                          tmp_cc_desc    at 68.
               if trim(tmp_project)  = '' then put '' at 93 .
               else  put  tmp_pj_desc    at 93.
                          if tmp_dr2 <> 0  then put tmp_dr2 at 120.
                          if tmp_cr2 <> 0  then put tmp_cr2 at 142.
			            put        tmp_sub_desc  at 38  .
                          
              end.               
                      
                  if last-of(tem_ref) then
             do:
                put "----" at 28  "------------------    ------------------" at 118.
                put                
                 "合计"      at 28   
                 to_dr_damt1    at 120 
                 to_cr_damt1    at 142 
                 to_dr_damt2  at 120   
                  
                 to_cr_damt2  at 142                 
                 .         
                  do while page-size - line-counter > 4:
                     put skip(1).
                  end.
               if page-size - line-counter < 4 then page.
                  
                  
                   put "财务经理:" at 28.
                  
                   put "经办人:"   at 98.
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
  
