/* ppptcg.p - CHANGE ITEM NUMBER                                              */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.38 $                                                          */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 1.0      LAST MODIFIED: 06/11/86   BY: pml                       */
/* REVISION: 1.0      LAST MODIFIED: 12/22/86   BY: emb *A5*                  */
/* REVISION: 4.0      LAST MODIFIED: 02/01/88   BY: pml *A119*                */
/* REVISION: 4.0      LAST MODIFIED: 02/02/88   BY: RL  *A136*                */
/* REVISION: 4.0      LAST MODIFIED: 09/12/88   BY: flm *A432*                */
/* REVISION: 4.0      LAST MODIFIED: 10/14/88   BY: flm *A484*                */
/* REVISION: 5.0      LAST MODIFIED: 10/19/89   BY: emb *B353*                */
/* REVISION: 5.0      LAST MODIFIED: 01/05/90   BY: emb *B488*                */
/* REVISION: 6.0      LAST MODIFIED: 11/21/90   BY: emb *D224*                */
/* REVISION: 6.0      LAST MODIFIED: 12/18/90   BY: emb *D262*                */
/* REVISION: 6.0      LAST MODIFIED: 03/08/91   BY: emb *D412*                */
/* REVISION: 6.0      LAST MODIFIED: 01/24/92   BY: emb *F111*                */
/* REVISION: 7.0      LAST MODIFIED: 04/28/92   BY: sas *F437*                */
/* REVISION: 7.3      LAST MODIFIED: 10/14/92   BY: sas *G168* Rev only       */
/* REVISION: 7.3      LAST MODIFIED: 11/25/92   BY: pma *G350*                */
/* REVISION: 7.3      LAST MODIFIED: 04/02/93   BY: pma *G900*                */
/* REVISION: 7.3      LAST MODIFIED: 04/30/93   BY: pma *GA44*                */
/* REVISION: 7.3      LAST MODIFIED: 07/07/93   BY: tjs *GD23* Rev only       */
/* REVISION: 7.3      LAST MODIFIED: 10/18/93   BY: sas *GG38* Rev only       */
/* REVISION: 7.2      LAST MODIFIED: 12/18/94   BY: qzl *F0B1*                */
/* REVISION: 8.5      LAST MODIFIED: 02/17/95   BY: tjs *J027*                */
/* REVISION: 7.3      LAST MODIFIED: 03/09/95   by: srk *G0GN*                */
/* REVISION: 7.2      LAST MODIFIED: 10/14/95   BY: qzl *F0VN*                */
/* REVISION: 7.3      LAST MODIFIED: 01/24/96   BY: ame *F0WW*                */
/* REVISION: 8.5      LAST MODIFIED: 03/29/96   BY: jxz *J078*                */
/* REVISION: 8.5      LAST MODIFIED: 07/30/96   BY: *G1ZS*  Russ Witt         */
/* REVISION: 8.6      LAST MODIFIED: 10/10/96   BY: svs *K007*                */
/* REVISION: 8.6      LAST MODIFIED: 10/18/96   BY: jpm *K017*                */
/* REVISION: 7.3      LAST MODIFIED: 02/20/97   BY: *G2L3*  Maryjeane Date    */
/* REVISION: 8.7      LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.7      LAST MODIFIED: 03/24/98   BY: *J2FG* Niranjan R.        */
/* REVISION: 8.7      LAST MODIFIED: 04/27/98   BY: *J2KS* Niranjan R.        */
/* REVISION: 8.7      LAST MODIFIED: 05/15/98   BY: *J2LM* Suresh Nayak       */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/09/98   BY: *J320* Manish K.          */
/* REVISION: 9.0      LAST MODIFIED: 11/20/98   BY: *M002* Mayse Lai          */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 09/08/00   BY: *M0SG* Rajesh Thomas      */
/* REVISION: 9.1      LAST MODIFIED: 09/21/00   BY: *L14D* Nikita Joshi       */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.24       BY: Rajesh Thomas         DATE: 05/24/01  ECO: *M177* */
/* Revision: 1.25       BY: Jean Miller           DATE: 05/17/02  ECO: *P05V* */
/* Revision: 1.26       BY: Jean Miller           DATE: 10/16/02  ECO: *N1X6* */
/* Revision: 1.27       BY: Narathip W.           DATE: 04/09/03  ECO: *P0PS* */
/* Revision: 1.31       BY: Paul Donnelly (SB)    DATE: 06/28/03  ECO: *Q00K* */
/* Revision: 1.32       BY: Kirti Desai           DATE: 09/25/03  ECO: *P140* */
/* Revision: 1.35       BY: Jyoti Thatte          DATE: 09/15/03  ECO: *P106* */
/* Revision: 1.36       BY: Rajiv Ramaiah         DATE: 11/05/03  ECO: *N2M0* */
/* Revision: 1.37       BY: Dayanand Jethwa       DATE: 01/15/04  ECO: *P1JT* */
/* $Revision: 1.38 $    BY: Priyank Khandare      DATE: 06/23/05  ECO: *P3QG* */
/* SS - 090729.1 By: Neil Gao */

