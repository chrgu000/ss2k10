/* fapl.p - Fixed Assets procedure library                                    */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* REVISION: 9.1     LAST MODIFIED: 10/26/99    BY: *N021* Hualin Zhong       */
/* REVISION: 9.1     LAST MODIFIED: 11/29/99    BY: *N05Y* Pat Pigatti        */
/* REVISION: 9.1     LAST MODIFIED: 11/30/99    BY: *N062* P Pigatti          */
/* REVISION: 9.1     LAST MODIFIED: 08/14/00    BY: *N0L0* Jacolyn Neder      */
/* Revision: 1.6          BY: Ashutosh Pitre      DATE: 09/24/01  ECO: *M1JV* */
/* Revision: 1.7          BY: Alok Thacker        DATE: 03/13/02  ECO: *M1NB* */
/* Revision: 1.8          BY: Kirti Desai         DATE: 05/03/02  ECO: *N1GN* */
/* Revision: 1.9          BY: Rajaneesh S.        DATE: 05/22/02  ECO: *M1Y9* */
/* Revision: 1.10         BY: Ashish Kapadia      DATE: 07/10/02  ECO: *M1ZW* */
/* Revision: 1.11         BY: Rajiv Ramaiah       DATE: 09/09/02  ECO: *N1T6* */
/* Revision: 1.12         BY: Manish Dani         DATE: 12/20/02  ECO: *M1YW* */
/* Revision: 1.13         BY: Mercy Chittilapilly DATE: 03/26/03  ECO: *N26Y* */
/* Revision: 1.14         BY: Rajesh Lokre        DATE: 04/03/03  ECO: *M1RX* */
/* Revision: 1.16         BY: Paul Donnelly (SB)  DATE: 06/26/03  ECO: *Q00C* */
/* Revision: 1.17         BY: Reena Ambavi        DATE: 03/17/04  ECO: *P1TP* */
/* Revision: 1.18         BY: Nishit V            DATE: 07/19/04  ECO: *P2B5* */
/* $Revision: 1.19 $    BY: Shivaraman V.       DATE: 12/02/05  ECO: *P4B5* */
/*-Revision end---------------------------------------------------------------*/
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/******************************************************************************/
/*V8:ConvertMode=NoConvert                                                    */

/* THIS ROUTINE ENCAPSULATES FUNCTIONS USED IN THE FIXED ASSETS MODULE.  EACH */
/* FUNCTION IS IMPLEMENTED BELOW AS AN INTERNAL PROCEDURE.  THIS PROCEDURE    */
/* LIBRARY ROUTINE IS INTENDED TO BE RUN PERSISTENT WITHIN THE FIXED ASSETS   */
/* APPLICATION.  THE RECOMMENDED METHOD FOR INSTANTIATING THE PERSISTENT      */
/* PROCEDURE AND CALLING THE VARIOUS INTERNAL PROCEDURES IS THROUGH USE OF    */
/* gprunp.i.                                                                  */

/* SS - 090423.1 By: Bill Jiang */

/* SS - 090423.1 - RNB
非标准程序,由于必须遵守QAD相关的命名规范,所以忽略了二次开发相关的命名规范
SS - 090423.1 - RNE */

/* MAIN PROCEDURE BODY IS EMPTY */
{mfdeclre.i}
/********************************************************************/

/* FIXED ASSETS LIBRARY PROCEDURES */

/* THE FOLLOWING INTERNAL PROCEDURES COMPRISE THE FIXED ASSETS  */
/* LIBRARY.  THEY MAY BE CALLED FROM WITHIN ANY APPLICATION     */
/* WHENEVER THE ENCAPSULATING LIBRARY PROCEDURE IS RUNNING      */
/* PERSISTENTLY.                                                */

/* fa-get-per: FINDS THE CORRESPONDING PERIOD FOR THE GIVEN DATE.          */
/* fa-get-nextper: FINDS THE NEXT PERIOD.                                  */
/* fa-get-perinyr: FINDS THE NUMBER OF PERIODS IN A CALENDAR YEAR.         */
/* fa-get-perinlife: FINDS THE NUMBER OF PERIODS IN A GIVEN LIFE.          */
/* fa-get-lifesum: FINDS THE SUM OF YEARS IN A GIVEN LIFE.                 */
/* fa-get-perleftinyr: FINDS THE NUMBER OF PERIODS LEFT IN A YEAR.         */
/* fa-get-halfyear: FINDS THE HALF YEAR THE PERIOD IS IN.                  */
/* fa-get-qtr: FINDS THE QUARTER OF THE YEAR THE PERIOD IS IN.             */
/* fa-get-cost: FINDS THE TOTAL COST FOR THE ASSET BOOK.                   */
/* fa-get-basis: FINDS THE TOTAL BASIS FOR THE ASSET BOOK.                 */
/* fa-get-salvage: FINDS THE TOTAL SALVAGE FOR THE ASSET BOOK.             */
/* fa-get-accdep: FINDS THE TOTAL ACCUMULATED DEPRECIATION FOR A           */
/*                GIVEN PERIOD.                                            */
/* fa-get-perdep: FINDS THE TOTAL PERIOD DEPRECIATION FOR A PERIOD.        */
/* fa-get-anndep: FINDS THE ANNUAL DEPRECIATION.                           */
/* fa-get-cur-perdep: FINDS THE TOTAL PERIOD DEPRECIATION SHOULD HAVE      */
/*                    BEEN TAKEN FOR A PERIOD.                             */
/* fa-get-forecast-perdep: FINDS THE FORECASTED DEPRECIATION FOR A         */
/*                         period. THIS PROCEDURE IS SPECIFICALLY          */
/*                         for uop DEPRECIATION METHOD.                    */
/* fa-get-forecast-anndep: FINDS THE FORECASTED ANNUAL DEPRECIATION        */
/*                         THIS PROCEDURE IS SPECIFICALLY FOR UOP          */
/*                         DEPRECIATION METHOD.                            */
/* fa-get-post: FINDS IF DEPRECIATION FOR A GIVEN PERIOD IS POSTED.        */
/* fa-get-suspend: FINDS IF DEPRECIATION FOR A GIVEN PERIOD IS SUSPENDED.  */
/* fa-get-transfer: FINDS IF A GIVEN PERIOD IS A TRANSFER PERIOD.          */
/* fa-get-lastper: FINDS THE LAST PERIOD OF REDUCED LIFE                   */
/* fa-shortyear: CHECKS IF THE CALENDAR IS A SHORT YEAR.                   */
/*               ALSO, GET THE SHORT YEAR RATIO.                           */
/* fa-perinlife-short: FINDS THE NUMBER OF PERIODS IN A SHORT-YEAR LIFE    */
/* fa-get-daysinyr: FINDS THE NUMBER OF DAYS IN A CALENDAR YEAR            */
/* fa-get-leapyear: RETURNS TRUE IF THE YEAR IS A LEAP YEAR                */
/* fa-conv-per-to-date: FINDS THE START DATE FOR A GIVEN PERIOD AND YEAR.  */
/* fa-chk-input-yrper: CHECKS IF THE INPUT YEAR-PERIOD IS VALID ENTRY.     */
/* fa-get-cost-asof-date: RETURNS THE COST AS OF DATE                      */
/* fa-get-perdep-range: RETURNS THE TOTAL PERIOD DEPRECIATION FOR GIVEN    */
/*                      YEAR/PERIOD RANGE.                                 */
/* fa-incr-last-period: INCREMENTS NUMBER OF PERIODS IN ASSET LIFE BY 1    */
/*                      BASED ON CONVENTION, ACTUAL DAYS FLAG AND          */
/*                      SERVICE DATE.                                      */
/* fa-get-post-class: RETURNS A YES IF THE BOOK ATTACHED TO THE     */
/*                    CLASS IS A POSTING BOOK                       */
/* fa-get-onlytransfer: FINDS IF A GIVEN PERIOD IS A SUSPENDED,            */
/*                      TRANSFERRED AND POSTED PERIOD.                     */


/***************************************************************/

PROCEDURE fa-get-per:

   /* THIS ROUTINE FINDS THE CORRESPONDING PERIOD FOR THE GIVEN */
   /* DATE.                                                     */
   /*                                                           */
   /* INPUT PARAMETERS                                          */
   /*  i_date - DATE TO BE CONVERTED.                           */
   /*  i_cal  - CALENDAR.  BLANK MEANS GL CALENDAR.             */
   /*                                                           */
   /* OUTPUT PARAMETERS                                         */
   /*  o_per   - CORRESPONDING PERIOD FOR THE DATE.             */
   /*  o_error - O IF NO ERROR; ERROR MESSAGE NUMBER            */

   define input  parameter i_date  as date      no-undo.
   define input  parameter i_cal   as character no-undo.
   define output parameter o_per   as character no-undo.
   define output parameter o_error as integer   no-undo.

   CASE i_cal:
      when ""
      then do:
         for first glc_cal
            fields( glc_domain glc_start glc_end glc_year glc_per)
            no-lock
             where glc_cal.glc_domain = global_domain and  glc_start <= i_date
            and   glc_end   >= i_date:
         end. /* FOR FIRST glc_cal */
         if available glc_cal
         then
            o_per = string(glc_year,"9999") + string(glc_per,"99").
         else
            o_error = 2988.  /* DATE NOT DEFINED IN CALENDAR */
      end. /* WHEN " " */
      otherwise do:
         for first facld_det
            fields( facld_domain facld_facl_id facld_start facld_end facld_year
            facld_per)
            no-lock
             where facld_det.facld_domain = global_domain and  facld_facl_id =
             i_cal
            and   facld_start  <= i_date
            and   facld_end    >= i_date:
         end. /* FOR FIRST facld_det */
         if available facld_det
         then
            o_per = string(facld_year,"9999") + string(facld_per,"99").
         else
            o_error = 2988.  /* DATE NOT DEFINED IN CALENDAR */
      end. /* OTHERWISE */
   END CASE. /* CASE i_cal... */

END PROCEDURE.  /* fa-get-per */

/********************************************************************/

