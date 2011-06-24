/* pomttrl2.p - PURCHASE ORDER TRAILER                                   */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                   */
/* All rights reserved worldwide.  This is an unpublished work.          */
/*V8:ConvertMode=Maintenance                                             */
/*V8:RunMode=Character,Windows                                           */
/*F0PN*/
/* $Revision: 1.8.2.2 $                                                  */
/* REVISION: 7.4            CREATED: 06/22/93   BY: *H006* JJS           */
/* REVISION: 7.4      LAST MODIFIED: 07/06/93   BY: *H024* JJS           */
/* REVISION: 7.4      LAST MODIFIED: 07/20/93   BY: *H033* bcm           */
/* REVISION: 7.4      LAST MODIFIED: 07/22/93   BY: *H032* bcm           */
/* REVISION: 7.4      LAST MODIFIED: 07/28/93   BY: *H042* bcm           */
/* REVISION: 7.4      LAST MODIFIED: 04/11/94   BY: *H334* bcm           */
/* REVISION: 7.4      LAST MODIFIED: 06/13/94   BY: *H382* bcm           */
/* REVISION: 7.4      LAST MODIFIED: 07/18/94   BY: *H442* qzl           */
/* REVISION: 7.4      LAST MODIFIED: 07/21/94   BY: *H453* qzl           */
/* REVISION: 7.4      LAST MODIFIED: 09/08/94   BY: *H509* bcm           */
/* REVISION: 7.4      LAST MODIFIED: 09/20/94   BY: *GM74* jpm           */
/* REVISION: 7.4      LAST MODIFIED: 11/22/94   BY: *H606* bcm           */
/* REVISION: 7.4      LAST MODIFIED: 03/28/95   BY: *H0BJ* tvo           */
/* REVISION: 7.4      LAST MODIFIED: 08/08/95   BY: *G0TR* jym           */
/* REVISION: 7.4      LAST MODIFIED: 09/01/95   BY: *H0FQ* ais           */
/* REVISION: 8.5      LAST MODIFIED: 10/03/95   BY: *J053* taf           */
/* REVISION: 8.5      LAST MODIFIED: 02/14/96   BY: *H0JJ* rxm           */
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan    */
/* Revision: 1.8.2.1  BY:Mark B. Smith    DATE:12/21/99 ECO: *N059*      */
/* REVISION: 9.1      LAST MODIFIED: 08/17/00   BY: *N0LJ* Mark Brown    */


{mfdeclre.i}

define shared variable convertmode as character no-undo.

if convertmode = "MAINT" then do:
   {gprun.i ""pomttrld.p""}
end.
else do:
   {gprun.i ""xxpomttrlc.p""}
end.
