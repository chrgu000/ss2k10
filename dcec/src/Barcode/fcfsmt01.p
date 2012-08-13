/* GUI CONVERTED from fcfsmt01.p (converter v1.78) Fri Oct 29 14:33:01 2004 */
/* fcfsmt01.p - FORECAST MASTER MAINTENANCE                                   */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.11.1.11 $                                                     */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 4.0      LAST MODIFIED: 03/18/88   BY: *A162* EMB                */
/* REVISION: 4.0      LAST MODIFIED: 12/13/89   BY: *A795* EMB                */
/* REVISION: 5.0      LAST MODIFIED: 09/05/89   BY: *B259* MLB                */
/* REVISION: 5.0      LAST MODIFIED: 11/13/89   BY: *B386* emb                */
/* REVISION: 6.0      LAST MODIFIED: 07/24/90   BY: *D036* emb                */
/* REVISION: 6.0      LAST MODIFIED: 07/24/90   BY: *D040* emb                */
/* REVISION: 7.0      LAST MODIFIED: 10/09/91   BY: *F024* emb                */
/* REVISION: 7.0      LAST MODIFIED: 03/24/92   BY: *F089* pma                */
/* REVISION: 7.0      LAST MODIFIED: 07/20/93   BY: *GD54* qzl                */
/* REVISION: 7.0      LAST MODIFIED: 09/01/94   BY: *FQ67* ljm                */
/* REVISION: 7.0      LAST MODIFIED: 09/15/94   BY: *GM65* ljm                */
/* REVISION: 7.0      LAST MODIFIED: 09/22/94   BY: *FR51* pxd                */
/* REVISION: 7.0      LAST MODIFIED: 10/17/94   BY: *GN36* ljm                */
/* REVISION: 7.5      LAST MODIFIED: 10/24/94   BY: *J034* mwd                */
/* REVISION: 7.0      LAST MODIFIED: 12/19/95   BY: *F0WT* qzl                */
/* REVISION: 8.5      LAST MODIFIED: 06/19/97   BY: *J1TK* Felcy D'Souza      */
/* REVISION: 8.5      LAST MODIFIED: 11/10/97   BY: *J1PS* Felcy D'Souza      */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 07/14/00   BY: *N0G1* Rajinder Kamra     */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L0* Jacolyn Neder      */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.11.1.5       BY: Nikita Joshi      DATE: 04/30/01  ECO: *M165* */
/* Revision: 1.11.1.6       BY: Mark Christian    DATE: 07/26/01  ECO: *M1G3* */
/* Revision: 1.11.1.7       BY: Anil Sudhakaran   DATE: 11/27/01  ECO: *M1LB* */
/* Revision: 1.11.1.8       BY: Jean Miller       DATE: 12/12/01  ECO: *P03N* */
/* Revision: 1.11.1.9       BY: Annasaheb Rahane  DATE: 01/18/02  ECO: *N180* */
/* Revision: 1.11.1.10      BY: Rajaneesh S.      DATE: 07/24/02  ECO: *N1PK* */
/* $Revision: 1.11.1.11 $     BY: Hareesh V.        DATE: 09/18/02  ECO: *N1V7* */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdtitle.i "2+ "}

define new shared variable frwrd like soc_fcst_fwd.

define new shared variable bck    like soc_fcst_bck.
define variable fcsduedate as date no-undo.
define variable week as integer no-undo.

define new shared variable fcs_recid as recid.
define new shared variable fcrecid as recid.
define new shared variable nett like fcs_fcst_qty extent 156.
define variable sales like fcs_sold_qty no-undo.
define variable net like fcs_fcst_qty no-undo.
define variable i as integer no-undo.

define new shared variable fcs_fcst like fcs_fcst_qty format ">>>>,>>9".
define variable del-yn like mfc_logical no-undo.
define variable start as date extent 52 no-undo
        view-as fill-in size 8 by 1   .
define variable ptstatus like pt_status no-undo.
define new shared variable totals like fcs_fcst
                                       format "->>>>>>,>>9" extent 4 no-undo.
define variable inrecno as recid no-undo.

define variable disp-forecast as character extent 4 no-undo
   format "x(10)".
define variable disp-week     as character extent 4 no-undo
   format "x(5)".
define variable disp-total    as character
                                 format "x(5)" extent 4 no-undo.

disp-total = getTermLabel("TOTAL", 5).

assign
   disp-week[1]     = getTermLabel("WEEK",5)
   disp-week[2]     = getTermLabel("WEEK",5)
   disp-week[3]     = getTermLabel("WEEK",5)
   disp-week[4]     = getTermLabel("WEEK",5)
   disp-forecast[1] = getTermLabelRt("FORECAST",10)
   disp-forecast[2] = getTermLabelRt("FORECAST",10)
   disp-forecast[3] = getTermLabelRt("FORECAST",10)
   disp-forecast[4] = getTermLabelRt("FORECAST",10).

