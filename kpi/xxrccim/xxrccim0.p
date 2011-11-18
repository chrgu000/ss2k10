/*V8:ConvertMode=Report                                                       */

{xxrccim.i}
define variable fn as character.
define variable vnbr as character.
define variable vline as integer.
define variable vid   as character.
DEFINE STREAM aa  .
DEFINE STREAM cc  .
empty temp-table xsch_mstr no-error.

  assign fn = file_name.
/***从.txt读入资料***************/
input from value(fn).

  repeat:
    create xsch_mstr.
    IMPORT DELIMITER ","
           xsch_order xsch_line
           xsch_rlseid
           xsch_pcsdate
           xsch_lrasn xsch_lrdate xsch_lrtime xsch_lrqty xsch_lrcum
           xsch_date xsch_time xsch_interval xsch_ref xsch_updqty xsch_fcqual
           no-error.
  end.

INPUT close.
/***从.txt读入资料***************/

 
FOR EACH xsch_mstr exclusive-lock where xsch_date = ?:
    delete xsch_mstr.
end.

for each xsch_mstr exclusive-lock break by recid(xsch_mstr):
    if xsch_order <> "" then do:
       assign vnbr = xsch_order.
    end.
    if xsch_rlseid <> "" then do:
       assign vid = xsch_rlseid.
    end.
    if xsch_line <> 0 and xsch_line <> ? then do:
       assign vline = xsch_line.
    end.
    if xsch_order = "" and vnbr <> "" then do:
       assign xsch_order = vnbr.
    end.
    if xsch_line = 0 and vline > 0 then do:
       assign xsch_line = vline.
    end.
    if xsch_rlseid = "" and vid <> "" then do:
       assign xsch_rlseid = vid.
    end.
end.

for each xsch_mstr no-lock:
    if xsch_date <> ? and xsch_time <> "" then do:
        create xschd_det.
        assign xschd_order   = xsch_order
        			 xschd_line    = xsch_line
               xschd_rlseid  = xsch_rlseid
               xschd_date    = xsch_date
               xschd_time    = xsch_time
               xschd_interva = xsch_interva
               xschd_ref     = xsch_ref
               xschd_updqty  = xsch_updqty
               xschd_fcqual  = xsch_fcqual.
    end.
end.
