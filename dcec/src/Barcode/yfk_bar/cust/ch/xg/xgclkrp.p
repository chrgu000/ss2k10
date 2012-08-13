/* xgclkrp.p                                     */
/* create by: Xiang     2006.03.27                   */  

function gettime return integer
   (input s_time  as char).
   return integer(substr(s_time,1,index(s_time,":") - 1)) * 3600
          + integer(substr(s_time,index(s_time,":") + 1)) * 60.
end function.


{mfdtitle.i "ao "}


define variable v_line        like  xwo_lnr.
define variable v_xwoo_date    like  xwoo_date label "提交日期".
define variable v_xwoo_date1   like  xwoo_date.
define variable v_xwoo_time    as    char format "x(5)" label "提交时间".
define variable v_xwoo_time1   like  v_xwoo_time.
define variable v_part        like  xwck_part.
define variable v_part1       like  xwck_part.
define variable v_xwoo_tm      like  xwoo_time.
define variable v_xwoo_tm1     like  xwoo_time.

{xkutlib.i}


form
    v_line        colon 20
    v_part        colon 20
    v_part1       label {t001.i} colon 49 skip
    v_xwoo_date    colon 20
    v_xwoo_date1   label {t001.i} colon 49
    v_xwoo_time    colon 20
    v_xwoo_time1   label {t001.i} colon 49
    skip(1)
with frame a side-labels width 80 attr-space.

repeat:
   
   if v_part1 = hi_char then v_part1 = "".
   if v_xwoo_date = low_date then v_xwoo_date = ?.
   if v_xwoo_date1 = hi_date then v_xwoo_date1 = ?.

   update v_line v_part v_part1 
          v_xwoo_date v_xwoo_date1 v_xwoo_time v_xwoo_time1
   with frame a.

   if 
      (v_xwoo_time <> "" and not IsCorrectTime(v_xwoo_time)) or
      (v_xwoo_time1 <> "" and not IsCorrectTime(v_xwoo_time1))
   then do:
      message "请输入正确的时间"view-as alert-box error.
      undo , retry .
   end.
        
   
   {mfquoter.i v_line}
   {mfquoter.i v_part}
   {mfquoter.i v_part1}
   {mfquoter.i v_xwoo_date}
   {mfquoter.i v_xwoo_date1}
   {mfquoter.i v_xwoo_time}
   {mfquoter.i v_xwoo_time1}
   
   if v_part1 = ""  then v_part1 = hi_char .
   if v_xwoo_date = ? then v_xwoo_date = low_date.
   if v_xwoo_date1  = ?  then v_xwoo_date1  = hi_date .
   v_xwoo_tm = gettime(v_xwoo_time).
   v_xwoo_tm1 = gettime(v_xwoo_time1).
   if v_xwoo_tm1 = 0 then v_xwoo_tm1 = 86400.
   
   {mfselbpr.i "terminal" 160}
   {mfphead.i}

   for each xwoo_srt no-lock where (xwoo_lnr = v_line or v_line = "")
      and xwoo_part >= v_part and xwoo_part <= v_part1
      and (xwoo_date > v_xwoo_date or 
           xwoo_date = v_xwoo_date and xwoo_time >= v_xwoo_tm)
      and (xwoo_date < v_xwoo_date1 or 
           xwoo_date = v_xwoo_date1 and xwoo_time <= v_xwoo_tm1)
      :
         
         display 
            xwoo_lnr
            xwoo_part
            xwoo_date      column-label "提交日期"
            string(xwoo_time,"HH:MM:SS") column-label "提交时间"
            xwoo_lot
            xwoo_qty_lot WITH WIDTH 160.
                         
      {mfrpexit.i}      
   end.
   
   {mfrtrail.i}

end.