/* Variable added to perform delete during CIM. Record is deleted only */
/* when the value of this variable is set to "X"                       */
define variable batchdelete as character format "x(1)" no-undo.

{fcsdate.i today fcsduedate week global_site}

frwrd = 0.

bck = 0.
for first soc_ctrl
   fields(soc_fcst_bck soc_fcst_fwd)
   no-lock:
end. /* FOR FIRST soc_ctrl */
if available soc_ctrl then do:
   fcsduedate = fcsduedate - 7 * soc_fcst_bck.

   frwrd = soc_fcst_fwd.

   bck = soc_fcst_bck.
end. /* if available soc_ctrl then do: */

{fcsdate1.i year(today) start[1]}

do i = 2 to 52:
   start[i] = start[i - 1] + 7.
end. /* do i = 2 to 52: */

/* DISPLAY SELECTION FORM */

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
space(1)
   fcs_part
   fcs_site
   fcs_year
 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

FORM /*GUI*/ 
/*V8+*/
     
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
disp-week[1]   at 2   disp-forecast[1]  to 20
   disp-week[2]   at 22  disp-forecast[2]  to 40
   disp-week[3]   at 42  disp-forecast[3]  to 60
   disp-week[4]   at 62  disp-forecast[4]  to 80 skip
  

   start[1]  no-attr-space fcs_fcst[1]  space(3)
   start[14] no-attr-space fcs_fcst[14] space(3)
   start[27] no-attr-space fcs_fcst[27] space(3)
   start[40] no-attr-space fcs_fcst[40] skip

   start[2]  no-attr-space fcs_fcst[2]  space(3)
   start[15] no-attr-space fcs_fcst[15] space(3)
   start[28] no-attr-space fcs_fcst[28] space(3)
   start[41] no-attr-space fcs_fcst[41] skip

   start[3]  no-attr-space fcs_fcst[3]  space(3)
   start[16] no-attr-space fcs_fcst[16] space(3)
   start[29] no-attr-space fcs_fcst[29] space(3)
   start[42] no-attr-space fcs_fcst[42] skip

   start[4]  no-attr-space fcs_fcst[4]  space(3)
   start[17] no-attr-space fcs_fcst[17] space(3)
   start[30] no-attr-space fcs_fcst[30] space(3)
   start[43] no-attr-space fcs_fcst[43] skip

   start[5]  no-attr-space fcs_fcst[5]  space(3)
   start[18] no-attr-space fcs_fcst[18] space(3)
   start[31] no-attr-space fcs_fcst[31] space(3)
   start[44] no-attr-space fcs_fcst[44] skip

   start[6]  no-attr-space fcs_fcst[6]  space(3)
   start[19] no-attr-space fcs_fcst[19] space(3)
   start[32] no-attr-space fcs_fcst[32] space(3)
   start[45] no-attr-space fcs_fcst[45] skip

   start[7]  no-attr-space fcs_fcst[7]  space(3)
   start[20] no-attr-space fcs_fcst[20] space(3)
   start[33] no-attr-space fcs_fcst[33] space(3)
   start[46] no-attr-space fcs_fcst[46] skip

   start[8]  no-attr-space fcs_fcst[8]  space(3)
   start[21] no-attr-space fcs_fcst[21] space(3)
   start[34] no-attr-space fcs_fcst[34] space(3)
   start[47] no-attr-space fcs_fcst[47] skip

   start[9]  no-attr-space fcs_fcst[9]  space(3)
   start[22] no-attr-space fcs_fcst[22] space(3)
   start[35] no-attr-space fcs_fcst[35] space(3)
   start[48] no-attr-space fcs_fcst[48] skip

   start[10] no-attr-space fcs_fcst[10] space(3)
   start[23] no-attr-space fcs_fcst[23] space(3)
   start[36] no-attr-space fcs_fcst[36] space(3)
   start[49] no-attr-space fcs_fcst[49] skip

   start[11] no-attr-space fcs_fcst[11] space(3)
   start[24] no-attr-space fcs_fcst[24] space(3)
   start[37] no-attr-space fcs_fcst[37] space(3)
   start[50] no-attr-space fcs_fcst[50] skip

   start[12] no-attr-space fcs_fcst[12] space(3)
   start[25] no-attr-space fcs_fcst[25] space(3)
   start[38] no-attr-space fcs_fcst[38] space(3)
   start[51] no-attr-space fcs_fcst[51] skip

   start[13] no-attr-space fcs_fcst[13] space(3)
   start[26] no-attr-space fcs_fcst[26] space(3)
   start[39] no-attr-space fcs_fcst[39] space(3)
   start[52] no-attr-space fcs_fcst[52] skip