/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdtitle.i "1+ "}
{cxcustom.i "PPPTCG.P"}

{gpfilev.i}

define new shared variable record_no as recid.
define new shared variable comp like ps_comp.
define new shared variable part1 like ps_par label "Old Item Number".
define new shared variable part2 like ps_par label "New Item Number".

define new shared frame b.

define variable desc1 like pt_desc1.
define variable desc2 like pt_desc1.
define variable i as integer.
define variable yn like mfc_logical.
define variable apm-ex-prg as character format "x(10)" no-undo.
define variable apm-ex-sub as character format "x(24)" no-undo.
define new shared stream prt.
define variable error_flag  like mfc_logical no-undo.
define variable err_mess_no like msg_nbr     no-undo.
define variable l_count     as   integer     no-undo.

{ppacdef.i &type="new shared"}

form
   part1          colon 25
   desc1          no-label
   part2          colon 25
   desc2          no-label skip
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

part1 = global_part.

for first soc_ctrl
   {&PPPTCG-P-TAG1}
   fields (soc_domain soc__qadl02 soc_apm)
   {&PPPTCG-P-TAG2}
 where soc_domain = global_domain no-lock: end.

if soc_apm then do:
   /* TrM DATABASE IS NOT CONNECTED */
   {ifapmcon.i "6316" " pause. return" }
end.

for each temp_inactive
   exclusive-lock:
   delete temp_inactive.
end. /* FOR EACH temp_inactive */

