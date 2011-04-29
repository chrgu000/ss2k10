/* xxwodvmt.p - For Work Order genbral and Receipt Backflush  CIM LOAD      */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=NoConvert                                                  */
/* REVISION: 1.0      Create : 07/21/06   BY: tommy                         */

         /* DISPLAY TITLE */
         {mfdtitle.i "1.0 "}
         
	 /* By SS Davild 20060808 --BEGIN*/
         def var tmp_loc as char .
	 def var tmp_lot as char .
	 def var tmp_qty_oh like ld_qty_oh .
	 def var tmp_desc1 as char format "x(48)" label "描 述" .
	 def var err_mss as logi.
	 def var err_mss_a_e as logi.
	 def var err_mss_a as logi.
	 /* By SS Davild 20060808 --END*/
	 	          
         define variable site as char label "地點" init "20".
         define variable part as char format "x(12)" label "料品 ".
         define variable loc like loc_loc label "庫位" initial "MG204E".
         define variable lotserial like tr_serial label "批/序號".
         define variable lotserial_qty  as decimal
                label "數量"  format "->>,>>>,>>9.999" .
         define variable um1 like pt_um.
         define variable ord_date like wo_ord_date label "生產日期" init today.
         define variable exp_code as char format "x(2)" label "特號" init "00".

         define variable nbr1 like wo_nbr.
         define variable nbr2 like wo_nbr.
         define variable nbr3 like wo_nbr.
         define variable nbr4 like wo_nbr.
         define variable nbr5 like wo_nbr.
         define variable nbr6 like wo_nbr.
         define variable nbr7 like wo_nbr.
         define variable nbr8 like wo_nbr.
         define variable lot1 like wo_lot.
         define variable lot2 like wo_lot.
         define variable lot3 like wo_lot.
         define variable lot4 like wo_lot.
         define variable lot5 like wo_lot.
         define variable lot6 like wo_lot.
         define variable lot7 like wo_lot.
         define variable lot8 like wo_lot.

         define variable qty as decimal format "->>,>>>,>>9.999" extent 8.
         define variable ln as integer format ">>9" label "項".
         define variable qty_oh as decimal format ">>>>>>9.999". /* as integer. qing */
         define variable tot_qty as decimal format ">>>>>>9.999".
         define variable lot_nbr like tr_serial.
	 define variable update_all like mfc_logical.
	 define variable i as integer.

         /* the following variables for display */
	 define variable l_disp_nbr like wo_nbr format "x(12)" label "工單".
	 define variable max_nbr as integer format "9999".
	 define variable type like tr_type label "類型".
	 define variable l_lot like ld_lot label "批號".
	 define variable iss_tot_qty as decimal format "->>,>>>,>>9.999".
	 define variable l_tot_qty as decimal format "->>,>>>,>>9.999".
	 define variable l_part like pt_part extent 8.
	 define variable iss_lot like wo_lot.
	 define variable V1110 as char .
         DEFINE VARIABLE WeekResult AS CHAR.
         DEFINE VARIABLE aa AS DATE INIT TODAY.
	 DEFINE VARIABLE partstr AS char.

         /* for iss qty */
         define temp-table temp1
                field t1_line as integer format ">9" label "序號"
                field t1_part as char format "x(13)" label "零件編號"
                field t1_loc like loc_loc  label "庫位"
                field lotser like tr_serial label "批號"
                field t1_qty as decimal format ">>>>>>9.999" label "數量"
		field t1_min_lot like mfc_logical 
		field t1_ld_qty  as decimal init 0 label "實際庫存數量"
		index t1_line IS PRIMARY t1_line ASCENDING.
                
         /* for cheack part loc serial */
         define temp-table temp2
                field t2_part like pt_part
                field t2_loc like loc_loc
                field t2_lotserial like tr_serial
                field t2_qty as decimal format "->>,>>>,>>9.999".

         /* check min serial */
         define temp-table temp3
                field t3_part like pt_part
                field t3_loc like loc_loc
                field t3_lot like tr_serial.

         define variable filename as char.
         define variable quote as char initial '"'.

         form
            site      colon 10
            ord_date  colon 30
            exp_code  colon 45
            lotserial colon 58
            loc       colon 10
            lotserial_qty  colon 30 space(0) pt_um
            part      colon 10 space(0) pt_desc1 no-label
         with frame a side-labels attr-space width 80.
    /*     setFrameLabels(frame a:handle). */

         form
            ln
            t1_part
            t1_loc
            lotser
            t1_qty 
	    pt_um 
	    /*pt_desc1 format "x(18)" label "DESC"*/
         with 10 down frame b row 8 width 80.
         /* SET EXTERNAL LABELS */
        /* SetFrameLabels(frame b:handle). */

         form
            "工單"
            "ID號"     colon 20
            "數量"     colon 31
	    "料號"     colon 45 skip
            nbr1       no-label
            lot1       no-label
            qty[1]     no-label 
	    l_part[1]  no-label skip
            nbr2       no-label
            lot2       no-label
            qty[2]     no-label
	    l_part[2]  no-label skip
            nbr3       no-label
            lot3       no-label
            qty[3]     no-label
	    l_part[3]  no-label skip
            nbr4       no-label
            lot4       no-label
            qty[4]     no-label
	    l_part[4]  no-label skip
            nbr5       no-label
            lot5       no-label
            qty[5]     no-label 
	    l_part[5]  no-label skip
            nbr6       no-label
            lot6       no-label
            qty[6]     no-label
	    l_part[6]  no-label skip
            nbr7       no-label
            lot7       no-label
            qty[7]     no-label
	    l_part[7]  no-label skip
            nbr8       no-label
            lot8       no-label
            qty[8]     no-label
	    l_part[8]  no-label skip
         with frame c row 8 no-label attr-space width 80.
        /* setFrameLabels(frame c:handle). */
	assign site = "20" .   /* Add By SS Davild 20060808 */

         mainloop:
         repeat:
            view frame a.
            view frame b.

            display site loc lotserial_qty ord_date exp_code lotserial with frame a.

            do on error undo, retry with frame a:
               prompt-for site loc part ord_date lotserial_qty exp_code
               editing:
                  if frame-field="site" then do:
                     {mfnp.i si_mstr site si_site site si_site si_site}
                     if recno <> ? then
                        display si_site @ site with frame a.
                  end.
                  else if frame-field="loc" then do:
                     assign site.
                     {mfnp01.i loc_mstr loc loc_loc site loc_site loc_loc}
                     if recno <> ? then
                        display loc_loc @ loc with frame a.
                  end.
                  else if frame-field="part" then do:
                     {mfnp.i pt_mstr part pt_part part pt_part pt_part}

                     if recno <> ? then do:
                        display
                           pt_part @ part
                           pt_desc1
                           pt_um
                        with frame a.
                        um1 = pt_um.
                     end.
                  end.
                  else do:
                     status input ststatus.
                     readkey.
                     apply lastkey.
                  end.
               end.
		  /* By SS Davild 20060808 --BEGIN*/
		  
		  assign part loc site lotserial_qty ord_date exp_code.
			  
		  find first loc_mstr where loc_site = site
                     and loc_loc = loc no-lock no-error.
                  if not available loc_mstr then do:
                     {mfmsg.i 709 3 3}
                     next-prompt loc with frame a.
                     undo, retry.
                  end.
                  else do:
                     if lookup(global_userid, loc_user1) = 0 then do:
		        message "錯誤: 用戶 " + global_userid + " 無權限訪問此庫位，請重新輸入!".
                        next-prompt loc with frame a.
                        undo, retry.
                     end.
                  end.
		  /* By SS Davild 20060808 --END*/
		  
		  
               
               find si_mstr where si_site = site no-lock no-error.
               if not available si_mstr then do:
                  {mfmsg.i 708 3 3}
                  next-prompt site with frame a.
                  undo, retry.
               end.

               find first loc_mstr where loc_site = site and loc_loc = loc no-lock no-error.
               if not available loc_mstr then do:
                  {mfmsg.i 709 3 3}
                  next-prompt loc with frame a.
                  undo, retry.
               end.

               find pt_mstr where pt_part = part no-lock no-error.
               if not available pt_mstr then do:
                  {mfmsg.i 16 3 3}
                  next-prompt part with frame a.
                  undo, retry.
               end.

               display
                  pt_part @ part
                  pt_desc1
                  pt_um
               with frame a.

               /*if integer(lotserial_qty) = 0 then do:
		  message "錯誤: 不允許零數量, 請重新輸入!".
                  next-prompt lotserial_qty with frame a.
                  undo, retry.
               end.*/	/* Remark By SS Davild 20060808 */
               
	       /* By SS Davild 20060808 --BEGIN*/
	       if (lotserial_qty) = 0 then do:
		  message "錯誤: 不允許零數量, 請重新輸入!".
                  next-prompt lotserial_qty with frame a.
                  undo, retry.
               end.
               /* By SS Davild 20060808 --END*/
                            
               
               
            end. /* do on error undo, retry with frame a */
            ln = 1.
            clear frame b all no-pause.

 	    if not update_all then do:
	    clear frame b all no-pause.
	       for each temp1 no-lock break by t1_line:
  	          find first pt_mstr where pt_part = t1_part no-lock no-error.
	          display
		     t1_line @ ln
		     t1_part
		     t1_loc
		     lotser
		     t1_qty 
		     pt_um  when available pt_mstr
	          with frame b.

                  if last(t1_line) then ln = t1_line + 1.
                  if frame-line(b) = frame-down(b) then pause.
                  down 1 with frame b.
               end.
            end. 

	    subloop:
            repeat on endkey undo, leave:


            clear frame b all no-pause.
	    for each temp1 no-lock break by t1_line:
  	          find first pt_mstr where pt_part = t1_part no-lock no-error.
	          display
	             t1_line @ ln
		     t1_part
		     t1_loc
		     lotser
		     t1_qty 
		     pt_um  when available pt_mstr
	          with frame b.

                  if last(t1_line) then ln = t1_line + 1.
                  if frame-line(b) = frame-down(b) then pause.
                  down 1 with frame b.
               end.



               update ln with frame b editing:
                  {mfnp.i temp1 ln t1_line ln t1_line t1_line}

                  if recno <> ? then do:
    	             find first pt_mstr where pt_part = t1_part no-lock no-error.
	             display
		        t1_line @ ln
		        t1_part
		        t1_loc
		        lotser
		        t1_qty 
		        pt_um  when available pt_mstr
		     with frame b.
                  end.
	       end.
	 

               find first temp1 where t1_line = input ln exclusive-lock no-error.
	       if not available temp1 then do:
                  /* Adding new Record */
                  {mfmsg.i 1 1}
		  create temp1.
		  t1_line = input ln.
		  err_mss_a_e=no.
	       end.
	       else do:
                  /* Modifying existing record */
                  {mfmsg.i 10 1}
		  err_mss_a_e=yes.

    	          find first pt_mstr where pt_part = t1_part no-lock no-error.
	          display
		     t1_qty 
		     pt_um  when available pt_mstr
		  with frame b.
	       end.

               do on error undo, retry with frame b:
			/* By SS Davild 20060808 --BEGIN*/	
			
                  update t1_part with frame b editing:
                     if frame-field="t1_part" then do:
                        {mfnp.i pt_mstr t1_part pt_part t1_part pt_part pt_part}

                        if recno <> ? then do:
                           display
                              pt_part @ t1_part
                              pt_um  
                           with frame b.
			   t1_part = pt_part .
                        end.
                     end.
                     else do:
                        status input ststatus.
                        readkey.
                        apply lastkey.
                     end.
		  End.   
		  
		  find first pt_mstr where pt_part = input t1_part no-lock no-error.
                  if not available pt_mstr then do:
                     {mfmsg.i 16 3 3}
                     next-prompt t1_part with frame b.
                     undo, retry.
                  end.
                  display pt_um  with frame b.
			
		  t1_loc =  loc .
		  disp t1_loc with frame b .
		  update t1_loc with frame b editing:
                   if frame-field="t1_loc" then do:
                        {mfnp01.i loc_mstr t1_loc loc_loc site loc_site loc_loc}
                        if recno <> ? then
                           display loc_loc @ t1_loc with frame b.
                     end.
                     else do:
                        status input ststatus.
                        readkey.
                        apply lastkey.
                     end.
                  end.
			/*找出最小批號及對應庫位,記住庫存數--BEGIN*/
			tmp_loc = t1_loc .
			run getpart_min_lot(input t1_part,input site,input tmp_loc,output tmp_lot,output tmp_qty_oh) .                       

			assign 
				lotser = tmp_lot .
				disp lotser with frame b .
				global_loc = t1_loc .
			       global_part = t1_part .
			       global_site = site .
			/*找出最小批號及對應庫位,記住庫存數--END*/
			/* By SS Davild 20060808 --END*/

		  update
		  lotser with frame b editing:	/* By SS Davild 20060808 --BEGIN*/ 		     		 


		        if frame-field = "lotser" then do:				
				{mfnp01.i ld_det lotser ld_lot t1_part ld_part ld_part_lot}
				if recno <> ? then do:
					lotser = ld_Lot .
				/*	t1_qty = ld_qty_oh .  */   /* ching remark */
					display  lotser /*t1_qty*/ with frame b .
				end.

			         

				find first ld_det where ld_site = site and ld_part = t1_part 
				    and ld_loc = t1_loc and ld_lot = input lotser no-lock no-error. 
				if avail ld_det THEN DO:
					lotser = ld_Lot .
					/* t1_qty = ld_qty_oh .  */
					display  lotser /*t1_qty*/ with frame b .
				END. /* THEN DO */
		     end.   /* By SS Davild 20060808 --END*/
		     		     
		     else do:
                        status input ststatus.
                        readkey.
                        apply lastkey.
                     end.
                  end.

                 /* if input t1_part = part /* or input t1_loc = loc */  then do:
		     message "錯誤: 發料零件編號和入庫零件編號相同, 請重新輸入!".
                     next-prompt t1_part with frame b.
                     undo, retry.
                  end.
		  */   /* Remark By SS Davild 20060808 */
		  	  

                  

                  find first loc_mstr where loc_site = site
                     and loc_loc = input t1_loc no-lock no-error.
                  if not available loc_mstr then do:
                     {mfmsg.i 709 3 3}
                     next-prompt t1_loc with frame b.
                     undo, retry.
                  end.
                  else do:
                     if lookup(global_userid, loc_user1) = 0 then do:
		        message "錯誤: 用戶 " + global_userid + " 無權限訪問此庫位，請重新輸入!".
                        next-prompt t1_loc with frame b.
                        undo, retry.
                     end.
                  end.

                  find first ld_det where ld_site = site and ld_loc = input t1_loc and ld_part = input t1_part
                     and trim(ld_lot) = trim(input lotser) no-lock no-error.
                  if not available ld_det then do:
                     {mfmsg.i 242 3 3}
                     next-prompt lotser with frame b.
                     undo, retry.
                  end.

                  qty_oh = 0.
                  for each ld_det no-lock where ld_part = input t1_part
                       and ld_site = site
                       and ld_loc = input t1_loc
                       and trim(ld_lot) = trim(input lotser)
                    , each is_mstr no-lock where is_status = ld_status:    /*remark by ching 2006/10/25*/
                      qty_oh = qty_oh + ld_qty_oh.
                  end.

                  if qty_oh <= 0 then do:
		     message "錯誤: 庫位/批號數量為零, 請重新輸入!".
                     next-prompt t1_loc with frame b.
                     undo, retry.
                  end.

                  find first temp2 where t2_part = input t1_part
                     and t2_loc = input t1_loc
                     and t2_lotserial = input lotser no-lock no-error.
                  err_mss=no.
                  if available temp2 then do:
		      err_mss=yes.
                     message "警告: 零件編號/庫位/批序號已經存在!,此記錄將被刪除".
                  end.

		   lot_nbr = "".


		   if input lotser <>  tmp_lot then 
		         message "警告： 庫存可用數量： " + string(qty_oh) + " ,輸入的批/序號不是最小的批/序號!".


                  t1_qty = qty_oh.                	
                  
                  repeat with frame b: /* ching add */
                     update t1_qty EDITING: 
		         status input.         /* ching add */
		         READKEY .             /* ching add */
		         pause 0 before-hide.  /* ching add */
		         if lastkey = 27 OR LASTKEY = 404 THEN do:   /* ching add */
			    READKEY.          /* ching add */
		         END.                  /* ching add */
		         ELSE DO:		 /* ching add */   
			    APPLY LASTKEY .  /* ching add */
		         END.   /* ching add */
		      end.
                     

		      if (input t1_qty) = 0 then do:
			 {mfmsg.i 317 3 3}
			 next-prompt t1_qty with frame b.
			 undo, retry.
		      end.
		      else do:
			 if input t1_qty > qty_oh then do:
			    message "錯誤: 轉出數量大於實際庫存數量, 請重新輸入!".
			    next-prompt t1_qty with frame b.
			    undo, retry.
			 end.      
			 else leave . /* ching add */			    
                      end. /* ching add */
		  end. /* ching add */

                   
		   err_mss_a=no.
                   if err_mss=yes and err_mss_a_e=no then do:
		      for  each temp1 where t1_line = input ln:
		         delete temp1.
		      end.
		      err_mss_a=yes.
		  end.
                  err_mss=no. 

                  find first temp2 where t2_part = input t1_part
                     and t2_loc = input t1_loc
                     and t2_lotserial = input lotser no-error.

                  if not available temp2 then do:
                     create temp2.
                     t2_part      = input t1_part.
                     t2_loc       = input t1_loc.
                     t2_lotserial = input lotser.

                     find first temp3 where t3_part = input t1_part
                        and t3_loc = input t1_loc and t3_lot = input lotser
                        no-error .
                     if available temp3 then delete temp3.
                  end.
		  else do:
	                     
			     
		  end.
                  t2_qty = input t1_qty.
	       end. /* do on error undo, retry with frame b: */

              
              i = i + 1.
	     
	      if err_mss_a=no then do:
               if ln < 999 then ln = ln + 1.
               else if ln = 999 then do:
                  /* Line number cannot exceed 999 */
                  {mfmsg.i 7418 2}
               end.
	       down 1 with frame b.
	       end.
	       
            end. /* subloop: */

            tot_qty = 0.
            for each temp1 exclusive-lock:
	    
	       if (t1_qty) = 0 or trim(t1_part) = "" or trim(t1_loc) = ""
	       then delete temp1.
	       else tot_qty = t1_qty + tot_qty.
	    end.

	    if tot_qty <> lotserial_qty then do:
	       message "錯誤: 入庫數量不等於發料數量 " + string(tot_qty) + " , 請重新輸入!".
               next-prompt lotserial_qty with frame a.
               undo, retry.
	    end.

            if not can-find(first temp1) then next mainloop.

            view frame c.            
            display qty with frame c.

            do on error undo, retry with frame c:
               update nbr1 lot1 qty[1]
                   nbr2 lot2 qty[2]
                   nbr3 lot3 qty[3]
                   nbr4 lot4 qty[4]
                   nbr5 lot5 qty[5]
                   nbr6 lot6 qty[6]
                   nbr7 lot7 qty[7]
                   nbr8 lot8 qty[8]
	       with frame c editing:
	          if frame-field = "nbr1" then do:
                     {mfnp.i wo_mstr nbr1 wo_nbr nbr1 wo_nbr wo_nbr}

                     if recno <> ? then do:
                        display
                           wo_nbr @ nbr1
                           wo_lot @ lot1
                           wo_part @ l_part[1]
                        with frame c.
                     end.

		     /* By SS Davild 20060808 --BEGIN*/
		     find first wo_mstr where wo_nbr = input nbr1  no-lock no-error.
		     if avail wo_mstr then do:
			display
			   wo_nbr @ nbr1
                           wo_lot @ lot1
                           wo_part @ l_part[1] with frame c .
		     end.
		     /* By SS Davild 20060808 --END*/	     
		     
                  end.
	          else if frame-field = "nbr2" then do:
                     {mfnp.i wo_mstr nbr2 wo_nbr nbr2 wo_nbr wo_nbr}

                     if recno <> ? then do:
                        display
                           wo_nbr @ nbr2
                           wo_lot @ lot2
                           wo_part @ l_part[2]
                        with frame c.
                     end.
		     /* By SS Davild 20060808 --BEGIN*/
		     find first wo_mstr where wo_nbr = input nbr2  no-lock no-error.
		     if avail wo_mstr then do:
			display
			   wo_nbr @ nbr2
                           wo_lot @ lot2
                           wo_part @ l_part[2] with frame c .
		     end.
		     /* By SS Davild 20060808 --END*/	
                  end.
	          else if frame-field = "nbr3" then do:
                     {mfnp.i wo_mstr nbr3 wo_nbr nbr3 wo_nbr wo_nbr}

                     if recno <> ? then do:
                        display
                           wo_nbr @ nbr3
                           wo_lot @ lot3
                           wo_part @ l_part[3]
                        with frame c.
                     end.
		     /* By SS Davild 20060808 --BEGIN*/
		     find first wo_mstr where wo_nbr = input nbr3  no-lock no-error.
		     if avail wo_mstr then do:
			display
			   wo_nbr @ nbr3
                           wo_lot @ lot3
                           wo_part @ l_part[3] with frame c .
		     end.
		     /* By SS Davild 20060808 --END*/	
                  end.
	          else if frame-field = "nbr4" then do:
                     {mfnp.i wo_mstr nbr4 wo_nbr nbr4 wo_nbr wo_nbr}

                     if recno <> ? then do:
                        display
                           wo_nbr @ nbr4
                           wo_lot @ lot4
                           wo_part @ l_part[4]
                        with frame c.
                     end.		
		     /* By SS Davild 20060808 --BEGIN*/
		     find first wo_mstr where wo_nbr = input nbr4  no-lock no-error.
		     if avail wo_mstr then do:
			display
			   wo_nbr @ nbr4
                           wo_lot @ lot4
                           wo_part @ l_part[4] with frame c .
		     end.
		     /* By SS Davild 20060808 --END*/	
                  end.
	          else if frame-field = "nbr5" then do:
                     {mfnp.i wo_mstr nbr5 wo_nbr nbr5 wo_nbr wo_nbr}

                     if recno <> ? then do:
                        display
                           wo_nbr @ nbr5
                           wo_lot @ lot5
                           wo_part @ l_part[5]
                        with frame c.
                     end.		
		     /* By SS Davild 20060808 --BEGIN*/
		     find first wo_mstr where wo_nbr = input nbr5  no-lock no-error.
		     if avail wo_mstr then do:
			display
			   wo_nbr @ nbr5
                           wo_lot @ lot5
                           wo_part @ l_part[5] with frame c .
		     end.
		     /* By SS Davild 20060808 --END*/	
                  end.
 	          else if frame-field = "nbr6" then do:
                     {mfnp.i wo_mstr nbr6 wo_nbr nbr6 wo_nbr wo_nbr}

                     if recno <> ? then do:
                        display
                           wo_nbr @ nbr6
                           wo_lot @ lot6
                           wo_part @ l_part[6]
                        with frame c.
                     end.	
		     /* By SS Davild 20060808 --BEGIN*/
		     find first wo_mstr where wo_nbr = input nbr6  no-lock no-error.
		     if avail wo_mstr then do:
			display
			   wo_nbr @ nbr6
                           wo_lot @ lot6
                           wo_part @ l_part[6] with frame c .
		     end.
		     /* By SS Davild 20060808 --END*/	
                  end.
	          else if frame-field = "nbr7" then do:
                     {mfnp.i wo_mstr nbr7 wo_nbr nbr7 wo_nbr wo_nbr}

                     if recno <> ? then do:
                        display
                           wo_nbr @ nbr7
                           wo_lot @ lot7
                           wo_part @ l_part[7]
                        with frame c.
                     end.	
		     /* By SS Davild 20060808 --BEGIN*/
		     find first wo_mstr where wo_nbr = input nbr7  no-lock no-error.
		     if avail wo_mstr then do:
			display
			   wo_nbr @ nbr7
                           wo_lot @ lot7
                           wo_part @ l_part[7] with frame c .
		     end.
		     /* By SS Davild 20060808 --END*/	
                  end.
	          else if frame-field = "nbr8" then do:
                     {mfnp.i wo_mstr nbr8 wo_nbr nbr8 wo_nbr wo_nbr}

                     if recno <> ? then do:
                        display
                           wo_nbr @ nbr8
                           wo_lot @ lot8
                           wo_part @ l_part[8]
                        with frame c.
                     end.	
		     /* By SS Davild 20060808 --BEGIN*/
		     find first wo_mstr where wo_nbr = input nbr8  no-lock no-error.
		     if avail wo_mstr then do:
			display
			   wo_nbr @ nbr8
                           wo_lot @ lot8
                           wo_part @ l_part[8] with frame c .
		     end.
		     /* By SS Davild 20060808 --END*/	
                  end.
		  /*
	          else if frame-field = "lot8" then do:
                     {mfnp01.i wo_mstr lot8 wo_lot nbr8 wo_nbr wo_nbr}

                     if recno <> ? then do:
                        display
                           wo_nbr @ nbr8
                           wo_lot @ lot8
                           wo_part @ l_part[8]
                        with frame c.
                     end.		     
                  end.
		  */
                  else do:
                     status input ststatus.
                     readkey.
                     apply lastkey.
                  end.
	       end.
		
		/* By SS Davild 20060808 工單隻能以B結尾--BEGIN*/
		assign nbr1 nbr2 nbr3 nbr4
	              nbr5 nbr6 nbr7 nbr8
	              lot1 lot2 lot3 lot4 
		      lot5 lot6 lot7 lot8 qty.
		
		nbr1 = trim(nbr1) .
		if nbr1 > "" and substr(nbr1 ,length(nbr1),1) <> "B" THEN DO:
			message "錯誤: 工單必須以 B 結尾,請重新輸入!".
                     next-prompt nbr1 with frame c.
                     undo, retry.
		END.
		nbr2 = trim(nbr2) .
		if nbr2 > "" and substr(nbr2 ,length(nbr2),1) <> "B" THEN DO:
			message "錯誤: 工單必須以 B 結尾,請重新輸入!".
                     next-prompt nbr2 with frame c.
                     undo, retry.
		END.
		nbr3 = trim(nbr3) .
		if nbr3 > "" and substr(nbr3 ,length(nbr3),1) <> "B" THEN DO:
			message "錯誤: 工單必須以 B 結尾,請重新輸入!".
                     next-prompt nbr3 with frame c.
                     undo, retry.
		END.
		nbr4 = trim(nbr4) .
		if nbr4 > "" and substr(nbr4 ,length(nbr4),1) <> "B" THEN DO:
			message "錯誤: 工單必須以 B 結尾,請重新輸入!".
                     next-prompt nbr4 with frame c.
                     undo, retry.
		END.
		nbr5 = trim(nbr5) .
		if nbr5 > "" and substr(nbr5 ,length(nbr5),1) <> "B" THEN DO:
			message "錯誤: 工單必須以 B 結尾,請重新輸入!".
                     next-prompt nbr5 with frame c.
                     undo, retry.
		END.
		nbr6 = trim(nbr6) .
		if nbr6 > "" and substr(nbr6 ,length(nbr6),1) <> "B" THEN DO:
			message "錯誤: 工單必須以 B 結尾,請重新輸入!".
                     next-prompt nbr6 with frame c.
                     undo, retry.
		END.
		nbr7 = trim(nbr7) .
		if nbr7 > "" and substr(nbr7 ,length(nbr7),1) <> "B" THEN DO:
			message "錯誤: 工單必須以 B 結尾,請重新輸入!".
                     next-prompt nbr7 with frame c.
                     undo, retry.
		END.
		nbr8 = trim(nbr8) .
		if nbr8 > "" and substr(nbr8 ,length(nbr8),1) <> "B" THEN DO:
			message "錯誤: 工單必須以 B 結尾,請重新輸入!".
                     next-prompt nbr8 with frame c.
                     undo, retry.
		END.

		/* By SS Davild 20060808 --END*/
		
		
	       if nbr1 > "" or lot1 > "" then do:
	          if qty[1] = 0 then do:
                     message "錯誤: 零數量不允許, 請重新輸入!".
                     next-prompt qty[1] with frame c.
                     undo, retry.
                  end.

	          find first wo_mstr where wo_nbr = nbr1 or wo_lot = lot1 no-lock no-error.
		  if available wo_mstr then do:
		     display
		        wo_nbr @ nbr1
			wo_lot @ lot1
			wo_part @ l_part[1]
		     with frame c.
		  end.
	       end.
	       if nbr2 > "" or lot2 > "" then do:
       	          if qty[2] = 0 then do:
                     message "錯誤: 零數量不允許, 請重新輸入!".
                     next-prompt qty[2] with frame c.
                     undo, retry.
                  end.

	          find first wo_mstr where wo_nbr = nbr2 or wo_lot = lot2 no-lock no-error.
		  if available wo_mstr then do:
		     display
		        wo_nbr @ nbr2
			wo_lot @ lot2
			wo_part @ l_part[2]
		     with frame c.
		  end.
	       end.
	       
	       if nbr3 > "" or lot3 > "" then do:
	       	  if qty[3] = 0 then do:
                     message "錯誤: 零數量不允許, 請重新輸入!".
                     next-prompt qty[3] with frame c.
                     undo, retry.
                  end.

	          find first wo_mstr where wo_nbr = nbr3 or wo_lot = lot3 no-lock no-error.
		  if available wo_mstr then do:
		     display
		        wo_nbr @ nbr3
			wo_lot @ lot3
			wo_part @ l_part[3]
		     with frame c.
		  end.
	       end.
	       if nbr4 > "" or lot4 > "" then do:
	       	  if qty[4] = 0 then do:
                     message "錯誤: 零數量不允許, 請重新輸入!".
                     next-prompt qty[4] with frame c.
                     undo, retry.
                  end.

	          find first wo_mstr where wo_nbr = nbr4 or wo_lot = lot4 no-lock no-error.
		  if available wo_mstr then do:
		     display
		        wo_nbr @ nbr4
			wo_lot @ lot4
			wo_part @ l_part[4]
		     with frame c.
		  end.
	       end.
	       if nbr5 > "" or lot5 > "" then do:
	       	  if qty[5] = 0 then do:
                     message "錯誤: 零數量不允許, 請重新輸入!".
                     next-prompt qty[5] with frame c.
                     undo, retry.
                  end.

	          find first wo_mstr where wo_nbr = nbr5 or wo_lot = lot5 no-lock no-error.
		  if available wo_mstr then do:
		     display
		        wo_nbr @ nbr5
			wo_lot @ lot5
			wo_part @ l_part[5]
		     with frame c.
		  end.
	       end.
	       if nbr6 > "" or lot6 > "" then do:
	       	  if qty[6] = 0 then do:
                     message "錯誤: 零數量不允許, 請重新輸入!".
                     next-prompt qty[6] with frame c.
                     undo, retry.
                  end.

	          find first wo_mstr where wo_nbr = nbr6 or wo_lot = lot6 no-lock no-error.
		  if available wo_mstr then do:
		     display
		        wo_nbr @ nbr6
			wo_lot @ lot6
			wo_part @ l_part[6]
		     with frame c.
		  end.
	       end.
	       if nbr7 > "" or lot7 > "" then do:
	       	  if qty[7] = 0 then do:
                     message "錯誤: 零數量不允許, 請重新輸入!".
                     next-prompt qty[7] with frame c.
                     undo, retry.
                  end.

	          find first wo_mstr where wo_nbr = nbr7 or wo_lot = lot7 no-lock no-error.
		  if available wo_mstr then do:
		     display
		        wo_nbr @ nbr7
			wo_lot @ lot7
			wo_part @ l_part[7]
		     with frame c.
		  end.
	       end.
	       if nbr8 > "" or lot8 > "" then do:
	       	  if qty[8] = 0 then do:
                     message "錯誤: 零數量不允許, 請重新輸入!".
                     next-prompt qty[8] with frame c.
                     undo, retry.
                  end.

	          find first wo_mstr where wo_nbr = nbr8 or wo_lot = lot8 no-lock no-error.
		  if available wo_mstr then do:
		     display
		        wo_nbr @ nbr8
			wo_lot @ lot8
			wo_part @ l_part[8]
  	             with frame c.
		  end.
	       end.

               assign nbr1 nbr2 nbr3 nbr4
	              nbr5 nbr6 nbr7 nbr8
	              lot1 lot2 lot3 lot4 
		      lot5 lot6 lot7 lot8 qty.

               iss_tot_qty = qty[1] + qty[2] + qty[3] + qty[4] + qty[5] + qty[6] 
	                      + qty[7] + qty[8].

	       if iss_tot_qty > lotserial_qty 
	       then do:
	          message "錯誤: 工單用料分配數量不能大於混合液晶入庫數量, 請重新輸入!".
                  next-prompt qty[1] with frame c.
                  undo, retry.
	       end.

               if nbr1 > "" then do:
                  find first wo_mstr where wo_nbr = nbr1 no-lock no-error.

                  if not available wo_mstr then do:
                     {mfmsg.i 503 3 3}
                     next-prompt nbr1 with frame c.
                     undo, retry.
                  end.
                  if lookup(wo_status,"A,R") = 0 then do:
                     /* ISSUES ONLY ALLOWED AGAINST ALLOCATED AND RELEASED ORDERS */
                     {pxmsg.i &MSGNUM=541 &ERRORLEVEL=3}
                     /* Current Work Order Status */
                     {pxmsg.i &MSGNUM=525 &ERRORLEVEL=1 &MSGARG1=wo_status}
                     next-prompt nbr1 with frame c.
                     undo, retry.
                  end.
               end.
               if lot1 > "" then do:
                  find first wo_mstr where wo_lot = lot1 no-lock no-error.

                  if not available wo_mstr then do:
                     {mfmsg.i 509 3 3}
                     next-prompt lot1 with frame c.
                     undo, retry.
                  end.
                  if lookup(wo_status,"A,R") = 0 then do:
                     /* ISSUES ONLY ALLOWED AGAINST ALLOCATED AND RELEASED ORDERS */
                     {pxmsg.i &MSGNUM=541 &ERRORLEVEL=3}
                     /* Current Work Order Status */
                     {pxmsg.i &MSGNUM=525 &ERRORLEVEL=1 &MSGARG1=wo_status}
                     next-prompt lot1 with frame c.
                     undo, retry.
                  end.
               end.
               if nbr1 <> "" and lot1 <> "" then do:
                  find first wo_mstr where wo_nbr = nbr1
                      and wo_lot = lot1 no-lock no-error.

                  if not available wo_mstr then do:
                     {pxmsg.i &MSGNUM=510 &ERRORLEVEL=3}
                     /* WORK ORDER DOES NOT EXIST.*/
                     next-prompt nbr1 with frame c.
                     undo, retry.
                  end.
               end.

               if nbr2 > "" then do:
                  find first wo_mstr where wo_nbr = nbr2 no-lock no-error.

                  if not available wo_mstr then do:
                     {mfmsg.i 503 3 3}
                     next-prompt nbr2 with frame c.
                     undo, retry.
                  end.
                  if lookup(wo_status,"A,R") = 0 then do:
                     /* ISSUES ONLY ALLOWED AGAINST ALLOCATED AND RELEASED ORDERS */
                     {pxmsg.i &MSGNUM=541 &ERRORLEVEL=3}
                     /* Current Work Order Status */
                     {pxmsg.i &MSGNUM=525 &ERRORLEVEL=1 &MSGARG1=wo_status}
                     next-prompt nbr2 with frame c.
                     undo, retry.
                  end.
               end.
               if lot2 > "" then do:
                  find first wo_mstr where wo_lot = lot2 no-lock no-error.

                  if not available wo_mstr then do:
                     {mfmsg.i 509 3 3}
                     next-prompt lot2 with frame c.
                     undo, retry.
                  end.
                  if lookup(wo_status,"A,R") = 0 then do:
                     /* ISSUES ONLY ALLOWED AGAINST ALLOCATED AND RELEASED ORDERS */
                     {pxmsg.i &MSGNUM=541 &ERRORLEVEL=3}
                     /* Current Work Order Status */
                     {pxmsg.i &MSGNUM=525 &ERRORLEVEL=1 &MSGARG1=wo_status}
                     next-prompt lot2 with frame c.
                     undo, retry.
                  end.
               end.
               if nbr2 <> "" and lot2 <> "" then do:
                  find first wo_mstr where wo_nbr = nbr2
                      and wo_lot = lot2 no-lock no-error.

                  if not available wo_mstr then do:
                     {pxmsg.i &MSGNUM=510 &ERRORLEVEL=3}
                     /* WORK ORDER DOES NOT EXIST.*/
                     next-prompt nbr2 with frame c.
                     undo, retry.
                  end.
               end.

               if nbr3 > "" then do:
                  find first wo_mstr where wo_nbr = nbr3 no-lock no-error.

                  if not available wo_mstr then do:
                     {mfmsg.i 503 3 3}
                     next-prompt nbr3 with frame c.
                     undo, retry.
                  end.
                  if lookup(wo_status,"A,R") = 0 then do:
                     /* ISSUES ONLY ALLOWED AGAINST ALLOCATED AND RELEASED ORDERS */
                     {pxmsg.i &MSGNUM=541 &ERRORLEVEL=3}
                     /* Current Work Order Status */
                     {pxmsg.i &MSGNUM=525 &ERRORLEVEL=1 &MSGARG1=wo_status}
                     next-prompt nbr3 with frame c.
                     undo, retry.
                  end.
               end.
               if lot3 > "" then do:
                  find first wo_mstr where wo_lot = lot3 no-lock no-error.

                  if not available wo_mstr then do:
                     {mfmsg.i 509 3 3}
                     next-prompt lot3 with frame c.
                     undo, retry.
                  end.
                  if lookup(wo_status,"A,R") = 0 then do:
                     /* ISSUES ONLY ALLOWED AGAINST ALLOCATED AND RELEASED ORDERS */
                     {pxmsg.i &MSGNUM=541 &ERRORLEVEL=3}
                     /* Current Work Order Status */
                     {pxmsg.i &MSGNUM=525 &ERRORLEVEL=1 &MSGARG1=wo_status}
                     next-prompt lot3 with frame c.
                     undo, retry.
                  end.
               end.
               if nbr3 <> "" and lot3 <> "" then do:
                  find first wo_mstr where wo_nbr = nbr3
                      and wo_lot = lot3 no-lock no-error.

                  if not available wo_mstr then do:
                     {pxmsg.i &MSGNUM=510 &ERRORLEVEL=3}
                     /* WORK ORDER DOES NOT EXIST.*/
                     next-prompt nbr3 with frame c.
                     undo, retry.
                  end.
               end.

               if nbr4 > "" then do:
                  find first wo_mstr where wo_nbr = nbr4 no-lock no-error.

                  if not available wo_mstr then do:
                     {mfmsg.i 503 3 3}
                     next-prompt nbr4 with frame c.
                     undo, retry.
                  end.
                  if lookup(wo_status,"A,R") = 0 then do:
                     /* ISSUES ONLY ALLOWED AGAINST ALLOCATED AND RELEASED ORDERS */
                     {pxmsg.i &MSGNUM=541 &ERRORLEVEL=3}
                     /* Current Work Order Status */
                     {pxmsg.i &MSGNUM=525 &ERRORLEVEL=1 &MSGARG1=wo_status}
                     next-prompt nbr4 with frame c.
                     undo, retry.
                  end.
               end.
               if lot4 > "" then do:
                  find first wo_mstr where wo_lot = lot4 no-lock no-error.

                  if not available wo_mstr then do:
                     {mfmsg.i 509 3 3}
                     next-prompt lot4 with frame c.
                     undo, retry.
                  end.
                  if lookup(wo_status,"A,R") = 0 then do:
                     /* ISSUES ONLY ALLOWED AGAINST ALLOCATED AND RELEASED ORDERS */
                     {pxmsg.i &MSGNUM=541 &ERRORLEVEL=3}
                     /* Current Work Order Status */
                     {pxmsg.i &MSGNUM=525 &ERRORLEVEL=1 &MSGARG1=wo_status}
                     next-prompt lot4 with frame c.
                     undo, retry.
                  end.
               end.
               if nbr4 <> "" and lot4 <> "" then do:
                  find first wo_mstr where wo_nbr = nbr4
                      and wo_lot = lot4 no-lock no-error.

                  if not available wo_mstr then do:
                     {pxmsg.i &MSGNUM=510 &ERRORLEVEL=3}
                     /*  WORK ORDER DOES NOT EXIST.*/
                     next-prompt nbr4 with frame c.
                     undo, retry.
                  end.
               end.

               if nbr5 > "" then do:
                  find first wo_mstr where wo_nbr = nbr5 no-lock no-error.

                  if not available wo_mstr then do:
                     {mfmsg.i 503 3 3}
                     next-prompt nbr5 with frame c.
                     undo, retry.
                  end.
                  if lookup(wo_status,"A,R") = 0 then do:
                     /* ISSUES ONLY ALLOWED AGAINST ALLOCATED AND RELEASED ORDERS */
                     {pxmsg.i &MSGNUM=541 &ERRORLEVEL=3}
                     /* Current Work Order Status */
                     {pxmsg.i &MSGNUM=525 &ERRORLEVEL=1 &MSGARG1=wo_status}
                     next-prompt nbr5 with frame c.
                     undo, retry.
                  end.
               end.
               if lot5 > "" then do:
                  find first wo_mstr where wo_lot = lot5 no-lock no-error.

                  if not available wo_mstr then do:
                     {mfmsg.i 509 3 3}
                     next-prompt lot5 with frame c.
                     undo, retry.
                  end.
                  if lookup(wo_status,"A,R") = 0 then do:
                     /* ISSUES ONLY ALLOWED AGAINST ALLOCATED AND RELEASED ORDERS */
                     {pxmsg.i &MSGNUM=541 &ERRORLEVEL=3}
                     /* Current Work Order Status */
                     {pxmsg.i &MSGNUM=525 &ERRORLEVEL=1 &MSGARG1=wo_status}
                     next-prompt lot5 with frame c.
                     undo, retry.
                  end.
               end.
               if nbr5 <> "" and lot5 <> "" then do:
                  find first wo_mstr where wo_nbr = nbr5
                      and wo_lot = lot5 no-lock no-error.

                  if not available wo_mstr then do:
                     {pxmsg.i &MSGNUM=510 &ERRORLEVEL=3}
                     /*  WORK ORDER DOES NOT EXIST.*/
                     next-prompt nbr5 with frame c.
                     undo, retry.
                  end.
               end.

               if nbr6 > "" then do:
                  find first wo_mstr where wo_nbr = nbr6 no-lock no-error.

                  if not available wo_mstr then do:
                     {mfmsg.i 503 3 3}
                     next-prompt nbr6 with frame c.
                     undo, retry.
                  end.
                  if lookup(wo_status,"A,R") = 0 then do:
                     /* ISSUES ONLY ALLOWED AGAINST ALLOCATED AND RELEASED ORDERS */
                     {pxmsg.i &MSGNUM=541 &ERRORLEVEL=3}
                     /* Current Work Order Status */
                     {pxmsg.i &MSGNUM=525 &ERRORLEVEL=1 &MSGARG1=wo_status}
                     next-prompt nbr6 with frame c.
                     undo, retry.
                  end.
               end.
               if lot6 > "" then do:
                  find first wo_mstr where wo_lot = lot6 no-lock no-error.

                  if not available wo_mstr then do:
                     {mfmsg.i 509 3 3}
                     next-prompt lot6 with frame c.
                     undo, retry.
                  end.
                  if lookup(wo_status,"A,R") = 0 then do:
                     /* ISSUES ONLY ALLOWED AGAINST ALLOCATED AND RELEASED ORDERS */
                     {pxmsg.i &MSGNUM=541 &ERRORLEVEL=3}
                     /* Current Work Order Status */
                     {pxmsg.i &MSGNUM=525 &ERRORLEVEL=1 &MSGARG1=wo_status}
                     next-prompt lot6 with frame c.
                     undo, retry.
                  end.
               end.
               if nbr6 <> "" and lot6 <> "" then do:
                  find first wo_mstr where wo_nbr = nbr6
                      and wo_lot = lot6 no-lock no-error.

                  if not available wo_mstr then do:
                     {pxmsg.i &MSGNUM=510 &ERRORLEVEL=3}
                     /*  WORK ORDER DOES NOT EXIST.*/
                     next-prompt nbr6 with frame c.
                     undo, retry.
                  end.
               end.

               if nbr7 > "" then do:
                  find first wo_mstr where wo_nbr = nbr7 no-lock no-error.

                  if not available wo_mstr then do:
                     {mfmsg.i 503 3 3}
                     next-prompt nbr7 with frame c.
                     undo, retry.
                  end.
                  if lookup(wo_status,"A,R") = 0 then do:
                     /* ISSUES ONLY ALLOWED AGAINST ALLOCATED AND RELEASED ORDERS */
                     {pxmsg.i &MSGNUM=541 &ERRORLEVEL=3}
                     /* Current Work Order Status */
                     {pxmsg.i &MSGNUM=525 &ERRORLEVEL=1 &MSGARG1=wo_status}
                     next-prompt nbr7 with frame c.
                     undo, retry.
                  end.
               end.
               if lot7 > "" then do:
                  find first wo_mstr where wo_lot = lot7 no-lock no-error.

                  if not available wo_mstr then do:
                     {mfmsg.i 509 3 3}
                     next-prompt lot7 with frame c.
                     undo, retry.
                  end.
                  if lookup(wo_status,"A,R") = 0 then do:
                     /* ISSUES ONLY ALLOWED AGAINST ALLOCATED AND RELEASED ORDERS */
                     {pxmsg.i &MSGNUM=541 &ERRORLEVEL=3}
                     /* Current Work Order Status */
                     {pxmsg.i &MSGNUM=525 &ERRORLEVEL=1 &MSGARG1=wo_status}
                     next-prompt lot7 with frame c.
                     undo, retry.
                  end.
               end.
               if nbr7 <> "" and lot7 <> "" then do:
                  find first wo_mstr where wo_nbr = nbr7
                      and wo_lot = lot7 no-lock no-error.

                  if not available wo_mstr then do:
                     {pxmsg.i &MSGNUM=510 &ERRORLEVEL=3}
                     /*  WORK ORDER DOES NOT EXIST.*/
                     next-prompt nbr7 with frame c.
                     undo, retry.
                  end.
               end.

               if nbr8 > "" then do:
                  find first wo_mstr where wo_nbr = nbr8 no-lock no-error.

                  if not available wo_mstr then do:
                     {mfmsg.i 503 3 3}
                     next-prompt nbr8 with frame c.
                     undo, retry.
                  end.
                  if lookup(wo_status,"A,R") = 0 then do:
                     /* ISSUES ONLY ALLOWED AGAINST ALLOCATED AND RELEASED ORDERS */
                     {pxmsg.i &MSGNUM=541 &ERRORLEVEL=3}
                     /* Current Work Order Status */
                     {pxmsg.i &MSGNUM=525 &ERRORLEVEL=1 &MSGARG1=wo_status}
                     next-prompt nbr8 with frame c.
                     undo, retry.
                  end.
               end.
               if lot8 > "" then do:
                  find first wo_mstr where wo_lot = lot8 no-lock no-error.

                  if not available wo_mstr then do:
                     {mfmsg.i 509 3 3}
                     next-prompt lot8 with frame c.
                     undo, retry.
                  end.
                  if lookup(wo_status,"A,R") = 0 then do:
                     /* ISSUES ONLY ALLOWED AGAINST ALLOCATED AND RELEASED ORDERS */
                     {pxmsg.i &MSGNUM=541 &ERRORLEVEL=3}
                     /* Current Work Order Status */
                     {pxmsg.i &MSGNUM=525 &ERRORLEVEL=1 &MSGARG1=wo_status}
                     next-prompt lot8 with frame c.
                     undo, retry.
                  end.
               end.
               if nbr8 <> "" and lot8 <> "" then do:
                  find first wo_mstr where wo_nbr = nbr8
                      and wo_lot = lot8 no-lock no-error.

                  if not available wo_mstr then do:
                     {pxmsg.i &MSGNUM=510 &ERRORLEVEL=3}
                     /*  WORK ORDER DOES NOT EXIST.*/
                     next-prompt nbr8 with frame c.
                     undo, retry.
                  end.
               end.
            end.

            /* SELECT PRINTER */
            {mfselbpr.i "printer" 132}

            V1110 = string (ord_date).
            aa = DATE ( 1,1,YEAR(Date(V1110))) .
            IF WEEKDAY (aa) > 2 THEN AA = aa + ( 7 - weekday(aa) ) + 2.
            IF WEEKDAY (aa) = 1 THEN aa = aa +  1.
            IF Date(V1110) = aa THEN WeekResult = "01" . 
            ELSE WeekResult = string(INTEGER (( Date(V1110) - aa ) / 7 - 0.5) + 1) .

	    /* {xsweekc.i} */

	    max_nbr = 0.
            for each wo_mstr no-lock
	       where wo_nbr begins ("WLC" + substring(string(year(ord_date)),4) + WeekResult) 
	    break by wo_nbr:
	       if last(wo_nbr) then max_nbr = integer(substring(wo_nbr, 7, 10)). 
	    end.
	    max_nbr = max_nbr + 1.

            l_disp_nbr = "WLC" + substring(string(year(ord_date)),4) + WeekResult + string(max_nbr, "9999").
            l_lot = substring(l_disp_nbr,3,8) + substring(string(year(today)),3) +
 	            string(month(today), "99") + string(day(today),"99") +
		    (if exp_code = "" then "00" else exp_code).
                              

               put "單體液晶扣料：" skip
		   "=============" skip.

               for each temp1 no-lock:
	       /* By SS Davild 20060808 --BEGIN*/
	       find first pt_mstr where pt_part = t1_part no-lock no-error.
	       if avail pt_Mstr then tmp_desc1 = trim( pt_desc1 ) + " " + trim(pt_desc2) .
	       else tmp_desc1 = "" .
	       /* By SS Davild 20060808 --END*/
	       
	       
	       
	          display
		     t1_part 
		     t1_qty 
		     tmp_desc1
                     t1_loc 
		     lotser  /*@ l_lot*/
		     
 		  with down frame p4 width 132.

		  if nbr1 > "" or lot1 > "" then do:
                     find first wod_det where wod_nbr = nbr1 
		        and wod_part = t1_part no-lock no-error.
		     if not available wod_det then do:
		        put "警告： 工單 " + nbr1 + " 清單中沒找到此料號!" format "x(50)" at 20 skip.
		     end.		     
		  end.

		  if nbr2 > "" or lot2 > "" then do:
                     find first wod_det where wod_nbr = nbr2
		        and wod_part = t1_part no-lock no-error.
		     if not available wod_det then do:
		        put "警告： 工單 " + nbr2 + " 清單中沒找到此料號!" format "x(50)" at 20 skip.
		     end.		     
		  end.

		  if nbr3 > "" or lot3 > "" then do:
                     find first wod_det where wod_nbr = nbr3
		        and wod_part = t1_part no-lock no-error.
		     if not available wod_det then do:
		        put "警告： 工單 " + nbr3 + " 清單中沒找到此料號!" format "x(50)" at 20 skip.
		     end.		     
		  end.

		  if nbr4 > "" or lot4 > "" then do:
                     find first wod_det where wod_nbr = nbr4
		        and wod_part = t1_part no-lock no-error.
		     if not available wod_det then do:
		        put "警告： 工單 " + nbr4 + " 清單中沒找到此料號!" format "x(50)" at 20 skip.
		     end.		     
		  end.

		  if nbr5 > "" or lot5 > "" then do:
                     find first wod_det where wod_nbr = nbr5
		        and wod_part = t1_part no-lock no-error.
		     if not available wod_det then do:
		        put "警告： 工單 " + nbr5 + " 清單中沒找到此料號!" format "x(50)" at 20 skip.
		     end.		     
		  end.

		  if nbr6 > "" or lot6 > "" then do:
                     find first wod_det where wod_nbr = nbr6
		        and wod_part = t1_part no-lock no-error.
		     if not available wod_det then do:
		        put "警告： 工單 " + nbr6 + " 清單中沒找到此料號!" format "x(50)" at 20 skip.
		     end.		     
		  end.

		  if nbr7 > "" or lot7 > "" then do:
                     find first wod_det where wod_nbr = nbr7
		        and wod_part = t1_part no-lock no-error.
		     if not available wod_det then do:
		        put "警告： 工單 " + nbr7 + " 清單中沒找到此料號!" format "x(50)" at 20 skip.
		     end.		     
		  end.

		  if nbr8 > "" or lot8 > "" then do:
                     find first wod_det where wod_nbr = nbr8
		        and wod_part = t1_part no-lock no-error.
		     if not available wod_det then do:
		        put "警告： 工單 " + nbr8 + " 清單中沒找到此料號!" format "x(50)" at 20 skip.
		     end.		     
		  end.
	       end.
	       
	       put skip(2).

               put "混合液晶庫存：" skip
		   "============="  skip.
               find first pt_mstr where pt_part = part no-lock no-error.
	       tmp_desc1 = if avail pt_mstr then trim( pt_desc1 ) + " " + trim(pt_desc2) else "" .

	       display
		  "RCT-WO" @ type l_disp_nbr
		  lotserial_qty 
		  part
		  tmp_desc1
		  site 
		  loc 
		  l_lot
		  
	       with down frame p2 width 140.

	       down 2 with frame p2.

               iss_tot_qty = 0.	       
	       if nbr1 > "" or lot1 > "" then do:
	          iss_tot_qty = iss_tot_qty + qty[1].

  	          display
		     "ISS-WO" @ type
	             nbr1 @ l_disp_nbr
		     qty[1] @ lotserial_qty
		     part
		  tmp_desc1
		  site 
		  loc 
		  l_lot
		     		     
	          with down frame p2 width 140.
		  down 1 with frame p2.
               end.

               if nbr2 > "" or lot2 > "" then do:
	          iss_tot_qty = iss_tot_qty + qty[2].
      	          display
		     "ISS-WO" @ type
	             nbr2 @ l_disp_nbr
		     qty[2] @ lotserial_qty
		     part
		  tmp_desc1
		  site 
		  loc 
		  l_lot
		     	
    	          with down frame p2 width 140.
		  down 1 with frame p2.
               end.

               if nbr3 > "" or lot3 > "" then do:
	          iss_tot_qty = iss_tot_qty + qty[3].
         	  display
		     "ISS-WO" @ type
	             nbr3 @ l_disp_nbr
		     qty[3] @ lotserial_qty
		     part
		  tmp_desc1
		  site 
		  loc 
		  l_lot
		     	
    	          with down frame p2 width 140.
		  down 1 with frame p2.
               end.

               if nbr4 > "" or lot4 > "" then do:
	          iss_tot_qty = iss_tot_qty + qty[4].
	          display
		     "ISS-WO" @ type
	             nbr4 @ l_disp_nbr
		     qty[4] @ lotserial_qty
		     part
		  tmp_desc1
		  site 
		  loc 
		  l_lot
		     	
    	          with down frame p2 width 140.
		  down 1 with frame p2.
               end.

               if nbr5 > "" or lot5 > "" then do:
	          iss_tot_qty = iss_tot_qty + qty[5].
	          display
		     "ISS-WO" @ type
	             nbr5 @ l_disp_nbr
		     qty[5] @ lotserial_qty
		     part
		  tmp_desc1
		  site 
		  loc 
		  l_lot
		     	
    	          with down frame p2 width 140.
		  down 1 with frame p2.
               end.

               if nbr6 > "" or lot6 > "" then do:
	          iss_tot_qty = iss_tot_qty + qty[6].
	          display
		     "ISS-WO" @ type
	             nbr6 @ l_disp_nbr
		     qty[6] @ lotserial_qty
		     part
		  tmp_desc1
		  site 
		  loc 
		  l_lot
		     	
    	          with down frame p2 width 140.
		  down 1 with frame p2.
               end.

               if nbr7 > "" or lot7 > "" then do:
	          iss_tot_qty = iss_tot_qty + qty[7].
	          display
		     "ISS-WO" @ type
	             nbr7 @ l_disp_nbr
		     qty[7] @ lotserial_qty
		     part
		  tmp_desc1
		  site 
		  loc 
		  l_lot
		     	
    	          with down frame p2 width 140.
		  down 1 with frame p2.
               end.

               if nbr8 > "" or lot8 > "" then do:
	          iss_tot_qty = iss_tot_qty + qty[8].
	          display
		     "ISS-WO" @ type
	             nbr8 @ l_disp_nbr
		     qty[8] @ lotserial_qty
		     part
		  tmp_desc1
		  site 
		  loc 
		  l_lot
		     	
    	          with down frame p2 width 140.
		  down 1 with frame p2.
               end.

	          underline lotserial_qty with frame p2.

		  display
		     fill(" ", 8) + "庫存余量:" @ l_disp_nbr
		     (lotserial_qty - iss_tot_qty) @ lotserial_qty
		  with frame p2.
		  down 1 with frame p2.

		
               {mfrpexit.i}

               /* REPORT TRAILER  */
               {mfreset.i}

    	    /* add by ching check store 10/25/2006 */ 