/*V8+*/

     
   disp-total[1] to  7  totals[1] to  18 no-attr-space
   disp-total[2] to 27  totals[2] to  38 no-attr-space
   disp-total[3] to 47  totals[3] to  58 no-attr-space
   disp-total[4] to 67  totals[4] to  78 no-attr-space
  
 SKIP(.4)  /*GUI*/
with frame b no-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-b-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame b = F-b-title.
 RECT-FRAME-LABEL:HIDDEN in frame b = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame b =
  FRAME b:HEIGHT-PIXELS - RECT-FRAME:Y in frame b - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME b = FRAME b:WIDTH-CHARS - .5.  /*GUI*/


/* DISPLAY */
view frame a.

display
   year(today) @ fcs_year
   global_site @ fcs_site
with frame a.

clear frame b.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame b = F-b-title.

display
   disp-total
   start
   disp-forecast
   disp-week
with frame b.

mainloop:
repeat with frame a:
/*GUI*/ if global-beam-me-up then undo, leave.


   /* Initialize delete flag before each display of frame */
   batchdelete = "".

   prompt-for fcs_part fcs_site
      fcs_year
      /* Prompt for the delete variable in the key frame at the */
      /* End of the key field/s only when batchrun is set to yes */
      batchdelete no-label when (batchrun)
   editing:

      if frame-field = "fcs_part" then do:
         {mfnp01.i fcs_sum fcs_part fcs_part
            fcs_year "input fcs_year" fcs_yearpart}
      end.
      else if frame-field = "fcs_year" then do:
         {mfnp.i fcs_sum fcs_year fcs_year fcs_year fcs_year fcs_yearpart}
      end.
      else do:
         readkey.
         apply lastkey.
      end.

      if recno <> ? then do:
         for first pt_mstr
            fields(pt_abc pt_avg_int pt_cyc_int pt_part pt_rctpo_active
                   pt_rctpo_status pt_rctwo_active pt_rctwo_status pt_status)
            where pt_part = fcs_part
            no-lock:
         end. /* FOR FIRST pt_mstr */

         display
            fcs_part
            fcs_site
            fcs_year
         with frame a.

         if fcs_year <> year(start[2]) then do:
            {fcsdate1.i fcs_year start[1]}
            do i = 2 to 52:
               start[i] = start[i - 1] + 7.
            end. /* do i = 2 to 52: */
            display start with frame b.
         end.

         totals = 0.

         fcrecid = recid(fcs_sum).

         {gprun.i ""fcfsmt02.p""}
/*GUI*/ if global-beam-me-up then undo, leave.


         display
            fcs_fcst
            totals
         with frame b.

      end. /* if recno <> ? then do: */

   end.
