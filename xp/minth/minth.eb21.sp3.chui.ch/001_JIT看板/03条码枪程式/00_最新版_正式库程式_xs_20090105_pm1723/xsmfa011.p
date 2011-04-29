define variable psid   like pt_part.
define variable i as integer.
define variable rs as char.
define variable aa as char.
define variable pswd   like pt_part.
define variable usection as char format "x(16)".
define variable stime as integer init 1.
define variable oldpasswd like usr_passwd.
define variable temp as char format "x(100)"   init "".
define variable counter as char format "x(10)" init "".
define variable temp1 as char format "x(100)"  init "".
define variable license1 as char format "x(6)" init "".
define variable license2 as char format "x(6)" init "".
define variable license3 as char format "x(6)" init "".
define variable license as char format "x(18)" init "".
define variable oldmnd_canrun  like mnd_canrun.
define variable cim_dbname as char format "x(20)".
/*tx01*/ define variable quote as char initial '"' no-undo.

/* Counter Convert Function Start*/
/*mage add */ define variable loop1  as integer init 1.

FUNCTION getcounter RETURNS CHAR (INPUT parm1 AS CHAR).
 
    CASE parm1:
        WHEN "A" THEN RETURN "0". 
        WHEN "B" THEN RETURN "1". 
        WHEN "C" THEN RETURN "2". 
        WHEN "D" THEN RETURN "3". 
        WHEN "E" THEN RETURN "4". 
        WHEN "F" THEN RETURN "5". 
        WHEN "G" THEN RETURN "6". 
        WHEN "H" THEN RETURN "7". 
        WHEN "I" THEN RETURN "8". 
        WHEN "J" THEN RETURN "9". 
        OTHERWISE RETURN "X".
    END CASE.    
END FUNCTION.    

/* Counter Convert Function End*/

psid = trim ( userid(sdbname(1)) ).

    /* Register License Code */
    /* Get Company Information Start */
/*tx01*  find ls_mstr where ls_addr = "~reports" and ls_type = "company" no-lock no-error. */

/*tx01*/ find first ls_mstr where ls_type = "company" and ls_domain = "011"
/*tx01*/    and substring(ls_addr,2,7) = "reports" no-lock no-error.
    
       if available ls_mstr then do:
/*tx01* find ad_mstr where ad_addr = ls_addr no-lock no-error. */

/*tx01*/ find first ad_mstr where ad_domain = "011"
/*tx01*/    and substring(ad_addr,2,7) = "reports" no-lock no-error.
       
       if available ad_mstr then temp =  trim (ad_name).
       else do :
	  display "Err: Missing ~reports in ad_mstr!".
	  quit.
       end.
    end.
    temp1 = temp.
    temp = temp + "@".

    /* Get Company Information End */

    /* Get OS Database Information Start */
    temp = temp + trim ( opsys )  + "@" .
    temp = temp + trim ( dbtype(1) ) + "@".
    temp = temp + trim ( dbversion(1) ).
    /* Get OS Database Information End */

   /* Register Clicense Code  Start*/	 
    find first usrw_wkfl where usrw_key1 = "BARCODE" and usrw_key2 = "LICENSEKEY" 
               and encode ( trim(temp) ) =  substring(usrw_charfld[1],1,1) +  
	                                    substring(usrw_charfld[1],3,14)  + 
					    substring(usrw_charfld[1],18,1)
               and usrw_domain = "011" no-lock no-error.
    if available usrw_wkfl then do:
       counter = getcounter ( substring(usrw_charfld[1],2,1) ) +  getcounter ( substring(usrw_charfld[1],17,1) ).
    end.
    else do:
       REPEAT:
	  display skip (16) "**REGISTER**"				at 48 no-label skip
			    "  CO:" + temp1 	    format "x(32)"   		at 48 no-label skip
			    "  OS:" + trim ( opsys )  format "x(28)"      	at 48 no-label skip
			    "Type:" + trim ( dbtype(1) ) + trim ( dbversion(1) )  format "x(28)" at 48 no-label skip
		  	    with fram registerf no-box .
                           
			    update license1 at 48 no-label license2 no-label license3 no-label with fram  registerf.
			    license = license1 + license2 + license3.

			    if not ( substring(license,1,1) +  substring(license,3,14)  +
			             substring(license,18,1) = encode (temp) ) then do:
			       display skip "Invalid License Code! "  NO-LABEL with frame registerf.
			       pause 0 before-hide.
                               undo, retry.

			    end.
                            if substring(license,2,1) < "A" or  substring(license,2,1) > "J" or substring(license,17,1) < "A" or substring(license,17,1) > "J" then do:
			       display skip "Invalid License Code! "  NO-LABEL with frame registerf.
			       pause 0 before-hide.
                               undo, retry.
			       
			    end.
