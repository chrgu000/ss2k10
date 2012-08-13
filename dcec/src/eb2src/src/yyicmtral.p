/*zzicmtral.p	CREATE BY LONG BO 2004 JUN 21					*/
/*	ITEM TRANSFER ORDER MAINTENANCE								*/
/*	移库单备料维护												*/
/*rev: eb2 + sp7      last modified: 2005/08/29    by: judy liu*/


         /* DISPLAY TITLE */
/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

/*GI32*/ {mfdtitle.i "E"}


/* DEFINITION */
def var del-yn as logic.
def var un-all as logic.

def new shared var nbr like lad_nbr.
def var i as integer.
def var lennbr as integer.
define variable new_lad like mfc_logical.
define new shared variable lad_recno as recid.
define new shared variable site_from like lad_site no-undo.
define new shared variable site_to   like lad_site no-undo.
define new shared variable loc_from  like lad_loc no-undo.
define new shared variable loc_to    like lad_loc no-undo.


form
	RECT-FRAME       AT ROW 1.4 COLUMN 1.25
	RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
	skip(.1)
	lad_nbr			colon 20 label "移库单"	format "x(8)"
	un-all			colon 50 label "取消备料量" 
	lad_site		colon 20 label "调出地点"
	lad_ord_site	colon 50 label "调入地点"
	lad_loc			colon 20 label "缺省调出库位"
	lad__qadc01		colon 50 label "缺省调入库位"
	lad_user1		colon 20 label "销售/定制品"
	lad_ref			colon 50 label "备注"
	skip(.4)
with frame a side-labels width 80 NO-BOX THREE-D /*GUI*/.

DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/
  
    /* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
	
	view frame a.
	
	mainloop:
	repeat:
		
		un-all = no.
/*GUI*/ if global-beam-me-up then undo, leave.

	    do transaction on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

	       /*GUI: view frame dtitle. */
IF global-tool-bar AND global-tool-bar-handle <> ? THEN
  view global-tool-bar-handle. /*GUI*/

			view frame a.
			prompt-for lad_nbr with frame a editing:

/*G716*/          /* Allow last PO number refresh */
/*G716*/          if keyfunction(lastkey) = "RECALL" or lastkey = 307
/*G716*/           then display nbr @ lad_nbr with frame a.

		  /* FIND NEXT/PREVIOUS  RECORD */
/*FS95*/             {mfnp06.i
				lad_det
				lad_det
				"lad_dataset = ""itm_mstr"""
				lad_nbr
				"input lad_nbr"
				yes
				yes }

				if recno <> ? then do:
					display 
						lad_nbr		
						lad_user1	
						lad_ref		
						lad_site	
						lad_ord_site
						lad_loc		
						lad__qadc01	
	 				with frame a.
				end.  /* IF RECNO <> ? */
			end. /* PROMPT-FOR...EDITING */
			
			find lad_det where lad_dataset = "itm_mstr" 
			and lad_nbr = input lad_nbr no-lock no-error.
			if available lad_det then do:
				display 
					lad_nbr		
					lad_user1	
					lad_ref		
					lad_site	
					lad_ord_site
					lad_loc		
					lad__qadc01	
				with frame a.
			end.
	
			if input lad_nbr <> "" then nbr = input lad_nbr.

			if input lad_nbr = "" then do:
	            
				find code_mstr where code_fldname = "xx-itr-ctrl" and 
									 code_value   = "nextnbr" exclusive-lock no-error.
				if not available code_mstr then do:
					create code_mstr.
					assign code_fldname = "xx-itr-ctrl"
	                       code_value   = "nextnbr"
	                       code_cmmt	= "1".
	            end.
	            
	            lennbr = length(code_cmmt).
	            
	            do i = 1 to lennbr:
	            	if index("0123456789",substring(code_cmmt,i,1)) = 0 then do:
	            		code_cmmt = "1".
	            		leave.
	            	end.
	            end.
	            nbr = "00000000" + code_cmmt.
	            code_cmmt = string(integer(code_cmmt) + 1).
	            nbr = substring(nbr,length(nbr) - 5, 6).

				find code_mstr where code_fldname = "xx-itr-ctrl" and 
									 code_value   = "prefix" exclusive-lock	no-error.
				if not available code_mstr then do:
					create code_mstr.
					assign code_fldname = "xx-itr-ctrl"
	                       code_value   = "prefix"
	                       code_cmmt	= "TR".
	            end.
	            nbr = code_cmmt + nbr.
	         end.  
	        
	         display nbr @ lad_nbr with frame a. 

		end. /* do transaction*/
		
	    do transaction on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

			find lad_det where lad_nbr = nbr and lad_dataset = "itm_mstr" exclusive-lock no-error.
			if not available lad_det then do :
				{mfmsg.i 1 1}
				new_lad = yes.
				create lad_det.
				assign lad_dataset  = "itm_mstr"
				       lad_nbr      = nbr
				       lad_user2    = global_userid
				       lad_line		= string(today).
			end.                           
	       	else do:        
				new_lad = no.
				{mfmsg.i 10 1}
			end.
			
			display 
				lad_user1	
				lad_ref		
				lad_site	
				lad_ord_site
				lad_loc		
				lad__qadc01	
			with frame a.
			
			setb:
			do on error undo, retry:
