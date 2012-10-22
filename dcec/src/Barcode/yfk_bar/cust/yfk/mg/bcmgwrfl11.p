 {bcdeclre.i}

DEFINE SHARED VARIABLE cimcase AS CHARACTER.

     /*DEF SHARED TEMP-TABLE t_error
        FIELD t_er_code AS CHAR FORMAT "x(18)"
       FIELD t_er_mess AS CHAR FORMAT "x(30)".*/
     /*   DEF SHARED TEMP-TABLE btrid_tmp
            FIELD btrid LIKE b_tr_id.*/
        FIND FIRST b_ct_ctrl NO-LOCK NO-ERROR.

FIND FIRST b_bf_det  EXCLUSIVE-LOCK WHERE b_bf_tocim = YES /*AND b_bf_sess = g_user*/ AND b_bf_program = cimcase NO-ERROR.
IF AVAILABLE b_bf_det THEN DO:

    OUTPUT TO 'e:\socim.cim'.
     PUT "@@batchload ". PUT  b_bf_program SKIP.
     PUT '"'. PUT CONTROL b_bf_nbr. PUT '" - - - "'. PUT CONTROL b_bf_site. PUT '"' SKIP.
     PUT CONTROL b_bf_line. 
     PUT ""  SKIP. 
     PUT CONTROL b_bf_qty_loc. 
     PUT "" SKIP.
     PUT "." SKIP.
     PUT "yes" SKIP.
     PUT "yes" SKIP.
     PUT "-" SKIP.
     PUT "-" SKIP.
     PUT "@@end".
    OUTPUT CLOSE.

END.

{bcrun.i ""bcmgbdpro.p"" "(INPUT ""e:\socim.cim"",INPUT ""e:\x"")"}



FIND LAST tr_hist NO-LOCK WHERE tr_part = b_bf_part AND tr_type = "ISS-SO" NO-ERROR.
       IF AVAILABLE tr_hist THEN DO:
          CREATE b_tr_hist.
          ASSIGN b_tr_nbr = tr_nbr
              b_tr_line = tr_line
              b_tr_code = ""
              b_tr_part = tr_part
              b_tr_lot = tr_lot
              /*b_tr_ser = tr_ser*/
              b_tr_qty_ord = tr_qty_req
              b_tr_qty_chg = tr_qty_chg
              b_tr_qty_loc = tr_qty_loc
              b_tr_um = tr_um
              b_tr_um1 = ""
              b_tr_um2 = ""
              b_tr_std_cost = 0
              b_tr_cur_cost = 0
              b_tr_tr_cost = 0
              b_tr_date = tr_date
              b_tr_tr_date = tr_date
              b_tr_eff_date = tr_date
              b_tr_type = tr_type
              b_tr_id = tr_trnbr
              b_tr_trnbr = tr_trnbr
              b_tr_time = tr_time
              b_tr_loc = tr_loc
              b_tr_site = tr_site.

          b_bf_tocim = NO.
END.

MESSAGE "completed" VIEW-AS ALERT-BOX.

