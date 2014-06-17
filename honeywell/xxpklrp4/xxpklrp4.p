/*REVISION: 9.0       LAST MODIFIED: 09/25/13      BY: Jordan Lin *SS-20130925.1*/

 {mfdtitle.i "140530.1"}

define variable pklnbr         like xxpklm_nbr.
define variable pklnbr1        like xxpklm_nbr.
define variable date          as date.
define variable date1         as date.
define variable wkctr         like xxpklm_wkctr.
define variable wkctr1        like xxpklm_wkctr.


DEFINE TEMP-TABLE temp1
   FIELD temp_part like pt_part
   FIELD temp_desc1 like pt_desc1
   FIELD temp_qty_req like xxpkld_qty_req
   FIELD temp_qty_iss like xxpkld_qty_iss
   FIELD temp_qty_tmp like xxpkld_qty_iss
   FIELD temp_desc2 like pt_desc2
   INDEX temp_xindex
      IS PRIMARY
       temp_part  .

form
   pklnbr    colon 20
   pklnbr1 label "To"   colon 49  skip
   date    colon 20 date1   label "To"   colon 49 skip
   wkctr     colon 20 wkctr1    label "To"   colon 49 skip
     skip(1)

with frame a side-labels width 80 attr-space.

form
      temp_part      label "物料号"
      temp_desc1     label "描述"
      temp_qty_req      label "需求量"
      temp_qty_iss        label "已发数量"
      temp_qty_tmp      label "缺料量"

with frame b width 134 no-attr-space no-box down .

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
      {mfselbpr.i "printer" 134}
   {mfphead.i}
   /* FIND AND DISPLAY */
   for each xxpklm_mstr where xxpklm_nbr >= pklnbr and xxpklm_nbr <= pklnbr1
                         and xxpklm_date >= date and xxpklm_date <= date1
       and xxpklm_wkctr >= wkctr and xxpklm_wkctr <= wkctr1
                         and trim(xxpklm_status) = "" no-lock,
       each xxpkld_det where xxpkld_nbr = xxpklm_nbr and xxpkld_qty_iss < xxpkld_qty_req no-lock :
       find temp1 where temp_part = xxpkld_part no-error.
       if not avail temp1 then do :
           create temp1 .
     temp_part = xxpkld_part .
     temp_desc1 = xxpkld_desc .
       end. /*  if not avail temp1 */
       temp_qty_req = temp_qty_req + xxpkld_qty_req .
       temp_qty_iss = temp_qty_iss + xxpkld_qty_iss .

  end. /* for each xxpklm_nbr */

    for each temp1 no-lock :
    temp_qty_tmp = temp_qty_req - temp_qty_iss.
        display temp_part
    temp_desc1
    temp_qty_req
    temp_qty_iss
    temp_qty_tmp
        with frame b  .
  down 1  with frame b  .

      {mfrpchk.i}

    end.

   /* REPORT TRAILER  */
   {mfrtrail.i}
end. /* REPEAT: */

