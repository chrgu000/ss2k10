/*Zzictrcfcrp2.p for report the transaction of the items during a period*/
/*Last modify: 12/25/2003, By: Kevin, copy from zzictrcfcrp.p*/

/* DISPLAY TITLE */
{mfdtitle.i "e+ "}

def var addr like ad_addr label "金税号".
def var addr1 like ad_addr.

DEFINE VARIABLE yn_zero AS LOGICAL INITIAL yes 
     LABEL "Suppress Zero" 
     VIEW-AS TOGGLE-BOX
     SIZE 13 BY 1.39 NO-UNDO.

DEF VAR I AS INTE.
DEF VAR LINECOUNT AS INTE.

Form
/*GM65*/
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
 addr colon 22       addr1 colon 49 label {t001.i}
 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

repeat:

    if addr1 = hi_char then addr1 = "".
        
    update addr addr1  /*site site1*/
            with frame a.
    
    if addr1 = "" then addr1 = hi_char.
        
    {mfselbpr.i "printer" 132}
        
    status input "Waiting for report process...".
        
FOR EACH ad_mstr WHERE ad_gst_id <> "":
    DISP ad_addr LABEL "金税代码" ad_name LABEL "客户名称" ad_line1 LABEL "客户名称" 
         ad_line2 LABEL "客户地址" ad_line3  LABEL "客户地址"  ad_gst_id LABEL "税号"
        ad_edi_tpid  LABEL "帐号"  with width 180 stream-io.
 end.            
    {mfreset.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/
    
    status input.
    
end. /*repeat*/
