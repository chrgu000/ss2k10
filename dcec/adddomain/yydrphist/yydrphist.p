/* GUI CONVERTED from ictrrp02.p (converter v1.69) Sat Mar 30 01:15:39 1996 */
/* ictrrp02.p - zzicmtr_hist.p 移库单转移结果报表                        */
/* ss2012-8-14 升级*/


/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "f+ "}

define variable nbr like tr_nbr.
define variable nbr1 like tr_nbr.
define variable so_job like tr_so_job.
define variable so_job1 like tr_so_job.
define variable part like tr_part.
define variable part1 like tr_part.
define variable trnbr like tr_trnbr.
define variable trnbr1 like tr_trnbr.
define variable trdate like tr_effdate.
define variable trdate1 like tr_effdate.
define variable keeper	as char.
define variable keeper1 as char.

define variable type like glt_tr_type format "x(8)".
define variable desc1 like pt_desc1.
define variable old_order like tr_nbr.
define variable first_pass like mfc_logical.
define variable site like in_site.
define variable site1 like in_site.
define variable site2 like in_site.
define variable site3 like in_site.
define variable rmks  like tr_rmks.
define variable rmks1 like tr_rmks.
define variable newpage as logic initial no.

define variable pageno as integer initial 1.
DEFINE VARIABLE copyd  LIKE tr_qty_loc.
define var 	  isCopy   as char.
DEFINE VAR    flag1    AS LOGICAL.
DEFINE VAR    flag2    AS LOGICAL.

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
   nbr       format "x(8)"      label "移库单" colon 20 
   nbr1       format "x(8)"     label {t001.i} colon 49 skip
   trdate         label "生效日期" colon 20
   trdate1        label {t001.i} colon 49 skip
   part           colon 20
   part1          label {t001.i} colon 49 skip
   site           label "移出地点" colon 20
   site1          label {t001.i} colon 49 skip
   site2           label "移入地点" colon 20
   site3          label {t001.i} colon 49 SKIP
   keeper		  label "保管员" colon 20
   keeper1		  label {t001.i} colon 49 skip
   flag1          LABEL "只打印未打印的收货单"   COLON 30 SKIP
   flag2          LABEL "是否更新" COLON 30
 SKIP(.4)  /*GUI*/
with overlay frame a width 80 side-labels NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = " 选择条件 ".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME




     FORM /*GUI*/ 
        header
		"移库单"   at 48
        "页号:"        at 1  
      /*  string         (page-number - pageno) format "X(8)" */
      	string(pageno) format "x(8)"
        isCopy  no-label
       "东风康明斯发动机有限公司"        at 42
        with STREAM-IO /*GUI*/  frame phead page-top width 132 no-box.


/*GL93*/ FORM /*GUI*/ 
			space(17)
			tr_hist.tr_nbr 	label "移库单"
		 /*   tr_hist.tr_site  	label "调出地点"      */
			tr_hist.tr_site  label "地点"
			tr_hist.tr_ref_site  label "发货-至"
/*GL93*/ with STREAM-IO /*GUI*/  down  frame b 
/*GL93*/ width 132 attr-space.


/*GL93*/ FORM /*GUI*/ 
			space (3)
			tr_hist.tr_lot format "999" label "序"
			tr_hist.tr_part 	label "零件" 
			pt_desc2	
			in__qadc01  label "保管员"
			tr_hist.tr_effdate label "转移日期"
			tr_hist.tr_loc 	label "调出库位"
			copyd label "转移量"
			tr_hist.tr_loc label "调入库位"
/*GL93*/ with STREAM-IO /*GUI*/ down frame c 
/*GL93*/ width 132 attr-space.



/*GUI*/ {mfguirpa.i true  "printer" 132 }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:


   if nbr1 = hi_char then nbr1 = "".
   if trdate = low_date then trdate = ?.
   if trdate1 = hi_date then trdate1 = ?.
	if part1 = hi_char then part1 = "".
	if site1 = hi_char then site1 = "".
	if site3 = hi_char then site3 = "".
	if keeper1 = hi_char then keeper1 = "".
   
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


   bcdparm = "".
   {mfquoter.i nbr         }
   {mfquoter.i nbr1        }
   {mfquoter.i trdate      }
   {mfquoter.i trdate1     }
   {mfquoter.i part        }
   {mfquoter.i part1       }
   {mfquoter.i site        }
   {mfquoter.i site1       }
   {mfquoter.i site2        }
   {mfquoter.i site3        }
   {mfquoter.i keeper        }
   {mfquoter.i keeper1        }


   if  nbr1 = "" then nbr1 = hi_char.
   if  trdate = ? then trdate = low_date.
   if  trdate1 = ? then trdate1 = hi_date.
	if part1 = "" then part1 = hi_char.
	if site1 = "" then site1 = hi_char.
	if site3 = "" then site3 = hi_char.
	if keeper1 = "" then keeper1 = hi_char.

   /* SELECT PRINTER */
   