/*GUI*/ 	if global-beam-me-up then undo, leave.

				if new_lad then do:
					set lad_site lad_ord_site with frame a.
				
					find si_mstr where si_site = lad_site no-lock no-error.
					if not available si_mstr then do :
						message "错误：地点不存在，请重新输入" view-as alert-box.
						next-prompt lad_site with frame a.
						undo, retry setb.
					end.
					find si_mstr where si_site = lad_ord_site no-lock no-error.
					if not available si_mstr then do :
						message "错误：地点不存在，请重新输入" view-as alert-box.
						next-prompt lad_ord_site with frame a.
						undo, retry setb.
					end.
				end.
				
	       		set
				/*	lad_site	
					lad_ord_site */
					lad_loc		
					lad__qadc01	
					lad_user1	
					lad_ref		
	          	go-on ("F5" "CTRL-D") with frame a editing:
					readkey.
					apply lastkey.
				end. /*editing*/
	
		       	/* DELETE */
		       	if new_lad = no and (lastkey = keycode("F5") or lastkey = keycode("CTRL-D"))
		       	then do:
					/*delete*/
					del-yn = yes.
					{mfmsg01.i 11 1 del-yn}
					if del-yn then do:
				   		lad_recno = recid(lad_det).
				   		site_from = lad_site.
				   		site_to   = lad_ord_site.
				   		loc_from  = lad_loc.
				   		loc_to    = lad__qadc01.
						{gprun.i ""yyicmtrald.p"" "(yes)"}  /*judy zz->yy*/
						delete lad_det.		
						clear frame a.		
						next mainloop.						
					end.
					else do :
						next-prompt lad_loc with frame a.
						undo,retry.
					end.
				end.
				
				/*VILIDATE*/
				find loc_mstr where loc_loc = lad_loc and loc_site = lad_site no-lock no-error.
				if not available loc_mstr then do :
					message "警告：调出地点下该库位不存在。".
					pause.
				end.				
				find loc_mstr where loc_loc = lad__qadc01 and loc_site = lad_ord_site no-lock no-error.
				if not available loc_mstr then do :
					message "警告：调入地点下该库位不存在。".
					pause.
				end.				
				
			end.   			 
			lad_lot = "N".  /*修改后，未打印*/
   		end. /*do transaction*/
   		
   		lad_recno = recid(lad_det).
   		site_from = lad_site.
   		site_to   = lad_ord_site.
   		loc_from  = lad_loc.
   		loc_to    = lad__qadc01.
   		
		{gprun.i ""yyicmtrala.p""}   /*judy zz->yy*/
		
		update un-all with frame a.
		if un-all then do:
			message "取消所有备料量吗？" view-as alert-box button yes-no update del-yn.
			if del-yn then do:
				{gprun.i ""yyicmtrald.p"" "(no)"}   /*judy zz->yy*/
			end.			
		end. 
				   		
   		
	end. /*repeat*/
 	
