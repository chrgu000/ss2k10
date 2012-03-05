/* fapl.p - Fixed Assets procedure library                                    */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.14 $                                                          */
/*V8:ConvertMode=NoConvert                                                    */
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
/* $Revision: 1.14 $      BY: Rajesh Lokre        DATE: 04/03/03  ECO: *M1RX* */
/* $Revision: 1.14 $      BY: Rajesh Lokre        DATE: 03/23/06  ECO: *SS - 20060323* */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/******************************************************************************/

/* THIS ROUTINE ENCAPSULATES FUNCTIONS USED IN THE FIXED ASSETS MODULE.  EACH */
/* FUNCTION IS IMPLEMENTED BELOW AS AN INTERNAL PROCEDURE.  THIS PROCEDURE    */
/* LIBRARY ROUTINE IS INTENDED TO BE RUN PERSISTENT WITHIN THE FIXED ASSETS   */
/* APPLICATION.  THE RECOMMENDED METHOD FOR INSTANTIATING THE PERSISTENT      */
/* PROCEDURE AND CALLING THE VARIOUS INTERNAL PROCEDURES IS THROUGH USE OF    */
/* gprunp.i.                                                                  */

/* MAIN PROCEDURE BODY IS EMPTY */

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


/********************************************************************/

PROCEDURE fa-get-accdep-a:

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

   DEFINE VARIABLE yrper LIKE fabd_yrper.

   yrper = "".
   for each fabd_det
      fields (fabd_fa_id fabd_fabk_id fabd_yrper fabd_accamt)
      no-lock
      where fabd_fa_id   = i_fa_id
      and fabd_fabk_id   = i_fabk_id
      and fabd_yrper     <= i_per
      BY fabd_yrper DESC
      :
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
   end. /* FOR EACH fabd_det */
END PROCEDURE . /* fa-get-accdep */

/********************************************************************/
