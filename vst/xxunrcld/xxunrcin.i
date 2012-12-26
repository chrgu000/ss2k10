define variable txt as character.
empty temp-table tmpic no-error.
defin variable i as integer.
input from value(flhload).
i = 0.
repeat:
    import unformat txt.
    if i <> 0 then do:
    	 create tmpic.
    	 assign tic_site = entry(1,txt,",")
    	 			  tic_effdate = date(entry(2,txt,","))
    	        tic_nbr = entry(3,txt,",")
    	        tic_loc = entry(4,txt,",")
    	        tic_part = entry(5,txt,",")
    	        tic_qty = dec(entry(6,txt,","))
    	        tic_acct  = entry(7,txt,",")
    	        tic_sub  = entry(8,txt,",")
    	        tic_cc  = entry(9,txt,",") no-error.
    	 assign tic_proj  = entry(10,txt,",") no-error.
    	 if tic_effdate = ? then tic_effdate = today.
    end.
    i = i + 1.
end.
input close.

i = 1.
for each tmpic exclusive-lock :
      if tic_part <= "" or tic_part >= "ZZZZZZZZ" then do:
         delete tmpic.
      end.
      else do:
         assign tic_sn = i
         				tic_chk = "".
      end.
     i = i + 1.
end.
