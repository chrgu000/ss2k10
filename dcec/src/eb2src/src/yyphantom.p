/*cj*add to change pt_phantom*/

DEF INPUT PARAMETER part LIKE pt_part .
DEF INPUT PARAMETER ptpha LIKE pt_phantom .

DEF VAR pha AS LOGICAL .

FIND ptp_det NO-LOCK WHERE ptp_part = part AND ptp_site = "dcec-c" NO-ERROR .
IF AVAILABLE ptp_det THEN pha = ptp_phantom .
ELSE DO :
    FIND ptp_det NO-LOCK WHERE ptp_part = part AND ptp_site = "dcec-b" NO-ERROR .
    IF AVAILABLE ptp_det THEN pha = ptp_phantom .
    ELSE DO :
        FIND ptp_det NO-LOCK WHERE ptp_part = part AND ptp_site = "dcec-sv" NO-ERROR .
        IF AVAILABLE ptp_det THEN pha = ptp_phantom .
        ELSE LEAVE .
    END.
END.

IF pha <> ptpha THEN DO :
    FIND pt_mstr WHERE pt_part = part EXCLUSIVE-LOCK .
    pt_phantom = pha .
END.