/*for check the last lose data */
               for each temp1 :
	          find first ld_det where ld_part = t1_part and ld_loc = t1_loc
		         and ld_lot = lotser and ld_site = site no-lock no-error.
                  if available ld_det then t1_ld_qty = ld_qty_oh.
	          else t1_ld_qty = 0.
	       end.
	    
	       partstr="".
               for each temp1 no-lock 
	          where t1_ld_qty < t1_qty or t1_ld_qty <= 0 :
	          partstr = partstr + " " + t1_part + "aaa".

		  put "錯誤: 下列扣料數量與實際庫存量不一致!" skip.
	          
		  display
		     t1_part site t1_loc lotser t1_ld_qty t1_qty
		  with down frame abcd width 320.

		  message "錯誤：混合液晶工單及發料失敗， 請檢查實際庫存數是否夠數？".
                  
		  filename = "xxwodvmt.log".

                  OUTPUT TO VALUE(filename) APPEND.
                  PUT UNFORMATTED
 		      "錯誤: 下列扣料數量與實際庫存量不一致!" skip
	              t1_part "; " site "; " t1_loc "; " lotser "; " t1_ld_qty "; " t1_qty "; " today " ;" trim(STRING(TIME)).

		  OUTPUT TO CLOSE.
	       end.
/*for check the last lose data */

	       if trim(partstr) = "" then
	          message "警告: 所有的數據正確嗎?" update update_all.
	       else do:
		  message "錯誤：混合液晶工單及發料失敗， 請檢查實際庫存數是否夠數？ 請重新輸入！！" VIEW-AS ALERT-BOX.
		  pause.
		  message "錯誤：混合液晶工單及發料失敗， 請檢查實際庫存數是否夠數？ 請重新輸入！！" VIEW-AS ALERT-BOX.
		  pause.
		  message "錯誤：混合液晶工單及發料失敗， 請檢查實際庫存數是否夠數？ 請重新輸入！！" VIEW-AS ALERT-BOX.
	       end.


               find first wo_mstr where wo_nbr = l_disp_nbr no-lock no-error.
	       if not available wo_mstr then do:

	    if update_all then do:
            
	    if length(trim(partstr))=0 then do:	           
	       /* add by ching check store 10/25/2006 */

               /* create work order */
	       filename =TRIM(l_disp_nbr) +  TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) + "WOWOMT1" .

               OUTPUT TO VALUE(filename).

               PUT UNFORMATTED
	           quote l_disp_nbr quote space
		   "-" space skip	           
	           quote part quote space
                   "-" space
		   quote site quote space skip
                   quote lotserial_qty quote space
		   quote ord_date quote space
		   "- -" space
		   "R" space
                   "- - - - - - -" space
                   "N" space 
		   "Y" space skip
                   "N" space skip
                   "-" space skip
                   skip(1)
                   "." .
               OUTPUT CLOSE.

               DO TRANSACTION ON ERROR UNDO,RETRY:
                  batchrun = YES.
                  INPUT FROM VALUE(filename).
                  output to  value (filename + ".o") .

                  {gprun.i ""wowomt.p""}

                  INPUT CLOSE.
		  output close.
		  run write_error_to_log(input filename,input filename + ".o") . /* add by ching */
               END.  /** do transaction ***/
               /* Sam Song Add 20070727  Start   - LOCK BY ITSELF*/
               
               REPEAT :
                   find first wo_mstr where wo_nbr  = l_disp_nbr NO-ERROR NO-WAIT.
                   IF NOT AVAILABLE wo_mstr then do:
                      pause 0.2.
		      for first wo_mstr where wo_nbr  = l_disp_nbr no-lock : end.
                   end.
	           else do:
		      iss_lot = wo_lot.
		      leave.
		   end.
               END.
               
	       /* Sam Song Add 20070727  Start*/
	       
	       
               for each temp1 exclusive-lock:
	       /* By SS Davild 20060731 --BEGIN*/
	              
		       filename =TRIM(l_disp_nbr) +  TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) + "WOWOIS2" .

		       /* issue item for work order */
		       OUTPUT TO VALUE(filename).

		       PUT UNFORMATTED l_disp_nbr space 
			   quote iss_lot quote space
			   "-" space
			   quote today quote space
			   "N" space
			   "N" space skip.

                       PUT UNFORMATTED 
		          quote t1_part quote space
		          "-" space skip
			  quote t1_qty  quote space
			  "N" space
			  "N" space
			  quote site quote space
			  quote t1_loc quote space
			  quote lotser quote space
			  "-" space
			  "N" space skip.
			PUT UNFORMATTED 
			   "- -" space skip
			   "Y" space skip
			   "Y" space skip
			   "." .
		       OUTPUT CLOSE.
                       
		       /* Sam Song Add 20070727  Start   - LOCK BY ITSELF*/
		       REPEAT :
			   find first wo_mstr where wo_lot  = iss_lot NO-ERROR NO-WAIT.
			   IF NOT AVAILABLE wo_mstr then do:
			      pause 0.2.
			      for first wo_mstr where wo_lot  = iss_lot no-lock : end.
			   end.
			   else leave.
		       END.
		       /* Sam Song Add 20070727  Start*/



		       DO TRANSACTION ON ERROR UNDO,RETRY:
			  batchrun = YES.
			  INPUT FROM VALUE(filename).
			  output to  value (filename + ".o") .

			  {gprun.i ""wowois.p""}

			  INPUT CLOSE.
			  output close.
			  run write_error_to_log(input filename,input filename + ".o") . /* add by ching */
		       END.  /** do transaction ***/		       

		       /* Sam Song Add 20070727  Start   - LOCK BY ITSELF*/
		       REPEAT :
			   find first wo_mstr where wo_lot  = iss_lot NO-ERROR NO-WAIT.
			   IF NOT AVAILABLE wo_mstr then do:
			      pause 0.2.
			      for first wo_mstr where wo_nbr  = l_disp_nbr no-lock : end.
			   end.
			   else leave.
		       END.
		       /* Sam Song Add 20070727  Start*/
		
               end.
               
               filename = TRIM(l_disp_nbr) + TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) + "WOWORC3" .

               /*  receipt for work order */
               OUTPUT TO VALUE(filename).

               PUT UNFORMATTED
	           quote l_disp_nbr quote    space
		   quote iss_lot quote       space skip
                         
		   quote lotserial_qty quote space
		   "- 1 0 - 1"               space
		   quote site quote          space
		   quote loc quote           space
		   quote l_lot quote         space
		   "-"                       space
		   "N"                       space
		   "N"                       space skip
		   "- - "                    space
                   "N"                       space skip
                   "Y"                       space skip
                   "Y"                       space skip
                   "." skip.

               OUTPUT CLOSE.

               DO TRANSACTION ON ERROR UNDO,RETRY:
                  batchrun = YES.
                  INPUT FROM VALUE(filename).
                  output to  value (filename + ".o") .

                  {gprun.i ""woworc.p""}

                  INPUT CLOSE.
  		  output close.
		  run write_error_to_log(input filename,input filename + ".o") . /* add by ching */
               END.  /** do transaction ***/
               release wo_mstr.	       

	       /* By SS Davild 20060808 -自動關閉液晶工單--END*/
               if nbr1 > "" or lot1 > "" then do:
                  filename = TRIM(nbr1) + TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) + "WOWOIS4" .

                  /* issue item for work order */
                  OUTPUT TO VALUE(filename).

                  PUT UNFORMATTED
		      quote nbr1 quote       space
                      quote lot1 quote       space
		      "-"                    space
                      quote today quote      space
		      "N"                    space
		      "N"                    space skip
		      quote part quote       space
		      "-"                    space skip
                      quote qty[1]  quote     space
		      "N"                    space
		      "N"                    space
		      quote site quote       space
		      quote loc quote        space
		      quote l_lot quote      space
		      "-"                    space
		      "N"                    space skip
	              "- -"                  space skip
		      "Y" space skip
		      "Y" space skip
 	              "." skip.
                  OUTPUT CLOSE.

                  DO TRANSACTION ON ERROR UNDO,RETRY:
                     batchrun = YES.
                     INPUT FROM VALUE(filename).
                     output to  value (filename + ".o") .

                     {gprun.i ""wowois.p""}

                     INPUT CLOSE.
  		     output close.
		     /* message "OK1".
		     pause 3. */
		     run write_error_to_log(input filename,input filename + ".o") . /* add by ching */
		     /* message "OK2".
		     pause 3. */
                  END.  /** do transaction ***/		  
               end.
               release wo_mstr.

               if nbr2 > "" or lot2 > "" then do:
                  filename = TRIM(nbr2) +  TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) + "WOWOIS5" .

                  /* issue item for work order */
                  OUTPUT TO VALUE(filename).

                  PUT UNFORMATTED 
		      quote nbr2 quote       space
                      quote lot2 quote       space
		      "-"                    space
                      quote today quote      space
		      "N"                    space
		      "N"                    space skip
		      quote part quote       space
		      "-"                    space skip
                      quote qty[2] quote     space
		      "N"                    space
		      "N"                    space
		      quote site quote       space
		      quote loc quote        space
		      quote l_lot quote      space
		      "-"                    space
		      "N"                    space skip
	              "- -"                  space skip
		      "Y" space skip
		      "Y" space skip
 	              "." skip.
                  OUTPUT CLOSE.

                  DO TRANSACTION ON ERROR UNDO,RETRY:
                     batchrun = YES.
                     INPUT FROM VALUE(filename).
                     output to  value (filename + ".o") .

                     {gprun.i ""wowois.p""}

                     INPUT CLOSE.
  		     output close.
                  END.  /** do transaction ***/
		  run write_error_to_log(input filename,input filename + ".o") . /* add by ching */
               end.
               release wo_mstr.

               if nbr3 > "" or lot3 > "" then do:
                  filename =TRIM(nbr3) +  TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) + "WOWOIS6" .

                  /* issue item for work order */
                  OUTPUT TO VALUE(filename).

                  PUT UNFORMATTED 
		      quote nbr3 quote       space
                      quote lot3 quote       space
		      "-"                    space
                      quote today quote      space
		      "N"                    space
		      "N"                    space skip
		      quote part quote       space
		      "-"                    space skip
                      quote qty[3] quote     space
		      "N"                    space
		      "N"                    space
		      quote site quote       space
		      quote loc quote        space
		      quote l_lot quote      space
		      "-"                    space
		      "N"                    space skip
	              "- -"                  space skip
		      "Y" space skip
		      "Y" space skip
 	              "." skip.
                  OUTPUT CLOSE.

                  DO TRANSACTION ON ERROR UNDO,RETRY:
                     batchrun = YES.
                     INPUT FROM VALUE(filename).
                     output to  value (filename + ".o") .

                     {gprun.i ""wowois.p""}

                     INPUT CLOSE.
  		     output close.
                  END.  /** do transaction ***/
		  run write_error_to_log(input filename,input filename + ".o") . /* add by ching */
               end.
               release wo_mstr.

               if nbr4 > "" or lot4 > "" then do:
                  filename = TRIM(nbr4) +  TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) + "WOWOIS7" .

                  /* issue item for work order */
                  OUTPUT TO VALUE(filename).

                  PUT UNFORMATTED 
		      quote nbr4 quote       space
                      quote lot4 quote       space
		      "-"                    space
                      quote today quote      space
		      "N"                    space
		      "N"                    space skip
		      quote part quote       space
		      "-"                    space skip
                      quote qty[4] quote     space
		      "N"                    space
		      "N"                    space
		      quote site quote       space
		      quote loc quote        space
		      quote l_lot quote      space
		      "-"                    space
		      "N"                    space skip
	              "- -"                  space skip
		      "Y" space skip
		      "Y" space skip
 	              "." skip.
                  OUTPUT CLOSE.

                  DO TRANSACTION ON ERROR UNDO,RETRY:
                     batchrun = YES.
                     INPUT FROM VALUE(filename).
                     output to  value (filename + ".o") .

                     {gprun.i ""wowois.p""}

                     INPUT CLOSE.
  		     output close.
                  END.  /** do transaction ***/
		  run write_error_to_log(input filename,input filename + ".o") . /* add by ching */
	       /* By SS Davild 20060731 --BEGIN*/
	       	  unix silent value ( "rm -f "  + Trim(filename)).	
		  unix silent value ( "rm -f "  + Trim(filename) + ".o"). 
		/* By SS Davild 20060731 --END*/
               end.
               release wo_mstr.

               if nbr5 > "" or lot5 > "" then do:
                  filename =TRIM(nbr5) +  TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) + "WOWOIS8" .

                  /* issue item for work order */
                  OUTPUT TO VALUE(filename).

                  PUT UNFORMATTED 
		      quote nbr5 quote       space
                      quote lot5 quote       space
		      "-"                    space
                      quote today quote      space
		      "N"                    space
		      "N"                    space skip
		      quote part quote       space
		      "-"                    space skip
                      quote qty[5] quote     space
		      "N"                    space
		      "N"                    space
		      quote site quote       space
		      quote loc quote        space
		      quote l_lot quote      space
		      "-"                    space
		      "N"                    space skip
	              "- -"                  space skip
		      "Y" space skip
		      "Y" space skip
 	              "." skip.
                  OUTPUT CLOSE.

                  DO TRANSACTION ON ERROR UNDO,RETRY:
                     batchrun = YES.
                     INPUT FROM VALUE(filename).
                     output to  value (filename + ".o") .

                     {gprun.i ""wowois.p""}

                     INPUT CLOSE.
  		     output close.
                  END.  /** do transaction ***/
		  run write_error_to_log(input filename,input filename + ".o") . /* add by ching */
               end.
               release wo_mstr.

	       if nbr6 > "" or lot6 > "" then do:
                  filename =TRIM(nbr6) +  TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) + "WOWOIS9" .

                  /* issue item for work order */
                  OUTPUT TO VALUE(filename).

                  PUT UNFORMATTED 
		      quote nbr6 quote       space
                      quote lot6 quote       space
		      "-"                    space
                      quote today quote      space
		      "N"                    space
		      "N"                    space skip
		      quote part quote       space
		      "-"                    space skip
                      quote qty[6] quote     space
		      "N"                    space
		      "N"                    space
		      quote site quote       space
		      quote loc quote        space
		      quote l_lot quote      space
		      "-"                    space
		      "N"                    space skip
	              "- -"                  space skip
		      "Y" space skip
		      "Y" space skip
 	              "." skip.
                  OUTPUT CLOSE.

                  DO TRANSACTION ON ERROR UNDO,RETRY:
                     batchrun = YES.
                     INPUT FROM VALUE(filename).
                     output to  value (filename + ".o") .

                     {gprun.i ""wowois.p""}

                     INPUT CLOSE.
  		     output close.
                  END.  /** do transaction ***/
		  run write_error_to_log(input filename,input filename + ".o") . /* add by ching */
               end.
               release wo_mstr.

               if nbr7 > "" or lot7 > "" then do:
                  filename =TRIM(nbr7) +  TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) + "WOWOIS10" .

                  /* issue item for work order */
                  OUTPUT TO VALUE(filename).

                  PUT UNFORMATTED 
		      quote nbr7 quote       space
                      quote lot7 quote       space
		      "-"                    space
                      quote today quote      space
		      "N"                    space
		      "N"                    space skip
		      quote part quote       space
		      "-"                    space skip
                      quote qty[7] quote     space
		      "N"                    space
		      "N"                    space
		      quote site quote       space
		      quote loc quote        space
		      quote l_lot quote      space
		      "-"                    space
		      "N"                    space skip
	              "- -"                  space skip
		      "Y" space skip
		      "Y" space skip
 	              "." skip.
                  OUTPUT CLOSE.

                  DO TRANSACTION ON ERROR UNDO,RETRY:
                     batchrun = YES.
                     INPUT FROM VALUE(filename).
                     output to  value (filename + ".o") .

                     {gprun.i ""wowois.p""}

                     INPUT CLOSE.
  		     output close.
                  END.  /** do transaction ***/
		  run write_error_to_log(input filename,input filename + ".o") . /* add by ching */
               end.
               release wo_mstr.

               if nbr8 > "" or lot8 > "" then do:
                  filename =TRIM(nbr8) +  TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) + "WOWOIS11" .

                  /* issue item for work order */
                  OUTPUT TO VALUE(filename).

                  PUT UNFORMATTED 
		      quote nbr8 quote       space
                      quote lot8 quote       space
		      "-"                    space
                      quote today quote      space
		      "N"                    space
		      "N"                    space skip
		      quote part quote       space
		      "-"                    space skip
                      quote qty[8] quote     space
		      "N"                    space
		      "N"                    space
		      quote site quote       space
		      quote loc quote        space
		      quote l_lot quote      space
		      "-"                    space
		      "N"                    space skip
	              "- -"                  space skip
		      "Y" space skip
		      "Y" space skip
 	              "." skip.
                  OUTPUT CLOSE.

                  DO TRANSACTION ON ERROR UNDO,RETRY:
                     batchrun = YES.
                     INPUT FROM VALUE(filename).
                     output to  value (filename + ".o") .

                     {gprun.i ""wowois.p""}

                     INPUT CLOSE.
  		     output close.
                  END.  /** do transaction ***/
		  run write_error_to_log(input filename,input filename + ".o") . /* add by ching */
               end.
               release wo_mstr.
