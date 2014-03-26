/* xxkbporl.p  For PO KB read Issue                                         */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=NoConvert                                                  */
/* REVISION: 1.0      Create : 06/28/2007   BY: Softspeed tommy xie         */
/* REVISION: 1.0      Create : 09/09/2007   BY: Softspeed Mage Chen         */
/* ss - 101020.1 by: mage */  /* 记录产生/调整周期计划的程序*/
/* ss - 120720.1 -b */  /* 增加wms控制 */



/*********** start tx01*************
   xxkbporl.p ----> xxrebkbcmt.p      
                    xxtransbcmt.i
                    xxsetupbcmt.i
                    xxdownbcmt.i
                    xxdowntimebcmt.i
                    xxretrforbcmt.i
       

   xxrebkbcmt.p --> xxredfltbcmt.p
                      --> xxretrforbcmt.i
                    xxretrin3bcmt.p
		      --> xxretrforbcmt.i		      
		    xxreopvalbcmt.i 
		    xxrebkfli1bcmt.p
		      --> xxretrforbcmt.i
		      --> xxresrqrinbcmt.p
		    xxreisslstbcmt.p
		      --> xxicedit2bcmt.p
		            --> xxicedit2bcmt.i
		    xxrercvlstbcmt.p
		    xxreoptr1fbcmt.p
		      --> xxicedit2bcmt.p
		            --> xxicedit2bcmt.i
		    xxreceivebcmt.p
		    xxrenplfmt.p
		      --> xxretrformmt.i
		    xxreophist.p 
		    
*********** end tx01*************/

	 /* DISPLAY TITLE */
	 /*
         {mfdtitle.i "120418.1"}
*/
    {mfdtitle.i "120720.1"}

/*mage	 define variable d_qty as integer label "差异数量" .
	 define variable compkb_qty as integer label "完成看板数量" .
	 define variable qc_qty as integer label "品质异常数量" . */

	    {xxkbbk04bcmt.i new}
 /*H1L6*/   {rescttdf.i "new shared"}
define new shared buffer gl_ctrl for gl_ctrl.

         define variable kb_enable like xkbc_enable.
	 define variable b_part like pt_part.
	 define variable part_old like pt_part.
	 define variable l_stat like xkb_status.
	 define variable l_time as integer.
	 define variable l_time_h as integer.
	 define variable l_date as date.
	 define variable l_date_h as date.
	 define variable l_recid_h as recid.
	 define variable l_recid as recid.
         define variable trnbr as integer.
         define variable trnbr1 as integer.
	 define variable b_barcode like xlkh_barcode.
         define variable f_barcode like xlkh_barcode.
	 define variable b_bc like xlkh_barcode.
	 define variable f_time like xlkh_time.
         define variable dt_time_b like xlkh_time.
         define variable dt_time_f like xlkh_time.
         define variable date_b as date.
         define variable date_f as date.
	 define variable start_time like xlkh_time.
	 define variable stop_time like xlkh_time.
         define variable seq as integer.
	 define variable time_sp as decimal format "zz9.9" extent 4 no-undo.
	 define variable time_dt as decimal format "zz9.9" no-undo.
	 define variable time_dn as decimal format "zz9.9" no-undo.
         define variable first_part like xkb_part no-undo.
	 define variable first_date like xkb_upt_date no-undo.
         define variable first_time like xlkh_time no-undo.
	 define variable last_date like xkb_upt_date no-undo.
	 define variable last_bc as char format "x(24)"  label "上一个条码" .
	 define variable last_time as integer label "上一次时间" .


         define new shared variable sf_entity like en_entity.
         define new shared variable op_recno as recid.
         define new shared variable sf_gl_amt like tr_gl_amt.
         define new shared variable sf_cr_acct   like dpt_lbr_acct.
         define new shared variable sf_dr_acct   like dpt_lbr_acct.
         define new shared variable sf_cr_sub    like dpt_lbr_sub.
         define new shared variable sf_dr_sub    like dpt_lbr_sub.
         define new shared variable sf_cr_cc     like dpt_lbr_cc.
         define new shared variable sf_dr_cc     like dpt_lbr_cc.
         define new shared variable ref          like glt_ref.
         define new shared variable opgltype     like opgl_type.
	 define variable project like op_project  no-undo.
         define variable pay_rate like emp_pay_rate no-undo.	  
         define variable sf_lbr_acct like dpt_lbr_acct no-undo.
         define variable sf_bdn_acct like dpt_bdn_acct no-undo.
         define variable sf_cop_acct like dpt_cop_acct no-undo.
         define variable sf_lbr_sub  like dpt_lbr_sub no-undo.
         define variable sf_bdn_sub  like dpt_bdn_sub no-undo.
         define variable sf_cop_sub  like dpt_cop_sub no-undo.
         define variable sf_lbr_cc   like dpt_lbr_cc no-undo.
         define variable sf_bdn_cc   like dpt_bdn_cc no-undo.
         define variable sf_cop_cc   like dpt_cop_cc no-undo.
         define variable earn like op_earn label "Pay Code" no-undo.

         define variable lotserial as char.
	 define variable trans_type as character.
	 define variable i as integer.
         define variable cumwo_lot as character.
         define variable ophist_recid as recid.
	 define variable schedwo_lot as character.
	 define variable upt_loc like loc_loc.

	 define variable rcp_user as character.
	 define variable rcp_file as character format "x(24)" .
	 
	 define variable lndtool     like lnd_tool.
         define variable xkbsite     like xkb_site no-undo.
         define variable xkbpart     like xkb_part no-undo.
         define variable xkbtype     like xkb_type no-undo.
         define variable xkbloc      like xkb_loc  no-undo.
         define variable xkboriqty   like xkb_kb_raim_qty no-undo.
         define variable xkbkbid     like xkb_kb_id no-undo.
         define variable xkbraimqty   like xkb_kb_raim_qty no-undo.
         define variable choice       as logical initial no no-undo.
         define variable choice2      as logical initial no no-undo.
         define variable choice3      as logical initial no no-undo.
         define variable i_x          as integer  no-undo.
         define variable i_prod       as integer  no-undo.

         define variable xkbpart1     like xkb_part no-undo.
         define variable xkbtype1     like xkb_type no-undo.
         define variable xkbid1       like  xkb_kb_id no-undo.

/*ss - 090601.1 -b*/
 	 define variable    start_date like xlns_start_date  no-undo.
	 define variable    men_qty    as  integer   no-undo.
	 define variable    tot_rest    as  decimal   no-undo.
	 define variable    tot_time1    as  decimal   no-undo.
	 define variable    diff_time1    as  decimal   no-undo.
	 define variable    share_tot_rest    as  decimal   no-undo.
 	 define variable    yn-over       as logical  no-undo.
  	 define variable    tot-part       as integer  no-undo.
 	 define variable    end_date like xlns_start_date  no-undo.
	 define variable    end_time like xlkh_time.
         define variable s_rel_qty      like xkb_kb_raim_qty  no-undo.  
 	 define variable  relqty      like xkb_kb_raim_qty  no-undo.  
	 define variable  s_seq1      like xlnd_tot_sequence label "序号"  no-undo.  
	 define variable s_rel_qty1      like xkb_kb_raim_qty  no-undo.  
	 define variable    s_stoptime   as  decimal   no-undo.
	 define variable    tot_wktime   as  decimal   no-undo.
 	 define variable    std_run   as  decimal initial 0.01   no-undo.
         def new shared var xxdue1 as date initial today.
	 def new shared var xxdue  as date initial today.
 def new shared var productioner  as character .
	 def new shared var companyname   as character  format "x(24)" .
	 def new shared var companyname1  as character  format "x(24)" .
         define var unfill_kb_id0 as  logical.
define var unfill_kb_idn as  logical.
define var unfill_kbidn  like xkb_kb_id .
define var unfill_kbid0_qty  as  decimal.
define var unfill_kbidn_qty  as  decimal .
define var startx  as  logical.
define var raimbc1  as  char format "x(24)" .
startx = yes.
  define var xxbcprnparm as char no-undo.
  define var xxbcdatastr as char no-undo.
  define var xxthtype   as  char.
  define var xxthdesc1  as  char  format "x(24)".
  define var xxthdesc2  as  char  format "x(24)".

  define var xxprnflag as logic no-undo.
  xxprnflag = yes.

	 define var old_kbrecid as recid .  

	 define variable xlnsstatus      like xlns_status.
	 define variable xlnslast_status like xlns_last_status.  
	 define variable xlnsbarcode1    like  xlns_barcode1.         
	 define variable xlnsbarcode2    like  xlns_barcode1. 
         define variable xlnsbc_date1    like  xlns_bc_date1.
	 define variable xlnsbc_time1    like  xlns_bc_time1.
	 define variable xlnsbc_date2    like  xlns_bc_date2.
	 define variable xlnsbc_time2    like  xlns_bc_time2.
/*ss - 09define variable0601.1 -e*/		 
	 define variable old_period_date as date.
	 define variable old_period  as integer.
	 define buffer xkbhhist for xkbh_hist.
	 define buffer xlnsdet  for xlns_det.
/*tx01*/ {gldydef.i new}
/*tx01*/ {gldynrm.i new}
/*ss - 20120204.1 - b*/
       define variable samplepart as char .
       define variable lineprinter as char format "x(24)" .

/*ss - 20120204.1 - b*/       
/*mage*/  op = 10.
	     
	 find first icc_ctrl where icc_domain = global_domain no-lock no-error.
	 site = (if available icc_ctrl then icc_site else global_domain).

         find first xkbc_ctrl where xkbc_domain = global_domain 
	        and (xkbc_site = site or xkbc_site = "") no-lock no-error.

	 if available xkbc_ctrl then kb_enable = xkbc_enable.
         for first si_mstr
         fields( si_domain si_entity si_site)
          where si_mstr.si_domain = global_domain and  si_site = global_domain
         no-lock:
         end. /* FOR FIRST si_mstr ... */	 
