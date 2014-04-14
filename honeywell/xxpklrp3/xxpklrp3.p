/*REVISION: 9.0       LAST MODIFIED: 11/14/13    BY: jordan Lin *SS-20131114.1*/

 {mfdtitle.i "test.1"}

define variable date          as date.
define variable date1         as date.

define variable isum          as int .
define variable seq           as int .
define variable lack          as int .

DEFINE TEMP-TABLE temp1
   FIELD temp_part like pt_part
   FIELD temp_desc1 like pt_desc1
   FIELD temp_qty_req like xxpkld_qty_req
   FIELD temp_qty_iss like xxpkld_qty_iss
   FIELD temp_qty_tmp like xxpkld_qty_iss
   FIELD temp_desc2 like pt_desc2
   INDEX temp_xindex IS PRIMARY temp_part.

form
   date colon 20 date1   label "To"   colon 49 skip
  skip(1)
with frame a side-labels width 80 attr-space.
date = today.
date1 = today.
/*日期限制*/
 {xxcmfun.i}
 run verfiydata(input today,input date(3,5,2014),input yes,input "softspeed201403",input vchk5,input 140.31).

repeat with frame a:

   if date = low_date then date = ?.
   if date1 = hi_date then date1 = ?.
      update date date1 with frame a.

      if date = ? then date = low_date.
      if date1 = ? then date1 = hi_date.
    {mfselbpr.i "printer" 134}
    {mfphead.i}
   /* FIND AND DISPLAY */

isum  = 0.
lack = 0.

   for each xxpklm_mstr where xxpklm_date >= date and xxpklm_date <= date1
                         and trim(xxpklm_status) = "" no-lock,
       each xxpkld_det where xxpkld_nbr = xxpklm_nbr  no-lock :
       isum = isum + 1.
       if xxpkld_qty_iss < xxpkld_qty_req then lack = lack + 1.
  end. /* for each xxpklm_nbr */

    put UNFORMATTED  string(date, "99/99/99") "到" string(date1, "99/99/99")
                     " 总共" isum  "项,欠料" lack "项,齐套率"
                     string (((isum - lack) / isum) * 100,">99.99%") .

      {mfrpchk.i}

   /* REPORT TRAILER  */
   {mfrtrail.i}
end. /* REPEAT: */