/***************2007/08/08   REPEAT WOISS** SAM SONG   START **************************/
	       for each temp1 exclusive-lock:
	       /* By SS Davild 20060731 --BEGIN*/
	                find first tr_hist where tr_nbr = l_disp_nbr  and tr_type = "ISS-WO" and
			                         tr_part = t1_part    and tr_qty_loc = - t1_qty and
						 tr_serial = lotser   and tr_loc    = t1_loc no-lock no-error.
			if NOT AVAILABLE tr_hist then do : 



			       filename =TRIM(l_disp_nbr) +  TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) + "WOWOIS2" .

			       /* issue item for work order */
			       OUTPUT TO VALUE(filename).

			       PUT UNFORMATTED l_disp_nbr space 
				   "-" space
				   "-" space
				   quote today quote space
				   "N" space
				   "N" space skip.

			       PUT UNFORMATTED 
				  quote t1_part quote space
				  "-" space skip
				  quote t1_qty  quote space
				  "N" space
				  "N" space
				  quote site quote space
				  quote t1_loc quote space
				  quote lotser quote space
				  "-" space
				  "N" space skip.
				PUT UNFORMATTED 
				   "- -" space skip
				   "Y" space skip
				   "Y" space skip
				   "." .
			       OUTPUT CLOSE.
			       
			       /* Sam Song Add 20070727  Start   - LOCK BY ITSELF*/
			       REPEAT :
				   find first wo_mstr where wo_nbr  = l_disp_nbr NO-ERROR NO-WAIT.
				   IF NOT AVAILABLE wo_mstr then do:
				      pause 0.2.
				      for first wo_mstr where wo_nbr  = l_disp_nbr no-lock : end.
				   end.
				   else leave.
			       END.
			       /* Sam Song Add 20070727  Start*/



			       DO TRANSACTION ON ERROR UNDO,RETRY:
				  batchrun = YES.
				  INPUT FROM VALUE(filename).
				  output to  value (filename + ".o") .

				  {gprun.i ""wowois.p""}

				  INPUT CLOSE.
				  output close.
				  run write_error_to_log(input filename,input filename + ".o") . /* add by ching */
			       END.  /** do transaction ***/		       

			       /* Sam Song Add 20070727  Start   - LOCK BY ITSELF*/
			       REPEAT :
				   find first wo_mstr where wo_nbr  = l_disp_nbr NO-ERROR NO-WAIT.
				   IF NOT AVAILABLE wo_mstr then do:
				      pause 0.2.
				      for first wo_mstr where wo_nbr  = l_disp_nbr no-lock : end.
				   end.
				   else leave.
			       END.
			       /* Sam Song Add 20070727  Start*/
	             END.  /* NOT AVALIEBLE tr_hist then do */
		
               end.
               
