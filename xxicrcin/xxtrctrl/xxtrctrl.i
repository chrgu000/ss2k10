/* xxtrctrl.i - xxtrctrl.i 库存转移控制                                      */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 26Y1 LAST MODIFIED: 5/31/12 BY: zy                              */
/* REVISION END                                                              */
define buffer xxship for xxship_det.
PROCEDURE getItemTrLoc:
/* -----------------------------------------------------------
   Purpose: 查找物料可用定制库位
   Parameters:
   Notes:
 -------------------------------------------------------------*/
    define input parameter iPart like pt_part.
    define input parameter iqty  like ld_qty_oh.
    define output parameter oLocList as character.

    define variable site as character initial "gsa01".
    define variable vlocList as character.         
    define variable vLoc as character.
    define variable vqty like ld_qty_oh.

    assign vlocList = "".

    for each xxpl_ref no-lock where xxpl_part = iPart,
        each loc_mstr no-lock where loc_site = xxpl_site and
             loc_loc = xxpl_loc by xxpl_rank:
        if xxpl_type = "Y" then do: /*按托放,只要有物料则不允许入库*/
           find first ld_det no-lock where ld_site = xxpl_site
                  and ld_loc = xxpl_loc and ld_qty_oh > 0 no-error.
           if not available ld_det then do:
              if vlocList = "" then assign vlocList = xxpl_loc.
                               else assign vlocList = vlocList + ";" + xxpl_loc.
           end.
        end. /* if xxpl_type = "Y" then do: */
        else do: /*按容量放可入容量大于入库量则可以入库*/
            find first ld_det no-lock where ld_site = xxpl_site
                   and ld_loc = xxpl_loc and ld_part <> xxpl_part
                   and ld_qty_oh > 0 no-error.
            if available ld_det then do:
                   next.
            end.
            assign vqty = 0.
            for each ld_det no-lock where ld_site = xxpl_site
                 and ld_loc = xxpl_loc and ld_part = xxpl_part:
                 assign vqty = vqty + ld_qty_oh.
            end.
            if (xxpl_cap > 0 and xxpl_cap - vqty >= iqty)
          /* or xxpl_cap = 0  */
            then do:
              if vlocList = "" then assign vlocList = xxpl_loc.
                               else assign vlocList = vlocList + ";" + xxpl_loc.
            end.
        end. /*if xxpl_type = "Y" else do: */
    end. /* for each xxpl_ref  */
    /*周转库位*/
    /*周转库位只有库存没有物料才允许入库*/
    for each usrw_wkfl no-lock where usrw_key1 = "TRANSLATE-LOCATION" and
             usrw_key3 = "20",
        each loc_mstr no-lock where loc_site = usrw_key6 and
             loc_loc = usrw_key2 by usrw_key4:
         find first ld_det no-lock where ld_site = usrw_key6
                and ld_loc = usrw_key2 and ld_qty_oh > 0 no-error.
         if not available ld_det then do:
            if vlocList = "" then assign vlocList = usrw_key2.
                             else assign vlocList = vlocList + ";" + usrw_key2.
         end.
   end. /*for each usrw_wkfl*/

  /*过道*/
   find first pt_mstr no-lock where pt_part = iPart no-error.
   if available pt_mstr then do:
   	   if index(pt_buyer,"4RSA") > 0 then do:  
   	   		assign vLoc = "P-4RSA".
       end.
       else do:
       		assign vLoc = "P-4RPS".       
       end.       
       find first loc_mstr no-lock where loc_site = pt_site
              and loc_loc = vLoc no-error.
       if available loc_mstr then do:
       	  if vLocList = "" then assign VlocList = loc_loc.
                           else assign vLocList = vLocList + ";" + loc_loc.
       end. 
   end.
   assign oLocList = vLocList.
END PROCEDURE. /* PROCEDURE getItemTrLoc*/

PROCEDURE getInvTrLoc:
/* -----------------------------------------------------------
   Purpose:
   Parameters:  <none>
   Notes:
 -------------------------------------------------------------*/
  define input parameter iInvNbr as character.
  define input parameter iCase   as integer.
  define output parameter oLocList as character.
  define variable vLocList as character.
  define variable vList as character.
  define variable vList1 as character.
  define variable vLoc   as character.
  define variable vCnt as integer.
  assign vLocList = "".
  for each usrw_wkfl no-lock where usrw_key1 = "TRANSLATE-LOCATION" and
           (usrw_key3 = "10" or usrw_key3 = "20"),
      each loc_mstr no-lock where loc_site = usrw_key6 and
           loc_loc = usrw_key2 break by usrw_key3 by usrw_key4:
       find first ld_det no-lock where ld_site = usrw_key6
              and ld_loc = usrw_key2 and ld_qty_oh > 0 no-error.
       if not available ld_det then do:
          if vlocList = "" then assign vlocList = usrw_key2.
                           else assign vlocList = vlocList + ";" + usrw_key2.
       end.
 end. /*for each usrw_wkfl*/

  assign vList = "".
  for each xxship no-lock where xxship.xxship_nbr = iInvNbr and
           xxship.xxship_case = iCase,
      each pt_mstr no-lock where pt_part = xxship.xxship_part2 break by pt_buyer:
      accum pt_part (count by pt_buyer) .
      if last-of(pt_buyer) then do:
          if vList = "" then do:
             assign Vlist =  pt_buyer + ":"
                          + string( accum count by pt_buyer pt_part).
          end.
          else do:
              assign vList = vList + ";" + pt_buyer + ":"
                           + string( accum count by pt_buyer pt_part).
          end.
      end.
 end. /* for each xxship_det */

 assign vCnt = 0.
 assign vList1 = vList.
 do while vList1 <> "":
   if integer(entry(2,entry(1,vList1,";"),":")) > vCnt then do:
      assign vCnt = integer(entry(2,entry(1,vList1,";"),":")).
      assign vLoc = entry(1,entry(1,vList1,";"),":").
   end.
   if index(vList1,";") > 0 then
       assign vList1 = substring(vList1,index(vList1,";") + 1).
   else
       assign vList1 = "".
 end.
 if index(vLoc,"4RSA") > 0 then do:
 		assign vList1 = "P-4RSA".
 end.
 Else do:
 		assign vList1 = "P-4RPS".
 end.
 find first loc_mstr no-lock where loc_site = "GSA01"
        and loc_loc = vList1 no-error.
 if available loc_mstr then do:
 		if vLocList = "" then assign VlocList = loc_loc.
                     else assign vLocList = vLocList + ";" + loc_loc.
 end. 
 assign oLocList = vLocList.
END PROCEDURE. /* PROCEDURE getInvLocList*/
