/* GUI CONVERTED from chglfmmt.p (converter v1.71) Sun Oct 21 21:39:26 2007 */
/* chglfmmt.p - GL FORMAT POSITION MAINTENANCE - CAS                    */
/* glfmmt.p - GL FORMAT POSITION MAINTENANCE                            */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                 */
/* REVISION: 1.0      LAST MODIFIED: 09/15/86   BY: JMS                 */
/*                    LAST MODIFIED: 12/05/86   BY: EMB                 */
/*                                   12/16/87   BY: JMS                 */
/*                                   01/25/88   BY: JMS                 */
/*                                   01/29/88   By: JMS                 */
/* REVISION: 5.0      LAST MODIFIED: 05/05/89   by: jms  *B139*         */
/* REVISION: 6.0      LAST MODIFIED: 06/25/90   by: jms  *D034*         */
/*                                   11/14/90   by: jms  *D212*         */
/*                                   12/11/90   by: jms  *D250*         */
/* REVISION: 7.0      LAST MODIFIED: 10/07/91   by: jjs  *F058*         */
/* Revision: 7.3      Last Modified: 08/04/92   by: mpp  *G026*         */
/* Revision: 8.6      Last Modified: 05/20/98   by: *K1Q4* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00 BY: *N0L1* Mark Brown       */
/* REVISION: 9.1CH    LAST MODIFIED: 05/20/01 BY: *XXCH911* Charles Yen   */
/* REVISION: 9.1CH    LAST MODIFIED: 01/09/02   BY: SEMMI *XC910201*     */

      /* DISPLAY TITLE */
/*G026*/ {mfdtitle.i "b+ "}

      define variable del-yn like mfc_logical initial no.
      define variable sums_into like fm_sums_into.
      define variable sums_desc like fm_desc.
      define new shared variable fm_recno as recid.
      define buffer f1 for fm_mstr.

/*XXCH911*/  define variable desc1 as char format "x(24)".
/*XXCH911*/  define variable desc2 as char format "x(16)".

      /* DISPLAY SELECTION FORM */
      
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
      
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
fm_fpos       colon 35
      fm_desc       colon 35
/*XXCH911*/  desc1  colon 35  no-label
/*XXCH911*/  desc2  colon 35  no-label
      fm_sums_into  colon 35   sums_desc no-label
      fm_type       colon 35
      fm_dr_cr      colon 35
/*G026*/  fm_sub_sort   colon 35
/*G026*/  fm_cc_sort    colon 35
      fm_page_brk   colon 35
      fm_header     colon 35
      fm_total      colon 35
      fm_skip       colon 35
      fm_underln    colon 35
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

      /* DISPLAY */
      view frame a.
      mainloop: repeat with frame a:
/*GUI*/ if global-beam-me-up then undo, leave.

         prompt-for fm_fpos editing:
        /* FIND NEXT/PREVIOUS RECORD */
        {mfnp.i fm_mstr fm_fpos fm_fpos fm_fpos fm_fpos fm_fpos}

        if recno <> ? then do:

/*XXCH911*/        for first qad_wkfl where qad_key1 = "fm_desc" and qad_key2 = string(fm_fpos, "999999")
/*XXCH911*/            exclusive-lock: end. 
/*XXCH911*/        if not available qad_wkfl then do:
/*XXCH911*/            create qad_wkfl.
/*XXCH911*/            qad_key1 = "fm_desc".
/*XXCH911*/            qad_key2 = string(fm_fpos, "999999").
/*XXCH911*/        end.

/*XXCH911*/        desc1 = qad_charfld[1] + qad_charfld[2] + qad_charfld[3].
/*XXCH911*/        desc2 = qad_charfld[4] + qad_charfld[5].
/*XXCH911*/        display desc1 desc2 with frame a.
           display fm_fpos fm_desc fm_sums_into fm_type
/*G026*/           fm_dr_cr fm_sub_sort fm_cc_sort fm_page_brk
               fm_header fm_total fm_skip fm_underln with frame a.
           find f1 where f1.fm_fpos = fm_mstr.fm_sums_into no-lock
              no-error.
           if available f1 then display f1.fm_desc @ sums_desc.
           else display "" @ sums_desc.
        end.
         end.
/*GUI*/ if global-beam-me-up then undo, leave.


         /* ADD/MOD/DELETE  */
         find fm_mstr using fm_mstr.fm_fpos no-error.
         if not available fm_mstr then do:
        {mfmsg.i 1 1}   /* Adding new record */
        create fm_mstr.
        assign fm_mstr.fm_fpos.
         end.
         recno = recid(fm_mstr).
         fm_recno = recno.

