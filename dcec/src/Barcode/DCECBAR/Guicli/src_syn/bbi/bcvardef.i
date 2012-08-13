DEF VAR pass AS LOGICAL.
pass = YES.
DEF {1} SHARED  TEMP-TABLE iss_list
    FIELD iss_part AS CHAR
    FIELD iss_lotser AS CHAR
    FIELD iss_ref AS CHAR
    FIELD iss_um AS CHAR
    FIELD iss_qty AS DECIMAL
   FIELD iss_site AS CHAR
   FIELD iss_loc AS CHAR.
DEF  {1} SHARED  TEMP-TABLE bd_merge_list
    FIELD bd_merge_id AS CHAR
    FIELD bd_merge_part AS CHAR
    FIELD bd_merge_lotser AS CHAR
    FIELD bd_merge_pack AS CHAR
    FIELD bd_merge_qty AS DECIMAL
    FIELD bd_merge_site AS CHAR
    FIELD bd_merge_loc AS CHAR.
DEF {1} SHARED TEMP-TABLE cimchk_lst
    FIELD cimchk_code AS CHAR
    FIELD cimchk_value AS CHAR.
DEF {1} SHARED TEMP-TABLE btrid_tmp
    FIELD btrid LIKE b_tr_trnbr.

DEF {1} SHARED VAR part AS CHAR.

DEF {1} SHARED VAR qty AS DECIMAL.
   qty = 0.
   
 DEF {1} SHARED VAR lntyp AS CHAR.  
   DEF {1} SHARED VAR amt AS DECIMAL.
lntyp = ''.
