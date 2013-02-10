/* GUI CONVERTED from yyictrrp.i (converter v1.78) Wed Dec  5 15:49:42 2012 */
/* yyictrrp.i - yyictrrp.i                                                   */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120713.1 LAST MODIFIED: 07/13/12 BY: zy                         */
/* REVISION END                                                              */


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

DEFINE {1} SHARED TEMP-TABLE xim
    FIELDS xim_nbr LIKE tr_nbr
    FIELDS xim_part LIKE pt_part
    FIELDS xim_desc like pt_desc1
    FIELDS xim_qty_req LIKE ld_qty_oh
    FIELDS xim_fsite LIKE si_site
    FIELDS xim_floc LIKE ld_loc
    FIELDS xim_flot LIKE ld_lot
    FIELDS xim_tsite LIKE si_site
    FIELDS xim_tloc LIKE ld_loc
    FIELDS xim_tlot LIKE ld_lot
    FIELDS xim_effdate like tr_effdate
    FIELDS xim_sn   as integer.
