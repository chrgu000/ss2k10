/*zzptmprp.p , report of the customer(Engine No.) -> components -> supplier mapping relationship*/
/*Last modified: 11/18/2003, By: Kevin, Atos Origin*/

         /* DISPLAY TITLE */
{mfdtitle.i "120817.1"}

def var site like si_site.
def var site1 like si_site.
def var par like ps_par.
def var par1 like ps_par.
def var comp like ps_comp.
def var comp1 like ps_comp.
def var vend like vd_addr.
def var vend1 like vd_addr.
def var cust like cm_addr.
def var cust1 like cm_addr.

FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
site colon 22       site1 colon 49 label {t001.i}
par colon 22        par1 colon 49 label {t001.i}
comp colon 22       comp1 colon 49 label {t001.i}
vend colon 22       vend1 colon 49 label {t001.i}
cust colon 22       cust1 colon 49 label {t001.i}
          SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/
setframelabels(frame a:handle) .
repeat:
    if site1 = hi_char then site1 = "".
    if par1 = hi_char then par1 = "".
    if comp1 = hi_char then comp1 = "".
    if vend1 = hi_char then vend1 = "".
    if cust1 = hi_char then cust1 = "".
    
    update site site1 par par1 comp comp1 vend vend1
           cust cust1 with frame a.
    
    if site1 = "" then site1 = hi_char.
    if par1 = "" then par1 = hi_char.
    if comp1 = "" then comp1 = hi_char.
    if vend1 = "" then vend1 = hi_char.
    if cust1 = "" then cust1 = hi_char.
    
    bcdparm = "".
    {mfquoter.i site       }
    {mfquoter.i site1       }
    {mfquoter.i par       }
    {mfquoter.i par1       }
    {mfquoter.i comp       }
    {mfquoter.i comp1       }
    {mfquoter.i vend       }
    {mfquoter.i vend1       }
    {mfquoter.i cust       }
    {mfquoter.i cust1       }
    
    {mfselbpr.i "printer" 132}
    {mfphead.i}

    for each xxptmp_mstr where xxptmp_domain = global_domain and
            (xxptmp_site >= site and xxptmp_site <= site1) and
            (xxptmp_par >= par and xxptmp_par <= par1) and
            (xxptmp_comp >= comp and xxptmp_comp <= comp1) and
            (xxptmp_vend >= vend and xxptmp_vend <= vend1) and
            (xxptmp_cust >= cust and xxptmp_cust <= cust1)
     no-lock:
            FIND FIRST pt_mstr WHERE pt_domain = global_domain and 
            					 pt_part = xxptmp_par NO-LOCK NO-ERROR.
            disp xxptmp_site xxptmp_par pt_status WHEN AVAIL pt_mstr xxptmp_comp xxptmp_vend
                 xxptmp_rmks xxptmp_qty xxptmp_cust 
                 with width 132 stream-io.
    end.
    
/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/
        {mfreset.i}  
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/    
               
end. /*repeat*/
