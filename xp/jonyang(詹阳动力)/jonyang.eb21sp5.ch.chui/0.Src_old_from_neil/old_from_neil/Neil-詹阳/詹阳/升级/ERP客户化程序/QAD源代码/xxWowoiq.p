/* GUI CONVERTED from wowoiq.p (converter v1.71) Tue Oct  6 14:58:38 1998 */
/* wowoiq.p - WORK ORDER INQUIRY                                        */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* web convert wowoiq.p (converter v1.00) Thu Feb 26 14:03:48 1998 */
/* web tag in wowoiq.p (converter v1.00) Thu Feb 26 14:03:39 1998 */
/*F0PN*/ /*K1K3*/ /*V8#ConvertMode=WebReport                            */
/*V8:ConvertMode=Report                                        */
/* REVISION: 1.0      LAST MODIFIED: 04/15/86   BY: PML                 */
/* REVISION: 1.0      LAST MODIFIED: 05/07/86   BY: EMB                 */
/* REVISION: 2.1      LAST MODIFIED: 09/10/87   BY: WUG *A94*           */
/* REVISION: 4.0      LAST EDIT: 12/30/87       BY: WUG *A137*          */
/* REVISION: 5.0      LAST EDIT: 05/03/89       BY: WUG *B098*          */
/* REVISION: 5.0      LAST MODIFIED: 11/14/89   BY: MLB *B391*          */
/* REVISION: 5.0      LAST MODIFIED: 03/15/90   BY: emb *B357*          */
/* Revision: 7.3      Last edit: 11/19/92       By: jcd *G339*          */
/* REVISION: 7.0      LAST MODIFIED: 08/30/94   BY: ais *FQ61*          */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 02/26/98   BY: *K1K3* Beena Mol    */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */

/* ********** Begin Translatable Strings Definitions ********* */

/*K1K3*/ /* DISPLAY TITLE */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

/*K1K3*/ {mfdtitle.i "e+ "}

&SCOPED-DEFINE wowoiq_p_1 "∂Ã»±¡ø"
/* MaxLen: Comment: */

&SCOPED-DEFINE wowoiq_p_2 "    ∂Ã»±¡ø"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

     define variable nbr like wo_nbr.
     define variable lot like wo_lot.
     define variable due like wo_due_date.
     define variable so_job like wo_so_job.
     define variable part like pt_part.
/*FQ61*/ define variable site like wo_site.
     define variable s_qty_open as character format "x(10)"
        label {&wowoiq_p_2}.
/*B357*/ define variable qty_open as decimal label {&wowoiq_p_1}.

/*K1K3* /* DISPLAY TITLE */
 *     {mfdtitle.i "e+ "} */
     part = global_part.

/*FQ61**
       * form
       *    part
       *    nbr
       *    lot
       *    due
       *    so_job
       * with frame a no-underline.
**FQ61**/

/*FQ61*/ 
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
/*FQ61*/    
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
part        at 2
/*FQ61*/    nbr
/*FQ61*/    lot         colon 68
/*FQ61*/    due         at 2
/*FQ61*/    so_job
/*FQ61*/    site
/*FQ61*/ with frame a width 80 side-labels no-underline NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/*K1K3*/ {wbrp01.i}

         repeat:

/*K1K3*/ if c-application-mode <> 'web':u then
        update part nbr lot due so_job
/*FQ61*/    site
        with frame a editing:

           if frame-field = "part" then do:
          /* FIND NEXT/PREVIOUS RECORD */
          {mfnp.i wo_mstr part wo_part part wo_part wo_part}
          if recno <> ? then do:
             part = wo_part.
             display part with frame a.
             recno = ?.
          end.
           end.
           else do:
          status input.
          readkey.
          apply lastkey.
           end.
        end.

/*K1K3*/ {wbrp06.i &command = update &fields = "  part nbr lot due so_job
          site" &frm = "a"}

/*K1K3*/ if (c-application-mode <> 'web':u) or
/*K1K3*/ (c-application-mode = 'web':u and
/*K1K3*/ (c-web-request begins 'data':u)) then do:

        hide frame b.
        hide frame c.
        hide frame d.
        hide frame e.
        hide frame f.
        hide frame g.

/*K1K3*/ end.

        /* SELECT PRINTER */
        {mfselprt.i "terminal" 100}
/*GUI*/ RECT-FRAME:HEIGHT-PIXELS in frame a = FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.


        /* FIND AND DISPLAY */
        if part <> "" then
        for each wo_mstr where (wo_part = part)
/*FQ61*/       and (wo_site = site or site = "")
           and (wo_lot = lot or lot = "" )
           and (wo_nbr = nbr or nbr = "" )
           and (wo_due_date = due or due = ?)
           and (wo_so_job = so_job or so_job = "" )
           no-lock
/*B391*/          by wo_due_date descending
           with frame b:
          
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/
                     /*G339*/

          {mfwoiq-1.i}

           end.

        else if nbr <> "" then
        for each wo_mstr where (wo_nbr = nbr)
           and (wo_lot = lot or lot = "" )
/*FQ61*/       and (wo_site = site or site = "")
           and (wo_due_date = due or due = ?)
           and (wo_so_job = so_job or so_job = "" ) no-lock
/*B391*/          by wo_due_date descending
           with frame c:
          
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/
                     /*G339*/

          {mfwoiq-1.i}

        end.

        else if lot <> "" then
        for each wo_mstr where (wo_lot = lot)
           and (wo_due_date = due or due = ?)
/*FQ61*/       and (wo_site = site or site = "")
           and (wo_so_job = so_job or so_job = "" ) no-lock
/*B391*/       by wo_due_date descending
        with frame d:
           
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/
                     /*G339*/

           {mfwoiq-1.i}

        end.

        else if due <> ? then
        for each wo_mstr where (wo_due_date = due)
/*FQ61*/       and (wo_site = site or site = "")
           and (wo_so_job = so_job or so_job = "" ) no-lock
        with frame e:
           
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/
                     /*G339*/

           {mfwoiq-1.i}

        end.

        else if so_job <> "" then
        for each wo_mstr where wo_so_job = so_job
/*FQ61*/       and (wo_site = site or site = "")
           no-lock
/*B391*/    by wo_due_date descending
        with frame f:
           
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/
                     /*G339*/

           {mfwoiq-1.i}

        end.

        else
        for each wo_mstr
/*FQ61*/       where wo_site = site or site = ""
           no-lock
/*B391*/       by wo_due_date descending
        with frame g:
           
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/
                     /*G339*/

           {mfwoiq-1.i}

        end.

        {mfreset.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

        {mfmsg.i 8 1}
     end.
     global_part = part.

/*K1K3*/ {wbrp04.i &frame-spec = a}
