/* zzgtsola.i - UPLOAD INVOICE DATA GENERATE BY GOLD-TAX INTO MFG/PRO       */
/*                                                                         */
/* VERSION:          DATE:2000.04.17  BY:James Zou*ORIGIN SHA*BW0000       */
/*	LAST MODIFIED 	DAT:2004.5.27	BY: *LB01* LONG BO 					   */
/*
    message "coming in zzgtsola.i".
    pause.
*/
    v_totso = 0.
    
    output stream rpt to value(v_rpfile).
    
    put stream rpt "DATE : " at 1 today at 20 skip
                   "INPUT FILE : " at 1 v_infile at 20  skip
                   "BACKUP FILE : " at 1 v_bkfile at 20 skip.
    put stream rpt "LOAD(Y)/VIEW(N) : " at 1 v_load at 20 skip(1).
/*    
        message "hello>>>".
        pause.   
        */                    
    for each giv:
/*
put stream rpt unformatted fill("=",80) skip.
display stream rpt giv with 2 column.
*/
/*
        message "hello2".
        pause.
        */
      type = "".
      if gref = "��" then do:
			put stream rpt  
			    "INVOICE " at 1 
			    ginv at 10
			    ": THE REFERENCE NUMBER IS BLANK!" AT 20.
			gerrflag = yes.
			gerrmsg  = "THE REFERENCE NUMBER IS BLANK.".
			next.
      end.
      else do:  /* reference nbr is not blank */
	        find first usrw_wkfl 
	             where usrw_key1 = "GOLDTAX-MSTR"
	             and   usrw_key5 = gref
	             no-lock no-error.
	        if available usrw_wkfl then do:  /*load before*/
	          put stream rpt  
	              "��Ʊ " at 1 
	              ginv at 10
	              ": �Ѿ��ϴ���!" AT 20.
	          gerrflag = yes.
	          gerrmsg  = "��Ʊ�Ѿ��ϴ���!".
	          next.
	        end.
        else do: /*will be load*/
