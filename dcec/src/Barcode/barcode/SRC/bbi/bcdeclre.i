DEF VAR success AS LOGICAL .
success = YES.
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
    FIELD bd_merge_ref AS CHAR
    FIELD bd_merge_qty AS DECIMAL.
DEF {1} SHARED TEMP-TABLE cimchk_lst
    FIELD cimchk_code AS CHAR
    FIELD cimchk_value AS CHAR.
DEF {1} SHARED TEMP-TABLE btrid_tmp
    FIELD btrid LIKE b_tr_id.
DEF VAR part AS CHAR.
part = ''.
DEF VAR qty AS DECIMAL.
   qty = 0.
   
 DEF VAR lntyp AS CHAR.  
   
lntyp = ''.
DEF {1} SHARED VAR bc_exec AS CHAR.
DEFINE {1}  {2} SHARED variable mfusr AS CHAR.
DEFINE {1}  {2} SHARED variable g_user AS CHAR.
 DEF VAR mcount LIKE b_tr_id.
DEF {1} SHARED VAR issmall AS LOGICAL.
DEF {1} SHARED VAR bc_name AS CHAR.
DEF VAR bid AS INTEGER.
