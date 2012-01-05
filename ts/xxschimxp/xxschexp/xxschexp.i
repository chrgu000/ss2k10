/*V8:ConvertMode=Report                                                       */

define {1} shared variable schtype as integer initial 4.
define {1} shared variable vpo like scx_po. /* initial "P1251100". */
define {1} shared variable vrlseid like rcsd_rlse_id. /*nitial "20111207-001".*/ 
define {1} shared temp-table xxsch_dtidx
       fields xdti_date as date
       fields xdti_time like schd_time
       fields xdti_idx as integer
       index xdti_dt is primary xdti_date xdti_time
       index xdti_idx xdti_idx
       .