/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i  "printer" 132}
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:

/*

   {mfphead.i}
*/
 IF flag1 THEN DO:

   for each tr_hist where /*ss2012-8-14 b*/ tr_hist.tr_domain = global_domain and /*2012-8-14 e*/ (tr_nbr >= nbr and tr_nbr <= nbr1 and tr_nbr <> "")
   and (tr_effdate >= trdate and tr_effdate <= trdate1)
   and (tr_part >= part) and (tr_part <= part1 or part1 = "")
   and (tr_type = "ISS-DO")
   and (tr_site >= site and tr_site <= site1)
   AND (tr__chr01 <> 'Y')
 /* and (tr_program = "yyicmtrtr.p") 2004-09-06 10:48*/  /*judy zz-> yy*/ 
      /* AND tr_program = "mfnewa3.p"*/    
   exclusive-lock ,

   each in_mstr where /*2012-8-14 b*/ in_mstr.in_domain = global_domain and /*2012-8-14 e*/ in_site = tr_hist.tr_site
   and in_part = tr_hist.tr_part 
   and (in__qadc01 >= keeper and in__qadc01 <= keeper1)
   no-lock

   break by tr_hist.tr_nbr by tr_hist.tr_effdate by integer(tr_hist.tr_lot) with frame b down width 132:
     
      IF flag2 THEN
       UPDATE 
           tr__chr01 ='Y'.
      
  /*     find first
	   tr_hist no-lock where
	   tr_hist.tr_type = "RCT-TR"
	   and tr_hist.tr_effdate = tr_hist.tr_effdate
	   and tr_hist.tr_nbr = tr_hist.tr_nbr
	   and tr_hist.tr_part = tr_hist.tr_part
	   and tr_hist.tr_so_job = tr_hist.tr_so_job
	   and tr_hist.tr_rmks = tr_hist.tr_rmks
	   and tr_hist.tr_site >= site2 and tr_hist.tr_site <= site3
	   and tr_hist.tr_qty_loc + tr_hist.tr_qty_loc = 0
	   and tr_hist.tr_trnbr > tr_hist.tr_trnbr
/*	   and tr_hist.tr_program = "" */
	   and tr_hist.tr_lot = tr_hist.tr_lot
	   and tr_hist.tr_userid = tr_hist.tr_userid no-error.
	
		if not available tr_hist then next.	

 		isCopy = if tr_hist.tr__log01 then "副本" else "原本".  /*打印标志*/
		tr_hist.tr__log01 = yes.   */
		
		view frame phead.	
		
		if page-size - LINE-COUNTER - 4 < 0 then do:
			put
				skip(1)
				"主管 ________" at 10
				"保管员________" at 50
				"接收人________" at 90.
			pageno = pageno + 1.
			page.
			newpage = yes.
		end.
		
		if first-of(tr_hist.tr_nbr) or first-of(tr_hist.tr_effdate) 
			
		or newpage then do:
			page. /*2004-09-03 17:55*/
			newpage = no.
   			display 
   				tr_hist.tr_nbr 	
   				tr_hist.tr_site  	
   				tr_hist.tr_ref_site
   				
   			with frame b.
   			down 1 with frame b.
		end.

		find first pt_mstr where /*2012-8-14 b*/ pt_mstr.pt_domain = global_domain and /*2012-8-14 e*/ 
								pt_part = tr_hist.tr_part no-lock no-error. 								
/*		find first in_mstr where in_site = tr_hist.tr_site and in_part = tr_hist.tr_part no-lock no-error. 2004-09-07 09:36 lb01*/
            copyd = tr_qty_loc * (-1).
		display
			tr_hist.tr_lot
			tr_hist.tr_part 	 
			pt_desc2 when available pt_mstr	
			in__qadc01   
			tr_hist.tr_loc 	 
			copyd 
			tr_hist.tr_loc  
			tr_hist.tr_effdate  
		with frame c.
		down 1 with frame c.
		put "---------------------------------------------------------------------------------------------------" at 4.

		if last-of(tr_hist.tr_nbr) or last-of(tr_hist.tr_effdate)  then do:
			put
				skip(1)
				"主管 ________" at 10
				"保管员________" at 50
				"接收人________" at 90.
			pageno = 1.
			page.
		end.


/*GUI*/ {mfguirex.i } /*Replace mfrpexit*/

   end.

 END.

