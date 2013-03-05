/* GUI CONVERTED from ictrrp02.p (converter v1.69) Sat Mar 30 01:15:39 1996 */
/* ictrrp02.p - zzicmtrhist.p 移库单转移结果报表                        */



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



define buffer trhist for tr_hist.
define var 	  isCopy   as char.


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
   site3          label {t001.i} colon 49 skip
   so_job         colon 20
   so_job1        label {t001.i} colon 49 skip
   rmks			  label "备注" colon 20
   rmks1 		  label {t001.i} colon 49 skip
   keeper		  label "保管员" colon 20
   keeper1		  label {t001.i} colon 49 skip
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
			tr_hist.tr_site  	label "调出地点" 
			trhist.tr_site  label "调入地点"
			tr_hist.tr_so_job  	label "销售/定制品"
			tr_hist.tr_rmks  	label "备注"
/*GL93*/ with STREAM-IO /*GUI*/  down  frame b 
/*GL93*/ width 132 attr-space.


/*GL93*/ FORM /*GUI*/ 
			space (3)
			tr_hist.tr_line format "999" label "序"
			tr_hist.tr_part 	label "零件" 
			pt_desc2	
			in__qadc01  label "保管员"
			tr_hist.tr_effdate label "转移日期"
			tr_hist.tr_loc 	label "调出库位"
			trhist.tr_qty_loc label "转移量"
			trhist.tr_loc label "调入库位"
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
	if so_job1 = hi_char then so_job1 = "".
	if rmks1 = hi_char then rmks1 = "".
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
   {mfquoter.i so_job      }
   {mfquoter.i so_job1     }
   {mfquoter.i site2        }
   {mfquoter.i site3        }
   {mfquoter.i rmks        }
   {mfquoter.i rmks1        }
   {mfquoter.i keeper        }
   {mfquoter.i keeper1        }


   if  nbr1 = "" then nbr1 = hi_char.
   if  trdate = ? then trdate = low_date.
   if  trdate1 = ? then trdate1 = hi_date.
	if part1 = "" then part1 = hi_char.
	if site1 = "" then site1 = hi_char.
	if site3 = "" then site3 = hi_char.
	if so_job1 = "" then so_job1 = hi_char.
	if rmks1 = "" then rmks1 = hi_char.
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

   for each tr_hist where tr_domain = "DCEC" and (tr_nbr >= nbr and tr_nbr <= nbr1 and tr_nbr <> "")
   and (tr_effdate >= trdate and tr_effdate <= trdate1)
   and (tr_part >= part) and (tr_part <= part1 or part1 = "")
   and (tr_so_job >= so_job) and (tr_so_job <= so_job1 or so_job1 = "")
   and (tr_rmks >= rmks and tr_rmks <= rmks1)
   and (tr_type = "ISS-TR")
   and (tr_site >= site and tr_site <= site1) /*2004-09-06 10:48*/  /*judy zz-> yy*/ 
      /* AND tr_program = "mfnewa3.p"*/
   exclusive-lock ,
   
   each in_mstr where in_domain = "DCEC" and in_site = tr_hist.tr_site 
   and in_part = tr_hist.tr_part 
   and (in__qadc01 >= keeper and in__qadc01 <= keeper1)
   no-lock

   break by tr_hist.tr_nbr by tr_hist.tr_effdate by tr_hist.tr_so_job by tr_hist.tr_rmks by integer(tr_hist.tr_line) with frame b down width 132:
   
	   find first
	   trhist no-lock where trhist.tr_domain = "DCEC" and
	   trhist.tr_type = "RCT-TR"
	   and trhist.tr_effdate = tr_hist.tr_effdate
	   and trhist.tr_nbr = tr_hist.tr_nbr
	   and trhist.tr_part = tr_hist.tr_part
	   and trhist.tr_so_job = tr_hist.tr_so_job
	   and trhist.tr_rmks = tr_hist.tr_rmks
	   and trhist.tr_site >= site2 and trhist.tr_site <= site3
	   and trhist.tr_qty_loc + tr_hist.tr_qty_loc = 0
	   and trhist.tr_trnbr > tr_hist.tr_trnbr
/*	   and trhist.tr_program = "" */
	   and trhist.tr_lot = tr_hist.tr_lot
	   and trhist.tr_userid = tr_hist.tr_userid no-error.
	
		if not available trhist then next.	

 		isCopy = if tr_hist.tr__log01 then "副本" else "原本".  /*打印标志*/
		tr_hist.tr__log01 = yes.
		
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
		
		if first-of(tr_hist.tr_nbr) or first-of(tr_hist.tr_effdate) or first-of(tr_hist.tr_so_job) 
			or first-of(tr_hist.tr_rmks)
		or newpage then do:
			page. /*2004-09-03 17:55*/
			newpage = no.
   			display 
   				tr_hist.tr_nbr 	
   				tr_hist.tr_site  	
   				trhist.tr_site
   				tr_hist.tr_so_job
   				tr_hist.tr_rmks
   			with frame b.
   			down 1 with frame b.
		end.

		find first pt_mstr where pt_domain = "DCEC" and pt_part = tr_hist.tr_part no-lock no-error.
/*		find first in_mstr where in_site = tr_hist.tr_site and in_part = tr_hist.tr_part no-lock no-error. 2004-09-07 09:36 lb01*/
		display
			tr_hist.tr_line
			tr_hist.tr_part 	 
			pt_desc2 when available pt_mstr	
			in__qadc01   
			tr_hist.tr_loc 	 
			trhist.tr_qty_loc  
			trhist.tr_loc  
			tr_hist.tr_effdate  
		with frame c.
		down 1 with frame c.
		put "------------------------------------------------------------------------------------------------" at 4.

		if last-of(tr_hist.tr_nbr) or last-of(tr_hist.tr_effdate) or last-of(tr_hist.tr_so_job) 
			or last-of(tr_hist.tr_rmks) then do:
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
/*GUI*/ {mfguirpb.i &flds=" nbr nbr1 trdate trdate1 part part1 site site1 site2 site3 so_job so_job1 rmks rmks1 keeper keeper1"} /*Drive the Report*/
