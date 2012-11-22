/*********************************************************************
		费用分摊程序  - zzglalloc.p
		Create by Long Bo 	8/12/2004 9:31AM
	需求描述：	
	1、	月末以6B与非6B发动机的收入为基数，计算出公共费用分摊的比例。
	可以通过.25.15.1菜单，对5101000帐户（产品销售收入-发动机）进行
	统计，分别选择分帐户1、2，取数。按1/(1+2)与2/（1+2）分别得到6B
	与非6B摊销的比例。5101000帐户为销售收入帐户  
		5101000-1:6B收入   
		5101000-2:非6B收入
	设5101000-1为6B收入为 F1,设5101000－2为非6B收入为F2.
	5101999为销售折扣折让帐户  
		5101999-1: 6B折扣  设其为D1  
		5101999-2: 非6B折扣 设其为D2
        加入了新的出口帐户
	    5101800-1: 6B折扣  设其为G1
		5101800-2: 非6B折扣  设其为G1
	对于某一个费用帐户，设其为A,该帐户的分帐户A-1：为分摊到6B的发动
	机的费用 该帐户的分帐户A-2：为分摊到非6B的发动机的费用 给帐户的
	分帐户A-0:为分摊前的公共费用同时要考虑成本中心的问题。
	公式如下 ：   
		帐户A－1的分摊值 ＝ (A－0)  *  (F1 - D1) / ( F1+ F2 - D1 - D2)     
		帐户A－2的分摊值 ＝ (A－0)  *  (F2 - D2) / ( F1+ F2 - D1 - D2)  
	如下主帐户要进行费用分摊：    
		5501***             针对不同的成本中心要分别分摊。
		5502***
		5503***
		
	2、	通过.25.15.1菜单，按成本中心对期间费用帐户，子帐户为0的进行统计
	3、	按期间费用帐户统计的发生额，分别乘以6B与非6B分摊的比例，分别记
	入期间费用帐户，子帐户1、2中，并生成相应的凭证。
	
	输入界面：
	------------------------------------------------
			生效日期:________
			分摊期间:________		至：_______
	
									输出：______
	------------------------------------------------
	
************************************************************************/
/*rev: eb2 + sp7    last modified: 2005/08/30           by: judy liu*/
/* $Revision:eb21sp12  $ BY: Jordan Lin            DATE: 09/06/12  ECO: *SS-20120906.1*   */



/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

/*H156*/  {mfdtitle.i "120906.1"}

		
		define variable effdate as date.
		define variable perdt_from as date.
		define variable perdt_to  as date.
		
		define variable acct as char initial "5501".
		define variable acct1 as char initial "5503999".
		
		define variable f1	like gltr_amt.
		define variable f2	like gltr_amt.
		define variable d1	like gltr_amt.
		define variable d2	like gltr_amt.
                define variable g1	like gltr_amt.
		define variable g2	like gltr_amt.
		define variable p1	as decimal format ">9.9999".	/* 分账户1的分摊比例*/
		define variable p2  as decimal format ">9.9999".
		define variable v0  like gltr_amt. /*待分摊*/
		define variable v1  like gltr_amt. /*分账户2的分摊值*/
		define variable v2	like gltr_amt. /*分账户2的分摊值*/
		define variable tmpv like gltr_amt. /*临时值，为正确显示用*/
		
		define variable ref like glt_ref.
		define variable sub like gltr_sub.

		define variable up_yn as logic.
		
		define stream batchdata.
		
		def workfile xxwk						
			field xxacct 	like ac_code
			field xxcc		like asc_cc
			field xxv0		like gltr_amt
			field xxv1		like gltr_amt
			field xxv2		like gltr_amt
    	.
	  
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
	  
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(1)  /*GUI*/
	  effdate	colon 25	label "生效日期"
	  perdt_from colon 25 label "分摊期间"
	  perdt_to	colon 45
	  label {t001.i} skip
	  acct 	colon 25	label "分摊账户"
	  acct1 colon 45	label {t001.i}
	  skip
/*FQ80*/  with frame a side-labels attr-space width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME

     FORM /*GUI*/ 
     	skip(1)
     	f1 colon 20 label "5101000-1"
     	f2 colon 50 label "5101000-2"
     	d1 colon 20 label "5101999-1"
     	d2 colon 50 label "5101999-2"
        g1 colon 20 label "5101800-1"
     	g2 colon 50 label "5101800-2"
     	skip(1)
     	p1 colon 19 label "分摊比例"
     	p2 colon 46 no-label skip(1)
		ref colon 10 no-label 
     with STREAM-IO /*GUI*/  frame pref side-label width 132 no-box.

