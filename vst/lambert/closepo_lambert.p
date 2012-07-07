
def temp-table a
  field a1 like pod_nbr 
  field a2 like pod_line
  .
input from /db2/vst/poclose.csv.
repeat:
  create a.
  import delimiter ',' a1 a2 .
end.
input close.

output to /db2/vst/po_error.txt.
    for each a where a1 <> '':

        find pod_det where pod_nbr = a1
                     and pod_line = a2 
        exclusive-lock no-wait no-error.
        if not available pod_det then do: 
           if locked pod_det then do:
                disp a1 a2  " locked". 
                next.
           end.
           else do:
                 disp a1  a2  .
           end.
        end.

        if available pod_det then do:
           pod_status = "c".
           if pod_status = "c" or pod_status = "x" or  pod_type <> "" then openqty = 0  then do:
             {mfmrw.i "pod_det"
             pod_part
             pod_nbr
             string(pod_line)
             """"
             ?
             v_date
             0
             "SUPPLY"
             "PURCHASE ORDER"
             pod_site}    
           end.
        end.
    end.
output close.