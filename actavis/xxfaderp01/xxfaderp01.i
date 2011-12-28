/*V8:ConvertMode=FullGUIReport                                                */
define {1} shared temp-table tmp_xfa
    fields tx_group     as   character initial "A"
    fields tx_faid      like fa_id
    fields tx_fa_loc    like fa_faloc_id
    fields tx_facls_id  like fa_facls_id
    fields tx_fabk_id   like fab_fabk_id
    fields tx_auth_nbr  like fa_auth_number
    fields tx_saveas    like fa__chr01 format "x(24)"
    fields tx_startdt   like fa_startdt
    fields tx_cstcent   like ap_cc
    fields tx_restype   as   character
    fields tx_salvamt   like fa_salvamt
    fields tx_life      like fab_life
    fields tx_mthDeptRt as   decimal
    fields tx_mthDept   like fa_puramt
    fields tx_puramt    like fa_puramt
    fields tx_costAmt   like fabd_peramt
    fields tx_accDepr   like fabd_accamt
    fields tx_netBook   like fabd_peramt
    fields tx_annDepr   like fabd_accamt.
