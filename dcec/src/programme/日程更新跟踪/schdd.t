TRIGGER PROCEDURE FOR DELETE OF schd_det.
{mfdeclre.i}

define var entryid as int.

if int(schd_det.schd_type) > 3 and execname <> "rssup.p" and execname <> "yyrssup.p" then do: 
   for first po_mstr fields(po_nbr po_vend) where po_nbr = schd_det.schd_nbr no-lock:
   end.
   for first pod_det fields(pod_nbr pod_line pod_part) where pod_nbr = schd_det.schd_nbr and pod_line = schd_det.schd_line    no-lock:
   end.
   if available po_mstr then do:
   for last aud_det use-index aud_entry no-lock:
   end.
   if available aud_det then entryid = aud_entry + 1.
   else entryid = 1.
   create aud_det.
   assign aud_dataset = "schd_det"
          aud_key1    = po_mstr.po_vend
          aud_key2    = "0"
          aud_key3    = schd_det.schd_nbr
          aud_key4    = schd_det.schd_rlse_id
          aud_key5    = string(schd_det.schd_line)
          aud_key6    = string(schd_det.schd_date)
          aud_key7    = execname
          aud_date    = today
          aud_time    = string(time,"HH:MM:SS")
          aud_entry   = entryid
          aud_userid  = global_userid
          aud_field   = "schd_discr_qty"
          aud_user1   = pod_det.pod_part
          aud_old_data[1] = string(schd_det.schd_discr_qty)
          aud_new_data[1] = "Delete".
end.
end.
          
