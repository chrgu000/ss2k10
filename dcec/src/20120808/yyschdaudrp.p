
/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i}

define variable ponbr        like po_nbr.
define variable ponbr1       like po_nbr.
DEFINE VARIABLE ln           LIKE pod_line.
DEFINE VARIABLE ln1          LIKE pod_line.
define variable rlseid       like schd_rlse_id FORMAT "X(18)".
define variable rlseid1      like schd_rlse_id FORMAT "X(18)".
define variable usernumber   like aud_userid.
define variable usernumber1  like aud_userid.
define variable dt           like aud_date.
define variable dt1          like aud_date.
define variable povend       like aud_key1 label "Address Code".
define variable povend1      like povend.
DEFINE VARIABLE prg          LIKE execname FORMAT "X(16)" LABEL "Program" .

/* SELECT FORM */

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
   
   povend         COLON 20   povend1     COLON 55 LABEL "To"
   ponbr        COLON 20   ponbr1    COLON 55 LABEL "To"
   rlseid       COLON 20   rlseid1   COLON 55 LABEL "To"
   usernumber        colon 20   usernumber1    colon 55 label "To"
   dt           colon 20   dt1       COLON 55 LABEL "To"
   prg          COLON 20   

SKIP(.4)  /*GUI*/
with frame a side-labels attr-space
width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = &IF (DEFINED(SELECTION_CRITERIA) = 0)
  &THEN " Selection Criteria "
  &ELSE {&SELECTION_CRITERIA}
  &ENDIF .
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME


 FORM
    ad_addr po_nbr pod_line pod_part sch_rlse_id FORMAT "X(18)" schd_date aud_old_data[1] FORMAT "X(12)" 
    aud_new_data[1] FORMAT "X(12)" aud_date aud_time aud_userid execname format "X(16)"
 WITH DOWN FRAME c WIDTH 180 STREAM-IO. 


setFrameLabels(frame a:handle).



{wbrp01.i}

/* REPORT BLOCK */

{mfguirpa.i true "printer" 180 " " " " " "  }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:

   if povend1    = hi_char  then povend1    = "".
   if ponbr1   = hi_char  then ponbr1   = "".
   if rlseid1  = hi_char  then rlseid1  = "".
   if usernumber1  = hi_char   then usernumber1   = "".
   if dt      = low_date  then dt       = ?.
   if dt1     = hi_date   then dt1      = ?.

if c-application-mode <> 'web' then
      
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


   {wbrp06.i &command = update &fields = "povend  povend1  ponbr  ponbr1  rlseid  rlseid1  usernumber   usernumber1  dt  dt1 prg " &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      /* CREATE BATCH INPUT STRING */
      bcdparm = "".
      {mfquoter.i povend     }
      {mfquoter.i povend1    }
      {mfquoter.i ponbr    }
      {mfquoter.i ponbr1   }
      {mfquoter.i rlseid   }
      {mfquoter.i rlseid1  }
      {mfquoter.i usernumber    }
      {mfquoter.i usernumber1   }
      {mfquoter.i dt       }
      {mfquoter.i dt1      }
      {mfquoter.i prg      }


      if povend1    = ""  then povend1    =  hi_char.
      if ponbr1   = ""  then ponbr1   =  hi_char.
      if rlseid1  = ""  then rlseid1  =  hi_char.
      if usernumber1   = ""  then usernumber1   =  hi_char.
      if dt       = ?   then dt       =  low_date.
      if dt1      = ?   then dt1      =  hi_date.


   end.

   /* OUTPUT DESTINATION SELECTION */
   
/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i "printer" 132 " " " " " " " " }


   {mfphead.i}

   for each aud_det
         where aud_dataset = "schd_det" and
               aud_key1    >= povend   and aud_key1    <= povend1   and
               aud_key3    >= ponbr  and aud_key3    <= ponbr1  and
               aud_key4    >= rlseid AND aud_key4    <= rlseid1 AND
               (aud_key7    =  prg    OR prg = "" )             AND
               aud_date    >= dt     and aud_date    <= dt1     and
               aud_userid  >= usernumber  and aud_userid  <= usernumber1  
               
         no-lock use-index aud_dataset:

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame c:handle).

         
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/

        DISP aud_key1 @ ad_addr
             aud_key3 @ po_nbr 
             int(aud_key5) @ pod_line
             aud_key4 @ sch_rlse_id 
             aud_key6 @ schd_date 
             aud_user1 @ pod_part
             aud_old_data[1] COLUMN-LABEL "修改前" 
             aud_new_data[1] COLUMN-LABEL "修改后"
             aud_date 
             aud_time
             aud_userid  
             aud_key7 @ execname
        WITH FRAME c STREAM-IO.
        DOWN WITH FRAME c.

      end.
   /* REPORT TRAILER  */
   
/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/



{wbrp04.i &frame-spec = a}

/*GUI*/ end procedure. /*p-report*/
/*GUI*/ {mfguirpb.i &flds=" povend   povend1  ponbr  ponbr1  rlseid  rlseid1  usernumber   usernumber1  dt  dt1 prg"} /*Drive the Report*/
