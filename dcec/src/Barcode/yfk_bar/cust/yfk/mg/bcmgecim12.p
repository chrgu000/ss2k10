{bcdeclre.i}

DEFINE INPUT PARAMETER bfid AS INTEGER.
DEFINE OUTPUT PARAMETER succeed AS LOGICAL.

DEFINE VARIABLE begintime AS INTEGER.
DEFINE VARIABLE endtime AS INTEGER.

FOR FIRST b_bf_det WHERE b_bf_id = bfid:
END.


DO ON ERROR UNDO, LEAVE ON ENDKEY UNDO,LEAVE:

  begintime = TIME.
  {bcrun.i ""bcmgbdpro.p"" "(INPUT ""d:\temp\woisrc.cim"",INPUT ""d:\temp\out.prn"")"}
  endtime = TIME.

  FIND LAST tr_hist NO-LOCK WHERE tr_part = b_bf_part AND tr_type = "rct-wo" AND (tr_time >= begintime AND tr_time <= endtime) NO-ERROR.
         IF AVAILABLE tr_hist THEN
         DO:
            succeed = TRUE.
            b_bf_tocim = NO.
         END.
         ELSE DO:
             succeed = FALSE.
         END.


END.
