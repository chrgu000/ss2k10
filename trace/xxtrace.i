/* xxtrace.i - add tracer hist                                               */
/*V8:ConvertMode=NoConvert                                                   */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 11YJ LAST MODIFIED: 01/19/11   BY: zy                           */
/* REVISION END                                                              */
procedure addtcehst:
    define input parameter tbl  as character.
    define input parameter fld  as character.
    define input parameter typ  as character.
    define input parameter aft  as character.
    define input parameter bef  as character.
    define input parameter rid  as integer.
    define input parameter dom  as character.
    define input parameter part like pt_mstr.pt_part.
    define input parameter site like si_mstr.si_site.
    define input parameter nbr  like wo_mstr.wo_nbr.
    define input parameter key0 as character.
    define input parameter key1 as character.
    define input parameter key2 as character.
    define input parameter key3 as character.
    define input parameter key4 as character.
    define input parameter key5 as character.
    define input parameter key6 as character.
    define input parameter key7 as character.
    define input parameter key9 as character.
    define input parameter key8 as character.
    define variable vlvl as integer no-undo.

    if bef = ? then bef = "".
    if aft = ? then aft = "".

    if (typ = "W") and (bef = aft) then return .
    create tce_hist .
    assign tce_table = tbl
           tce_fld = fld
           tce_type = TYP
           tce_aval = aft
           tce_bval = bef
           tce_tabrecid = rid
           tce_domain = dom
           tce_part = part
           tce_site = site
           tce_nbr = nbr
           tce_date = today
           tce_time = time
           tce_userid = global_userid
           tce_key0 = if key0 = ? then "" else key0
           tce_key1 = if key1 = ? then "" else key1
           tce_key2 = if key2 = ? then "" else key2
           tce_key3 = if key3 = ? then "" else key3
           tce_key4 = if key4 = ? then "" else key4
           tce_key5 = if key5 = ? then "" else key5
           tce_key6 = if key6 = ? then "" else key6
           tce_key7 = if key7 = ? then "" else key7
           tce_key8 = if key8 = ? then "" else key8
           tce_key9 = if key9 = ? then "" else key9.

    FOR EACH mon_mstr NO-LOCK WHERE mon_sid = mfguser,
        EACH qaddb._connect NO-LOCK WHERE mon__qadi01 = _Connect-Usr:
      assign tce_osuser    = _connect-name
             tce_host      = _connect-device
             tce_dev       = _connect-device
             tce_interface = mon_interface
             tce_startDate = mon_date_start
             tce_prog      = mon_program
             tce_logindate = mon_login_date
             tce_logintime = mon_login_time.
    END.
    vlvl = 3.
    REPEAT WHILE (PROGRAM-NAME(vlvl) <> ?)
             AND INDEX(PROGRAM-NAME(vlvl), "gpwinrun") = 0:
      tce_stack = tce_stack + string(vlvl - 2, "99")
                + ":" + program-name(vlvl) + "; ".
      vlvl = vlvl + 1.
    END.
    qad_next_seq:
    do while true on error undo, retry:
        do on error undo, leave:
            assign
                tce_recid = next-value(tce_sq01).
            if tce_recid = 0 then next qad_next_seq.
            leave qad_next_seq.
        end.
    end.
end procedure .
