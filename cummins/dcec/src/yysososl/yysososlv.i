define {1} shared variable loc  like ld_loc no-undo label "Loc".
define {1} shared variable loc1 like ld_loc no-undo Label "To".
define {1} shared variable xxlog as log label "考虑最小包装量(Y/N)" initial yes.
define {1} shared variable xxlot as log label "按批序号备料" initial yes.
define {1} shared variable vkey2k13 as character initial "yysososltmp2013.".

/*
define {1} shared temp-table tmpld3
       fields l3_domain like ld_domain
       fields l3_site like ld_site
       fields l3_loc like ld_loc
       fields l3_part like ld_part
       fields l3_lot like ld_lot
       fields l3_ref like ld_ref
       fields l3_ostat like ld_status
       index index1 is primary l3_domain l3_site l3_loc l3_part l3_lot l3_ref .

procedure setldUnavl:
    define variable vstat like is_status.
    find first is_mstr no-lock where is_domain = global_domain and
           not is_avail no-error.
    if available is_mstr then do:
       assign vstat = is_status.
    end.
    find first is_mstr no-lock where is_domain = global_domain and
           not is_avail and not is_nettable no-error.
    if available is_mstr then do:
       assign vstat = is_status.
    end.
    do transaction:
       for each  usrw_wkfl no-lock where usrw_domain = global_domain
                           and usrw_key1 = vkey2k13 + global_userid:
           find first ld_det exclusive-lock where ld_domain = global_domain
                  and ld_site = usrw_key3 and ld_loc = usrw_key4        
                  and ld_part = usrw_key5 and ld_lot = usrw_key6        
                  and ld_ref = usrw_charfld[1] no-error.
           if available ld_det then do:
              assign ld_status = vstat.
           end.
       end.
    end.
end.

procedure retoldval:
    do transaction:
    for each  usrw_wkfl exclusive-lock where usrw_domain = global_domain
                        and usrw_key1 = vkey2k13 + global_userid:
        find first ld_det exclusive-lock where ld_domain = global_domain
               and ld_site = usrw_key3 and ld_loc = usrw_key4        
               and ld_part = usrw_key5 and ld_lot = usrw_key6        
               and ld_ref = usrw_charfld[1] no-error.
        if available ld_det then do:
           assign ld_status = usrw_charfld[2].
           delete usrw_wkfl.
        end.
    end.
    end. /* do transaction*/
end.
*/