/*GUI*/ if global-beam-me-up then undo, leave.
   /* PROMPT-FOR...EDITING */

   if available si_mstr then do:
      {gprun.i ""gpsiver.p""
         "(input si_site, input recid(si_mstr), output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

   end. /* if available si_mstr then do: */
   else do:
      {gprun.i ""gpsiver.p""
         "(input (input fcs_site), input ?, output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

   end.

   if return_int = 0 then do:
      {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}
      /*USER DOES NOT HAVE ACCESS TO THIS SITE*/
      next-prompt fcs_site.
      undo mainloop, retry.
   end.

   for first si_mstr
      fields(si_cur_set si_db si_gl_set si_site)
      where si_site = input fcs_site
      no-lock:
   end. /* FOR FIRST si_mstr */
   if available si_mstr and si_db <> global_db then do:
      /* Site is not assigned to this database */
      {pxmsg.i &MSGNUM=5421 &ERRORLEVEL=3}
      undo mainloop, retry.
   end. /* if available si_mstr and si_db <> global_db then do: */

   /* ADD/MOD/DELETE */
   for first pt_mstr
      fields(pt_abc pt_avg_int pt_cyc_int pt_part pt_rctpo_active
             pt_rctpo_status pt_rctwo_active pt_rctwo_status pt_status)
      where pt_part = input fcs_part
      no-lock:
   end. /* FOR FIRST pt_mstr */

   find fcs_sum using fcs_part and fcs_site and fcs_year
   exclusive-lock no-error.

   if not available fcs_sum then do:

      ptstatus = pt_status.
      substring(ptstatus,9,1) = "#".

      if can-find(isd_det where isd_status = ptstatus
                            and isd_tr_type = "ADD-FC")
      then do:
         /* Restricted procedure for item status code */
         {pxmsg.i &MSGNUM=358 &ERRORLEVEL=3 &MSGARG1=pt_status}
         undo mainloop, retry.
      end.

      /* Adding new record */
      {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}

      create fcs_sum.
      assign
         fcs_part = caps(input fcs_part)
         fcs_site
         fcs_year.

   end. /* if not available fcs_sum then do: */

   if not can-find(in_mstr where in_part = fcs_part and
                                 in_site = fcs_site)
   then do:
      {gprun.i ""gpincr.p""
         "(input yes,
           input pt_part,
           input si_site,
           input si_gl_set,
           input si_cur_set,
           input pt_abc,
           input pt_avg_int,
           input pt_cyc_int,
           input pt_rctpo_status,
           input pt_rctpo_active,
           input pt_rctwo_status,
           input pt_rctwo_active,
           output inrecno)" }
/*GUI*/ if global-beam-me-up then undo, leave.

   end. /* fcs_site) then do: */

   ststatus = stline[2].
   status input ststatus.

   del-yn = no.
   fcs_recid = recid(fcs_sum).

   /* SET GLOBAL ITEM VARIABLE */
   global_part = fcs_part.

   if fcs_year <> year(start[2]) then do:
      {fcsdate1.i fcs_year start[1]}
      do i = 2 to 52:
         start[i] = start[i - 1] + 7.
      end. /* do i = 2 to 52: */
   end. /* if fcs_year <> year(start[2]) then do: */

   totals = 0.

   fcrecid = recid(fcs_sum).

   {gprun.i ""fcfsmt02.p""}
/*GUI*/ if global-beam-me-up then undo, leave.


   display
      start
      fcs_fcst
      totals
   with frame b.

   do on error undo, retry with frame b:
/*GUI*/ if global-beam-me-up then undo, leave.


      set fcs_fcst go-on ("F5" "CTRL-D") with frame b.

      /* DELETE */
      if lastkey = keycode("F5")
      or lastkey = keycode("CTRL-D")
      /* Delete to be executed if batchdelete is set to "x" */
      or input batchdelete = "x":U
      then do:
         del-yn = yes.
         /* Please confirm delete */
         {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
         if not del-yn then undo, retry.
      end. /* then do: */

      do i = 1 to 52:
         fcs_fcst_qty[i] = fcs_fcst[i].
      end. /* do i = 1 to 52: */

      if del-yn then fcs_fcst_qty = 0.

      {gprun.i ""fcfsre.p""}
/*GUI*/ if global-beam-me-up then undo, leave.


      do i = 1 to 52:

         if i > 52 - bck then do:
            if start[i] - 364 < fcsduedate then nett[i] = 0.
            {gprun1.i ""mfmrwfs.p""
               "(input ""fcs_sum"",
                 input fcs_part,
                 input string(fcs_year - 1) + fcs_site,
                 input string(i),
                 input """",
                 input ?,
                 input (start[i] - 364),
                 input nett[i],
                 input ""DEMAND"",
                 input ""FORECAST"",
                 input fcs_site)" }
         end. /* if i > 52 - bck then do: */

         if start[i] < fcsduedate then nett[i + 52] = 0.

         {gprun1.i ""mfmrwfs.p""
            "(input ""fcs_sum"",
                       input fcs_part,
                       input string(fcs_year) + fcs_site,
                       input string(i),
                       input """",
                       input ?,
                       input start[i],
                       input nett[i + 52],
                       input ""DEMAND"",
                       input ""FORECAST"",
                       input fcs_site)" }

         if i <= frwrd then do:
            if start[i] + 364 < fcsduedate then nett[i + 104] = 0.

            {gprun1.i ""mfmrwfs.p""
               "(input ""fcs_sum"",
                       input fcs_part,
                       input string(fcs_year + 1) + fcs_site,
                       input string(i),
                       input """",
                       input ?,
                       input (start[i] + 364),
                       input nett[i + 104],
                       input ""DEMAND"",
                       input ""FORECAST"",
                       input fcs_site)" }
         end. /* if i <= frwrd then do: */
      end. /* do i = 1 to 52: */

      if del-yn then do:
         do i = 1 to 52:
            if not del-yn then leave.
            if fcs_sold_qty[i] <> 0
               or fcs_abnormal[i] <> 0
               or fcs_pr_fcst[i] <> 0 then del-yn = no.
         end. /* do i = 1 to 52: */

         if del-yn then delete fcs_sum.
         del-yn = no.
         next mainloop.
      end. /* if del-yn then do: */
   end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* do on error undo, retry with frame b: */

   totals = 0.

   fcrecid = recid(fcs_sum).
   {gprun.i ""fcfsmt02.p""}
/*GUI*/ if global-beam-me-up then undo, leave.


   display start fcs_fcst totals with frame b.

end. /* fcs_year */
status input.
