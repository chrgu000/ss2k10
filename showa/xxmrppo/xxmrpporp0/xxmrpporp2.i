define variable vkey1 like usrw_key1 no-undo
                initial "XXMRPPORP0.P-ITEM-ORDER-POLICY".
define variable v_key_rec_date like usrw_key1
                initial "xxmrpporp.rec_date" no-undo.
FUNCTION getWeekIdx RETURNS integer(idate as date):
 /* -----------------------------------------------------------
    Purpose:
    Parameters:  <none>
    Notes:
  -------------------------------------------------------------*/
  define variable oi as integer.
  if weekday(idate) - 1 = 0 then assign oi = 7.
  else assign oi = weekday(idate) - 1.
  return oi.
END FUNCTION. /*FUNCTION getWeekidx*/

procedure iniPOdate:
    define input parameter vdatef as date initial 6/1/2013.
    define input parameter vdatet as date initial 12/31/2013.

    define variable vi as integer.
    define variable vj as integer.
    define variable vw as integer.
    define variable vdte as date.

    for each qad_wkfl exclusive-lock where qad_key1 = v_key_rec_date: delete qad_wkfl. end.

    do vdte = vdatef to vdatet:
       if day(vdte) = 1 then do:
         assign vi = 1
                vj = 1.
       end.
       assign vw = getWeekIdx(vdte).
       find first qad_wkfl where qad_key1 = v_key_rec_date
              and qad_key2 = string(vdte) no-error.
       if not available qad_wkfl then do:
               create qad_wkfl.
               assign qad_key1 = v_key_rec_date
                      qad_key2 = string(vdte)
                      qad_datefld[1] = vdte
                      qad_intfld[1] = vj
                      qad_intfld[2] = vw
                      qad_charfld[1] = string(vj)
                      qad_charfld[2] = string(vw)
                      qad_logfld[1] = yes.
       end.
       find first hd_mstr no-lock where hd_site = "gsa01"
              and hd_date = vdte no-error.
       if available(hd_mstr) then do:
          qad_logfld[1] = no.
       end.
       vi = vi + 1.
       if vi = 8 then do:
          assign vi = 1
                 vj = vj + 1.
       end.
    end.
end.

FUNCTION getRole RETURNS character(iVend as character, iPart as character):
 /* -----------------------------------------------------------
    Purpose:get Vedor or item recive role
    Parameters: iVend = vendor , iPart = part.
    Notes: default = any time.
  -------------------------------------------------------------*/
  define variable oRole as character initial "12345;1234567".
  find first vd_mstr no-lock where vd_addr = iVend no-error.
  if available vd_mstr then do:
     assign oRole = vd__chr04.
  end.
  find first usrw_wkfl no-lock where usrw_key1 = vkey1 and usrw_key2 = iPart no-error.
  if available usrw_wkfl then do:
     assign oRole = usrw_charfld[4] when usrw_charfld[4] <> "".
  end.
  return oRole.
END FUNCTION. /*FUNCTION getRole*/

FUNCTION getRelDate RETURNS date(iRole as character,iDate as date):
 /* -----------------------------------------------------------
    Purpose:
    Parameters:  <none>
    Notes:
  -------------------------------------------------------------*/
  define variable oDate as date.
  assign oDate = iDate.
  define variable vmth as character.
  define variable vwk  as character.
  assign vmth = entry(1,iRole,";").
  assign vwk  = entry(2,iRole,";").
  for each qad_wkfl no-lock where qad_key1 = v_key_rec_date
      and qad_logfld[1] and qad_datefld[1] <= iDate
      and index(vmth,qad_charfld[1]) > 0
      and index(vwk,qad_charfld[2]) > 0
      break by qad_key1 by qad_datefld[1] descending:
      if first-of(qad_key1) then do:
         assign oDate = qad_datefld[1].
         leave.
      end.
  end.
  return oDate.
END FUNCTION. /*FUNCTION getRelDate*/
