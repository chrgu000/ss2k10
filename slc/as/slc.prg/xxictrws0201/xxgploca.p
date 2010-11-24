/* gpsiver.p - PROCEDURE TO VALIDATE SITES FOR DATA ENTRY                    */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                        */
/*M02W*/ /*V8:RunMode=Character,Windows                                      */
/* REVISION:  7.5     LAST MODIFIED: 09/28/94    BY:  MWD  *J034*            */
/* REVISION: 9.0      LAST MODIFIED: 12/22/98   BY: *M02W* Luke Pokic   */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KS* myb               */
/* $Revision: 1.8 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00F* */
/* $Revision: 1.8 $ BY: ken  chen     (SB) DATE: 08/24/08 ECO: *SS - 20080824.1* */
/*-Revision end---------------------------------------------------------------*/

/*                                                                           */
/*****************************************************************************/
/* This subroutine determines whether a particular user is allowed to        */
/* enter data for a given site, based on his assigned user groups            */
/* It looks up the si_mstr based on either the si_recid (if available) or    */
/* the site.  If the si_mstr is found and has security assigned, compares    */
/* to see if any of the user's groups is among the security groups           */
/* (si_canrun) for the site.  Returns a code of 1 for authorized, 0 for NOT  */
/* authorized.  The calling program is expected to display any messages      */
/* and/or take other action based on that return code.                       */
/*                                                                           */
/* Called by icedit1.i and icedit2.i transaction edit routines as well as a  */
/* number of maintenance routines which get user data entry by site.         */

/*****************************************************************************/
/*  parameters used:                                                         */
/* input variables:        sisite                  input site                */
/*                         si_recno                recid of site being       */
/*                                                 processed                 */
/* output variable:        authorized              integer return code       */
/*                                                 1=authorized; 0-not auth  */
/*****************************************************************************/

         {mfdeclre.i}           /* COMMON VARIABLES                  */
     {mf1.i}            /* ADDITIONAL COMMON VARIABLES, SUCH */
                    /* AS GLOBAL_USER_GROUPS             */



/*SS - 20080824.1 B*/
/*
     define input  parameter sisite      like si_site.
     define input  parameter si_recno    as recid.
         define output parameter authorized  as int initial 1.
*/

             define input  parameter locsite      like loc_site.
             define input  parameter locloc      like loc_loc.
             define input  parameter loc_recno    as recid.
                 define output parameter authorized  as int initial 1.

/*SS - 20080824.1 E*/
         define variable group_indx          as integer.

         /* CHECK SITE FOR USER GROUP AUTHORIZATION */
     if loc_recno <> ? then
         find loc_mstr where recid(loc_mstr) = loc_recno no-lock no-error.
     else
         find loc_mstr  where loc_mstr.loc_domain = global_domain and  loc_site =
         locsite AND loc_loc = locloc no-lock no-error.

     if available loc_mstr and loc_user2 <> "" then do:
            authorized = 0.

            if can-do (loc_user2 + ",!*",global_userid) then
               authorized = 1.

            if authorized = 0 then
               do group_indx = 1 to num-entries(global_user_groups)
               while authorized = 0:
                  if can-do (loc_user2 + ",!*",
                  entry(group_indx, global_user_groups) ) then
                     authorized = 1.
               end.  /* DO WHILE */
         end.  /* (IF AVAILABLE SI_MSTR AND...) */
