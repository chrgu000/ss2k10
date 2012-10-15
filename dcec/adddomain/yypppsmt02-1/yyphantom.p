/* $Revision:eb21sp12  $ BY: Jordan Lin            DATE: 09/03/12  ECO: *SS-20120903.1*   */
{mfdeclre.i }
/*cj*add to change pt_phantom*/

DEF INPUT PARAMETER part LIKE pt_part .
DEF INPUT PARAMETER ptpha LIKE pt_phantom .

DEF VAR pha AS LOGICAL .

FIND ptp_det NO-LOCK WHERE /* *SS-20120903.1*   */ ptp_det.ptp_domain = global_domain and  ptp_part = part AND ptp_site = "dcec-c" NO-ERROR .
IF AVAILABLE ptp_det THEN pha = ptp_phantom .
ELSE DO :
    FIND ptp_det NO-LOCK WHERE  /* *SS-20120903.1*   */ ptp_det.ptp_domain = global_domain and  ptp_part = part AND ptp_site = "dcec-b" NO-ERROR .
    IF AVAILABLE ptp_det THEN pha = ptp_phantom .
    ELSE DO :
        FIND ptp_det NO-LOCK WHERE /* *SS-20120903.1*   */ ptp_det.ptp_domain = global_domain and ptp_part = part AND ptp_site = "dcec-sv" NO-ERROR .
        IF AVAILABLE ptp_det THEN pha = ptp_phantom .
        ELSE LEAVE .
    END.
END.

IF pha <> ptpha THEN DO :
    FIND pt_mstr WHERE /* *SS-20120903.1*   */ pt_mstr.pt_domain = global_domain and pt_part = part EXCLUSIVE-LOCK .
    pt_phantom = pha .
END.