/* 是否已开帐  /*mage add 08/07/07*/  */     {gpglefv.i}  
	 if not kb_enable then do:
	    message "警告: 看板未启用, 不能进行生产看板接收!"  .	       
	    leave.
	 end.
         setx:
	 do on error undo, retry with frame a:
            update pdln
	    with frame a editing:
               if frame-field = "pdln" then do:
                  {mfnp.i ln_mstr pdln  " ln_mstr.ln_domain = global_domain and
                          ln_line "  pdln ln_line ln_line site}
                  if recno <> ? then do:
                     display ln_line @ pdln ln_desc
                     with frame a.
                  end.
               end. /* if frame-field */
               else do:
                  readkey.
                  apply lastkey.
               end.
            end. /* prompt-for */


            {xxeffdate.i}
 /*是否已开帐  /*mage add 08/07/07*/  */          {gpglef1.i &module = ""IC""
                    &entity = si_entity
                    &date   = eff_date
                    &prompt = "pdln"
                    &frame  = "a"
                    &loop   = "setx"
                 } 
 
            find first ln_mstr where ln_mstr.ln_domain = global_domain
               and ln_line =  pdln no-lock no-error.
            
	    if not available ln_mstr then do:
               message "错误: 生产线不存在,请重新输入!"   .
               next-prompt pdln with frame a.
               undo, retry.	       
            end. /* IF NOT AVAILABLE ln_mstr */
	    else display ln_desc with frame a.
           s_period  = 1.
	  shift = "A".

        find first code_mstr where code_domain = global_domain and code_fldname = "lineprinter" 
        and  code_value = pdln no-lock no-error.
	 if not available code_mstr then do:
	             lineprinter =  lineprinter.
                 if length(lineprinter) <= 2 then  do: 
                 message "生产线打印机没有设置" view-as alert-box.
	         	           undo, retry .
                 end.
	       end.
	       else  lineprinter = code_cmmt. 

            /*是否所有的完成已投放看板, 若是则要删除xlns_det ***/
            for each xlns_det where xlns_domain = global_domain  and xlns_site  = global_domain 
	       and xlns_line = pdln :

               find first xkb_mstr where xkb_domain = global_domain and xkb_site = xlns_site 
	          and xkb_part = xlns_part  and xkb_status = "P" no-lock no-error.

	       if  ((xlns_rel_qty <= xlns_comp_qty or xlns_kb_rel <= xlns_kb_comp ) 
	          or not available xkb_mstr )
	          and xlns_start_date = ? then 
	          delete xlns_det .
	       
             end.
             clear frame bx all no-pause .
             i_prod = 0.
	     for each  xlns_det no-lock
	       where xlns_domain = global_domain and xlns_site = global_domain
	         and xlns_line = pdln,
	       each pt_mstr no-lock where pt_domain = global_domain 
	          and pt_part = xlns_part break by xlns_line :
                  i_prod = i_prod + 1.
	     if first-of(xlns_line) then  
	          display
                     xlns_start_date                         
   		     string(xlns_start_time , "HH:MM:SS" ) @ xlns_start_time
                /*   xlns_tot_sp     
   		     xlns_chr[1]     
                     xlns_dec[1]     
                     xlns_chr[2]     
   		     xlns_dec[2]     
                     xlns_chr[3]     
                     xlns_dec[3]     
   		     xlns_tot_dn     
                     xlns_tot_dt  */   
 		     xlns_status 
		     with frame a .
               

               find last lnd_det no-lock where lnd_domain = global_domain 
		  and lnd_line = xlns_line and lnd_part = xlns_part 
	          and lnd_start <= today no-error .
/*ss - 090727.1 - b	       
	       if available lnd_det and lnd_rate >= 0 then 
		  d_qty = xlns_tot_prod * lnd_rate - xlns_comp_qty .
	       

   	       
	       display 
   		   xlns_part     label "产品编号" format "x(17)"       
                   pt_desc1      label "产品名称" FORMAT "X(24)"        
                   xlns_rel_qty  label "投产量"   format ">>>>>9"   
                   xlns_comp_qty label "完成量"   format ">>>>>9"   
   		   xlns_tot_Prod label "工时"     format ">>9.99" 
		   xlns_tot_qc   label "异常量"   format ">>>>>9"
                   d_qty         label "差异量"   format "->>>>9"
		   with frame bx  overlay   . 
*ss - 090727.1 - e*/ 
/*ss - 090727.1 - b*/	       
	      

   	       
	       display 
   		   xlns_part     label "产品编号" format "x(17)"       
                   pt_desc1      label "产品名称" FORMAT "X(24)"        
                   xlns_rel_qty  label "投产量"   format ">>>>>9"   
                   xlns_comp_qty label "完成量"   format ">>>>>9"   
 		   xlns_tot_qc   label "异常量"   format ">>>>>9"
 		   with frame bx  overlay   . 
/*ss - 090727.1 - e*/ 
		   down 1 with frame bx.
     /*          put pt_desc1 pt_desc2 skip . */
	       
             end. /*for each xlns_det *********/
	    
	 end.  /*do on error undo, retry with frame a: */
/*ss - 090601.1 -b*/
	    start_time = 0 .
	    start_date = ? .
	    men_qty = 0.
	    tot_rest = 0.
             assign old_period_date = ?  
		   old_period      = 0 .
/*ss - 090601.1 -e*/	          
         find first xlns_det where xlns_domain = global_domain and xlns_site = global_domain and xlns_line  = pdln no-error. 
         if available xlns_det then do:
/*ss - 090601.1 -b*/
	    start_time = xlns_start_time .
	    start_date = xlns_start_date .
	    men_qty = xlns_int[1].
	    tot_rest = xlns_tot_rest.
	    assign old_period_date = xlns_date[1]  
		   old_period      = xlns_int[3]  .
/*ss - 090601.1 -e*/		 

/*ss - 090601.1 -b*		 
                find first lnd_det   no-lock where lnd_domain = global_domain and lnd_line = pdln and lnd_part = xlns_part and lnd_tool <> "" no-error.

                if available lnd_det then lndtool = lnd_tool . 
		 else do:
		   lndtool = "".
		    message "错误: 一出多程序不能控制非一出多产品,请重新输入!"   .
                    next-prompt pdln with frame a.
                    undo, retry.
                 end. 
*ss - 090601.1 -e*/		 
		 
         end.

	 if time <  28800  then  s_period_date = today - 1 .   else s_period_date = today .
                           
            display s_period_date  s_period  shift with frame  a.
            update s_period_date  s_period  with frame  a.
                      IF s_period = ?  THEN DO:
                           MESSAGE "周期不能为空" VIEW-AS ALERT-BOX .
                           UNDO, RETRY .
                       END.
		       IF s_period_date = ?  THEN DO:
                           MESSAGE "周期日期不能为空" VIEW-AS ALERT-BOX .
                           UNDO, RETRY .
                       END.

/*ss - 101106.1 - b*/        
	  if (time <=  28800 and  s_period_date <> today - 1  
	        or time > 28800 and time <= 36000 and not ( s_period_date = today - 1 or  s_period_date = today ) 
		or time > 36000 and s_period_date <> today )
	          then do:
               message "错误: 周期日期不能大于当前当前日期或小于前一日,请重新输入!"   .
               next-prompt s_period_date  with frame a1.
               undo, retry.	
	     end.
/*ss - 101106.1 - b*/

            if index("AB",   shift) < 1 then do:
               message "错误: 班次只能是A或B,请重新输入!"   .
               next-prompt  shift  with frame a1.
               undo, retry.	
	    end.

        find first code_mstr where code_domain = global_domain and code_fldname = "s_period" 
        and  code_value = pdln no-lock no-error.
	if not available code_mstr then  find first code_mstr where code_domain = global_domain and code_fldname = "s_period" 
          and  code_value = ""  no-lock no-error.
	  if available code_mstr then do:
	        if   not (s_period  >=  1   and   string(s_period)  <= code_cmmt  
		and length(string(s_period))  <=  length(code_cmmt))  then do:
               	      message "周期不能小于1或大于 "  code_cmmt  view-as alert-box.
	              next-prompt s_period .
	              undo, retry .
	          end.   /* if   not s_period  >=  1   and   string(s_period)  <= code_cmmt then do: */
           END.  /*if available code_mstr */
	   else do:
              if   s_period  <  1 or  s_period  > 10  then do:
	           message "周期不能小于1或大于 10" view-as alert-box.
	           next-prompt s_period .
	           undo, retry .
	        end.   /*else do: */   
           end.    /*else do: */

               if (old_period_date   <  s_period_date  and old_period_date  <>  ?  or 
	           old_period     <>     s_period )  then	      
              for each  xlns_det 
	       where xlns_domain = global_domain and xlns_site = global_domain
	         and xlns_line = pdln :
                   assign xlns_date[1]  = s_period_date
	                  xlns_int[3]     =    s_period.
		 assign 
                     xlns_xdate[1] = today                       
   		     xlns_xtime[1] = time
                     xlns_xdec[1]  = xlns_rel_qty
                     xlns_xdec[2]  = xlns_comp_qty
   		     xlns_xdec[3]  = xlns_tot_Prod
                     xlns_xdec[4]  = xlns_tot_sp 
   		     xlns_xdec[5]  = xlns_tot_dn 
                     xlns_xdec[6]  = xlns_tot_dt 
                     xlns_xdec[7]  = xlns_tot_qc .
 
              end.
/*minth 08/05/27*/        release xlns_det .

 /*ss - 090601.1 -b*/		 
         if start_time = 0 and start_date = ? then do:
	    display men_qty with frame ay.
            update men_qty  format "99"  label "人数" with frame ay side-labels width 40 overlay row 17 column 15.
         
            if men_qty > 0 and men_qty < 100 then do:
              assign   start_time = time  
	               start_date = today
		       tot_rest = 0.

              for each  xlns_det  
	       where xlns_domain = global_domain and xlns_site = global_domain
	         and xlns_line = pdln  break by xlns_line :
/*生产线状态自动恢復*/
                 if first-of(xlns_line) then do:
		    if xlns_status = "生产中"  then  do:
                       xlns_last_status = "生产中".
		       xlns_barcode1 = "".
		       xlns_barcode2 = "".
		    end.
		    if xlns_status = "休息中"  and xlns_last_status = "休息中"  then do:
		      xlns_last_status = "生产中".
		      xlns_barcode1 = "".
		      xlns_barcode2 = "".
		    end.
                       xlnsstatus      =  xlns_status.
		       xlnslast_status =  xlns_last_status.  
		       xlnsbarcode1    =  xlns_barcode1.         
		       xlnsbarcode2    =  xlns_barcode1. 
                       xlnsbc_date1    =  xlns_bc_date1.
		       xlnsbc_time1    =  xlns_bc_time1.
		       xlnsbc_date2    =  xlns_bc_date2.
		       xlnsbc_time2    =  xlns_bc_time2.

 		 end.
                   
		       xlns_status      =  xlnsstatus.
		       xlns_last_status =  xlnslast_status.  
		       xlns_barcode1    =  xlnsbarcode1 .         
		       xlns_barcode2    =  xlnsbarcode2 .
		       xlns_bc_date1    =  xlnsbc_date1.
		       xlns_bc_time1    =  xlnsbc_time1.
		       xlns_bc_date2    =  xlnsbc_date2.
		       xlns_bc_time2    =  xlnsbc_time2.
/*生产线状态自动恢復*/

                  xlns_start_time  = start_time.
	          xlns_start_date  = start_date.
		  xlns_int[1] = men_qty.
		  xlns_tot_rest = tot_rest.
		  assign  
	                                  xlns_date[1]    = s_period_date
	                                  xlns_int[3]     =    s_period. 
					  


/*ss - 120109.1 - b*/		    
                 unfill_kb_id0 = no.
                 unfill_kb_idn = no.
                 unfill_kbidn  = 0.
                 unfill_kbid0_qty = 0.
                 unfill_kbidn_qty = 0.

              for each xkb_mstr no-lock where xkb_domain = global_domain and xkb_site = xlns_site 
                and xkb_part = xlns_part  and (xkb_kb_id = 0 and xkb_status = "U" and xkb_kb_raim_qty > 0  
                or xkb_kb_id <> 0 and xkb_status = "P" and xkb_kb_raim_qty > 0) :

              if xkb_kb_id = 0 then assign unfill_kb_id0  = yes  unfill_kbid0_qty =  xkb_kb_raim_qty.
               if xkb_kb_id <> 0 then  assign  unfill_kb_idn = yes
                                     unfill_kbidn   =  xkb_kb_id 
				     unfill_kbidn_qty =  xkb_kb_raim_qty.
               end.
               if unfill_kb_idn  or unfill_kb_id0 then do:

/*ss -  120110 - b************************/
         message  "产品"  xlns_part  "有未完成的尾数看板! 请找到相关的产品尾数标签" 
                 unfill_kbidn unfill_kbidn_qty
	VIEW-AS ALERT-BOX QUESTION BUTTONS OK.
        update raimbc1  label "尾数标签编号"   with frame ax1 side-labels width 72  overlay row 12 column 5  .
	find first xbc1_mstr where xbc1_domain = global_domain 
	    and xbc1_bc = raimbc1  and xbc1_part = xlns_part and xbc1_type = "R" no-lock no-error.
	 if not available xbc1_mstr then do:
             message "不是正在生产产品的尾数条码" view-as alert-box.
               next-prompt raimbc1  with frame ax1.
	       undo, retry.
	     end.  
/*ss -  120110 - e************************/
/*ss -  120110 - b************************
         message "有未完成的尾数看板! 请找到相关的产品看板" 
                 unfill_kbidn unfill_kbidn_qty
	VIEW-AS ALERT-BOX QUESTION BUTTONS OK.
        update raimbc1  label "相关产品看板"   with frame ax1 side-labels width 72  overlay row 12 column 5  .


/*	find first xbc1_mstr where xbc1_domain = global_domain 
	    and xbc1_bc = raimbc1  and xbc1_part = and xbc1_type = "R" no-lock no-error. */


	 if xlns_part <>  substring(raimbc1, 2, length(p_bc) - 4) then do:
             message "不是正在生产产品相关看板" view-as alert-box.
               next-prompt raimbc1  with frame ax1.
	       undo, retry.
	     end.  
*ss -  120110 - e************************/	     
         hide frame ax1 .

end.
/*ss - 120109.1 - e*/


              end.
	    end.
	    else do:
	      message "人数不能小于1或大于100，请重新输入！"  view-as alert-box.
              next-prompt men_qty with frame ay.
              undo, retry.	       
	    end.
 	end. /* if start_time = 0 and start_date = ? then do:*/
/*ss - 090601.1 -e*/	

/*ss - 111207.1 - b****************************/ 
  update productioner  label "生产员工编号"   with frame ax side-labels width 72  overlay row 12 column 5  .
	 if productioner = "" then do:
             message "生产员工编号不能为空" view-as alert-box.
	           next-prompt productioner .
	           undo, retry .
	 end.      
         hide frame ax .


 

find first ad_mstr no-lock  where ad_mstr.ad_domain = global_domain and  ad_addr =
  global_domain and ad_type = "company"  no-error.

   if available ad_mstr
   then companyname = ad_name.
   else companyname = "敏实集团".
/*ss - 111207.1 - e****************************/

         repeat:         
  	    do on error undo, retry with frame a:
	       trnbr = 0.  trnbr1 = 0.

	       update p_bc with frame a.
 
               if p_bc = "" then do:
	          message "错误: 看板条码空号不允许!"  .
                  next-prompt p_bc with frame a.
                  undo, retry.	       
	       end.
/*ss - 20120204.1 - b*/
         find first pt_mstr where pt_domain = global_domain and
	      pt_part = p_bc no-lock no-error.
	    if available pt_mstr then do:
 	       message "样品:" pt_part pt_desc1 pt_desc2 "条码，成功接收！"   view-as alert-box.
	       samplepart = p_bc.
 	       next.
	     end.
/*ss - 20120204.1 - b*/
/*minth 08/05/27*/  find first xlns_det where xlns_domain = global_domain and xlns_site = global_domain 
                            and  xlns_line  = pdln and xlns_part <> "" no-error. 

               if available xlns_det and last_bc = p_bc 
	          and ((time - last_time ) < 10  and  time >= 10 )  then do:
	          message "错误: 在十秒钟之内不能刷读同一条码!"   .
                  next-prompt p_bc with frame a.
                  undo, retry.	       
	       end.
 
 /*产生报警信息*/
find first xlnc_mstr where xlnc_domain = global_domain 
	               and xlnc_line = pdln  
		       and xlnc_barcode = p_bc 
		       and index(xlnc_barcode, "AL" )  >= 1  no-lock no-error. 
                   
		   if  available xlnc_mstr then do:
		       find first xald_det where  xald_domain = GLOBAL_domain 
		            and   xald_site = global_domain	
				and  xald_line = pdln
				and  xald_comedate <= today
				and  xald_type = "AL"
				and  not xald_closed 
				and    xald_alertcode = xlnc_code
				no-error.
				if not available xald_det then do:
                            create  xald_det .
		              assign xald_domain = GLOBAL_domain 
		                   xald_comedate = today 
				   xald_cometime     =  time
				   xald_site = global_domain
				   xald_line = pdln
				   xald_type = "AL"
				   xald_alertcode = xlnc_code
				   xald_desc = xlnc_desc
				  
/*ss - 100918.1 - B*/
                                 xald_update = string(today) + string(time, "999999")
/*ss - 100918.1 - e*/    
                             . 			
                                message  xlnc_desc "报警信息成功接收!" .
			    end.
			    else do:
			          if  xald_proddate = ?  then assign xald_proddate = today xald_prodtime = time.
				     else  assign xald_compdate = today  xald_comptime = time xald_close = yes.
				     
/*ss - 100918.1 - B*/
                                 xald_update = string(today) + string(time, "999999").
/*ss - 100918.1 - e*/    
                             . 			
			    end.  /*else do: */

			next .
		   end.
/*产生报警信息*/
/*如是生产看板, 先判断是否看板是当前生产线条码*/
/*看板条码状态是否正确*/
               xkbtype1 = substring(p_bc,1,1).
	       if length(p_bc) >= 19 and xkbtype1 = "M" then assign  xkbpart1 = substring(p_bc, 2, length(p_bc) - 4)
	                                          xkbid1   = integer(substring(p_bc, length(p_bc) - 2,3)) .
                                     else assign  xkbpart1 = ""
				                  xkbid1   = 0.
                find first xkb_mstr where xkb_domain = global_domain
	              and xkb_site = global_domain
		      and xkb_part = xkbpart1
	              and xkb_type = xkbtype1 and xkb_type = "M" 
		      and xkb_kb_id   = xkbid1
 		      no-error. 
              

               if available xkb_mstr then do: /*是生产管理看板**/
	         find first   xlns_det where xlns_domain = global_domain and xlns_site = xkb_site 
			    and xlns_line  = pdln and xlns_part <>  ""  no-lock no-error.

                  if  available xlns_det and xlns_barcode1 <> ""     then do:
                      message "错误: 这条生产线目前不可以接收生产看板!生产线接受条码是:"  xlns_barcode1 .
                      next-prompt p_bc with frame a.
                      undo, retry.
		  end.

	       find xlns_det where xlns_domain = global_domain and xlns_site = xkb_site 
			    and xlns_line  = pdln and xlns_part = xkb_part no-lock no-error.

                  if  available xlns_det and xlns_barcode1 <> ""  and xkb_status <> "R" then do:
                      message "错误: 这条生产线目前不可以接收非 R 状态的生产看板!生产线接受条码是:"  xlns_barcode1 .
                      next-prompt p_bc with frame a.
                      undo, retry.
		  end.
                  if (xkb_prod_line <> pdln )then do:
                        message "错误: 不是这条生产线的生产看板!"  .
                        next-prompt p_bc with frame a.
                        undo, retry.
		   end.

                  if not (xkb_status = "R" or  xkb_status = "P") then do:
                        message "错误: 看板状态不是 R 或 P 状态!, 而是"  xkb_status "! 不可接收!"   .
                        next-prompt p_bc with frame a.
                        undo, retry.
                  end.

/*判断是否是正在生产产品*******************/ 
 /*ss - 090601.1 -b*		 
                  if lndtool <> ""  then do:  /*此条生产线有产品正在生产**/
 		      find first lnd_det where lnd_domain = global_domain and lnd_line = pdln 
		           and  lnd_part = xkb_part and lnd_tool <> ""  no-error.
                      if available lnd_det and lnd_tool <> lndtool  and  lndtool <> "" then do:
                            message "错误: 这条线正在生产的产品, 不允许同时生产这个产品!"   .
                            next-prompt p_bc with frame a.
                            undo, retry.
		      end.
		      else if not available lnd_det then do:
                            message "错误: 不允许同时生产这个产品!"   .
                            next-prompt p_bc with frame a.
                            undo, retry.
                      end. 
 *ss - 090601.1 -e*/		 
		      
		      /*根据看板状态, 判断是投产还是追加生产***/
/*mage                xkb_kb_raim_qty = xkb_kb_qty .
                      set xkb_kb_raim_qty with frame a. */
		      if xkb_status = "R" then do:

		         find first  xlns_det where xlns_domain = global_domain and xlns_site = xkb_site 
			    and xlns_line  = pdln and xlns_part = xkb_part  no-error. 
                         if available xlns_det then do: 
		            assign xlns_rel_qty = xlns_rel_qty + xkb_kb_raim
			       xlns_last_bc = p_bc
			       xlns_kb_rel = xlns_kb_rel + 1.
			       xkb_status = "P" .
			       xkb_upt_date = today.
                             assign  
	                                  xlns_date[1]  = s_period_date
	                                  xlns_int[3]     =    s_period.  
/*			    display xkb_kb_raim with frame bx .  */
		         end.
		         else do:
/*ss - 20120204.1 - b*/
         if samplepart <> xkb_part then do:
	    if samplepart = "" then 
	       message "请先刷产品的样品条码，才能允许投产"  view-as alert-box.
	       else message "投产产品同样品不一至，请查原因" view-as alert-box.
	       next-prompt p_bc with frame  a .   
	       undo,retry.
	 end.
/*ss - 20120204.1 - b*/
                               create xlns_det .
		               assign xlns_domain = global_domain
		                    xlns_site   = xkb_site
			         xlns_line   = pdln
			         xlns_part   = xkb_part
			         xlns_rel_qty = xkb_kb_raim 
			         xlns_start_date = start_date
			         xlns_start_time    = start_time 
				 xlns_int[1]        = men_qty 
			         xlns_last_date = today
			         xlns_last_time = time 
			         xlns_status = "生产中" 
			         xlns_last_bc = p_bc
			         xlns_kb_rel = 1.
			         xkb_status = "P".
				 i_prod = i_prod + 1 .
				 xlns_tot_rest = tot_rest.
				 xkb_upt_date = today.
				assign   
				        xlns_bc_date1 = today
					xlns_bc_date2 = today
					xlns_bc_date3 = today.
                                    assign  
	                                  xlns_date[1]  = s_period_date
	                                  xlns_int[3]     =    s_period.  
/*ss - 111210.1 - */	         assign   xlns_xdate[1] = today                       
   		                            xlns_xtime[1] = time .

/*			         display xkb_kb_raim with frame a . */
                                
                     find xlpd_det  where xlpd_domain = global_domain 
                            and xlpd_site = global_domain 
	                    and xlpd_line = pdln
	                   and xlpd_plan_date =  s_period_date
	                  and xlpd_period = s_period 
			  and xlpd_part =  xlns_part

	                  no-error.
	                 if available xlpd_det then  assign xlpd__deci = xlpd__deci + xkb_kb_raim   xlpd_date  = today 
			       xlpd_time = time
/*ss - 100918.1 - B*/
                               xlpd_update = string(today) + string(time, "999999")
			       xlpd_uchar[2] = "xxkbbk04.p"
/*ss - 100918.1 - e*/    
                             . 
	                 else do:   create xlpd_det .
                               assign     xlpd_domain = global_domain 
                               xlpd_site = global_domain 
	                       xlpd_line = pdln
                               xlpd_part =  xlns_part
	                       xlpd_plan_date =  s_period_date
	                       xlpd_period = s_period  
	                       xlpd__deci = xlpd__deci +  xkb_kb_raim 
			       xlpd_date  = today 
			       xlpd_time = time 
/*ss - 100918.1 - B*/
                               xlpd_update = string(today) + string(time, "999999")
			       xlpd_uchar[2] = "xxkbbk04.p"
/*ss - 100918.1 - e*/    
                             . 
/*ss - 101205.1 - b*/
                                     find pt_mstr where pt_domain = global_domain 
					     and  pt_part = xlpd_part no-lock no-error.
                                      find ptp_det  where ptp_det.ptp_domain = global_domain 
					     and  ptp_part = xlpd_part and ptp_site = xlpd_site no-lock no-error.

					  if available ptp_det then do:
					     if ptp_routing > ""
					     then routing = ptp_routing.
					     else routing = ptp_part.
					  end.
					  else
					     routing = if pt_routing > "" then pt_routing else pt_part.

			        	find first ro_det where ro_domain = global_domain 
					 and ro_routing  = routing and ((ro_start <= eff_date or ro_start = ?)
					 and (ro_end   >= eff_date or ro_end   = ?)) no-lock no-error.
				      if available ro_det then do :
                                          xlpd_udec[3]   = ro_run.
			                  xlpd_udec[1] =   ro_setup.
 				      end .
				      else  assign  xlpd_udec[3]  =  0  xlpd_udec[1] = 0.
/*ss - 101205.1 - e*/
			     
	               end.
                                       
                         end. /*else do*/


/*minth 08/05/27 begin ************************************************************************************/  
                         l_stat = "R".
                         xkboriqty = xkb_kb_raim_qty.
			 xkbraimqty = xkb_kb_raim_qty.
                         {xxkbhist.i &type="xkb_type"      &part="xkb_part"      &site="xkb_site"
				     &kb_id="xkb_kb_id"    &effdate=today        &program="'xxkbbk04.p'"
				     &qty="xkb_kb_qty"     &ori_qty="xkboriqty"  &tr_trnbr=0
				     &b_status="l_stat"    &c_status="xkb_status"
				     &rain_qty="xkb_kb_raim_qty"}

/*minth 08/05/27 end ************************************************************************************/  
 /*ss - 090601.1 -b*		 

                         find first lnd_det   no-lock where lnd_domain = global_domain and lnd_line = pdln and  lnd_part = xlns_part and lnd_tool <> "" no-error.
		         if available lnd_det then lndtool = lnd_tool . else lndtool = "".  
 *ss - 090601.1 -b*/		 

		      end.  /*if xkb_status = "R" then do: *******/
		      
		      else  if xkb_status = "P" then do: /*入库回冲*/


                         find first xlns_det where xlns_domain = global_domain and xlns_site = global_domain
			    and xlns_line  = pdln and xlns_part = xkb_part  no-error. 
                         if available xlns_det then do:  /*一出多增加******/


		            if xlns_barcode1 <> "" then do:
			       message "错误: 生产线正在" xlns_status "请先刷读" xlns_barcode1    .
                               next-prompt p_bc with frame a.
                               undo, retry.
		             end.
                             else do:

/*ss - 120112.1 - b*检查相关产品的尾数看板****************/
old_kbrecid = recid(xkb_mstr).

unfill_kb_id0 = no.
unfill_kb_idn = no.
unfill_kbidn  = 0.
unfill_kbid0_qty = 0.
unfill_kbidn_qty = 0.

for each xkb_mstr no-lock where xkb_domain = global_domain and xkb_site = xlns_site 
    and xkb_part = xlns_part  and (xkb_kb_id = 0 and xkb_status = "U" and xkb_kb_raim_qty > 0  
     or xkb_kb_id <> 0 and xkb_status = "P" and xkb_kb_raim_qty > 0) :

     if xkb_kb_id = 0 then assign unfill_kb_id0  = yes  unfill_kbid0_qty =  xkb_kb_raim_qty.
     if xkb_kb_id <> 0 then  assign  unfill_kb_idn = yes
                                     unfill_kbidn   =  xkb_kb_id 
				     unfill_kbidn_qty =  xkb_kb_raim_qty.


end.

find xkb_mstr where recid(xkb_mstr) = old_kbrecid .

if unfill_kb_idn and xkb_kb_id <> unfill_kbidn  then do:
    message "错误: 还有未满包装的看板,请先找这" unfill_kbidn  "看板回报"  .
    next-prompt p_bc with frame a.
    undo, retry.
end.

/*ss - 120112.1 - b*检查相关产品的尾数看板****************/
                              compkb_qty = xkb_kb_raim - xkb_kb_raim_qty .
                                /* do on error undo, retry with frame a: */
			        update compkb_qty label "完成看板数量" with frame a.
				if  compkb_qty = ?  then do:
                                          message "完成数量是? "  	 .			     
                                          next-prompt compkb_qty with frame a .
                                          undo, retry .
				end. 
/*ss - 111207.1 - b****************************/
/*检查是否有尾数或未有完成的看板存在***********/

if not unfill_kb_idn  and unfill_kb_id0  
   and  ((xkb_kb_qty - unfill_kbid0_qty) < compkb_qty)  then do:
    message "错误: 尾数看板有余量" unfill_kbid0_qty  "存在,现只能接收数量小于"  xkb_kb_qty - unfill_kbid0_qty .
    next-prompt compkb_qty with frame a .
    undo, retry.
end.

/*ss - 111207.1 - e****************************/

			        if  compkb_qty > xkb_kb_raim - xkb_kb_raim_qty then do:

/*ss - 111111.1 - b*                           message "完成数量大于看板数量! 是否正确?"  
				    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
                                    TITLE "" UPDATE choice1 As logical. 
 			            if not choice1 or (compkb_qty + xkb_kb_raim_qty ) > xkb_kb_raim  * 1.5 then do:
				       if (compkb_qty + xkb_kb_raim_qty )  > xkb_kb_raim  * 1.5  THEN  message "错误：完成数量大于看板数量 * 1.5 倍，系统不接收! "  .
				       next-prompt compkb_qty with frame a .
                                       undo, retry .
				    end. 
*ss - 111111.1 - e*/
/*ss - 111111.1 - b*/ 
                                 message "完成数量大于看板数量! "  
				    VIEW-AS ALERT-BOX .
                                  next-prompt compkb_qty with frame a .
                                   undo, retry .
/*ss - 111111.1 - e*/

                                end. 
			         /* end. do on error undo, retry with frame a:*/



				  choice  = no.
				  choice2  = no.
                                  choice3  = no.
                                if   xkb_kb_raim >  xkb_kb_raim_qty + compkb_qty then do:
 			            message "没有完成看板下达数量! 是否关闭现在正生产此张看板!"  
				    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
                                    TITLE "" UPDATE choice  .
                                 end.

                         if   choice  then do:
 			         message "完成数量不是整包装数, 是否转移至该零件的尾数看板上!"  
				    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
                                    TITLE "" UPDATE choice2 .
                               end.

                               if   choice and not choice2  then do:
 			           message "由于完成数量不是整包装数, 是否直接把尾数看板上数量转移至这张看板上!"  
				    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
                                    TITLE "" UPDATE choice3 .
                                end. 
 
			      if compkb_qty > 0 then do: 
/*调用18.22.13 进行入库回冲*********************************************************************************/	
 	   
                                   assign
                                        wkctr              = ""
                                        mch                = ""
                                        dept               = ""
                                        um                 = ""
                                        conv               = 1
                                        qty_rjct           = 0
                                        rjct_rsn_code      = ""
                                        rejque_multi_entry = no
                                        to_op              = op
                                        qty_scrap          = 0
                                        scrap_rsn_code     = ""
                                        outque_multi_entry = no
                                        mod_issrc          = no
                                        start_run          = ""
                                        act_run_hrs        = 0
                                        stop_run           = ""
                                        earn_code          = ""
                                        rsn_codes          = ""
                                        quantities         = 0
                                        scrap_rsn_codes    = ""
                                        scrap_quantities   = 0
                                        reject_rsn_codes   = ""
                                        reject_quantities  = 0
                                        act_rsn_codes      = ""
                                        act_hrs            = 0
                                        prod_multi_entry   = no
                                        rsn                = ""
                                        act_run_hrs        = 0
                                        move_next_op       = yes
                                        act_setup_hrs      = 0
                                        setup_rsn          = ""
                                        act_multi_entry    = no
                                        act_setup_hrs20    = 0
                                        down_rsn_code      = ""
                                        stop_multi_entry   = no
                                        non_prod_hrs       = 0 .
					l_stat_undo        = no. 
	                         
 /*ss - 090601.1 -b*		 				    	   	                       
                                     act_run_hrs = ((today - xlns_last_date) * 24 * 3600 + time - xlns_last_time) / 3600
			                         - xlns_last_dn - xlns_last_sp - xlns_last_dt - xlns_last_rest .
                                     if act_run_hrs = ? or  i_prod = 0  then act_run_hrs = 0.  else act_run_hrs = act_run_hrs / i_prod .
 *ss - 090601.1 -b*/		 
/*ss - 090601.1 -b*/
                                          find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part = xlns_part no-lock no-error.
					  find ptp_det  where ptp_det.ptp_domain = global_domain and  ptp_part = xlns_part and ptp_site = site no-lock no-error.

					  if available ptp_det then do:
					     if ptp_routing > ""
					     then routing = ptp_routing.
					     else routing = ptp_part.
					  end.
					  else
					     routing = if pt_routing > "" then pt_routing else pt_part.

			        	find first ro_det where ro_domain = global_domain 
					 and ro_routing  = routing and ((ro_start <= eff_date or ro_start = ?)
					 and (ro_end   >= eff_date or ro_end   = ?)) no-lock no-error.
				      if available ro_det then do :
				          if ro_run = ? then do:
					  message "工艺流程的运行时间为?, 请检查相关数据" view-as alert-box.
					  undo, retry.
					  end.
                                          act_run_hrs =  ro_run * compkb_qty.
 				      end .
				      else   act_run_hrs =  1.

                                     
 /*ss - 090601.1 -b*/
				     site = xlns_site.
				     emp = global_userid.
                                     line = xlns_line.
				     part = xlns_part.
/* ss-090401.1 -b */
				     if ln__chr03 = "" then do :
				         find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part = xlns_part no-lock no-error.

					  find ptp_det  where ptp_det.ptp_domain = global_domain and  ptp_part = xlns_part and ptp_site = site no-lock no-error.

					  if available ptp_det then do:
					     if ptp_routing > ""
					     then routing = ptp_routing.
					     else routing = ptp_part.
					  end.
					  else
					     routing = if pt_routing > "" then pt_routing else pt_part.

			        	find first ro_det where ro_domain = global_domain 
					 and ro_routing  = routing and ((ro_start <= eff_date or ro_start = ?)
					 and (ro_end   >= eff_date or ro_end   = ?)) no-lock no-error.
				          if available ro_det then do :
                                         assign
                                        wkctr              = ro_wkctr
                                        mch                = ro_mch
					std_run            = ro_run.
				      end .
				      end .
				     else do :
				     /* ss-090401.1 -e */
/*09/02/18*/	                    assign
                                        wkctr              = ln__chr03
                                        mch                = ln__chr04
					std_run            = 0.01.
				    /* ss-090401.1 -b */
				    end . /* ln_chr03 <> "" */
				    /* ss-090401.1 -e */

/* ss - 090513.1 - b*/
	for first wc_mstr
         fields( wc_domain wc_dept wc_desc wc_mch wc_wkctr)
          where wc_mstr.wc_domain = global_domain and  wc_wkctr = wkctr
           and wc_mch   = mch
      no-lock:
      end. /* FOR FIRST wc_mstr */
      if not available wc_mstr then do:
         message "工作中心不存在, 请检查相应的生产线设置" view-as alert-box.
	 undo, retry .
      end.

      dept = wc_dept.
      for first dpt_mstr
         fields( dpt_domain dpt_dept dpt_desc)
          where dpt_mstr.dpt_domain = global_domain and  dpt_dept = wc_dept
      no-lock:
      end. /* FOR FIRST dpt_mstr */
      if not available dpt_mstr then do:
         message "部门不存在, 请检查相应的生产线设置" view-as alert-box.
	 undo, retry .
      end.
/* ss - 090513.1 - b*/

 /*ss - 090601.1 -b*/
                   xlns_dec[3] =  xlns_dec[3] + act_run_hrs .
 /*ss - 090601.1 -e*/
	             assign  
	                                  xlns_date[1]  = s_period_date
	                                  xlns_int[3]     =    s_period.       
				  /* mage add 08/04/27 */    {xxtransbcmt21.i}  

				    qty_proc =  compkb_qty .
	                             b_qc = "".
                                     {gprun.i ""xxkbbk04bcmt.p""
                                               "(output upt_loc)"}

                       find xlpd_det  where xlpd_domain = global_domain 
                            and xlpd_site = global_domain 
	                    and xlpd_line = pdln
	                   and xlpd_plan_date =  s_period_date
	                  and xlpd_period = s_period 
			  and xlpd_part =  xlns_part

	                  no-error.
	                 if available xlpd_det then  assign  xlpd_comp_qty = xlpd_comp_qty  + compkb_qty  xlpd_date  = today 
			       xlpd_time = time 
/*ss - 100918.1 - B*/
                               xlpd_update = string(today) + string(time, "999999")
			       xlpd_uchar[2] = "xxkbbk04.p"
/*ss - 100918.1 - e*/    
                             . 
	                 else do:   create xlpd_det .
                               assign     xlpd_domain = global_domain 
                               xlpd_site = global_domain 
	                       xlpd_line = pdln
                               xlpd_part =  xlns_part
	                       xlpd_plan_date =  s_period_date
	                       xlpd_period = s_period  
	                       xlpd_comp_qty = xlpd_comp_qty +  compkb_qty
			         xlpd_date  = today 
			       xlpd_time = time 
/*ss - 100918.1 - B*/
                               xlpd_update = string(today) + string(time, "999999")
			       xlpd_uchar[2] = "xxkbbk04.p"
/*ss - 100918.1 - e*/    
                             .  

/*ss - 101205.1 - b*/
                                     find pt_mstr where pt_domain = global_domain 
					     and  pt_part = xlpd_part no-lock no-error.
                                      find ptp_det  where ptp_det.ptp_domain = global_domain 
					     and  ptp_part = xlpd_part and ptp_site = xlpd_site no-lock no-error.

					  if available ptp_det then do:
					     if ptp_routing > ""
					     then routing = ptp_routing.
					     else routing = ptp_part.
					  end.
					  else
					     routing = if pt_routing > "" then pt_routing else pt_part.

			        	find first ro_det where ro_domain = global_domain 
					 and ro_routing  = routing and ((ro_start <= eff_date or ro_start = ?)
					 and (ro_end   >= eff_date or ro_end   = ?)) no-lock no-error.
				      if available ro_det then do :
                                          xlpd_udec[3]   = ro_run.
			                  xlpd_udec[1] =   ro_setup.
 				      end .
				      else  assign  xlpd_udec[3]  =  0  xlpd_udec[1] = 0.
/*ss - 101205.1 - e*/

	               end.

		       assign  xlpd_prodtime = xlpd_prodtime + act_run_hrs                        /*生产时间良品+不良品*/
                               xlpd_wktime   = xlpd_wktime + act_run_hrs                          /*工作时间 生产时间 准备时间 DN时间 DT时间 */
			       xlpd_sptime   = xlpd_sptime + 0                                    /*准备时间*/
			       xlpd_dntime   = xlpd_dntime + 0                                    /*dn 时间*/
			       xlpd_dttime   = xlpd_dttime + 0                                    /*dt 时间*/
			       xlpd_stdtime  = xlpd_stdtime  + act_run_hrs                        /*良品标准时间*/
			       xlpd_udec[1]  = xlpd_udec[1] +  0                                  /*不良品标准时间*/
			       xlpd_udec[2]  =  xlpd_udec[2] + 0 .                                /*标准准备时间*/

			   end.  /*if compkb_qty > 0 */

	                   	                   
/*调用18.22.13 进行入库回冲*********************************************************************************/




/*ss - 090727.1 - b*/


			   if l_stat_undo and compkb_qty > 0  or compkb_qty = 0 and choice then do:
                               xkb_mstr.xkb_loc = upt_loc.

			      /*  xlns_tot_prod = xlns_tot_prod + max(((today - xlns_last_date) * 24 * 3600 + time - xlns_last_time) / 3600
			                   - xlns_last_dn - xlns_last_sp - xlns_last_dt - xlns_last_rest, 0) . */

                                xlns_comp_qty = xlns_comp_qty + compkb_qty .

			        assign xlns_last_date = today
			           xlns_last_time = time
			           xlns_last_dn = 0
			           xlns_last_sp = 0
			           xlns_last_dt = 0
			           xlns_last_rest = 0
			           xlns_last_bc = p_bc.
			      
/*ss - 111210.1 - */	         assign   xlns_xdate[2] = today                       
   		                            xlns_xtime[2] = time .
			      	      
			      
   			       xkb_kb_raim_qty = xkb_kb_raim_qty + compkb_qty .
/*ss - 120110.1 - b***********************/
     def var rflot1 as integer.
     def var ssbc1 as char format "x(24)" .
      ssbc1 = "".
     find first rfpt_mstr  where rfpt_domain = global_domain
                                and rfpt_part = xlns_part
				and rfpt_isbar  no-lock no-error.

     if available rfpt_mstr and compkb_qty > 0 then do:
     /* ss - 120720.1 -b
     find last rflot_hist where   rflot_domain   = global_domain
                                 and rflot_part    = xlns_part
				 and rflot_site   = global_domain
				 and rflot_prod_date >= today
				 and length(rflot_box_seq) >=  17  use-index rflot_box_seq 
                                    no-lock no-error.
   ss - 120720.1 -e */
   /* ss - 120720.1 -b */
     find last rflot_hist where   rflot_domain   = global_domain
                                 and rflot_part    = xlns_part
				 and rflot_site   = global_domain
				 and rflot_box_type    =    rfpt_shp_box       
				 and rflot_prod_date >= today
				 and length(rflot_box_seq) >=  17  use-index rflot_box_seq 
                                    no-lock no-error.
   
   /* ss - 120720.1 -e */
    if not available rflot_hist or rflot_prod_date < today then rflot1 = 1.
 else if  substring( rflot_hist.rflot_box_seq, length( rflot_hist.rflot_box_seq) , 1) <>  "R" 
				  then   rflot1 = integer(substring( rflot_hist.rflot_box_seq, length( rflot_hist.rflot_box_seq) - 3, 4)) +  1 .
				  else   rflot1 = integer(substring( rflot_hist.rflot_box_seq, length( rflot_hist.rflot_box_seq) - 4, 4)) +  1 .
				/* message  rflot_box_seq view-as alert-box. */
    ssbc1 = string(today, "999999") +  rfpt_shp_box  + string(rflot1, "9999") .
 /*  message "ssbc1"  ssbc1 view-as alert-box. */
    create rflot_hist.

    rflot_seq = next-value(s_fglbl_seq).

    assign  rflot_domain      = global_domain
            rflot_part        = xlns_part      
            rflot_part_desc   =  ""      
            rflot_wkctr       =         ""      
            rflot_shift       =          ""      
            rflot_lot         =      string(today, "999999")      
 /*         rflot_box_qty     =        xkb_kb_qty    
            rflot_mult_qty    =        xkb_kb_qty  */
            rflot_scatter_qty =        0    
            rflot_status      =         ""      
            rflot_printed     =         no      
            rflot_prod_date   =         today      
            rflot_crt_date    =         today      
            rflot_crt_time    =         time     
            rflot_prod_dt     =         ""      
            rflot_part_group  =         ""      .

 assign     rflot_site        =         global_domain         
            rflot_prod_time   =         ""      
            rflot_num_lbl     =         rflot1      
            rflot_part_rev    =         ""      
            rflot_crt_userid  =         ""      
            rflot_um          =         ""      
            rflot_cust        =         ""      
            rflot_box_seq     =         ssbc1     
            rflot_box_type    =        rfpt_shp_box       
            rflot_line        =        pdln       
            rflot_mach        =         ""     
            rflot_worker      =          ""      
            rflot_cust_part   =         ""      
            rflot_exp_date    =         today      
            rflot_part_desc1  =         ""      
            rflot_part_desc2  =         ""      
            rflot_type        =         ""      
            rflot_output      =         no      
            rflot_trnbr       =         0      
            rflot_direction   =         ""   .  
 end.  /* if available rfpt_mstr then do: */

/*ss - 120110.1 - e***********************/

		               if  choice  or xkb_kb_raim <= xkb_kb_raim_qty then do:
				    /*产生看板历史记录, 如果看板余量为零, 则看板状态变为A*/
                                      xlns_kb_comp = xlns_kb_comp + 1 .
				      l_stat = "P".
				      xkboriqty = xkb_kb_raim_qty .
				      if xkb_kb_raim_qty > 0 then xkb_status = "U".
					                        else assign xkb_status = "A"
								xkb_kb_raim_qty = 0.
                                             xkb_upt_date = today .
                                         {xxkbhist.i &type="xkb_type"      &part="xkb_part"      &site="xkb_site"
				                    &kb_id="xkb_kb_id"    &effdate=today        &program="'xxkbbk04.p'"
				                    &qty="xkb_kb_qty"     &ori_qty="xkb_kb_qty" &tr_trnbr=0
					            &b_status="l_stat"    &c_status="xkb_status"
					            &rain_qty="xkb_kb_raim_qty"}
	                   
/*09/02/18*/    				 if xkb_fldusr[5] <> "" then xkb_prod_line = xkb_fldusr[5] .

/*ss - 120110.1 - b***********************/

       if available rfpt_mstr and compkb_qty > 0 then do:
             if  xkb_kb_raim_qty >  compkb_qty then  do:
                 find first rflotd_det where  rflotd_domain     = global_domain
		   and rflotd_mstr_id  = ssbc1      
                   and rflotd_comp_id  = xkb_kb_lock no-lock no-error.

		   if not available  rflotd_det then do:
	         create rflotd_det .
		 assign 
                 rflotd_domain     = global_domain
		 rflotd_mstr_id  = ssbc1      
                 rflotd_comp_id  = xkb_kb_lock       
                 rflotd_crt_date = today        
                 rflotd_crt_time = time     
                 rflotd_dt       = ""      
                 rflotd_comp_part = xkb_part     
                 rflotd_comp_qty  = xkb_kb_raim_qty - compkb_qty         
                 rflotd_crt_userid = global_userid  .     
                end.
		else assign 
                 rflotd_crt_date = today        
                 rflotd_crt_time = time     
                 rflotd_dt       = ""      
                 rflotd_comp_part = xkb_part     
                 rflotd_comp_qty  = xkb_kb_raim_qty - compkb_qty         
                 rflotd_crt_userid = global_userid  .    

             end. /*if  xkb_kb_raim_qty >  compkb_qty then  do: */
             if xkb_kb_raim_qty > 0 then   xkb_kb_lock = ssbc1 .
       end.
/*ss - 120110.1 - e***********************/
  					 /********** lotserial ************/
					 find first pt_mstr where pt_domain = global_domain 
					      and pt_part = xkb_part no-lock no-error.
					
					 if available pt_mstr then do:
                                            if index("LS",pt_lot_ser) > 0 then do:
                                              lotserial = "".
                                              for last tr_hist no-lock
                                                 where tr_domain = global_domain
                                                   and tr_effdate = today
                                                   and tr_part = xkb_part
                                                break by tr_serial:
	   	                              lotserial = tr_serial.
                                              end.
                                              if lotserial > "" and length(lotserial) = 10 then
                                                 lotserial = string(integer(substring(lotserial, 9,2)) + 1, "99").
                                              else lotserial = "01".
                                  
				              lotserial = string(year(today), "9999") + string(month(today), "99") 
                                                        + string(day(today),"99") + lotserial.
                                              xkb_lot = lotserial.
					   end.
					 end.
                                /********** lotserial ************/
                                     /*如果看板完成数量不是整包装数量, 看板库存数量转移尾数看板, 但不产生库存交易记录**/
	                             if choice and choice2 and xkb_kb_raim_qty > 0 then do:
				         assign xkbsite = xkb_site
					        xkbpart = xkb_part
						xkbtype = xkb_type
						xkbloc  = xkb_loc
						xkbkbid   = xkb_kb_id 
						xkbraimqty = xkb_kb_raim_qty .
/*ss - 120110.1 - b***********************/

       if available rfpt_mstr and compkb_qty > 0 then do:
             if  xkb_kb_raim_qty >  compkb_qty then  do:
	       find first rflotd_det where  rflotd_domain     = global_domain
		   and rflotd_mstr_id  = ssbc1      
                   and rflotd_comp_id  = xkb_kb_lock no-lock no-error.

		   if not available  rflotd_det then do:
	         create rflotd_det .
		 assign 
                 rflotd_domain     = global_domain
		 rflotd_mstr_id  = ssbc1      
                 rflotd_comp_id  = xkb_kb_lock       
                 rflotd_crt_date = today        
                 rflotd_crt_time = time     
                 rflotd_dt       = ""      
                 rflotd_comp_part = xkb_part     
                 rflotd_comp_qty  = xkb_kb_raim_qty - compkb_qty         
                 rflotd_crt_userid = global_userid  .     
                end.
		else assign 
                 rflotd_crt_date = today        
                 rflotd_crt_time = time     
                 rflotd_dt       = ""      
                 rflotd_comp_part = xkb_part     
                 rflotd_comp_qty  = xkb_kb_raim_qty - compkb_qty         
                 rflotd_crt_userid = global_userid  .    

             end. /*if  xkb_kb_raim_qty >  compkb_qty then  do: */
             if xkb_kb_raim_qty > 0 then   xkb_kb_lock = ssbc1 .
       end.

       def var x_kbqty000 as decimal .
       x_kbqty000 = 0.
/*ss - 120110.1 - e***********************/ 

                                        find first xkb_mstr where xkb_domain = global_domain and
					      xkb_site = xkbsite    and
					      xkb_part = xkbpart   and  xkb_type = xkbtype   and  (xkb_kb_id = 000 or xkb_kb_id = 999) no-error.
					    if not available xkb_mstr then do:
					       Message "这个零件的制造尾数看板不存在!! 数据无法接收到相关尾数看板上"  view-as alert-box.
					    end.
					    else if xkb_loc <>  upt_loc  and xkb_loc <> ""  then do:
					       Message "这个零件的制造尾数看板没有转到现场仓!! 数据无法接收到相关尾数看板上"  view-as alert-box.
					       end.
					       else if xkbraimqty + xkb_kb_raim_qty >= xkb_kb_qty then do:
					          Message "尾数看板数量加上此份看板完成数量大于看板容量, 数据无法接收到相关尾数看板上"  view-as alert-box.
					       end.
					       ELSE DO:
/*ss - 120112.1 - b*/                          x_kbqty000 = xkb_kb_raim_qty .					       					       
                                               l_stat = xkb_status.
                                               xkb_status  = "U".
					       xkb_upt_date = today .
                                               xkboriqty = xkb_kb_raim_qty.
					       xkb_kb_raim_qty = xkb_kb_raim_qty + xkbraimqty.

/*ss - 120110.1 - b***********************/
       if available rfpt_mstr and compkb_qty > 0 then do:
             if  xkb_kb_raim_qty >   xkbraimqty then  do:
                 find first rflotd_det where  rflotd_domain     = global_domain
		   and rflotd_mstr_id  = ssbc1      
                   and rflotd_comp_id  = xkb_kb_lock no-lock no-error.

		if not available  rflotd_det then do:
	         create rflotd_det .
		 assign 
                 rflotd_domain     = global_domain
		 rflotd_mstr_id  = ssbc1      
                 rflotd_comp_id  = xkb_kb_lock       
                 rflotd_crt_date = today        
                 rflotd_crt_time = time     
                 rflotd_dt       = ""      
                 rflotd_comp_part = xkb_part     
                 rflotd_comp_qty  = xkb_kb_raim_qty - xkbraimqty         
                 rflotd_crt_userid = global_userid  .     
                end.
		else assign 
                 rflotd_crt_date = today        
                 rflotd_crt_time = time     
                 rflotd_dt       = ""      
                 rflotd_comp_part = xkb_part     
                 rflotd_comp_qty  = xkb_kb_raim_qty - xkbraimqty         
                 rflotd_crt_userid = global_userid  .    

             end. /*if  xkb_kb_raim_qty >  compkb_qty then  do: */
             if xkb_kb_raim_qty > 0 then   xkb_kb_lock = ssbc1 .
       end.
/*ss - 120110.1 - e***********************/    
                                               if  xkb_loc = "" then xkb_loc = upt_loc .
					       {xxkbhist.i &type="xkb_type"      &part="xkb_part"      &site="xkb_site"
				                    &kb_id="xkb_kb_id"    &effdate=today        &program="'xxkbbk04.p'"
				                    &qty="xkb_kb_qty"     &ori_qty="xkboriqty"  &tr_trnbr=0
					            &b_status="l_stat"    &c_status="xkb_status"
					            &rain_qty="xkb_kb_raim_qty"}
/*09/02/18*/    				 if xkb_fldusr[5] <> "" then xkb_prod_line = xkb_fldusr[5] .

					      xkb_upt_date = today.
                                              find first xkb_mstr where xkb_domain = global_domain and					      
					      xkb_site = xkbsite  and
					      xkb_part = xkbpart    and  xkb_type = xkbtype    and  (xkb_kb_id = xkbkbid ) no-error.
					      
					      if available xkb_mstr then do:
                                                 l_stat = xkb_status.
                                                 xkb_status  = "A".
                                                 xkboriqty = xkb_kb_raim_qty.
					         xkb_kb_raim_qty = 0.
						 xkb_upt_date = today .
                                                {xxkbhist.i &type="xkb_type"      &part="xkb_part"      &site="xkb_site"
				                    &kb_id="xkb_kb_id"    &effdate=today        &program="'xxkbbk04.p'"
				                    &qty="xkb_kb_qty"     &ori_qty="xkboriqty"  &tr_trnbr=0
					            &b_status="l_stat"    &c_status="xkb_status"
					            &rain_qty="xkb_kb_raim_qty"}
/*09/02/18*/    				 if xkb_fldusr[5] <> "" then xkb_prod_line = xkb_fldusr[5] .

					      end.

 					  END.
				     end. /*if choice and choice2 ****/

                                     /*如果看板完成数量不是整包装数量, 看板库存数量转移尾数看板, 但不产生库存交易记录**/

                                     /*如果看板完成数量不是整包装数量, 尾数看板数量转移整数看板库存, 但不产生库存交易记录**/
	                             if choice and not choice2 and choice3 then do:
                                         assign xkbsite = xkb_site
					        xkbpart = xkb_part
						xkbtype = xkb_type
						xkbloc  = xkb_loc
						xkbkbid   = xkb_kb_id 
                                                xkbraimqty = xkb_kb_raim_qty .
 /*ss - 120110.1 - b***********************/

       if available rfpt_mstr and compkb_qty > 0 then do:
             if  xkb_kb_raim_qty >  compkb_qty then  do:
                 find first rflotd_det where  rflotd_domain     = global_domain
		   and rflotd_mstr_id  = ssbc1      
                   and rflotd_comp_id  = xkb_kb_lock no-lock no-error.

		   if not available  rflotd_det then do:
	         create rflotd_det .
		 assign 
                 rflotd_domain     = global_domain
		 rflotd_mstr_id  = ssbc1      
                 rflotd_comp_id  = xkb_kb_lock       
                 rflotd_crt_date = today        
                 rflotd_crt_time = time     
                 rflotd_dt       = ""      
                 rflotd_comp_part = xkb_part     
                 rflotd_comp_qty  = xkb_kb_raim_qty - compkb_qty         
                 rflotd_crt_userid = global_userid  .     
                end.
		else assign 
                 rflotd_domain     = global_domain  
                 rflotd_crt_date = today        
                 rflotd_crt_time = time     
                 rflotd_dt       = ""      
                 rflotd_comp_part = xkb_part     
                 rflotd_comp_qty  = xkb_kb_raim_qty - compkb_qty         
                 rflotd_crt_userid = global_userid  .     

             end. /*if  xkb_kb_raim_qty >  compkb_qty then  do: */
             if xkb_kb_raim_qty > 0 then   xkb_kb_lock = ssbc1 .
       end.
/*ss - 120110.1 - e***********************/                                          
					find first xkb_mstr where xkb_domain = global_domain and
					      xkb_site = xkbsite    and 
					      xkb_part = xkbpart    and  xkb_type = xkbtype  and (xkb_kb_id = 000 or xkb_kb_id = 999) no-error.
					
					    if not available xkb_mstr then do:
					       Message "这个零件的制造尾数看板不存在! 尾数看板数量没有转移到整数看板上!"  view-as alert-box.
					    end.
                                            else if xkb_loc <>  upt_loc  and xkb_loc <> ""    then do:
					       Message "这个零件的制造尾数看板没有转到现场仓!! 尾数看板数量没有转移到整数看板上!"  view-as alert-box.
					    end.
					    else if xkbraimqty + xkb_kb_raim_qty < xkb_kb_qty then do:
					          Message "尾数看板数量加上此份看板完成数量小于看板容量, 数据无法接收到相关整数看板上"  view-as alert-box.
                                            end.
					    ELSE DO:
/*ss - 120110.1 - b***********************/

       if available rfpt_mstr and compkb_qty > 0 then do:
             if   xkb_kb_raim_qty  > 0 and  xkbraimqty < xkb_kb_qty then  do:
                 find first rflotd_det where  rflotd_domain     = global_domain
		   and rflotd_mstr_id  = ssbc1      
                   and rflotd_comp_id  = xkb_kb_lock no-lock no-error.

		   if not available  rflotd_det then do:
	         create rflotd_det .
		 assign 
                 rflotd_domain     = global_domain
		 rflotd_mstr_id  = ssbc1      
                 rflotd_comp_id  = xkb_kb_lock       
                 rflotd_crt_date = today        
                 rflotd_crt_time = time     
                 rflotd_dt       = ""      
                 rflotd_comp_part = xkb_part     
                 rflotd_comp_qty  =  min(xkb_kb_raim_qty , xkb_kb_qty - xkbraimqty)        
                 rflotd_crt_userid = global_userid  .     
                end.
		else assign 
                 rflotd_domain     = global_domain  
                 rflotd_crt_date = today        
                 rflotd_crt_time = time     
                 rflotd_dt       = ""      
                 rflotd_comp_part = xkb_part     
                 rflotd_comp_qty  =  min(xkb_kb_raim_qty , xkb_kb_qty - xkbraimqty)        
                 rflotd_crt_userid = global_userid  .     

             end. /*if  xkb_kb_raim_qty >  compkb_qty then  do: */
   
       end. /* if available rfpt_mstr and compkb_qty > 0 then do:*/
/*ss - 120110.1 - e***********************/ 

					       l_stat = xkb_status.
                                               xkb_status  = "U".
					       xkb_upt_date = today .
                                               xkboriqty = xkb_kb_raim_qty.
 					       xkb_kb_raim_qty = xkb_kb_raim_qty + xkbraimqty - xkb_kb_qty.
					       if  xkb_loc = "" then xkb_loc = upt_loc .

                                               {xxkbhist.i &type="xkb_type"      &part="xkb_part"      &site="xkb_site"
				                    &kb_id="xkb_kb_id"    &effdate=today        &program="'xxkbbk04.p'"
				                    &qty="xkb_kb_qty"     &ori_qty="xkboriqty"  &tr_trnbr=0
					            &b_status="l_stat"    &c_status="xkb_status"
					            &rain_qty="xkb_kb_raim_qty"}
/*09/02/18*/    				 if xkb_fldusr[5] <> "" then xkb_prod_line = xkb_fldusr[5] .
					      xkb_upt_date = today.
                                              find first xkb_mstr where xkb_domain = global_domain and
					      xkb_site = xkbsite   and
					      xkb_part = xkbpart    and  xkb_type = xkbtype   and  (xkb_kb_id = xkbkbid ) no-error.
					    
					      if available xkb_mstr then do:
                                                 l_stat = xkb_status.
                                                 xkb_status  = "U".
                                                 xkboriqty = xkb_kb_raim_qty .
					         xkb_kb_raim_qty = xkb_kb_qty.
                                                {xxkbhist.i &type="xkb_type"      &part="xkb_part"      &site="xkb_site"
				                    &kb_id="xkb_kb_id"    &effdate=today        &program="'xxkbbk04.p'"
				                    &qty="xkb_kb_qty"     &ori_qty="xkboriqty"  &tr_trnbr=0
					            &b_status="l_stat"    &c_status="xkb_status"
					            &rain_qty="xkb_kb_raim_qty"}
                                                 xkb_upt_date = today.
/*09/02/18*/    				 if xkb_fldusr[5] <> "" then xkb_prod_line = xkb_fldusr[5] .
/*12/01/12*/                                                 if xkb_kb_raim_qty > 0 then   xkb_kb_lock = ssbc1 .

					      end.

 					  END.
				     end. /*if choice and choice2 ****/


/*ss - 090727 - e*/


/*ss - 090727 - b*



			   if l_stat_undo and compkb_qty > 0  or compkb_qty = 0 and choice then do:
            
				xkb_loc = upt_loc.

			 
			        xlns_tot_prod = xlns_tot_prod + ((today - xlns_last_date) * 24 * 3600 + time - xlns_last_time) / 3600
			                   - xlns_last_dn - xlns_last_sp - xlns_last_dt - xlns_last_rest .
                                xlns_comp_qty = xlns_comp_qty + compkb_qty .

			        assign xlns_last_date = today
			           xlns_last_time = time
			           xlns_last_dn = 0
			           xlns_last_sp = 0
			           xlns_last_dt = 0
			           xlns_last_rest = 0
			           xlns_last_bc = p_bc.
			      
   			      xkb_kb_raim_qty = xkb_kb_raim_qty + compkb_qty .

		               if  choice  or xkb_kb_raim <= xkb_kb_raim_qty then do:
				    /*产生看板历史记录, 如果看板余量为零, 则看板状态变为A*/
                                      xlns_kb_comp = xlns_kb_comp + 1 .
				      l_stat = "P".
				      xkboriqty = xkb_kb_raim_qty .
				      if xkb_kb_raim_qty > 0 then xkb_status = "U".
					                        else assign xkb_status = "A"
								xkb_kb_raim_qty = 0.
                                         {xxkbhist.i &type="xkb_type"      &part="xkb_part"      &site="xkb_site"
				                    &kb_id="xkb_kb_id"    &effdate=today        &program="'xxkbbk04.p'"
				                    &qty="xkb_kb_qty"     &ori_qty="xkb_kb_qty" &tr_trnbr=0
					            &b_status="l_stat"    &c_status="xkb_status"
					            &rain_qty="xkb_kb_raim_qty"}
	                   
					 
/*09/02/18*/    				 if xkb_fldusr[5] <> "" then xkb_prod_line .
					 xkb_upt_date = today.
					 /********** lotserial ************/
					 find first pt_mstr where pt_domain = global_domain 
					      and pt_part = xkb_part no-lock no-error.
					
					 if available pt_mstr then do:
                                            if index("LS",pt_lot_ser) > 0 then do:
                                              lotserial = "".
                                              for last tr_hist no-lock
                                                 where tr_domain = global_domain
                                                   and tr_effdate = today
                                                   and tr_part = xkb_part
                                                break by tr_serial:
	   	                              lotserial = tr_serial.
                                              end.
                                              if lotserial > "" and length(lotserial) = 10 then
                                                 lotserial = string(integer(substring(lotserial, 9,2)) + 1, "99").
                                              else lotserial = "01".
                                  
				              lotserial = string(year(today), "9999") + string(month(today), "99") 
                                                        + string(day(today),"99") + lotserial.
                                              xkb_lot = lotserial.
					   end.
					 end.
                                /********** lotserial ************/

                                     /*如果看板完成数量不是整包装数量, 看板库存数量转移尾数看板, 但不产生库存交易记录**/
	                             if choice and choice2 and xkb_kb_raim_qty > 0 then do:
				         assign xkbsite = xkb_site
					        xkbpart = xkb_part
						xkbtype = xkb_type
						xkbloc  = xkb_loc
						xkbkbid   = xkb_kb_id 
                                                xkbraimqty = xkb_kb_raim_qty .
                                        find first xkb_mstr where xkb_domain = global_domain and
					      xkb_site = xkbsite  and
					      xkb_part = xkbpart    and  xkb_type = xkbtype    and  (xkb_kb_id = 000 or xkb_kb_id = 999) no-error.
					    if not available xkb_mstr then do:
					       Message "这个零件的制造尾数看板不存在!! 数据无法接收到相关尾数看板上"  view-as alert-box.
					    end.
					    else if xkb_loc <>  upt_loc   and xkb_loc <> ""  then do:
					       Message "这个零件的制造尾数看板没有转到现场仓!! 数据无法接收到相关尾数看板上"  view-as alert-box.
					    end.
					    if xkbraimqty + xkb_kb_raim_qty >= xkb_kb_qty then do:
					          Message "尾数看板数量加上此份看板完成数量大于看板容量, 数据无法接收到相关尾数看板上"  view-as alert-box.
					     end.
                                             ELSE DO:
                                               l_stat = xkb_status.
                                               xkb_status  = "U".
                                               xkboriqty = xkb_kb_raim_qty.
					       xkb_kb_raim_qty = xkb_kb_raim_qty + xkbraimqty.
                                                 if  xkb_loc = "" then xkb_loc = upt_loc .
                                       
					       {xxkbhist.i &type="xkb_type"      &part="xkb_part"      &site="xkb_site"
				                    &kb_id="xkb_kb_id"    &effdate=today        &program="'xxkbbk04.p'"
				                    &qty="xkb_kb_qty"     &ori_qty="xkboriqty"  &tr_trnbr=0
					            &b_status="l_stat"    &c_status="xkb_status"
					            &rain_qty="xkb_kb_raim_qty"}
	                   
/*09/02/18*/    				 if xkb_fldusr[5] <> "" then xkb_prod_line = xkb_fldusr[5] .
					      xkb_upt_date = today.
                                              find first xkb_mstr where xkb_domain = global_domain and					      
					      xkb_site = xkbsite  and
					      xkb_part = xkbpart   and  xkb_type = xkbtype     and  (xkb_kb_id = xkbkbid ) no-error.
					      
					      if available xkb_mstr then do:
                                                 l_stat = xkb_status.
                                                 xkb_status  = "A".
                                                 xkboriqty = xkb_kb_raim_qty.
					         xkb_kb_raim_qty = 0.
                                                {xxkbhist.i &type="xkb_type"      &part="xkb_part"      &site="xkb_site"
				                    &kb_id="xkb_kb_id"    &effdate=today        &program="'xxkbbk04.p'"
				                    &qty="xkb_kb_qty"     &ori_qty="xkboriqty"  &tr_trnbr=0
					            &b_status="l_stat"    &c_status="xkb_status"
					            &rain_qty="xkb_kb_raim_qty"}
                                                 xkb_upt_date = today.
/*09/02/18*/    				 if xkb_fldusr[5] <> "" then xkb_prod_line = xkb_fldusr[5] .
					      end.

 					  END.
				     end. /*if choice and choice2 ****/

                                     /*如果看板完成数量不是整包装数量, 看板库存数量转移尾数看板, 但不产生库存交易记录**/

                                     /*如果看板完成数量不是整包装数量, 尾数看板数量转移整数看板库存, 但不产生库存交易记录**/
	                             if choice and not choice2 and choice3 then do:
                                         assign xkbsite = xkb_site
					        xkbpart = xkb_part
						xkbtype = xkb_type
						xkbloc  = xkb_loc
						xkbkbid   = xkb_kb_id 
                                                xkbraimqty = xkb_kb_raim_qty .
                                     
					find first xkb_mstr where xkb_domain = global_domain and
					      xkb_site = xkbsite and
					      xkb_part = xkbpart     and  xkb_type = xkbtype    and  (xkb_kb_id = 000 or xkb_kb_id = 999) no-error.
					
					    if not available xkb_mstr then do:
					       Message "这个零件的制造尾数看板不存在! 尾数看板数量没有转移到整数看板上!"  view-as alert-box.
					    end.
					    else if xkb_loc <>  upt_loc  and xkb_loc <> ""   then do:
					       Message "这个零件的制造尾数看板没有转到现场仓!! 尾数看板数量没有转移到整数看板上!"  view-as alert-box.
					    end.
					    else if xkbraimqty + xkb_kb_raim_qty < xkb_kb_qty then do:
					          Message "尾数看板数量加上此份看板完成数量小于看板容量, 数据无法接收到相关整数看板上"  view-as alert-box.
                                            end.
                                            ELSE DO:
                                               l_stat = xkb_status.
                                               xkb_status  = "U".
                                               xkboriqty = xkb_kb_raim_qty.
  					       xkb_kb_raim_qty = xkb_kb_raim_qty + xkbraimqty - xkb_kb_qty.
					       if  xkb_loc = "" then xkb_loc = upt_loc .
                                               {xxkbhist.i &type="xkb_type"      &part="xkb_part"      &site="xkb_site"
				                    &kb_id="xkb_kb_id"    &effdate=today        &program="'xxkbbk04.p'"
				                    &qty="xkb_kb_qty"     &ori_qty="xkboriqty"  &tr_trnbr=0
					            &b_status="l_stat"    &c_status="xkb_status"
					            &rain_qty="xkb_kb_raim_qty"}
/*09/02/18*/    				 if xkb_fldusr[5] <> "" then xkb_prod_line = xkb_fldusr[5] .
					      xkb_upt_date = today.
                                              find first xkb_mstr where xkb_domain = global_domain and
					      xkb_site = xkbsite   and xkb_part = xkbpart    and  xkb_type = xkbtype   
					      and  (xkb_kb_id = xkbkbid ) no-error.
					    
					      if available xkb_mstr then do:
                                                 l_stat = xkb_status.
                                                 xkb_status  = "U".
                                                 xkboriqty = xkb_kb_raim_qty .
					         xkb_kb_raim_qty = xkb_qty .
                                                {xxkbhist.i &type="xkb_type"      &part="xkb_part"      &site="xkb_site"
				                    &kb_id="xkb_kb_id"    &effdate=today        &program="'xxkbbk04.p'"
				                    &qty="xkb_kb_qty"     &ori_qty="xkboriqty"  &tr_trnbr=0
					            &b_status="l_stat"    &c_status="xkb_status"
					            &rain_qty="xkb_kb_raim_qty"}
                                                 xkb_upt_date = today.
/*09/02/18*/    				 if xkb_fldusr[5] <> "" then xkb_prod_line = xkb_fldusr[5] .

					      end.

 					  END.
				     end. /*if choice and choice2 ****/

                                     /*如果看板完成数量不是整包装数量, 尾数看板数量转移整数看板库存, 但不产生库存交易记录**/
 *ss - 090727 - e*/
                               
				/*发送信息********************************************* 
 
				rcp_user = global_domain + "rcp".
				rcp_file = "/home/" + rcp_user + "/" + rcp_user  + "msg1.txt" .
				
				output to  value(rcp_file).
				
				put unformatted  "                   最新生产线需要入库表       " skip .
				put unformatted  " 生产线                  零件                   生产线库存数量   " skip .
				
				for each wc_mstr no-lock where wc_domain = global_domain  ,
				    each ld_det no-lock where ld_domain = global_domain and ld_site = xlns_site 
				     and ld_loc = wc_wkctr and ld_qty_oh >= 1 ,
				    each xmpt_mstr no-lock where xmpt_domain = global_domain 
				     and xmpt_part = ld_part and ld_qty_oh >= xmpt_kb_fqty ,
				    each pt_mstr no-lock where pt_domain = global_domain 
				     and pt_part = xmpt_part :

				    find first ptp_det no-lock where ptp_domain = global_domain 
				       and ptp_part = xmpt_part no-error .  
 
				    if available ptp_det and ptp_ms  or not available ptp_det and pt_ms  then 
				       put unformatted  wc_desc "   "   pt_desc1   pt_desc2   "           "  ld_qty_oh   skip.

				end. /*for each **/
		                output close. 
				unix silent value ("write "  + trim(rcp_user) + " < "  + trim(rcp_file)).
  发送信息***********************************************/
                              end. /*if if  choice  or xkb_kb_raim <= xkb_kb_raim_qty then do: */ 
/*ss lambert - 20111105.1 - b* 条码打印*******************/
  /* xkb_kb_qty(默认容量) compkb_qty xlns_part pt_desc1 pt_desc2 trim(substring(ln_desc,31)) */


/*ss - 111207.1 - b***********************/

     if available rfpt_mstr and compkb_qty > 0  then do:

/*ss - 111207.1 - b***********************		 
   if  choice and choice2 then 
     xxbcprnparm = "01@" +  lineprinter + "@" + pt_desc1 + "@" + 
                         pt_desc2 + "@" + xlns_part + "@" + "3" + "@" + xxbcdatastr + "@" + string(xkb_kb_qty) + "@" + 
			 STRING(TODAY, "9999-99-99").
    else 
     xxbcprnparm = "01@" +  lineprinter + "@" + pt_desc1 + "@" + 
                         pt_desc2 + "@" + xlns_part + "@" + "3" + "@" + xxbcdatastr + "@" + string(xkb_kb_qty) + "@" + 
			 STRING(TODAY, "9999-99-99").

 

    {gprun.i ""xxbcprnall.p"" "(
        INPUT xxbcprnparm )"}
*ss - 111207.1 - b***********************/		 

/*ss - 111207.1 - e***********************/

  if xkb_kb_qty <> compkb_qty  /*and ( not unfill_kb_id0 or not unfill_kb_idn )*/
    then do:
    {gprun.i ""xxbccreatex.p"" "(
        INPUT xlns_part,
	input ssbc1,
	output xxbcdatastr,
	output xxthtype,
	output xxthdesc1,
	output xxthdesc2 )"}

    find first xbc1_mstr  where xbc1_domain = global_domain and xbc1_bc = xxbcdatastr no-error.
    if not available xbc1_mstr then do:
       message "无法产生相应的条码"  view-as alert-box.
       next-prompt p_bc with frame a.
       undo, retry.
    end.
/* xbc1_kb_raim = xkb_kb_raim_qty.*/
    xbc1_kb_qty = xkb_kb_qty.
    xbc1_site  =   global_domain.
    xbc1_loc   =   upt_loc .
    xbc1_crt_date = today .
    xbc1_status = "W".
 /*   xbc1_type = "R".*/
    xbc1_print = yes.
    xbc1_fldusr[1] = productioner .

    assign  
             rflot_scatter_qty =      xkb_kb_raim_qty
                .
    /*
    xbc1_nbr  =   thnbr 
    xbc1_line  =   thline 
    xbc1_lot    =  thlot 
    xbc1_ref    =  thref 
    xbc1_shp_nbr = threc
    */



/*ss - 120107 - b***************************
     if  choice and choice2 then 
        xxbcprnparm = "01@" +  lineprinter + "@" + xxthdesc1 + "@" + 
                         xxthdesc2 + "@" + xlns_part + "@" + xxthtype + "@" + xxbcdatastr + "@" + string(x_kbqty000  + xkbraimqty) + "@" + 
			 STRING(TODAY, "9999-99-99").
    
     else 
      xxbcprnparm = "01@" +  lineprinter + "@" + xxthdesc1 + "@" + 
                         xxthdesc2 + "@" + xlns_part + "@" + xxthtype + "@" + xxbcdatastr + "@" + string(xkb_kb_raim_qty) + "@" + 
			 STRING(TODAY, "9999-99-99").

*ss - 120107 - e***************************/
/*
   使用@符号进行分割par1@par2@par3@par4@par5@par6@par7@.........
   par1是标签类型代码，决定调用的标签程序名,在xxbcprnall中使用
   
   在本程序中
   par2是打印机队列名
   par3   公司名
   par4   desc1
   par5   desc2
   par6   pt_part
   par7   lotserial
   par8   完工数
   par9   日期
   par10  生产者
   par11  H3 方位信息
   以上都是打印标签的变量字段，
   注意：在本程序中调用了额外的程序进行汉字处理
*/
/*ss - 120107 - b***************************/

      if rfpt_title <> "" then  do: 
          find first ad_mstr no-lock  where ad_mstr.ad_domain = global_domain and  ad_addr =
                    rfpt_title   no-error. 
          if available ad_mstr then 
                           companyname1 = ad_name  .
			   else companyname1 = companyname .
       end. /* if rfpt_title <> "" then  do: */
                           else companyname1 = companyname .
          assign  
            rflot_mult_qty    =       xkb_kb_qty 
            rflot_part_group = "" 
            rflot_part_rev = ""
            rflot_part_desc        = ""  
            rflot_part_desc1 = xxthdesc1
            rflot_part_desc2 = xxthdesc2   
            rflot_direction =  rfpt_chrfld[2] 
            rflot_type = "FG"            /* 类型 成品*/
            rflot_um = ""                      /*单位*/
            rflot_crt_user = global_userid  /*创建用户*/
            rflot_crt_time =  time   /*创建时间*/
            rflot_num_lbl = 1               /*标签数*/
            rflot_box_qty = 1               /*箱数*/
            rflot__chrfld[1] = companyname1 /*标题*/
            rflot_worker =  productioner  /*生产者*/
            rflot__chrfld[2] = pdln  /*生产线*/
            .
      if  choice and choice2 then  do:
       if x_kbqty000  + xkbraimqty = xkb_kb_qty  then Assign  xxbcprnparm = "02@" + lineprinter + "@" + companyname1 + "@" + xxthdesc1 + "@" + 
                         xxthdesc2 + "@" + xlns_part + "@" + string(today, "999999") +  rfpt_shp_box  + string(rflot1, "9999") + "@" + string(x_kbqty000  + xkbraimqty) + "@" + 
			 STRING(TODAY, "9999-99-99") + "@" + productioner + "@" + rfpt_chrfld[2]
			  xbc1_kb_raim = x_kbqty000  + xkbraimqty
			  xbc1_type = "" 
			  unfill_kb_id0 = no
                          unfill_kb_idn = no
                          unfill_kbidn  = 0
                          unfill_kbid0_qty = 0
                          unfill_kbidn_qty = 0.

                         
                         else 
			  assign  xxbcprnparm = "03@" + lineprinter + "@" + companyname1 + "@" + xxthdesc1 + "@" + 
                         xxthdesc2 + "@" + xlns_part + "@" + string(today, "999999") +  rfpt_shp_box  + string(rflot1, "9999") + "@" + string(x_kbqty000  + xkbraimqty) + "@" + 
			 STRING(TODAY, "9999-99-99") + "@" + productioner + "@" + rfpt_chrfld[2]
			  xbc1_kb_raim = x_kbqty000  + xkbraimqty
			  xbc1_type = "R"
                          rflot_scatter_qty =      x_kbqty000  + xkbraimqty .
      
      
      end.
      else do:
       if xkb_kb_raim_qty =  xkb_kb_qty  then assign  xxbcprnparm =  "02@"+ lineprinter + "@" + companyname1 + "@"  + xxthdesc1 + "@" + 
                         xxthdesc2 + "@" + xlns_part + "@" + string(today, "999999") +  rfpt_shp_box  + string(rflot1, "9999") + "@" +  string(xkb_kb_raim_qty) + "@" + 
			 STRING(TODAY, "9999-99-99") + "@" + productioner + "@" + rfpt_chrfld[2]
			  xbc1_kb_raim = xkb_kb_raim_qty
			  xbc1_type = "" 
			   unfill_kb_id0 = no
                          unfill_kb_idn = no
                          unfill_kbidn  = 0
                          unfill_kbid0_qty = 0
                          unfill_kbidn_qty = 0. 
       
           else  assign  xxbcprnparm =  "03@"+ lineprinter + "@" + companyname1 + "@"  + xxthdesc1 + "@" + 
                         xxthdesc2 + "@" + xlns_part + "@" + string(today, "999999") +  rfpt_shp_box  + string(rflot1, "9999") + "@" +  string(xkb_kb_raim_qty) + "@" + 
			 STRING(TODAY, "9999-99-99") + "@" + productioner + "@" + rfpt_chrfld[2]
			 xbc1_kb_raim = xkb_kb_raim_qty
			  xbc1_type = "R"
			   rflot_scatter_qty =    xkb_kb_raim_qty.
              
       
       end.
/*ss - 120107 - e***************************/

		 	/* message "111"  xxbcprnparm  view-as alert-box.  */
     {gprun.i ""xxbcprnall.p"" "(
        INPUT xxbcprnparm )"}  
    end.
    else do:
    {gprun.i ""xxbccreatex.p"" "(
        INPUT xlns_part,
	input ssbc1,
	output xxbcdatastr,
	output xxthtype,
	output xxthdesc1,
	output xxthdesc2 )"}
      if rfpt_title <> "" then  do: 
          find first ad_mstr no-lock  where ad_mstr.ad_domain = global_domain and  ad_addr =
                    rfpt_title   no-error. 
          if available ad_mstr then 
                           companyname1 = ad_name  .
			   else companyname1 = companyname .
       end. /* if rfpt_title <> "" then  do: */
                           else companyname1 = companyname .
  find first xbc1_mstr  where xbc1_domain = global_domain and xbc1_bc = xxbcdatastr no-error.
    if not available xbc1_mstr then do:
       message "无法产生相应的条码"  view-as alert-box.
       next-prompt p_bc with frame a.
       undo, retry.
    end.
    xbc1_kb_raim = xkb_kb_qty.
    xbc1_kb_qty = xkb_kb_qty.
    xbc1_site  =   global_domain.
    xbc1_loc   =   upt_loc .
    xbc1_crt_date = today .
    xbc1_status = "W".
    xbc1_crt_date = today.
    xbc1_fldusr[1] = productioner.
    xbc1_print = yes.

   assign  
            rflot_mult_qty    =       xkb_kb_qty 
            rflot_part_group = "" 
            rflot_part_rev = ""
            rflot_part_desc        = ""  
            rflot_part_desc1 = xxthdesc1
            rflot_part_desc2 = xxthdesc2   
            rflot_direction =  rfpt_chrfld[2] 
            rflot_type = "FG"                   /* 类型 成品*/
            rflot_um = ""                      /*单位*/
            rflot_crt_user = global_userid  /*创建用户*/
            rflot_crt_time =  time   /*创建时间*/
            rflot_num_lbl = 1               /*标签数*/
            rflot_box_qty = 1               /*箱数*/
            rflot__chrfld[1] = companyname1 /*标题*/
            rflot_worker =  productioner  /*生产者*/
            rflot__chrfld[2] = pdln  /*生产线*/
            .

    /*
    xbc1_nbr  =   thnbr 
    xbc1_line  =   thline 
    xbc1_lot    =  thlot 
    xbc1_ref    =  thref 
    xbc1_shp_nbr = threc
    */
   /* xxbcprnparm = "01@" +  lineprinter + "@" + xxthdesc1 + "@" + 
                         xxthdesc2 + "@" + xlns_part + "@" +  xxthtype + "@" + xxbcdatastr + "@" + string(xkb_kb_qty) + "@" + 
			 STRING(TODAY, "9999-99-99").*/
/*    xxbcprnparm =  "02@"+ lineprinter + "@" + companyname1 + "@"  + xxthdesc1 + "@" + 
                         xxthdesc2 + "@" + xlns_part + "@" + string(today, "999999") +  rfpt_shp_box  + string(rflot1, "9999") + "@" +  string(xkb_kb_qty) + "@" + 
			 STRING(TODAY, "9999-99-99") + "@" + productioner + "@" + rfpt_chrfld[2] .
    		/*	  message "222"  xxbcprnparm  view-as alert-box.  */
*/
 xxbcprnparm =  "02@"+ lineprinter + "@" + companyname1 + "@"  + xxthdesc1 + "@" + 
                         xxthdesc2 + "@" + xlns_part + "@" + string(today, "999999") +  rfpt_shp_box  + string(rflot1, "9999") + "@" +  string(xkb_kb_qty) + "@" + 
			 STRING(TODAY, "9999-99-99") + "@" + productioner + "@" + rfpt_chrfld[2] .
     {gprun.i ""xxbcprnall.p"" "(
        INPUT xxbcprnparm )"}  
  /*ss - 111207.1 - e***********************/

  end.

  end.  /*if available rfpt_mstr */
   startx  = no.
/*ss lambert - 20111105.1 - e* 条码打印*******************/				  

				end.  /*if l_stat_undo then do:*/
				else do:
                                    message "产品入库回冲不成功,请重刷读或找支持人员查找问题!"  .
                                    next-prompt p_bc with frame a.
                                    undo, retry.	
				end.

                                

                           end.  /*else do: if xlns_barcode1 <> "" then do: */

			end.  /**if available xlns_det ****/
			else do : /*if not available xlns_det ****/
                            message "不能接收此张看板, 可能是看板状态与生产线状态不一致".
                            next-prompt p_bc with frame a.
                            undo, retry.
                        end.  /*else do: **********/
		     end. /*if xkb_status = "P" then do: /*入库回冲*/ */

 /*ss - 090601.1 -b*	删除一定义的一出多组零件控制功能	 
		  end.  /*if lndtool <>  "" */
		  else do:  /*if lndtool = ""*/
/*minth 08/06/26*/    if xkb_status = "R"  and xkb_kb_raim > 0  then do:
/*ss - 090601.1 -b*		      find first lnd_det   no-lock where lnd_domain = global_domain and lnd_line = pdln 
		          and  lnd_part = xkb_part and lnd_tool <> "" no-error.
		           if available lnd_det then lndtool = lnd_tool .
			   else  do:

                            message "错误: 一出多程序不能控制非一出多产品,请重新输入!"   .
                            next-prompt pdln with frame a.
                            undo, retry.
			   end.
*ss - 090601.1 -e*/

                      find first  xlns_det where xlns_domain = global_domain and xlns_site = xkb_site 
			    and xlns_line  = pdln and xlns_part = xkb_part no-error. 
                      if available xlns_det then do: 
		            assign xlns_rel_qty = xlns_rel_qty + xkb_kb_raim
			       xlns_last_bc = p_bc
			       xlns_kb_rel = xlns_kb_rel + 1.
                                               l_stat = xkb_status.
					       xkb_status = "P" .
                                                xkboriqty = xkb_kb_raim_qty.
					       xkbraimqty = xkb_kb_raim_qty.
					       xkb_kb_raim_qty = 0.
                                               {xxkbhist.i &type="xkb_type"      &part="xkb_part"      &site="xkb_site"
				                    &kb_id="xkb_kb_id"    &effdate=today        &program="'xxkbbk04.p'"
				                    &qty="xkb_kb_qty"     &ori_qty="xkboriqty"  &tr_trnbr=0
					            &b_status="l_stat"    &c_status="xkb_status"
					            &rain_qty="xkb_kb_raim_qty"}
	                   
					      xkb_upt_date = today.


/*			    display xkb_kb_raim with frame bx .  */
		         end.
		         else do:
 		       /*minth set xkb_kb_raim  with frame a. */

/*ss - 20120204.1 - b*/
         if samplepart <> xkb_part then do:
	    if samplepart = "" then 
	       message "请先刷产品的样品条码，才能允许投产"  view-as alert-box.
	       else message "投产产品同样品不一至，请查原因" view-as alert-box.
	       next-prompt p_bc with frame  a .   
	       undo, retry.
	 end.
/*ss - 20120204.1 - b*/

                       create xlns_det .
		       assign xlns_domain = global_domain
		              xlns_site   = xkb_site
			      xlns_line   = pdln
			      xlns_part   = xkb_part
			      xlns_rel_qty = xkb_kb_raim 
			      xlns_start_date = today
			      xlns_start_time    = time 
			      xlns_last_date = today
			      xlns_last_time = time 
			      xlns_status = "生产中" 
			      xlns_last_bc = p_bc
			      xlns_kb_rel = 1.
			      xlns_tot_rest = tot_rest.
                            assign  
	                                  xlns_date[1]  = s_period_date
	                                  xlns_int[3]     =    s_period.  
			      assign   
				        xlns_bc_date1 = today
					xlns_bc_date2 = today
					xlns_bc_date3 = today.
/*ss - 111210.1 - */	     assign   xlns_xdate[1] = today                       
   		                            xlns_xtime[1] = time .

                 find xlpd_det  where xlpd_domain = global_domain 
                            and xlpd_site = global_domain 
	                    and xlpd_line = pdln
	                   and xlpd_plan_date =  s_period_date
	                  and xlpd_period = s_period 
			  and xlpd_part =  xlns_part

	                  no-error.
	                 if available xlpd_det then  assign xlpd__deci = xlpd__deci + xkb_kb_raim   xlpd_date  = today 
			       xlpd_time = time
/*ss - 100918.1 - B*/
                               xlpd_update = string(today) + string(time, "999999")
			       xlpd_uchar[2] = "xxkbbk04.p"
/*ss - 100918.1 - e*/    
                             . 
	                 else do:   create xlpd_det .
                               assign     xlpd_domain = global_domain 
                               xlpd_site = global_domain 
	                       xlpd_line = pdln
                               xlpd_part =  xlns_part
	                       xlpd_plan_date =  s_period_date
	                       xlpd_period = s_period  
	                       xlpd__deci = xlpd__deci +  xkb_kb_raim 
			         xlpd_date  = today 
			       xlpd_time = time 
/*ss - 100918.1 - B*/
                               xlpd_update = string(today) + string(time, "999999")
			       xlpd_uchar[2] = "xxkbbk04.p"
/*ss - 100918.1 - e*/    
                             . 
/*ss - 101205.1 - b*/
                                     find pt_mstr where pt_domain = global_domain 
					     and  pt_part = xlpd_part no-lock no-error.
                                      find ptp_det  where ptp_det.ptp_domain = global_domain 
					     and  ptp_part = xlpd_part and ptp_site = xlpd_site no-lock no-error.

					  if available ptp_det then do:
					     if ptp_routing > ""
					     then routing = ptp_routing.
					     else routing = ptp_part.
					  end.
					  else
					     routing = if pt_routing > "" then pt_routing else pt_part.

			        	find first ro_det where ro_domain = global_domain 
					 and ro_routing  = routing and ((ro_start <= eff_date or ro_start = ?)
					 and (ro_end   >= eff_date or ro_end   = ?)) no-lock no-error.
				      if available ro_det then do :
                                          xlpd_udec[3]   = ro_run.
			                  xlpd_udec[1] =   ro_setup.
 				      end .
				      else  assign  xlpd_udec[3]  =  0  xlpd_udec[1] = 0.
/*ss - 101205.1 - e*/

	               end.


                                               l_stat = xkb_status.
					       xkb_status = "P" .
                                                xkboriqty = xkb_kb_raim_qty.
					       xkbraimqty = xkb_kb_raim_qty.
					       xkb_kb_raim_qty = 0.
                                               {xxkbhist.i &type="xkb_type"      &part="xkb_part"      &site="xkb_site"
				                    &kb_id="xkb_kb_id"    &effdate=today        &program="'xxkbbk04.p'"
				                    &qty="xkb_kb_qty"     &ori_qty="xkboriqty"  &tr_trnbr=0
					            &b_status="l_stat"    &c_status="xkb_status"
					            &rain_qty="xkb_kb_raim_qty"}
 	                   
					      xkb_upt_date = today.
					      i_prod = i_prod + 1.
 		        end.
		      
                          
                    end.
		    else do:
                        message "错误: 生产看板条码状态不是 R , 不接收! 生产线状态记录不存在!"  .
                        next-prompt p_bc with frame a.
                        undo, retry.
		    end.
		end.  /*else do:****/
 *ss - 090601.1 -b* 删除一定义的一出多组零件控制功能*/		 

/*判断是否是正在生产产品*******************/
	       end. /*if available xkb_mstr */
	       else  do: /*不是生产看板*/
	       /*是否是该生产线管理条码*/
 
                   find first xlnc_mstr where xlnc_domain = global_domain 
	               and xlnc_line = pdln
		       and xlnc_barcode = p_bc no-lock no-error. 
                   
		   if not available xlnc_mstr then do:
                        message "错误: 不是这条生产线的管理条码或不可接受的看板!" .
                        next-prompt p_bc with frame a.
                        undo, retry.
		   end.
		   else do: /*是否是可以接收的条码*/
		       display xlnc_desc with frame a .
		       
		       if not available xlns_det then  do:
                          message "错误: 目前不可以接收的管理条码!"    .
                          next-prompt p_bc with frame a.
                          undo, retry.
		       end.
 
		       if index(p_bc, "OTCANCEL") > 1  and xlns_barcode1 = ""  
		          and not index(xlns_last_bc, "QC") >= 1   then do:
                          message "错误: 不允许取消上一次刷读!"    .
                          next-prompt p_bc with frame a.
                          undo, retry.
		       end. /*if index(p_bc, "OTCANCEL") > 1 */
 /*ss 090810.1 - b*/
                       if not ( index(p_bc, "OTREST")  >= 1 
			            or index(p_bc, "OTCANCEL") >= 1  
				    or index(p_bc, "OTOVER")   >= 1
			            or index(p_bc, "QC" )   >= 1 ) then do:
                          message "错误: 目前不可以接收的管理条码! "   .
                          next-prompt p_bc with frame a.
                          undo, retry.
		       end.
 /*ss 090810.1 - e*/

		       if p_bc <> xlns_barcode1 and xlns_barcode1 <> "" 
		             and (not ( index(p_bc, "OTREST")  >= 1 
			            or index(p_bc, "OTCANCEL") >= 1  
			            or index(p_bc, "QC" )   >= 1 )) then do:
                          message "错误: 目前可以接收的管理条码是 "  xlns_barcode1   .
                          next-prompt p_bc with frame a.
                          undo, retry.
		       end.
		       else do: 
 
                          if xlns_barcode1 = p_bc and not index(p_bc, "QC") >= 1   then do:
                                  site = xlns_site .
                                  part = xlns_part.
                                 {xxeffdate.i}
	                         line = pdln.
	                         emp = global_userid.
/* ss-090401.1 -b */
				     if ln__chr03 = "" then do :
				         find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part = xlns_part no-lock no-error.

					  find ptp_det  where ptp_det.ptp_domain = global_domain and  ptp_part = xlns_part and ptp_site = site no-lock no-error.

					  if available ptp_det then do:
					     if ptp_routing > ""
					     then routing = ptp_routing.
					     else routing = ptp_part.
					  end.
					  else
					     routing = if pt_routing > "" then pt_routing else pt_part.

			        	find first ro_det where ro_domain = global_domain 
					 and ro_routing  = routing and ((ro_start <= eff_date or ro_start = ?)
					 and (ro_end   >= eff_date or ro_end   = ?)) no-lock no-error.
				       if available ro_det then do :
                                         assign
                                        wkctr              = ro_wkctr
                                        mch                = ro_mch
					std_run            = ro_run.
				      end .
				      end .
				     else do :
				     /* ss-090401.1 -e */
/*09/02/18*/	                    assign
                                        wkctr              = ln__chr03
                                        mch                = ln__chr04
					std_run            = 0.01.
				    /* ss-090401.1 -b */
				    end . /* ln_chr03 <> "" */
				    /* ss-090401.1 -e */
/* ss - 090513.1 - b*/
	for first wc_mstr
         fields( wc_domain wc_dept wc_desc wc_mch wc_wkctr)
          where wc_mstr.wc_domain = global_domain and  wc_wkctr = wkctr
           and wc_mch   = mch
      no-lock:
      end. /* FOR FIRST wc_mstr */
      if not available wc_mstr then do:
         message "工作中心不存在, 请检查相应的生产线设置" view-as alert-box.
	 undo, retry .
      end.

      dept = wc_dept.
      for first dpt_mstr
         fields( dpt_domain dpt_dept dpt_desc)
          where dpt_mstr.dpt_domain = global_domain and  dpt_dept = wc_dept
      no-lock:
      end. /* FOR FIRST dpt_mstr */
      if not available dpt_mstr then do:
         message "部门不存在, 请检查相应的生产线设置" view-as alert-box.
	 undo, retry .
      end.
/* ss - 090513.1 - b*/
				  /* mage add 08/04/27 */    {xxtransbcmt21.i}  
                              if index(p_bc, "SP") >= 1  then do:
/*ss - 0909601.1 -  b* 删除不支持这一功能*****************************
			         /*直接修改*/
				 assign
                                        wkctr              = ""
                                        mch                = ""
                                        dept               = ""
                                        um                 = ""
                                        conv               = 1
                                        qty_rjct           = 0
                                        rjct_rsn_code      = ""
                                        rejque_multi_entry = no
                                        to_op              = op
                                        qty_scrap          = 0
                                        scrap_rsn_code     = ""
                                        outque_multi_entry = no
                                        mod_issrc          = no
                                        start_run          = ""
                                        act_run_hrs        = 0
                                        stop_run           = ""
                                        earn_code          = ""
                                        rsn_codes          = ""
                                        quantities         = 0
                                        scrap_rsn_codes    = ""
                                        scrap_quantities   = 0
                                        reject_rsn_codes   = ""
                                        reject_quantities  = 0
                                        act_rsn_codes      = ""
                                        act_hrs            = 0
                                        prod_multi_entry   = no
                                        rsn                = ""
                                        act_run_hrs        = 0
                                        move_next_op       = yes
                                        act_setup_hrs      = 0
                                        setup_rsn          = ""
                                        act_multi_entry    = no
                                        act_setup_hrs20    = 0
                                        down_rsn_code      = ""
                                        stop_multi_entry   = no
                                        non_prod_hrs       = 0 .
					l_stat_undo        = no. 

                                  act_setup_hrs = ((today - xlns_bc_date1) * 24 * 3600 + time - xlns_bc_time1) / 3600   - xlns_last_rest2 .   
			          if act_setup_hrs = ? or i_prod = 0 then act_setup_hrs = 0 . else act_setup_hrs = act_setup_hrs / i_prod .
				  if act_setup_hrs < 0 then act_setup_hrs = 0.        
				 for each xlnsdet where xlnsdet.xlns_domain = global_domain 
				      and xlnsdet.xlns_site = global_domain
				      and xlnsdet.xlns_line = pdln :
				  /* mage del 08/04/27    {xxtransbcmt2.i}  */
                                  /*mage add  08/04/27   *********/
				    part = xlnsdet.xlns_part.
	                            eff_date = today.
				    {xxeffdate.i}
	                            line = pdln.
	                            emp = global_userid.  

/* ss-090401.1 -b */
				     if ln__chr03 = "" then do :
				         find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part = xlns_part no-lock no-error.

					  find ptp_det  where ptp_det.ptp_domain = global_domain and  ptp_part = xlns_part and ptp_site = site no-lock no-error.

					  if available ptp_det then do:
					     if ptp_routing > ""
					     then routing = ptp_routing.
					     else routing = ptp_part.
					  end.
					  else
					     routing = if pt_routing > "" then pt_routing else pt_part.

			        	find first ro_det where ro_domain = global_domain 
					 and ro_routing  = routing and ((ro_start <= eff_date or ro_start = ?)
					 and (ro_end   >= eff_date or ro_end   = ?)) no-lock no-error.
                                       if available ro_det then do :
                                         assign
                                        wkctr              = ro_wkctr
                                        mch                = ro_mch
					std_run            = ro_run.
				      end .
				      end .
				     else do :
				     /* ss-090401.1 -e */
/*09/02/18*/	                    assign
                                        wkctr              = ln__chr03
                                        mch                = ln__chr04
					std_run            = 0.01.
				    /* ss-090401.1 -b */
				    end . /* ln_chr03 <> "" */
				    /* ss-090401.1 -e */
/* ss - 090513.1 - b*/
	for first wc_mstr
         fields( wc_domain wc_dept wc_desc wc_mch wc_wkctr)
          where wc_mstr.wc_domain = global_domain and  wc_wkctr = wkctr
           and wc_mch   = mch
      no-lock:
      end. /* FOR FIRST wc_mstr */
      if not available wc_mstr then do:
         message "工作中心不存在, 请检查相应的生产线设置" view-as alert-box.
	 undo, retry .
      end.

      dept = wc_dept.
      for first dpt_mstr
         fields( dpt_domain dpt_dept dpt_desc)
          where dpt_mstr.dpt_domain = global_domain and  dpt_dept = wc_dept
      no-lock:
      end. /* FOR FIRST dpt_mstr */
      if not available dpt_mstr then do:
         message "部门不存在, 请检查相应的生产线设置" view-as alert-box.
	 undo, retry .
      end.
/* ss - 090513.1 - b*/
				    
			           {xxtransbcmt21.i} 

                                  /*mage add  08/04/27   *********/

				      assign xlnsdet.xlns_tot_sp   = xlnsdet.xlns_tot_sp + act_setup_hrs 
				        xlnsdet.xlns_last_sp  = xlnsdet.xlns_last_sp + act_setup_hrs
					xlnsdet.xlns_status   = "生产中"
					xlnsdet.xlns_last_bc    = p_bc
					xlnsdet.xlns_barcode1  = ""
					xlnsdet.xlns_bc_date1  = today
					xlnsdet.xlns_bc_time1  = 0
					xlnsdet.xlns_last_rest2 = 0.   

			          setup_rsn = xlnc_mstr.xlnc_code.

                                    if act_setup_hrs > 0 then   {xxsetupbcmtkb.i}
				 end. /*for each xlnsdet***/
*ss - 0909601.1 -  b* 删除不支持这一功能*****************************/
/*ss - 090601.1 - b*/
                  message "错误: 不可以接收的管理条码 "   .
/*ss - 090601.1 - e*/
 			      end.
			      else if index(p_bc, "DN") >= 1  then do:
/*ss - 0909601.1 -  b* 删除不支持这一功能*****************************

			         /*直接修改*/
				 assign
                                        wkctr              = ""
                                        mch                = ""
                                        dept               = ""
                                        um                 = ""
                                        conv               = 1
                                        qty_rjct           = 0
                                        rjct_rsn_code      = ""
                                        rejque_multi_entry = no
                                        to_op              = op
                                        qty_scrap          = 0
                                        scrap_rsn_code     = ""
                                        outque_multi_entry = no
                                        mod_issrc          = no
                                        start_run          = ""
                                        act_run_hrs        = 0
                                        stop_run           = ""
                                        earn_code          = ""
                                        rsn_codes          = ""
                                        quantities         = 0
                                        scrap_rsn_codes    = ""
                                        scrap_quantities   = 0
                                        reject_rsn_codes   = ""
                                        reject_quantities  = 0
                                        act_rsn_codes      = ""
                                        act_hrs            = 0
                                        prod_multi_entry   = no
                                        rsn                = ""
                                        act_run_hrs        = 0
                                        move_next_op       = yes
                                        act_setup_hrs      = 0
                                        setup_rsn          = ""
                                        act_multi_entry    = no
                                        act_setup_hrs20    = 0
                                        down_rsn_code      = ""
                                        stop_multi_entry   = no
                                        non_prod_hrs       = 0 .
					l_stat_undo        = no. 

			         act_setup_hrs20 = ((today - xlns_bc_date1) * 24 * 3600 + time - xlns_bc_time1) / 3600  - xlns_last_rest2.
                                 if act_setup_hrs20 = ? or i_prod = 0 then act_setup_hrs20 = 0 . else act_setup_hrs20 = act_setup_hrs20 / i_prod .
				 if act_setup_hrs20 < 0 then act_setup_hrs20 = 0.        
                                 for each xlnsdet where xlnsdet.xlns_domain = global_domain 
				      and xlnsdet.xlns_site = global_domain
				      and xlnsdet.xlns_line = pdln :
				  /* mage del 08/04/27    {xxtransbcmt2.i}  */
				  /*mage add  08/04/27   *********/
				    part = xlnsdet.xlns_part.
	                            eff_date = today.
				    {xxeffdate.i}
	                            line = pdln.
	                            emp = global_userid.   
/* ss-090401.1 -b */
				     if ln__chr03 = "" then do :
				         find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part = xlns_part no-lock no-error.

					  find ptp_det  where ptp_det.ptp_domain = global_domain and  ptp_part = xlns_part and ptp_site = site no-lock no-error.

					  if available ptp_det then do:
					     if ptp_routing > ""
					     then routing = ptp_routing.
					     else routing = ptp_part.
					  end.
					  else
					     routing = if pt_routing > "" then pt_routing else pt_part.

			        	find first ro_det where ro_domain = global_domain 
					 and ro_routing  = routing and ((ro_start <= eff_date or ro_start = ?)
					 and (ro_end   >= eff_date or ro_end   = ?)) no-lock no-error.
				      if available ro_det then do :
                                         assign
                                        wkctr              = ro_wkctr
                                        mch                = ro_mch
					std_run            = ro_run.
				      end .
				      end .
				     else do :
				     /* ss-090401.1 -e */
/*09/02/18*/	                    assign
                                        wkctr              = ln__chr03
                                        mch                = ln__chr04
					std_run            = 0.01.
				    /* ss-090401.1 -b */
				    end . /* ln_chr03 <> "" */
/* ss - 090513.1 - b*/
	for first wc_mstr
         fields( wc_domain wc_dept wc_desc wc_mch wc_wkctr)
          where wc_mstr.wc_domain = global_domain and  wc_wkctr = wkctr
           and wc_mch   = mch
      no-lock:
      end. /* FOR FIRST wc_mstr */
      if not available wc_mstr then do:
         message "工作中心不存在, 请检查相应的生产线设置" view-as alert-box.
	 undo, retry .
      end.

      dept = wc_dept.
      for first dpt_mstr
         fields( dpt_domain dpt_dept dpt_desc)
          where dpt_mstr.dpt_domain = global_domain and  dpt_dept = wc_dept
      no-lock:
      end. /* FOR FIRST dpt_mstr */
      if not available dpt_mstr then do:
         message "部门不存在, 请检查相应的生产线设置" view-as alert-box.
	 undo, retry .
      end.
/* ss - 090513.1 - b*/

				    {xxtransbcmt21.i} 
                                  /*mage add  08/04/27   *********/

 				      assign xlnsdet.xlns_tot_dn   = xlnsdet.xlns_tot_dn + act_setup_hrs20
				        xlnsdet.xlns_last_dn  = xlnsdet.xlns_last_dn + act_setup_hrs20
					xlnsdet.xlns_status   = "生产中"
					xlnsdet.xlns_last_bc  = p_bc
                                        xlnsdet.xlns_barcode1  = ""
					xlnsdet.xlns_bc_date1  = today
					xlnsdet.xlns_bc_time1  = 0
					xlnsdet.xlns_last_rest2 = 0.   
                                   if xlnsdet.xlns_chr[1] = xlnc_desc then xlnsdet.xlns_dec[1] = xlnsdet.xlns_dec[1] + act_setup_hrs20  .
				        else if xlnsdet.xlns_chr[2] = xlnc_desc then xlnsdet.xlns_dec[2] = xlnsdet.xlns_dec[2] + act_setup_hrs20  .
						   else if xlnsdet.xlns_chr[3] = xlnc_desc then xlnsdet.xlns_dec[3] = xlnsdet.xlns_dec[3] + act_setup_hrs20  .

                                 /*非生产性工时 18.22.22*/
			         down_rsn_code = xlnc_mstr.xlnc_code.
 
 
			         
				    if act_setup_hrs20 > 0 then  {xxdownbcmtkb.i}
				 end. /*for each xlnsdet***/
*ss - 0909601.1 -  b* 删除不支持这一功能*****************************/
/*ss - 090601.1 - b*/
                  message "错误: 不可以接收的管理条码 "   .
/*ss - 090601.1 - e*/
 			      end.
			      else if index(p_bc, "DT") >= 1  then do:
/*ss - 0909601.1 -  b* 删除不支持这一功能*****************************

			         /*直接修改*/
				 assign
                                        wkctr              = ""
                                        mch                = ""
                                        dept               = ""
                                        um                 = ""
                                        conv               = 1
                                        qty_rjct           = 0
                                        rjct_rsn_code      = ""
                                        rejque_multi_entry = no
                                        to_op              = op
                                        qty_scrap          = 0
                                        scrap_rsn_code     = ""
                                        outque_multi_entry = no
                                        mod_issrc          = no
                                        start_run          = ""
                                        act_run_hrs        = 0
                                        stop_run           = ""
                                        earn_code          = ""
                                        rsn_codes          = ""
                                        quantities         = 0
                                        scrap_rsn_codes    = ""
                                        scrap_quantities   = 0
                                        reject_rsn_codes   = ""
                                        reject_quantities  = 0
                                        act_rsn_codes      = ""
                                        act_hrs            = 0
                                        prod_multi_entry   = no
                                        rsn                = ""
                                        act_run_hrs        = 0
                                        move_next_op       = yes
                                        act_setup_hrs      = 0
                                        setup_rsn          = ""
                                        act_multi_entry    = no
                                        act_setup_hrs20    = 0
                                        down_rsn_code      = ""
                                        stop_multi_entry   = no
                                        non_prod_hrs       = 0 .
					l_stat_undo        = no. 

			         act_setup_hrs20 = ((today - xlns_bc_date1) * 24 * 3600 + time - xlns_bc_time1) / 3600 - xlns_last_rest2.
                                 if act_setup_hrs20 = ? or i_prod = 0 then act_setup_hrs20 = 0 . else act_setup_hrs20 = act_setup_hrs20 / i_prod .
				 if act_setup_hrs20 < 0 then act_setup_hrs20 = 0.        
                                 for each xlnsdet where xlnsdet.xlns_domain = global_domain
				      and xlnsdet.xlns_site = global_domain
				      and xlnsdet.xlns_line = pdln :
				  /* mage del 08/04/27    {xxtransbcmt2.i}  */
				  /*mage add  08/04/27   *********/
				    part = xlnsdet.xlns_part.
	                            eff_date = today.
				    {xxeffdate.i}
	                            line = pdln.
	                            emp = global_userid. 
/* ss-090401.1 -b */
				     if ln__chr03 = "" then do :
				         find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part = xlns_part no-lock no-error.

					  find ptp_det  where ptp_det.ptp_domain = global_domain and  ptp_part = xlns_part and ptp_site = site no-lock no-error.

					  if available ptp_det then do:
					     if ptp_routing > ""
					     then routing = ptp_routing.
					     else routing = ptp_part.
					  end.
					  else
					     routing = if pt_routing > "" then pt_routing else pt_part.

			        	find first ro_det where ro_domain = global_domain 
					 and ro_routing  = routing and ((ro_start <= eff_date or ro_start = ?)
					 and (ro_end   >= eff_date or ro_end   = ?)) no-lock no-error.
				        if available ro_det then do :
                                         assign
                                        wkctr              = ro_wkctr
                                        mch                = ro_mch
					std_run            = ro_run.
				      end .
				      end .
				     else do :
				     /* ss-090401.1 -e */
/*09/02/18*/	                    assign
                                        wkctr              = ln__chr03
                                        mch                = ln__chr04
					std_run            = 0.01.
				    /* ss-090401.1 -b */
				    end . /* ln_chr03 <> "" */
/* ss - 090513.1 - b*/
	for first wc_mstr
         fields( wc_domain wc_dept wc_desc wc_mch wc_wkctr)
          where wc_mstr.wc_domain = global_domain and  wc_wkctr = wkctr
           and wc_mch   = mch
      no-lock:
      end. /* FOR FIRST wc_mstr */
      if not available wc_mstr then do:
         message "工作中心不存在, 请检查相应的生产线设置" view-as alert-box.
	 undo, retry .
      end.

      dept = wc_dept.
      for first dpt_mstr
         fields( dpt_domain dpt_dept dpt_desc)
          where dpt_mstr.dpt_domain = global_domain and  dpt_dept = wc_dept
      no-lock:
      end. /* FOR FIRST dpt_mstr */
      if not available dpt_mstr then do:
         message "部门不存在, 请检查相应的生产线设置" view-as alert-box.
	 undo, retry .
      end.
/* ss - 090513.1 - b*/


				    {xxtransbcmt21.i} 
                                  /*mage add  08/04/27   *********/

 				 assign xlnsdet.xlns_tot_dt   = xlnsdet.xlns_tot_dt + act_setup_hrs20
				        xlnsdet.xlns_last_dt  = xlnsdet.xlns_last_dt + act_setup_hrs20
					xlnsdet.xlns_status   = "生产中"
					xlnsdet.xlns_last_bc  = p_bc
					xlnsdet.xlns_barcode1  = ""
					xlnsdet.xlns_bc_date1  = today
					xlnsdet.xlns_bc_time1  = 0
					xlnsdet.xlns_last_rest2 = 0.                               
			       

 
			         down_rsn_code = xlnc_mstr.xlnc_code.
			             if act_setup_hrs20 > 0 then  {xxdowntimebcmtkb.i}
				  end. /*for each xlnsdet***/
*ss - 0909601.1 -  b* 删除不支持这一功能*****************************/
/*ss - 090601.1 - b*/
                  message "错误: 不可以接收的管理条码 "   .
/*ss - 090601.1 - e*/
 			      end.
			      else if index(p_bc, "OTREST")  >= 1 then do:
			         /*直接修改*/
                                for each xlnsdet where xlnsdet.xlns_domain = global_domain 
				      and xlnsdet.xlns_site = global_domain
				      and xlnsdet.xlns_line = pdln :
/*ss - 091106.1 *
 			         assign xlnsdet.xlns_tot_rest   = xlnsdet.xlns_tot_rest + (((today - xlnsdet.xlns_bc_date1) * 24 * 3600 + time - xlnsdet.xlns_bc_time1) / 3600) * men_qty
				        xlnsdet.xlns_last_rest  = xlnsdet.xlns_last_rest + (((today - xlnsdet.xlns_bc_date1) * 24 * 3600 + time - xlnsdet.xlns_bc_time1) / 3600) * men_qty
				        xlnsdet.xlns_last_rest2 = xlnsdet.xlns_last_rest2 + (((today - xlnsdet.xlns_bc_date1) * 24 * 3600 + time - xlnsdet.xlns_bc_time1) / 3600) * men_qty
                                        xlnsdet.xlns_last_bc    = p_bc.
*ss - 091106.1 */					
/*ss - 091106.1 */
 			         assign xlnsdet.xlns_tot_rest   = xlnsdet.xlns_tot_rest + (((today - xlnsdet.xlns_bc_date1) * 24 * 3600 + time - xlnsdet.xlns_bc_time1) / 3600) 
				        xlnsdet.xlns_last_rest  = xlnsdet.xlns_last_rest + (((today - xlnsdet.xlns_bc_date1) * 24 * 3600 + time - xlnsdet.xlns_bc_time1) / 3600)  
				        xlnsdet.xlns_last_rest2 = xlnsdet.xlns_last_rest2 + (((today - xlnsdet.xlns_bc_date1) * 24 * 3600 + time - xlnsdet.xlns_bc_time1) / 3600)  

/*ss - 091106.1 */
                                     xlnsdet.xlns_barcode1 = xlnsdet.xlns_barcode2.
				     xlnsdet.xlns_bc_date1 = xlnsdet.xlns_bc_date2.
				     xlnsdet.xlns_bc_time1 = xlnsdet.xlns_bc_time2.
				     xlnsdet.xlns_last_bc  = p_bc.
				     xlnsdet.xlns_status   = xlnsdet.xlns_last_status.
				                                          xlnsdet.xlns_last_status = "".
				  end. /*for each xlnsdet***/  
				  /* release xlnsdet. */ 
			      end.  /*else do: ****************/
/*debug*/
			  end. /*if xlns_barcode1 = p_bc and not index(p_bc, "QC") >= 1   then do:*/
			  else do: /*第一次刷读, 或QC类型 */
/*ss - 090601.1 - b*/
 			      if index(p_bc, "OTOVER") >= 1 then do:
			         tot_time1 = 0 .
                                 tot-part = 0.
				 end_date = today.
				 end_time = time.

                                 for each xlnsdet where xlnsdet.xlns_domain = global_domain
				      and xlnsdet.xlns_site = global_domain
				      and xlnsdet.xlns_line = pdln break by xlns_line: 
				          tot_time1 = tot_time1 + xlnsdet.xlns_dec[3].
					  tot-part = tot-part + 1.
				      if last-of( xlnsdet.xlns_line ) 
				         then diff_time1 = (((end_date - xlnsdet.xlns_start_date) * 24 * 3600 + end_time - xlns_start_time ) / 3600 - xlnsdet.xlns_tot_rest ) * xlns_int[1] - tot_time1 .  
                                 end.
				  yn-over = yes.
                                  if tot_time1 <= 0  or diff_time1 = ? then do:
				    message "产品的总吸收时间为零或差异时间为？，不能分配. 是否一定要结束？" 
				     view-as alert-box buttons  yes-no update yn-over.
				     if not yn-over then   undo, retry .
				 end.
			      /*分配差异工时*/
			         if yn-over  and  diff_time1 <> ? and (tot_time1 > 0   or tot_time1 <= 0 and tot-part > 0 ) then
                                 for each xlnsdet where xlnsdet.xlns_domain = global_domain
				      and xlnsdet.xlns_site = global_domain
				      and xlnsdet.xlns_line = pdln : 
                                      assign
                                           wkctr              = ""
                                           mch                = ""
                                           dept               = ""
                                           um                 = ""
                                           conv               = 1
                                           qty_rjct           = 0
                                           rjct_rsn_code      = ""
                                           rejque_multi_entry = no
                                           to_op              = op
                                           qty_scrap          = 0
                                           scrap_rsn_code     = ""
                                           outque_multi_entry = no
                                           mod_issrc          = no
                                           start_run          = ""
                                           act_run_hrs        = 0
                                           stop_run           = ""
                                           earn_code          = ""
                                           rsn_codes          = ""
                                           quantities         = 0
                                           scrap_rsn_codes    = ""
                                           scrap_quantities   = 0
                                           reject_rsn_codes   = ""
                                           reject_quantities  = 0
                                           act_rsn_codes      = ""
                                           act_hrs            = 0
                                           prod_multi_entry   = no
                                           rsn                = ""
                                           act_run_hrs        = 0
                                           move_next_op       = yes
                                           act_setup_hrs      = 0
                                           setup_rsn          = ""
                                           act_multi_entry    = no
                                           act_setup_hrs20    = 0
                                           down_rsn_code      = ""
                                           stop_multi_entry   = no
                                           non_prod_hrs       = 0 .
					   l_stat_undo        = no. 
	        
	        
 	 		             site = xlnsdet.xlns_site.
			             emp = global_userid.
                                     line = xlnsdet.xlns_line.
			             part = xlnsdet.xlns_part.
			             b_qc = "qc".
				     if tot_time1 > 0 then act_run_hrs = diff_time1 * xlnsdet.xlns_dec[3] / tot_time1.
				                      else if tot-part > 0 then act_run_hrs = diff_time1   / tot-part.
			             qty_proc = 0 .
	        	             message "工时差异分配: 投产时间:"  round((((end_date - xlnsdet.xlns_start_date) * 24 * 3600 + end_time - xlns_start_time ) / 3600  * xlns_int[1]), 2)  
				         skip(0) "休息时间" round( xlnsdet.xlns_tot_rest , 2)  skip(0)  "总标准耗用时间"  round(tot_time1, 2)  skip(0) "本产品标准耗用时间"  round(xlnsdet.xlns_dec[3], 2)  skip(0) "本产品分配差异时间" round(act_run_hrs, 2)  view-as alert-box.  
              	     	 			     if ln__chr03 = "" then do :
					  find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part = xlns_part no-lock no-error.
	        
					  find ptp_det  where ptp_det.ptp_domain = global_domain and  ptp_part = xlns_part and ptp_site = site no-lock no-error.
	        
					  if available ptp_det then do:
					     if ptp_routing > ""
					     then routing = ptp_routing.
					     else routing = ptp_part.
					  end.
					  else
					     routing = if pt_routing > "" then pt_routing else pt_part.
	        
				         find first ro_det where ro_domain = global_domain 
					    and ro_routing  = routing and ((ro_start <= eff_date or ro_start = ?)
					    and (ro_end   >= eff_date or ro_end   = ?)) no-lock no-error.
					if available ro_det then do :
                                         assign
                                        wkctr              = ro_wkctr
                                        mch                = ro_mch
					std_run            = ro_run.
				      end .
				      end .
				     else do :
				     /* ss-090401.1 -e */
/*09/02/18*/	                    assign
                                        wkctr              = ln__chr03
                                        mch                = ln__chr04
					std_run            = 0.01.
				    /* ss-090401.1 -b */
				    end . /* ln_chr03 <> "" */
    	      	   	   	    for first wc_mstr
                                      fields( wc_domain wc_dept wc_desc wc_mch wc_wkctr)
                                       where wc_mstr.wc_domain = global_domain and  wc_wkctr = wkctr
                                        and wc_mch   = mch
                                        no-lock:
                                     end. /* FOR FIRST wc_mstr */
                                    if not available wc_mstr then do:
                                       message "工作中心不存在, 请检查相应的生产线设置" view-as alert-box.
					 undo, retry .
                                    end.
       	                        
                                    dept = wc_dept.
                                    for first dpt_mstr
                                      fields( dpt_domain dpt_dept dpt_desc)
                                       where dpt_mstr.dpt_domain = global_domain and  dpt_dept = wc_dept
                                    no-lock:
                                    end. /* FOR FIRST dpt_mstr */
                                    if not available dpt_mstr then do:
                                         message "部门不存在, 请检查相应的生产线设置" view-as alert-box.
					 undo, retry .
                                    end.
				  /* mage add 08/04/27 */    {xxtransbcmt21.i}  
 	   						    
                                   if act_run_hrs  <> 0 then 
                                   {gprun.i ""xxkbbk04bcmt.p""
                                     "(output upt_loc)"}
				 assign
                                    xlnsdet.xlns_start_date = ? 
				    xlnsdet.xlns_start_time = 0
				    xlnsdet.xlns_dec[3]     = 0
				    xlnsdet.xlns_int[1]     = 0
				    xlnsdet.xlns_tot_rest   = 0.

                     find xlpd_det  where xlpd_domain = global_domain 
                            and xlpd_site = global_domain 
	                    and xlpd_line = pdln
	                    and xlpd_plan_date =  s_period_date
	                    and xlpd_period = s_period 
			    and xlpd_part =  xlnsdet.xlns_part

	                  no-error.
	                 if available xlpd_det then  assign     xlpd_date  = today 
			       xlpd_time = time 

/*ss - 100918.1 - B*/
                               xlpd_update = string(today) + string(time, "999999")
			       xlpd_uchar[2] = "xxkbbk04.p"
/*ss - 100918.1 - e*/    
                             . 
	                 else do:   create xlpd_det .
                               assign     xlpd_domain = global_domain 
                               xlpd_site = global_domain 
	                       xlpd_line = pdln
                               xlpd_part =  xlnsdet.xlns_part
	                       xlpd_plan_date =  s_period_date
	                       xlpd_period = s_period  
	                       xlpd_comp_qty = 0
			       xlpd_date  = today 
			       xlpd_time = time 

/*ss - 100918.1 - B*/
                               xlpd_update = string(today) + string(time, "999999")
			       xlpd_uchar[2] = "xxkbbk04.p"
/*ss - 100918.1 - e*/    
                             . 

/*ss - 101205.1 - b*/
                                     find pt_mstr where pt_domain = global_domain 
					     and  pt_part = xlpd_part no-lock no-error.
                                      find ptp_det  where ptp_det.ptp_domain = global_domain 
					     and  ptp_part = xlpd_part and ptp_site = xlpd_site no-lock no-error.

					  if available ptp_det then do:
					     if ptp_routing > ""
					     then routing = ptp_routing.
					     else routing = ptp_part.
					  end.
					  else
					     routing = if pt_routing > "" then pt_routing else pt_part.

			        	find first ro_det where ro_domain = global_domain 
					 and ro_routing  = routing and ((ro_start <= eff_date or ro_start = ?)
					 and (ro_end   >= eff_date or ro_end   = ?)) no-lock no-error.
				      if available ro_det then do :
                                          xlpd_udec[3]   = ro_run.
			                  xlpd_udec[1] =   ro_setup.
 				      end .
				      else  assign  xlpd_udec[3]  =  0  xlpd_udec[1] = 0.
/*ss - 101205.1 - e*/
	                   end.

/*查找标准运行时间*****************************************************
                                          find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part = xlpd_part no-lock no-error.

					  find ptp_det  where ptp_det.ptp_domain = global_domain and  ptp_part = xlpd_part and ptp_site = site no-lock no-error.

					  if available ptp_det then do:
					     if ptp_routing > ""
					     then routing = ptp_routing.
					     else routing = ptp_part.
					  end.
					  else
					     routing = if pt_routing > "" then pt_routing else pt_part.

			        	find first ro_det where ro_domain = global_domain 
					 and ro_routing  = routing and ((ro_start <= eff_date or ro_start = ?)
					 and (ro_end   >= eff_date or ro_end   = ?)) no-lock no-error.
				        if available ro_det then do :
                                         assign
                                 		std_run            = ro_run.
				        end .
 				     else do :
				     /* ss-090401.1 -e */
/*09/02/18*/	                    assign
                                        
					std_run            = 0.01.
				    /* ss-090401.1 -b */
				    end .  
				    
*查找标准运行时间*****************************************************/

		       assign  xlpd_prodtime = xlpd_prodtime  + act_run_hrs                  /*生产时间良品+不良品*/
                               xlpd_wktime   = xlpd_wktime    + act_run_hrs                  /*工作时间 生产时间 准备时间 DN时间 DT时间 */
			       xlpd_stdtime  = xlpd_stdtime  +  0                                 /*良品标准时间*/
			       xlpd_sptime   = xlpd_sptime + 0                                    /*准备时间*/
			       xlpd_dntime   = xlpd_dntime +  0                                    /*dn 时间*/
			       xlpd_dttime   = xlpd_dttime + 0                                     /*dt 时间*/
			       xlpd_udec[1]  =  xlpd_udec[1] +  0                                  /*不良品标准时间*/
			       xlpd_udec[2]  =  xlpd_udec[2] + 0 .                   /*标准准备时间*/
 
                                 end. /*for each ***************/

                              end. /*if index(p_bc, "OTOVER") >= 1 then do:*/
			      else do:
/*ss - 090601.1 - e*/

			      if index(p_bc, "OTCANCEL") >= 1 then do:
                                 for each xlnsdet where xlnsdet.xlns_domain = global_domain
				      and xlnsdet.xlns_site = global_domain
				      and xlnsdet.xlns_line = pdln :
                                     if index(xlnsdet.xlns_last_bc, "QC") >= 1 and xlnsdet.xlns_barcode1 = "" then do:
				     
				      
/*不删除历史记录,改为新增一条负数的历史记录**********************************/
/*ss - 1009016 - b*                    /*回冲品质不良数量*/
                                          find last xlkh_hist where xlkh_domain = global_domain                    
		  		             and xlkh_hist.xlkh_site = site
		  		             and xlkh_hist.xlkh_line = xlnsdet.xlns_line
		  		             and xlkh_hist.xlkh_part = xlnsdet.xlns_part
		                             and xlkh_hist.xlkh_date >= today - 1
		  		             and xlkh_hist.xlkh_barcode = xlnsdet.xlns_last_bc
 		  		             and xlkh_hist.xlkh_qc_qty = xlnsdet.xlns_last_qc 
				             use-index xlkh_part  no-error.
                                         if available xlkh_hist then do:
                                            delete xlkh_hist .
		                         end.
*ss - 1009016 - e*/
/*ss - 1009016 - b*/
              trnbr = 0.
              find last xlkh_hist where xlkh_domain = global_domain
        	    use-index xlkh_trnbr no-lock no-error.
              if available xlkh_hist then do:
                 trnbr =  xlkh_trnbr.
		end.
	      
              create xlkh_hist.
		  assign
		    xlkh_hist.xlkh_domain = global_domain
		    xlkh_hist.xlkh_site = site
		    xlkh_hist.xlkh_line = xlnsdet.xlns_line
		    xlkh_hist.xlkh_part = xlnsdet.xlns_part
		    xlkh_hist.xlkh_barcode = xlnsdet.xlns_last_bc
		    xlkh_hist.xlkh_trnbr = trnbr + 1
		    xlkh_hist.xlkh_date = s_period_date
		    xlkh_hist.xlkh_time = time
		    xlkh_hist.xlkh_userid = global_userid
		    xlkh_hist.xlkh_fpart = shift 
		    xlkh_hist.xlkh_seq = s_period 
		    xlkh_hist.xlkh_qc_qty = - xlnsdet.xlns_last_qc 
		    xlkh_hist.xlkh_rsn = substring(xlnsdet.xlns_last_bc, index(xlnsdet.xlns_last_bc, "qc") + 2)
                    xlkh_hist.xlkh_period = s_period 
		    xlkh_hist.xlkh_crt_date = today
		    xlkh_hist.xlkh_effdate = eff_date .
		    /* ss - 110307.1 -b */
             xlkh_hist.xlkh_char01[1] = execname.
              /* ss - 110307.1 -e */
/*ss - 1009016 - e*/

/*ss - 1009016 - e*/
/*不删除历史记录,改为新增一条负数的历史记录**********************************/
                     xlnsdet.xlns_tot_qc = xlnsdet.xlns_tot_qc - xlnsdet.xlns_last_qc .
		     xlnsdet.xlns_last_bc = p_bc .

		   find xlpd_det  where xlpd_domain = global_domain 
                            and xlpd_site = global_domain 
	                    and xlpd_line = pdln
	                   and xlpd_plan_date =  s_period_date
	                  and xlpd_period = s_period
			  and xlpd_part =  xlns_part

	                  no-error.
	                 if available xlpd_det then assign  xlpd_scrap_qty = xlpd_scrap_qty  - xlns_last_qc    xlpd_date  = today 
			       xlpd_time = time
/*ss - 100918.1 - B*/
                               xlpd_update = string(today) + string(time, "999999")
			       xlpd_uchar[2] = "xxkbbk04.p"
/*ss - 100918.1 - e*/    
                             . 
	                 else do:  create xlpd_det .
                               assign     xlpd_domain = global_domain 
                               xlpd_site = global_domain 
	                       xlpd_line = pdln
                               xlpd_part =  xlns_part
	                       xlpd_plan_date =  s_period_date
	                       xlpd_period = s_period  
	                       xlpd_scrap_qty = xlpd_scrap_qty - xlns_last_qc 
			       xlpd_date  = today 
			       xlpd_time = time 
/*ss - 100918.1 - B*/
                               xlpd_update = string(today) + string(time, "999999")
			       xlpd_uchar[2] = "xxkbbk04.p"
/*ss - 100918.1 - e*/    
                             .  
/*ss - 101205.1 - b*/
                                     find pt_mstr where pt_domain = global_domain 
					     and  pt_part = xlpd_part no-lock no-error.
                                      find ptp_det  where ptp_det.ptp_domain = global_domain 
					     and  ptp_part = xlpd_part and ptp_site = xlpd_site no-lock no-error.

					  if available ptp_det then do:
					     if ptp_routing > ""
					     then routing = ptp_routing.
					     else routing = ptp_part.
					  end.
					  else
					     routing = if pt_routing > "" then pt_routing else pt_part.

			        	find first ro_det where ro_domain = global_domain 
					 and ro_routing  = routing and ((ro_start <= eff_date or ro_start = ?)
					 and (ro_end   >= eff_date or ro_end   = ?)) no-lock no-error.
				      if available ro_det then do :
                                          xlpd_udec[3]   = ro_run.
			                  xlpd_udec[1] =   ro_setup.
 				      end .
				      else  assign  xlpd_udec[3]  =  0  xlpd_udec[1] = 0.
/*ss - 101205.1 - e*/

	                 end.
				       /*增加删除品质不良记录表*/
				     end.
				     else  do:
				        if xlnsdet.xlns_barcode1 <> "" then  do:

				             assign  xlnsdet.xlns_barcode1 = ""
				               xlnsdet.xlns_bc_date1 = today
					       xlnsdet.xlns_bc_time1 = 0.
				               xlnsdet.xlns_status   = xlnsdet.xlns_last_status.
					       xlnsdet.xlns_last_bc = p_bc .
					        xlnsdet.xlns_last_status = "".
/*ss - 111109.1 - b* mage*******/
                                        if (index(xlnsdet.xlns_barcode1, "DN") >= 1 ) then do:
                                            find first xald_det where  xald_domain = GLOBAL_domain 
		                               and   xald_site = global_domain	
				               and  xald_line = pdln
			                       and  xald_comedate <= today
				               and  xald_type = "DN"
				               and  not xald_closed 
				               and    xald_alertcode = substring(xlnsdet.xlns_barcode1, index(xlnsdet.xlns_barcode1, "DN") + 1)
				               no-error.
                                            if not available xald_det then do:                           
                                             /*  message  xlnc_desc "报警信息出错! 不能取消上一次操作!"  view-as alert-box  .
				               undo, retry .*/
			                    end.
			                    else do:
 				             assign xald_proddate = today
					            xald_prodtime = time                         		
 				                    xald_compdate = today
						    xald_comptime = time xald_close = yes
                                                 xald_update = string(today) + string(time, "999999").
					    end.
					 end.
					 else  if ( index(xlnsdet.xlns_barcode1, "DT") >= 1) then  do:
                                               find first xald_det where  xald_domain = GLOBAL_domain 
		                               and   xald_site = global_domain	
				               and  xald_line = pdln
			                       and  xald_comedate <= today
				               and  xald_type = "DT"
				               and  not xald_closed 
				               and    xald_alertcode = substring(xlnsdet.xlns_barcode1, index(xlnsdet.xlns_barcode1, "DT") + 1)
					       no-error.
                                            if not available xald_det then do:                           
                                              /* message  xlnc_desc "报警信息出错! 不能取消上一次操作!"  view-as alert-box  .
				               undo, retry .*/
			                    end.
			                    else do:
 				             assign xald_proddate = today
					            xald_prodtime = time                         		
 				                    xald_compdate = today
						    xald_comptime = time xald_close = yes
                                                 xald_update = string(today) + string(time, "999999").
					    end.
 
					 end. /*else  if ( index(xlns_barcode1, "DT") >= 1) then  do: */
/*ss - 111109.1 - e* mage*******/
                                         end.
				         else do:
				            message xlnsdet.xlns_part "不能取消上一次操作!".
				            next-prompt p_bc with frame a.
				            undo, retry.
				         end.
				     end.
				 end. /*for each ***/
				 /* release xlnsdet */ .
			      end. /*if index(p_bc, "OTCANCEL") >= 1 then do: */
                              else if index(p_bc, "QC") >= 1  then do:
			         for each xlnsdet where xlnsdet.xlns_domain = global_domain
				      and xlnsdet.xlns_site = global_domain
				      and xlnsdet.xlns_line = pdln,
				      each pt_mstr where pt_domain = global_domain 
				      and pt_part = xlnsdet.xlns_part: 
			             qc_qty = 0. 
				     xlnspart =  xlnsdet.xlns_part.
				     desc1  = pt_desc1 .
				     display  xlnspart  desc1   with frame a.
		                     update qc_qty with frame a.
				    if  qc_qty > 1000  or   qc_qty  <  - 1000  or  qc_qty = ? then do:
                                        message "次品数量大于(1000)  或  小于(-1000) 看板数量或 等于 "?"  !"  
				        VIEW-AS ALERT-BOX .
 				        next-prompt qc_qty with frame a .
                                        undo, retry .
                                     end. 
 /*检查同一周期是否有相关不良品回报****************************************************/
 if  qc_qty <  0  then do:  
              s_rel_qty = 0.
             for each xlkh_hist where 
		    xlkh_hist.xlkh_domain = global_domain  and
		    xlkh_hist.xlkh_site = site             and 
		    xlkh_hist.xlkh_line = xlnsdet.xlns_line  and 
		    xlkh_hist.xlkh_part = xlnsdet.xlns_part  and 
		    xlkh_hist.xlkh_barcode = p_bc   and 
 		    xlkh_hist.xlkh_date = s_period_date and
		    xlkh_hist.xlkh_period = s_period no-lock:
                   
		      s_rel_qty = s_rel_qty + xlkh_hist.xlkh_qc_qty  .
           end.

	   if s_rel_qty  + qc_qty < 0 then do:
                      message "本周期相同不良品原因的数量是"   s_rel_qty  skip(0)
 				    "负数回冲数量"  qc_qty   "请重输"
				     view-as alert-box .
  				        next-prompt qc_qty with frame a .
                                        undo, retry .
	   end.
 end. /*if  qc_qty <  0  then do:*/
/*检查同一周期是否有相关不良品回报****************************************************/
			             xlnsdet.xlns_tot_qc = xlnsdet.xlns_tot_qc + qc_qty .
				     xlnsdet.xlns_barcode3 = p_bc .
				     xlnsdet.xlns_last_bc = p_bc .
				     xlnsdet.xlns_last_qc  = qc_qty .

/*ss - 111210.1 - */	    if qc_qty > 0 then     assign   xlns_xdate[2] = today                       
   		                                            xlns_xtime[2] = time .
                                     
				      assign  
	                                   xlnsdet.xlns_date[1]  = s_period_date
	                                   xlnsdet.xlns_int[3]     =    s_period.  
                                     if qc_qty <> 0 then do:                                     
                                     trnbr = 0.
                                     find last xlkh_hist where xlkh_domain = global_domain
        			     	    use-index xlkh_trnbr no-lock no-error.
        			           if available xlkh_hist then do:
        			              trnbr =  xlkh_trnbr.
			             	end.
				           
        	   create xlkh_hist.
		  assign
		    xlkh_hist.xlkh_domain = global_domain
		    xlkh_hist.xlkh_site = site
		    xlkh_hist.xlkh_line = xlns_line
		    xlkh_hist.xlkh_part = xlns_part
		    xlkh_hist.xlkh_barcode = p_bc
		    xlkh_hist.xlkh_trnbr = trnbr + 1
		    xlkh_hist.xlkh_date = s_period_date
		    xlkh_hist.xlkh_time = time
		    xlkh_hist.xlkh_userid = global_userid
		    xlkh_hist.xlkh_fpart = shift 
                    xlkh_hist.xlkh_seq = s_period 
		    xlkh_hist.xlkh_qc_qty = qc_qty
		    xlkh_hist.xlkh_rsn = substring(p_bc, index(p_bc, "qc") + 2)
                    xlkh_hist.xlkh_period = s_period 
		    xlkh_hist.xlkh_crt_date = today
		    xlkh_hist.xlkh_effdate = eff_date.

/* ss - 110307.1 -b */
             xlkh_hist.xlkh_char01[1] = execname.
              /* ss - 110307.1 -e */
/*ss - 1009016 - e*/
					      find xlpd_det  where xlpd_domain = global_domain 
                            and xlpd_site = global_domain 
	                    and xlpd_line = pdln
	                   and xlpd_plan_date =  s_period_date
	                  and xlpd_period = s_period 
			  and xlpd_part =  xlns_part

	                  no-error.
	                 if available xlpd_det then assign  xlpd_scrap_qty = xlpd_scrap_qty  + qc_qty    xlpd_date  = today 
			       xlpd_time = time 
/*ss - 100918.1 - B*/
                               xlpd_update = string(today) + string(time, "999999")
			       xlpd_uchar[2] = "xxkbbk04.p"
/*ss - 100918.1 - e*/    
                             . 
	                 else do:  create xlpd_det .
                               assign     xlpd_domain = global_domain 
                               xlpd_site = global_domain 
	                       xlpd_line = pdln
                               xlpd_part =  xlns_part
	                       xlpd_plan_date =  s_period_date
	                       xlpd_period = s_period  
	                       xlpd_scrap_qty = xlpd_scrap_qty + qc_qty 
			         xlpd_date  = today 
			       xlpd_time = time 
/*ss - 100918.1 - B*/
                               xlpd_update = string(today) + string(time, "999999")
			       xlpd_uchar[2] = "xxkbbk04.p"
/*ss - 100918.1 - e*/    
                             . 
/*ss - 101205.1 - b*/
 
                                      find ptp_det  where ptp_det.ptp_domain = global_domain 
					     and  ptp_part = xlpd_part and ptp_site = xlpd_site no-lock no-error.

					  if available ptp_det then do:
					     if ptp_routing > ""
					     then routing = ptp_routing.
					     else routing = ptp_part.
					  end.
					  else
					     routing = if pt_routing > "" then pt_routing else pt_part.

			        	find first ro_det where ro_domain = global_domain 
					 and ro_routing  = routing and ((ro_start <= eff_date or ro_start = ?)
					 and (ro_end   >= eff_date or ro_end   = ?)) no-lock no-error.
				      if available ro_det then do :
                                          xlpd_udec[3]   = ro_run.
			                  xlpd_udec[1] =   ro_setup.
 				      end .
				      else  assign  xlpd_udec[3]  =  0  xlpd_udec[1] = 0.
/*ss - 101205.1 - e*/

	               end.
                                     end. /*if qc_qty <> 0 then do:*/
                                 end. /*for each ***************/
			      end.
			      else if index(p_bc, "OTREST")  >= 1 then do:
			      	for each xlnsdet where xlnsdet.xlns_domain = global_domain
				      and xlnsdet.xlns_site = global_domain
				      and xlnsdet.xlns_line = pdln : 
			      	     xlnsdet.xlns_last_status = xlnsdet.xlns_status.
			             /*记录第一次刷读时间*/
			             xlnsdet.xlns_barcode2 = xlnsdet.xlns_barcode1.
				     xlnsdet.xlns_bc_date2 = xlnsdet.xlns_bc_date1.
				     xlnsdet.xlns_bc_time2 = xlnsdet.xlns_bc_time1.
				     xlnsdet.xlns_barcode1 = p_bc.
				     xlnsdet.xlns_bc_date1 = today.
				     xlnsdet.xlns_bc_time1 = time.
				     xlnsdet.xlns_status   = "休息中". 
				     xlnsdet.xlns_last_bc  = p_bc.
                                end. /*for each xlnsdet **************/
			      end.
			      else if (index(p_bc, "SP") >= 1 or index(p_bc, "DT")  >= 1
			         or index(p_bc, "DN")  >= 1 ) then do:
				 /*产生相关报警信息   
              find first xlnc_mstr where xlnc_domain = global_domain 
	               and xlnc_line = pdln  
		       and xlnc_barcode = p_bc 
		       and (index(xlnc_barcode, "DT" )  >= 1 or index(xlnc_barcode, "DN" )  >= 1 )  no-lock no-error. 
               if available xlnc_mstr then do:
 	         create  xald_det .
		              assign xald_domain = GLOBAL_domain 
		                   xald_comedate = today 
				   xald_time     =  time
				   xald_site = global_domain
				   xald_line = pdln
				   xald_type = xlnc_type
				   xald_alertcode = xlnc_code
				   xald_desc = xlnc_desc
				   .
                                message  xlnc_desc "报警信息成功接收!" .	   
           end.
   产生相关报警信息*/
/*ss - 090601.1 - b*/
                  message "错误: 不可以接收的管理条码 "   .
/*ss - 090601.1 - e*/
 			      end.
			      else do: 
                                 message "错误: 目前可以接收的管理条码是  "  xlns_barcode1   .
                                 next-prompt p_bc with frame a.
                                 undo, retry.
		              end.
/*ss - 090601.1 - b*/
			      end. /*if index(p_bc, "OTOVER") >= 1 then do:   ... else do:*/
/*ss - 090601.1 - e*/

                          end. /*else do: /*不是第二次刷读同一条码*/ */
  		       end.   

                   end.  /* else do: /*是否是可以接收的条码*/ */		     
             
	       end. /* else  do: /*不是生产看板*/ */

	find first  xlns_det where xlns_domain = global_domain and xlns_site = global_domain  
	       and xlns_line = pdln no-error.

 /*相应的数据处理完成之后, 产生条码刷读历史记录********************************************************* 
              trnbr = 0.
              find last xlkh_hist where xlkh_domain = global_domain
        	    use-index xlkh_trnbr no-lock no-error.
              if available xlkh_hist then do:
                 trnbr =  xlkh_trnbr.
		end.
	      
              create xlkh_hist.
		  assign
		    xlkh_hist.xlkh_domain = global_domain
		    xlkh_hist.xlkh_site = site
		    xlkh_hist.xlkh_line = xlns_line
		    xlkh_hist.xlkh_part = xlns_part
		    xlkh_hist.xlkh_barcode = p_bc
		    xlkh_hist.xlkh_trnbr = trnbr + 1
		    xlkh_hist.xlkh_date = today
		    xlkh_hist.xlkh_time = time
		    xlkh_hist.xlkh_userid = global_userid
                    xlkh_hist.xlkh_seq = 0.

               last_bc = p_bc .
	       last_time = time .
 相应的数据处理完成之后, 产生条码刷读历史记录***********************************************************/

/*生产完成之后, 进行品质不良回报, 及 删除生产线状态记录***********************************************************/
                 release xlns_det.
              for each xlns_det where xlns_domain = global_domain and xlns_site = global_domain
		     and xlns_line = pdln
/*ss - 100519.1 -		     and ( xlns_rel_qty <= xlns_comp_qty or  xlns_kb_rel <= xlns_kb_comp)    */
/*ss - 100519.1 -	*/		   and  index(p_bc, "OTOVER")   >= 1 :
	              
		      if xlns_tot_qc > 0 then do:
   	         
 		         /*品质异常数量, 入库回冲*********/
                          assign
                                        wkctr              = ""
                                        mch                = ""
                                        dept               = ""
                                        um                 = ""
                                        conv               = 1
                                        qty_rjct           = 0
                                        rjct_rsn_code      = ""
                                        rejque_multi_entry = no
                                        to_op              = op
                                        qty_scrap          = 0
                                        scrap_rsn_code     = ""
                                        outque_multi_entry = no
                                        mod_issrc          = no
                                        start_run          = ""
                                        act_run_hrs        = 0
                                        stop_run           = ""
                                        earn_code          = ""
                                        rsn_codes          = ""
                                        quantities         = 0
                                        scrap_rsn_codes    = ""
                                        scrap_quantities   = 0
                                        reject_rsn_codes   = ""
                                        reject_quantities  = 0
                                        act_rsn_codes      = ""
                                        act_hrs            = 0
                                        prod_multi_entry   = no
                                        rsn                = ""
                                        act_run_hrs        = 0
                                        move_next_op       = yes
                                        act_setup_hrs      = 0
                                        setup_rsn          = ""
                                        act_multi_entry    = no
                                        act_setup_hrs20    = 0
                                        down_rsn_code      = ""
                                        stop_multi_entry   = no
                                        non_prod_hrs       = 0 .
					l_stat_undo        = no. 


 		         site = xlns_site.
		         emp = global_userid.
                         line = xlns_line.
		         part = xlns_part.
		         b_qc = "qc".
			 act_run_hrs = 0.
		         qty_proc = xlns_tot_qc .

/* ss-090401.1 -b */
				     if ln__chr03 = "" then do :
				         find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part = xlns_part no-lock no-error.

					  find ptp_det  where ptp_det.ptp_domain = global_domain and  ptp_part = xlns_part and ptp_site = site no-lock no-error.

					  if available ptp_det then do:
					     if ptp_routing > ""
					     then routing = ptp_routing.
					     else routing = ptp_part.
					  end.
					  else
					     routing = if pt_routing > "" then pt_routing else pt_part.

			        	find first ro_det where ro_domain = global_domain 
					 and ro_routing  = routing and ((ro_start <= eff_date or ro_start = ?)
					 and (ro_end   >= eff_date or ro_end   = ?)) no-lock no-error.
				     if available ro_det then do :
                                         assign
                                        wkctr              = ro_wkctr
                                        mch                = ro_mch
					std_run            = ro_run.
				      end .
				      end .
				     else do :
				     /* ss-090401.1 -e */
/*09/02/18*/	                    assign
                                        wkctr              = ln__chr03
                                        mch                = ln__chr04
					std_run            = 0.01.
				    /* ss-090401.1 -b */
				    end . /* ln_chr03 <> "" */
/* ss - 090513.1 - b*/
	for first wc_mstr
         fields( wc_domain wc_dept wc_desc wc_mch wc_wkctr)
          where wc_mstr.wc_domain = global_domain and  wc_wkctr = wkctr
           and wc_mch   = mch
      no-lock:
      end. /* FOR FIRST wc_mstr */
      if not available wc_mstr then do:
         message "工作中心不存在, 请检查相应的生产线设置" view-as alert-box.
	 undo, retry .
      end.

      dept = wc_dept.
      for first dpt_mstr
         fields( dpt_domain dpt_dept dpt_desc)
          where dpt_mstr.dpt_domain = global_domain and  dpt_dept = wc_dept
      no-lock:
      end. /* FOR FIRST dpt_mstr */
      if not available dpt_mstr then do:
         message "部门不存在, 请检查相应的生产线设置" view-as alert-box.
	 undo, retry .
      end.
/* ss - 090513.1 - b*/
				    
				  /* mage add 08/04/27 */    {xxtransbcmt21.i}  
 
                         {gprun.i ""xxkbbk04bcmt.p""
                               "(output upt_loc)"}
                         b_qc = "".
 			 /***
		         trnbr = 0.
                         find last xlkh_hist where xlkh_domain = global_domain
        	            use-index xlkh_trnbr no-lock no-error.
                         if available xlkhhist then do:
                            trnbr = xlkh_trnbr.
		          end.
                          **/
                       end. /*if xlns_tot_qc > 0 then do:*/
		              /*发送信息*********************************************** 

				rcp_user = global_domain + "rcp".
				rcp_file = "/home/" + rcp_user + "/" + rcp_user  + "msg1.txt" .
				output to  value(rcp_file).
				put unformatted  "                   生产线批量完成入库信息提示           " skip .
				put unformatted  " 生产线                  零件                   生产线库存数量   " skip .
				
				for each ld_det no-lock where ld_domain = global_domain and ld_site = xlns_site 
				      and ld_part = xlns_part   and ld_qty_oh >= 1,
				    each wc_mstr no-lock where wc_domain = global_domain
				      and wc_wkctr =  ld_loc  ,
				    each pt_mstr no-lock where pt_domain = global_domain 
				       and pt_part = xmpt_part :

				    find first ptp_det no-lock where ptp_domain = global_domain 
				       and ptp_part = xmpt_part no-error .  
 
				    if available ptp_det and ptp_ms  or not available ptp_det and pt_ms  then 
				       put unformatted wc_desc "   "   pt_desc1   pt_desc2   "           "   ld_qty_oh   skip.

				end. /*for each **/
		                output close. 
				unix silent value ("write "  + trim(rcp_user) + " < "  + trim(rcp_file)).
                               *发送信息***********************************************/
                               xlns_tot_qc  = 0 .
/*ss - 090601.1 - b*
        delete xlns_det .
*ss - 090601.1 - b*/
                                 assign
                                    xlns_start_date = ? 
				    xlns_start_time = 0
				    xlns_dec[3]     = 0
				    xlns_int[1]     = 0
				    xlns_tot_rest   = 0.

               find first xkb_mstr where xkb_domain = global_domain and xkb_site = xlns_site 
	            and xkb_part = xlns_part and   xkb_status = "P" no-lock no-error.

	       if ((xlns_rel_qty <= xlns_comp_qty or xlns_kb_rel <= xlns_kb_comp ) or  not available xkb_mstr  
	          and xlns_start_date = ? )  then 
	          delete xlns_det .

		       clear frame a all no-pause.
                   end.
 /*生产完成之后, 进行品质不良回报, 及 删除生产线状态记录***********************************************************/	    
                last_bc = p_bc .
	        last_time = time . 
		message "成功接收!".
		release xlns_det .
 		clear frame bx all no-pause.
		
		for each  xlns_det no-lock
		   where xlns_domain = global_domain and xlns_site = global_domain
	           and xlns_line = pdln,
	        each pt_mstr no-lock where pt_domain = global_domain 
	           and pt_part = xlns_part break by xlns_line with frame a:

	          if first-of(xlns_line) then        
	             display pdln
                     xlns_start_date                         
   		     string(xlns_start_time , "HH:MM:SS" ) @ xlns_start_time
                    /* xlns_tot_sp     
   		     xlns_chr[1]     
                     xlns_dec[1]     
                     xlns_chr[2]     
   		     xlns_dec[2]     
                     xlns_chr[3]     
                     xlns_dec[3]     
   		     xlns_tot_dn     
                     xlns_tot_dt  */   
 		     xlns_status
 		     with frame a . 
		     
		if first-of(xlns_line) then  do:
		find first ln_mstr where ln_mstr.ln_domain = global_domain
                   and ln_line =  pdln no-lock no-error.
            
	       if not available ln_mstr then do:
                   	       
                end. /* IF NOT AVAILABLE ln_mstr */
	        else display ln_desc with frame a.

               end.
              

               find last lnd_det no-lock where lnd_domain = global_domain 
		  and lnd_line = xlns_line and lnd_part = xlns_part 
	          and lnd_start <= today no-error .
/*ss - 090727.1 - b*	       
	       if available lnd_det and lnd_rate >= 0 then 
		  d_qty = xlns_tot_prod * lnd_rate - xlns_comp_qty .

   	       
	      display 
   		   xlns_part     label "产品编号" format "x(17)"       
                   pt_desc1      label "产品名称" FORMAT "X(24)"        
                   xlns_rel_qty  label "投产量"   format ">>>>>9"   
                   xlns_comp_qty label "完成量"   format ">>>>>9"   
   		   xlns_tot_Prod label "工时"     format ">>9.99" 
		   xlns_tot_qc   label "异常量"   format ">>>>>9"
                   d_qty         label "差异量"   format "->>>>9"
		   with frame bx  overlay  .  
		   down 1 with frame bx .
*ss - 090727.1 - b*/	       
/*ss - 090727.1 - b*/	       
	       
	      display 
   		   xlns_part     label "产品编号" format "x(17)"       
                   pt_desc1      label "产品名称" FORMAT "X(24)"        
                   xlns_rel_qty  label "投产量"   format ">>>>>9"   
                   xlns_comp_qty label "完成量"   format ">>>>>9"   
 		   xlns_tot_qc   label "异常量"   format ">>>>>9"
 		   with frame bx  overlay  .  
		   down 1 with frame bx .
/*ss - 090727.1 - b*/	    	       
             end. /*for each xlns_det *********/
/*minth 08/05/26*/	     		release xlns_det .
/*minth 08/05/26*/                        release xkb_mstr .
    	       p_bc = "".
	    end. /*do on error undo, retry with frame a: */
         end.  /* REPEAT */

	 