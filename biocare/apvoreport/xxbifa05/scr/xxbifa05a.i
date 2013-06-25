               
define {1} shared variable entity            like gltr_entity no-undo.
define {1} shared variable entity1           like gltr_entity no-undo.
define {1} shared variable ref               like glt_ref     no-undo.
define {1} shared variable ref1              like glt_ref     no-undo.
define {1} shared variable dt                like glt_date    no-undo.
define {1} shared variable dt1               like glt_date    no-undo.
define {1} shared variable effdt             like glt_effdate no-undo.
define {1} shared variable effdt1            like glt_effdate no-undo.
define {1} shared variable batch              like glt_batch   no-undo.
define {1} shared variable batch1             like glt_batch   no-undo.
define {1} shared variable type              like glt_tr_type no-undo.
define {1} shared variable type1             like glt_tr_type no-undo.

define {1} shared variable user-id LIKE gltr_user .
define {1} shared variable unb               like glt_unb label "Unbalanced Only" no-undo.

define {1} shared variable name_reports             like ad_name no-undo.
define {1} shared variable name_usr             like usr_name no-undo.

DEFINE {1} SHARED TEMP-TABLE tt1 
    FIELD tt1_ref  LIKE gltr_ref 
    FIELD tt1_line LIKE gltr_line
    FIELD tt1_desc LIKE gltr_desc
    FIELD tt1_ascp  AS CHAR
    FIELD tt1_as_desc AS CHAR
    FIELD tt1_cp_desc AS CHAR
    FIELD tt1_ex_rate AS CHAR 
    FIELD tt1_char1 AS CHAR
    FIELD tt1_user2 AS CHAR
    FIELD tt1_effdate AS CHAR
    FIELD tt1_dr_amt AS DECIMAL
    FIELD tt1_cr_amt AS DECIMAL
    FIELD tt1_decimal1 AS DECIMAL
    FIELD tt1_curramt AS DECIMAL
    FIELD tt1_page AS CHAR /* 当前页码 */
    INDEX ref_line tt1_ref tt1_line
    .

DEFINE {1} SHARED TEMP-TABLE tt2 
    FIELD tt2_ref  LIKE gltr_ref 
    FIELD tt2_line LIKE gltr_line
    FIELD tt2_desc LIKE gltr_desc /* 中文大写金额 */
    FIELD tt2_ascp  AS CHAR /* 签名 */
    FIELD tt2_as_desc AS CHAR /* 打印信息 */
    FIELD tt2_cp_desc AS CHAR /* 公司 */
    FIELD tt2_ex_rate AS CHAR 
    FIELD tt2_char1 AS CHAR
    FIELD tt2_user2 AS CHAR
    FIELD tt2_effdate AS CHAR
    FIELD tt2_dr_amt AS DECIMAL
    FIELD tt2_cr_amt AS DECIMAL
    FIELD tt2_decimal1 AS DECIMAL /* 借方合计金额绝对值 */
    FIELD tt2_curramt AS DECIMAL
    FIELD tt2_page AS CHAR /* 总页码 */
    INDEX ref_line tt2_ref tt2_line
    .

