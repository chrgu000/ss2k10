/*zzicmtrtr.p CRETATE BY LONG BO ,  2004/06/22                 */
/*移库单移库                                                   */


         /* DISPLAY TITLE */
/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

/*GI32*/ {mfdtitle.i "E"}


/* DEFINITION */
def var del-yn as logic.

def new shared var nbr like lad_nbr.
def var i as integer.
def var lennbr as integer.
define variable new_lad like mfc_logical.
define new shared variable lad_recno as recid.
define new shared variable site_from like lad_site no-undo.
define new shared variable site_to   like lad_site no-undo.
define new shared variable eff_date as date.
define new shared variable so_job like tr_so_job no-undo. 
define new shared variable rmks like tr_rmks no-undo. 

define variable tr-yn as logic.


form
	RECT-FRAME       AT ROW 1.4 COLUMN 1.25
	RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
	skip(.1)
	lad_nbr			colon 16 label "移库单"	format "x(8)"
	lad_user2 		colon 40 label "创建人"
	lad_line 		colon 62 label "创建日期"
	lad_site		colon 16 label "调出地点"
	lad_ord_site	colon 40 label "调入地点"
	eff_date			colon 62 label "生效日期"
	lad_user1		colon 16 label "销售/定制品"
	lad_ref			colon 40 label "备注"
	tr-yn			colon 62 label "确认转移"
	skip(.4)
with frame a side-labels width 80 NO-BOX THREE-D /*GUI*/.

DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

	
	view frame a.

	
	mainloop:
	repeat:
		
/*GUI*/ if global-beam-me-up then undo, leave.

	    do transaction on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

	       /*GUI: view frame dtitle. */
IF global-tool-bar AND global-tool-bar-handle <> ? THEN
  view global-tool-bar-handle. /*GUI*/
			
			eff_date = today.
			tr-yn = no.
			display eff_date tr-yn with frame a.
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
						lad_user2
						lad_line	
						lad_user1	
						lad_ref		
						lad_site	
						lad_ord_site
	 				with frame a.
				end.  /* IF RECNO <> ? */
			end. /* PROMPT-FOR...EDITING */
			
			find lad_det where lad_dataset = "itm_mstr" 
			and lad_nbr = input lad_nbr no-lock no-error.
			if available lad_det then do:
				display 
					lad_nbr
					lad_user2
					lad_line		
					lad_user1	
					lad_ref		
					lad_site	
					lad_ord_site
				with frame a.
			end.
			else do:
				message "移库单不存在，请重新输入".
				next-prompt lad_nbr with frame c.
				undo, retry.
			end.

		end. /* do transaction*/
		
   		nbr = lad_nbr.
   		
   		lad_recno = recid(lad_det).
   		site_from = lad_site.
   		site_to   = lad_ord_site.
   		so_job = lad_user1.
   		rmks = lad_ref.
   		
		{gprun.i ""zzicmtrtra.p""}
		
		update eff_date tr-yn with frame a.

		
		if tr-yn then do:
	        /* SELECT PRINTER */
	        {mfselprt.i "terminal" 80}
			{gprun.i ""zzicmtrtrt.p""}
	/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/
	        {mfreset.i}
	/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/
		end. 

				   		
	end. /*repeat*/

