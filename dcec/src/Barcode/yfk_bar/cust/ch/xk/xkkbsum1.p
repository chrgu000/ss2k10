
/*create by Cai Jing 01/14/2005 kanban sumary report */

{mfdtitle.i }

DEFINE VARIABLE part LIKE pt_part .
DEFINE VARIABLE part1 LIKE pt_part .
DEFINE VARIABLE sup LIKE xkgpd_sup .
DEFINE VARIABLE sup1 LIKE xkgpd_sup .
DEFINE VARIABLE dsite LIKE xkgpd_site .
DEFINE VARIABLE dsite1 LIKE xkgpd_site .
DEFINE VARIABLE xwtotqty AS DECIMAL.
DEFINE VARIABLE qtyoh AS DECIMAL.
DEFINE VARIABLE nobal AS LOGICAL LABEL "只显示不平".

DEFINE TEMP-TABLE xxkb
    FIELD xxpart LIKE pt_part 
    FIELD xxsite LIKE si_site
    FIELD xxloc LIKE ld_loc
    FIELD xxsup LIKE xkgpd_sup
    FIELD xxmax AS DECIMAL LABEL "最大看板数"
    FIELD xxmin AS DECIMAL LABEL "最小看板数"
    FIELD xxfull AS DECIMAL LABEL "满看板数量"
    FIELD xxauthpo AS DECIMAL LABEL "在途看板数"
    FIELD xxemauth AS DECIMAL LABEL "授权看板数"
    FIELD xxwosdqty AS DECIMAL LABEL "待消耗数"
INDEX xxkb xxpart xxsite xxsup .

FORM
part                colon 20  
part1                colon 45 label {t001.i} 
dsite                   colon 20
dsite1                   colon 45 label {t001.i}
sup                     colon 20
sup1                     colon 45 label {t001.i}
nobal               COLON 20

    skip(1)


with frame a width 80 side-labels attr-space .

repeat:

if part1 = hi_char then part1 = "" .
if dsite1 = hi_char then dsite1 = "" .
if sup1 = hi_char then sup1 = "" .

UPDATE
    part part1
    dsite dsite1
   sup sup1 nobal

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
        xxloc = knbsm_inv_loc.
        xxsup = knbsm_supermarket_id .
        xxmax = knbl_kanban_quantity .
        xxmin = IF AVAILABLE xkgpd_det THEN xkgpd_urgcard * knbl_kanban_quantity ELSE 0 .
        IF knbd_status = '5'THEN xxfull = knbl_kanban_quantity.
        ELSE IF knbd_status = '2' AND knbd_user1 <> '' THEN xxauthpo = knbl_kanban_quantity.
        ELSE xxemauth = knbl_kanban_quantity. 
    END.
    ELSE  do:
        xxmax = xxmax + knbl_kanban_quantity .
        IF knbd_status = '5'THEN xxfull = xxfull + knbl_kanban_quantity.
        ELSE IF knbd_status = '2' AND knbd_user1 <> '' THEN xxauthpo = xxauthpo + knbl_kanban_quantity.
        ELSE xxemauth = xxemauth + knbl_kanban_quantity.
    END.
END.

FOR EACH xwosd_det NO-LOCK WHERE xwosd_part >= part AND xwosd_part <= part1 
    AND xwosd_site >= dsite AND xwosd_site <= dsite1
    AND xwosd_lnr >= sup AND xwosd_lnr <= sup1 
    AND xwosd_qty_consumed <> xwosd_qty
    USE-INDEX xwosd_det
    BREAK BY xwosd_lnr BY xwosd_part:
    IF FIRST-OF(xwosd_part) THEN xwtotqty = 0.
    xwtotqty = xwtotqty + (xwosd_qty - xwosd_qty_consumed).
    IF LAST-OF(xwosd_part) THEN DO:
        FIND FIRST xxkb WHERE xxpart = xwosd_part
            AND xxsite = xwosd_site
            AND xxsup = xwosd_lnr NO-LOCK NO-ERROR .
        IF AVAILABLE xxkb THEN DO:
            xxwosdqty = xwtotqty.
        END.
    END.     
END.
FOR EACH xxkb NO-LOCK WHERE xxpart >= part AND xxpart <= part1 
    AND xxsite >= dsite AND xxsite <= dsite1
    AND xxsup >= sup AND xxsup <= sup1 :
    FIND FIRST ld_det WHERE ld_part = xxpart AND ld_site = xxsite AND ld_loc = xxloc NO-LOCK NO-ERROR.
    IF AVAILABLE ld_det THEN qtyoh = ld_qty_oh.
    FIND FIRST pt_mstr WHERE pt_part = xxpart NO-LOCK NO-ERROR.
    IF nobal THEN DO:
        IF xxfull - xxwosdqty <> qtyoh THEN
           DISPLAY xxpart xxsup xxmax xxauthpo xxemauth xxfull xxwosdqty qtyoh LABEL "库存" pt_desc1 WITH WIDTH 132 STREAM-IO.
    END.
    ELSE
    DISPLAY xxpart xxsup xxmax xxauthpo xxemauth xxfull xxwosdqty qtyoh LABEL "库存" pt_desc1 WITH WIDTH 132 STREAM-IO  .
END.

{mfrtrail.i}

end .
                   
