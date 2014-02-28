/* fcfsmt02.p - FORECAST MASTER MAINTENANCE                             */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*K1Q4*/ /*V8:WebEnabled=No                                             */
/* REVISION: 7.2      LAST MODIFIED: 09/16/94   BY: pxd *FR51* */
/* REVISION: 7.2      LAST MODIFIED: 11/07/94   BY: ljm *GO15* */
/* REVISION: 8.5      LAST MODIFIED: 06/19/97   BY: *J1TK* Felcy D'Souza*/
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L0* Jacolyn Neder */




DEFINE  SHARED  VARIABLE  totals LIKE  fcs_fcst EXTENT  4.
DEFINE  VARIABLE  i AS  INTEGER .
DEFINE  SHARED  VARIABLE  fcrecid AS  RECID .
DEFINE  SHARED  VARIABLE  fcs_fcst LIKE  a6fcs_fcst_qty FORMAT  ">>>>,>>9" .
DEFINE  SHARED  VARIABLE  START  AS  DATE  EXTENT  52 .

/* DISPLAY TITLE */
/*GO15* {mfdtitle.i "b+ "} */
/*J1TK** /*GO15*/ {mfdeclre.i} */

/*J1TK** find a6fcs_sum where recid(a6fcs_sum) = fcrecid exclusive no-error. */
/*J1TK*/ find a6fcs_sum where recid(a6fcs_sum) = fcrecid no-lock no-error.

/*J1TK*/ assign fcs_fcst = 0
/*J1TK*/        totals   = 0.

/*J1TK*/ if available a6fcs_sum then
         do i = 1 to 52:
         	  a6fcs_star_date [i] = START [i] .
            fcs_fcst[i] = a6fcs_fcst_qty[i].
            if i <= 13 then totals[1] = totals[1] + a6fcs_fcst_qty[i].
            if i >= 14 and i <= 26 then totals[2] = totals[2] + a6fcs_fcst_qty[i].
            if i >= 27 and i <= 39 then totals[3] = totals[3] + a6fcs_fcst_qty[i].
            if i >= 40 then totals[4] = totals[4] + a6fcs_fcst_qty[i].
        end.
