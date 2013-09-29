/* xxpimacr.p - 盘点原表                      */
/* $Revision: eb2sp4  $BY: Cosesa Yang         DATE: 09/27/13  ECO: *SS - 20130927.1* */

{mfdtitle.i "130927.1"}

DEF VAR lins   AS INT FORMAT ">9".
DEF VAR loc1   AS CHAR.
DEF VAR loc2   AS CHAR.
DEF VAR eff    as char.
def var str_dt as char.
define variable v_site           like si_site.
define variable v_site1          like si_site .
define variable v_loc            like loc_loc.
define variable v_loc1           like loc_loc .
define variable v_line           like pl_prod_line.
define variable v_line1          like pl_prod_line .
define variable v_part           like pt_part.
define variable v_part1          like pt_part .
define variable v_abc            like pt_abc.
define variable v_abc1           like pt_abc  .
define variable v_incl_zero      like mfc_logical init yes.
define variable v_incl_negative  like mfc_logical init yes.
define variable v_sortoption     as integer initial 2.
define variable tnbr          like tag_nbr init 0.
define variable bcode         as char .

form
    v_loc      colon 15  label "库位"
    v_loc1     colon 49  label "至"
    skip
with frame a side-labels attr-space width 80 .

/* REPORT BLOCK */
{wbrp01.i}

mainloop:
REPEAT:
     IF v_loc1 = hi_char THEN v_loc1 = "".
     IF v_site1 = hi_char THEN v_site1 = "".
     IF v_line1 = hi_char THEN v_line1 = "".
     IF v_part1 = hi_char THEN v_part1 = "".
     IF v_abc1 = hi_char THEN v_abc1 = "".

     update
      v_loc
      v_loc1
      with frame a.

      {wbrp06.i &command = update &fields = "
         v_loc v_loc1
       " &frm = "a"}

       assign bcdparm = "".
        {mfquoter.i v_loc       }
        {mfquoter.i v_loc1      }

      IF v_loc1 = ""    THEN v_loc1 = "ZZZZZZZZ".
      IF v_site1 = ""    THEN v_site1 = hi_char.
      IF v_line1 = ""    THEN v_line1 = hi_char.
      IF v_part1 = ""    THEN v_part1 = hi_char .
      IF v_abc1 = ""    THEN v_abc1 = hi_char .
      lins = 0.
      v_incl_zero = yes .
      v_incl_negative = yes .
      v_sortoption = 2.

      {mfselbpr.i "printer" 132}

      find last tag_mstr where tag_nbr >= 0 no-lock no-error.
      if available tag_mstr and tag_nbr < 99999999 then
         assign tnbr = tag_nbr + 1.
   /*
      {gprun.i ""xxpiptcr.p"" "(
         INPUT v_site  ,
         INPUT v_site1 ,
         INPUT v_loc   ,
         INPUT v_loc1  ,
         INPUT v_line  ,
         INPUT v_line1 ,
         INPUT v_part  ,
         INPUT v_part1 ,
         INPUT v_abc   ,
         INPUT v_abc1  ,
         INPUT v_incl_zero ,
         INPUT v_incl_negative ,
         INPUT v_sortoption  )"}
   */
      PUT UNFORMATTED "#def REPORTPATH=$/库存/实际盘点/xxpimacr" SKIP.
      PUT UNFORMATTED "#def :end" SKIP.
      str_dt = "日期:" + substring(string(year(today)),3) + "年" + string(month(today),"99") + "月" .

         for each tag_mstr exclusive-lock where /* tag_nbr >= tnbr and */
                  tag_loc >= v_loc
              and tag_loc <= v_loc1
              and tag_type = "I"
              and not tag_posted
              and not tag_void
            break by tag_nbr by tag_site by tag_loc by tag_part:
         lins = lins + 1 .
   if lins > 15 then lins = 1.

   find first in_mstr where in_part = tag_part and in_site = tag_site no-lock no-error.
   find first pt_mstr where pt_part = tag_part no-lock no-error.

      PUT UNFORMATTED str_dt ";" .
      put lins format ">>>,>>9" ";" tag_loc format "x(8)" ";" .
      if avail in_mstr then put in_abc format "x(2)" ";" .
      else put UNFORMATTED  " ;" .

      bcode = "000000" + trim(string(tag_nbr)).
/*
      if tag_nbr < 10 then bcode = "00000" + bcode.
      else
      if tag_nbr >= 10 and tag_nbr < 100 then bcode = "0000" + bcode.
      else
      if tag_nbr >= 100 and tag_nbr < 1000 then bcode = "000" + bcode.
      else
      if tag_nbr >= 1000 and tag_nbr < 10000 then bcode = "00" + bcode.
      else
      if tag_nbr >= 10000 and tag_nbr < 100000 then bcode = "0" + bcode.
*/
      bcode = substring(trim(bcode),length(trim(bcode)) - 5).
      PUT UNFORMATTED tag_part ";" tag_nbr ";" "*" + bcode + "*" ";" .
      if avail pt_mstr then put pt_desc1 format "x(24)" ";" .
      else put UNFORMATTED " ;".
      put UNFORMATTED  "; ; ; ; ; " skip.

      tag_prt_dt = today.

   end. /*for each tag_mstr*/
   {a6mfrtrail.i}
END.
{wbrp04.i &frame-spec = a}