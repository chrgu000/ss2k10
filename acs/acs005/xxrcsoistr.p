/* rcsoistr.p - Release Management Customer Schedules                   */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.6.1.9 $                                             */
/*V8:ConvertMode=Maintenance                                            */
/* REVISION: 7.4    LAST MODIFIED: 09/22/93           BY: WUG *H140*    */
/* REVISION: 7.4    LAST MODIFIED: 07/07/94           BY: dpm *GK62*    */
/* REVISION: 8.5    LAST MODIFIED: 07/31/95           BY: taf *J053*    */
/* REVISION: 8.5    LAST MODIFIED: 10/11/96    BY: *G2FT* Suresh Nayak  */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 8.6E     LAST MODIFIED: 03/30/99   BY: *K1ZH* Santosh Rao  */
/* REVISION: 9.1      LAST MODIFIED: 10/12/99   BY: *K23N* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 05/12/00   BY: *N09X* Antony Babu      */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* myb              */
/* Old ECO marker removed, but no ECO header exists *F0PN*                  */
/* Revision: 1.6.1.7  BY: Katie Hilbert DATE: 04/01/01 ECO: *P002* */
/* $Revision: 1.6.1.9 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00K* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SHIPPER CONFIRM SUBPROGRAM - TRAILER CHARGE UPDATE */

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

define shared variable rndmthd like rnd_rnd_mthd.
define input parameter sonbr as character.
define output parameter undo_stat like mfc_logical no-undo.

define variable term-disc as decimal.
define variable tax_date as date.
define variable tax_tr_type like tx2d_tr_type initial "13".
define variable user_desc like trl_desc extent 3.
define variable title_data as character.
define variable there_is_trailer_code like mfc_logical extent 3.
define variable trl_fmt as character no-undo.
define variable retval as integer no-undo.
define new shared variable so_recno as recid.
define new shared variable tax_recno as recid.

undo_stat = no.

for first shc_ctrl
   fields( shc_domain shc_trl_amts)  where shc_ctrl.shc_domain = global_domain
   no-lock:
end.

find so_mstr  where so_mstr.so_domain = global_domain and  so_nbr = sonbr
exclusive-lock.
find trl_mstr  where trl_mstr.trl_domain = global_domain and  trl_code =
so_trl1_cd no-lock no-error.
if available trl_mstr then
assign
   user_desc[1] = fill(" ",24 - length (trl_desc,"RAW")) + trl_desc
   there_is_trailer_code[1] = yes.

find trl_mstr  where trl_mstr.trl_domain = global_domain and  trl_code =
so_trl2_cd no-lock no-error.
if available trl_mstr then
assign
   user_desc[2] = fill(" ",24 - length (trl_desc,"RAW")) + trl_desc
   there_is_trailer_code[2] = yes.

find trl_mstr  where trl_mstr.trl_domain = global_domain and  trl_code =
so_trl3_cd no-lock no-error.
if available trl_mstr then
assign
   user_desc[3] = fill(" ",24 - length (trl_desc,"RAW")) + trl_desc
   there_is_trailer_code[3] = yes.

so_recno = recid(so_mstr).
{gprun.i ""rcsoisf.p""}
if not
   (
   there_is_trailer_code[1]
   or
   there_is_trailer_code[2]
   or
   there_is_trailer_code[3]
   )
   then leave.

title_data = " " + getTermLabel("SALES_ORDER",16) + ": "  + so_nbr +
getFrameTitle("TRAILER_AMOUNTS",22).

form
   user_desc[1]   to 28 no-label
   so_trl1_cd     format "x(2)" to 33 no-label
   ":"            at 35
   so_trl1_amt    no-label
   user_desc[2]   to 28 no-label
   so_trl2_cd     format "x(2)" to 33 no-label
   ":"            at 35
   so_trl2_amt    no-label
   user_desc[3]   to 28 no-label
   so_trl3_cd     format "x(2)" to 33 no-label
   ":"            at 35
   so_trl3_amt    no-label
with frame trailer side-labels width 80 attr-space
   title color normal title_data.

undo_stat = yes.

trl_fmt = so_trl1_amt:format.
{gprun.i ""gpcurfmt.p"" "(input-output trl_fmt,
                   input rndmthd)"}
so_trl1_amt:format = trl_fmt.
so_trl2_amt:format = trl_fmt.
so_trl3_amt:format = trl_fmt.

/* MANUAL UPDATE OF TRAILER DATA ONLY WHEN MAINTAIN           */
/* TRAILER AMOUNTS IS SET TO "YES"                            */

if shc_trl_amts then
   do:

   /* SET EXTERNAL LABELS */
   setFrameLabels(frame trailer:handle).
   display
      user_desc[1]
      user_desc[2]
      user_desc[3]
      so_trl1_cd
      so_trl2_cd
      so_trl3_cd
   with frame trailer.

   trlloop:
   do on error undo, retry:
      update
         so_trl1_amt when (there_is_trailer_code[1])
         so_trl2_amt when (there_is_trailer_code[2])
         so_trl3_amt when (there_is_trailer_code[3])
      with frame trailer.
      /* VALIDATE TRAILER 1 AMOUNT */
      if (so_trl1_amt <> 0) then do:
         {gprun.i ""gpcurval.p"" "(input so_trl1_amt,
                                input rndmthd,
                                output retval)"}
         if retval <> 0 then do:
            next-prompt so_trl1_amt with frame trailer.
            undo trlloop, retry trlloop.
         end.
      end.
      /* VALIDATE TRAILER 2 AMOUNT */
      if (so_trl2_amt <> 0) then do:
         {gprun.i ""gpcurval.p"" "(input so_trl2_amt,
                                   input rndmthd,
                                   output retval)"}
         if retval <> 0 then do:
            next-prompt so_trl2_amt with frame trailer.
            undo trlloop, retry trlloop.
         end.
      end.
      /* VALIDATE TRAILER 3 AMOUNT */
      if (so_trl3_amt <> 0) then do:
         {gprun.i ""gpcurval.p"" "(input so_trl3_amt,
                                   input rndmthd,
                                   output retval)"}
         if retval <> 0 then do:
            next-prompt so_trl3_amt with frame trailer.
            undo trlloop, retry trlloop.
         end.
      end.
   end. /* TRLLOOP: DO ON ERROR UNDO, RETRY:*/
end.
undo_stat = no.

hide frame trailer no-pause.