/*			    
			    license = substring(license,1,1) + getcounter(substring(license,2,1) ) +  substring(license,3,14)  + getcounter(substring(license,17,1) ) + substring(license,18,1).                            
*/
                            find first usrw_wkfl where usrw_key1 = "BARCODE" and usrw_key2 = "LICENSEKEY" 
			        and usrw_domain = "011" no-error .
			    if not available usrw_wkfl then do:
			       create usrw_wkfl .
			       assign  usrw_key1 = "BARCODE"
			               usrw_key2 = "LICENSEKEY"
				       usrw_charfld[1] = license.
				       usrw_domain = "011".
			    end.
                            else usrw_charfld[1] = license.

          quit.
      END.

    end.

    
    /* License session Checking Start */

    def variable summaryusr as char format "x(300)" init "xxyyxx".
    def variable command    as char format "x(300)" init "xxyyxx".
    def variable loginuser  as integer init 0.
    def variable ts9130     as char format "x(200)" init "".
    
    for each code_mstr where code_fldname = "BARCODEUSERID"  and code_domain = "011" no-lock :
        summaryusr = summaryusr + "|" + trim ( code_value ).
    end.

    /**************Add by Sam Song ***2006/5/22    START********************/
     rs = "".
     aa = "".
     DO i = 1 to length(summaryusr).
	      
	    IF substring(summaryusr,i,1) <> "|" THEN
	       aa = aa + substring(summaryusr,i,1) .
	    ELSE do:
		
		rs = rs +  trim ( aa ) + fill(" ",12 - length( aa )) + "p|" .
		aa = "".

	    END.
    END.
    summaryusr = rs + aa + fill(" ",12 - length( aa )) + "p" .
    /**************Add by Sam Song ***2006/5/22    END********************/
   
    usection = TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY))) +              
               trim(STRING(TIME)) + trim(string(RANDOM(1,100))).
    command  = "who -u |grep -E " + """" + trim ( summaryusr ) + """" + " > " + usection + ".tmp".

    unix silent value (command).

    PROCEDURE addcounter.   
       input from value (usection + ".tmp").
        Do While True:
            IMPORT UNFORMATTED ts9130.
	    loginuser = loginuser + 1.
        end.
	input close.
    END PROCEDURE.   
    run addcounter.

    if loginuser > integer ( counter ) then do:     
	command = "cat " + usection + ".tmp".
	unix value (command).
	quit.
    end.
    /* License session  Checking End */

    /* Register Clicense Code  End*/	 
     /*
     find first usr_mstr where usr_userid = psid and usr_restrict no-lock no-error .
     if not available usr_mstr   then do:
	display skip "ノめ/盞絏Τ粇"  NO-LABEL with frame loginf no-box no-labels .
	pause 2. 
	quit.
     end.
     */

     if index(summaryusr,psid) = 0 then do:
        display skip(16)
	             "**BARCODE ERROR**"	at 60 no-label skip
	             "  *INPUT USER INFO* "	at 60 no-label skip
		     "MENU:(.36.2.13)"		at 60 no-label skip
		     "Field=BARCODEUSERID"  at 60 no-label skip
		     "Value=< OS USER ID >"	at 60 no-label skip
		      "#BATCH INPUT " + """" +  "|" + """"  format "x(20)" at 60  no-label skip 
	              with frame loginerrorf no-box no-labels .
	pause 20. 
	quit.
     end.
     

     /*  Using US User to Update MFG/PRO START START  ## 2006 Feb 22 ##  */
     for last usr_mstr no-lock where usr_userid <> ""  and usr_lang = "ch"
       , each usrl_det no-lock where usrl_userid = usr_userid and usrl_active = yes 
          and usrl_product = "MFG/PRO" :
         psid = usr_userid.
     end.

     for last mon_mstr no-lock 
       , each usr_mstr no-lock where mon_userid = usr_userid and usr_lang = "ch" 
       , each usrl_det no-lock where usrl_userid = mon_userid and usrl_active = yes 
          and usrl_product = "MFG/PRO" by mon_sid:
         psid = mon_userid.
     end.

     /*  Using US User to Update MFG/PRO START  END ## 2006 Feb 22 ## */
     do transaction on error undo:

         for each usr_mstr no-lock where usr_userid = psid  :
                  oldpasswd = usr_passwd .
	       /*    usr_passwd = encode ( substring( encode ( psid + "011" ),1,8) ). */
         end.
	
	 find first usr_mstr where usr_userid = psid  no-lock no-error.
         if available usr_mstr   then do: 
         
		  usection = TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + 
		             trim(STRING(TIME)) + trim(string(RANDOM(1,100))).

		  output to value( trim(usection) + ".i") .
		   /*  display  """" + trim(psid) + """"  + " " + """" + substring( encode ( psid + "011" ) ,1,8) + """" format "X(50)" skip  
		  */
