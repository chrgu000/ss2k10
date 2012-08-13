/*zzicmtrrp.p CRETATE BY LONG BO ,  2004/06/22                 */
/*移库单报表                                                   */


         /* DISPLAY TITLE */
/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

/*GI32*/ {mfdtitle.i "E"}


/* DEFINITION */

def var nbr like lad_nbr.
def var nbr1 like lad_nbr.
def new shared var tmpnbr like lad_nbr.
def new shared var keeper as char.
def new shared var keeper1 as char.
def new shared var site_from like lad_site.

def var sd like lad_user1.
def var sd1 like lad_user1.
def var rmks like lad_ref.
def var rmks1 like lad_ref.

def var prn_date as date initial today.

def new shared var pageno as integer initial 1. /*2004-09-07 15:03*/

def buffer laddet for lad_det. /*2004-09-06 10:06*/


form
	RECT-FRAME       AT ROW 1.4 COLUMN 1.25
	RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
	skip(.1)
	nbr 			colon 20 label "移库单"	format "x(8)"
	nbr1 			colon 50 label "至" format "x(8)"
	keeper			colon 20 label "保管员" 
	keeper1			colon 50 label "至"
	sd				colon 20 label "销售/定制品"
	sd1				colon 50 label "至"
	rmks			colon 20 label "备注"
	rmks1			colon 50 label "至"
	skip(.4)
with frame a side-labels width 80 NO-BOX THREE-D /*GUI*/.

DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*	 define var tmp_page as integer.*/
	 define var isCopy   as char.

     FORM /*GUI*/ 
        header
		"移库单(备料)"   at 48
        "页号:"        at 1  
   /*     string         (page-number) format "X(8)" */
   		string (pageno) format "x(8)"
        isCopy  no-label
       "东风康明斯发动机有限公司"        at 42
        with STREAM-IO /*GUI*/  frame phead page-top width 132 no-box.


/*GL93*/ FORM /*GUI*/ 
			space(17)
			lad_nbr    column-label "移库单"
			lad_site   column-label "调出地点" 
			lad_ord_site  COLUMN-LABEL "调入地点"
			lad_user1  column-label "销售/定制品"
			lad_ref  	COLUMN-LABEL "备注"
	/*		lad_user2  	label "创建用户" */
	       lad_line  	COLUMN-LABEL "创建日期"   
			prn_date	COLUMN-LABEL "打印日期"
/*GL93*/ with STREAM-IO /*GUI*/  down  frame b 
/*GL93*/ width 132 attr-space.
           /* SET EXTERNAL LABELS */
        /* setFrameLabels(frame b:handle).*/

	view frame a.

	
	mainloop:
	repeat:
		
/*GUI*/ if global-beam-me-up then undo, leave.
		
		hide frame b.
		hide frame c.
		
		if nbr1 = hi_char then nbr1 = "".
		if keeper1 = hi_char then keeper1 = "".
		if sd1 = hi_char then sd1 = "".
		if rmks1 = hi_char then rmks1 = "".
		
		update nbr nbr1 keeper keeper1 sd sd1 rmks rmks1 with frame a.
		
				
		bcdparm = "".
		
		{mfquoter.i nbr   }
		{mfquoter.i nbr1  }
		{mfquoter.i keeper   }
		{mfquoter.i keeper1  }
		{mfquoter.i sd  }
		{mfquoter.i sd1  }
		{mfquoter.i rmks  }
		{mfquoter.i rmks1  }
		
		if nbr1 = "" then nbr1 = hi_char.
		if keeper1 = "" then keeper1 = hi_char.
		if sd1 = "" then sd1 = hi_char.
		if rmks1 = "" then rmks1 = hi_char.

        {mfselprt.i "printer" 132}
		
		/*{mfphead.i} */
		
		for each lad_det exclusive-lock where lad_dataset = "itm_mstr"
			and lad_nbr >= nbr and lad_nbr <= nbr1 
			and lad_user1 >= sd and lad_user1 <= sd1
			and lad_ref >= rmks and lad_ref <= rmks1
			and can-find(first laddet where laddet.lad_nbr = lad_det.lad_nbr and
			                  laddet.lad_dataset = "itm_det" and laddet.lad_qty_all <> 0)
			break by lad_nbr:
     		
     		isCopy = if lad_lot = "Y" then "副本" else "原本".  /*打印标志*/
     		lad_lot = "Y".
     		
     		pageno = 1. 
     		
     		view frame phead.
			/*if not first-of(lad_nbr) then*/ page.
			tmpnbr = lad_nbr.
			site_from = lad_site.
			if page-size - LINE-COUNTER - 4 < 0 then page.
   			find usr_mstr no-lock where usr_userid = lad_user2 no-error.
   			display 
   				lad_nbr 	
   				lad_site  	
   				lad_ord_site
   				lad_user1  	
   				lad_ref  	
   			/*	(if available usr_mstr then usr_name else lad_user2) @ lad_user2  	*/
   				lad_line 
   				prn_date
   			with frame b.
   			down 1 with frame b.
     			    
			{gprun.i ""zzicmtrrpa.p""}
			
			down 1. 
			put
			/*	skip(page-size - LINE-COUNTER - 2) */
				skip(1)
				"主管 ________" at 10
				"保管员________" at 50
				"接收人________" at 90.
		        
		end. 

/*		
		put
		/*	skip(page-size - LINE-COUNTER - 2) */
			skip(1)
			"主管 ________" at 10
			"保管员________" at 50
			"接收人________" at 90.
	*/	

/*
/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/
  */
        
        {mfreset.i}
        
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

				   		
	end. /*repeat*/

