/* xxrepkdis1.i - display workorder seqerence                                */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 24YP LAST MODIFIED: 04/24/12 BY: zy expand xrc length to 120    */
/* REVISION END                                                              */
   
       for each tmp_file0:                               
       display t0_date                                   
               t0_record                                 
               t0_site                                   
               t0_line                                   
               t0_sn                                     
               t0_part                                   
               t0_wktime                                 
               t0_tttime                                 
               string(t0_start ,"hh:mm:ss") @ t0_start   
               string(t0_end ,"hh:mm:ss") @ t0_end       
               t0_qtyA                                   
               t0_qty                                    
               t0_user1                                  
    with width 300 stream-io.                            
	end.
/**************
for each tmp_file0 no-lock with frame tmpfile0 with width 300:
    setFrameLabels(frame tmpfile0:handle).
    display t0_date
            t0_site
            t0_line
            t0_part
            t0_user1
            t0_sn
            string(t0_start,"hh:mm:ss") @ t0_start
            string(t0_end,"hh:mm:ss") @ t0_end
            t0_wktime
            t0_qtya
            t0_qty
            t0_tttime.
end.
**********/