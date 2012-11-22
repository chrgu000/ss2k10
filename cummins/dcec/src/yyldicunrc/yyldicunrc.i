define {1} shared variable fn as character.
define {1} shared temp-table xim
    fields xim_part    like pt_part
    fields xim_qty     like ld_qty_oh
    fields xim_site    like ld_site
    fields xim_sojob   like rbm_rsn
    fields xim_nbr     like tr_nbr
    fields xim_rmks    like tr_rmks
    fields xim_effdate like tr_effdate
    fields xim_lot     like ld_lot
    fields xim_chk     like mph_rsult format "x(40)"
    fields xim_loc     like ld_loc
    fields xim_sn      as integer label "serial"
    .