PROCEDURE fa-get-nextper:

   /* THIS ROUTINE FINDS THE NEXT PERIOD.                       */
   /*                                                           */
   /* INPUT PARAMETERS                                          */
   /*  i_per    - PERIOD.                                       */
   /*  i_numper - NUMBER OF PERIODS IN A CALENDAR YEAR.         */
   /*                                                           */
   /* OUTPUT PARAMETERS                                         */
   /*  o_per - NEXT PERIOD.                                     */

   define input  parameter i_per    as character no-undo.
   define input  parameter i_numper as integer   no-undo.
   define output parameter o_per    as character no-undo.

   define variable v_period as integer no-undo.
   define variable v_year   as integer no-undo.

   assign
      v_period = integer(substring(i_per,5,2)) + 1
      v_year   = if v_period > i_numper
                 then
                    integer(substring(i_per,1,4)) + 1
                 else
                    integer(substring(i_per,1,4))
      v_period = if v_period > i_numper
                 then
                    1
                 else
                    v_period
      o_per    = string(v_year,"9999") + string(v_period,"99").

END PROCEDURE.  /* fa-get-nextper */

/********************************************************************/

PROCEDURE fa-get-perinyr:

   /* THIS ROUTINE FINDS THE NUMBER OF PERIODS IN A CALENDAR    */
   /* YEAR.                                                     */
   /*                                                           */
   /* INPUT PARAMETERS                                          */
   /*  i_per - PERIOD.                                          */
   /*  i_cal - CALENDAR.  BLANK MEANS GL CALENDAR.              */
   /*                                                           */
   /* OUTPUT PARAMETERS                                         */
   /*  o_perinyr - NUMBER OF PERIODS IN YEAR.                   */

   define input  parameter i_per     as character no-undo.
   define input  parameter i_cal     as character no-undo.
   define output parameter o_perinyr as integer   no-undo.

   CASE i_cal:
      when ""
      then do:
         for each glc_cal
            fields( glc_domain glc_year)
            no-lock
             where glc_cal.glc_domain = global_domain and  glc_year =
             integer(substring(i_per,1,4)):
         o_perinyr = o_perinyr + 1.
         end. /* FOR EACH glc_cal */
      end. /* WHEN " " */
      otherwise do:
         for each facld_det
            fields( facld_domain facld_facl_id facld_year)
            no-lock
             where facld_det.facld_domain = global_domain and  facld_facl_id =
             i_cal
            and   facld_year    = integer(substring(i_per,1,4)):
         o_perinyr = o_perinyr + 1.
         end. /* FOR EACH facld_det */
      end. /* OTHERWISE */
   END CASE. /* CASE i_cal ... */

END PROCEDURE.  /* fa-get-perinyr */

/********************************************************************/

PROCEDURE fa-get-perinlife:

   /* THIS ROUTINE FINDS THE NUMBER OF PERIODS IN A GIVEN LIFE. */
   /*                                                           */
   /* INPUT PARAMETERS                                          */
   /*  i_per     - PERIOD.                                      */
   /*  i_life    - LIFE IN YEARS.                               */
   /*  i_cal     - CALENDAR.  BLANK MEANS GL CALENDAR.          */
   /*  i_actdays - ACTUAL DAYS.                                 */
   /*  i_conv    - CONVENTION.                                  */
   /*  i_date    - SERVICE DATE.                                */
   /*                                                           */
   /* OUTPUT PARAMETERS                                         */
   /*  o_perinlife - PERIODS IN LIFE.                           */

   define input  parameter i_per       as   character       no-undo.
   define input  parameter i_life      as   decimal         no-undo.
   define input  parameter i_cal       as   character       no-undo.
   define input  parameter i_actdays   like famt_actualdays no-undo.
   define input  parameter i_conv      like famt_conv       no-undo.
   define input  parameter i_date      like fab_date        no-undo.
   define output parameter o_perinlife as integer   no-undo.

   run fa-get-perinyr
      (input  i_per,
       input  i_cal,
       output o_perinlife).

   o_perinlife = i_life * o_perinlife.

   run fa-incr-last-period(input         i_actdays,
                           input         i_cal,
                           input         i_date,
                           input         i_conv,
                           input-output  o_perinlife).

END PROCEDURE.  /* fa-get-perinlife */

/********************************************************************/

PROCEDURE fa-get-lifesum:

   /* THIS ROUTINE FINDS THE SUM OF YEARS IN A GIVEN LIFE.      */
   /*                                                           */
   /* INPUT PARAMETERS                                          */
   /*  i_life - LIFE IN YEARS.                                  */
   /*                                                           */
   /* OUTPUT PARAMETERS                                         */
   /*  o_lifesum - SUM OF YEARS IN LIFE.                        */

   define input  parameter i_life    as decimal no-undo.
   define output parameter o_lifesum as integer no-undo.

   define variable v_year as integer no-undo.

   do v_year = 1 to integer(i_life):
      o_lifesum = o_lifesum + v_year.
   end. /* DO v_year = 1 ... */

END PROCEDURE.  /* fa-get-lifesum */

/********************************************************************/

PROCEDURE fa-get-perleftinyr:

   /* THIS ROUTINE FINDS THE NUMBER OF PERIODS LEFT IN A YEAR.  */
   /*                                                           */
   /* INPUT PARAMETERS                                          */
   /*  i_per - PERIOD.                                          */
   /*  i_cal - CALENDAR.  BLANK MEANS GL CALENDAR.              */
   /*                                                           */
   /* OUTPUT PARAMETERS                                         */
   /*  o_perleftinyr - NUMBER OF PERIODS LEFT IN YEAR.          */

   define input  parameter i_per         as character no-undo.
   define input  parameter i_cal         as character no-undo.
   define output parameter o_perleftinyr as integer   no-undo.

   run fa-get-perinyr
      (input  i_per,
       input  i_cal,
       output o_perleftinyr).

   o_perleftinyr = o_perleftinyr - integer(substring(i_per,5,2)) + 1.

END PROCEDURE.  /* fa-get-perleftinyr */

/********************************************************************/

PROCEDURE fa-get-halfyear:

   /* THIS ROUTINE FINDS THE HALF YEAR THE PERIOD IS IN.        */
   /*                                                           */
   /* INPUT PARAMETERS                                          */
   /*  i_per  - PERIOD.                                         */
   /*  i_date - DATE.                                           */
   /*  i_cal  - CALENDAR.  BLANK MEANS GL CALENDAR.             */
   /*                                                           */
   /* OUTPUT PARAMETERS                                         */
   /*  o_halfyear - HALF YEAR.                                  */

   define input  parameter i_per      as character no-undo.
   define input  parameter i_date     as date      no-undo.
   define input  parameter i_cal      as character no-undo.
   define output parameter o_halfyear as integer   no-undo.

   define variable v_even        as logical no-undo.
   define variable v_perinyr     as integer no-undo.
   define variable v_half        as decimal no-undo.
   define variable v_daystostart as integer no-undo.
   define variable v_halfyear    as integer no-undo.
   define variable v_date        as date no-undo.
   define variable v_firstdate   as date no-undo.
   define variable v_lastdate    as date no-undo.

   run fa-get-perinyr
      (input  i_per,
       input  i_cal,
       output v_perinyr).
   assign
      v_half    = v_perinyr / 2
      v_even    = if v_half > truncate(v_half,0)
                  then
                     no
                  else
                     yes.
   if v_even = yes
   then
      o_halfyear = if integer(substring(i_per,5,2)) <= v_half
                   then
                      1
                   else
                      2.

   else do:
      if i_cal = ""
      then do:
         for first glc_cal
            fields( glc_domain glc_year glc_start glc_end)
            no-lock
             where glc_cal.glc_domain = global_domain and  glc_start <= i_date
            and   glc_end   >= i_date:
         end. /* FOR FIRST glc_cal */
         if available glc_cal
         then
            v_date = glc_end.
         else do:
            /* ASSIGN 0 TO o_halfyear TO INDICATE ERROR */
            o_halfyear = 0.
            return.
         end. /* ELSE DO */

         for first glc_cal
            fields( glc_domain glc_year glc_start glc_end)
            no-lock
             where glc_cal.glc_domain = global_domain and  glc_year =
             integer(substring(i_per,1,4)):
         end. /* FOR FIRST glc_cal */
         if available glc_cal
         then
            v_firstdate = glc_start.
         else do:
            /* ASSIGN 0 TO o_halfyear TO INDICATE ERROR */
            o_halfyear = 0.
            return.
         end. /* ELSE DO */

         for last glc_cal
            fields( glc_domain glc_year glc_start glc_end)
            no-lock
             where glc_cal.glc_domain = global_domain and  glc_year =
             integer(substring(i_per,1,4)):
         end. /* FOR LAST glc_cal */
         if available glc_cal
         then
            v_lastdate = glc_end.
         else do:
            /* ASSIGN 0 TO o_halfyear TO INDICATE ERROR */
            o_halfyear = 0.
            return.
         end. /* ELSE DO */
      end.  /* IF i_cal = "" */
      else do:
         for first facld_det
            fields( facld_domain facld_facl_id facld_year facld_start facld_end)
            no-lock
             where facld_det.facld_domain = global_domain and  facld_facl_id =
             i_cal
            and   facld_start  <= i_date
            and   facld_end    >= i_date:
         end. /* FOR FIRST facld_det */
         if available facld_det
         then
            v_date = facld_end.
         else do:
            /* ASSIGN 0 TO o_halfyear TO INDICATE ERROR */
            o_halfyear = 0.
            return.
         end. /* ELSE DO */

         for first facld_det
            fields( facld_domain facld_facl_id facld_year facld_start facld_end)
            no-lock
             where facld_det.facld_domain = global_domain and  facld_facl_id =
             i_cal
              and facld_year = integer(substring(i_per,1,4)):
         end. /* FOR FIRST facld_det */
         if available facld_det
         then
            v_firstdate = facld_start.
         else do:
            /* ASSIGN 0 TO o_halfyear TO INDICATE ERROR */
            o_halfyear = 0.
            return.
         end. /* ELSE DO */

         for last facld_det
            fields( facld_domain facld_facl_id facld_year facld_start facld_end)
            no-lock
             where facld_det.facld_domain = global_domain and  facld_facl_id =
             i_cal
              and facld_year = integer(substring(i_per,1,4)):
         end. /* FOR LAST facld_det */
         if available facld_det
         then
            v_lastdate = facld_end.
         else do:
            /* ASSIGN 0 TO o_halfyear TO INDICATE ERROR */
            o_halfyear = 0.
            return.
         end. /* ELSE DO */
      end.  /* ELSE */

      assign
         v_daystostart = (v_date - v_firstdate)
         v_halfyear    = (v_lastdate - v_firstdate) / 2
         o_halfyear    = if v_daystostart <= v_halfyear
                         then
                            1
                         else
                            2.
   end.  /* ELSE DO v_even = no */

