
      /*NO TRANSACTION SHOULD BE PENDING HERE*/
      {gprun.i ""gpistran.p""
                "(input 1,
                  input """")"}
      
      trans_type = "DOWNTIME".

      if act_setup_hrs20 <> 0 then do:	 
         {gprun.i ""xxreophist.p""
                   "(input trans_type,
                     input cumwo_lot, 
	             input op, 
		     input emp,
                     input wkctr, 
		     input mch, 
		     input dept, 
		     input shift,
                     input eff_date,
		     input down_rsn_code,
                     output ophist_recid)"}

/*minth*/    {gprun.i ""redta.p"" 
                      "(input cumwo_lot, 
	                input op,
                        input wkctr, 
			input mch, 
			input dept, 
			input act_setup_hrs20,
                        input eff_date,
                        input earn_code, 
			input down_rsn_code, 
			input emp, 
                        input ophist_recid)"}  
      end. /* ELSE IF conv_qty_scrap */
