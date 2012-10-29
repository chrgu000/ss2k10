define {1} shared variable v_gtaxid     like ad_name  format "x(4)".
define {1} shared variable v_companyid  like ad_name  format "x(8)".
define {1} shared variable v_adname     like ad_name  format "x(40)".
define {1} shared variable v_userstr    like usr_name format "x(60)".
define {1} shared variable v_username   like usr_name format "x(30)".
define {1} shared variable v_sitestr    like usr_name format "x(60)".

define {1} shared variable v_itemgtax   as character.
define {1} shared variable v_itemkind   as character.


define {1} shared variable v_p01        as char format "x(8)".
define {1} shared variable v_p02        as char format "x(8)".
define {1} shared variable v_p03        as char format "x(8)".

define {1} shared variable v_outtaxin   as logical.
define {1} shared variable v_intaxin    as logical.
define {1} shared variable v_infixrd    as logical.
define {1} shared variable v_inpost     as logical.
define {1} shared variable v_drange     as decimal format "9.999".
define {1} shared variable v_invprex    as character.


define {1} shared variable v_gtax_ip    as character.
define {1} shared variable v_gtax_id    as character.
define {1} shared variable v_gtax_pw    as character.
define {1} shared variable v_gtax_inbox as character.
define {1} shared variable v_gtax_otbox as character.

define {1} shared variable v_box        as character extent 5.

define {1} shared variable v_name_pre   as character extent 5.
define {1} shared variable v_name_ext   as character extent 5.
define {1} shared variable v_name_body  as character extent 5.
define {1} shared variable v_name_def   as character extent 5.
define {1} shared variable v_name_seq   as integer   extent 5.
define {1} shared variable v_name_date  as date      extent 5.

define {1} shared variable gdinvmaxamt as decimal. 