END PROCEDURE.  /* fa-get-halfyear */

/********************************************************************/

PROCEDURE fa-get-qtr:

   /* THIS ROUTINE FINDS THE QUARTER OF THE YEAR THE PERIOD IS  */
   /* IN.                                                       */
   /*                                                           */
   /* INPUT PARAMETERS                                          */
   /*  i_per  - PERIOD.                                         */
   /*  i_date - DATE.                                           */
   /*  i_cal  - CALENDAR.  BLANK MEANS GL CALENDAR.             */
   /*                                                           */
   /* OUTPUT PARAMETERS                                         */
   /*  o_qtr - QUARTER OF THE YEAR.                             */

   define input  parameter i_per  as character no-undo.
   define input  parameter i_date as date      no-undo.
   define input  parameter i_cal  as character no-undo.
   define output parameter o_qtr  as integer   no-undo.

   define variable v_daystostart as integer no-undo.
   define variable v_date        as date    no-undo.
   define variable v_firstdate   as date    no-undo.
   define variable v_lastdate    as date    no-undo.
   define variable v_firstqtr    as integer no-undo.
   define variable v_secondqtr   as integer no-undo.
   define variable v_thirdqtr    as integer no-undo.

   run fa-get-perinyr
      (input  i_per,
       input  i_cal,
       output o_qtr).

   if o_qtr = 4 or o_qtr = 12
   then do:
      o_qtr = if o_qtr = 4
              then
                 integer(substring(i_per,5,2))
              else
              if (integer(substring(i_per,5,2)) = 1 or
                  integer(substring(i_per,5,2)) = 2 or
                  integer(substring(i_per,5,2)) = 3)
              then
                 1
              else
              if (integer(substring(i_per,5,2)) = 4 or
                  integer(substring(i_per,5,2)) = 5 or
                  integer(substring(i_per,5,2)) = 6)
              then
                 2
              else
              if (integer(substring(i_per,5,2)) = 7 or
                  integer(substring(i_per,5,2)) = 8 or
                  integer(substring(i_per,5,2)) = 9)
              then
                 3
              else
                 4.
   end. /* IF o_qtr = 4 OR ... */
   else do:
      if i_cal = ""
      then do:
         for first glc_cal
            fields( glc_domain glc_year glc_start glc_end)
            no-lock
             where glc_cal.glc_domain = global_domain and  glc_start <= i_date
            and   glc_end   >= i_date:
         end. /* FOR FIRST glc_cal */
         if available glc_cal
         then
            v_date = glc_end.
         else do:
            /* ASSIGN 0 TO o_qty TO INDICATE ERROR */
            o_qtr = 0.
            return.
         end. /* ELSE DO */

         for first glc_cal
            fields( glc_domain glc_year glc_start glc_end)
            no-lock
             where glc_cal.glc_domain = global_domain and  glc_year =
             integer(substring(i_per,1,4)):
         end. /* FOR FIRST glc_cal */
         if available glc_cal
         then
            v_firstdate = glc_start.
         else do:
            /* ASSIGN 0 TO o_qty TO INDICATE ERROR */
            o_qtr = 0.
            return.
         end. /* ELSE DO */

         for last glc_cal
            fields( glc_domain glc_year glc_start glc_end)
            no-lock
             where glc_cal.glc_domain = global_domain and  glc_year =
             integer(substring(i_per,1,4)):
         end. /* FOR LAST glc_cal */
         if available glc_cal
         then
            v_lastdate = glc_end.
         else do:
            /* ASSIGN 0 TO o_qty TO INDICATE ERROR */
            o_qtr = 0.
            return.
         end. /* ELSE DO */
      end.  /* IF i_cal = "" */
      else do:
         for first facld_det
            fields( facld_domain facld_facl_id facld_year facld_start facld_end)
            no-lock
             where facld_det.facld_domain = global_domain and  facld_facl_id =
             i_cal
            and facld_start    <= i_date
            and facld_end      >= i_date:
         end. /* FOR FIRST facld_det */
         if available facld_det
         then
            v_date = facld_end.
         else do:
            /* ASSIGN 0 TO o_qty TO INDICATE ERROR */
            o_qtr = 0.
            return.
         end. /* ELSE DO */

         for first facld_det
            fields( facld_domain facld_facl_id facld_year facld_start facld_end)
            no-lock
             where facld_det.facld_domain = global_domain and  facld_facl_id =
             i_cal
            and   facld_year    = integer(substring(i_per,1,4)):
         end. /* FOR FIRST facld_det */
         if available facld_det
         then
            v_firstdate = facld_start.
         else do:
            /* ASSIGN 0 TO o_qty TO INDICATE ERROR */
            o_qtr = 0.
            return.
         end. /* ELSE DO */

         for last facld_det
            fields( facld_domain facld_facl_id facld_year facld_start facld_end)
            no-lock
             where facld_det.facld_domain = global_domain and  facld_facl_id =
             i_cal
            and   facld_year    = integer(substring(i_per,1,4)):
         end. /* FOR LAST facld_det */
         if available facld_det
         then
            v_lastdate = facld_end.
         else do:
            /* ASSIGN 0 TO o_qty TO INDICATE ERROR */
            o_qtr = 0.
            return.
         end. /* ELSE DO */
      end.  /* i_cal <> "" */

      assign
         v_daystostart = (v_date - v_firstdate)
         v_firstqtr    = .25 * (v_lastdate - v_firstdate)
         v_secondqtr   = .5 * (v_lastdate - v_firstdate)
         v_thirdqtr    = .75 * (v_lastdate - v_firstdate)
         o_qtr         = if v_daystostart <= v_firstqtr
                         then
                            1
                         else if v_daystostart <= v_secondqtr
                         then
                            2
                         else if v_daystostart <= v_thirdqtr
                         then
                            3
                         else
                            4.
   end.  /* o_qty <> 4 and o_qty <> 12 */
END PROCEDURE.  /* fa-get-qtr */

/********************************************************************/

PROCEDURE fa-get-cost:

   /* THIS ROUTINE FINDS THE TOTAL COST FOR THE ASSET BOOK.     */
   /*                                                           */
   /* INPUT PARAMETERS                                          */
   /*  i_fa_id   - ASSET ID.                                    */
   /*  i_fabk_id - BOOK ID.                                     */
   /*                                                           */
   /* OUTPUT PARAMETERS                                         */
   /*  o_cost - TOTAL COST FOR THE ASSET BOOK.                  */

   define input  parameter i_fa_id   like fab_fa_id   no-undo.
   define input  parameter i_fabk_id like fab_fabk_id no-undo.
   define output parameter o_cost    like fab_amt     no-undo.

   /* SUM ALL RESERVES TO DETERMINE TOTAL COST */
   for each fab_det
      fields( fab_domain fab_fa_id fab_fabk_id fab_amt)
      no-lock
       where fab_det.fab_domain = global_domain and  fab_fa_id = i_fa_id
      and fab_fabk_id = i_fabk_id:
      o_cost = o_cost + fab_amt.
   end. /* FOR EACH fab_det */
END PROCEDURE.  /* fa-get-cost */

/********************************************************************/

PROCEDURE fa-get-basis:

   /* THIS ROUTINE FINDS THE TOTAL BASIS FOR THE ASSET BOOK.    */
   /*                                                           */
   /* INPUT PARAMETERS                                          */
   /*  i_fa_id   - ASSET ID.                                    */
   /*  i_fabk_id - BOOK ID.                                     */
   /*                                                           */
   /* OUTPUT PARAMETERS                                         */
   /*  o_basis - TOTAL BASIS FOR THE ASSET BOOK.                */

   define input  parameter i_fa_id   like fab_fa_id   no-undo.
   define input  parameter i_fabk_id like fab_fabk_id no-undo.
   define output parameter o_basis   like fab_amt     no-undo.

   define variable v_salvamt like fab_salvamt no-undo.

   /* SUM ALL RESERVES TO DETERMINE TOTAL COST */
   for each fab_det
      fields( fab_domain fab_fa_id fab_fabk_id fab_amt fab_salvamt fab_famt_id)
      no-lock
       where fab_det.fab_domain = global_domain and  fab_fa_id = i_fa_id
      and fab_fabk_id = i_fabk_id:
      assign
         o_basis   = o_basis   + fab_amt
         v_salvamt = v_salvamt + fab_salvamt.
   end. /*FOR EACH fab_det */

   for last fab_det
      fields( fab_domain fab_fa_id fab_fabk_id fab_amt fab_salvamt fab_famt_id)
      no-lock
       where fab_det.fab_domain = global_domain and  fab_fa_id = i_fa_id
      and fab_fabk_id = i_fabk_id:

      /* ADJUST FOR SALVAGE VALUE */
      for first famt_mstr
         fields( famt_domain famt_id famt_salv)
         no-lock
          where famt_mstr.famt_domain = global_domain and  famt_id =
          fab_det.fab_famt_id:
      end. /* FOR FIRST famt_mstr */
      if available famt_mstr and famt_mstr.famt_salv
      then
         o_basis = o_basis - v_salvamt.
   end. /* FOR LAST fab_det */

END PROCEDURE.  /* fa-get-basis */

/********************************************************************/

PROCEDURE fa-get-salvage:

   /* THIS ROUTINE FINDS THE TOTAL SALVAGE FOR THE ASSET BOOK.  */
   /*                                                           */
   /* INPUT PARAMETERS                                          */
   /*  i_fa_id   - ASSET ID.                                    */
   /*  i_fabk_id - BOOK ID.                                     */
   /*                                                           */
   /* OUTPUT PARAMETERS                                         */
   /*  o_salvage - TOTAL SALVAGE VALUE FOR THE ASSET BOOK.      */

   define input  parameter i_fa_id   like fab_fa_id   no-undo.
   define input  parameter i_fabk_id like fab_fabk_id no-undo.
   define output parameter o_salvage like fab_salvamt no-undo.

   /* SUM ALL RESERVES TO DETERMINE TOTAL SALVAGE */
   for each fab_det fields( fab_domain fab_fa_id fab_fabk_id fab_salvamt)
      no-lock
       where fab_det.fab_domain = global_domain and  fab_fa_id = i_fa_id
      and fab_fabk_id = i_fabk_id:
      o_salvage = o_salvage + fab_salvamt.
   end. /* FOR EACH fab_det */