/*XXCH911*/ for first qad_wkfl where qad_key1 = "fm_desc" and qad_key2 = string(fm_mstr.fm_fpos, "999999")
/*XXCH911*/     exclusive-lock: end.
/*XXCH911*/ if not available qad_wkfl then do:
/*XXCH911*/    create qad_wkfl.
/*XXCH911*/    qad_key1 = "fm_desc".
/*XXCH911*/    qad_key2 = string(fm_mstr.fm_fpos, "999999").
/*XXCH911*/ end.

         ststatus  =  stline[2].
         status input ststatus.
         del-yn = no.

/*XXCH911*/  find first qad_wkfl where qad_key1 = "fm_desc" and
/*XXCH911*/       qad_key2 = string(fm_mstr.fm_fpos, "999999") .
/*XXCH911*/  assign desc1 = qad_charfld[1] + qad_charfld[2] + qad_charfld[3]
/*XXCH911*/         desc2 = qad_charfld[4] + qad_charfld[5].
/*XXCH911*/  display desc1 desc2 with frame a.

         display fm_mstr.fm_desc fm_mstr.fm_sums_into fm_mstr.fm_type
                 validate(fm_mstr.fm_type = "B" or fm_mstr.fm_type = "I" or fm_mstr.fm_type = "C",
      "FORMAT TYPE MUST BE B -BALANCE SHEET OR I -INCOME STMT OR C -Cash Flow.")
/*G026*/      fm_mstr.fm_dr_cr fm_mstr.fm_sub_sort fm_mstr.fm_cc_sort
          fm_mstr.fm_page_brk fm_mstr.fm_header fm_mstr.fm_total
          fm_mstr.fm_skip fm_mstr.fm_underln
          with frame a.
         loopa: do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

        set fm_mstr.fm_desc
/*XXCH911*/ desc1 desc2
	    fm_mstr.fm_sums_into fm_mstr.fm_type
/*G026*/        fm_mstr.fm_dr_cr fm_mstr.fm_sub_sort fm_mstr.fm_cc_sort
            fm_mstr.fm_page_brk fm_mstr.fm_header fm_mstr.fm_total
            fm_mstr.fm_skip fm_mstr.fm_underln
            go-on("F5" "CTRL-D").

/*XXCH911*/ assign  qad_charfld[1] = substring(desc1, 1, 8, "RAW")
/*XXCH911*/         qad_charfld[2] = substring(desc1, 9, 8, "RAW")
/*XXCH911*/         qad_charfld[3] = substring(desc1,17, 8, "RAW")
/*XXCH911*/         qad_charfld[4] = substring(desc2, 1, 8, "RAW")
/*XXCH911*/         qad_charfld[5] = substring(desc2, 9, 8, "RAW").

        /* DELETE */
        if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
           then do:
           del-yn = yes.
           {mfmsg01.i 11 1 del-yn}
           if del-yn = no then undo loopa.
        end.

        if del-yn then do:
           /*CHECK FOR FORMAT POSITIONS USING FORMAT POSITION
             FOR SUMS INTO*/
           sums_into = fm_mstr.fm_fpos.
           if can-find (first fm_mstr where
              fm_mstr.fm_sums_into = sums_into) then do:
              {mfmsg.i 3042 3} /* CANNOT DELETE--FORMAT POSITION USED AS
                       'SUMS INTO' */
              undo loopa.
           end.
           /* CHECK FOR ACCOUNT MASTERS USING FORMAT POSITION */
           if can-find (first ac_mstr where ac_fpos = fm_mstr.fm_fpos)
              then do:
              {mfmsg.i 3003 3}
              undo loopa.
           end.

           /* OK TO DELETE */
           delete fm_mstr.
/*XXCH911*/ delete qad_wkfl.
           clear frame a.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
           del-yn = no.
           next mainloop.
        end.

        else do:
           if fm_mstr.fm_sums_into = fm_mstr.fm_fpos then do:
              {mfmsg.i 3012 3} /* INVALID FORMAT POSITION */
              next-prompt fm_mstr.fm_sums_into with frame a.
              undo loopa, retry.
           end.

           sums_into = fm_mstr.fm_sums_into.
           find f1 where f1.fm_fpos = sums_into no-lock no-error.
           if not available f1  and sums_into <> 0 then do:
               {mfmsg.i 3012 3} /* INVALID FORMAT POSITION */
               next-prompt fm_mstr.fm_sums_into with frame a.
               undo loopa, retry.
           end.
           if available f1 then display f1.fm_desc @ sums_desc
              with frame a.

           /* CHECK FOR CYCLICAL FORMAT POSITIONS */
           {gprun.i ""glfmmta.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

           if fm_recno = 0 then do:
              {mfmsg.i 3043 3} /* CYCLICAL FORMAT POSITION */
              next-prompt fm_mstr.fm_sums_into with frame a.
              undo loopa, retry.
           end.
        end.
         end.
/*GUI*/ if global-beam-me-up then undo, leave.

      end.
      status input.
