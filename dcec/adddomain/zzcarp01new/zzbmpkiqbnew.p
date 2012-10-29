/* $Revision:eb21sp12  $ BY: Jordan Lin            DATE: 09/19/12  ECO: *SS-20120919.1*   */

        {mfdeclre.i}
        DEFINE INPUT PARAMETER part LIKE ps_par .
        DEFINE INPUT PARAMETER site1 LIKE si_site .
        DEFINE INPUT PARAMETER eff_date1 LIKE ps_start .
        DEFINE INPUT PARAMETER date1 LIKE ps_start .
        DEFINE new shared VARIABLE comp LIKE ps_comp .
        DEFINE VARIABLE LAST_part LIKE ps_par .
        DEFINE VARIABLE op LIKE ps_op .
        define variable qty like pk_qty initial 1 .
        DEFINE VARIABLE  disp_pkqty LIKE ps_qty_per .
        DEFINE new shared  variable site LIKE si_site no-undo .
        define shared variable errmsg as integer .
        define new shared  variable eff_date as date .
        define new shared  variable date2 as date .
        define shared variable transtype as character format "x(4)".
         def variable pkqty1 like ps_qty_per .
         define variable oldpart like ps_par .
        {gpxpld01.i "new shared"}
        op = 0 .
        site = site1 .
        eff_date = eff_date1 .
        date2 = date1.
        define  shared workfile pkdet no-undo
        field pkpart like ps_comp
        field pkop as integer
                          format ">>>>>9"
        field pkstart like pk_start
        field pkend like pk_end
        field pkqty like pk_qty
        field pkbombatch like bom_batch
        field pkltoff like ps_lt_off
        field pkdate1 like pk_start.
        /*****tfq exploded to not phontom item**************/
        define temp-table xxtmp1_wkfl 
                    field xxtmp1_par like ps_par
                    field xxtmp1_comp like ps_comp 
                    field xxtmp1_qty_per like ps_qty_per
                    field xxtmp1_site like si_site 
                    field xxtmp1_start like pk_start
                    field xxtmp1_end   like pk_end
                    field xxtmp1_bombatch like bom_batch
                    field xxtmp1_op as integer
                          format ">>>>>9"
                    field xxtmp1_ltoff like ps_lt_off
                    field xxtmp1_date1 LIKE pk_start.
            define temp-table xxtmp2_wkfl 
                    field xxtmp2_par like ps_par
                    field xxtmp2_comp like ps_comp 
                    field xxtmp2_qty_per like ps_qty_per
                    field xxtmp2_site like si_site
                    field xxtmp2_date1 like ps_start .
         oldpart = part .           
    repeat:                 
        comp = part.
/*G234*/    /* Added section*/
        find ptp_det no-lock where ptp_det.ptp_domain = global_domain and ptp_part = part
        and ptp_site = site no-error.
        if available ptp_det then do:
/*J020*/       if index("1234",ptp_joint_type) > 0 then do:
                  errmsg = 6519 .
   
/*J020*/       end.
           if ptp_bom_code > "" then comp = ptp_bom_code.
        end.
        else
/*G265*/    if available pt_mstr then
        do:
/*J020*/       if index("1234",pt_joint_type) > 0 then do:
                    errmsg = 6519 .
                
/*J020*/       end.
           if pt_bom_code > "" then comp = pt_bom_code.
        end.
/*G234*/    /* End of added section*/
        /* explode part by standard picklist logic */
      
        
  
         {gprun.i ""zzwoworla2new.p""}
 

/*G1H5** /*H100*/    if op = 999 then op = 0. **/

        for each pkdet
        where eff_date = ? or (eff_date <> ?
        and (pkstart = ? or pkstart <= eff_date)
/*H100*/    and (pkend = ? or eff_date <= pkend)
/*H100*/    and ((op = pkop) or (op = 0)))
        break by pkpart
/*G1JF*/          by pkop :
                pkqty1 = pkqty * qty .
       
           find pt_mstr where pt_mstr.pt_domain = global_domain and pt_part = pkpart no-lock no-error.
/*G1JF*/       accumulate pkqty1 (total by pkop).