/***************2007/08/08   REPEAT WOISS** SAM SONG   END **************************/


               empty temp-table temp1.
               empty temp-table temp2.
               empty temp-table temp3.

               clear frame a all no-pause.
               clear frame b all no-pause.
               clear frame c all no-pause.
	       view frame a.
	       view frame b.
	       qty = 0.
               ord_date = today.
               lotserial_qty = 0.
               exp_code = "00".
	       lotserial = l_lot.
	       nbr1 = "".  lot1 = "" .
	       nbr2 = "".  lot2 = "".	      
               nbr3 = "".  lot3 = "".	       
               nbr4 = "".  lot4 = "".
	       nbr5 = "".  lot5 = "".
               nbr6 = "".  lot6 = "".
               nbr7 = "".  lot7 = "".
	       nbr8 = "".  lot8 = "".
	  end.  
	  else do:
	     message "料品" + partstr + "庫存不足,重試" VIEW-AS ALERT-BOX .
	  end.
       end. /* end of updated_all */

	  end. 

	  else do:	         
	     message "工單號已存在，重試." VIEW-AS ALERT-BOX .		  
	  end.   /* else do: */
       end. /* mainloot: */
/* By SS Davild 20060808 --BEGIN*/

PROCEDURE getpart_min_lot:
    DEF INPUT PARAM pro_part AS CHAR .
    DEF INPUT PARAM pro_site AS CHAR .
    def input param pro_loc as char .
    DEF OUTPUT PARAM pro_lot AS CHAR .
    DEF OUTPUT PARAM pro_qty_oh like ld_qty_oh .
    def var ii as inte.
	ii = 1 .
    for each ld_det where ld_site = pro_site and ld_part = pro_part and ld_loc = pro_loc 
         and ld_qty_oh > 0 no-lock by ld_lot :
	if ii = 1 THEN DO:
		ii = 2 .
		assign 
		       pro_lot = ld_lot
		       pro_qty_oh = ld_qty_oh .
		       leave .
	END. /* THEN DO */

    end.
    if ii = 1 THEN DO:    /*如果未找到則為空值或0*/
    assign pro_loc = ""
		       pro_lot = ""
		       pro_qty_oh = 0 .
    END. /* THEN DO */
    
