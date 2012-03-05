/* relsrp.i - DISPLAY LOGIC FOR REPETITIVE SCHEDULE REPORT                    */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.7 $                                                           */
/*V8:ConvertMode=FullGUIReport                                                */
/* REVISION: 9.1         CREATED: 06/07/99   BY: *N005* Luke Pokic            */
/* REVISION: 9.1   LAST MODIFIED: 08/12/00   BY: *N0KP* myb                   */
/* Revision: 1.5  BY: Saurabh C. DATE: 02/07/02 ECO: *N18M* */
/* $Revision: 1.7 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00K* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/******************************************************************************/
/*!
SEARCH THROUGH FILE rps_mstr AND lnd_det FOR GIVEN SELECTION CRITERION AND
SORTING ORDER {1} FOR FIELD lnd_run_seq1, AND {2} FOR FIELD lnd_run_seq2.
*/

/*!
INPUT PARAMETERS:
{1} " " or descending (WHICHEVER ENTERED FOR PRIMARY RUN SEQUENCE SORTING ORDER)
{2} " " or descending (WHICHEVER ENTERED FOR SECONDARY RUN SEQUENCE SORTING
                       ORDER)
*/
/******************************************************************************/

/* SS - 100818.1 By: Bill Jiang */

/* RECORD RETREIVING AND DISPLAY LOGIC  */
for each rps_mstr
   fields( rps_domain rps_due_date rps_line rps_part rps_qty_req
           rps_qty_comp rps_rel_date rps_site)
   use-index rps_site_line
    where rps_mstr.rps_domain = global_domain and  rps_site     >= site
     and rps_site     <= site1
     and rps_line     >= prline
     and rps_line     <= prline1
     and rps_rel_date >= release_date
     and rps_rel_date <= release_date1
   no-lock,

      last lnd_det
         fields( lnd_domain lnd_line lnd_part lnd_run_seq1 lnd_run_seq2
         lnd_site lnd_start)
      no-lock
          where lnd_det.lnd_domain = global_domain and  lnd_site      = rps_site
           and lnd_line      = rps_line
           and lnd_part      = rps_part
           and lnd_start    <= rps_rel_date
   /* SS - 100818.1 - B
           and lnd_run_seq1 >= primary_seq
           and lnd_run_seq1 <= primary_seq1
           and lnd_run_seq2 >= secondary_seq
           and lnd_run_seq2 <= secondary_seq1
   SS - 100818.1 - E */

         break by rps_site
         by rps_line
         by rps_rel_date
         by lnd_run_seq1 {1}
         by lnd_run_seq2 {2}
         by lnd_part
         by rps_due_date
         :

   for first ln_mstr
      fields( ln_domain ln_site ln_line ln_desc)
       where ln_mstr.ln_domain = global_domain and  ln_site = rps_site
        and ln_line = rps_line
      no-lock:
   end. /* FOR FIRST ln_mstr */

   /* SS - 100818.1 - B
   form header
      l_site
      ln_site
      l_line
      ln_line
      ln_desc
   with frame top with no-label page-top width 132.

   view frame top.

   if first-of(rps_line)
      and not first(rps_line)
   then
      page.
   SS - 100818.1 - E */

   for first pt_mstr
      fields( pt_domain pt_desc1 pt_desc2 pt_part)
       where pt_mstr.pt_domain = global_domain and  pt_part = lnd_part
      no-lock:
   end. /* FOR FIRST pt_mstr */

   open_qty = rps_qty_req - rps_qty_comp.

   /* SS - 100818.1 - B
   display
      rps_part
      pt_desc1
      rps_rel_date
      rps_due_date
      lnd_run_seq1
      lnd_run_seq2
      rps_qty_req
      rps_qty_comp
      open_qty
   with frame b.

   down 1  with frame b.

   if pt_desc2 <> ""
   then do:
      display
         pt_desc2 @ pt_desc1
      with frame b.

      down 1 with frame b.
   end. /* IF pt_desc2 <> "" */
   SS - 100818.1 - E */
   /* SS - 100818.1 - B */
   CREATE ttxxrelsrp0001.
   ASSIGN
      ttxxrelsrp0001_rps_site = rps_site
      ttxxrelsrp0001_rps_line = rps_line
      ttxxrelsrp0001_rps_part = rps_part
      ttxxrelsrp0001_pt_desc1 = pt_desc1
      ttxxrelsrp0001_pt_desc2 = pt_desc2
      ttxxrelsrp0001_rps_rel_date = rps_rel_date
      ttxxrelsrp0001_rps_due_date = rps_due_date
      ttxxrelsrp0001_lnd_run_seq1 = lnd_run_seq1
      ttxxrelsrp0001_lnd_run_seq2 = lnd_run_seq2
      ttxxrelsrp0001_rps_qty_req = rps_qty_req
      ttxxrelsrp0001_rps_qty_comp = rps_qty_comp
      ttxxrelsrp0001_open_qty = open_qty
      .
   /* SS - 100818.1 - E */

   /* REPORT EXIT FOR PAGING INCLUDE FILE */
   { mfrpchk.i}

end. /* FOR EACH rps_mstr ,LAST lnd-det */
