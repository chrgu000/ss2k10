    FOR EACH xxwk2 BY xxwk2_box_id:
        put STREAM s1 UNFORMATTED
            '"C"'     SPACE(1)
            '"' + xxwk3_shipfr + '"' SPACE(1)
            '"' + xxwk2_box_loc + '"' SPACE(1)
            '"' + xxwk3_shipfr + '"' SPACE(1)
            '"' + xxwk2_box_id + '"' SPACE(1)
            '"' + v_box_item + '"' SPACE(1)
            ' - - 1 '  SPACE(1)
            '"' + xxwk3_shipto + '"' space(1)
            ' - - ' SPACE(1)
            's' + xxwk3_asn_nbr SPACE(1)
            ' - EA - - - - ' SPACE(1)
            /*xxwk1_box_gwt*/ xxwk2_box_cwt  SPACE(1)
            '"' + xxwk2_box_dim + '"' SPACE(1)  /*shipvia = boxdim*/
            ' - - - - - '   SPACE(1)
            SKIP.
        FOR EACH xxwk1 WHERE xxwk1_box_id = xxwk2_box_id:
            put STREAM s1 UNFORMATTED
            '"I"'  SPACE(1)
            '"' + xxwk3_shipfr + '"' SPACE(1)
            '"' + xxwk1_loc + '"' SPACE(1)
            '"' + xxwk3_shipfr + '"' SPACE(1)
            '-'       SPACE(1)
            '"' + xxwk1_part + '"' SPACE(1)
            ' - - '    SPACE(1)
            xxwk1_qty space(1)
            '-'       SPACE(1)
            '"' + xxwk1_sonbr + '"' space(1)
            xxwk1_soln  space(1)
            '"' + 'c' + xxwk1_box_id + '"' SPACE(1)
            ' - EA ' SPACE(1)
            '- - - -' SPACE(1)
            /*xxwk1_box_gwt*/ '-' SPACE(1)
            ' - '
            ' - - - - - '
            SKIP.
        END.
    END.


/*
DEF TEMP-TABLE xxwk2
    FIELDS xxwk2_box_id        AS CHAR     COLUMN-LABEL "箱号"
    FIELDS xxwk2_box_nwt       LIKE ABS_nwt LABEL "净重"
    FIELDS xxwk2_box_gwt       LIKE ABS_gwt LABEL "毛重"
    FIELDS xxwk2_box_cwt       LIKE ABS_nwt LABEL "箱子自重" FORMAT "->>>>>>9.9<<<<<<"
    FIELDS xxwk2_box_wtum      LIKE pt_um
    FIELDS xxwk2_box_dim       AS CHAR LABEL "长宽高" FORMAT "x(24)"
    FIELDS xxwk2_mfg_nwt       LIKE ABS_nwt
    FIELDS xxwk2_box_loc       AS CHAR LABEL "库位"
    INDEX xxwk2_idx1 xxwk2_box_id
    .

DEF TEMP-TABLE xxwk1 
    FIELDS xxwk1_part          LIKE pt_part
    FIELDS xxwk1_desc          LIKE pt_desc1
    FIELDS xxwk1_lot           LIKE ld_lot
    FIELDS xxwk1_qty           LIKE schd_upd_qty
    FIELDS xxwk1_loc           LIKE ld_loc
    FIELDS xxwk1_box_id        AS CHAR LABEL "箱号"
    FIELDS xxwk1_box_nwt       LIKE ABS_nwt LABEL "净重"
    FIELDS xxwk1_mfg_nwt       LIKE ABS_nwt LABEL "系统计算净重"
    FIELDS xxwk1_sonbr         LIKE so_nbr
    FIELDS xxwk1_soln          LIKE sod_line
    FIELDS xxwk1_site          LIKE sod_site
    INDEX xxwk1_idx1 xxwk1_part
    .
*/
