{mfdeclre.i "new global"}
{mf1.i "new global"}
session:date-format = 'dmy'.
base_curr = "RMB".
IF global_userid = "" THEN global_userid = "MFG".
mfguser="".
global_user_lang = "ch".
global_user_lang_dir = "ch/".
global_domain = "DCEC".
global_db = "DCEC".
execname = "qadtocrm.p".

DEFINE VAR mpath AS CHAR.
DEFINE VAR v_start_date AS CHAR.
DEFINE VAR v_end_date AS CHAR.

DEFINE TEMP-TABLE xx_wkfl
    FIELD xx_part LIKE pi_part_code
    FIELD xx_list LIKE pi_list
    FIELD xx_line LIKE pt_prod_line
    FIELD xx_curr LIKE pi_curr
    FIELD xx_price LIKE pi_list_price
    FIELD xx_start_date LIKE pi_start
    FIELD xx_end_date LIKE pi_expire.

/* get salse prcie for service
一、价格产生

服务价格 1、备件 A12
         2、发动机OEM价格 * 1.03   重复最低
         3、基础机 C12
新零件和发动机   先订备件价格 然后转成服务价

二、审核
三、发布
*/

FIND FIRST code_mstr where code_domain = global_domain and code_fldname = "BCTOCRM" NO-LOCK NO-ERROR.
IF AVAIL code_mstr THEN mpath = code_value.

mpath = mpath + "QAD_CRM_partprice" + STRING(YEAR(TODAY),'9999') + STRING(MONTH(TODAY),'99') + STRING(DAY(TODAY),'99') + ".TXT".


OUTPUT TO VALUE(mpath).

FOR EACH pi_mstr NO-LOCK WHERE pi_domain = global_domain and (pi_expire >= TODAY - 1  OR pi_expire = ?) AND pi_mod_date >= TODAY - 1.
    FIND FIRST pt_mstr WHERE pt_domain = global_domain and pt_part = pi_part_code NO-LOCK NO-ERROR.
    IF AVAIL pt_mstr THEN DO:
        CREATE xx_wkfl.
        ASSIGN xx_part = pi_part_code.
        xx_list = pi_list.
        xx_line = pt_prod_line.
        xx_curr = pi_curr.
        xx_price = pi_list_price.
        xx_start_date = pi_start.
        xx_end_date = pi_expire.
    END.
END.



FOR EACH xx_wkfl NO-LOCK BREAK BY xx_part BY xx_price.

    v_start_date = STRING(YEAR(xx_start_date),"9999") + "-" + STRING(MONTH(xx_start_date),"99") + "-" +  STRING(DAY(xx_start_date),"99").
    v_end_date = STRING(YEAR(xx_end_date),"9999") + "-" + STRING(MONTH(xx_end_date),"99") + "-" +  STRING(DAY(xx_end_date),"99").

    IF ((xx_line >= "1000" AND xx_line <= "16ZZ") OR (xx_line >= "1800" AND xx_line <= "6ZZZ")) AND xx_list = "A12" THEN DO:
        PUT UNFORMATTED xx_part "|".
        PUT UNFORMATTED xx_curr "|".
        PUT UNFORMATTED xx_price "|".
        PUT UNFORMATTED v_start_date "|".
        PUT UNFORMATTED v_end_date  SKIP.
    END.


    ELSE IF (xx_line >= "1700" AND xx_line <= "17ZZ") OR (xx_line >= "7000" AND xx_line <"7W00") OR (xx_line > "7WZZ" AND xx_line < "7Z00") OR (xx_line >= "8000" AND xx_line <="8ZZZ")  THEN DO:
        IF LAST-OF(xx_part) THEN DO:
            PUT UNFORMATTED xx_part "|".
            PUT UNFORMATTED xx_curr "|".
            PUT UNFORMATTED xx_price * 1.03 "|".
            PUT UNFORMATTED v_start_date "|".
            PUT UNFORMATTED v_end_date  SKIP.
        END.

    END.

    ELSE IF ((xx_line > "7W00" AND xx_line <="7WZZ") OR (xx_line >= "7Z00" AND xx_line <="7ZZZ")) AND xx_list = "C12" THEN DO:
        PUT UNFORMATTED xx_part "|".
        PUT UNFORMATTED xx_curr "|".
        PUT UNFORMATTED xx_price "|".
        PUT UNFORMATTED v_start_date "|".
        PUT UNFORMATTED v_end_date  SKIP.
    END.

    /*
    ELSE DO:
        PUT UNFORMATTED xx_part "|".
        PUT UNFORMATTED xx_curr "|".
        PUT UNFORMATTED xx_price "|".
        PUT UNFORMATTED v_start_date "|".
        PUT UNFORMATTED v_end_date  SKIP.
    END.
    */

END.



FIND FIRST code_mstr where code_domain = global_domain and code_fldname = "BCTOCRM" no-lock no-error.
IF AVAIL code_mstr THEN mpath = code_value.

mpath = mpath + "QAD_CRM_replacepart" + STRING(YEAR(TODAY),'9999') + STRING(MONTH(TODAY),'99') + STRING(DAY(TODAY),'99') + ".TXT".


OUTPUT TO VALUE(mpath).


FOR EACH pts_det NO-LOCK.
    v_start_date = "".
    v_end_date = "".
    PUT UNFORMATTED pts_part "|".
    PUT UNFORMATTED pts_sub_part "|".
    PUT UNFORMATTED v_start_date "|".
    PUT UNFORMATTED v_end_date  SKIP.
END.

/* OUTPUT TO VALUE ("\\qadtemp\ftp\QADtoCRM.logfile") APPEND. */
OUTPUT TO VALUE (mpath + "QADtoCRM.logfile") APPEND.
DISP mpath FORMAT "X(100)" TODAY TIME WITH WIDTH 180 STREAM-IO.

OUTPUT CLOSE.
