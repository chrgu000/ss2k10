/* yypart-wo.p - yypart wo                                                   */
/*V8:ConvertMode=Report                                                      */
/* REVISION: 120713.1 LAST MODIFIED: 07/13/12 BY: zy                         */
/* REVISION END                                                              */
/*此程序是字符版-不提供GUI的程序                                             */

{mfdtitle.i "121021.1"}

DEFINE VAR itpart LIKE tr_part.
define variable part1 like pt_part.
DEFINE VAR bedate LIKE tr_date INIT TODAY.
DEFINE VAR eddate LIKE tr_date INIT TODAY.
DEFINE VAR partsum LIKE tr_qty_loc INIT 0.
DEFINE VAR sosum LIKE tr_qty_loc INIT 0.
DEFINE WORKFILE xxwkpt
       FIELD part LIKE  tr_part
       FIELD lot LIKE  tr_lot
       FIELD qty LIKE  tr_qty_loc. /*part*/

DEFINE WORKFILE xxwkso
       FIELD partpt LIKE tr_part
       FIELD partsum LIKE tr_qty_loc
       FIELD partso LIKE  tr_part
       FIELD qty LIKE  tr_qty_loc
       FIELD lot LIKE  tr_lot. /*so */

/* 查询零件回冲的数量和冲到的发动机*/

FORM
 itpart colon 12   part1 colon 42 label {t001.i}
 bedate colon 12   eddate colon 42 skip(1)
with frame a side-label.
setframelabels(frame a:handle) .

REPEAT:

    if bedate = low_date then bedate = ?.
    if eddate = hi_date  then eddate = ?.
    if part1 = hi_char then part1 = "".

    update itpart part1 bedate eddate with frame a.

    if part1 = "" then part1 = hi_char.
    if bedate = ? then bedate = low_date.
    if eddate = ? then eddate = hi_date.

    {mfquoter.i itpart}
    {mfquoter.i part1}
    {mfquoter.i bedate}
    {mfquoter.i eddate}
    {mfselbpr.i "printer" 132}
   FOR EACH xxwkpt.
       DELETE xxwkpt.
   END.
   FOR EACH xxwkso.
       DELETE xxwkso.
   END.

   FOR EACH tr_hist WHERE tr_domain = global_domain and
            tr_part >= itpart AND tr_part <= part1 and
/*          tr_userid ="mrp" AND  */
            tr_date >=bedate AND tr_date <= eddate BREAK BY tr_lot .
    IF FIRST-OF (tr_lot) THEN partsum =0.
    partsum= partsum + tr_qty_loc.
    IF LAST-OF(tr_lot) THEN do:
           CREATE xxwkpt.
           ASSIGN xxwkpt.part = tr_part
                  xxwkpt.qty = partsum
                  xxwkpt.lot = tr_lot.
    END.
   END.

   FOR EACH xxwkpt.
    FOR EACH tr_hist WHERE tr_domain = global_domain and tr_lot = xxwkpt.lot AND
/*         tr_userid="mrp" AND   */
        tr_type ="rct-wo" AND  tr_date >= bedate AND tr_date <=eddate
      BREAK BY tr_lot.
        IF FIRST-OF (tr_lot) THEN sosum =0.
        sosum= sosum + tr_qty_loc.
        IF LAST-OF(tr_lot) THEN do:
           CREATE xxwkso.
           ASSIGN xxwkso.partpt = xxwkpt.part
                  xxwkso.partsum = xxwkpt.qty
                  xxwkso.partso = tr_part
                  xxwkso.qty = sosum
                  xxwkso.lot = xxwkpt.lot.
        END.
    END.
  END.

  PUT "零件号;零件回冲数量;发动机号;发动机回冲数量;事务号" skip.
  PUT fill("_",84) skip.
  FOR EACH xxwkso no-lock.
    PUT unformat xxwkso.partpt ";"
                 xxwkso.partsum ";"
                 xxwkso.partso ";"
                 xxwkso.qty ";"
                 xxwkso.lot SKIP.
  END.
    {mfreset.i}

END.
