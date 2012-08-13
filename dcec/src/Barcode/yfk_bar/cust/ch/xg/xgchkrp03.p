/* xgchkrp03.p                                     */
/* create by: hou     2006.03.06                   */  

function gettime return integer
   (input s_time  as char).
   return integer(substr(s_time,1,index(s_time,":") - 1)) * 3600
          + integer(substr(s_time,index(s_time,":") + 1)) * 60.
end function.


{mfdtitle.i "ao "}

define query    qry_xw for xwo_srt,xwck_mstr.

define variable v_line        like  xwck_lnr.
define variable v_lot         like  xwck_lot.
define variable v_lot1        like  xwck_lot.
define variable v_chk_date    like  xwck_date.
define variable v_chk_date1   like  xwck_date.
define variable v_chk_time    as    char format "x(5)" label "审核时间".
define variable v_chk_time1   like  v_chk_time.
define variable v_xwo_date    like  xwo_date label "提交日期".
define variable v_xwo_date1   like  xwo_date.
define variable v_xwo_time    as    char format "x(5)" label "提交时间".
define variable v_xwo_time1   like  v_xwo_time.
define variable v_shp_date    like  xwck_shp_date.
define variable v_shp_date1   like  xwck_shp_date.
define variable v_part        like  xwck_part.
define variable v_part1       like  xwck_part.

define variable v_chk_tm      like  xwck_time.
define variable v_chk_tm1     like  xwck_time.
define variable v_xwo_tm      like  xwo_time.
define variable v_xwo_tm1     like  xwo_time.
define variable v_stat        like  xwck_stat.
define variable v_type        like  xwck_type.

define variable v_xwck_pallet     like xwck_pallet  .
define variable v_xwck_shipper    like xwck_shipper .
define variable v_xwck_stat       like xwck_stat    .
define variable v_xwck_type       like xwck_type    .
define variable v_xwck_blkflh     like xwck_blkflh  .
define variable v_xwck_date       like xwck_date    .
define variable v_xwck_time       as   char format "x(5)" label "审核时间" .
define variable v_xwck_shp_date   like xwck_shp_date.
define variable v_chk_only        as   logical label "只显示未审核".

{xkutlib.i}


form
    v_line        colon 20
    v_lot         colon 20
    v_lot1        label {t001.i} colon 49 skip
    v_part        colon 20
    v_part1       label {t001.i} colon 49 skip
    v_chk_date    colon 20
    v_chk_date1   label {t001.i} colon 49
    v_chk_time    colon 20
    v_chk_time1   label {t001.i} colon 49
    v_xwo_date    colon 20
    v_xwo_date1   label {t001.i} colon 49
    v_xwo_time    colon 20
    v_xwo_time1   label {t001.i} colon 49
    v_stat        colon 20
    v_type        colon 49
    v_chk_only    colon 20
    skip(1)
with frame a side-labels width 80 attr-space.

