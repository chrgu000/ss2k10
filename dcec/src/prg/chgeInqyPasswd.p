/* update the QAD inqire database users password */
{mfdeclre.i "new"}


DEFINE WORKFILE xxwk
    FIELD id LIKE usr_userid
    FIELD name1 LIKE usr_name
    FIELD group1 LIKE usr_group
    FIELD lang LIKE usr_lang
    FIELD passwd LIKE usr_passwd. /*define the input table*/

DEFINE VAR srcfile AS CHAR FORMAT "X(40)". /*define the input file name*/
DEFINE STREAM src. /*define input stream */
DEFINE VAR xx_data AS CHAR EXTENT 20 FORMAT "X(200)". /*define the temp input data*/
DEFINE VAR i AS INTE.

srcfile = "\\qadtemp\appeb2\batch\inbox\inqypwd.txt".

IF SEARCH(srcfile) = ? THEN DO:
    MESSAGE "源文件" + srcfile + "不存在" .
END.

FOR EACH xxwk:
    DELETE xxwk.
END.

INPUT STREAM src FROM VALUE(srcfile).
i = 0.
REPEAT:
    xx_data = "".
    i = i + 1.
    IMPORT STREAM src DELIMITER ";" xx_data.
    IF i >= 1 THEN DO:
        CREATE xxwk.
        ASSIGN xxwk.id = TRIM(xx_data[1])
               xxwk.name1 = TRIM(xx_data[2])
               xxwk.group1 = TRIM(xx_data[3])
               xxwk.lang = TRIM(xx_data[4])
               xxwk.passwd = xx_data[5].
    END.
END. /*input the data */

FOR EACH usr_mstr.
    FIND FIRST xxwk WHERE xxwk.id = usr_userid NO-LOCK NO-ERROR.
    IF AVAIL xxwk THEN ASSIGN usr_passwd = xxwk.passwd.
END. /*change the inqire password*/
