/*define   variable age_amt like ar_amt extent 6.
define   variable age_tmp like ar_amt extent 6 .
define  variable agebe_amt like ar_amt extent 6 .
define  variable agebc_amt like ar_amt extent 6 .
define  variable agetot_amt like ar_amt extent 6 .
define shared variable be_amt like ar_amt label "Beer Amt.".
define shared variable bc_amt like ar_amt label "B&C Amt.".
  */
  agebe_amt[6] = xxa_ar_amt - agebe_amt[1] - agebe_amt[2]
     - agebe_amt[3] - agebe_amt[4] - agebe_amt[5] .
     if agebe_amt[1] < 0 then do:
     agebe_amt[6] =  agebe_amt[6] + agebe_amt[1] .
     agebe_amt[1] = 0.
     end.
      if agebe_amt[2] < 0 then do:
        agebe_amt[6] =  agebe_amt[6] + agebe_amt[2] .
        agebe_amt[2] = 0.
         end.
        if agebe_amt[3] < 0 then do:
       agebe_amt[6] =  agebe_amt[6] + agebe_amt[3] .
       agebe_amt[3] = 0.
       end.                              
        if agebe_amt[4] < 0       
       then do:
       agebe_amt[6] =  agebe_amt[6] + agebe_amt[4] .
       agebe_amt[4] = 0.
       end.
        if agebe_amt[5] < 0
       then do:
       agebe_amt[6] =  agebe_amt[6] + agebe_amt[5] .
       agebe_amt[5] = 0.
       end.
if (agebe_amt[6] < 0) and
    (agebe_amt[5] <> 0 or agebe_amt[4] <> 0 or agebe_amt[3] <> 0 
    or agebe_amt[2] <> 0 or agebe_amt[1] <> 0)
then do:    /*1*/
age_tmp[5] = agebe_amt[6] + agebe_amt[5] .
agebe_amt[6] = 0 .
if (age_tmp[5] < 0) and
   (agebe_amt[4] <> 0 or agebe_amt[3] <> 0 or agebe_amt[2] <> 0 
   or agebe_amt[1] <> 0)
  then do:       /*2*/
  age_tmp[4] = age_tmp[5] + agebe_amt[4] .
  agebe_amt[5] = 0 .
  if (age_tmp[4] < 0) and (agebe_amt[3] <> 0 or agebe_amt[2] <> 0
   or agebe_amt[1] <> 0) 
    then do:     /*3*/
    age_tmp[3] = age_tmp[4] + agebe_amt[3] .
    agebe_amt[4] = 0.
    if age_tmp[3] < 0 and (agebe_amt[2] <> 0 or agebe_amt[1] <> 0)
    then do:     /*4*/
            age_tmp[2] = age_tmp[3] + agebe_amt[2] .
            agebe_amt[3] = 0.
            if age_tmp[2] < 0 and (agebe_amt[1] <> 0)                                        then do :  /*5*/
                 age_tmp[1] = age_tmp[2] + agebe_amt[1] .
                 agebe_amt[2] = 0.
                 agebe_amt[1] = age_tmp[1] .
                 end.
            else agebe_amt[2] = age_tmp[2] .
         end.
     else agebe_amt[3] = age_tmp[3] .
    end.
    else agebe_amt[4] = age_tmp[4] .
  end.
  else agebe_amt[5] = age_tmp[5] .
end.