END PROCEDURE.  /* fa-get-salvage */

/********************************************************************/

PROCEDURE fa-get-accdep:

   /* THIS ROUTINE FINDS THE TOTAL ACCUMULATED DEPRECIATION FOR */
   /* A GIVEN PERIOD.                                           */
   /*                                                           */
   /* INPUT PARAMETERS                                          */
   /*  i_fa_id   - ASSET ID.                                    */
   /*  i_fabk_id - BOOK ID.                                     */
   /*  i_per     - PERIOD.                                      */
   /*                                                           */
   /* OUTPUT PARAMETERS                                         */
   /*  o_accdep - ACCUMULATED DEPRECIATION FOR THE PERIOD.      */

   define input  parameter i_fa_id   like fabd_fa_id   no-undo.
   define input  parameter i_fabk_id like fabd_fabk_id no-undo.
   define input  parameter i_per     like fabd_yrper   no-undo.
   define output parameter o_accdep  like fabd_accamt  no-undo.

   define variable l_fasuspend like fabd_accamt no-undo.

   for each fabd_det
      fields( fabd_domain fabd_fa_id fabd_fabk_id fabd_yrper fabd_accamt)
      no-lock
       where fabd_det.fabd_domain = global_domain and  fabd_fa_id   = i_fa_id
      and fabd_fabk_id   = i_fabk_id
      and fabd_yrper     = i_per:
      o_accdep = o_accdep + fabd_accamt.
   end. /* FOR EACH fabd_det */

   /* FOR THE BELOW MENTIONED REPORTS THE SUSPENDED PERIODS */
   /* WILL BE EXCLUDED WHEN CALCULATING PERIOD DEPRECIATION */
   if execname = "faderp.p"
      or execname = "faaorp.p"
   then do:
      for each fabd_det
         fields (fabd_domain   fabd_fa_id     fabd_fabk_id fabd_yrper
                 fabd_accamt   fabd_suspend fabd_peramt)
         where fabd_det.fabd_domain = global_domain
         and   fabd_fa_id           =  i_fa_id
         and   fabd_fabk_id         =  i_fabk_id
         and   fabd_suspend         =  yes
         and   fabd_yrper           <= i_per
         no-lock:

         l_fasuspend = l_fasuspend + fabd_peramt.

      end. /* FOR EACH fabd_det */

      o_accdep = o_accdep - l_fasuspend.

   end. /* IF execname */

END PROCEDURE . /* fa-get-accdep */

/********************************************************************/

/* SS - 090423.1 - B */
PROCEDURE fa-get-accdepa:

   /* THIS ROUTINE FINDS THE TOTAL ACCUMULATED DEPRECIATION FOR */
   /* A GIVEN PERIOD.                                           */
   /*                                                           */
   /* INPUT PARAMETERS                                          */
   /*  i_fa_id   - ASSET ID.                                    */
   /*  i_fabk_id - BOOK ID.                                     */
   /*  i_per     - PERIOD.                                      */
   /*                                                           */
   /* OUTPUT PARAMETERS                                         */
   /*  o_accdep - ACCUMULATED DEPRECIATION FOR THE PERIOD.      */

   define input  parameter i_fa_id   like fabd_fa_id   no-undo.
   define input  parameter i_fabk_id like fabd_fabk_id no-undo.
   define input  parameter i_per     like fabd_yrper   no-undo.
   define output parameter o_accdep  like fabd_accamt  no-undo.

   define variable l_fasuspend like fabd_accamt no-undo.

   /* SS - 090423.1 - B */
   DEFINE VARIABLE yrper LIKE fabd_yrper.

   yrper = "".
   /* SS - 090423.1 - E */

   for each fabd_det
      fields( fabd_domain fabd_fa_id fabd_fabk_id fabd_yrper fabd_accamt)
      no-lock
       where fabd_det.fabd_domain = global_domain and  fabd_fa_id   = i_fa_id
      and fabd_fabk_id   = i_fabk_id
      and fabd_yrper     = i_per
      /* SS - 090423.1 - B */
      BY fabd_yrper DESC
      /* SS - 090423.1 - E */
      :
      /* SS - 090423.1 - B
      o_accdep = o_accdep + fabd_accamt.
      SS - 090423.1 - E */
      /* SS - 090423.1 - B */
      IF yrper = "" THEN DO:
         yrper = fabd_yrper.
         o_accdep = o_accdep + fabd_accamt.
      END.
      ELSE DO:
         IF fabd_yrper = yrper THEN DO:
            o_accdep = o_accdep + fabd_accamt.
         END.
         ELSE DO:
            LEAVE.
         END.
      END.
      /* SS - 090423.1 - E */
   end. /* FOR EACH fabd_det */

   /* FOR THE BELOW MENTIONED REPORTS THE SUSPENDED PERIODS */
   /* WILL BE EXCLUDED WHEN CALCULATING PERIOD DEPRECIATION */
   if execname = "faderp.p"
      or execname = "faaorp.p"
      /* SS - 090423.1 - B */
      OR YES
      /* SS - 090423.1 - E */
   then do:
      for each fabd_det
         fields (fabd_domain   fabd_fa_id     fabd_fabk_id fabd_yrper
                 fabd_accamt   fabd_suspend fabd_peramt)
         where fabd_det.fabd_domain = global_domain
         and   fabd_fa_id           =  i_fa_id
         and   fabd_fabk_id         =  i_fabk_id
         and   fabd_suspend         =  yes
         and   fabd_yrper           <= i_per
         no-lock:

         l_fasuspend = l_fasuspend + fabd_peramt.

      end. /* FOR EACH fabd_det */

      o_accdep = o_accdep - l_fasuspend.

   end. /* IF execname */

END PROCEDURE . /* fa-get-accdep */
/* SS - 090423.1 - E */

/********************************************************************/

PROCEDURE fa-get-perdep:

   /* THIS ROUTINE FINDS THE TOTAL PERIOD DEPRECIATION FOR A    */
   /* PERIOD.                                                   */
   /*                                                           */
   /* INPUT PARAMETERS                                          */
   /*  i_fa_id   - ASSET ID.                                    */
   /*  i_fabk_id - BOOK ID.                                     */
   /*  i_per     - PERIOD.                                      */
   /*                                                           */
   /* OUTPUT PARAMETERS                                         */
   /*  o_perdep - PERIOD DEPRECIATION FOR THE PERIOD.           */

   define input  parameter i_fa_id   like fabd_fa_id   no-undo.
   define input  parameter i_fabk_id like fabd_fabk_id no-undo.
   define input  parameter i_per     like fabd_yrper   no-undo.
   define output parameter o_perdep  like fabd_accamt  no-undo.

   for each fabd_det
      fields( fabd_domain fabd_fa_id  fabd_fabk_id
              fabd_yrper  fabd_peramt fabd_suspend)
      no-lock
       where fabd_det.fabd_domain = global_domain and  fabd_fa_id   = i_fa_id
      and   fabd_fabk_id = i_fabk_id
      and   fabd_yrper   = i_per:
      o_perdep = o_perdep + fabd_peramt.

      /* FOR THE BELOW MENTIONED REPORTS THE SUSPENDED PERIODS */
      /* WILL BE EXCLUDED WHEN CALCULATING PERIOD DEPRECIATION */
      if (execname = "faderp.p"
          or execname = "faaorp.p")
         and fabd_suspend
      then
         o_perdep = o_perdep - fabd_peramt.

   end. /* FOR EACH fabd_det */

END PROCEDURE. /* fa-get-perdep */

/********************************************************************/

PROCEDURE fa-get-anndep:

   /* THIS ROUTINE FINDS THE TOTAL PERIOD DEPRECIATION FOR A    */
   /* PERIOD.                                                   */
   /*                                                           */
   /* INPUT PARAMETERS                                          */
   /*  i_fa_id   - ASSET ID.                                    */
   /*  i_fabk_id - BOOK ID.                                     */
   /*  i_beg_per - BEGINNING PERIOD.                            */
   /*  i_end_per - ENDING PERIOD.                               */
   /*                                                           */
   /* OUTPUT PARAMETERS                                         */
   /*  o_anndep - ANNUAL DEPRECIATION.                          */

   define input  parameter i_fa_id   like fabd_fa_id   no-undo.
   define input  parameter i_fabk_id like fabd_fabk_id no-undo.
   define input  parameter i_beg_per like fabd_yrper   no-undo.
   define input  parameter i_end_per like fabd_yrper   no-undo.
   define output parameter o_anndep  like fabd_accamt  no-undo.

   define variable v_beg_per    like fabd_yrper  no-undo.
   define variable v_end_per    like fabd_yrper  no-undo.
   define variable v_beg_accamt like fabd_accamt no-undo.
   define variable v_end_accamt like fabd_accamt no-undo.
   define variable l_fasuspend  like fabd_accamt no-undo.
   /* FIND BEGINNING ANNUAL DEPRECIATION */

   for last fabd_det
      fields( fabd_domain fabd_fa_id fabd_fabk_id fabd_yrper fabd_accamt)
      no-lock
       where fabd_det.fabd_domain = global_domain and  fabd_fa_id   = i_fa_id
      and   fabd_fabk_id = i_fabk_id
      and   fabd_yrper  <= i_beg_per:
      v_beg_per = fabd_yrper.
   end. /* FOR LAST fabd_det */

   /* FIND BEGINNING ANNUAL DEPRECIATION */
   for each fabd_det
      fields( fabd_domain fabd_fa_id fabd_fabk_id fabd_yrper fabd_accamt)
      no-lock
       where fabd_det.fabd_domain = global_domain and  fabd_fa_id = i_fa_id
      and fabd_fabk_id = i_fabk_id
      and fabd_yrper   = v_beg_per:
      v_beg_accamt = v_beg_accamt + fabd_accamt.
   end. /* FOR EACH fabd_det */

   for last fabd_det
      fields( fabd_domain fabd_fa_id fabd_fabk_id fabd_yrper fabd_accamt)
      no-lock
       where fabd_det.fabd_domain = global_domain and  fabd_fa_id   = i_fa_id
      and fabd_fabk_id   = i_fabk_id
      and fabd_yrper    >= i_beg_per
      and fabd_yrper    <= i_end_per:
      v_end_per = fabd_yrper.
   end. /* FOR LAST fabd_det */

   /* FIND ENDING ANNUAL DEPRECIATION */
   for each fabd_det
      fields( fabd_domain fabd_fa_id fabd_fabk_id fabd_yrper fabd_accamt)
      no-lock
       where fabd_det.fabd_domain = global_domain and  fabd_fa_id = i_fa_id
      and fabd_fabk_id = i_fabk_id
      and fabd_yrper = v_end_per:
      v_end_accamt = v_end_accamt + fabd_accamt.
   end. /* FOR EACH fabd_det */

   o_anndep = if (v_end_accamt - v_beg_accamt) < 0
              then
                 0
              else
                 (v_end_accamt - v_beg_accamt).

   /* FOR THE BELOW MENTIONED REPORTS THE SUSPENDED PERIODS */
   /* WILL BE EXCLUDED WHEN CALCULATING PERIOD DEPRECIATION */
   if execname = "faderp.p"
      or execname = "faaorp.p"
   then do:
      for each fabd_det
         fields (fabd_domain   fabd_fa_id     fabd_fabk_id fabd_yrper
                 fabd_accamt   fabd_suspend   fabd_peramt)
         where fabd_det.fabd_domain = global_domain
         and   fabd_fa_id           =  i_fa_id
         and   fabd_fabk_id         =  i_fabk_id
         and   fabd_yrper          >=  v_beg_per
         and   fabd_yrper          <= v_end_per
         and   fabd_suspend
         no-lock:

         l_fasuspend = l_fasuspend + fabd_peramt.

      end. /* FOR EACH fabd_det */

      o_anndep = if (o_anndep - l_fasuspend) < 0
                 then
                    0
                 else
                    (o_anndep - l_fasuspend).

   end. /* IF execname */

