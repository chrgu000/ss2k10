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
  {bcrun.i ""bcmgbdpro_90.p."" "(INPUT mfguser,INPUT ""d:\temp\out.prn"")"}
  /*  define variable errors as integer.
  {xgcmdef.i "new"}
  {bcrun.i ""bcmgcm001.p""
           "(INPUT ""d:\temp\iclotr04.cim"",
             output errors)"}*/
  endtime = TIME.

  OS-DELETE VALUE(mfguser).
  IF CAN-FIND( FIRST tr_hist NO-LOCK WHERE tr_part = b_bf_part AND tr_type = "RCT-TR"
                AND (tr_time >= begintime AND tr_time <= endtime) ) THEN
  DO:
      succeed = TRUE.
  END.
  ELSE DO:
      succeed = FALSE.
  END.

END.