/*G1JF*/       if last-of(pkop) then do:
/*N0F3*/          disp_pkqty = accum total by pkop pkqty1.
                  pkqty = disp_pkqty .

           end.
           else do :
           delete pkdet .
           end.
           
        end.
        for each pkdet
        where eff_date = ? or (eff_date <> ?
        and (pkstart = ? or pkstart <= eff_date)
/*H100*/    and (pkend = ? or eff_date <= pkend)
/*H100*/    and ((op = pkop) or (op = 0))) :
        find first ptp_det where ptp_det.ptp_domain = global_domain and ptp_part = pkpart and ptp_site = site no-lock no-error .
        if available ptp_det then
        do:
                if ptp_pm_code <> "P" then
                do:
                find first ps_mstr where ps_par = pkpart no-lock no-error .
                if available ps_mstr then do:
                create xxtmp2_wkfl .
                assign xxtmp2_par = part
                 xxtmp2_comp = pkpart 
                 xxtmp2_qty_per = pkqty
                 xxtmp2_site = site
                 xxtmp2_date1 = date2.
                   end .
                   else do:
                   create xxtmp1_wkfl .
               assign  xxtmp1_par = oldpart
                 xxtmp1_comp = pkpart 
                 xxtmp1_qty_per = pkqty
                 xxtmp1_site = site
                 xxtmp1_start = pkstart
                 xxtmp1_end = pkend
                 xxtmp1_ltoff = pkltoff
                 xxtmp1_op = pkop
                 xxtmp1_bombatch = pkbombatch
                 xxtmp1_date1 =date2.

                   end. 
                end.
                else do:
                create xxtmp1_wkfl .
               assign  xxtmp1_par = oldpart
                 xxtmp1_comp = pkpart 
                 xxtmp1_qty_per = pkqty
                 xxtmp1_site = site
                 xxtmp1_start = pkstart
                 xxtmp1_end = pkend
                 xxtmp1_ltoff = pkltoff
                 xxtmp1_op = pkop
                 xxtmp1_bombatch = pkbombatch
                 xxtmp1_date1 =date2.
                end.
                delete pkdet .
        end. /*available ptp_det*/
        else do:
        find first pt_mstr where pt_part = pkpart no-lock no-error .
        if available pt_mstr then
        do:
        if pt_pm_code <> "P" then
                do:
                find first ps_mstr where ps_par = pkpart no-lock no-error .
                if available ps_mstr then do:
                   create xxtmp2_wkfl .
                assign xxtmp2_par = part
                 xxtmp2_comp = pkpart 
                 xxtmp2_qty_per = pkqty
                 xxtmp2_site = site
                 xxtmp2_date1 = date2.
                 end.
                 else do:
                create xxtmp1_wkfl .
               assign  xxtmp1_par = oldpart
                 xxtmp1_comp = pkpart 
                 xxtmp1_qty_per = pkqty
                 xxtmp1_site = site
                 xxtmp1_start = pkstart
                 xxtmp1_end = pkend
                 xxtmp1_ltoff = pkltoff
                 xxtmp1_op = pkop
                 xxtmp1_bombatch = pkbombatch
                 xxtmp1_date1 =date2.

                    end.
                 end.
                else do:
                 create xxtmp1_wkfl .
               assign  xxtmp1_par = oldpart
                 xxtmp1_comp = pkpart 
                 xxtmp1_qty_per = pkqty
                 xxtmp1_site = site
                 xxtmp1_start = pkstart
                 xxtmp1_end = pkend
                 xxtmp1_ltoff = pkltoff
                 xxtmp1_op = pkop
                 xxtmp1_bombatch = pkbombatch
                 xxtmp1_date1 =date2.
                end.
                delete pkdet .
        end.   /*available pt_mstr*/
        end.  /*not available ptp_det*/
        end.  /*for each pkdet*/
        find next xxtmp2_wkfl no-error .
        if available xxtmp2_wkfl 
        then do:
         part = xxtmp2_comp .
         qty = xxtmp2_qty_per .
         delete xxtmp2_wkfl .
         end .
         else leave .
                                    
  end.   /*repeat*/ 
  for each pkdet :
  delete pkdet .
  end.   
for each xxtmp1_wkfl :
create pkdet .
assign pkpart = xxtmp1_comp
       pkqty  = xxtmp1_qty_per 
         pkstart =      xxtmp1_start  
         pkend =        xxtmp1_end 
         pkltoff =      xxtmp1_ltoff 
         pkop =         xxtmp1_op 
         pkbombatch =   xxtmp1_bombatch 
         pkdate1 = xxtmp1_date1.
       delete xxtmp1_wkfl .
       end.
       
