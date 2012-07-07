
def temp-table a
  field a1 like pod_nbr 
  field a2 like pod_line
  .
define var openqty like pod_qty_ord.
define var v_date like pod_due_date.

v_date = date(3,8,2012).

input from /db2/vst/po.csv.
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
           assign pod_due_date = v_date.
           if pod_qty_ord >= 0 then
              openqty = max(pod_qty_ord - pod_qty_rcvd,0) * pod_um_conv.
           else
              openqty = min(pod_qty_ord - pod_qty_rcvd,0) * pod_um_conv.
           if pod_status = "c" or pod_status = "x" or  pod_type <> "" then openqty = 0  then do:
             {mfmrw.i "pod_det"
             pod_part
             pod_nbr
             string(pod_line)
             """"
             ?
             v_date
             openqty
             "SUPPLY"
             "PURCHASE ORDER"
             pod_site}    
           end.
        end.
    end.
output close.