/*GL93*/ FORM /*GUI*/ 
			space(15)
			xxacct 
			xxcc
			sub			
			xxv0 label "金额"
/*GL93*/ with STREAM-IO /*GUI*/  down  frame b 
/*GL93*/ width 132 attr-space.



		/* find period and effdate */
		
		find first glc_cal  no-lock
		where  /* *SS-20120906.1*   */ glc_cal.glc_domain = global_domain and  glc_start <= today and glc_end >= today 
		no-error.
		if available glc_cal then
			find prev glc_cal no-lock where glc_domain = global_domain no-error.
		else
			find last glc_cal no-lock where glc_domain = global_domain no-error.
				
		if not available glc_cal then do:
			message "总帐日历错误".
			pause 3.
			return.
		end.
		
		effdate = glc_end.
		perdt_from = glc_start.
		perdt_to = glc_end.
		

	  /* REPORT BLOCK */
	repeat:

		display effdate perdt_from perdt_to acct acct1 with frame a.

		set effdate perdt_from perdt_to	acct acct1
		with frame a.
	/*	if peryr = "" then do:
		   {mfmsg.i 3018 3} /*DATE NOT WITHIN A VALID PERIOD */
		   next-prompt enddt with frame a.
		   undo, retry.
		end. */

	     /* CREATE BATCH INPUT STRING */
	     bcdparm = "".
	     {mfquoter.i effdate   }
	     {mfquoter.i perdt_from  }
	     {mfquoter.i perdt_to    }
	     {mfquoter.i acct    }
	     {mfquoter.i acct1    }
	     

	     /* SELECT PRINTER */
	     {mfselbpr.i "printer" 132}
/*GUI*/ RECT-FRAME:HEIGHT-PIXELS in frame a = FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.

	     {mfphead.i}
		
		/*计算6B销售收入*/
		{yyglasccal.i ""5101000"" ""1"" ""?"" f1}          /*judy  zz-> yy*/
		
		/*计算非6B销售收入*/
		{yyglasccal.i ""5101000"" ""2"" ""?"" f2}          /*judy  zz-> yy*/
		
		/*折扣*/
		{yyglasccal.i ""5101999"" ""1"" ""?"" d1}          /*judy  zz-> yy*/
		{yyglasccal.i ""5101999"" ""2"" ""?"" d2}          /*judy  zz-> yy*/

        {yyglasccal.i ""5101800"" ""1"" ""?"" g1}          /*fm268  zz-> yy*/
		{yyglasccal.i ""5101800"" ""2"" ""?"" g2}          /*fm268  zz-> yy*/
		
		
		/*计算分摊比例 */
