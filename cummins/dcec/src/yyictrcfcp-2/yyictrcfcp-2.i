/* yyictrcfcrpx.i - parameter file                                           */
/*V8:ConvertMode=Maintenance                                                 */
/* REVISION END                                                              */

define {1} shared temp-table temptr
    fields ttr_part    like pt_part
    fields ttr_site    like pt_site
    fields ttr_qtyf    like tr_qty_loc
/*    fields ttr_cstf    like sct_cst_tot  */
    fields ttr_qtyt    like tr_qty_loc
/*    fields ttr_cstt    like sct_cst_tot  */
    fields ttr_rctpo   like ld_qty_oh
/*    fields ttr_rctpoc  like sct_cst_tot  */
    fields ttr_rcttr   like ld_qty_oh
/*    fields ttr_rcttrc  like sct_cst_tot  */
    fields ttr_rctunp  like ld_qty_oh
/*    fields ttr_rctunpc like sct_cst_tot  */
    fields ttr_rctwo   like ld_qty_oh
/*    fields ttr_rctwoc  like sct_cst_tot  */
    fields ttr_isspo   like ld_qty_oh
/*    fields ttr_isspoc  like sct_cst_tot  */
    fields ttr_isstr   like ld_qty_oh
/*    fields ttr_isstrc  like sct_cst_tot  */
    fields ttr_issunp  like ld_qty_oh
/*    fields ttr_issunpc like sct_cst_tot  */
    fields ttr_issso   like ld_qty_oh
/*    fields ttr_isssoc  like sct_cst_tot  */
    fields ttr_isswo   like ld_qty_oh
/*    fields ttr_isswoc  like sct_cst_tot  */
    fields ttr_invadj  like ld_qty_oh
/*    fields ttr_invadjc like sct_cst_tot  */
    fields ttr_oth     like ld_qty_oh
/*    fields ttr_othc    like sct_cst_tot  */
    index ttr_part_site is primary ttr_part ttr_site.
