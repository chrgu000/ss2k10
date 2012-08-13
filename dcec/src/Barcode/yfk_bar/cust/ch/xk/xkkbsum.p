/*create by Cai Jing 01/14/2005 kanban sumary report */

{mfdtitle.i }

DEFINE VARIABLE part LIKE pt_part .
DEFINE VARIABLE part1 LIKE pt_part .
DEFINE VARIABLE sup LIKE xkgpd_sup .
DEFINE VARIABLE sup1 LIKE xkgpd_sup .
DEFINE VARIABLE dsite LIKE xkgpd_site .
DEFINE VARIABLE dsite1 LIKE xkgpd_site .

DEFINE TEMP-TABLE xxkb
    FIELD xxpart LIKE pt_part 
    FIELD xxsite LIKE si_site
    FIELD xxsup LIKE xkgpd_sup
    FIELD xxmax AS INTEGER LABEL "最大看板数"
    FIELD xxmin AS INTEGER LABEL "最小看板数"
INDEX xxkb xxpart xxsite xxsup .

FORM
part                colon 20  
part1                colon 45 label {t001.i} 
dsite                   colon 20
dsite1                   colon 45 label {t001.i}
sup                     colon 20
sup1                     colon 45 label {t001.i}

    skip(1)


with frame a width 80 side-labels attr-space .

repeat:

if part1 = hi_char then part1 = "" .
if dsite1 = hi_char then dsite1 = "" .
if sup1 = hi_char then sup1 = "" .

UPDATE
    part part1
    dsite dsite1
   sup sup1

with frame a .

bcdparm = "".

{mfquoter.i part   }
{mfquoter.i part1   }
{mfquoter.i dsite  }
{mfquoter.i dsite1   }
{mfquoter.i sup   }
{mfquoter.i sup1  }

if part1 = "" then part1 = hi_char .
IF dsite1 = "" THEN dsite1 = hi_char .
IF sup1 = "" THEN sup1 = hi_char .

{mfselbpr.i "printer" 132}

{mfphead.i}

FOR EACH xxkb :
    DELETE xxkb .
END.

FOR EACH knbd_det WHERE knbd_active = YES NO-LOCK :
    
    FIND knbl_det WHERE knbl_keyid = knbd_knbl_keyid NO-LOCK.
    FIND knb_mstr WHERE knb_keyid = knbl_knb_keyid NO-LOCK.
    FIND knbi_mstr WHERE knbi_keyid = knb_knbi_keyid NO-LOCK .
    FIND knbsm_mstr WHERE knbsm_keyid = knb_knbsm_keyid NO-LOCK .
    
    FIND FIRST xxkb WHERE xxpart = knbi_part
        AND xxsite = knbsm_site
        AND xxsup = knbsm_supermarket_id NO-LOCK NO-ERROR .
    IF NOT AVAILABLE xxkb THEN DO :
        FIND FIRST xkgpd_det WHERE xkgpd_site = knbsm_site 
                        AND knbsm_supermarket_id = xkgpd_sup 
                        AND xkgpd_part = knbi_part NO-LOCK NO-ERROR .
        CREATE xxkb .
        xxpart = knbi_part .
        xxsite = knbsm_site .
        xxsup = knbsm_supermarket_id .
        xxmax = 1 .
        xxmin = IF AVAILABLE xkgpd_det THEN xkgpd_urgcard ELSE 0 .
    END.
    ELSE xxmax = xxmax + 1 .
END.

FOR EACH xxkb NO-LOCK WHERE xxpart >= part AND xxpart <= part1 
    AND xxsite >= dsite AND xxsite <= dsite1
    AND xxsup >= sup AND xxsup <= sup1 :
    DISPLAY xxpart xxsite xxsup xxmax xxmin WITH STREAM-IO .
END.

{mfrtrail.i}

end .
                   