/*		if ( F1 + F2 - D1 - D2) <> 0 then
		p1 =  (F1 - D1) / ( F1 + F2 - D1 - D2).
		else p1 = 1. */
		/*2004-09-06 16:35*/
		if ( F1 + F2 + D1 + D2 + g1 + g2) <> 0 then
		p1 =  (F1 + D1 + g1) / ( F1 + F2 + D1 + D2 + g1 + g2).
		else p1 = 1.
		
		/*分摊*/
		output stream batchdata to value("c:\yyglalloc.tmp") no-echo.  /*judy  zz-> yy*/
		/*header*/
		put stream batchdata "-".
		put stream batchdata effdate at 1.
		put stream batchdata "-" at 1.
		
		for each xxwk:
			delete xxwk.
		end.
		
		/*detail*/
		for each ac_mstr no-lock where  /* *SS-20120906.1*   */ ac_mstr.ac_domain = global_domain and  ac_code >= acct and ac_code <= acct1,
		each cc_mstr no-lock  
		:
			{yyglasccal.i ac_code ""0"" cc_ctr v0}      /*judy  zz-> yy*/

			if v0 = 0 then next.
			v1 = v0 * p1.
			v1 = round(v1,2).
			
			v2 = v0 - v1.
			create xxwk.
			assign
				xxacct 	= ac_code
				xxcc	= cc_ctr
				xxv0	= v0
				xxv1	= v1
				xxv2	= v2.
				
			put stream batchdata	"-" at 1.
			put stream batchdata	"""" at 1 ac_code  """ ""0"" """ cc_ctr """".
			if v0 > 0 then
                /*put stream batchdata	"- - - no" at 1.*/  /*judy*/
                put stream batchdata  "- no" AT 1.
			else
				/*put stream batchdata	"- - - yes" at 1.*/ /*judy*/
                put stream batchdata  "- yes" AT 1.
            put stream batchdata  "-"  AT 1.   /*judy*/
            put stream batchdata  "-"  AT 1.   /*judy*/

			tmpv = ABSOLUTE(v0).
			put stream batchdata  tmpv at 1.

			put stream batchdata	"-" at 1.
			put stream batchdata	"""" at 1 ac_code  """ ""1"" """ cc_ctr """".
			if v0 > 0 then
                /*put stream batchdata	"- - - yes" at 1.*/  /*judy*/
                 put stream batchdata  "- yes" AT 1.
			else
				/*put stream batchdata	"- - - no" at 1.*/  /*judy*/
			    put stream batchdata  "- no" AT 1.
            put stream batchdata  "-"  AT 1.   /*judy*/
            put stream batchdata  "-"  AT 1.   /*judy*/
        
			tmpv = ABSOLUTE(v1).
			put stream batchdata  tmpv at 1.
	/*		put stream batchdata	ABSOLUTE(v1) at 1. */
			
			put stream batchdata	"-" at 1.
			put stream batchdata	"""" at 1 ac_code  """ ""2"" """ cc_ctr """".
			if v0 > 0 then
                /*put stream batchdata	"- - - yes" at 1.*/  /*judy*/
                 put stream batchdata  "- yes" AT 1.
			else
                /*put stream batchdata	"- - - no" at 1.*/  /*judy*/
			    put stream batchdata  "- no" AT 1.
            put stream batchdata  "-"  AT 1.   /*judy*/
            put stream batchdata  "-"  AT 1.   /*judy*/

            tmpv = ABSOLUTE(v2).
			put stream batchdata  tmpv at 1.
/*			put stream batchdata	ABSOLUTE(v2) at 1.*/
			
		end.		
		put stream batchdata "."  at 1.
		put stream batchdata "."  at 1.
		
		output stream batchdata close.
		
		up_yn = no.
		p2 = 1 - p1.
		disp f1 f2 d1 d2 g1 g2 p1 p2 "准备分摊数据" @ ref with frame pref.
		
		for each xxwk:
			up_yn = yes.
			disp xxacct
				 xxcc
				 "0" @ sub
				 (0 - xxv0) @ xxv0
			with frame b.
			down 1 with frame b.				
			disp "" @ xxacct
				 "" @ xxcc
				 "1" @ sub
				 (  xxv1) @ xxv0
			with frame b.
			down 1 with frame b.				
			disp "" @ xxacct
				 "" @ xxcc
				 "2" @ sub
				 (  xxv2) @ xxv0
			with frame b.
			down 1 with frame b.				
		end.

/*GUI*/ {mfguirex.i } /*Replace mfrpexit*/

	     /* REPORT TRAILER */
	     {mfrtrail.i}
		
		if not up_yn then do:
			undo, retry.
		end.

		message "确认分摊" view-as alert-box question buttons yes-no update up_yn.
		if not up_yn then undo, retry.


		find co_ctrl no-lock no-error.
		
/*G703*/           if co_daily_seq then
                      ref = "JL" + substring(string(year(today),"9999"),3,2)
                         + string(month(today),"99") + string(day(today),"99").
/*G703*/           else ref = "JL".

/*H0PS           find last glt_det no-lock where glt_ref begins ref no-error. */
/*H0PS*/           find last glt_det no-lock where  /* *SS-20120906.1*   */ glt_det.glt_domain = global_domain and  glt_ref >= ref
/*H0PS*/           and glt_ref <= ref + fill(hi_char,14) no-error.

/*H0PS             find last gltr_hist no-lock where gltr_ref begins ref */
/*H0PS*/           find last gltr_hist no-lock where /* *SS-20120906.1*   */ gltr_hist.gltr_domain = global_domain and  gltr_ref >= ref
/*H0PS*/           and gltr_ref <= ref + fill(hi_char,14)
                   no-error.
