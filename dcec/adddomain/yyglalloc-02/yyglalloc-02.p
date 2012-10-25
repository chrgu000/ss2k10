/*********************************************************************
		���÷�̯����  - zzglalloc.p
		Create by Long Bo 	8/12/2004 9:31AM
	����������	
	1��	��ĩ��6B���6B������������Ϊ������������������÷�̯�ı�����
	����ͨ��.25.15.1�˵�����5101000�ʻ�����Ʒ��������-������������
	ͳ�ƣ��ֱ�ѡ����ʻ�1��2��ȡ������1/(1+2)��2/��1+2���ֱ�õ�6B
	���6B̯���ı�����5101000�ʻ�Ϊ���������ʻ�  
		5101000-1:6B����   
		5101000-2:��6B����
	��5101000-1Ϊ6B����Ϊ F1,��5101000��2Ϊ��6B����ΪF2.
	5101999Ϊ�����ۿ������ʻ�  
		5101999-1: 6B�ۿ�  ����ΪD1  
		5101999-2: ��6B�ۿ� ����ΪD2
        �������µĳ����ʻ�
	    5101800-1: 6B�ۿ�  ����ΪG1
		5101800-2: ��6B�ۿ�  ����ΪG1
	����ĳһ�������ʻ�������ΪA,���ʻ��ķ��ʻ�A-1��Ϊ��̯��6B�ķ���
	���ķ��� ���ʻ��ķ��ʻ�A-2��Ϊ��̯����6B�ķ������ķ��� ���ʻ���
	���ʻ�A-0:Ϊ��̯ǰ�Ĺ�������ͬʱҪ���ǳɱ����ĵ����⡣
	��ʽ���� ��   
		�ʻ�A��1�ķ�ֵ̯ �� (A��0)  *  (F1 - D1) / ( F1+ F2 - D1 - D2)     
		�ʻ�A��2�ķ�ֵ̯ �� (A��0)  *  (F2 - D2) / ( F1+ F2 - D1 - D2)  
	�������ʻ�Ҫ���з��÷�̯��    
		5501***             ��Բ�ͬ�ĳɱ�����Ҫ�ֱ��̯��
		5502***
		5503***
		
	2��	ͨ��.25.15.1�˵������ɱ����Ķ��ڼ�����ʻ������ʻ�Ϊ0�Ľ���ͳ��
	3��	���ڼ�����ʻ�ͳ�Ƶķ�����ֱ����6B���6B��̯�ı������ֱ��
	���ڼ�����ʻ������ʻ�1��2�У���������Ӧ��ƾ֤��
	
	������棺
	------------------------------------------------
			��Ч����:________
			��̯�ڼ�:________		����_______
	
									�����______
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
		define variable p1	as decimal format ">9.9999".	/* ���˻�1�ķ�̯����*/
		define variable p2  as decimal format ">9.9999".
		define variable v0  like gltr_amt. /*����̯*/
		define variable v1  like gltr_amt. /*���˻�2�ķ�ֵ̯*/
		define variable v2	like gltr_amt. /*���˻�2�ķ�ֵ̯*/
		define variable tmpv like gltr_amt. /*��ʱֵ��Ϊ��ȷ��ʾ��*/
		
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
	  effdate	colon 25	label "��Ч����"
	  perdt_from colon 25 label "��̯�ڼ�"
	  perdt_to	colon 45
	  label {t001.i} skip
	  acct 	colon 25	label "��̯�˻�"
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
     	p1 colon 19 label "��̯����"
     	p2 colon 46 no-label skip(1)
		ref colon 10 no-label 
     with STREAM-IO /*GUI*/  frame pref side-label width 132 no-box.

/*GL93*/ FORM /*GUI*/ 
			space(15)
			xxacct 
			xxcc
			sub			
			xxv0 label "���"
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
			message "������������".
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
		
		/*����6B��������*/
		{yyglasccal.i ""5101000"" ""1"" ""?"" f1}          /*judy  zz-> yy*/
		
		/*�����6B��������*/
		{yyglasccal.i ""5101000"" ""2"" ""?"" f2}          /*judy  zz-> yy*/
		
		/*�ۿ�*/
		{yyglasccal.i ""5101999"" ""1"" ""?"" d1}          /*judy  zz-> yy*/
		{yyglasccal.i ""5101999"" ""2"" ""?"" d2}          /*judy  zz-> yy*/

        {yyglasccal.i ""5101800"" ""1"" ""?"" g1}          /*fm268  zz-> yy*/
		{yyglasccal.i ""5101800"" ""2"" ""?"" g2}          /*fm268  zz-> yy*/
		
		
		/*�����̯���� */
/*		if ( F1 + F2 - D1 - D2) <> 0 then
		p1 =  (F1 - D1) / ( F1 + F2 - D1 - D2).
		else p1 = 1. */
		/*2004-09-06 16:35*/
		if ( F1 + F2 + D1 + D2 + g1 + g2) <> 0 then
		p1 =  (F1 + D1 + g1) / ( F1 + F2 + D1 + D2 + g1 + g2).
		else p1 = 1.
		
		/*��̯*/
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
		disp f1 f2 d1 d2 g1 g2 p1 p2 "׼����̯����" @ ref with frame pref.
		
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

		message "ȷ�Ϸ�̯" view-as alert-box question buttons yes-no update up_yn.
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


		/* �����˲ο���*/

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
			message "ִ��ʧ�ܡ�" view-as alert-box.
		else do:
			message string("��̯����������ο��ţ�" + ref) view-as alert-box.
		end.
		if ref = "" then 
			message "ִ��ʧ�ܡ�" .
		else do:
			message string("��̯����������ο��ţ�" + ref).
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
					 (if (available glt_det or available gltr_hist) then "�ɹ�" else "ʧ��") @ msg
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
					 (if (available glt_det or available gltr_hist) then "�ɹ�" else "ʧ��") @ msg
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
					 (if (available glt_det or available gltr_hist) then "�ɹ�" else "ʧ��") @ msg
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
