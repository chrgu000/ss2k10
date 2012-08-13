{mfdtitle.i}
    {bcdeclre.i NEW}
     {bcgetprt.i}
    DEFINE VARIABLE i AS INT.
UPDATE i.
FOR EACH b_wod_det, EACH b_co_mstr  WHERE b_wod_date = 04/29/08 AND b_wod_shift = "c"
AND b_co_code = b_wod_code AND b_co_status = "fini-rel" :
  {bcco001.i b_wod_code b_wod_part "0" """" """" """" """"}

                   {gprun.i ""bccopr.p"" "(input b_wod_code, input ""FUL"", input pname, input no)"}

  /*     {bcco002.i ""FINI-REL""}*/

END.
