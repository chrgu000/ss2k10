/* GUI CONVERTED from utshrel.p (converter v1.78) Fri Oct 29 14:34:21 2004 */
/* utshrel.p - UTILITY PROGRAM TO DELETE STRANDED qad_wkfl RECORDS            */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*V8:ConvertMode=Report  */

/* REVISION: 8.5            CREATED: 11/03/97   By: *H1GD* Seema Varma        */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KC* myb                */
/* REVISION: 9.1      LAST MODIFIED: 09/01/00   BY: *N0QX* Jean Miller        */
/* REVISION: 9.1      LAST MODIFIED: 09/04/00   BY: *N0RD* Jean Miller        */

/******************************************************************************
This utility reports and optionally deletes stranded qad_wkfl records.
Confirm Shipper (7.11.9 - rcsois.p) uses the qad_wkfl to keep track of
Sales Orders that are in the process of being confirmed. However, if the
confirmation is aborted, then the qad_wkfl records are stranded. Hence,
no shipper associated with any of these orders can be confirmed until
the stranded qad_wkfl records are deleted."
******************************************************************************/


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

         {mfdtitle.i "b+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE utshrel_p_1 "Shipper"
/* MaxLen: Comment: */

&SCOPED-DEFINE utshrel_p_2 "Time Locked"
/* MaxLen: Comment: */

&SCOPED-DEFINE utshrel_p_3 "Sales Order"
/* MaxLen: Comment: */

&SCOPED-DEFINE utshrel_p_4 "User"
/* MaxLen: Comment: */

&SCOPED-DEFINE utshrel_p_5 "Session"
/* MaxLen: Comment: */

&SCOPED-DEFINE utshrel_p_6 "Ship-from"
/* MaxLen: Comment: */

&SCOPED-DEFINE utshrel_p_7 "Preshipper/Shipper"
/* MaxLen: Comment: */

&SCOPED-DEFINE utshrel_p_8 "Date Locked"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

         define variable l_user    like global_userid no-undo.
         define variable l_session like mfguser       no-undo.
         define variable l_shipper like abs_id        no-undo.
         define variable l_del_yn  like mfc_logical   no-undo.
         define variable l_type    as   logical format {&utshrel_p_7} no-undo.
        
         
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
/*N0QX*     {t06r.i} */
            
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
    {xxt06r.i}
    l_user    label {&utshrel_p_4}    colon 20
            l_session label {&utshrel_p_5} colon 20
         
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

         /* Display Utility Information */
/*N0QX*/ /*{gpcdget.i "UT"}*/

         view frame a.

         mainloop:
         repeat:

            display
               l_user
               l_session
            with frame a.

            set
               l_user
               l_session
            with frame a.

            /* SELECT PRINTER */
            {mfselprt.i "printer" 132}
/*GUI*/ RECT-FRAME:HEIGHT-PIXELS in frame a = FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.

            {mfphead.i}

            for each qad_wkfl where (qad_key3       = "xxrcsotr.p" OR qad_key3 = "xxshipperexp.p")  and
                    (qad_key4       = l_session   or
                     l_session      = ""       )  and
                    (qad_charfld[1] = l_user      or
                     l_user         = ""       )
            no-lock by qad_charfld[2]
            by qad_key2
            with frame b down no-attr-space width 132:

               if substring(qad_charfld[2] ,1,1) = "P"
               then
                  l_type = true.
               else if substring(qad_charfld[2] ,1,1) = "S" then
                  l_type = false.
               l_shipper =
                  substring(qad_charfld[2],2,length(qad_charfld[2]) - 1).

               /* SET EXTERNAL LABELS */
               setFrameLabels(frame b:handle).

               display
                  l_type          label {&utshrel_p_7}
                  l_shipper       label {&utshrel_p_1}
                  qad_key2        label {&utshrel_p_3}
                  qad_charfld[1]  label {&utshrel_p_4}
                  qad_key4        label {&utshrel_p_5}
                  qad_charfld[3]  label {&utshrel_p_6}
                  qad_date[1]     label {&utshrel_p_8}
                  qad_charfld[5]  label {&utshrel_p_2} WITH STREAM-IO /*GUI*/ .

               down with frame b.

            end. /* FOR EACH qad_wkfl */

            {mfrtrail.i}

            l_del_yn =  no.

            /* CONFIRM DELETE */
            {mfmsg01.i 11 1 l_del_yn}

            if not l_del_yn then next mainloop.

            for each qad_wkfl where (qad_key3       = "xxrcsotr.p" OR qad_key3 = "xxshipperexp.p")   and
                   (qad_key4       = l_session   or
                    l_session      = ""       )  and
                   (qad_charfld[1] = l_user      or
                    l_user         = ""       )
            exclusive-lock:
               delete qad_wkfl.
            end. /* FOR EACH qad_wkfl */

        end. /* MAINLOOP */