ELSE DO:

    for each tr_hist where /*ss2012-8-14 b*/ tr_hist.tr_domain = global_domain and /*2012-8-14 e*/ (tr_nbr >= nbr and tr_nbr <= nbr1 and tr_nbr <> "")
   and (tr_effdate >= trdate and tr_effdate <= trdate1)
   and (tr_part >= part) and (tr_part <= part1 or part1 = "")
   and (tr_type = "ISS-DO")
   and (tr_site >= site and tr_site <= site1)

 /* and (tr_program = "yyicmtrtr.p") 2004-09-06 10:48*/  /*judy zz-> yy*/ 
      /* AND tr_program = "mfnewa3.p"*/    
   exclusive-lock ,

   each in_mstr where /*2012-8-14 b*/ in_mstr.in_domain = global_domain and /*2012-8-14 e*/ in_site = tr_hist.tr_site
   and in_part = tr_hist.tr_part 
   and (in__qadc01 >= keeper and in__qadc01 <= keeper1)
   no-lock

   break by tr_hist.tr_nbr by tr_hist.tr_effdate by integer(tr_hist.tr_lot) with frame b down width 132:
   

      IF flag2 THEN
       UPDATE 
           tr__chr01 ='Y'.
  /*     find first
	   tr_hist no-lock where
	   tr_hist.tr_type = "RCT-TR"
	   and tr_hist.tr_effdate = tr_hist.tr_effdate
	   and tr_hist.tr_nbr = tr_hist.tr_nbr
	   and tr_hist.tr_part = tr_hist.tr_part
	   and tr_hist.tr_so_job = tr_hist.tr_so_job
	   and tr_hist.tr_rmks = tr_hist.tr_rmks
	   and tr_hist.tr_site >= site2 and tr_hist.tr_site <= site3
	   and tr_hist.tr_qty_loc + tr_hist.tr_qty_loc = 0
	   and tr_hist.tr_trnbr > tr_hist.tr_trnbr
/*	   and tr_hist.tr_program = "" */
	   and tr_hist.tr_lot = tr_hist.tr_lot
	   and tr_hist.tr_userid = tr_hist.tr_userid no-error.
	
		if not available tr_hist then next.	

 		isCopy = if tr_hist.tr__log01 then "副本" else "原本".  /*打印标志*/
		tr_hist.tr__log01 = yes.   */
		
		view frame phead.	
		
		if page-size - LINE-COUNTER - 4 < 0 then do:
			put
				skip(1)
				"主管 ________" at 10
				"保管员________" at 50
				"接收人________" at 90.
			pageno = pageno + 1.
			page.
			newpage = yes.
		end.
		
		if first-of(tr_hist.tr_nbr) or first-of(tr_hist.tr_effdate) 
			
		or newpage then do:
			page. /*2004-09-03 17:55*/
			newpage = no.
   			display 
   				tr_hist.tr_nbr 	
   				tr_hist.tr_site  	
   				tr_hist.tr_ref_site
   				
   			with frame b.
   			down 1 with frame b.
		end.

		find first pt_mstr where /*2012-8-14 b*/ pt_mstr.pt_domain = global_domain and /*2012-8-14 e*/ 
							pt_part = tr_hist.tr_part no-lock no-error.
/*		find first in_mstr where in_site = tr_hist.tr_site and in_part = tr_hist.tr_part no-lock no-error. 2004-09-07 09:36 lb01*/
		       copyd = tr_qty_loc * (-1). 
        display
			tr_hist.tr_lot
			tr_hist.tr_part 	 
			pt_desc2 when available pt_mstr	
			in__qadc01   
			tr_hist.tr_loc 	 
			copyd 
			tr_hist.tr_loc  
			tr_hist.tr_effdate  
		with frame c.
		down 1 with frame c.
		put "---------------------------------------------------------------------------------------------" at 4.

		if last-of(tr_hist.tr_nbr) or last-of(tr_hist.tr_effdate)  then do:
			put
				skip(1)
				"主管 ________" at 10
				"保管员________" at 50
				"接收人________" at 90.
			pageno = 1.
			page.
		end.


/*GUI*/ {mfguirex.i } /*Replace mfrpexit*/

   end.

 END.


/*
	put
	/*	skip(page-size - LINE-COUNTER - 2) */
		skip(1)
		"主管 ________" at 10
		"保管员________" at 50
		"接收人________" at 90.  */

   /* REPORT TRAILER */



/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/


end.

/*GUI*/ end procedure. /*p-report*/
/*GUI*/ {mfguirpb.i &flds=" nbr nbr1 trdate trdate1 part part1 site site1 site2 site3 keeper keeper1 flag1 flag2"} /*Drive the Report*/
