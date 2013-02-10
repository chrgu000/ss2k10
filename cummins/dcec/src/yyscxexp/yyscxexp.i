/* GUI CONVERTED from xxscxexp.i (converter v1.78) Thu Dec  6 12:03:47 2012 */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

define {1} shared variable schtype as integer initial 4.
define {1} shared variable order like scx_order.
define {1} shared variable rlseid_from like rcsd_rlse_id.
define {1} shared temp-table xxsch_dtidx
       fields xdti_date as date
       fields xdti_time like schd_time
       fields xdti_idx as integer
       index xdti_dt is primary xdti_date xdti_time
       index xdti_idx xdti_idx
       .
