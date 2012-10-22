/*{mfdtitle.i}*/
{mfdeclre.i}
{bcdeclre.i}

DEFINE INPUT PARAMETER bfid AS INTEGER.
DEFINE OUTPUT PARAMETER succeed AS LOGICAL INITIAL FALSE.

DEFINE VARIABLE begintime AS INTEGER.
DEFINE VARIABLE endtime AS INTEGER.

FOR FIRST b_bf_det WHERE b_bf_id = bfid:
END.


DO ON ERROR UNDO, LEAVE ON ENDKEY UNDO,LEAVE:

  begintime = TIME.
  /*{gprun.i ""mgbdpro.p"" "(INPUT ""d:\temp\sfoptr.cim"",INPUT ""d:\temp\out.prn"")"}*/
         define variable errors as integer.
  {xgcmdef.i "new"}
  {gprun.i ""mgcm001.p""
           "(INPUT mfguser,
             output errors)"}
  endtime = TIME.

   OS-DELETE VALUE(mfguser).
  IF CAN-FIND( FIRST op_hist NO-LOCK WHERE op_wo_nbr = b_bf_nbr AND op_wo_op = b_bf_ser ) THEN
  DO:
      succeed = TRUE.
  END.
  ELSE DO:
      succeed = FALSE.
  END.

     IF SEARCH("D:\temp\sfoptr.cim") <> ? THEN
             OS-DELETE VALUE("d:\temp\sfoptr.cim").

END.