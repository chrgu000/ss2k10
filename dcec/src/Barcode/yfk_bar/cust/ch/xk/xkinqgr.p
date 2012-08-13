/* xkinqgr.p                 Áã¼þ×é²éÑ¯                  */

{mfdtitle.i "ao "}

DEFINE VARIABLE part LIKE pt_part .
DEFINE VARIABLE part1 LIKE pt_part .
DEFINE VARIABLE site LIKE si_site .
DEFINE VARIABLE site1 LIKE si_site .
DEFINE VARIABLE sup LIKE knbsm_supermarket_id .
DEFINE VARIABLE sup1 LIKE knbsm_supermarket_id .
DEFINE VARIABLE grou LIKE xkgp_group .
DEFINE VARIABLE grou1 LIKE xkgp_group .
DEFINE VARIABLE des AS CHARACTER FORMAT "x(44)" .
 
form
part                colon 20  
part1                colon 45 label {t001.i} 
site                   colon 20
site1                   colon 45 label {t001.i}
sup                     colon 20
sup1                     colon 45 label {t001.i}
grou                colon 20  
grou1                colon 45 label {t001.i}    

    skip(1)


with frame a width 80 side-labels attr-space .
setFrameLabels(frame a:handle).

/*FORM

    SKIP(2)
    xkgp_group           COLON 12 SKIP
    xkgp_lead_time COLON 12
    xkgp_auto      COLON 32 SKIP
    xkgp_desc      COLON 12 SKIP(1)

WITH FRAME b WIDTH 80 SIDE-LABELS ATTR-SPACE .*/

repeat:

if part1 = hi_char then part1 = "" .
if site1 = hi_char then site1 = "" .
if sup1 = hi_char then sup1 = "" .
IF grou1 = hi_char THEN grou1 = "" .

update
    part part1
    site site1
    sup sup1
    grou grou1
with frame a .

bcdparm = "".

{mfquoter.i part   }
{mfquoter.i part1   }
{mfquoter.i site   }
{mfquoter.i site1   }
{mfquoter.i sup   }
{mfquoter.i sup1   }
{mfquoter.i grou  }
{mfquoter.i grou1   }

if part1 = "" then part1 = hi_char .
if site1 = "" then site1 = hi_char .
if sup1 = "" then sup1 = hi_char .
if grou1 = "" then grou1 = hi_char .

{mfselbpr.i "printer" 132}

{mfphead.i}

FOR EACH xkgp_mstr WHERE xkgp_group >= grou
        AND xkgp_group <= grou1 NO-LOCK :

    FOR EACH xkgpd_det WHERE xkgpd_group = xkgp_group 
        AND xkgpd_part >= part 
        AND xkgpd_part <= part1 
        AND xkgpd_site >= site
        AND xkgpd_site <= site1
        AND xkgpd_sup >= sup
        AND xkgpd_sup <= sup1
	 NO-LOCK 
	WITH FRAME d DOWN WIDTH 255 STREAM-IO :
        FIND pt_mstr WHERE pt_part = xkgpd_part .
        des = pt_desc1 + pt_desc2 .

        DISPLAY xkgp_group xkgp_desc xkgp_wkctr xkgp_type xkgp_auto xkgp_lead_time xkgp_urg_time xkgp_wkctr xkgpd_line xkgpd_site xkgpd_sup xkgpd_part xkgpd_urgcard des /*zx01*/ xkgpd__log01	WITH FRAME d DOWN.
	setFrameLabels(frame d:handle).

    END.
END.



{mfrtrail.i}

end .
                   