END PROCEDURE.  /* fa-get-anndep */

/********************************************************************/

PROCEDURE fa-get-cur-perdep:

   /* THIS ROUTINE FINDS THE TOTAL PERIOD DEPRECIATION SHOULD   */
   /* HAVE BEEN TAKEN FOR A PERIOD.                             */
   /*                                                           */
   /* INPUT PARAMETERS                                          */
   /*  i_fa_id   - ASSET ID.                                    */
   /*  i_fabk_id - BOOK ID.                                     */
   /*  i_per     - PERIOD.                                      */
   /*                                                           */
   /* OUTPUT PARAMETERS                                         */
   /*  o_perdep - PERIOD DEPRECIATION FOR THE PERIOD.           */

   define input  parameter i_fa_id   like fabd_fa_id   no-undo.
   define input  parameter i_fabk_id like fabd_fabk_id no-undo.
   define input  parameter i_per     like fabd_yrper   no-undo.

   define output parameter o_perdep  like fabd_accamt no-undo.

   for each fabd_det
      fields( fabd_domain fabd_fa_id fabd_fabk_id fabd_yrper fabd_peramt
      fabd_adj_yrper)
      no-lock
       where fabd_det.fabd_domain = global_domain and  fabd_fa_id   = i_fa_id
      and fabd_fabk_id   = i_fabk_id
      and fabd_yrper     = i_per
      and fabd_adj_yrper = i_per:
      o_perdep = o_perdep + fabd_peramt.
   end. /* FOR EACH fabd_det */

END PROCEDURE.  /* fa-get-cur-perdep */

/********************************************************************/

PROCEDURE fa-get-forecast-perdep:

   /* THIS ROUTINE FINDS THE FORECASTED DEPRECIATION FOR A      */
   /* PERIOD. THIS PROCEDURE IS SPECIFICALLY FOR UOP            */
   /* DEPRECIATION METHOD.                                      */
   /*                                                           */
   /* INPUT PARAMETERS                                          */
   /*  i_fa_id   - ASSET ID.                                    */
   /*  i_fabk_id - BOOK ID.                                     */
   /*  i_per     - PERIOD.                                      */
   /*                                                           */
   /* OUTPUT PARAMETERS                                         */
   /*  o_perdep - PERIOD DEPRECIATION FOR THE PERIOD.           */

   define input  parameter i_fa_id   like fauop_fa_id   no-undo.
   define input  parameter i_fabk_id like fauop_fabk_id no-undo.
   define input  parameter i_per     like fauop_yrper   no-undo.
   define output parameter o_perdep  like fabd_accamt   no-undo.

   for first fauop_det
      fields( fauop_domain fauop_fa_id fauop_fabk_id fauop_yrper fauop_upper)
      no-lock
       where fauop_det.fauop_domain = global_domain and  fauop_fa_id = i_fa_id
      and fauop_fabk_id = i_fabk_id
      and fauop_yrper   = i_per:

      for first fab_det
         fields( fab_domain fab_fa_id fab_fabk_id fab_upcost)
         no-lock
          where fab_det.fab_domain = global_domain and  fab_fa_id = i_fa_id
         and fab_fabk_Id = i_fabk_id:
         o_perdep = fauop_upper * fab_upcost.
      end.  /* FOR FIRST fab_det */
   end. /* FOR FIRST fauop_det */
END PROCEDURE. /* fa-get-forecast-perdep */

/********************************************************************/

PROCEDURE fa-get-forecast-anndep:

   /* THIS ROUTINE FINDS THE FORECASTED DEPRECIATION FOR A      */
   /* PERIOD. THIS PROCEDURE IS SPECIFICALLY FOR UOP            */
   /* DEPRECIATION METHOD.                                      */
   /*                                                           */
   /* INPUT PARAMETERS                                          */
   /*  i_fa_id   - ASSET ID.                                    */
   /*  i_fabk_id - BOOK ID.                                     */
   /*  i_beg_per - BEGINNING PERIOD.                            */
   /*  i_end_per - ENDING PERIOD.                               */
   /*                                                           */
   /* OUTPUT PARAMETERS                                         */
   /*  o_anndep - ANNUAL DEPRECIATION.                          */

   define input  parameter i_fa_id   like fauop_fa_id   no-undo.
   define input  parameter i_fabk_id like fauop_fabk_id no-undo.
   define input  parameter i_beg_per like fauop_yrper   no-undo.
   define input  parameter i_end_per like fauop_yrper   no-undo.
   define output parameter o_anndep  like fabd_accamt   no-undo.

   define variable v_beg_per   like fauop_yrper  no-undo.
   define variable v_end_per   like fauop_yrper  no-undo.
   define variable v_beg_accup like fabd_accamt  no-undo.
   define variable v_end_accup like fabd_accamt  no-undo.

   /* FIND BEGINNING ANNUAL DEPRECIATION */
   for first fauop_det
      fields( fauop_domain fauop_fa_id fauop_fabk_id fauop_yrper fauop_accup)
      no-lock
       where fauop_det.fauop_domain = global_domain and  fauop_fa_id = i_fa_id
      and fauop_fabk_id = i_fabk_id
      and fauop_yrper  >= i_beg_per
      and fauop_yrper   < i_end_per:
      v_beg_accup = fauop_accup.
   end. /* FOR FIRST fauop_det */

   for last fauop_det
      fields( fauop_domain fauop_fa_id fauop_fabk_id fauop_yrper fauop_accup)
      no-lock
       where fauop_det.fauop_domain = global_domain and  fauop_fa_id   = i_fa_id
      and fauop_fabk_id = i_fabk_id
      and fauop_yrper  >= i_beg_per
      and fauop_yrper   < i_end_per:
      v_end_accup = fauop_accup.
   end. /* FOR LAST fauop_det */

   for first fab_det
      fields( fab_domain fab_fa_id fab_fabk_id fab_upcost)
      no-lock
       where fab_det.fab_domain = global_domain and  fab_fa_id = i_fa_id
      and fab_fabk_Id = i_fabk_id:
      o_anndep = if (v_end_accup - v_beg_accup) < 0
                 then
                    0
                 else
                    (v_end_accup - v_beg_accup) * fab_upcost.
   end.  /* FOR FIRST fab_det */

END PROCEDURE.  /* fa-get-forecast-anndep */

/********************************************************************/

PROCEDURE fa-get-post:

   /* THIS ROUTINE FINDS IF DEPRECIATION FOR A GIVEN PERIOD IS  */
   /* POSTED.                                                   */
   /*                                                           */
   /* INPUT PARAMETERS                                          */
   /*  i_fa_id   - ASSET ID.                                    */
   /*  i_fabk_id - BOOK ID.                                     */
   /*  i_per     - PERIOD.                                      */
   /*                                                           */
   /* OUTPUT PARAMETERS                                         */
   /*  o_post - POST FALG.                                      */

   define input  parameter i_fa_id   like fabd_fa_id   no-undo.
   define input  parameter i_fabk_id like fabd_fabk_id no-undo.
   define input  parameter i_per     like fabd_yrper   no-undo.

   define output parameter o_post like fabd_post no-undo.

   o_post = can-find(first fabd_det
                      where fabd_det.fabd_domain = global_domain and
                      fabd_fa_id = i_fa_id
                     and fabd_fabk_id = i_fabk_id
                     and fabd_yrper   = i_per
                     and fabd_post    = yes).
END PROCEDURE.  /* fa-get-post */

/********************************************************************/

PROCEDURE fa-get-suspend:

   /* THIS ROUTINE FINDS IF DEPRECIATION FOR A GIVEN PERIOD IS  */
   /* SUSPENDED.                                                */
   /*                                                           */
   /* INPUT PARAMETERS                                          */
   /*  i_fa_id   - ASSET ID.                                    */
   /*  i_fabk_id - BOOK ID.                                     */
   /*  i_per     - PERIOD.                                      */
   /*                                                           */
   /* OUTPUT PARAMETERS                                         */
   /*  o_suspend - SUSPENDED FLAG.                              */

   define input  parameter i_fa_id   like fabd_fa_id   no-undo.
   define input  parameter i_fabk_id like fabd_fabk_id no-undo.
   define input  parameter i_per     like fabd_yrper   no-undo.

   define output parameter o_suspend like fabd_suspend no-undo.

   o_suspend = can-find(first fabd_det
                         where fabd_det.fabd_domain = global_domain and
                         fabd_fa_id = i_fa_id
                        and fabd_fabk_id = i_fabk_id
                        and fabd_yrper   = i_per
                        and fabd_suspend = yes).
