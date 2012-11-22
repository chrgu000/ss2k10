/* yysscalc.i - Safety Stock Calc                                            */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 121116.1 LAST MODIFIED: 11/16/12 BY: zy                         */
/* REVISION END                                                              */

define {1} shared variable v_key like usrw_key1 no-undo
           initial "Safety_Stock_Ctrl".

define {1} shared variable v_key1 like usrw_key1 no-undo
           initial "Safey_Stock_Month_Ref".

define {1} shared variable vka as decimal  no-undo.
define {1} shared variable vkb as decimal  no-undo.
define {1} shared variable vkc as decimal  no-undo.
define {1} shared variable vcyc as integer no-undo.

define {1} shared temp-table xss_mstr
    fields xss_part like pt_part
    fields xss_site like pt_site
    fields xss_desc like pt_desc1
    fields xss_sfty_stkn like pt_sfty_stk
    fields xss_sfty_stk like pt_sfty_stk
    fields xss_qty_loc like in_qty_oh
    fields xss_abc  like pt_abc
    fields xss_k    as   decimal
    fields xss_qty_iss like tr_qty_loc
    fields xss_qty_avg like tr_qty_loc
    fields xss_std_dev as decimal
    index xss_index1 is primary xss_part xss_site.

define {1} shared workfile xssd_det
    fields xssd_part like pt_part
    fields xssd_site like pt_site
    fields xssd_i    as   integer
    fields xssd_qty_iss like tr_qty_loc.

procedure iniVar:
  assign vka = 1.5
         vkb = 1.25
         vkc = 1
         vcyc = 6.
  find first usrw_wkfl no-lock where usrw_domain = global_domain
         and usrw_key1 = v_key and usrw_key2 = v_key no-error.
  if available usrw_wkfl then do:
     assign vka = usrw_decfld[1]
            vkb = usrw_decfld[2]
            vkc = usrw_decfld[3]
            vcyc = usrw_intfld[1].
  end.
end procedure.

FUNCTION getMonths RETURNS integer(fdate as date,tdate as date):
 /* -----------------------------------------------------------
    Purpose:计算2个日期间有多少个月份
    Parameters: fdate: from date / tdate: to date
    Notes:
  -------------------------------------------------------------*/
  define variable vi as integer.
  define variable vret as integer.
  define variable vdte as date.

  assign vdte = fdate.
  assign vi = 0
         vret = 0.
  if fdate < fdate then do:
     assign vret = 0.
  end.
  else if month(fdate) = month(tdate) and year(fdate) = year(tdate) then do:
     assign vret = 1.
  end.
  else do:
     repeat:
       if day(vdte) = 1 then do:
          assign vret = vret + 1.
          vdte = vdte + 27.
       end.
       else do:
          vdte = vdte + 1.
       end.
       if vdte >= tdate then leave.
     end.
  end.

  return vret.
END FUNCTION. /* FUNCTION getMonths */

PROCEDURE iniSSwkfl:
define input parameter imth as integer.
define input parameter idte as date.
define variable vi as integer.
define variable dte as date.
/* -----------------------------------------------------------
   Purpose:
   Parameters:  <none>
   Notes:
 -------------------------------------------------------------*/

for each usrw_wkfl exclusive-lock where usrw_domain = global_domain and
       usrw_key1 = v_key1:
    delete usrw_wkfl.
end.
assign dte = date(month(idte),1,year(idte)).
do vi = 1 to imth:
   find first usrw_wkfl exclusive-lock where usrw_domain = global_domain and
              usrw_key1 = v_key1 and usrw_key2 = string(vi,"99999") no-error.
   if not available usrw_wkfl then do:
          create usrw_wkfl. usrw_domain = global_domain.
          assign usrw_key1 = v_key1
                 usrw_key2 = string(vi,"99999")
                 usrw_intfld[1] = vi.
   end.
          assign usrw_datefld[1] = dte.
          assign dte = dte + 35.
          assign dte = date(month(dte),1,year(dte)).
          assign usrw_datefld[2] = dte - 1.
end.

END PROCEDURE. /* PROCEDURE iniSSwkfl*/
