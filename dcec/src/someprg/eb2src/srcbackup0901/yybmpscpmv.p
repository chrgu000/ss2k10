/*zzbmpscpmv.p - verify the all components of non-phantom for bom copy
between different site	                                               */
/* REVISION: 8.5         MODIFIED: 12/23/03      BY: Kevin             */
/*Note:(Kevin,12/23/2003)***********************************************
Add a new function to verify the all components of non-phantom
for BOM copy between different site(Now,only "DCEC-C" to "DCEC-B").
The name of the new program is: zzbmpscpmv.p
***********************************************************************/

        {mfdeclre.i}

        def shared var msg_file as char format "x(40)".    /*kevin,12/23/2003*/
        def shared var pass_yn as logic.                   /*kevin,12/23/2003*/
        def shared var bom-type like bom_fsm_type.              /*kevin*/
        def shared var site1 like si_site.             /*kevin*/
        def shared var site2 like si_site.             /*kevin*/
        def shared var sel-yn as logic initial "No".                    /*kevin*/
                
         define shared variable part1          like ps_par label "源结构".
         define shared variable part2          like ps_par label "目标结构".
         define shared variable dest_desc      like pt_desc1
                                        label "目的地描述".
         define shared variable desc1          like pt_desc1 no-undo.
         define shared variable desc3          like pt_desc1 no-undo.
         define shared variable um1            like pt_um label "UM".
         define shared variable um2            like pt_um label "UM".

         define shared buffer ps_from for ps_mstr.

         def var ps_from_recno as recid format "->>>>>>9".              /*kevin*/
         define variable first_sw_call as logical initial true.      /*kevin*/
         def var framename as char format "x(40)".           /*kevin*/  
	 define variable parent like ps_comp.                /*kevin*/
	 define variable level as integer.               /*kevin*/
	 define variable record as integer extent 100.     /*kevin*/
         def var topart like bom_parent extent 100.   /*kevin*/  
        def var effdate like tr_effdate.        /*kevin,12/23/2003*/
        
         def workfile xxpt
              field par like ps_par label "源结构"
                field comp like ps_comp
                field desc2 like pt_desc2
              field msg as char format "x(40)" label "出错提示".
       
       
       for each xxpt:
             delete xxpt.
       end.            
       
	    assign parent = part1
	           level = 1.
	    
	    find first ps_from use-index ps_parcomp where ps_from.ps_par = parent
	       no-lock no-error.
	    repeat:

	       if not available ps_from then do:
		  repeat:
		     level = level - 1.
		     if level < 1 then leave.
		     find ps_from where recid(ps_from) = record[level]
		     no-lock no-error.
		     parent = ps_from.ps_par.
		     find next ps_from use-index ps_parcomp where ps_from.ps_par = parent
		     no-lock no-error.
		     if available ps_from then leave.
		  end.
	       end.
	       if level < 1 then leave.
              
              if level = 1 and (sel-yn and ps_from.ps__chr02 = "") then do:
		      find next ps_from use-index ps_parcomp where ps_from.ps_par = parent
		      no-lock no-error.
              end.
              else do:      
                  
                effdate = today.
                  
	           if effdate = ? or (effdate <> ? and
	           (ps_start = ? or ps_start <= effdate)
	           and (ps_end = ? or effdate <= ps_end)) then do:

                        record[level] = recid(ps_from).
                        
                     find first xxpt where xxpt.comp = ps_from.ps_comp no-lock no-error.
                     if not available xxpt then do:
                            find pt_mstr where pt_part = ps_from.ps_comp no-lock no-error.
                            if available pt_mstr then do:
                                find ptp_det where ptp_part = ps_from.ps_comp and ptp_site = site1 no-lock no-error.
                                if available ptp_det and not ptp_phantom then do:
                                    create xxpt.
                                    assign xxpt.par = part1
                                           xxpt.comp = ps_from.ps_comp
                                           xxpt.desc2 = pt_desc2.
                                
                                    find ptp_det where ptp_part = xxpt.comp and ptp_site = site2 no-lock no-error.
                                    if not available ptp_det then do:
                                        assign xxpt.msg = "未维护地点 " + site2 + " 的计划数据".
                                        pass_yn = no.
                                    end.    
                                end.    
                                        
                            end.
                     end.   
                        
		         parent = ps_from.ps_comp.
		         level = level + 1.
		         find first ps_from use-index ps_parcomp where ps_from.ps_par = parent
		         no-lock no-error.
		    end.
		   else do:
                      find next ps_from use-index ps_parcomp where ps_from.ps_par = parent
		         no-lock no-error.		   
		   end.     

		      
		end. /*else do,not (level = 1 and (sel-yn and ps_from.ps__chr02 = ""))*/
		     
	    end. /*repeat for ps_from expand*/
            
            /*output to the error lines*/
          output close.
          output to value(msg_file).
          for each xxpt where xxpt.msg <> "" no-lock:
               disp xxpt with width 132 stream-io.
          end.
              
