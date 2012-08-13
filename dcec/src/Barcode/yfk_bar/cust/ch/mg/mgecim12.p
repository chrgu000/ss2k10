/*{mfdtitle.i}*/
{mfdeclre.i}
{bcdeclre.i}

DEFINE INPUT PARAMETER bfid AS INTEGER.
DEFINE OUTPUT PARAMETER succeed AS LOGICAL.

DEFINE VARIABLE begintime AS INTEGER.
DEFINE VARIABLE endtime AS INTEGER.

FOR FIRST b_bf_det WHERE b_bf_id = bfid:
END.


DO ON ERROR UNDO, LEAVE ON ENDKEY UNDO,LEAVE:

  begintime = TIME.
  /*{gprun.i ""mgbdpro.p"" "(INPUT ""d:\temp\woisrc.cim"",INPUT ""d:\temp\out.prn"")"}*/
         define variable errors as integer.
  {xgcmdef.i "new"}
  {gprun.i ""mgcm001.p""
           "(INPUT mfguser,
             output errors)"}
  endtime = TIME.
   OS-DELETE VALUE(mfguser).

  FIND LAST tr_hist NO-LOCK WHERE tr_part = b_bf_part AND tr_type = "rct-wo" AND (tr_time >= begintime AND tr_time <= endtime)
      AND tr_qty_loc  =b_bf_qty_loc  NO-ERROR.
         IF AVAILABLE tr_hist THEN
         DO:
            succeed = TRUE.
            b_bf_tocim = NO.
         END.
         ELSE DO:
             succeed = FALSE.
         END.

   IF SEARCH("D:\temp\woisrc.cim") <> ? THEN
             OS-DELETE VALUE("d:\temp\woisrc.cim").

END.