END PROCEDURE.  /* fa-get-suspend */

/********************************************************************/

PROCEDURE fa-get-transfer:

   /* THIS ROUTINE FINDS IF A GIVEN PERIOD IS A TRANSFER        */
   /* PERIOD.                                                   */
   /*                                                           */
   /* INPUT PARAMETERS                                          */
   /*  i_fa_id   - ASSET ID.                                    */
   /*  i_fabk_id - BOOK ID.                                     */
   /*  i_per     - PERIOD.                                      */
   /*                                                           */
   /* OUTPUT PARAMETERS                                         */
   /*  o_transfer - TRANSFER FLAG.                              */

   define input  parameter i_fa_id   like fabd_fa_id   no-undo.
   define input  parameter i_fabk_id like fabd_fabk_id no-undo.
   define input  parameter i_per     like fabd_yrper   no-undo.

   define output parameter o_transfer like fabd_transfer no-undo.

   o_transfer = can-find(first fabd_det
                          where fabd_det.fabd_domain = global_domain and
                          fabd_fa_id  = i_fa_id
                         and fabd_fabk_id  = i_fabk_id
                         and fabd_yrper    = i_per
                         and fabd_transfer = yes).
END PROCEDURE.  /* fa-get-transfer */

/********************************************************************/

PROCEDURE fa-get-lastper:

   /* THIS ROUTINE FINDS THE LAST PERIOD OF REDUCED LIFE        */
   /*                                                           */
   /* INPUT PARAMETERS                                          */
   /*  i_fa_id   - ASSET ID.                                    */
   /*  i_fabk_id - BOOK ID.                                     */
   /*                                                           */
   /* OUTPUT PARAMETERS                                         */
   /*  o_final_yrper - LAST PERIOD.                             */

   define input  parameter i_fa_id       like fabd_fa_id   no-undo.
   define input  parameter i_fabk_id     like fabd_fabk_id no-undo.
   define output parameter o_final_yrper like fabd_yrper   no-undo.

   define variable v_per_total           like fabd_peramt  no-undo.

   for last fabd_det
      fields( fabd_domain fabd_fa_id fabd_fabk_id fabd_yrper)
       where fabd_det.fabd_domain = global_domain and  fabd_fa_id = i_fa_id
      and fabd_fabk_id = i_fabk_id
      no-lock:
      o_final_yrper = fabd_yrper.
   end. /* FOR LAST fabd_det */

   repeat:
      /* LIFE/PERIOD ADJUSTMENTS NULLIFY THE PERIOD DEPRECIATION  */
      /* AMOUNTS, WHEN REDUCED. HENCE, FIND THE LAST RECORD       */
      /* HAVING NON-ZERO PERIOD DEPRECIATION AMOUNT.              */

      run fa-get-perdep
         (input  i_fa_id,
          input  i_fabk_id,
          input  o_final_yrper,
          output v_per_total).

      if v_per_total <> 0
      then
         leave.
      else do:
         /* REDUCE YEAR/PERIOD */

         if integer(substring(o_final_yrper,5,2)) - 1 < 0
         then do:
            for last fabd_det
               fields( fabd_domain fabd_fa_id fabd_fabk_id fabd_yrper)
               where fabd_det.fabd_domain = global_domain
               and    fabd_fa_id   = i_fa_id
               and    fabd_fabk_id = i_fabk_id
               and    fabd_yrper   < o_final_yrper
               no-lock:
                  o_final_yrper = fabd_yrper.
            end. /* FOR LAST fabd_det */
            if not available fabd_det then leave.
         end. /* IF integer(substring(o_final_yrper ... */
         else
            /* REDUCE PERIOD ONLY */

            o_final_yrper = substring(o_final_yrper,1,4) +
                            string(integer(substring(o_final_yrper,5,2)) - 1,
                            "99").
      end. /* ELSE DO */
   end. /* REPEAT*/
END PROCEDURE.  /* fa-get-lastper */

/********************************************************************/

PROCEDURE fa-shortyear:

   /* THIS ROUTINE fa-shortyear PERFORMS TWO MAJOR TASKS.         */
   /* 1. RETURNS A LOGICAL VALUE INDICATING IF THE CALENDAR IS A  */
   /*    SHORT YEAR. YES IF SHORT NO OTHERWISE.                   */
   /* 2. IF IT IS A SHORTYEAR, IT CALCULATES THE MONTH FACTOR AND */
   /*    THE DAY FACTOR AND DETERMINES THE SHORT YEAR RATIO.      */
   /* INPUT PARAMETERS                                            */
   /*  i_per           - Period.                                  */
   /*  i_cal           - Calendar.                                */
   /*                                                             */
   /* OUTPUT PARAMETERS                                           */
   /*  o_short      - Short Year.                                 */
   /*  o_sratio     - Short Year Ratio.                           */

   define input  parameter  i_per           as   character   no-undo.
   define input  parameter  i_cal           as   character   no-undo.
   define output parameter  o_short         as   logical     no-undo.
   define output parameter  o_sratio        as   decimal     no-undo.

   define        variable v_daysinyr        as   integer     no-undo.
   define        variable v_mfactor         as   decimal     no-undo.
   define        variable v_dfactor         as   decimal     no-undo.
   define        variable v_dcalc           as   decimal     no-undo.
   define        variable v_yrbgn           as   integer     no-undo.
   define        variable v_yrend           as   integer     no-undo.
   define        variable v_mtbgn           as   integer     no-undo.
   define        variable v_mtend           as   integer     no-undo.
   define        variable v_dybgn           as   integer     no-undo.
   define        variable v_dyend           as   integer     no-undo.


   /* GET THE NUMBER OF DAYS IN THE GL/FA CALENDAR YEAR */
   /* AND IDENTIFY IF IT IS A SHORT YEAR                */

   run fa-get-daysinyr
      (input  i_per,
       input  i_cal,
       output v_daysinyr).

   /* A SHORT TAX YEAR IS A TAX YEAR OF MORE THAN 6 DAYS */
   /* BUT LESS THAN 359 DAYS */

   if v_daysinyr     >= 6
      and v_daysinyr <= 358
   then
      o_short = yes.

   /* GET THE YEAR,MONTH,DAY FROM THE BEGINNING AND ENDING */
   /* DATES OF THE YEAR FROM THE RESPECTIVE CALENDAR       */

   if o_short
   then do:
      case i_cal:
         when ""
         then do:
            for first glc_cal
               fields( glc_domain glc_year glc_start)
                where glc_cal.glc_domain = global_domain and  glc_year  =
                integer(substring(i_per,1,4))
               no-lock:

                assign
                   v_yrbgn = year(glc_start)
                   v_mtbgn = month(glc_start)
                   v_dybgn = day(glc_start).
            end. /* FOR FIRST glc_cal */

            for last glc_cal
                fields( glc_domain glc_year glc_end)
                 where glc_cal.glc_domain = global_domain and  glc_year  =
                 integer(substring(i_per,1,4))
                no-lock:

                assign
                   v_yrend = year(glc_end)
                   v_mtend = month(glc_end)
                   v_dyend = day(glc_end).
            end. /* FOR last glc_cal */

         end. /* WHEN "" */

         otherwise do:

            for first facld_det
                fields( facld_domain facld_facl_id facld_year facld_start)
                 where facld_det.facld_domain = global_domain and
                 facld_facl_id = i_cal
                and   facld_year    = integer(substring(i_per,1,4))
                no-lock:

                assign
                   v_yrbgn = year(facld_start)
                   v_mtbgn = month(facld_start)
                   v_dybgn = day(facld_start).
             end. /* FOR FIRST facld_det */


             for last facld_det
                fields( facld_domain facld_facl_id facld_year facld_end)
                 where facld_det.facld_domain = global_domain and
                 facld_facl_id = i_cal
                and   facld_year    = integer(substring(i_per,1,4))
                no-lock:

                assign
                   v_yrend = year(facld_end)
                   v_mtend = month(facld_end)
                   v_dyend = day(facld_end).
             end. /* FOR LAST facld_det */

         end. /* OTHERWISE DO */
      end case. /* i_cal */

      /* THE LOGIC BELOW DETERMINES THE FRACTION OF THE TAX YEAR TO */
      /* A FULL CALENDAR YEAR. FOLLOWING CALCULATIONS WILL GET      */
      /* THE SHORT YEAR RATIO                                       */
      /* MONTH FACTOR:                                              */
      /* IF YEAR OF THE 1ST PERIOD IN THE CALENDAR                  */
      /*         = YEAR OF LAST PERIOD THEN (MONTH OF LAST PERIOD   */
      /*                              - MONTH OF 1ST PERIOD ).      */
      /*             IF YEAR OF 1ST PERIOD < YEAR OF LAST PERIOD    */
      /*             THEN ((12 - MONTH OF 1ST PERIOD )              */
      /*                    + (MONTH OF LAST PERIOD).               */

      assign
         v_mfactor = if v_yrbgn = v_yrend
                     then
                        (v_mtend - v_mtbgn)
                     else
                        ((12 - v_mtbgn) + v_mtend)
         v_dcalc   = (v_dyend - v_dybgn).

   /* DAY FACTOR:                                                  */
   /* ((DAY WHICH ENDS THE LAST PERIOD OF THE SHORT YEAR CALENDAR) */
   /*   - (DAY WHICH BEGINS 1ST PERIOD OF SHORT YEAR CALENDAR))    */
   /* CALCULATION RESULT      DAY FACTOR                           */
   /* ------------------      ----------                           */
   /*           x <= -23        -1                                 */
   /*    -22 <= x <= -8         -0.5                               */
   /*     -7 <= x <=  7          0                                 */
   /*      8 <= x <=  22         0.5                               */
   /*           x >=  23         1                                 */
   /*                                                              */
   /* 5 SCENARIOS (EXAMPLES)                                       */
   /*    BEGIN YEAR  END YEAR  SHORTYEAR RATIO CALCULATION         */
   /*    ---------  --------- ------------------------------       */
   /* 1 01/01/01   10/31/01 (10 MONTH - 1 MONTH) = 9 MONTH FACTOR  */
   /*                       (31 - 01) = 30 (1 DAY FACTOR)          */
   /*                       SHORTYEAR RATIO = (9 + 1) / 12         */

   /* 2 07/15/01   03/15/02  ((12 - 7) + (3) ) = 8 MONTH FACTOR    */
   /*                        (15 - 15)  = 0 DAY (0 DAY FACTOR)     */
   /*                        SHORTYEAR RATIO = (8 + 0) / 12        */

   /* 3 01/25/01   09/15/01  (9 - 1)  = 8 MONTH FACTOR             */
   /*                        (15 - 25) = -10 DAY (-0.5 DAY FACTOR) */
   /*                        SHORTYEAR RATIO = (8 - 0.5) / 12      */

   /* 4 01/31/01   05/07/01  (5 - 1) = 4 MONTH FACTOR              */
   /*                        (07 - 31)  = -24 DAY (-1 DAY FACTOR)  */
   /*                        SHORTYEAR RATIO = (4 - 1) / 12        */

   /* 5 09/15/01   01/25/02  ((12 - 9) + (1) ) = 4 MONTH FACTOR    */
   /*                        (25 - 15) = 10 DAY (0.5 DAY FACTOR)   */
   /*                        SHORTYEAR RATIO = (8 + 0.5) / 12      */

      v_dfactor = if v_dcalc <= -23
                  then -1
                  else
                     if v_dcalc     >= -22
                        and v_dcalc <= -8
                     then -0.5
                     else
                        if v_dcalc     >= -7
                           and v_dcalc <=  7
                        then  0
                        else
                           if v_dcalc     >=  8
                              and v_dcalc <= 22
                           then  0.5
                           else 1.

     /* NUMERATOR OF FRACTION   : MONTH FACTOR + DAY FACTOR. */
     /* DENOMINATOR OF FRACTION : 12 MONTHS                  */
     /* o_sratio (FRACTION-SHORTYEAR RATIO)                  */
     /*    = ((MONTH FACTOR + DAY FACTOR)) / 12              */

      o_sratio = (v_mfactor + v_dfactor) / 12.

   end. /* END if o_short then do: */
   else
      o_sratio = 1.