/*origin20000703*/

		/* lb02 --2004-11-12 9:25

          find first so_mstr 
               where so_inv_nbr = ginv
               and  so_nbr <> substring(gref,6,8) 
               no-lock no-error.

          if available so_mstr then do:
            gerrflag = yes.
            gerrmsg  = "SO Invoice number be assign to another SO!".
            next.
          end.
          
          find first so_mstr 
               where so_nbr = substring(gref,6,8) 
               no-error.
          if available so_mstr then do:
            type    = "SO".

            if can-find(ar_mstr where ar_nbr = ginv)
            or can-find(first ih_hist where ih_inv_nbr = ginv) 
            then do:
              put stream rpt  
                  "INVOICE " at 1 
                  ginv at 10
                  ": Invoice conflict with ih_hist or ar_mstr!" AT 20.
              IF v_invprex = "" THEN DO:
                  gerrflag = yes.
                  gerrmsg  = "Invoice conflict with ih_hist or ar_mstr!".
                  next.
              END.
              ELSE DO:
                 ginvx = v_invprex + SUBSTRING(ginv, (LENGTH(v_invprex) + 1)).
                 if can-find(ar_mstr where ar_nbr = ginvx)
                 or can-find(first ih_hist where ih_inv_nbr = ginvx) 
                 then do:
                    put stream rpt  
                         "INVOICE " at 1 
                         ginvx      at 10
                         ": Invoice conflict with ih_hist or ar_mstr!" AT 20.
                    gerrflag = yes.
                    gerrmsg  = "Invoice conflict with ih_hist or ar_mstr!".
                    next.
                 END.
              END.
            end.

		--lb02*/
		/*
        message "hello3".
        pause.*/		
			/*lb02*- duplicate invoice number check */

			find first usrw_wkfl exclusive-lock
			where usrw_key1 = "GOLD-TAX-SO"
			and usrw_key2 = gref no-error.
			
			if not available usrw_wkfl then do:
		          put stream rpt  
		              "���ݺ�" at 1 
		              gref at 10
		              ": �����ڣ��Ҳ�����Ӧ�����۶���!" AT 20.
		          gerrflag = yes.
		          gerrmsg  = "���ݺŲ����ڣ��Ҳ�����Ӧ�����۶���!".
		          next.
			end.
	
			/*check so_mstr*/
			for each so_mstr no-lock where 
			so_inv_nbr = ginv:
				s_pos = index(usrw_key3, so_nbr).
				if s_pos > 0 and ((s_pos - 1) mod 8 = 0 ) then do:
					if substring(usrw_key3, s_pos, 8) = so_nbr then do:
				          put stream rpt  
				              "��Ʊ" at 1 
				              ginv at 10
				              ": �Ѿ�������������۶���!" AT 20.
				          gerrflag = yes.
				          gerrmsg  = "��Ʊ���Ѿ�������������۶���!".
				          next.
					end.
				end.
			end.
	/*		
        message "hello4".
        pause.*/			
			/*check ar_mstr*/
			find first ar_mstr where ar_nbr = ginv no-lock no-error.
			if available ar_mstr then do:
		          put stream rpt  
		              "��Ʊ" at 1 
		              ginv at 10
		              ": �Ѿ�����AR_MSTR��!" AT 20.
		          gerrflag = yes.
		          gerrmsg  = "��Ʊ���Ѿ�����AR_MSTR��!".
		          next.
			end.
			/*check ih_hist*/
			for each ih_hist no-lock
			where ih_inv_nbr = ginv:
				s_pos = index(usrw_key3, ih_nbr).
				if s_pos > 0 and ((s_pos - 1) mod 8 = 0 ) then do:
					if substring(usrw_key3, s_pos, 8) = ih_nbr then do:
				          put stream rpt  
				              "��Ʊ" at 1 
				              ginv at 10
				              ": �Ѿ����ڷ�Ʊ��ʷ��¼��!" AT 20.
				          gerrflag = yes.
				          gerrmsg  = "��Ʊ���Ѿ����ڷ�Ʊ��ʷ��¼��!".
				          next.
					end.
				end.
			end.
			/*--lb02*/
			
			v_sonbr = usrw_key3.
			do while v_sonbr <> "":
				find first so_mstr where so_nbr = substring(v_sonbr,1,8) no-error.
				if not available so_mstr then do:
		            if can-find(ar_mstr where ar_nbr = ginv)
        		    or can-find(first ih_hist where ih_inv_nbr = ginv) 
            		then do:
				          put stream rpt  
				              "����" at 1 
				              substring(v_sonbr,1,8) at 10
				              ": �Ѿ���Ʊ����!" AT 20.
				          gerrflag = yes.
				          gerrmsg  = substring(v_sonbr,1,8) + "���۶����Ѿ���Ʊ����!".
						  v_sonbr = "".
					end.
					else do:
				          put stream rpt  
				              "����" at 1 
				              substring(v_sonbr,1,8) at 10
				              ": ������!" AT 20.
				          gerrflag = yes.
				          gerrmsg  = substring(v_sonbr,1,8) + "���۶���������!".
						  v_sonbr = "".
					end.
				end.
				
				if not gerrflag then v_sonbr = substring(v_sonbr,9).
			end.
			
			if gerrflag then next.
			
			find first so_mstr where so_nbr = substring(usrw_key3,1,8).

            v_site  = so_site.
            v_totso = v_totso + 1.
            gnbr    = so_nbr.
            gcust   = so_cust.
            gbill   = so_bill.
            gshipdate   = so_ship_date.
            gsite   = so_site.

            /*load inv_nbr,inv_date, change status*/
            ginvx = ginv. /*lb02 2004-11-12 10:18*/
            
            if v_load = yes then do:

				v_sonbr = usrw_key3.
				do while v_sonbr <> "":
					find first so_mstr where so_nbr = substring(v_sonbr,1,8) no-error.
			        so_inv_nbr  = ginvx.
		            so_to_inv   = no.
		            so_invoiced = yes.
		            so_inv_date = gdate.
					v_sonbr = substring(v_sonbr,9).
				end.
				
				/*lb02 
	              so_inv_nbr  = ginvx.
	              so_to_inv   = no.
	              so_invoiced = yes.
	              so_inv_date = gdate.
	              substring(so_user1,1,1) = "L".
	              so_user2    = ginv.
				 lb02*/
            end.

            /*create goldtax-mstr*/
            if v_load = yes then do:
              create usrw_wkfl.
              assign usrw_key1    = "GOLDTAX-MSTR"
                 usrw_key2        = v_gtaxid + "-" + gref + "-" + ginv + "-" + ginvx
                 usrw_key3        = v_gtaxid
                 usrw_key4        = gnbr
                 usrw_key5        = gref
                 usrw_key6        = ginv
                 usrw_user2       = ginvx
                 usrw_user1       = global_userid
                 usrw_charfld[1]  = "VAT"
                 usrw_charfld[2]  = "SO"
                 usrw_charfld[3]  = "L"
                 usrw_charfld[4]  = gcust
                 usrw_charfld[5]  = gbill
                 usrw_charfld[6]  = gsite
                 usrw_charfld[7]  = grmks
                 usrw_datefld[1]  = gdate
                 usrw_datefld[2]  = gshipdate
                 usrw_charfld[11] = string(gtotamt)
                 usrw_charfld[12] = string(gmfgtotamt)
                 usrw_decfld[1]   = gtaxpct * 100
                 .
				
            end.
		
		  /*lb02-- 	
.          end. /*available so_mstr*/
.          else do: /*can not find so_mstr*/ 
.            if can-find(ar_mstr where ar_nbr = ginv)
.            or can-find(first ih_hist where ih_inv_nbr = ginv) 
.            then do:
.              put stream rpt  
.                  "INVOICE " at 1 
.                  ginv at 10
.                  ": SO Invoice been posted!" AT 20.
.              gerrflag = yes.
.              gerrmsg  = "SO Invoice been posted!".
.              next.
.            end.
.            else do: 
.              put stream rpt  
.                  "INVOICE " at 1 
.                  ginv at 10
.                  ": Can not find SO/INV!" AT 20.
.              gerrflag = yes.
.              gerrmsg  = "Can not find SO/INV!".
.              next.
.            end.
.          end. /*not so_mstr*/
.          ---lb02*/
          
          
        end. /*will load*/

