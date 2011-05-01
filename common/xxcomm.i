/* xxsomt13.p - SALES ORDER MAINTENANCE                                       */
/* REVISION:101027.1 LAST MODIFIED: 10/27/10 BY: zy                       *ar**/
/*-Revision end---------------------------------------------------------------*/
/* Environment: Progress:10.1B   QAD:eb21sp5    Interface:                    */
/*V8:ConvertMode=Maintenance                                                  */
/*-Revision:[110106.1]---------------------------------------------------------
  Purpose:
  Notes:
------------------------------------------------------------------------------*/

PROCEDURE getVer:
/*-Revision:[14YT]---------------------------------------------------------
  Purpose: 获取程序版本.
  Notes: 此版本规则是自定规则,1-Year,2-Month,3-Fixed(Y),4-Day
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER iDate AS DATE.
    DEFINE OUTPUT PARAMETER oVersion AS CHARACTER.

    DEFINE VARIABLE vI AS INTEGER.
    DEFINE VARIABLE vO AS CHARACTER.
    ASSIGN vi = YEAR(idate) - 2010.
    IF vI < 10 THEN ASSIGN vO = STRING(vI).
    ELSE ASSIGN vO = CHR(vI + 55).

    ASSIGN vI = MONTH(idate).
    IF vI < 10 THEN ASSIGN vO = vO + STRING(vI).
    ELSE ASSIGN vO = vO + CHR(vI + 55).

    ASSIGN vO = vO + "Y".
    ASSIGN vI = DAY(idate).
    IF vI < 10 THEN ASSIGN vO = vO + STRING(vI).
    ELSE ASSIGN vO = vO + CHR(vI + 55).

    ASSIGN oVersion = vO.
END PROCEDURE.
