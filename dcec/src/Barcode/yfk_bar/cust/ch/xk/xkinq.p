/* xkinq.p                   看板要货需求查询                     */
/*Cai last modified by 06/16/2004*/

{mfdtitle.i "2+ "}
 {kbconst.i}

DEFINE VARIABLE site LIKE pt_site .
DEFINE VARIABLE site1 LIKE pt_site .
DEFINE VARIABLE supermarket  LIKE knbsm_supermarket_id .
DEFINE VARIABLE supermarket1  LIKE knbsm_supermarket_id .
DEFINE VARIABLE grou LIKE xkgp_group .
DEFINE VARIABLE grou1 LIKE xkgp_group .
DEFINE VARIABLE part LIKE pt_part .
DEFINE VARIABLE part1 LIKE pt_part .
DEFINE VARIABLE tempgrou LIKE xkgp_group .

DEFINE TEMP-TABLE gg 
    FIELD gxgr LIKE xkgp_group 
    FIELD gxpa LIKE pt_part 
    FIELD gxqe AS DECIMAL LABEL "空数量"
    FIELD gxqa AS DECIMAL LABEL "授权数量" 
    FIELD gyqe AS DECIMAL LABEL "空包装数量"
    FIELD gyqa AS DECIMAL LABEL "授权包装数量" 
INDEX gp gxgr gxpa .

FORM
    site COLON 20
    site1 COLON 45 LABEL {t001.i}
    supermarket COLON 20
    supermarket1 COLON 45 LABEL {t001.i}
    grou COLON 20
    grou1 COLON 45 LABEL {t001.i}
    part COLON 20
    part1 COLON 45 LABEL {t001.i}
    SKIP(1)

WITH FRAME a WIDTH 80 SIDE-LABELS ATTR-SPACE .

FORM 
    gxgr FORMAT "x(16)"
    gxpa FORMAT "x(18)"
    gxqe 
    gyqe
    gxqa
    gyqa
    SKIP 
WITH FRAME b DOWN WIDTH 80 ATTR-SPACE NO-LABEL  .

REPEAT:

if part1 = hi_char then part1 = "" .
if site1 = hi_char then site1 = "" .
IF supermarket1 = hi_char THEN supermarket1 = "" .
IF grou1 = hi_char THEN grou1 = "" .

UPDATE site site1 supermarket supermarket1 grou grou1 part part1 WITH FRAME a .

if part1 = "" then part1 = hi_char .
if site1 = "" then site1 = hi_char .
IF supermarket1 = "" THEN supermarket1 = hi_char .
IF grou1 = "" THEN grou1 = hi_char .

bcdparm = "".

{mfquoter.i site   }
{mfquoter.i supermarket   }
{mfquoter.i grou   }
{mfquoter.i part   }
{mfquoter.i site1   }
{mfquoter.i supermarket1   }
{mfquoter.i grou1   }
{mfquoter.i part1   }

{mfselbpr.i "printer" 132}

{mfphead.i}

      for each knbsm_mstr no-lock where
            knbsm_site >= site and
            knbsm_site <= site1 and
            knbsm_supermarket_id >= supermarket and
            knbsm_supermarket_id <= supermarket1,
         each knb_mstr no-lock where
            knb_knbsm_keyid = knbsm_keyid,
         each knbi_mstr no-lock where
            knbi_keyid = knb_knbi_keyid and
            knbi_part >= part and
            knbi_part <= part1,
         each knbs_det no-lock where
            knbs_keyid = knb_knbs_keyid,
         each knbl_det no-lock where
            knbl_knb_keyid = knb_keyid,
         each knbd_det no-lock where
            knbd_knbl_keyid = knbl_keyid and
           (knbd_status = {&KB-CARDSTATE-EMPTYACC} OR knbd_status = {&KB-CARDSTATE-EMPTYAUTH}) and        
            knbd_active AND 
            knbd_user1 = ""
/*Cai0616*/ AND knbd_active_code = "1"
         by knbsm_site
         by knbi_part:
            IF knbs_source_type = {&KB-SOURCETYPE-INVENTORY} then do:
                FIND xkgpd_det WHERE xkgpd_site = knbsm_site and xkgpd_sup = knbsm_supermarket_id AND xkgpd_part = knbi_part NO-LOCK NO-ERROR .
                IF AVAILABLE xkgpd_det THEN tempgrou = xkgpd_group .
            END.
            if knbs_source_type = {&KB-SOURCETYPE-SUPPLIER} THEN tempgrou = knbs_ref2 .
            FIND FIRST knbism_det WHERE knbism_knbi_keyid = knbi_keyid AND knbism_knbsm_keyid = knbsm_keyid NO-LOCK NO-ERROR .
            IF tempgrou = "" THEN tempgrou = "空".
            FIND gg WHERE gxgr = tempgrou AND gxpa = knbi_part NO-ERROR .
            IF NOT AVAILABLE gg THEN DO:
                CREATE gg .
                gxgr = tempgrou .
                gxpa = knbi_part .
            END .
            IF knbd_status = {&KB-CARDSTATE-EMPTYACC} THEN DO :
                gxqe = knbd_kanban_quantity .
                IF AVAILABLE knbism_det THEN gyqe = gxqe / knbism_pack_qty .
            END.
            ELSE DO :
                gxqa = knbd_kanban_quantity .
                IF AVAILABLE knbism_det THEN gyqa = gxqa / knbism_pack_qty .
            END.

    END.

    FOR EACH gg BREAK BY gxgr :
          IF FIRST-OF(gxgr) THEN DISPLAY gxgr gxpa gxqe gyqe gxqa gyqa WITH WIDTH 132 .
          ELSE DISPLAY "" @ gxgr gxpa gxqe gyqe gxqa gyqa WITH WIDTH 132 .

    END.

 {mfrtrail.i}
END.