/*lb02--
        if type = "" then do:
          put stream rpt  
              "INVOICE " at 1 
              ginv at 10
              ": Can not find SO/INV!" AT 20.
          gerrflag = yes.
          gerrmsg  = "Can not find SO/INV!".
          next.
        end.
*/          

        /*after check*/
        /*cal totamt using MFG standard method*/
       /* {gprun.i ""zzgtsola.p"" 
                 "(
                   input gnbr,
                   output gmfgtotamt,output  gmfgtaxamt,output  gmfgnetamt
                  )"}
		*/
		
		/*lb02--*/
		find first usrw_wkfl exclusive-lock
		where usrw_key1 = "GOLD-TAX-SO"
		and usrw_key2 = gref no-error.
		v_sonbr = usrw_key3.

		v_totamt = 0.
		do while v_sonbr <> "":
			find first so_mstr where so_nbr = substring(v_sonbr,1,8) no-error.
			{gprun.i ""zzgttotal.p"" "(input so_nbr,
	                                        output gmfgtotamt)"}
			v_totamt = v_totamt + gmfgtotamt.
						
			v_sonbr = substring(v_sonbr,9).
		end.
		gmfgtotamt = v_totamt.
		/*--lb02*/
		
		/*lb02		
		{gprun.i ""zzgttotal.p"" "(input gnbr,
                                        output gmfgtotamt)"}
        --*/
                                        
        if v_adj then do:
          if (ABSOLUTE(gtotamt - gmfgtotamt) <= v_drange) or (v_drange = 0) then do:
            find first so_mstr
                 where so_nbr = gnbr
                 and   so_inv_nbr = ginvx
                 no-error.
            if available so_mstr then do:
             /*Trailer Master ���ô��� = Sale Order ���÷��� 1*/
              FIND FIRST trl_mstr WHERE trl_code = so_trl1_cd NO-LOCK NO-ERROR.
              IF NOT AVAILABLE trl_mstr THEN DO:
                  gerrflag = yes.
                  gerrmsg  = "ERROR:β���������.".
                  next.
              END.
              /*Sale Order  ���ý�� 1 */
              so_trl1_amt = so_trl1_amt + gtotamt - gmfgtotamt.
            end.
          end.
          else do:
            gerrflag = yes.
            gerrmsg  = "ERROR:�����ݲ�����������.".
            next.
          end.
        end.
        ELSE DO:
                       
            if (ABSOLUTE(gtotamt - gmfgtotamt) > v_drange AND v_drange <> 0 ) then do:
            /*
            message "gtotamt=" + string(gtotamt).
            pause.
            message "gmfgtotamt=" + string(gmfgtotamt).
            pause.
            message "v_drange=" + string(v_drange).
            pause. 
            */
                gerrmsg  = "WARNING:���ڲ���.".
            END. 
        END.
        /*
        message "hello".
        pause.*/
