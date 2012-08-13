/*Last modified by Tracy Zhang 11/23/2004 *zx1123*/
/*Cai last modified by 05/20/2004*/
/*Last Modify by SunnyZhou on 06/22/2004   *xw0622*/
/*Lase Modify by xwh on 01/06/2005 added the vend part number *xwh0106*/
/*Modified by xwh on 03/02/2005 addd supplier code *xwh0302*/

{mfdtitle.i "2+ "}

DEFINE VARIABLE part LIKE pt_part .
DEFINE VARIABLE part1 LIKE pt_part .
DEFINE VARIABLE site LIKE si_site .
DEFINE VARIABLE site1 LIKE si_site .
DEFINE VARIABLE loc LIKE xkro_loc .
DEFINE VARIABLE loc1 LIKE xkro_loc .
DEFINE VARIABLE dsite LIKE xkro_dsite .
DEFINE VARIABLE dsite1 LIKE xkro_dsite .
DEFINE VARIABLE dloc LIKE xkro_dloc .
DEFINE VARIABLE dloc1 LIKE xkro_dloc .
DEFINE VARIABLE supplier LIKE xkro_supplier .
DEFINE VARIABLE supplier1 LIKE xkro_supplier .
DEFINE VARIABLE dat LIKE xkro_ord_date label "收货日期".
DEFINE VARIABLE dat1 LIKE xkro_ord_date .
DEFINE VARIABLE xnbr LIKE xkro_nbr .
DEFINE VARIABLE xnbr1 LIKE xkro_nbr .
DEFINE VARIABLE rnbr LIKE xkprh_nbr .
DEFINE VARIABLE rnbr1 LIKE xkprh_nbr .
DEFINE VARIABLE effdat LIKE xkprh_eff_date .
DEFINE VARIABLE effdat1 LIKE xkprh_eff_date .
DEFINE VARIABLE vendpart LIKE pt_part LABEL "供应商零件号".

DEFINE VARIABLE des AS CHARACTER LABEL "描述" FORMAT "x(48)" .

form
xnbr                colon 20  
xnbr1                colon 45 label {t001.i} 
rnbr                colon 20  
rnbr1                colon 45 label {t001.i} 
dat                colon 20  
dat1                colon 45 label {t001.i} 
effdat                colon 20  
effdat1                colon 45 label {t001.i} 
part                colon 20  
part1                colon 45 label {t001.i} 
/*xw0621*
site                   colon 20
site1                   colon 45 label {t001.i}
loc                     colon 20
loc1                     colon 45 label {t001.i}
dsite                   colon 20
dsite1                   colon 45 label {t001.i}
dloc                     colon 20
dloc1                     colon 45 label {t001.i}  
supplier                colon 20  
supplier1                colon 45 label {t001.i} 
*xw0621*/
skip(1)
with frame a width 80 side-labels attr-space .

setFrameLabels(frame a:handle).

FORM 
    SKIP(2)
    xkro_nbr COLON 20               xkro_supplier COLON 50
    xkro_user COLON 20              xkro_ord_date COLON 50
    xkro_site COLON 20              xkro_loc      COLON 50
    xkro_dsite COLON 20             xkro_dloc     COLON 50
    xkro_urgent COLON 20            xkro_status   COLON 50
    SKIP(1)

WITH FRAME b WIDTH 80 SIDE-LABELS ATTR-SPACE .


repeat:

if part1 = hi_char then part1 = "" .
if site1 = hi_char then site1 = "" .
if loc1 = hi_char then loc1 = "" .
if dsite1 = hi_char then dsite1 = "" .
if dloc1 = hi_char then dloc1 = "" .
if supplier1 = hi_char then supplier1 = "" .
if xnbr1 = hi_char then xnbr1 = "" .
if rnbr1 = hi_char then rnbr1 = "" .
if dat1 = hi_date then dat1 = ? .
IF dat = low_date THEN dat = ? .
if effdat1 = hi_date then effdat1 = ? .
IF effdat = low_date THEN effdat = ? .

update
    xnbr xnbr1
    rnbr rnbr1
    dat dat1 
    effdat effdat1
    part part1
