define variable psid   like pt_part.
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
define variable pdomain like ls_domain.
define variable pOnlyOneDomain as logical init no.
Define variable wDomain  like ls_domain . /* temp Variable */
/* Counter Convert Function Start*/
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

psid = trim ( userid(sdbname(2)) ).

find first code_mstr where code_fldname = "BARCODEDEFDOMAIN" and code_value = "*" 
and code_domain = "PDC"
no-lock no-error .
if available code_mstr then pdomain = code_cmmt.

find first code_mstr where code_fldname = "BARCODEDEFDOMAIN" and code_value = trim ( psid ) 
and code_domain = "PDC"
no-lock no-error .
if available code_mstr then pdomain = trim ( code_cmmt )  .

if pdomain = "" then do:

   display "Err:Def Domain!".
   pause .
   quit.
end.    

    /* Register License Code */
    /* Get Company Information Start */
    find first ls_mstr where ls_addr = "~~reports" and ls_type = "company" 
    and ls_domain = "PDC"
    no-lock no-error.
    if available ls_mstr then do:
       find first ad_mstr where ad_addr = ls_addr and ad_domain=ls_domain 
       and ad_domain = "PDC"
       no-lock no-error.
       if available ad_mstr then temp =  trim (ad_name).
       else do :
	  display "Err: Missing ~reports in ad_mstr SYSTEM DOMAIN!".
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
    /*
    output to "/app/bc/tmp.txt".
    put unformat temp1 skip.
    put unformat temp skip.
    output close.
*/
    find first usrw_wkfl where usrw_key1 = "BARCODE" and usrw_key2 = "LICENSEKEY" 
               and encode ( trim(temp) ) =  substring(usrw_charfld[1],1,1) +  substring(usrw_charfld[1],3,14)  + substring(usrw_charfld[1],18,1)
	       and usrw_domain = "PDC"
	       no-lock no-error.
    if available usrw_wkfl then do:
       counter = getcounter ( substring(usrw_charfld[1],2,1) ) +  getcounter ( substring(usrw_charfld[1],17,1) ).
    end.
    else do:
      REPEAT:

	  display skip (16) "**BARCODE SIGNED**"				at 48 no-label skip
			    "  CO:" + temp1 	    format "x(32)"   		at 48 no-label skip
			    " SYS:" + trim ( opsys )  format "x(28)"      	at 48 no-label skip
			    "TYPE:" + trim ( dbtype(1) ) + trim ( dbversion(1) )  format "x(28)" at 48 no-label skip
		  	    with fram registerf no-box .
                           
			    update license1 at 48 no-label license2 no-label license3 no-label with fram  registerf.
			    license = license1 + license2 + license3.
			    if not ( substring(license,1,1) +  substring(license,3,14)  + substring(license,18,1) = encode (temp) ) then do:
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
			    	       and usrw_domain = "PDC"
                            no-error .
			    if not available usrw_wkfl then do:
			       find first dom_mstr where  dom_domain = "PDC" and dom_active = yes no-lock no-error.
			       create usrw_wkfl .
			       assign  usrw_domain = dom_domain
			               usrw_key1 = "BARCODE"
			               usrw_key2 = "LICENSEKEY"
				       usrw_charfld[1] = license.
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
    
    for each code_mstr where code_fldname = "BARCODEUSERID" 
    and code_domain = "PDC"
    no-lock :
        summaryusr = summaryusr + "|" + trim ( code_value ).
    end.
    
    usection = TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))).
    command  = "who -u |egrep -si " + """" + trim ( summaryusr ) + """" + " > " + usection + ".tmp".
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
	display skip "用戶/密碼有誤"  NO-LABEL with frame loginf no-box no-labels .
	pause 2. 
	quit.
     end.
     */
     
    
     if index(summaryusr,psid) = 0 then do:
        display skip(16)
	             "*BARCODE USER ERROR*" at 60 no-label skip
	             "* SETUP USER INFOR * "  at 60 no-label skip
		     "MFG/PRO :(.36.2.13)"  at 60 no-label skip
		     "Field=BARCODEUSERID"  at 60 no-label skip
		     "Value=< OS USER ID >"  at 60 no-label skip
		     "#成批用戶用 " + """" +  "|" + """" + " 隔開#" format "x(20)" at 60 no-label skip
	              with frame loginerrorf no-box no-labels .
	pause 20. 
	quit.
     end.

     /* Get Fixed User Name */
     psid = "zzzzzzzz".
     find first usr_mstr where usr_userid = "zzzzzzzz"  no-lock no-error.
     if NOT available usr_mstr then do:
        display "Err:Setup Barcode User zzzzzzzz".
        quit.
     end.
     
     /*  Only One Domain in MFG/PRO  Start */
     pOnlyOneDomain = no.
     wDomain = "".
     find first udd_det where udd_userid = usr_userid  no-lock no-error.
     if available udd_det then wDomain = udd_domain.
     find last udd_det where udd_userid = usr_userid  no-lock no-error.
     if available udd_det then do:
        if udd_domain = wDomain and wDomain <> "" then pOnlyOneDomain = yes.
     end.
     /*  Only One Domain in MFG/PRO  Start */


     
     do transaction on error undo:

         for each usr_mstr where usr_userid = psid  :
                  oldpasswd = usr_passwd .
	          usr_passwd = encode ( substring( encode ( psid + "99" ),1,8) ).
         end.

	 find first usr_mstr where usr_userid = psid  no-lock .
         if available usr_mstr   then do: 
         
		  usection = TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))).
		  output to value( trim(usection) + ".i") .
		  /* display  """" + trim(psid) + """"  + " " + """" + substring( encode ( psid + "99" ) ,1,8) + """" format "X(50)" skip
			   if pOnlyOneDomain = no then pDomain skip
			   "." skip
			   "P" skip             
		     with fram finput no-box no-labels width 200.  */
		     
		     put """" + trim(psid) + """"  + " " + """" + substring( encode ( psid + "99" ) ,1,8) + """" format "X(50)" skip .
	             if pOnlyOneDomain = no then do :
		        put pDomain skip .
		     end.
	 	     put  "." skip .
		     put  "P" skip  .           
		  
		  output close.
		 /* hide all. */
                  display skip (15) "** BARCODE SYSTEM **" at 60 no-label skip
		                    "    Copyright By"     at 60 no-label skip
			            "   SOFTSPEED Inc."    at 60 no-label skip
			            "all Rights reserved"  at 60 no-label skip
			            "*Lic: " + string ( loginuser ) + "/" + trim(counter) + " USER(S)*" format "x(20)" at 60 no-label skip(1)
			            "ANY KEY TO CONTINUE"  at 60 no-label skip 

			  with fram copyrightf no-box no-labels width 200.

                  pause 10 before-hide.

    		  for each mnd_det where mnd_nbr ="" and mnd_select = 1 :
		      oldmnd_canrun = mnd_canrun.
		      mnd_canrun = mnd_canrun + "," + trim ( psid ) .
		  end.



		  input from value ( usection + ".i") .
		  output to  value ( usection + ".o") . 
		  run mf.p.
		  input close.
		  output close.

      		  for each mnd_det where mnd_nbr ="" and mnd_select = 1 :
		      mnd_canrun = oldmnd_canrun.
		  end.
            
         
               /* unix silent value ("rm -f " + trim(usection) + ".*").
               */
         end.

	 for each usr_mstr where usr_userid = psid :
	     usr_passwd = oldpasswd. 
	 end.
      end.
  
      run xsmain.p.
      quit.
 