END PROCEDURE. /* fa-shortyear */

/******************************************************************/


PROCEDURE fa-perinlife-short:

   /* THE FOLLOWING PROCEDURE CALCULATES AND RETURNS THE NUMBER  */
   /* OF PERIODS IN THE LIFE OF THE ASSET PLACED IN SHORT YEAR.  */
   /* THE CALCULATION IS DONE ONLY IF THE NEXT CALENDAR IS FULLY */
   /* DEFINED FOR THE BOOK OTHERWISE ERROR 4933 IS RETURNED.     */

   /*                                                            */
   /* INPUT PARAMETERS                                           */
   /*  i_utcall        - if 'yes' validate next calendar         */
   /*  i_per           - Period.                                 */
   /*  i_yrsinlife     - No of years in asset life               */
   /*  i_cal           - Calendar.                               */
   /*  i_actdays       - Actual Days.                            */
   /*  i_conv          - Convention.                             */
   /*  i_date          - Service Date.                           */
   /*                                                            */
   /* OUTPUT PARAMETERS                                          */
   /*  o_perinslife - Periods in short life.                     */

   define input  parameter i_utcall     as   logical         no-undo.
   define input  parameter i_per        as   character       no-undo.
   define input  parameter i_yrsinlife  as   decimal         no-undo.
   define input  parameter i_cal        as   character       no-undo.
   define input  parameter i_actdays    like famt_actualdays no-undo.
   define input  parameter i_conv       like famt_conv       no-undo.
   define input  parameter i_date       like fab_date        no-undo.

   define output parameter o_perinslife as   integer         no-undo.

   define variable v_daysinyr    as integer   no-undo.
   define variable v_perinrlife  as integer   no-undo.
   define variable v_perleftinyr as integer   no-undo.
   define variable v_leapyear    as logical   no-undo.

   /* GET THE NUMBER OF DAYS IN THE NEXT CALENDAR YEAR AND */
   /* ENSURE IT IS COMPLETELY DEFINED (NOT A SHORT YEAR)   */

   run fa-get-daysinyr
      (input  string(integer(substring(i_per,1,4)) + 1),
       input  i_cal,
       output v_daysinyr).

   run fa-get-leapyear
      (input  string(integer(substring(i_per,1,4)) + 1),
       input  i_cal,
       output v_leapyear).

   /* IF LEAP YEAR AND NOT 366 DAYS OR IF NOT A LEAP              */
   /* YEAR AND NOT 365 DAYS THEN RETURN ERROR NO 4933             */
   /* ERROR 4933: "CALENDAR # IS NOT FULLY DEFINED FOR NEXT YEAR" */
   /* THE FOLLOWING CHECK WILL BE IGNORED IF i_utcall IS no  i.e. */
   /* IF UTILITY utrgendp.p CALLS THIS PROCEDURE                  */

   if ((v_leapyear and v_daysinyr <> 366)
       or (not v_leapyear and v_daysinyr <> 365))
      and i_utcall
   then
      o_perinslife = 4933.
   else do:
      run fa-get-perinyr
         (input string(integer(substring(i_per,1,4)) + 1),
          input  i_cal,
          output v_perinrlife).

      run fa-get-perleftinyr
         (input i_per,
          input i_cal,
          output v_perleftinyr).

      o_perinslife = v_perleftinyr
                        + (v_perinrlife - v_perleftinyr)
                        + (v_perinrlife
                           * (i_yrsinlife - 1)).

      run fa-incr-last-period(input         i_actdays,
                              input         i_cal,
                              input         i_date,
                              input         i_conv,
                              input-output  o_perinslife).

   end. /* ELSE DO */
END PROCEDURE. /* fa-perinlife-short */


PROCEDURE fa-get-daysinyr:

   /* THIS ROUTINE GETS THE NUMBER OF DAYS IN A CALENDAR YEAR   */
   /*                                                           */
   /* INPUT PARAMETERS                                          */
   /*  i_per     - Period.                                      */
   /*  i_cal     - Calendar.                                    */
   /*                                                           */
   /* OUTPUT PARAMETERS                                         */
   /*  o_daysinyr - Total days in a year.                       */

   define input  parameter  i_per      as character no-undo.
   define input  parameter  i_cal      as character no-undo.
   define output parameter  o_daysinyr as integer   no-undo.

   case i_cal:
      when ""
      then do:
         for each glc_cal
            fields( glc_domain glc_year glc_start glc_end)
             where glc_cal.glc_domain = global_domain and  glc_year =
             integer(substring(i_per,1,4))
            no-lock:

            o_daysinyr = o_daysinyr + ((glc_end - glc_start) + 1).

         end. /* FOR EACH glc_cal */
      end. /* WHEN "" */

      otherwise do:
         for each facld_det
            fields( facld_domain facld_facl_id facld_year facld_end facld_start)
             where facld_det.facld_domain = global_domain and  facld_facl_id =
             i_cal
            and   facld_year    = integer(substring(i_per,1,4))
            no-lock:

            o_daysinyr = o_daysinyr
                         + ((facld_end - facld_start) + 1).
         end. /* FOR EACH facld_det */
      end. /* OTHERWISE DO */
   end case. /* i_cal */
END PROCEDURE. /* fa-get-daysinyr */


PROCEDURE fa-get-leapyear:

   /* THIS ROUTINE RETURNS TRUE IF THE YEAR IS A LEAP YEAR */
   /*                                                      */
   /* INPUT PARAMETERS                                     */
   /*  i_per     - Period.                                 */
   /*  i_cal     - Calendar.                               */
   /*                                                      */
   /* OUTPUT PARAMETERS                                    */
   /*  o_leapyear - Leap Year.                             */

   define input  parameter  i_per       as   character   no-undo.
   define input  parameter  i_cal       as   character   no-undo.
   define output parameter  o_leapyear  as   logical     no-undo.


   case i_cal:
      when ""
      then do:
         for first glc_cal
            fields( glc_domain glc_year glc_start glc_end)
             where glc_cal.glc_domain = global_domain and  glc_year         =
             integer(substring(i_per,1,4))
            and   month(glc_start) <= 2
            and   month(glc_end)   >= 2
            no-lock:

            o_leapyear = if (year(glc_start) modulo 4 = 0
                            or year(glc_end) modulo 4 = 0)
                         then yes else no.

         end. /* FOR FIRST glc_cal */
      end. /* WHEN "" */

      otherwise do:

         /* CHECK IF CALENDAR INCLUDES A LEAP YEAR PERIOD */
         for first facld_det
            fields( facld_domain facld_facl_id facld_year facld_start facld_end)
             where facld_det.facld_domain = global_domain and  facld_facl_id
               = i_cal
            and   facld_year         = integer(substring(i_per,1,4))
            and   month(facld_start) <= 2
            and   month(facld_end)   >= 2
            no-lock:

            o_leapyear = if (year(facld_start) modulo 4 = 0
                            or year(facld_end) modulo 4 = 0)
                         then yes
                         else no.

         end. /* FOR FIRST facld_det */
      end. /* OTHERWISE DO: */
   end case. /* i_cal */

END PROCEDURE. /* fa-get-leapyear */

PROCEDURE fa-chk-input-yrper:

   /* This routine checks if the input Year-Period is valid entry  */
   /*                                                              */
   /* INPUT PARAMETERS                                             */
   /*  i_per   - Input Year and Period in a calendar year.         */
   /*                                                              */
   /* OUTPUT PARAMETERS                                            */
   /*  o_error - Error Number.                                     */

   define input  parameter i_per   like fabd_yrper no-undo.
   define output parameter o_error as   integer    no-undo.

   o_error = if i_per = ""
             then
                /* BLANK NOT ALLOWED */
                40
             else
             if length(i_per) <> 6
             then
                /* INVALID PERIOD */
                495
             else
                0.

END PROCEDURE. /* fa-chk-input-yrper */

