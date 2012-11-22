/* xxsh1201a.p - sh1201 item request calc                                    */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1C04   QAD:eb21sp6    Interface:Character        */
/* REVISION: 120706.1 LAST MODIFIED: 07/06/12 BY:Zy                          */
/* REVISION END                                                              */

/* define shared variable global_user_lang_dir like lng_mstr.lng_dir.        */
{mfdeclre.i}
{xxsh1201.i}
define variable txt as character.
define variable qty as decimal.
define variable i as integer.
define variable x as integer.
empty temp-table xxpln_mstr no-error.
input from value(flhload).
assign x = 0.
repeat:
    x = x + 1.
    import unformat txt.
    if x  >= 3 then do:
    do i = 1 to maxArray:
       assign qty = 0.
       assign qty = decimal(trim(entry(7 + i,txt,","))) no-error.
       if qty > 0 and
          can-find(first pt_mstr no-lock where pt_domain = global_domain and
                         pt_part = entry(2,txt,","))
       then do:
          find first xxpln_mstr no-lock where xxpln_par = entry(2,txt,",")
                  and xxpln_date = sdate + i - 1 no-error.
          if not available xxpln_mstr then do:
                  create xxpln_mstr.
                  assign xxpln_par = entry(2,txt,",")
                         xxpln_date = sdate + i - 1.
          end.
          assign xxpln_qty = xxpln_qty + qty.
       end. /* if qty > 0 then do: */
    end. /*do i = 1 to maxArray:*/
    end. /*if x  >= 3 then do:*/
end.
input close.
