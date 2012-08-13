DEF INPUT PARAMETER bc_id AS CHAR.
DEF INPUT PARAMETER bc_site AS CHAR.
DEF INPUT PARAMETER bc_loc AS CHAR.
FIND FIRST b_co_mstr WHERE b_co_code = bc_id EXCLUSIVE-LOCK NO-ERROR.
ASSIGN
          b_co_status = 'rct'
          b_co_site = bc_site
          b_co_loc = bc_loc.