/*xw0621*    
    site site1
    loc loc1
    dsite dsite1
    dloc dloc1

    supplier supplier1
*xw0621*/
with frame a .

bcdparm = "".

{mfquoter.i part   }
{mfquoter.i part1   }
{mfquoter.i site   }
{mfquoter.i site1   }
{mfquoter.i xnbr   }
{mfquoter.i xnbr1   }
{mfquoter.i rnbr   }
{mfquoter.i rnbr1   }
{mfquoter.i dsite  }
{mfquoter.i dsite1   }
{mfquoter.i dloc1   }
{mfquoter.i dloc  }
{mfquoter.i dat1   }
{mfquoter.i dat  }
{mfquoter.i effdat1   }
{mfquoter.i effdat  }
{mfquoter.i supplier   }
{mfquoter.i supplier1  }
{mfquoter.i loc1   }
{mfquoter.i loc  }


if part1 = "" then part1 = hi_char .
if site1 = "" then site1 = hi_char .
if loc1 = "" then loc1 = hi_char .
if supplier1 = "" then supplier1 = hi_char .
IF dloc1 = "" THEN dloc1 = hi_char .
IF dat1 = ? THEN dat1 = hi_date .
IF dat = ? THEN dat = low_date .
IF xnbr1 = "" THEN xnbr1 = hi_char .
IF dsite1 = "" THEN dsite1 = hi_char .
IF effdat1 = ? THEN effdat1 = hi_date .
IF effdat = ? THEN effdat = low_date .
IF rnbr1 = "" THEN rnbr1 = hi_char .


{mfselbpr.i "printer" 132}

{mfphead.i}

/*xw0622* FOR EACH xkro_mstr WHERE (xkro_ord_date <= dat1 AND xkro_ord_date >= dat) 
    AND (xkro_nbr >= xnbr AND xkro_nbr <= xnbr1)
    AND (xkro_site >= site AND xkro_site <= site1)
    AND (xkro_loc >= loc AND xkro_loc <= loc1)
    AND (xkro_dsite >= dsite AND xkro_dsite <= dsite1)
    AND (xkro_dloc >= dloc AND xkro_dloc <= dloc1)
    AND (xkro_supplier >= supplier AND xkro_supplier <= supplier1) NO-LOCK :

    DISPLAY xkro_nbr xkro_supplier xkro_ord_date xkro_user xkro_site xkro_loc
         xkro_dsite xkro_dloc xkro_urgent xkro_status WITH FRAME b .
    DOWN WITH FRAME b .
*/
    FOR EACH xkprh_hist 
    WHERE xkprh_po_nbr >= xnbr AND xkprh_po_nbr <= xnbr1 
        AND (xkprh_nbr >= rnbr AND xkprh_nbr <= rnbr1)
        AND (xkprh_part >= part AND xkprh_part <= part1) 
        AND (xkprh_rct_date >= dat AND xkprh_rct_date <= dat1) 
        AND (xkprh_eff_date >= effdat AND xkprh_eff_date <= effdat1) 
	NO-LOCK  WITH FRAME c DOWN WIDTH 300 :
        FIND pt_mstr WHERE pt_part = xkprh_part NO-LOCK NO-ERROR .
        IF AVAILABLE pt_mstr THEN des = pt_desc1 + pt_desc2 .
/*xwh0106-----*/        
        FIND vp_mstr WHERE vp_part = xkprh_part AND vp_vend = xkprh_vend NO-LOCK NO-ERROR .
        IF AVAILABLE vp_mstr THEN vendpart = vp_vend_part.
/*----xwh0106*/ 
        DISPLAY xkprh_po_nbr xkprh_nbr xkprh_vend 
	    xkprh_line xkprh_part vendpart des xkprh_nbr xkprh_qty format "->>>,>>9.99"
	    xkprh_rct_date 
            xkprh_eff_date 
	    xkprh_web_date column-label "发布日期"
	    xkprh_dsite
	    xkprh_dloc 
	    xkprh_kbid column-label "看板卡" format "x(80)"
	    with frame c.
/*        DOWN WITH FRAME c . */
    END.

/*xw0622* END. */


{mfrtrail.i}

end .
                   