mainloop:
repeat:

   update
      part1
      part2
   with frame a
   editing:

      if frame-field = "part1" then do:
         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp.i pt_mstr part1  " pt_mstr.pt_domain = global_domain and pt_part
         "  part1 pt_part pt_part}
         if recno <> ? then do:
            part1 = pt_part.
            display
               part1
               pt_desc1 @ desc1
            with frame a.
         end.
      end.
      else do:
         status input.
         readkey.
         apply lastkey.
      end.
   end.

   assign
      desc1 = ""
      desc2 = "".

   find pt_mstr where pt_domain = global_domain and pt_part = part1
   no-lock no-error.
   if not available pt_mstr then do:
      {pxmsg.i &MSGNUM=16 &ERRORLEVEL=3} /*  ITEM NUMBER DOES NOT EXIST.*/
      display
         "" @ desc1
      with frame a.
      next-prompt part1 with frame a.
      undo, retry.
   end.

   assign
      part1 = pt_part
      desc1 = pt_desc1.

   display
      part1
      desc1
   with frame a.

   if part2 = "" then do:
      next-prompt part2 with frame a.
      undo, retry.
   end.

   find pt_mstr where pt_domain = global_domain and pt_part = part2
   no-lock no-error.
   if available pt_mstr then do:
      {pxmsg.i &MSGNUM=204 &ERRORLEVEL=3} /*  EXISTING PART.*/
      assign
         part2 = pt_part
         desc2 = pt_desc1.
      display
         part2
         desc2
      with frame a.
      next-prompt part2 with frame a.
      undo, retry.
   end.

   for first an_mstr
      {&PPPTCG-P-TAG3}
      fields(an_domain an_type an_code)
      {&PPPTCG-P-TAG4}
      where an_domain = global_domain
      and  (an_type = "6" and
           (an_code = part1 or an_code = part2))
   no-lock: end.

   if available an_mstr then do:
      /* ITEM MATCHES EXISTING ITEM ANALYSIS CODE #. CANNOT PROCESS */
      {pxmsg.i &MSGNUM=2618 &ERRORLEVEL=4 &MSGARG1=an_code}
      undo mainloop, retry mainloop.
   end.  /* IF AVAILABLE AN_MSTR */

   if can-find(first cd_det
                  where cd_domain = global_domain
                  and   cd_ref    = part1)
      and can-find(first cd_det
                      where cd_domain = global_domain
                      and   cd_ref    = part2)
   then do:
      /* MASTER COMMENT # ALREADY EXISTS */
      {pxmsg.i &MSGNUM=6836 &ERRORLEVEL=4 &MSGARG1=part2}
      if not batchrun
      then
         undo mainloop, retry mainloop.
      else
         undo mainloop, leave mainloop.
   end. /* IF CAN-FIND FIRST cd_det */

   /* VALIDATE THE ENTERED ITEM AGAINST EXISTING CUSTOMER ITEMS   */
   /* ONLY IF THE SEARCH FOR CUSTOMER ITEM FIRST BEFORE INVENTORY */
   /* ITEM FLAG (SOC__QADL02 ) IS SET TO NO IN THE SALES ORDER    */
   /* CONTROL FILE.                                               */
   if not available soc_ctrl or not soc__qadl02 then do:
      find first cp_mstr
         where cp_domain = global_domain and
               cp_cust_part = part2 no-lock no-error.
      if available cp_mstr then do:
         /* Customer Part exists */
         {pxmsg.i &MSGNUM=243 &ERRORLEVEL=3}
         next-prompt part2 with frame a.
         undo, retry.
      end.
   end. /* IF NOT SOC__QADL02 */

   part2 = caps(part2).

   display
      part2
      desc2
   with frame a.

   hide frame b.

   bcdparm = "".
   {mfquoter.i part1}
   {mfquoter.i part2}

   {mfselbpr.i "printer" 80 " " "stream prt"}

   setb:
   do with frame b:

      {mfphead2.i "stream prt" "(prt)"}

      find pt_mstr where pt_domain = global_domain
                    and  pt_part = part1
      no-error.

      {&PPPTCG-P-TAG5}
      form
         part1
         part2
         pt_desc1 format "x(30)"
         i        column-label "Records!Updated"
      with frame b width 80 down no-attr-space no-box.
      {&PPPTCG-P-TAG6}

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).

      display stream prt part1 part2 pt_desc1 with frame b.

      if pt_desc2 > "" then
         down stream prt 1 with frame b.

      if pt_desc2 > "" then
         display stream prt
            pt_desc2 @ pt_desc1
         with frame b.

      down stream prt 2 with frame b.

      {gprun.i ""ppptcga.p""}
      {gprun.i ""ppptcga1.p""}
      {gprun.i ""ppptcga3.p""}
      {gprun.i ""ppptcga2.p""}

      {gprun.i ""ppptcgb.p""}
      {gprun.i ""ppptcgb1.p""}

      {gprun.i ""ppptcgc.p""}
      {gprun.i ""ppptcgc1.p""}
      {gprun.i ""ppptcgc2.p""}

      {gprun.i ""ppptcgd.p""}     /*field service*/
      {gprun.i ""ppptcgd1.p""}    /*field service continued*/
      {gprun.i ""ppptcgd3.p""}    /*field service continued*/
      {gprun.i ""ppptcgd2.p""}    /*field service continued*/

      {gprun.i ""ppptcge.p""}     /*release 7.0*/
      {gprun.i ""ppptcge1.p""}    /*release 7.0 continued*/
      {gprun.i ""ppptcge2.p""}    /*release 7.0 continued*/

      {gprun.i ""ppptcgf.p""}     /*release 7.3*/
      {gprun.i ""ppptcgf1.p""}    /*release 7.3 continued*/

      {gprun.i ""ppptcgg.p""}     /*release 8.5 acm_mstr */
      {gprun.i ""ppptcgf2.p""}    /*release 8.5 operations planning */

      {gprun.i ""ppptcgh.p""}     /*MRP Order % */

      /* ITEM CHANGE FOR ALL FILES IN KANBAN MODULE */
      {gprun.i ""ppptckb.p""}

      /* ITEM CHANGE FOR ALL FILES IN CONSIGNMENT MODULE */
      {gprun.i ""ppptccn.p""}

      {&PPPTCG-P-TAG7}
      /* TO UPDATE ITEM NUMBER in qad_wkfl's WITH key1 = "MFWORLA" */
      for each wod_det
         fields (wod_domain wod_lot wod_op wod_part)
         where wod_domain = global_domain and wod_part = part2
      no-lock:

         for each qad_wkfl
            where qad_domain = global_domain
              and qad_key1 = "MFWORLA"
              and qad_key2 = wod_lot + part1 + string(wod_op)
         exclusive-lock:
            qad_key2 = wod_lot + part2 + string(wod_op).
         end. /* FOR EACH qad_wkfl ... */

      end. /* FOR EACH wod_det ... */

      find first soc_ctrl where soc_domain = global_domain no-lock
      no-error.
      if available soc_ctrl then
      if soc_apm and pt_promo <> "" then do:

         /* Future logic will go here to determine subdirectory*/
         apm-ex-prg = "ifprodc.p".
         apm-ex-sub = "if/".

         {gprunex.i
            &module   = 'APM'
            &subdir   = apm-ex-sub
            &program  = 'ifapm055.p'
            &params   = "(input part1,
                      input part2,
                      output error_flag,
                      output err_mess_no)" }
         if error_flag then do:
            {pxmsg.i &MSGNUM=err_mess_no &ERRORLEVEL=4 }
            /* ERROR OCCURRED UPDATING APM */
            undo.
         end.

      end.

      do transaction:
         pt_part = part2.
         for first comd_det
            where comd_domain = global_domain
              and comd_part = part1
         exclusive-lock:
            comd_part = part2.
         end.
      end.

      /* DELETE OLD ITEM RECORDS FROM anx_det                 */
      {gpfile.i &file_name='anx_det'}.
      for each anx_det
         where anx_domain = global_domain
          and  anx_type = "6"
          and  anx_node = part1
      exclusive-lock:

         /* CREATING TEMP TABLE FOR INACTIVE NODES */
         if not anx_active
         then do:
            create temp_inactive.
            assign
               temp_inactive_node = part2
               temp_inactive_code = anx_code.
         end. /* IF not anx_active */

         delete anx_det.
         l_count = l_count + 1.
      end.

      /* REGENERATE ANALYSIS CODE DETAIL FOR NEW ITEM            */
      {gprun.i ""ppptgen.p"" "(input ""6"", input part2)"}

/* SS 090729.1 - B */
			{gprun.i ""xxppptcg01.p"" "(input part1,input part2)"}
/* SS 090729.1 - E */

      /* DISPLAY COUNT OF anx_det RECORDS UPDATED                */
      if l_count > 0 then do:

         hide message no-pause.
         /* Checking for affected items file */
         {pxmsg.i &MSGNUM=211 &ERRORLEVEL=1 &MSGARG1=file_desc}

         display stream prt
            file_desc @ pt_desc1 l_count @ i.
         down stream prt 1.
         l_count = 0.

      end. /* IF L_COUNT > 0 */

      global_part = part2.
      /*Change item number process completed */
      {pxmsg.i &MSGNUM=210 &ERRORLEVEL=1}
   end.

   {mftrl080.i "stream prt"}

end.
