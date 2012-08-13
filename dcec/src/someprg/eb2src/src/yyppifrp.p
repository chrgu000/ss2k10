/* LOAD DATA FROM PPIF INTO MFG/PRO AND EXPORT SCHEDULE FROM MFG/PRO    */
/* xxppifrp.p - Interface between PPIF & MFG/PRO REPORT.                */
/* CREATE BY *lb01* LONG BO      ATOS ORIGIN CHINA                      */


         /* DISPLAY TITLE */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

/*GI32*/ {mfdtitle.i "E"}

def var actdate like xxppif_act_date.
def var actdate1 like xxppif_act_date.
def var acttime  as integer format "99".
def var acttime1 as integer format "99".
def var part like pt_part.
def var part1 like pt_part.
def var trtype like xxppif_tr_code.
def var errcode like xxppif_err initial 4.

def var desc3 as character format "x(70)".
def var desc4 as character format "x(60)".

form
   RECT-FRAME       AT ROW 1 COLUMN 1.25
   RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
   SKIP(1)  /*GUI*/

	actdate colon 20 label "Act Date" 	actdate1 colon 45 label {t001.i}
	acttime colon 20 label "Act Hour" 	acttime1 colon 45 label {t001.i}
	part colon 20 
	part1 colon 45 label {t001.i}
	skip(1)
	trtype colon 20 label "Tr Code"
	desc3 colon 14 no-label
	errcode colon 20 label "Err Code"
	desc4 colon 14 no-label

   skip (1)
   with frame a side-labels width 80 NO-BOX THREE-D /*GUI*/.

   DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
   RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
   RECT-FRAME-LABEL:HIDDEN in frame a = yes.
   RECT-FRAME:HEIGHT-PIXELS in frame a =
   FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
   RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

    desc3 = "TrCode:	PDIA PDIC PDID PDSA PDSC SOIA SOIC SOSA SOSC XSCD XSYS".
	desc4 = "0-no error 1-warning 2-error 3-hand 4-display all".
	disp desc3 desc4 with frame a.
	

repeat:
    
    if actdate = low_date then actdate = ?.
    if actdate1 = hi_date then actdate1 = ?.
    if part1 = hi_char then part1 = "".

    if acttime1 = 00 then acttime1 = 24.
    
    update actdate actdate1 
           acttime  validate(integer(acttime)>=0 and integer(acttime)<=24,"hour>=0 and hour <= 24")
           acttime1 validate(integer(acttime1)>=0 and integer(acttime1)<=24,"hour>=0 and hour <= 24")
           part part1 trtype errcode with frame a.
	
	if actdate = ? then actdate = low_date.
	if actdate1 = ? then actdate1 = hi_date.    
	
	
    if part1 = "" then part1 = hi_char.
    
        {mfselbpr.i "printer" 132}
        
        
       for each xxppif_log no-lock where xxppif_act_date >= actdate
                                     and xxppif_act_date <= actdate1
                                     and xxppif_part >= part
                                     and xxppif_part <= part1
                                     and substring(xxppif_act_time,1,2) >= string(acttime,"99")
                                     and substring(xxppif_act_time,1,2) <= string(acttime1,"99")
                                     and (trtype = "" or xxppif_tr_code = trtype)
                                     and (errcode = 4 or xxppif_err = errcode) break by xxppif_tr_id:
       		disp xxppif_tr_id 
       		     xxppif_tr_code format "x(4)"
       		     xxppif_part  
       		     xxppif_act_date
       		     xxppif_act_time 
 				 xxppif_err 
 				 xxppif_qty_chg 
				 xxppif_bld_date 
				 xxppif_msg format "x(60)" 
			     xxppif_content format "x(110)" colon 8
			     skip(1)
				with frame b down width 150 STREAM-IO.
		end.
      
        
            {mfreset.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/
    
    status input.
    
end.
