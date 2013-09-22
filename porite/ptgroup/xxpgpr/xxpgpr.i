procedure getlikeStat:
   /* -----------------------------------------------------------
      相似组判断
      Parameters:ipart1 料号1
                 ipart2 料号2
                 idate  日期(通常为today)
                 oret   返回yes 是相似组, no 不是相似组
    -------------------------------------------------------------*/

  define input parameter ipart1 like pt_part.
  define input parameter ipart2 like pt_part.
  define input parameter idate  as   date.
  define output parameter oret   like mfc_logical.

  DEFINE VARIABLE i AS INTEGER.
  define variable grp as character.
  define variable vret like mfc_logical.

  assign grp = "".
  for each xpgt_det use-index xpgt_part_group no-lock
     where xpgt_domain = global_domain and xpgt_part = ipart1
       and (xpgt_start <= idate or idate = ?)
       and (xpgt_end >= idate or idate = ?):
     if grp = "" then do:
        assign grp = xpgt_group.
     end.
     else do:
        assign grp = grp + ";" + xpgt_group.
     end.
  end.
  assign vret = no.
  repeat i = 1 to NUM-ENTRIES(grp, ";"):
      find first xpgt_det no-lock where xpgt_domain = global_domain
             and xpgt_group = entry(i,grp) and xpgt_part = ipart2 
             and (xpgt_start <= idate or idate = ?)
             and (xpgt_end >= idate or idate = ?) no-error.
      if available xpgt_det then do:
         assign vret = yes.
         leave.
      end.
  end.
  assign oret = vret.
end.