/* DO NOT POST        
        /*post to ar*/
        /*check post effdate*/
        {gpglefv.i}
        {gprun.i ""gpglef1.p""
                 "( input  ""SO"",
                    input  glentity,
                    input  gdate,
                    output gpglef_result,
                    output gpglef_msg_nbr
                    )" }

        if gpglef_result > 0 then do:
          gerrflag = yes.
          gerrmsg  = "ERROR:effect date is invalid!".
          next.
        end.
        else do:
          v_postfile = v_rpbox 
                      + "iv"
                      + string(month(v_dt),"99")
                      + string(day(v_dt),"99")
                      + string(ginvx) 
                      .

          find first so_mstr
               where so_inv_nbr = ginvx
               and   so_nbr     = gnbr
               and   so_to_inv  = no
               and   so_invoiced = yes
               no-lock no-error.
          if not available so_mstr and v_load = yes then do:
            gerrflag = yes.
            gerrmsg  = "ERROR:SO Status is invalid!".
            next.
          end.
          else do:
          	v_post = no. /*lb01 DO NOT POST */
            if v_post then do:
            /*
               message "begin to post".
               pause.
               */
              if (gtotamt - gmfgtotamt <= v_drange) or (v_drange = 0) then do:
                {gprun.i ""zzgtsolb.p"" 
                         "(input ginvx, 
                           input gdate, 
                           input v_postfile, 
                           output gerrflag
                           )"}
                           /*
               message "ginvx=" + string(ginvx).
               pause.
               message "gdate=" + string(gdate).
               pause.
               message "v_postfile=" + string(v_postfile).
               pause.
               message "gerrflag=" + string(gerrflag).
               pause.*/                                                                         
              end.
              else do:
                gerrflag = yes.
                gerrmsg  = "ERR:Difference out of range.do not posted".
                next.
              end.
            end.
          end.
        end.       
      DO NOT POST*/
		
        /*create goldtax-mstr*/
        if v_load = yes then do:
          find first usrw_wkfl
               where usrw_key1    = "GOLDTAX-MSTR"
               and   usrw_key2    = v_gtaxid + "-" + gref + "-" + ginvx
               no-error.
          if available usrw_wkfl then do:
            assign
                 usrw_charfld[12] = string(gmfgtotamt)
                 .
          end.
        end.
      end. /*ref not blank*/
    end.  /* end of "for each" */
    
    put stream rpt skip(1)
        "TOTAL SALES ORDER INVOICE LOADED : " at 1 v_totso to 45 skip.
        
/*    output stream rpt close. */
    
    /*update control file*/
    if v_load then do:  /* 2004-11-15 12:36 added. only unpdate when loading */
    
	    find first usrw_wkfl 
	         where usrw_key1 = "GOLDTAX-CTRL"
	         and   lookup(global_userid,usrw_charfld[1]) <> 0
	         no-error.
	    if available usrw_wkfl then do:
	      overlay(usrw_charfld[6],31,6) = string(v_times,"999999").
	      overlay(usrw_charfld[6],21,8) =   string(year(today),"9999") 
	                                      + string(month(today),"99")
	                                      + string(day(today),"99").
	    end.
	    
	end.
	
    /*report to screen*/      
/************
    input from value(v_rpfile) .
    repeat:
      import unformatted v_rpline.
      put v_rpline at 1.
    end.
************/
put stream rpt unformatted skip fill("=",158) skip.
    for each giv with frame xx width 200 down:
/* message "xxxx" . pause. */
      display stream rpt
              ginv                         column-label "��Ʊ��"
              gerrflag                     column-label "ERR"
              ginvx                        column-label "MFG��Ʊ"
              gref         format "x(20)"  column-label "���ݺ�"
              gnbr                         column-label "������"
              gbill                        column-label "��Ʊ��"
              gdate                        column-label "��Ʊ����"
              gshipdate                    column-label "��������"
              gtotamt                      column-label "��Ʊ���"
              gmfgtotamt                   column-label "ԭMFG���"
              gerrmsg      format "x(40)"  column-label "������Ϣ"
              .
      display 
              ginv                         column-label "��Ʊ��"
              gerrflag                     column-label "ERR"
              ginvx                        column-label "MFG��Ʊ"
              gref         format "x(20)"  column-label "���ݺ�"
              gnbr                         column-label "������"
              gbill                        column-label "��Ʊ��"
              gdate                        column-label "��Ʊ����"
              gshipdate                    column-label "��������"
              gtotamt                      column-label "��Ʊ���"
              gmfgtotamt                   column-label "ԭMFG���"
              gerrmsg      format "x(40)"  column-label "������Ϣ"
              .
       
       /*DISPLAY EACH ORDER LOADED*/ 
		find first usrw_wkfl exclusive-lock
		where usrw_key1 = "GOLD-TAX-SO"
		and usrw_key2 = gref no-error.
		v_sonbr = substring(usrw_key3,9).

		do while v_sonbr <> "":
			put stream rpt substring(v_sonbr,1,8) at 44 skip.
			put  substring(v_sonbr,1,8) at 44 skip.
			v_sonbr = substring(v_sonbr,9).
		end.
             
              
              
    end.
    output stream rpt close.
    
/*    {mfreset.i} */

    /*move data file to back box*/
	if opsys = "unix" then do:
	    if v_load then unix silent mv value(v_infile) value(v_bkfile).
	            /*  else unix silent cp value(v_infile) value(v_bkfile).  lb02 2004-11-15 12:38*/
	end.
		
	else if opsys = "win32" then do:
	    if v_load then dos silent move value(v_infile) value(v_bkfile).
	             /* else dos silent copy value(v_infile) value(v_bkfile).  lb02 2004-11-15 12:38*/
	end.	
	
	
	
	