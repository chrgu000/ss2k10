/*REVISION: 9.0 LAST MODIFIED: 11/14/13 BY: jordan Lin *SS-20131114.1*/

{mfdtitle.i "test.1"}

define variable pklnbr  like xxpklm_nbr.
define variable pklnbr1 like xxpklm_nbr.
define variable date    as date.
define variable date1   as date.
define variable wkctr   like xxpklm_wkctr.
define variable wkctr1  like xxpklm_wkctr.

DEFINE TEMP-TABLE temp1
   FIELD temp_part like pt_part
   FIELD temp_desc1 like pt_desc1
   FIELD temp_qty_req like xxpkld_qty_req
   FIELD temp_qty_iss like xxpkld_qty_iss
   FIELD temp_qty_tmp like xxpkld_qty_iss
   FIELD temp_desc2 like pt_desc2
   INDEX temp_xindex
      IS PRIMARY temp_part  .

form
   pklnbr    colon 20
   pklnbr1 label "To"   colon 49  skip
   date    colon 20 date1   label "To" colon 49 skip
   wkctr   colon 20 wkctr1  label "To" colon 49 skip
   skip(1)
with frame a side-labels width 80 attr-space.

form
      xxpkld_wkctr      label "W/C"
      xxpkld_part     label "Item Number"
      xxpkld_desc      label "Description"
      xxpkld_loc_to        label "Location"
      xxpkld_max      label "Max"
      xxpkld_qty_req      label "ROP/Size"
      xxpkld_loc_from  label "Location"
      xxpkld_locator  label "Locatior"
      xxpkld_ROP  label "Qty On Hand"
      xxpkld_qty_iss  label "Issue"

with frame b1 width 136 no-attr-space no-box down .

form
      xxpkld_wkctr      label "W/C"
      xxpkld_part     label "Item Number"
      xxpkld_desc     format "x(8)" column-label "Desc"
      xxpkld_c        format "x(1)" column-label "C"
      xxpkld_line_stk label "Line Stk"
      xxpkld_locator    label "Locatior"
      xxpkld_loc_from        label "Location"
      xxpkld_main_stk label "Main Stk"
      xxpkld_qty_req  label "Request Qty"
      xxpkld_qty_iss  label "Issue Qty"
      xxpkld_qty_tmp  label "Return Qty"
      xxpkld_qty_rej  label "Variance"
with frame b2 width 128 no-attr-space no-box down .

form
      xxpkld_wkctr      label "W/C"
      xxpklm_wkctr     label "W/C"
      xxpkld_part     label "Item Number"
      xxpkld_desc     format "x(24)" column-label "Desc"
      xxpkld_line_stk label "Line Stk"
      xxpkld_locator    label "Locatior"
      xxpkld_loc_from        label "Location"
      xxpkld_main_stk label "Main Stk"
      xxpkld_qty_req  label "Request Qty"
      xxpkld_qty_iss  label "Issue Qty"
with frame b3 width 128 no-attr-space no-box down .

/*日期限制*/
 {xxcmfun.i}
 run verfiydata(input today,input date(3,5,2014),input yes,input "softspeed201403",input vchk5,input 140.31).

repeat with frame a:

   if pklnbr1 = hi_char
   then
      pklnbr1 = "".
   if wkctr1 = hi_char
   then
      wkctr1 = "".
   if date = low_date
   then
      date = ?.
   if date1 = hi_date
   then
      date1 = ?.

      update
         pklnbr
         pklnbr1
         date
         date1
         wkctr wkctr1
      with frame a.

      if pklnbr1 = ""
      then
         pklnbr1 = hi_char.
      if wkctr1 = ""
      then
         wkctr1 = hi_char.

      if date = ?
      then
         date = low_date.
      if date1 = ?
      then
         date1 = hi_date.


      {mfselbpr.i "printer" 128}
   {mfphead.i}
   for each xxpklm_mstr where xxpklm_nbr >= pklnbr and xxpklm_nbr <= pklnbr1
                         and xxpklm_date >= date and xxpklm_date <= date1
       and xxpklm_wkctr >= wkctr and xxpklm_wkctr <= wkctr1
                         and trim(xxpklm_status) = "" no-lock,
       each xxpkld_det where xxpkld_nbr = xxpklm_nbr  no-lock
        BREAK by xxpklm_type by  xxpklm_nbr by xxpkld_line  :
       if first-of(xxpklm_nbr) then do:
