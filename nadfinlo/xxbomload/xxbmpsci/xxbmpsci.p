/* xxbmsuci.p - bom load                                                      */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120703.1 LAST MODIFIED: 07/03/12 BY:                            */
/* REVISION END                                                              */
{mfdeclre.i}
{xxbmpsci.i}
define variable vfile as character.
define stream bf.

if cloadfile then do:
   for each xps_wkfl exclusive-lock:
       assign vfile = execname + "." + string(xps_sn,"99999").
       output stream bf to value(vfile + ".bpi").
       put stream bf unformat '"' trim(xps_par) '"' skip.
       put stream bf unformat '"' trim(xps_comp) '" "' trim(xps_ref) '" ' xps_start skip.
       put stream bf unformat trim(string(xps_qty_per),"->>>>>>>>9.<<") ' "' trim(xps_ps_code) '" ' xps_start ' ' xps_end ' "'.
       put stream bf unformat trim(xps_rmks) '" ' xps_scrp_pct ' ' xps_lt_off ' '.
       put stream bf unformat xps_op ' ' xps_item_no ' ' xps_fcst_pct ' "' trim(xps_group) '" "'.
       put stream bf unformat trim(xps_process) '"' skip.
       put stream bf unformat '.' skip.
       output stream bf close.
       pause 0 before-hide.
       batchrun = yes.   
       cimrunprogramloop:                                                    
       do transaction on stop undo cimrunprogramloop,leave cimrunprogramloop:
          input from value(vfile + ".bpi").
          output to value(vfile + ".bpo") keep-messages.
          hide message no-pause.
             {gprun.i ""bmpsmt.p""}
          hide message no-pause.
          output close.
          input close.
          batchrun = no.
          pause before-hide.
          find first ps_mstr no-lock where ps_par = xps_par 
                 and ps_comp = xps_comp
                 and ps_ref = xps_ref
                 and ps_start = xps_start no-error.
          if available ps_mstr and 
                       xps_qty_per = ps_qty_per and   
                       xps_ps_code = ps_ps_code and     
                       xps_end     = ps_end and         
                       xps_rmks    = ps_rmks and        
                       xps_scrp_pct = ps_scrp_pct and    
                       xps_lt_off   = ps_lt_off and      
                       xps_op       = ps_op and          
                       xps_item_no  = ps_item_no and     
                       xps_fcst_pct = ps_fcst_pct and   
                       xps_group = ps_group and          
                       xps_process = ps_process       
          then do:
               assign xps_chk = "OK".
          end.
          else do:
               {gprun.i ""xxgetcimerr.p"" "(input vfile + '.bpo' ,output xps_chk)"}
               undo,next.
          end.
       end.       
   end.
end.   /* if cloadfile then do: */
