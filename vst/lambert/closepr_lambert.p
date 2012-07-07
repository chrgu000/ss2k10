define var v_date as date .


def temp-table a
  field a1 like rqd_nbr 
  field a2 like rqd_line
  .
input from /db2/vst/prclose.csv.

repeat:
  create a.
  import delimiter ',' a1 a2 .
end.
input close.

output to /db2/vst/pr_error.txt.
for each a where a1 <> ''  with frame x width 100:
    find first rqd_d where rqd_nbr = a1
                 and rqd_line = a2 no-wait no-error.
    if available rqd_d then do:
       assign rqd_status = "c".
       {gprun.i ""rqmrw.p""
                 "(input false, input rqd_site, input rqd_nbr, input rqd_line)"}
    end.
    if not available rqd_d then do:
      if locked rqd_d then do:
                disp a1 a2  " locked". 
                next.
      end.
      else do:
            disp a1  a2  .
      end.
    end.
end.
output close.