/*
      hide frame b1 no-pause.
      hide frame b2 no-pause.
      hide frame b3 no-pause.
*/
           if xxpklm_type = 11 or xxpklm_type = 12 then do:
                     put UNFORMATTED  "PICKING LIST: " xxpklm_nbr skip.
  /*  view frame b1.     */
     end.
           if xxpklm_type = 13 then do:
      put "   Line: " + xxpklm_prod_line    format "x(40)" skip.
      put "    W/C: " + xxpklm_wkctr    format "x(40)" skip.
      put "Sch_Qty: " + string(xxpklm_sch_qty, ">>>>>>>9") format "x(40)" skip.
      put " Parent: " + xxpklm_Par   format "x(40)" skip.
      put " PICKING LIST: " + xxpklm_nbr   format "x(40)" skip.

         /*    view frame b2.  */


     end.
           if xxpklm_type = 3 then do:
         put "Line: " + xxpklm_prod_line + "   领料单: " + xxpklm_nbr  format "x(80)" skip.
         /*  view frame b3.   */
     end.

       end. /*  if first-of(xxpklm_nbr) then do: */

       if xxpklm_type >= 11 and xxpklm_type <= 13  then do :
            disp xxpkld_wkctr    label "W/C"
                 xxpkld_part     label "Item Number"
                 xxpkld_desc     label "Description"
                 xxpkld_loc_to   label "Location"
                 xxpkld_max      label "Max"
                 xxpkld_ROP      label "ROP/Size"
                 xxpkld_loc_from label "Location"
                 xxpkld_locator  label "Locatior"
                 xxpkld_qty_req  label "Qty On Hand"
                 " " @ xxpkld_qty_iss  label "Issue"
    with frame b1 .
  down with frame b1 .
       end.  /*  if xxpklm_type = 1 then do : */


       if xxpklm_type = 2 then do :
            disp
    xxpkld_wkctr      label "W/C"
    xxpkld_part     label "Item Number"
    xxpkld_desc     format "x(8)" column-label "Desc"
    xxpkld_c        format "x(1)" column-label "C"
    xxpkld_line_stk label "Line Stk"
    xxpkld_locator    label "Locatior"
    xxpkld_loc_from        label "Location"
    xxpkld_main_stk label "Main Stk"
    xxpkld_qty_req  label "Request Qty"
    " " @ xxpkld_qty_iss  label "Issue Qty"
    " " @ xxpkld_qty_tmp  label "Return Qty"
    " " @ xxpkld_qty_rej  label "Variance"
    with frame b2 .
  down with frame b2 .
       end.  /*  if xxpklm_type = 2 then do : */


       if xxpklm_type = 3 then do :
            disp
    xxpkld_line      label "seq"
    xxpkld_part     label "Item Number"
    xxpkld_desc     format "x(24)" column-label "Desc"
    xxpkld_line_stk label "Line Stk"
    xxpkld_locator    label "Locatior"
    xxpkld_loc_from        label "Location"
    xxpkld_main_stk label "Main Stk"
    xxpkld_qty_req  label "Request Qty"
    " " @ xxpkld_qty_iss  label "Issue Qty"
    with frame b3  .
  down with frame b3 .
       end.  /*  if xxpklm_type = 3 then do : */

      put fill("-", 128) format "x(128)" skip.

  if page-size - line-counter < 2 then  do:
    page.

           if xxpklm_type = 1 then do:
                put UNFORMATTED  "PICKING LIST: " xxpklm_nbr skip.
     end.
           if xxpklm_type = 2 then do:
      put "   Line: " + xxpklm_prod_line    format "x(40)" skip.
      put "    W/C: " + xxpklm_wkctr    format "x(40)" skip.
      put "Sch_Qty: " + string(xxpklm_sch_qty, ">>>>>>>9") format "x(40)" skip.
      put " Parent: " + xxpklm_Par   format "x(40)" skip.
      put " PICKING LIST: " + xxpklm_nbr   format "x(40)" skip.
     end.
           if xxpklm_type = 3 then do:
         put "Line: " + xxpklm_prod_line + "   领料单: " + xxpklm_nbr  format "x(80)" skip.
     end.
        end. /* if page-size - line-counter < 2  */


       if last-of(xxpklm_nbr) then do:
           page.

       end. /*  if last-of(xxpklm_nbr) then do: */

    {mfrpchk.i}
  end. /* for each xxpklm_nbr */

   /* REPORT TRAILER  */
   {mfrtrail.i}

end.