/*tx01* commentted		
		       display  """" + "bcpd" + """"  + " " + """" + "bcpd" + """"  +  " " +  """" + "01" + """"format "X(50)" skip

			   "." skip
			   "P" skip             
		     with fram finput no-box no-labels width 200.
commentted tx01*/
/*start tx01*/
                  PUT UNFORMATTED 
		      "bcpd" space		
		      "bcpd" space skip
		      "011" space skip
		      skip
      	              "." skip
		      "P" skip
		      skip.
/*end tx01*/
		  output close.
		 /* hide all. */
/*commentted by tommy
                  display skip (15) "** BARCODE SYSTEM **" at 60 no-label skip
		                    "    Copyright By"     at 60 no-label skip
			            "   SOFTSPEED Inc."    at 60 no-label skip
			            "all Rights reserved"  at 60 no-label skip
			            "*Lic: " + string ( loginuser ) + "/" + trim(counter) + " USER(S)*" format "x(20)" at 60 no-label skip(1)
			            "ANY KEY TO CONTINUE"  at 60 no-label skip 

			  with fram copyrightf no-box no-labels width 200.

                  pause 10 before-hide.
commentted by tommy */
/*mage  del  		  for each mnd_det where mnd_nbr ="" and mnd_select = 1 :
		      oldmnd_canrun = mnd_canrun.
		      mnd_canrun = mnd_canrun + "," + trim ( psid ) .
		  end.  */
/*mage  chg*/   for first mnd_det where mnd_nbr ="" and mnd_select = 1 :
		      oldmnd_canrun = mnd_canrun.
		      mnd_canrun = mnd_canrun + "," + trim ( psid ) .
		  end. 
		  release  mnd_det .
		  input from value ( usection + ".i") .
		  output to  value ( usection + ".o") . 

		  run mf.p. 

		  input close.
		  output close.		  

 /*mage del     		  for each mnd_det where mnd_nbr ="" and mnd_select = 1 :
		      mnd_canrun = oldmnd_canrun.
		  end. */
            
 /*mage chg */    for first mnd_det where mnd_nbr ="" and mnd_select = 1 :
		      mnd_canrun = oldmnd_canrun.
		  end.  
		  release mnd_det .
/*mage add*/      loop1 = loop1 + 1.
             unix silent value ("rm -f " + trim(usection) + ".*").
 
/*mage add*/  if loop1 >= 5  then  do: message "程序进入死循环,将退出!"  view-as alert-box .  quit.  end.
	     end.
	/*  for each usr_mstr where usr_userid = psid :
	    usr_passwd = oldpasswd.  
	 end. */
/*mage add*/  if loop1 >= 5  then  do: message "程序进入死循环,将退出!"  view-as alert-box .  quit.  end.
      end.
      run xsmain.p.
      quit.