PROCEDURE fa-conv-per-to-date:

   /* This routine finds the start date for a given period and  */
   /* year                                                      */
   /*                                                           */
   /* INPUT PARAMETERS                                          */
   /*  i_calendar - Calendar.                                   */
   /*  i_per      - Year and Period in a calendar year.         */
   /*                                                           */
   /* OUTPUT PARAMETERS                                         */
   /*  o_date  - The Calendar start date.                       */
   /*  o_error - Error Number.                                  */

   define input  parameter i_calendar as   character    no-undo.
   define input  parameter i_per      like fabd_yrper   no-undo.
   define output parameter o_date     as   date         no-undo.
   define output parameter o_error    as   integer      no-undo.

   if i_calendar <> ""
   then do:
      for first facld_det
         fields( facld_domain facld_facl_id facld_start facld_year facld_per)
          where facld_det.facld_domain = global_domain and  facld_facl_id =
          i_calendar
           and facld_year    = integer(substring(i_per,1,4))
           and facld_per     = integer(substring(i_per,5,2))
         no-lock:

         assign
            o_date  = facld_start
            o_error = 0.

      end. /* FOR FIRST facld_det */

      if not available facld_det
      then
         /* DATE NOT WITHIN A VALID PERIOD */
         assign
            o_date  = ?
            o_error = 3018.

   end. /* IF i_calendar <> "" */
   else do:

      for first glc_cal
         fields( glc_domain glc_start glc_year glc_per)
          where glc_cal.glc_domain = global_domain and  glc_year =
          integer(substring(i_per,1,4))
           and glc_per  = integer(substring(i_per,5,2))
         no-lock:

         assign
            o_date  = glc_start
            o_error = 0.

      end. /* FOR FIRST glc_cal */

      if not available glc_cal
      then
         /* DATE NOT WITHIN A VALID PERIOD */
         assign
            o_date  = ?
            o_error = 3018.

   end. /* ELSE DO */

END PROCEDURE. /* fa-conv-per-to-date */

PROCEDURE fa-get-cost-asof-date:

   /* THIS ROUTINE RETURNS THE COST AS OF DATE */
   /*                                          */
   /* INPUT PARAMETERS                         */
   /*  i_faid    - Fixed Asset Id.             */
   /*  i_bkid    - Book Id.                    */
   /*  i_per     - Year/Period.                */
   /*  i_opbal   - Consider the Adjustment of  */
   /*              the input Year/Period.      */
   /*                                          */
   /* OUTPUT PARAMETERS                        */
   /*  o_cost    - Cost Of the Asset.          */

   define input  parameter  i_faid  as   character   no-undo.
   define input  parameter  i_bkid  as   character   no-undo.
   define input  parameter  i_per   as   character   no-undo.
   define input  parameter  i_opbal as   logical     no-undo.
   define output parameter  o_cost  as   decimal     no-undo.

   /* ACCUMULATE FOR ORIGINAL COST AMOUNT */
   for first fab_det
      fields( fab_domain fab_amt fab_fabk_id fab_fa_id fab_resrv)
       where fab_det.fab_domain = global_domain and  fab_fa_id       = i_faid
        and fab_fabk_id     = i_bkid
        and fab_resrv       = 0
      no-lock:
      o_cost = fab_amt.
   end. /* FOR FIRST fab_det */

   /* ACCUMULATE COST ADJUSTMENT AS OPENING BALANCE      */
   /* FOR THE INPUT YR/PERIOD ALONG WITH PRIOR YR/PERIOD */
   /*         OR                                         */
   /* JUST FOR THE PREVIOUS YR/PERIOD.                   */
   /* YES = OPENING BALANCE ONLY.                        */
   /* NO  = INCLUDE YEAR/PERIOD.                         */
   for each fab_det
      fields( fab_domain fab_amt fab_fabk_id fab_fa_id fab_resrv
             fab_cst_adjper)
       where fab_det.fab_domain = global_domain and  fab_fa_id          = i_faid
        and fab_fabk_id        = i_bkid
        and (if i_opbal
             then
                fab_cst_adjper < i_per
             else
                fab_cst_adjper <= i_per)
        and fab_amt            <> 0
        and fab_resrv          <> 0
      no-lock:
      o_cost = o_cost + fab_amt.
   end. /* FOR EACH fab_det */

END PROCEDURE. /* fa-get-cost-asof-date:  */

PROCEDURE fa-get-perdep-range:

   /* THIS ROUTINE RETURNS THE TOTAL PERIOD DEPRECIATION        */
   /* FOR A YEAR/PERIOD RANGE.                                  */
   /*                                                           */
   /* INPUT PARAMETERS                                          */
   /*  i_fa_id   - Fixed Asset ID.                              */
   /*  i_fabk_id - Book ID.                                     */
   /*  i_per     - From Year/Period.                            */
   /*  i_per1    - To Year/Period.                              */
   /*                                                           */
   /* OUTPUT PARAMETERS                                         */
   /*  o_perdep - Total Period Depreciation for the             */
   /*             Year/Period range.                            */

   define input  parameter i_fa_id   as character no-undo.
   define input  parameter i_fabk_id as character no-undo.
   define input  parameter i_per     as character no-undo.
   define input  parameter i_per1    as character no-undo.
   define output parameter o_perdep  as decimal   no-undo.

   for each fabd_det
      fields( fabd_domain fabd_fa_id  fabd_fabk_id
              fabd_yrper  fabd_peramt fabd_suspend)
       where fabd_det.fabd_domain = global_domain and  fabd_fa_id   =  i_fa_id
        and fabd_fabk_id =  i_fabk_id
        and (fabd_yrper  >= i_per and
             fabd_yrper  <= i_per1)
      no-lock:
      o_perdep = o_perdep + fabd_peramt.

      /* FOR THE BELOW MENTIONED REPORTS THE SUSPENDED PERIODS */
      /* WILL BE EXCLUDED WHEN CALCULATING PERIOD DEPRECIATION */
      if (execname = "faderp.p"
          or execname = "faaorp.p")
         and fabd_suspend
      then
         o_perdep = o_perdep - fabd_peramt.

   end. /* FOR EACH fabd_det */

END PROCEDURE. /* fa-get-perdep-range */

PROCEDURE fa-incr-last-period:

   /* THIS ROUTINE INCREMENTS NUMBER OF PERIODS IN ASSET LIFE      */
   /* BY 1 BASED ON CONVENTION, ACTUAL DAYS FLAG AND SERVICE DATE. */
   /*                                                              */
   /* INPUT PARAMETERS                                             */
   /*  i_actdays - Actual Days.                                    */
   /*  i_cal     - Calendar.  Blank means GL Calendar.             */
   /*  i_date    - Service Date.                                   */
   /*  i_conv    - Convention.                                     */
   /*                                                              */
   /* INPUT-OUTPUT PARAMETERS                                      */
   /*  o-perinlife - Total Period Based on Service Date            */

   define input  parameter i_actdays   like famt_actualdays no-undo.
   define input  parameter i_cal       as   character       no-undo.
   define input  parameter i_date      like fab_date        no-undo.
   define input  parameter i_conv      like famt_conv       no-undo.

   define input-output parameter o-perinlife as integer     no-undo.

   if i_actdays
   then do:

      case i_cal:
         when ""
         then
            o-perinlife = if can-find (first glc_cal
                                        where glc_cal.glc_domain =
                                        global_domain and  glc_start <= i_date
                                       and   glc_end   >= i_date
                                       and   glc_start <> i_date)
                          then
                             (o-perinlife + 1)
                          else
                             o-perinlife.

         otherwise
            o-perinlife = if can-find (first facld_det
                                        where facld_det.facld_domain =
                                        global_domain and  facld_facl_id = i_cal
                                       and   facld_start  <= i_date
                                       and   facld_end    >= i_date)

                          then
                             (o-perinlife + 1)
                          else
                             o-perinlife.

      end case. /* CASE i_cal */
   end. /* IF i_actdays */
   else
      if (i_conv = "2"
      or  i_conv = "3")
      then
         o-perinlife = o-perinlife + 1.

END PROCEDURE. /* fa-incr-last-period */

PROCEDURE fa-get-post-class:

   /* THIS ROUTINE RETURNS A YES IF THE BOOK   */
   /* ATTACHED TO THE CLASS IS A POSTING BOOK  */
   /*                                          */
   /* INPUT PARAMETERS                         */
   /*  i_clsid    - Class Id.                  */
   /*                                          */
   /* OUTPUT PARAMETERS                        */
   /*  o_post    - Posting Book.               */

   define input  parameter  i_clsid  like fa_facls_id   no-undo.
   define output parameter  o_post   like mfc_logical   no-undo.

   for each fadf_mstr
       where fadf_mstr.fadf_domain = global_domain and  fadf_facls_id = i_clsid
      no-lock:
      o_post = (can-find (first fabk_mstr
                           where fabk_mstr.fabk_domain = global_domain and
                           fabk_id   = fadf_fabk_id
                          and   fabk_post = yes)).

      if o_post then leave.
   end. /* FOR EACH fadf_mstr */

END PROCEDURE. /* fa-get-post-class */

PROCEDURE fa-get-onlytransfer:

   /* THIS ROUTINE FINDS IF A GIVEN PERIOD IS A SUSPENDED, */
   /* TRANSFERRED AND POSTED PERIOD.                       */
   /*                                                      */
   /* INPUT PARAMETERS                                     */
   /*  p_fa_id   - ASSET ID.                               */
   /*  p_fabk_id - BOOK ID.                                */
   /*  p_per     - PERIOD.                                 */
   /*                                                      */
   /* OUTPUT PARAMETERS                                    */
   /*  p_onlytransfer - POST FLAG FOR THE SUSPENDED AND    */
   /*                   TRANSFERRED ASSET.                 */

   define input  parameter p_fa_id        like fabd_fa_id   no-undo.
   define input  parameter p_fabk_id      like fabd_fabk_id no-undo.
   define input  parameter p_per          like fabd_yrper   no-undo.

   define output parameter p_onlytransfer like fabd_transfer no-undo.

   p_onlytransfer = can-find(first fabd_det
                                 where fabd_det.fabd_domain = global_domain and
                                  fabd_fa_id  = p_fa_id
                                and fabd_fabk_id  = p_fabk_id
                                and fabd_yrper    = p_per
                                and fabd__qadl01  = yes).

END. /* PROCEDURE fa-get-onlytransfer */
