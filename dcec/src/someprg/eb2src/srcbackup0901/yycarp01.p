/*zzcarp01.p	CREATE BY LONG BO 2004 JUN 21					*/
/*																*/
/*	合同评审报表												*/
/*	FUNCTION - 输入成品和数量，计算库存和计划是否满足需要		*/

         /* DISPLAY TITLE */
/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

/*GI32*/ {mfdtitle.i "E"}


/* DEFINITION */

def new shared var y# as integer.
def new shared  var m# as integer.
def new shared  var nbr as char.
def  var new_wkfl as logic.
def var del-yn as logic.
def var ifo_yn as logic.
def var site as logic format "B/C".  /*Y-B, N-C*/

define variable sw_reset like mfc_logical.

/*lb01*/
def new shared var effdate as date label "月度计划发布日期".
def new shared var mstart as date label "月度范围".		/*月度开始日期 */
def new shared var mend as date.		/*月度结束日期 */
/*lb01*/


form
	RECT-FRAME       AT ROW 1.4 COLUMN 1.25
	RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
	skip(.1)
	usrw_key1	colon 22 label "评审模板"
	y# colon 42 label "月度" format "9999" "年"
	m# no-label format "99" "月"
	skip
	site	colon 22 label "地点DCEC-B/DCEC-C"
	skip
	effdate	colon 22 
	mstart  colon 42
	mend	colon 55 label "至"
	skip(.4)
with frame a side-labels width 80 NO-BOX THREE-D /*GUI*/.

DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/********************************************

			usrw_key1		usrw_key2		usrw_key3		usrw_key4
MSTR		nbr				ORDER-TEST-MSTR	ORDER-TEST-MSTR	site b/c
DET			nbr				part			ORDER-TEST-DET	part desc1





********************************************/



	view frame a.
	
	mainloop:
	repeat:
		
/*GUI*/ if global-beam-me-up then undo, leave.

	    do transaction on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

	       /*GUI: view frame dtitle. */
IF global-tool-bar AND global-tool-bar-handle <> ? THEN
  view global-tool-bar-handle. /*GUI*/
		
			view frame a.
			prompt-for usrw_key1 with frame a editing:

/*G716*/          /* Allow last PO number refresh */
/*G716*/          if keyfunction(lastkey) = "RECALL" or lastkey = 307
/*G716*/           then display nbr @ usrw_key1 with frame a.

		  /* FIND NEXT/PREVIOUS  RECORD */
/*FS95*/             {mfnp06.i
				usrw_wkfl
				usrw_index1
				"usrw_key2 = ""ORDER-TEST-MSTR"""
				usrw_key1
				"input usrw_key1"
				yes
				yes }

				if recno <> ? then do:
					display 
						(usrw_key4 = "B") @ site
						usrw_key1		
	 				with frame a.
				end.  /* IF RECNO <> ? */

			end. /* PROMPT-FOR...EDITING */

			if input usrw_key1 <> "" then nbr = input usrw_key1.
			if input usrw_key1 = "" then do:
				message "不允许为空".
				next-prompt usrw_key1 with frame a.
				undo, retry.	            
			end.  
			
			display nbr @ usrw_key1 with frame a. 
		
			find usrw_wkfl where usrw_key1 = nbr and usrw_key2 = "ORDER-TEST-MSTR" 
			exclusive-lock no-error.
			if not available usrw_wkfl then do :
				{mfmsg.i 1 1}
				new_wkfl = yes.
				create usrw_wkfl.
				assign usrw_key1  = nbr
				       usrw_key2  = "ORDER-TEST-MSTR"
				       usrw_key3  = "ORDER-TEST-MSTR".
			end.                           
	       	else do:        
				new_wkfl = no.
				{mfmsg.i 10 1}
			end.
			
			display 
				(usrw_key4 = "B") @ site
				usrw_key1	
			with frame a.

			if y# = 0 or m# = 0 then do:
				if y# = 0 then y# = year(today).
				if m# = 0 then m# = month(today).
	/*
				if m# = 12 then assign m# = 1 y# = y# + 1.
					else assign m# = m# + 1.
	*/		end.
			

			
			mstart = today - day(today) - 1. /*上个月最后一天*/
			mstart = mstart + 28 - day(mstart). /*月的28号*/
			
			mend = today + 27 - day(today).  /*这个月的27号*/

			effdate = mstart.						
	
			display mstart mend effdate with frame a.

			display (usrw_key4 = "B") @ site y# m# with frame a.			
			view frame a.

			sets:
			do on error undo, retry:
		if global-beam-me-up then undo, leave.
		    
	       		set site effdate mstart mend
	          	go-on ("F5" "CTRL-D") with frame a editing:
					readkey.
					apply lastkey.
				end. /*editing*/
	
		       	/* DELETE */
		       	if new_wkfl = no and (lastkey = keycode("F5") or lastkey = keycode("CTRL-D"))
		       	then do:
					/*delete*/
					del-yn = yes.
					{mfmsg01.i 11 1 del-yn}
					if del-yn then do:
						for each usrw_wkfl where usrw_key1 = nbr and usrw_key3 = "ORDER-TEST-DET":
							delete usrw_wkfl. /*detail*/
						end.
						for each usrw_wkfl where usrw_key1 = nbr and usrw_key2 = "ORDER-TEST-MSTR":
							delete usrw_wkfl.
						end.
						clear frame a.		
						next mainloop.						
					end.
					else do :
						next-prompt y# with frame a.
						undo,retry.
					end.
				end.

				if y# < 1990 or y# > 3000 then do:
					message "错误的年度范围，请重新输入" view-as alert-box.
					next-prompt y# with frame a.
					undo, retry sets.
				end.
					   	
				if m# < 1 or m# > 12 then do:
					message "错误的月份范围，请重新输入" view-as alert-box.
					next-prompt m# with frame a.
					undo, retry sets.
				end.
				
				if effdate = ? then do:
					message "日期必须输入" view-as alert-box.
					next-prompt effdate with frame a.
					undo, retry sets.
				end.
				if mstart = ? then do:
					message "日期必须输入" view-as alert-box.
					next-prompt mstart with frame a.
					undo, retry sets.
				end.
				if mend = ? then do:
					message "日期必须输入" view-as alert-box.
					next-prompt mend with frame a.
					undo, retry sets.
				end.
				if mend - mstart < 0 then do:
					message "日期错误，请重新输入" view-as alert-box.
					next-prompt mstart with frame a.
					undo, retry sets.
				end.
				
			end. /*end sets */
			
			usrw_key4 = if site then "B" else "C".
			
			display site m# y# mstart mend effdate with frame a.
	
			{gprun.i ""zzcarp01a.p""}
	
		end. /* do transaction*/

		message "计算可能需要一段时间，开始计算吗？" view-as alert-box button yes-no update ifo_yn.
		if ifo_yn then do:
			{gprun.i ""zzcarp01c.p""}
		end.			

   		
	end. /*repeat*/
 	