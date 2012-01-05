/* GUI CONVERTED from resqmta.p (converter v1.78) Fri Oct 29 14:37:53 2004 */
/* resqmta.p - Sequence Maintenance -Sub Program Calculate qty Required       */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.19 $                                                              */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.0    LAST MODIFIED: 10/15/91     BY: smm *F230*                */
/* REVISION: 7.0    LAST MODIFIED: 04/07/92     BY: smm *F364*                */
/* REVISION: 7.0    LAST MODIFIED: 05/16/92     BY: emb *F531*                */
/* REVISION: 7.3    LAST MODIFIED: 12/08/92     BY: emb *G468*                */
/* REVISION: 7.3    LAST MODIFIED: 01/07/93     BY: emb *G524*                */
/* REVISION: 7.3    LAST MODIFIED: 01/04/94     BY: pxd *FL16*                */
/* REVISION: 7.3    LAST MODIFIED: 03/30/94     BY: pma *FN17*                */
/* REVISION: 7.3    LAST MODIFIED: 01/04/95     BY: pxd *F0CR*                */
/* REVISION: 7.2    LAST MODIFIED: 04/10/95     BY: ais *F0Q2*                */
/* REVISION: 7.3    LAST MODIFIED: 12/04/95     BY: jym *F0WF*                */
/* REVISION: 7.3    LAST MODIFIED: 09/12/97     BY: *G2PJ* Felcy D'Souza      */
/* REVISION: 8.5    LAST MODIFIED: 12/10/97     BY: *J1R2* Julie Milligan     */
/* REVISION: 8.6    LAST MODIFIED: 05/20/98     BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6    LAST MODIFIED: 07/30/98     BY: *J2TH* Sandesh Mahagaokar */
/* REVISION: 9.0    LAST MODIFIED: 01/29/98     BY: *M066* John Pison         */
/* REVISION: 9.0    LAST MODIFIED: 03/13/99     BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1    LAST MODIFIED: 08/12/00     BY: *N0KP* myb                */
/* REVISION: 9.1    LAST MODIFIED: 09/11/00     BY: *N0RS* Mudit Mehta        */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.16   BY: Rajesh Thomas           DATE: 05/01/01 ECO: *M15B*    */
/* Revision: 1.17  BY: Amit Chaturvedi DATE: 08/06/02 ECO: *N1P3* */
/* $Revision: 1.19 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00K* */
/* $Revision: 1.19 $ BY: Mage chen (SB) DATE: 06/28/03 ECO: *ts* */

/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/* be added.  The ECO marker should only be included in the Revision History. */

/******************************************************************************/

{mfdeclre.i} /* SHARED VARIABLE INCLUDE */
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* IF YES THEN WILL SHOW ERROR MESSAGES TO USER */
define input parameter p-show-messages as logical no-undo.

define shared variable shopcal_recno as   recid.
define shared variable prline        like seq_line.
define shared variable site          like seq_site.
define shared variable amt_seq       like seq_qty_req.
define shared variable temp_rel      like seq_due_date.
define shared variable part          like seq_part.
define shared variable sequence      like seq_priority.
define shared variable lnd_recno     as   recid.
define shared variable qtyreq        like seq_qty_req.
define shared variable done_division like mfc_logical.
define shared variable use_detail    like mfc_logical.
define shared variable rptrel        like seq_due_date.
define shared variable leftover      like mfc_logical.
define shared variable shft_amt      as   decimal decimals 2 extent 4.
define shared variable hours         as   decimal extent 4.
define shared variable cap           as   decimal extent 4.
define shared variable line_rate     like lnd_rate.
define shared variable undo-input    like mfc_logical.
define shared variable multiple      as   decimal.
define        variable qtyall        like rps_qty_req       no-undo.
define        variable last_rate     like lnd_rate          no-undo.
define        variable total_hours   like seq_qty_req       no-undo.
define        variable extra         like mfc_logical       no-undo.
define        variable increment     as   integer           no-undo.
define        variable decrement     like seq_qty_req       no-undo.
define        variable found_date    like mfc_logical       no-undo.
define        variable consumed      like mfc_logical       no-undo.
define        variable checkdate     like temp_rel          no-undo.
define        variable ii            as   integer           no-undo.
define        variable check_date    as   date              no-undo.
define        variable yn            like mfc_logical       no-undo.
define        variable l_totcap      as   decimal initial 0 no-undo.
define        variable l_totshiftqty as   decimal initial 0 no-undo.
define        buffer   seq1          for  seq_mstr.
define        buffer   lnddet        for  lnd_det.

undo-input = yes.

if cap[1] = 0
and cap[2] = 0
and cap[3] = 0
and cap[4] = 0
then do:

   /* FIND CAPACITY OF LINE BY LOOKING UP SHIFT FILE */
   assign
      qtyall      = 0
      total_hours = 0
      cap         = 0
      hours       = 0
      shft_amt    = 0.

   {recaldt.i temp_rel shopcal_recno}

   {recalcap.i &date=temp_rel}

   if cap[1] = 0
   and cap[2] = 0
   and cap[3] = 0
   and cap[4] = 0
   then do:

      repeat:
