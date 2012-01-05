/* GUI CONVERTED from recalcap.i (converter v1.78) Fri Oct 29 14:37:51 2004 */
/* recalcap.i - Calculate capacity for scheduling shifts given the date */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*K1Q4*/
/* REVISION: 7.2    LAST MODIFIED: 12/09/92     BY: emb *G468*          */
/* REVISION: 8.6    LAST MODIFIED: 05/20/98     BY: *K1Q4* Alfred Tan   */
/* REVISION: 9.1    LAST MODIFIED: 08/12/00     BY: *N0KP* myb          */
/* $Revision: 1.4.1.3 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00K* */
/* $Revision: 1.4.1.3 $ BY: Mage chen (SB) DATE: 08/06/08 ECO: *ts* */
/*-Revision end---------------------------------------------------------------*/

/* &date = Date to check                                                */


     check_date = {&date}.


     repeat while available shop_cal:
/*GUI*/ if global-beam-me-up then undo, leave.


        assign cap = 0
         hours = 0.

        assign
          cap[1] = shop_hours[weekday({&date})]
        hours[1] = shop_hours[weekday({&date})].

        find shft_det no-lock  where shft_det.shft_domain = global_domain and
        shft_site = shop_site
        and shft_wkctr = shop_wkctr and shft_mch = shop_mch
        and shft_day = weekday({&date}) no-error.

        if available shft_det then
        assign
        cap[1] = shft_load1 * shft_hour1 / 100
        cap[2] = shft_load2 * shft_hour2 / 100
        cap[3] = shft_load3 * shft_hour3 / 100
        cap[4] = shft_load4 * shft_hour4 / 100

        hours[1] = shft_hour1
        hours[2] = shft_hour2
        hours[3] = shft_hour3
        hours[4] = shft_hour4.

        /* Adjust daily capacity by cal_det file records */
        for each cal_det no-lock  where cal_det.cal_domain = global_domain and
        (  cal_site = shop_site
        and cal_wkctr = shop_wkctr and cal_mch = shop_mch
        and (cal_start <= {&date} or cal_start = ?)
        and (cal_end >= {&date} or cal_end = ?) ) :

           if available shft_det then
           assign
          cap[1] = cap[1] + cal_shift1 * shft_load1 / 100
          cap[2] = cap[2] + cal_shift2 * shft_load2 / 100
          cap[3] = cap[3] + cal_shift3 * shft_load3 / 100
          cap[4] = cap[4] + cal_shift4 * shft_load4 / 100

          hours[1] = hours[1] + cal_shift1
          hours[2] = hours[2] + cal_shift2
          hours[3] = hours[3] + cal_shift3
          hours[4] = hours[4] + cal_shift4.

           else
           assign
          cap[1] = cap[1] + cal_shift1
        hours[1] = hours[1] + cal_shift1.
        end.

        if cap[1] > 0 or cap[2] > 0 or cap[3] > 0 or cap[4] > 0
        then leave.

/*ts        if {&date} - check_date > 365 then leave.

        {&date} = {&date} + 1.*/
/*ts*/    if check_date -  {&date} > 365 then leave.
 /*ts */     if {&date} > today then  {&date} = {&date} - 1.  
 /*ts */                      else leave .

        {recaldt.i {&date} shopcal_recno}
     end.
/*GUI*/ if global-beam-me-up then undo, leave.