END PROCEDURE .
/*找出最小批號及對應庫位,記住庫存數--END*/

/* By SS Davild 20060808 --END*/


/* write err log  start  by ching*/
PROCEDURE write_error_to_log:
  DEF INPUT PARAM file_name AS CHAR .
  DEF INPUT PARAM file_name_o AS CHAR .
  DEF var linechar AS CHAR .
  def var woutputstatment as char.
  def var ik as inte.
	  
   linechar = "" .
	input from value (file_name_o) .
             
	    repeat: 
	  	                
		  IMPORT UNFORMATTED woutputstatment.                         
                   
		  IF index (woutputstatment,"ERROR:")   <> 0 OR    /* for us langx */ 
		     index (woutputstatment,"渣昫:")	<> 0 OR    /* for ch langx */
		     index (woutputstatment,"錯誤:")	<> 0       /* for tw langx */ 
		     
		     then do:
			  
			  output to  value ( "log.err") APPEND.
			  put  unformatted today " " string (time,"hh:mm:ss")  " " file_name_o " " woutputstatment  skip.
			  output close.
			  linechar = "ERROR" .
			  
		     end.
		     
	    End.

           
	input close.
/*	  
	if linechar <> "ERROR" then do:
			unix silent value ("rm -f "  + trim(file_name)).
			unix silent value ("rm -f "  + trim(file_name_o)).
			
	end. 
*/
end.
/* run write_error_to_log(input filename,input file_name + ".o") . */
/* write err log  end   by ching*/
