define {1} shared variable fn as character.
define {1} shared variable v_key like usrw_key1 no-undo
           initial "Safety_Stock_Ctrl".
define {1} shared temp-table xss_mstr
    fields xss_part like pt_part label "ITEM_NUMBER"
    fields xss_site like pt_site label "SITE"
    fields xss_sfty_stkn as decimal label "SAFETY_STOCK"
    fields xss_sfty_stk as decimal label "SAFETY_STOCK(CURRENT)"
    fields xss_qty_loc like in_qty_oh label "QUANTITY_ON_HAND"
    fields xss_abc  like pt_abc label "ABC_CLASS"
    fields xss_desc like pt_desc1 label "DESCRIPTION"
    fields xss_chk as character format "x(40)" label "RESULT"
    fields xss_k    as   decimal label "K_VALUE"
    fields xss_tat as decimal label "TURN_AROUND_TIMES"
    fields xss_sn  as integer label "SERIAL"
    index xss_index1 is primary xss_part xss_site.
    .
