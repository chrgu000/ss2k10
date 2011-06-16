/* mfrtrail.i - REPORT TRAILER INCLUDE FILE                                   */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.25 $                                                          */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 1.0     Created  : 03/13/86    BY: EMB                           */
/* REVISION: 4.0     LAST EDIT: 03/03/89    BY: WUG *B060*                    */
/* REVISION: 5.0     LAST EDIT: 06/29/89    BY: emb *B164*                    */
/* REVISION: 5.0     LAST EDIT: 02/15/90    BY: WUG *B569*                    */
/* REVISION: 5.0     LAST EDIT: 05/23/90    BY: emb *B695*                    */
/* REVISION: 7.3     LAST EDIT: 03/23/95    BY: jzs *G0FB*                    */
/* REVISION: 7.3     LAST EDIT: 02/04/96    BY: dzn *G1KT*                    */
/* REVISION: 8.5     LAST EDIT: 11/04/96    BY: *J17M* Cynthia J. Terry       */
/* REVISION: 8.6     LAST EDIT: 09/17/97    BY: kgs *K0J0*                    */
/* REVISION: 8.6E    LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane           */
/* REVISION: 8.6E    LAST EDIT: 05/17/98    BY: *K1Q4* Mohan CK               */
/* REVISION: 8.6E    LAST EDIT: 05/28/98    BY: *K1QW* Mohan CK               */
/* REVISION: 8.6E    LAST EDIT: 10/04/98    BY: *J314* Alfred Tan             */
/* REVISION: 9.0     LAST EDIT: 01/12/99    BY: *J372* Raphael Thoppil        */
/* REVISION: 9.0     LAST EDIT: 03/13/99    BY: *M0BD* Alfred Tan             */
/* REVISION: 9.1     LAST EDIT: 09/29/99    BY: *J3LV* A. Philips             */
/* REVISION: 9.1     LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane      */
/* REVISION: 9.1     LAST MODIFIED: 08/13/00 BY: *N0KR* myb                   */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.22    BY: Katie Hilbert  DATE: 03/07/01 ECO: *N0XB*            */
/* Revision: 1.23    BY: Falguni Dalal  DATE: 09/24/01 ECO: *N12X*            */
/* Revision: 1.24    BY: A.R. Jayaram   DATE: 01/18/02 ECO: *N183*            */
/* $Revision: 1.25 $   BY: Manisha Sawant DATE: 06/03/02 ECO: *N1KF*            */
/* $Revision: 1.27 $ BY: Bill Jiang DATE: 02/28/07 ECO: *SS - 20070228.1* */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/************************************************************************/
/*!
    {1} "stream name"    if necessary
*/
/************************************************************************/

/*! GUI cannot do a VIEW FRAME A to get the criteria fields printed to
*   the trailer, so V8 has some extra code to do this by looping thru
*   all widgets (fields) in frame a.
*/
/*V8!
     define variable criteria as character.
     define variable criteria-column as integer.
*/
define variable tmp_batch_id like bcd_det.bcd_batch.
define variable c-end-report as character format "x(17)" no-undo.
define variable c-rpt-crit   as character format "x(21)" no-undo.
define variable c-rpt-sub    as character format "x(26)" no-undo.

define variable l_execname   like execname               no-undo.

assign
   c-end-report = getTermLabel("END_OF_REPORT",17)
   c-rpt-crit = getTermLabel("REPORT_CRITERIA",20) + ":"
   c-rpt-sub = getTermLabel("REPORT_SUBMITTED_BY",25) + ":".

{wbgp03.i}
if c-application-mode <> 'WEB' or
  (c-application-mode = 'WEB' and
   c-web-request begins 'DATA')
then do:
   repeat:
      /* SS - 20070228.1 - B */
      /*
      display
         {1} skip(1)
         c-end-report no-label at 60
      with frame rfoot width 132.
      if line-counter > 7 then do:
         page {1}.
      end.
      display
         {1} skip(3)
         c-rpt-crit no-label
         space(19)
         c-rpt-sub no-label
         report_userid no-label
         /*V8!       skip(1) */
         .
      */
      /* SS - 20070228.1 - E */

      /* COMPILE TIME CODE ADDED TO DISPLAY BATCH IN REPORT */
      /* TRAILER                                            */
      &IF defined(BATCHID) &THEN
         if batchrun then
         do:

            l_execname = execname.

            /*V8!
            l_execname = substring(execname,7,length(execname,"RAW"),"RAW").
            */

            for first qad_wkfl
               fields(qad_key1 qad_key2 qad_key3)
               where qad_key1 = l_execname
               and   qad_key2 = mfguser no-lock:
            end.
            if available(qad_wkfl) then
               {&BATCHID} = qad_wkfl.qad_key3.
            /* SS - 20070228.1 - B */
            /*
            /*V8-*/
            display {1} {&BATCHID} to 77 with frame a.
            /*V8+*/
            */
            /* SS - 20070228.1 - E */
         end.
      &ENDIF

      /* SS - 20070228.1 - B */
      /*
      /*V8-*/
      view {1} frame a.
      /*V8+*/
      */
      /* SS - 20070228.1 - E */
      /*V8!
      /* Print all report criteria from frame a */
      local-handle = frame a:first-child.      /* field group */
      local-handle = local-handle:first-child. /* first widget */
      repeat while local-handle <> ?:

         if local-handle:type = "fill-in"
         then do:
            &IF DEFINED(BATCHID) &THEN
               if  batchrun and local-handle:name = "batch_id" then
                  local-handle:screen-value = {&BATCHID}.
            &ENDIF
            criteria-prt = if local-handle:labels then
                              local-handle:label + ": "
                            + local-handle:screen-value
                           else local-handle:screen-value.
            criteria-prt-column = if local-handle:labels then
                                     max(1,(local-handle:column -
                                     length(local-handle:label, "raw")))
                                  else local-handle:column.
            put {1} unformatted
               criteria-prt
            at criteria-prt-column.  /* Print widget's current value */
         end.
         local-handle = local-handle:next-sibling.
      end.  /* repeat */
      */

      leave.
   end.
end.
{mfreset.i {1}}
{pxmsg.i &MSGNUM=9 &ERRORLEVEL=1}
/*end mfrtrail.i*/
