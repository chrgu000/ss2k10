define input parameter  v_part  like pc_part .
define input parameter  v_um    like pc_um .
/*define input parameter v_effdate as date .*/
define output parameter vender  like pc_list .
define output parameter v_curr  like pc_curr .
define output parameter v_price like pc_amt[1] .

define var price like pc_amt[1] .
define var price1 like pc_amt[1] .



vender = "" .
v_curr = "RMB" .
price1 = 999. 
price  = 999 .
v_price = 999.
for each pc_mstr use-index pc_part 
	where pc_part = v_part 
	and pc_um = v_um
	and (pc_start <= today) 
	and (pc_expire > today  or pc_expire = ?) 
	no-lock break by pc_part by pc_list by pc_start:
	if last-of(pc_list) then do:

		/*      convert to RMB_price    */ 
		if pc_curr = "RMB" then do:
			  assign  price = pc_amt[1]  .
		end.
		else do:
                            /*               find exr_rate where exr_curr1 = "rmb"                                             */
                            /*                             and exr_curr2 = pc_curr                                             */
                            /*                             and ( exr_start_date <= pc_start and exr_end_date >= pc_start )     */
                            /*                             no-lock no-error.                                                   */
                            /*               if avail exr_rate then do :                                                       */
                            /*                    assign price = ( pc_amt[1] * exr_rate / exr_rate2).                          */
                            /*               end.                                                                              */
                            /*               else do:  /*a*/                                                                   */
                            /*                    find exr_rate where exr_curr2 = "rmb"                                        */
                            /*                                 and exr_curr1 = pc_curr                                         */
                            /*                                 and ( exr_start_date <= pc_start and exr_end_date >= pc_start ) */
                            /*                                 no-lock no-error.                                               */
                            /*                    if avail exr_rate then do :                                                  */
                            /*                           assign price = ( pc_amt[1] * exr_rate2 / exr_rate).                   */
                            /*                    end.                                                                         */
                            /*                    else do: /*b*/                                                               */
                  find exr_rate where exr_curr1 = "rmb" 
                                and exr_curr2 = pc_curr 
                                and ( exr_start_date <= today and exr_end_date >= today )  
                                no-lock no-error.
                  if avail exr_rate then do :
                       assign price = ( pc_amt[1] * exr_rate / exr_rate2).
                  end.
                  else do:	/*c*/ 
                       find exr_rate where exr_curr2 = "rmb" 
                                    and exr_curr1 = pc_curr 
                                    and ( exr_start_date <= today and exr_end_date >= today )  
                                    no-lock no-error.
                       if avail exr_rate then do :
                              assign price = ( pc_amt[1] * exr_rate2 / exr_rate).
                       end.
                       else do:
                             price = 999.
                       end.
                  end.	/*c*/   
                            /*                    end. /*b*/ */
                            /*               end.  /*a*/     */
		end.
		/*      convert to RMB_price    */  

		if price < price1 then do:
			 price1  = price .

			 vender  = pc_list . 
			 v_price = pc_amt[1] .
			 v_curr  = Pc_curr .
		end.
	end.                                 
end. /*for each pc_mstr*/