/*H0RW*/           if co_daily_seq then do: /* IF DAILY */
		     ref = max(ref + string(0, "999999"),
                           max(if available glt_det then glt_ref else "",
                           if available gltr_hist then gltr_ref else "")).
 
/*H0RW*/           end. /* IF DAILY */

/*H0RW*/           else do:  /* IF CONTINUOUS */
/*H0RW*/             ref = max(ref + string(0,"999999999999"),
/*H0RW*/                   max(if available glt_det then glt_ref else "",
/*H0RW*/                   if available gltr_hist then gltr_ref else "")).
 
/*H0RW*/           end. /* IF CONTINUOUS */
 
	 		
		

		/* CIM LOAD */
		batchrun = yes.
		input from value("c:\yyglalloc.tmp") no-echo.               /*judy  zz-> yy*/
		output to value("c:\yyglalloc.out") keep-messages.          /*judy  zz-> yy*/
		
		{gprun.i ""chgltrmt.p""} 
		
		hide message no-pause.
		
		output close.
		input close.

		batchrun = no.


		/* 找总账参考号*/

		find first glt_det no-lock where  /* *SS-20120906.1*   */ glt_det.glt_domain = global_domain 
		and  glt_ref > ref
		and glt_effdate = effdate
		and glt_date = today
		and glt_userid = global_userid
		and can-find(first xxwk where xxacct = glt_acct) no-error.
		
		if not available glt_det then do:
	 		find last gltr_hist no-lock where /* *SS-20120906.1*   */ gltr_hist.gltr_domain = global_domain 
			and gltr_ref >= ref
			and gltr_eff_dt = effdate
			and gltr_ent_dt = today
			and gltr_user = global_userid 
			and can-find(first xxwk where xxacct = glt_acct)
			no-error.
		end.
		
		ref = if available glt_det then glt_ref else (if available gltr_hist then gltr_ref else "")	.	

		if ref = "" then 
			message "执行失败。" view-as alert-box.
		else do:
			message string("分摊结束，请检查参考号：" + ref) view-as alert-box.
		end.
		if ref = "" then 
			message "执行失败。" .
		else do:
			message string("分摊结束，请检查参考号：" + ref).
		end.
/*			for each xxwk:
				find first glt_det where glt_ref = ref
				and glt_acct = xxacct and glt_sub = "0"
				and glt_cc = xxcc and glt_effdate = effdate no-lock no-error.
				if not available glt_det then 
					find first gltr_hist where gltr_ref = ref
					and gltr_acc  = xxacct and gltr_sub = "0"
					and gltr_ctr = xxcc and gltr_eff_dt = effdate no-lock no-error.
				
				disp xxacct
					 xxcc
					 v0
					 (if (available glt_det or available gltr_hist) then "成功" else "失败") @ msg
				with frame b.
				down 1 with frame b.				
				
				find first glt_det where glt_ref = ref
				and glt_acc  = xxacct  and glt_sub = "1"
				and glt_cc = xxcc and glt_effdate = effdate no-lock no-error.
				if not available glt_det then 
					find first gltr_hist where gltr_ref = ref
					and gltr_acc  = xxacct and gltr_sub = "1"
					and gltr_ctr = xxcc and gltr_eff_dt = effdate no-lock no-error.
				
				disp xxacct
					 xxcc
					 v1 @ v0
					 (if (available glt_det or available gltr_hist) then "成功" else "失败") @ msg
				with frame b.
				down 1 with frame b.				
				
				find first glt_det where glt_ref = ref
				and glt_acct = xxacct and glt_sub = "2"
				and glt_cc = xxcc and glt_effdate = effdate no-lock no-error.
				if not available glt_det then 
					find first gltr_hist where gltr_ref = ref
					and gltr_acc  = xxacct and gltr_sub = "2"
					and gltr_ctr = xxcc and gltr_eff_dt = effdate no-lock no-error.
				
				disp xxacct
					 xxcc
					 v2 @ v0
					 (if (available glt_det or available gltr_hist) then "成功" else "失败") @ msg
				with frame b.
				down 1 with frame b.				
				
			end.
		end.
		
		*/
/*		
/*GUI*/ {mfguirex.i } /*Replace mfrpexit*/

	     /* REPORT TRAILER */
	     {mfrtrail.i}
*/
	  end.
