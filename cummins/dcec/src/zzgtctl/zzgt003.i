/*zzgt003.i - get usrw_wkfl to variable*/

      v_gtaxid    = usrw_key2.
      v_companyid = usrw_key4.
      
      v_userstr = usrw_charfld[1].
      
      v_p01 = trim(substring(usrw_charfld[2],1,8)).
      v_p02 = trim(substring(usrw_charfld[2],9,8)).
      v_p03 = trim(substring(usrw_charfld[2],17,8)).
      
      v_outtaxin = if substring(usrw_charfld[3],1,1) = "Y" then yes else no.
      v_intaxin  = if substring(usrw_charfld[3],2,1) = "Y" then yes else no.
      v_infixrd  = if substring(usrw_charfld[3],3,1) = "Y" then yes else no.
      v_inpost   = if substring(usrw_charfld[3],4,1) = "Y" then yes else no.
      
      v_sitestr  = usrw_charfld[4].
      
      v_itemgtax = trim(substring(usrw_charfld[5],1,8)).
      v_itemkind = trim(substring(usrw_charfld[5],11,8)).

      v_name_def[1]  = trim(substring(usrw_charfld[6],1,12)).
      v_name_date[1] = date((integer(substring(usrw_charfld[6],25,2))),
                            (integer(substring(usrw_charfld[6],27,2))),
                            (integer(substring(usrw_charfld[6],21,4)))) no-error.
      v_name_seq[1]  = integer(substring(usrw_charfld[6],31,6)). 

      v_name_def[2] = trim(substring(usrw_charfld[7],1,12)).
      v_name_date[2] = date((integer(substring(usrw_charfld[7],25,2))),
                            (integer(substring(usrw_charfld[7],27,2))),
                            (integer(substring(usrw_charfld[7],21,4)))) no-error.
      v_name_seq[2]  = integer(substring(usrw_charfld[7],31,6)). 
      
      v_gtax_ip = trim(substring(usrw_charfld[9],1,20)).
      v_gtax_id = trim(substring(usrw_charfld[9],21,20)).
      v_gtax_pw = trim(substring(usrw_charfld[9],41,20)).
      v_gtax_inbox = trim(substring(usrw_charfld[9],61,60)).
      v_gtax_otbox = trim(substring(usrw_charfld[9],121,60)).
      
      v_box[1] = trim(substring(usrw_charfld[10],1,60)).
      v_box[2] = trim(substring(usrw_charfld[10],61,60)).
      v_box[3] = trim(substring(usrw_charfld[10],121,60)).
      v_box[4] = trim(substring(usrw_charfld[10],181,60)).
      v_box[5] = trim(substring(usrw_charfld[10],241,60)).
      v_max_amt = usrw_decfld[3].
      v_drange = usrw_decfld[1].
			gdinvmaxamt = usrw_decfld[3].