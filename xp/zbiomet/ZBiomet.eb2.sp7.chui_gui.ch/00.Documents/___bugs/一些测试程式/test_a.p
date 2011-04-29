output to C:\

for each tr_hist no-lock
   where tr_type = "RCT-WO"
     and tr_effdate >= 01/01/08:

   find first pt_mstr where pt_part = tr_part no-lock no-error.
   
   if available pt_mstr then do:
      if lower(pt_desc1) begins "bearing" 
         and index(pt_prod_line,"FG") > 0 
      then do:
        
         display pt_part pt_desc1 
                 tr_effdate tr_loc tr_lot tr_qty_loc tr_trnbr
         with down frame a stream-io.
     
      end.   
   end.
end.