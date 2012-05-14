/*zzshdef1.i  */
/*Last Modify by Leo Zhou   11/08/2011 */
/*Last Modify by Leo Zhou   03/24/2012    *CLZ1*/

def {1} shared temp-table tt
    field tt_line   as int format ">>9"
    field tt_key1   as logical format "Y/N"
    field tt_key2   as logical format "Y/N"
    field tt_key3   as char format "x(1)"
    field tt_lotno  as char format "x(15)"
    field tt_def    as char format "x(1)"
    field tt_star   as char format "x(1)"
    field tt_mfd    as deci format ">9.99"
    field tt_lc     as deci format ">>,>>9"
    field tt_l0     as deci format ">>,>>9.9"
    field tt_dia    as deci format ">>9.9<"
    field tt_efflen as int  format ">>,>>9"
    field tt_totwt  as deci format ">>>,>>9.9"
    field tt_calwt  as deci format ">>>,>>9.9"
    field tt_diavar as deci format ">9.99"
    field tt_dn     as deci format ">9.99"
    field tt_ecc    as deci format ">9.99"
    field tt_bow    as deci format ">9.99"
    field tt_ellip  as deci format ">9.99"
    field tt_bubb   as char format "x(1)" 
    field tt_gdwt   as deci format ">>>,>>9.9"  /*CLZ1*/
    index tt_idx1 tt_key1 descending tt_key2 descending tt_lotno ascending
    index tt_idx2 tt_key2 descending tt_key1 descending tt_lotno ascending
    index tt_line tt_line ascending.

def {1} shared temp-table wf
    field wf_lotno   as char
    field wf_calwt   as deci
    field wf_shiplot as char
    field wf_defect  as char
    field wf_star    as char.
