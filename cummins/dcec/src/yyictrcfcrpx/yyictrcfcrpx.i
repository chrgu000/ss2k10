/* yyictrcfcrpx.i - parameter file                                           */
/*V8:ConvertMode=Maintenance                                                 */
/* REVISION END                                                              */

define {1} shared temp-table temptr
    fields ttr_part    like pt_part
    fields ttr_site    like pt_site
    fields ttr_qtyf    like tr_qty_chg
    fields ttr_cstf    like sct_cst_tot
    fields ttr_qtyt    like tr_qty_chg
    fields ttr_cstt    like sct_cst_tot
    fields ttr_rctpo   like tr_qty_chg
    fields ttr_rctpoc  like sct_cst_tot
    fields ttr_rcttr   like tr_qty_chg
    fields ttr_rcttrc  like sct_cst_tot
    fields ttr_rctunp  like tr_qty_chg
    fields ttr_rctunpc like sct_cst_tot
    fields ttr_rctwo   like tr_qty_chg
    fields ttr_rctwoc  like sct_cst_tot
    fields ttr_isspo   like tr_qty_chg
    fields ttr_isspoc  like sct_cst_tot
    fields ttr_isstr   like tr_qty_chg
    fields ttr_isstrc  like sct_cst_tot
    fields ttr_issunp  like tr_qty_chg
    fields ttr_issunpc like sct_cst_tot
    fields ttr_issso   like tr_qty_chg
    fields ttr_isssoc  like sct_cst_tot
    fields ttr_isswo   like tr_qty_chg
    fields ttr_isswoc  like sct_cst_tot
    fields ttr_invadj  like tr_qty_chg
    fields ttr_invadjc like sct_cst_tot
    fields ttr_cstadj  like tr_qty_chg
    fields ttr_cstadjc like sct_cst_tot
    fields ttr_oth     like tr_qty_chg
    fields ttr_othc    like sct_cst_tot
    index ttr_part_site is primary ttr_part ttr_site.
