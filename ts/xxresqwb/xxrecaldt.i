/* GUI CONVERTED from recaldt.i (converter v1.78) Fri Oct 29 14:37:51 2004 */
/* recaldt.i - Calculate next available workdate using shop Calendar and Holiday*/
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                         */
/*K1Q4*/
/* REVISION: 7.0    LAST MODIFIED: 12/04/91     BY: smm *F230*        */
/* REVISION: 7.0    LAST MODIFIED: 05/16/92     BY: emb *F531*        */
/* REVISION: 7.3    LAST MODIFIED: 12/09/92     BY: emb *G468*        */
/* REVISION: 8.6    LAST MODIFIED: 05/20/98     BY: *K1Q4* Alfred Tan         */
/* REVISION: 9.1    LAST MODIFIED: 08/12/00     BY: *N0KP* myb                  */
/* $Revision: 1.4.1.3 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00K* */
/* $Revision: 1.4.1.3 $ BY: Mage Chen (SB) DATE: 08/06/06 ECO: *ts* */
/*-Revision end---------------------------------------------------------------*/

/* {1} = send date       {2} = recid of shop calendar used */


/*G468*  increment = 0. */
     {2} = 0.

     find shop_cal no-lock  where shop_cal.shop_domain = global_domain and
     shop_site = site
     and shop_wkctr = prline and shop_mch = "" no-error.

     if not available shop_cal then
     find shop_cal no-lock  where shop_cal.shop_domain = global_domain and
     shop_site = ""
     and shop_wkctr = prline and shop_mch = "" no-error.

     if not available shop_cal then
     find shop_cal no-lock  where shop_cal.shop_domain = global_domain and
     shop_site = site
     and shop_wkctr = "" and shop_mch = "" no-error.

     if not available shop_cal then
     find shop_cal no-lock  where shop_cal.shop_domain = global_domain and
     shop_site = ""
     and shop_wkctr = "" and shop_mch = "" no-error.

     if available shop_cal then {2} = recid(shop_cal).

     if available shop_cal
     and (shop_wday[1] or shop_wday[2] or shop_wday[3]
       or shop_wday[4] or shop_wday[5] or shop_wday[6] or shop_wday[7])
     then do:
/*G468*     found_date = no. */
/*G468*     repeat while not found_date: */
/*G468*/    repeat:
/*G468*        if shop_wdays[weekday({1} + increment)] then do: */
/*G468*/       if shop_wdays[weekday({1})] then do:
          /* Check Holiday File */
/*G468*           if not can-find(hd_mstr where hd_date = {1} + increment */
/*G468*/          if not can-find(hd_mstr  where hd_mstr.hd_domain =
global_domain and  hd_date = {1}
             and hd_site = site) then do:
/*G468*              {1} = {1} + increment. */
/*G468*              found_date = yes. */
/*G468*/             leave.
          end.
          else do:
/*G468*              increment = increment + 1. */
/*ts /*G468*/          {1} = {1} + 1.*/
/*ts /*G468*/*/   if {1} > today then   {1} = {1} -  1.
          end.
           end.
           else
/*G468*           increment = increment + 1. */
/*ts /*G468*/          {1} = {1} + 1.*/
/*ts /*G468*/*/    if {1} > today then    {1} = {1} -  1.
        end. /*repeat*/
     end. /*available shop_cal*/
/*G468*  else {1} = {1} + 1. */
/*G468*/ else release shop_cal.
