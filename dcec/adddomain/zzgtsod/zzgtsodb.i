/* zzgtsodb.i - create export txt file  */

/*LAST MODIFIED  2004-08-30 11:17 *LB01* longbo            */

/*LB01 TABLE HEADER*/


/* define variable v_sum  like cst_tl. */
define variable v_sum as decimal.

find first code_mstr no-lock where code_domain = global_domain and 
					 code_fldname = "zz-gt-ctrl"
and code_value = "header" no-error.

if available code_mstr then 
	put stream soivdat code_cmmt.
else
	put stream soivdat "SJJK0101~~~~销售单据传入".

find first code_mstr no-lock where code_domain = global_domain and 
					 code_fldname = "zz-gt-ctrl"
and code_value = "line header" no-error.

if available code_mstr then 
	sLnHeaderDesc = code_cmmt.
else
	sLnHeaderDesc = "单据".

/*  TABBLE HEADER END */

iCount = 0.

for each wkgtm 
    where wkgtm_status = ""
    and   wkgtm_line   > 0
    and   wkgtm_totamt <> 0
    :

  /*line header */
  iCount = iCount + 1.
  put stream soivdat skip(1)
     "//" + sLnHeaderDesc + string(iCount) + ":" format "x(20)" skip.

   strOutMstr = wkgtm_ref +   "~~~~"  + 
				string(wkgtm_line)  +   "~~~~"  + 
				wkgtm_name  +   "~~~~" + 
				wkgtm_taxid +   "~~~~" + 
				wkgtm_addr  +   "~~~~" + 
				wkgtm_bkacct +  "~~~~" + 
				wkgtm_rmks  +   "~~~~" + 
				v_p02      +    "~~~~" + 
				v_p03.         
  put stream soivdat UNFORMATTED strOutMstr skip.

	
  for each wkgtd 
      where wkgtd_ref = wkgtm_ref
      and   wkgtd_status = ""
      by wkgtd_line:

          v_sum = round(((wkgtd_totamt - wkgtd_discamt) / wkgtd_qty),9).
         
		strOutDet =  wkgtd_item  +  "~~~~" +
        wkgtd_um   +   "~~~~" +
        wkgtd_spec  +  "~~~~" +
        string(wkgtd_qty)  +   "~~~~" +
		trim(string((v_sum * wkgtd_qty),"->>>>>>>>>>>>9.99")) + "~~~~" +   /*不含税金额*/
        trim(string(wkgtd_taxpct,">>>9.99")) +   "~~~~" +
        wkgtd_kind  +     "~~~~" +
/*lb01*/ " ~~"		+		/*折扣金额*/
 		 "~~ ~~"	+			/*税额*/
 		 "~~ ~~"		+		/*折扣税额*/
 		 "~~ ~~"		+		/*折扣率*/
 	         "~~" + trim(string(v_sum ,"->>>>>>>>>>>>9.99"))			/*单价huangjie2007529*/ 
 		.
 /*	if v_outtaxin then
 		strOutDet = strOutDet + 
 		"~~1"
		.
 	else 
 		strOutDet = strOutDet + 
 		"~~0"
		.   huangjie2007529*/

	put stream soivdat UNFORMATTED strOutDet skip.
  end.

  find first so_mstr 
       where so_domain = global_domain and so_nbr = substring(wkgtm_ref,4,8) 
       exclusive-lock no-error.
  if available so_mstr then do: 
    so_to_inv = no.
  /*  so_user1  = "D" + substring(wkgtm_ref,3)). lb01*/
    so_inv_date = inv_date.
  end.
end.

	
	