/*GUI*/ if global-beam-me-up then undo, leave.


         if p-show-messages = yes
         then do:

            hide message no-pause.
            /* ZERO CAPACITY DEFINED FOR SCHEDULING */
            {pxmsg.i &MSGNUM=403 &ERRORLEVEL=4}
            hide message.
         end. /* IF p-show-messages = yes THEN DO: */

         leave.
      end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* REPEAT */
      leave.
   end. /* IF cap[1] = 0 ..... */
   if temp_rel - check_date > 7
   then do:

      if p-show-messages = yes
      then do:

         hide message no-pause.
         /* ZERO CAPACITY DEFINED FOR NEXT # DAYS */
         {pxmsg.i &MSGNUM=404 &ERRORLEVEL=2
                  &MSGARG1=temp_rel - check_date}
         /* DO YOU WISH TO CONTINUE */
         {pxmsg.i &MSGNUM=8500 &ERRORLEVEL=1 &CONFIRM=yn
                  &CONFIRM-TYPE='LOGICAL'}
         if yn = no
         then
            leave.
      end. /* IF p-show-messages = yes THEN DO: */
   end. /* IF temp_rel - check_date > 7 */

end. /* IF cap[1] = 0 */

line_rate = 0.

for last lnd_det
   fields( lnd_domain lnd_line lnd_part lnd_rate lnd_site lnd_start)
    where lnd_det.lnd_domain = global_domain and  lnd_line  =  prline
     and lnd_site  =  site
     and lnd_part  =  part
     and lnd_start <= temp_rel
   no-lock:
end. /* FOR LAST lnd_det */

if available lnd_det
and lnd_rate <> 0
then
   line_rate = lnd_rate.

else do:

   for first ln_mstr
      fields( ln_domain ln_line ln_rate ln_site)
       where ln_mstr.ln_domain = global_domain and  ln_site = site
        and ln_line = prline
      no-lock:

      line_rate = ln_rate.
   end. /* FOR FIRST ln_mstr */
end. /* ELSE DO,  IF AVAILABLE lnd_det */

if line_rate = 0
then do:

   find next lnd_det no-lock
       where lnd_det.lnd_domain = global_domain and  lnd_line  = prline
        and lnd_site  = site
        and lnd_part  = part
        and lnd_start <> ?
        and lnd_rate  > 0 no-error.
   if available lnd_det
   then do:

      if p-show-messages = yes
      then do:

         hide message no-pause.
         /* ITEM HAS ZERO PRODUCTION RATE DEFINED */
         {pxmsg.i &MSGNUM=405 &ERRORLEVEL=2
            &MSGARG1=part
            &MSGARG3=" getTermLabel(""UNTIL"",5) + "" ""  +
                       string(lnd_start) "}
         /* DO YOU WISH TO CONTINUE */
         {pxmsg.i &MSGNUM=8500 &ERRORLEVEL=1 &CONFIRM=yn
                  &CONFIRM-TYPE='LOGICAL'}
         if yn = no
         then
            leave.
      end. /* IF p-show-messages = yes THEN DO: */
      temp_rel = lnd_start - 1.
   end. /* IF AVAILABLE lnd_det */
   else do:

      if p-show-messages = yes
      then do:

         hide message no-pause.
         /* ITEM HAS ZERO PRODUCTION RATE DEFINED */
         {pxmsg.i &MSGNUM=405 &ERRORLEVEL=4 &MSGARG1=part}
         hide message.
      end. /* IF p-show-messages = yes THEN DO: */

      leave.
   end. /* ELSE DO, IF AVAILABLE lnd_det */
end. /* IF line_rate = 0 */

/* ACCUMULATE CAPACITY IN ALL SHIFTS, FIND TOTAL SHIFT QUANTITY,  */
/* ROUND THIS QUANTITY FOR ORDER MULTIPLE AND LOAD IN EACH SHIFT. */

assign
   l_totcap      = cap[1] + cap[2] + cap[3] + cap[4]
   l_totshiftqty = min(l_totcap * line_rate,qtyreq).

if multiple > 0
then
   l_totshiftqty = truncate((l_totshiftqty / multiple),0) * multiple.

assign
   amt_seq = l_totshiftqty
   shft_amt = 0.

do ii = 1 to 4:

   if cap[ii] * line_rate >  0
   then do:

      assign
         shft_amt[ii]  = min(cap[ii] * line_rate,l_totshiftqty)
         l_totshiftqty = l_totshiftqty - shft_amt[ii].

      if shft_amt[ii] > 0
      then
         assign
            qtyreq    = qtyreq - shft_amt[ii]
            /* TO UTILISE FULL AVAILABLE CAPACITY */
            hours[ii] = hours[ii]
                      * (1 - (shft_amt[ii] / (line_rate * cap[ii])))
            cap[ii]   = cap[ii] - shft_amt[ii] / line_rate.

      /* INITIALIZE THE CAP[II] TO ZERO WHEN SHIFT CAPACITY IS LESS    */
      /* THAN ONE AND THE MULTIPLE IS SET TO ZERO.                     */

      if ( cap[ii] > 0
      and (cap[ii] * line_rate) < (if multiple = 0
                                   then
                                      1
                                   else
                                      multiple)
      and qtyreq > 0 )
       or ( cap[ii] < 0 )
      then
         cap[ii] = 0.

   end. /* IF cap[ii] * line_rate >  0 */
   else
      cap[ii] = 0.
end. /* DO ii = 1 TO 4 */

undo-input = no.