repeat:
   
   if v_part1 = hi_char then v_part1 = "".
   if v_lot1 = hi_char then v_lot1 = "".
   if v_chk_date = low_date then v_chk_date = ?.
   if v_chk_date1 = hi_date then v_chk_date1 = ?.
   if v_xwo_date = low_date then v_xwo_date = ?.
   if v_xwo_date1 = hi_date then v_xwo_date1 = ?.

   update v_line v_lot v_lot1 v_part v_part1 
          v_chk_date v_chk_date1 v_chk_time v_chk_time1 
          v_xwo_date v_xwo_date1 v_xwo_time v_xwo_time1
          v_stat v_type v_chk_only
   with frame a.

   if (v_chk_time <> "" and not IsCorrectTime(v_chk_time)) or
      (v_chk_time1 <> "" and not IsCorrectTime(v_chk_time1)) or
      (v_xwo_time <> "" and not IsCorrectTime(v_xwo_time)) or
      (v_xwo_time1 <> "" and not IsCorrectTime(v_xwo_time1))
   then do:
      message "请输入正确的时间"view-as alert-box error.
      undo , retry .
   end.
        
   
   {mfquoter.i v_line}
   {mfquoter.i v_lot}
   {mfquoter.i v_lot1}
   {mfquoter.i v_part}
   {mfquoter.i v_part1}
   {mfquoter.i v_chk_date}
   {mfquoter.i v_chk_date1}
   {mfquoter.i v_chk_time}
   {mfquoter.i v_chk_time1}
   {mfquoter.i v_xwo_date}
   {mfquoter.i v_xwo_date1}
   {mfquoter.i v_xwo_time}
   {mfquoter.i v_xwo_time1}
   {mfquoter.i v_stat}
   {mfquoter.i v_type}

   
   if v_part1 = ""  then v_part1 = hi_char .
   if v_lot1  = ""  then v_lot1  = hi_char .
   if v_chk_date = ? then v_chk_date = low_date.
   if v_xwo_date = ? then v_xwo_date = low_date.
   if v_chk_date1  = ?  then v_chk_date1  = hi_date .
   if v_xwo_date1  = ?  then v_xwo_date1  = hi_date .
   
   v_chk_tm = gettime(v_chk_time).
   v_chk_tm1 = gettime(v_chk_time1).
   v_xwo_tm = gettime(v_xwo_time).
   v_xwo_tm1 = gettime(v_xwo_time1).
         
   if v_chk_tm1 = 0 then v_chk_tm1 = 86400.
   if v_xwo_tm1 = 0 then v_xwo_tm1 = 86400.
   
   {mfselbpr.i "terminal" 132}
   {mfphead.i}

   for each xwo_srt no-lock where (xwo_lnr = v_line or v_line = "")
      and xwo_part >= v_part and xwo_part <= v_part1
      and xwo_lot >= v_lot and xwo_lot <= v_lot1
      and (xwo_date > v_xwo_date or 
           xwo_date = v_xwo_date and xwo_time >= v_xwo_tm)
      and (xwo_date < v_xwo_date1 or 
           xwo_date = v_xwo_date1 and xwo_time <= v_xwo_tm1)
      break by xwo_lot:
      
      IF v_chk_only AND xwo_wolot <> '' THEN NEXT.

      if first-of(xwo_lot) then do with frame b width 180 down:
         find first xwck_mstr where xwck_lnr = xwo_lnr
         and xwck_part = xwo_part and xwck_lot = xwo_lot
         and (xwck_date > v_chk_date or 
              xwck_date = v_chk_date and xwck_time >= v_chk_tm)
         and (xwck_date < v_chk_date1 or 
              xwck_date = v_chk_date1 and xwck_time <= v_chk_tm1)
         and (xwck_type = v_type or v_type = "")
         and (xwck_stat = v_stat or v_stat = "") no-lock no-error.
         
         if avail xwck_mstr and v_chk_only then do:
            if xwck_date <> ? then next.
         end.
         
         if avail xwck_mstr then do:
            v_xwck_pallet     = xwck_pallet  . 
            v_xwck_shipper    = xwck_shipper . 
            v_xwck_stat       = xwck_stat    . 
            v_xwck_type       = xwck_type    . 
            v_xwck_blkflh     = xwck_blkflh  . 
            v_xwck_date       = xwck_date    . 
            v_xwck_time       = string(xwck_time,"HH:MM:SS") . 
            v_xwck_shp_date   = xwck_shp_date. 
         end.
         else do:
            v_xwck_pallet     = ""  . 
            v_xwck_shipper    = "" . 
            v_xwck_stat       = ""    . 
            v_xwck_type       = ""    . 
            v_xwck_blkflh     = no  . 
            v_xwck_date       = ?    . 
            v_xwck_time       = ""    . 
            v_xwck_shp_date   = ?. 
         end.
         
         display 
            xwo_lnr
            xwo_part
            xwo_date      column-label "提交日期"
            string(xwo_time,"HH:MM:SS") column-label "提交时间"
            xwo_lot
            xwo_type COLUMN-LABEL "类型"
            xwo_qty_lot
            v_xwck_pallet
            v_xwck_shipper
            v_xwck_stat
            v_xwck_type
            v_xwck_blkflh
            v_xwck_date     
            v_xwck_time
            v_xwck_shp_date column-label "发运日期" .
                         
            {mfrpexit.i}
         
      end.
      
   end.
   
   {mfrtrail.i}

end.
