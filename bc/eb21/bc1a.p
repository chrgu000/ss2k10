/* mf1a.p - Mfg/pro Manufacturing Entry Program - Translatable Section        */
/* Copyright 1986-2008 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*                                                                            */
/*                                                                            */
/*                                                                            */
/* Note: All translatable source code for the startup procedures should       */
/*       be placed into this routine.  This program should be placed          */
/*       in the same directory as mfmenu.p, not mf.p and mf1.p.               */
/*       05/14/93 - rwl                                                       */
/*                                                                            */
/*                                                                     *H259* */
/*                                                                     *Hxxx* */
/*  Revision:       By: rwl            Date: 05/18/93  Rel: 7.3   ECO: *GA97* */
/*  Revision:       By: rwl            Date: 06/25/93  Rel: 7.3   ECO: *GC72* */
/*  Revision:       By: rwl            Date: 06/29/93  Rel: 7.3   ECO: *GC82* */
/*  Revision:       By: gjp            Date: 09/22/93  Rel: 7.3   ECO: *GF76* */
/*  Revision:       By: rwl            Date: 10/04/93  Rel: 7.3   ECO: *GG14* */
/*  Revision:       By: dgh            Date: 10/27/93  Rel: 7.4   ECO: *H213* */
/*  Revision:       By: rwl            Date: 11/15/93  Rel: 7.4   ECO: *H223* */
/*  Revision:       By: rwl            Date: 11/16/93  Rel: 7.4   ECO: *H231* */
/*  Revision:       By: rmh            Date: 06/09/94  Rel: 7.4   ECO: *FO45* */
/*  Revision:       By: rmh            Date: 06/14/94  Rel: 7.4   ECO: *FO83* */
/*  Revision:       By: rmh            Date: 08/23/94  Rel: 7.4   ECO: *H485* */
/*  Revision:       By: rmh            Date: 07/13/94  Rel: 7.4   ECO: *FO79* */
/*  Revision:       By: dgh            Date: 09/19/94  Rel: 7.4   ECO: *FR63* */
/*  Revision:       By: ame            Date: 11/02/94  Rel: 7.4   ECO: *GO04* */
/*  Revision:       By: ame            Date: 12/09/94  Rel: 7.4   ECO: *GO82* */
/*  Revision:       By: rwl            Date: 01/13/95  Rel: 7.4   ECO: *G0C0* */
/*  Revision:       By: jzs            Date: 03/25/95  Rel: 7.4   ECO: *G0KC* */
/*  Revision:       By: aed            Date: 04/10/95  Rel: 7.4   ECO: *H0D2* */
/*  Revision:       By: srk            Date: 04/27/95  Rel: 7.4   ECO: *H0DH* */
/*  Revision:       By: dzn            Date: 06/05/95  Rel: 7.4   ECO: *H0DS* */
/*  Revision:       By: jzs            Date: 10/27/95  Rel: 7.4   ECO: *H0GM* */
/*  Revision:       By: str            Date: 11/01/95  Rel: 7.4   ECO: *G1BN* */
/*  Revision:       By: dxb            Date: 12/01/95  Rel: 7.4   ECO: *F0WH* */
/*  Revision:       By: dzn            Date: 12/13/95  Rel: 7.4   ECO: *G1G9* */
/*  Revision:       By: jzs            Date: 12/20/95  Rel: 7.4   ECO: *G1GR* */
/*  Revision:       By: tvo            Date: 11/28/95  Rel: 7.4   ECO: *J094* */
/*  Revision:       By: aed            Date: 03/27/85  Rel: 7.4   ECO: *J0G1* */
/*  Revision:       By: jpm            Date: 04/03/96  Rel: 7.4   ECO: *G1MP* */
/*  Revision:       By: GWM            Date: 04/24/96  Rel: 7.4   ECO: *J0K8* */
/*  Revision:       By: taf            Date: 07/02/96  Rel: 7.4   ECO: *J0X5* */
/*  Revision:       By: taf            Date: 07/10/96  Rel: 7.4   ECO: *J0YK* */
/*  Revision:       By: rkc            Date: 07/12/96  Rel: 7.4   ECO: *G1WV* */
/*  Revision:       By: jpm            Date: 10/22/96  Rel: 7.4   ECO: *K017* */
/*  Revision:       By: dxb            Date: 11/11/96  Rel: 7.4   ECO: *H0P2* */
/*  Revision:       By: JPM            Date: 03/12/97  Rel: 8.6   ECO: *K081* */
/*  Revision:       By: Duane Burdett  Date: 03/26/97  Rel: 8.6   ECO: *G2LR* */
/*  Revision:       By: Cynthia J. Te  Date: 04/04/97  Rel: 8.6   ECO: *G2M3* */
/*  Revision:       By: David J. Seo   Date: 04/04/97  Rel: 8.6   ECO: *J1JH* */
/*  Revision:       By: David J. Seo   Date: 04/15/97  Rel: 8.6   ECO: *G2M9* */
/*  Revision:       By: Verghese Kuri  Date: 04/29/97  Rel: 8.6   ECO: *J1Q5* */
/*  Revision:       By: David J. Seo   Date: 05/27/97  Rel: 8.6   ECO: *G2N4* */
/*  Revision:       By: Cynthia Terry  Date: 07/07/97  Rel: 8.6   ECO: *J1VR* */
/*  Revision:       By: John Worden    Date: 07/18/97  Rel: 8.6   ECO: *K0GN* */
/*  Revision:       By: Jean Miller    Date: 09/12/97  Rel: 8.6   ECO: *K0HY* */
/*  Revision:       By: Patrick Rowan  Date: 09/12/97  Rel: 8.6   ECO: *J1YW* */
/*  Revision:       By: Surendra Kuma  Date: 10/03/97  Rel: 8.6   ECO: *K0JN* */
/*  Revision:       By: Steve Nugent   Date: 10/28/97  Rel: 8.6   ECO: *J24M* */
/*  Revision:       By: A. Rahane      Date: 02/23/98  Rel: 8.6E  ECO: *L007* */
/*  Revision:       By: A. Rahane      Date: 03/02/98  Rel: 8.6E  ECO: *L008* */
/*  Revision:       By: Suhas Bhargav  Date: 05/06/98  Rel: 8.6E  ECO: *J2JB* */
/*  Revision:       By: Alfred Tan     Date: 05/20/98  Rel: 8.6E  ECO: *K1Q4* */
/*  Revision:       By: Sachin Shah    Date: 05/26/98  Rel: 8.6E  ECO: *J2KK* */
/*  Revision:       By: Paul Knopf     Date: 06/02/98  Rel: 8.6E  ECO: *K1NM* */
/*  Revision:       By: Viswanathan M  Date: 06/19/98  Rel: 8.6E  ECO: *J2PL* */
/*  Revision:       By: Raphael Thopp  Date: 07/23/98  Rel: 8.6E  ECO: *J2TM* */
/*  Revision:       By: Vijaya Pakala  Date: 09/25/98  Rel: 8.6E  ECO: *J2Z2* */
/*  Revision:       By: Vijaya Pakala  Date: 11/10/98  Rel: 8.6E  ECO: *J33W* */
/*  Revision:       By: Mayse Lai      Date: 12/17/98  Rel: 9.0   ECO: *M03R* */
/*  Revision:       By: Vijaya Pakala  Date: 01/14/99  Rel: 9.0   ECO: *J38L* */
/*  Revision:       By: Hemanth Ebene  Date: 03/10/99  Rel: 9.0   ECO: *M0B8* */
/*  Revision:       By: Alfred Tan     Date: 03/13/99  Rel: 9.0   ECO: *M0BD* */
/*  Revision:       By: A. Philips     Date: 08/09/99  Rel: 9.0   ECO: *J3KC* */
/*  Revision:       By: Robin McCarth  Date: 09/28/99  Rel: 9.1   ECO: *N014* */
/*  Revision:       By: Jean Miller    Date: 11/24/99  Rel: 9.0   ECO: *M0G0* */
/*  Revision:       By: Kevin Schantz  Date: 12/05/99  Rel: 9.1   ECO: *J3MV* */
/*  Revision:       By: Raphael Thopp  Date: 12/15/99  Rel: 9.1   ECO: *J3N0* */
/*  Revision:       By: Jean Miller    Date: 03/06/00  Rel: 9.1   ECO: *N082* */
/*  Revision:       By: Raphael Thoppil Date: 02/23/00  Rel: 9.1  ECO: *J3PC* */
/*  Revision: 1.48  By: Dennis Taylor    Date: 03/27/00  Rel: 9.1 ECO: *N08T* */
/*  Revision: 1.50  By: Bill Gates       Date: 01/28/00  Rel: 9.1 ECO: *N06R* */
/*  Revision: 1.51  By: Annasaheb Rahane Date: 07/12/00  Rel: 9.1 ECO: *N0FX* */
/*  Revision: 1.52  By: Jean Miller      Date: 08/09/00  Rel: 9.1 ECO: *N0JS* */
/*  Revision: 1.53  By: Jean Miller      Date: 08/10/00  Rel: 9.1 ECO: *N0JY* */
/*  Revision: 1.54  By: Annasaheb Rahane Date: 09/25/00  Rel: 9.1 ECO: *N0S8* */
/*  Revision: 1.55  By: Jean Miller      Date: 10/23/00  Rel: 9.1 ECO: *N0T3* */
/*  Revision: 1.57    By: Jean Miller       Date: 07/30/01        ECO: *N10T* */
/*  Revision: 1.58    By: Falguni D.        Date: 08/06/01        ECO: *P01D* */
/*  Revision: 1.59    By: Anil Sudhakaran   Date: 10/18/01        ECO: *M1ND* */
/*  Revision: 1.60    By: Dipesh Bector     Date: 11/19/01        ECO: *N167* */
/*  Revision: 1.61    By: Raju Murugesan    Date: 06/13/02        ECO: *P07X* */
/*  Revision: 1.66    By: Jean Miller       Date: 06/20/02        ECO: *P09H* */
/*  Revision: 1.72    By: Mugdha Tambe      Date: 07/21/02        ECO: *P08G* */
/*  Revision: 1.74    By: Jean Miller       Date: 08/13/02        ECO: *P0F5* */
/*  Revision: 1.76    By: Jean Miller       Date: 08/15/02        ECO: *P0FG* */
/*  Revision: 1.77    By: Rajaneesh S.      Date: 08/29/02        ECO: *M1BY* */
/*  Revision: 1.78    By: Jean Miller       Date: 11/25/02        ECO: *P0KS* */
/*  Revision: 1.79    By: Rafal Krzyminski  Date: 01/15/03        ECO: *P0LX* */
/*  Revision: 1.81    By: Marek Krajanowski Date: 02/27/03        ECO: *P0NH* */
/*  Revision: 1.82    By: Narathip W.       Date: 04/30/03        ECO: *P0QX* */
/*  Revision: 1.85    By: Paul Donnelly     DATE: 07/01/03        ECO: *Q00H* */
/*  Revision: 1.86    By: Ed van de Gevel   DATE: 07/08/03        ECO: *Q003* */
/*  Revision: 1.87    By: Neil Curzon       DATE: 09/12/03        ECO: *Q039* */
/*  Revision: 1.88    By: Jean Miller       Date: 09/22/03        ECO: *P12V* */
/*  Revision: 1.92    By: Michael Hansen    Date: 11/14/03        ECO: *Q04K* */
/*  Revision: 1.93    By: Michael Hansen    Date: 04/06/04        ECO: *Q06Y* */
/*  Revision: 1.94    By: Narathip W.       Date: 06/08/04        ECO: *P256* */
/*  Revision: 1.95    BY: Michael Hansen    DATE: 07/15/04        ECO: *Q06H* */
/*  Revision: 1.96    BY: Vinay Soman       DATE: 08/19/04        ECO: *Q0CF* */
/*  Revision: 1.97    BY: Vinay Soman       DATE: 08/24/04        ECO: *P2GK* */
/*  Revision: 1.105   BY: Michael Hansen    DATE: 10/27/04        ECO: *Q0D7* */
/*  Revision: 1.113   BY: Michael Hansen    DATE: 11/08/04        ECO: *Q0F7* */
/*  Revision: 1.116   BY: Sandy Brown       DATE: 01/04/05        ECO: *P2HX* */
/*  Revision: 1.118   BY: Tiziana Giustozzi DATE: 05/02/05        ECO: *Q0HZ* */
/*  Revision: 1.120   BY: Abhishek Jha      DATE: 08/25/05        ECO: *P3ZJ* */
/*  Revision: 1.123   BY: Sushant Pradhan   DATE: 09/26/05        ECO: *P42J* */
/*  Revision: 1.123.1.1 BY: Amit Singh      DATE: 12/13/05        ECO: *P4C0* */
/*  Revision: 1.123.1.3 BY: Katie Hilbert   DATE: 06/07/07        ECO: *Q16K* */
/*  Revision: 1.123.1.4 BY: Ashim Mishra    DATE: 10/29/07        ECO: *Q1DJ* */
/*  $Revision: 1.123.1.5 $ BY: Katie Hilbert    DATE: 01/16/08        ECO: *Q1GM* */
/*-Revision end---------------------------------------------------------------*/
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*V8:ConvertMode=ConditionalIncludeExclude                                    */

{mfdeclre.i}

{cxcustom.i "MF1A.P"}

{&MF1A-P-TAG1}
{mf1.i}
{pxsevcon.i}

{pxmaint.i}
{mgconsdf.i}

/************************** Function Prototypes *********************/
function offerNewPassword returns character
   (input p-userid as character) forward.

&SCOPED-DEFINE CONCURRENT-SESSIONS 0
&SCOPED-DEFINE NAMED-USERS         1
&SCOPED-DEFINE LOCATION-USERS      2
&SCOPED-DEFINE CAPACITY-UNITS      3
&SCOPED-DEFINE FIXED-PRICE         4

/* MAKE LABEL FUNCTION DECLARATIONS AND RUN LABEL PROGRAM PERSISTENT. */
/* IN CHUI THE PERSISTENT GPLABEL.P IS RESTARTED IF WE'VE RETURNED    */
/* HERE FROM THE MENU SYSTEM. IN EFFECT EMPTYING THE LABEL TEMP TABLE */
/* ALLOWING NEW LABELS ADDED DURING THE SESSION TO BE USED.           */
{gplabel.i &ClearReg=yes}

{gpfilev.i}

/* DEFINE ALL VARIABLES AND STREAM FOR AUDIT TRAIL. */
{gpaud.i &uniq_num1 = 01
    &uniq_num2      = 02
    &db_file        = usr_mstr
    &db_field       = usr_userid}

define shared variable h_mfinitpl as handle no-undo.
define shared variable password_required as logical initial yes no-undo.

define variable i as integer no-undo.
define variable token1 as character no-undo.
define variable current_user_lang like global_user_lang no-undo.

define variable passwd as character label "Password" format "x(16)"
   case-sensitive no-undo.

define variable temp_vers as character no-undo format "x(78)".
define variable o_passwd like passwd no-undo.

define variable expdays like usrc_expire_days no-undo.
define variable expired like mfc_logical initial no no-undo.
define variable rstatus as character no-undo.

define variable first-time      as logical initial true     no-undo.
define variable v_cur           as integer    no-undo.
define variable v_max           as integer    no-undo.
define variable v_secure        as logical    no-undo.
define variable v_sid           as character  no-undo.
define variable lv-handle       as handle     no-undo.
define variable v_licType       as integer    no-undo.
define variable v_licDesc       as character  no-undo.

define variable c-welcome           as character format "x(78)" no-undo.
define variable c-allrightsreserved as character format "x(27)" no-undo.
define variable c-notreproduced     as character format "x(78)" no-undo.
define variable h-widget            as handle no-undo.
define variable msg-text        like msg_desc no-undo.
define variable l_usercount     as integer no-undo.
define variable l_locked        as logical no-undo.
define variable using_GRS      like mfc_logical no-undo label "Using GRS".

define variable new_list        as character no-undo.
define variable userISOCountry  as character no-undo.
define variable c-countryCode   as character no-undo.
define variable c-variantCode   as character no-undo.

define variable lv_domain like dom_domain no-undo.
define variable l_error   as integer      no-undo.

define variable i-msg-number      as integer   no-undo.
define variable c-msg-desc        as character no-undo.
define variable c-status          as character no-undo.
define variable c-userid          as character no-undo.
define variable c-password        as character no-undo
                label "Password" format "x(16)" case-sensitive.
define variable c-last-log-date  as character no-undo.
define variable c-last-log-time  as character no-undo.
define variable c-last-log-zone  as character no-undo.

define variable c-logon          as integer   no-undo.
define variable c-ret-message    as character no-undo.
define variable l-ret-value      as logical   no-undo.
define variable l_authorized     as logical   no-undo.
define variable l_enforce_os_userid as logical initial no no-undo.
define variable l_passwd_chg     like mfc_logical initial no no-undo.
define variable cprt             as character format "x(34)".
/* SET MESSAGE HANDLER TO RUN PROCEDURE REGISTERREASONMESSAGE */
run setMessageHandlerHandle in h_mfinitpl
   (input this-procedure).

subscribe to "previousSuccessfulLogin" in h_mfinitpl.

{gprunpdf.i "gpurxr" "p"}
{gprunpdf.i "lvgenpl" "p"}

/*V8!
define variable previous_userid as character.
{mfqwizrd.i}
{mf8def.i}
{mf8trig.i}
{mf8proc.i}
*/

/*V8-*/
define variable passwd-matched  like mfc_logical no-undo.
/*V8+*/

/*V8!
/* START OF CODE TO HANDLE ENTRY FROM QWIZARD
 * THE VARIABLE QWIZARD IS ONLY SET TO YES IF WE CAME FROM QWIZARD
 * AND RAN THE PROGRAM mqwizrd.p THE QWIZARD STARTUP PROGRAM*/

if qwizard then do:

   define variable dde-var as integer no-undo.
   define variable pgm-name as character no-undo.
   define variable DDEframe as widget-handle no-undo.
   define variable pgm-title as character no-undo.
   define variable passedSecurity as logical no-undo.
   define variable isProgram as logical no-undo.

   create frame DDEframe
   assign
      bgcolor = 8
      fgcolor = 8
      box     = no
   triggers:
   on dde-notify run get_dde.
   end triggers.

end. /* END IF qwizard THEN DO */

/* THIS IS THE PROCEDURE THAT ACTUALLY GETS THE NEW PROGRAM TO RUN  */
/* FROM QWIZARD                                                     */

PROCEDURE get_dde:
   dde get dde-var target pgm-name item "PROGRAM-ID" no-error.
END PROCEDURE.

run p-gui-setup.
*/       /* End of Qwizard Specific Logic */

run p-update-user-lang-dir in tools-hdl
   (input global_user_lang_dir).

/*V8-*/
/* SET EXTERNALIZED LABELS FOR VARIABLES USED AS LABELS. */
c-welcome = getTermLabelCentered("MFG/PRO_WELCOME",78).
c-allrightsreserved = getTermLabel("ALL_RIGHTS_RESERVED",27) + ".".

/* GET REPRODUCED MESSAGE FROM MESSAGE MASTER WHEN AVAILABLE. */
{pxmsg.i &MSGNUM=3775 &ERRORLEVEL=1 &MSGBUFFER=c-notreproduced}

/* CENTER LABEL */
run centerLabel in h-label
   (input 78,
   input-output c-notreproduced).
assign cprt = "Copyright " + string(year(today) , "9999" ) + " Softspeed CO,LTD.".
/*WELCOME AND PRODUCT LICENSE AUDIT FRAME*/
form
/*   skip(1)                                 */
/*   c-welcome no-label                      */
/*   temp_vers no-label skip                 */
/*   "QAD" at 38                             */
/*   "100 Innovation Place" at 30            */
/*   "Santa Barbara, CA  93108" at 28        */
/*   skip(1)                                 */
/*   "(805) 684-6614" at 32                  */
/*   "(805) 565-4202 FAX" at 32              */
/*   skip(1)                                 */
/*   "Copyright 1986-2008 QAD Inc. " at 15   */
/*   c-allrightsreserved no-label skip       */
/*   c-notreproduced no-label skip           */
/*   v_cur format ">>>9" colon 29            */
/*   v_max format ">>>9" colon 60 skip(1)    */
   skip
   c-welcome colon 1 format "x(36)" no-label
   "SoftSpeed Barcode System" colon 4 skip(1)
   cprt colon 2 no-label
   " (8620) 8552 1040" colon 16
   " 400 538 3200"  colon 20
   "http:~/~/www.softspeed.com.cn~/" colon 6
   c-allrightsreserved colon 16 format "x(20)" no-label skip
   c-notreproduced colon 1 format "x(36)" no-label skip

   c-userid      colon 12 label "User ID" format "x(8)"
   c-password    colon 12
   lv_domain     colon 12 dom_name format "x(16)" no-label
with frame welcome side-labels width 40 no-attr-space.

/* SET EXTERNALIZED LABELS FRAME WELCOME. */
/* v_cur:label         = getTermLabel("ACTIVE_SESSIONS",20).       */
/* v_max:label         = getTermLabel("SESSIONS_ALLOWED",26).      */
   lv_domain:label     = getTermLabel("DOMAIN",35).
   c-userid:label      = getTermLabel("User_ID",39).
   c-password:label    = getTermLabel("PASSWORD",39).

/*NEW PASSWORD FRAME*/
form
   skip(1)
   skip(1)
   passwd colon 10 no-label /* label "New Password" */
   skip(1)
   skip(1)
with frame b side-labels overlay width 40 centered attr-space row 2.

/* SET EXTERNALIZED LABELS FRAME B.
passwd:label in frame b = getTermLabel("NEW_PASSWORD",18).
*/
/*V8+*/

/*SEARCH FOR VERSION INFORMATION*/
/* Call gpgetver.p to get Version Information */
{gprun.i ""gpgetver.p""
   "(input '5', output temp_vers)"}

/*V8-*/
assign
   token1    = trim(temp_vers)
   temp_vers = "                                                                              ".

substring(temp_vers,maximum(1,40 -(integer(length(token1,"RAW")/ 2))),-1,"RAW")
   = token1.

repeat while substring(temp_vers,length(temp_vers,"RAW"), 1 , "RAW") = " ":
   temp_vers = substring(temp_vers, 1,length(temp_vers,"RAW") - 1,"RAW").
end.
/*V8+*/

/*INVOKE THE LICENSING SESSION RECORD LOCK/UNLOCK UTILITY*/
DELETE PROCEDURE lv-handle no-error.
{gprun.i ""lvlock.p"" "persistent set lv-handle"}

/*CREATE DEFAULT ROUND METHOD RECORDS*/
run createRoundMthdRecords in h_mfinitpl.

/* Get the License Type */
{gprunp.i "lvgenpl" "p" "getLicenseType"
   "(input 'MFG/PRO',
     input  no,
     output v_licType,
     output v_licDesc)"}

/*V8-*/
/* PRODUCT LICENSE AUDIT */
if v_licType <> {&CONCURRENT-SESSIONS} then
 /*  assign                                                                   */
 /*     v_cur:label in frame welcome    = getTermLabel("ACTIVE_USERS",20)     */
 /*     v_max:label in frame welcome    = getTermLabel("DEFINED_USERS",26).   */

display
  cprt
  trim(c-welcome) @ c-welcome
  trim(c-allrightsreserved) @ c-allrightsreserved
  /*  c-notreproduced       */
 /*  temp_vers             */
   c-userid
with frame welcome.
/*V8+*/

/*SET GLOBAL_SEC_OPT */
global_sec_opt = "B".

/*GET EXPIRATION DAYS, GLOBAL_TIMEOUT_MIN*/
for first usrc_ctrl
   fields(usrc_expire_days usrc_timeout_min usrc__qad02)
no-lock:
   assign
      expdays = usrc_expire_days
      global_timeout_min = usrc_timeout_min
      l_enforce_os_userid = if (usrc__qad02 = "yes") then true else false.
end.

/*V8-*/
AuthorizeBlock:
do on error undo, leave:

   l_authorized = false.

   if l_enforce_os_userid then do:
      c-userid = global_userid.
      display c-userid with frame welcome.
   end.

   /* GET USER TO LOG IN */
   LoginBlock:
   do while true on endkey undo, leave AuthorizeBlock:
      if password_required
      then
         update
            c-userid when (not l_enforce_os_userid)
            c-password blank
            with frame welcome.
      display
         " " @ c-password
      with frame welcome.

      do on error undo, leave:
         run loginUser(input c-userid, input c-password).
         if return-value = {&SUCCESS-RESULT} or
            return-value = {&WARNING-RESULT} then
            leave LoginBlock.
      end.     /* END DO ON ERROR */

      /* DEAL WITH ERROR RESULT */
      c-status = return-value.

      case c-status:
         when ({&INVALID-PASSWORD})   or
         when ({&DEACTIVATED-USERID}) or
         when ({&INVALID-USERID})     then
            i-msg-number = 5546.  /* INVALID USERID/PASSWORD */
         otherwise
            i-msg-number = 0.
      end case.

      if i-msg-number <> 0 then
      do:
         run registerReasonMessage(input i-msg-number,
                                   input "",
                                   input {&INFORMATION-RESULT}).
         if session:display-type = "TTY" then
            pause.
      end.

      case c-status:
         when ({&INVALID-USERID}) or
         when ({&INVALID-PASSWORD}) then
         do:
            next LoginBlock.
         end.
         otherwise
            quit.
      end case.
   end.   /* LOGINBLOCK */

   assign
      global_userid  = c-userid
      passwd         = c-password.

   /* CHECK USER AUTHORIZATION */
   {gprunp.i "lvgenpl" "p" "validateUserAuthorization"
              "(input global_userid, input ""MFG/PRO"")" }
   if return-value = {&USER-NOT-AUTHORIZED}
   then do:
      undo , retry.
   end. /* IF RETURN-VALUE = {&USER-NOT-AUTHORIZED} */

   l_authorized = true.
end.     /* AuthorizeBlock */

if not l_authorized then quit.

loopdomain:
do on endkey undo, leave:
   find udd_det where udd_userid = global_userid no-lock no-error.
   if ambiguous udd_det then do:
      find first udd_det
       where udd_userid = global_userid
         and udd_primary
      no-lock no-error.
      if available udd_det then lv_domain = udd_domain.
      update lv_domain with frame welcome.
      {gprunp.i "mgdompl" "p" "ppUserDomDbValidate"
                "(input lv_domain, input global_userid, output l_error)"}
      if l_error > 0 then undo loopdomain, retry.
   end.
   else if available udd_det then do:
      lv_domain = udd_domain.
      display lv_domain with frame welcome.
   end.
   else do:
      /*DOMAIN IS NOT ASSIGNED TO THE USER*/
      {pxmsg.i &MSGNUM=6170 &ERRORLEVEL=3 &PAUSEAFTER=true}
      quit.
   end.
   find dom_mstr where dom_domain = lv_domain no-lock no-error.
        display dom_name with frame welcome.
   {gprun.i ""gpmdas.p"" "(input lv_domain, output l_error)"}
end.

/* FOLLOWING LOGIC ALREADY EXISTS IN gpaud1.i.                            */
/* WRITTEN HERE AGAIN TO DETERMINE WHETHER AUDIT IS ENABLED               */
/* OR NOT AS AT THIS POINT IT IS KNOWN WHICH DOMAIN USER IS LOGGED INTO   */
/**/ assign l_passwd_chg = no.
if l_passwd_chg
then do:

   find first gl_ctrl
      where gl_ctrl.gl_domain = global_domain
   no-lock no-error.

   if gl__qad01 = 1
   then
      audit_on01 = yes.

   if audit_on01
   then
      assign
         s_name01  = string(mfguser) + ".01"
         s_name02  = string(mfguser) + ".02"
         s_nameb01 = search(s_name01)
         s_nameb02 = search(s_name02).

   /* AUDIT NEW DATA */
   for first usr_mstr
      where usr_userid = c-userid
   no-lock:

      {gpaud2.i
         &uniq_num1 = 01
         &uniq_num2 = 02
         &db_file = usr_mstr
         &db_field = usr_userid
         &db_field1 = """"}

   end. /* FOR FIRST usr_mstr.. */

   /* CLEAN UP */
   {gpaud3.i
      &uniq_num1 = 01
      &uniq_num2 = 02
      &db_file   = b_usr_mstr
      &db_field  = b_usr_mstr.usr_userid}

end. /* IF l_passwd_chg... */

if keyfunction(lastkey) = "END-ERROR" then quit.
/*V8+*/

/* Set the global right header display mode */
find first usrc_ctrl no-lock no-error.
if available usrc_ctrl then global_usrc_right_hdr_disp = usrc_right_hdr_disp.

/*CHECK FOR EURO TOOLKIT RUNNING*/
run checkEurotoolkitLock in h_mfinitpl.

/* SET GLOBAL_USER_NAME, GLOBAL_USER_GROUPS, */
/* GLOBAL_SITE_LIST, GLOBAL_PASSWD           */
run setGlobalUserFields in h_mfinitpl
   (input global_userid,
    input passwd).

/*V8!
assign
   previous_userid = global_userid.

if not qwizard then do:     /* NOT RUNNING QWIZARD */

   run p-fix-frame-size.   /* run ONCE only */

   fakeblock:
   do:

      run enable_UI.

      /* SPIN THE GLOBE ONE TIME */
      if first-time and spin_ok = "yes" then do:
         run spin-globe.
         assign first-time = false.
      end.

      do on error undo, leave on endkey undo, leave:

         on CTRL-C of passwd in frame signon-frame
         do:
            return NO-APPLY.
         end. /* DO */

         on CTRL-X of passwd in frame signon-frame
         do:
            return NO-APPLY.
         end. /* DO */

         on RIGHT-MOUSE-CLICK of passwd in frame signon-frame
         do:
            return NO-APPLY.
         end. /* DO */

         on RIGHT-MOUSE-DBLCLICK of passwd in frame signon-frame
         do:
            return NO-APPLY.
         end. /* DO */

         wait-for WINDOW-CLOSE of current-window
            or GO of frame signon-frame.

         if last-event:function = "WINDOW-CLOSE"
         then
            quit.

         leave fakeblock.
      end. /* DO on error */

      quit.

   end. /* fakeblock */

end. /* END IF NOT QWIZARD */
*/

/* CHECK TO SEE IF DISPLAY LANGUAGE SHOULD CHANGE */
current_user_lang = global_user_lang.

for first usr_mstr
   fields(usr_userid usr_lang usr_ctry_code usr_variant_code)
   where usr_userid = global_userid
no-lock:
   assign
      current_user_lang = usr_lang
      c-countryCode = usr_ctry_code
      c-variantCode = usr_variant_code.
end.

if (current_user_lang <> global_user_lang)
/*V8!    or (previous_userid <> global_userid)       */
then do:
   {mflang.i}
end.

/* Set user specific date and number formats based on user language and
country code*/
for first ctry_mstr where ctry_ctry_code = c-countryCode no-lock: end.
if available ctry_mstr then
   userISOCountry = ctry_mstr.ctry_code1.
assign
   userISOCountry = if userISOCountry = "" or userISOCountry = ? then
                    'US' else userISOCountry.

{gprunp.i "gplocale" "p" "setUserLocale"
   "(input global_user_lang,
     input userISOCountry,
     input c-variantCode)"}.

{gpdelp.i "gplocale" "p"}

/* CONNECT TO ALL AVAILABLE DATABASES */
{gprun.i ""mgdcinit.p""}

/*SET USERID FOR ALL CONNECTED DATABASES*/
run setDbUserids in h_mfinitpl
   (input global_userid,
    input passwd).

/*SET GLOBAL HIGH-LOW VALUES*/
run setGlobalHighLowValues in h_mfinitpl.

/*SAVE VALUE OF "TERMINAL"*/
if can-find (_field where _field-name = "_frozen") then do:
   {gprun.i ""gpsavtrm.p""}
end.

/*V8-*/
view frame welcome.
/*V8+*/

/* Create intrastat control file record */
run createIntrastatControlFile in h_mfinitpl.
/*WARN IF GL_RND_MTHD BLANK*/
for first gl_ctrl
   fields(gl_domain gl_rnd_mthd)
where gl_ctrl.gl_domain = global_domain
and gl_rnd_mthd = ''
no-lock:
   /*BASE ROUND METHOD IS BLANK - SETUP IN 36.1*/
   {pxmsg.i &MSGNUM=2247 &ERRORLEVEL=2}
   pause.
end.

/* SET BASE CURRENCY AND ENTITY */
run setBaseCurrencyEntity in h_mfinitpl.

/*V8-*/
/*SET UP STATUS LINES*/
/* Retrieve the CHUI status lines from msg_mstr */
{pxmsg.i &MSGNUM=8800 &ERRORLEVEL=1 &MSGBUFFER=stline[1]}
{pxmsg.i &MSGNUM=8802 &ERRORLEVEL=1 &MSGBUFFER=stline[2]}
{pxmsg.i &MSGNUM=8814 &ERRORLEVEL=1 &MSGBUFFER=stline[3]}
{pxmsg.i &MSGNUM=8807 &ERRORLEVEL=1 &MSGBUFFER=stline[4]}
{pxmsg.i &MSGNUM=3633 &ERRORLEVEL=1 &MSGBUFFER=stline[5]}
{pxmsg.i &MSGNUM=8815 &ERRORLEVEL=1 &MSGBUFFER=stline[6]}
{pxmsg.i &MSGNUM=8816 &ERRORLEVEL=1 &MSGBUFFER=stline[7]}
{pxmsg.i &MSGNUM=8817 &ERRORLEVEL=1 &MSGBUFFER=stline[8]}
{pxmsg.i &MSGNUM=8818 &ERRORLEVEL=1 &MSGBUFFER=stline[9]}
{pxmsg.i &MSGNUM=8819 &ERRORLEVEL=1 &MSGBUFFER=stline[10]}
{pxmsg.i &MSGNUM=3632 &ERRORLEVEL=1 &MSGBUFFER=stline[11]}
{pxmsg.i &MSGNUM=8820 &ERRORLEVEL=1 &MSGBUFFER=stline[12]}
{pxmsg.i &MSGNUM=8821 &ERRORLEVEL=1 &MSGBUFFER=stline[13]}
/*V8+*/

/*V8!
/* Retrieve the Windows status lines from msg_mstr */
{pxmsg.i &MSGNUM=8822 &ERRORLEVEL=1 &MSGBUFFER=stline[1]}
{pxmsg.i &MSGNUM=8823 &ERRORLEVEL=1 &MSGBUFFER=stline[2]}
{pxmsg.i &MSGNUM=8824 &ERRORLEVEL=1 &MSGBUFFER=stline[3]}
{pxmsg.i &MSGNUM=8825 &ERRORLEVEL=1 &MSGBUFFER=stline[4]}
{pxmsg.i &MSGNUM=8826 &ERRORLEVEL=1 &MSGBUFFER=stline[5]}
{pxmsg.i &MSGNUM=8827 &ERRORLEVEL=1 &MSGBUFFER=stline[6]}
{pxmsg.i &MSGNUM=8828 &ERRORLEVEL=1 &MSGBUFFER=stline[7]}
{pxmsg.i &MSGNUM=8829 &ERRORLEVEL=1 &MSGBUFFER=stline[8]}
{pxmsg.i &MSGNUM=8830 &ERRORLEVEL=1 &MSGBUFFER=stline[9]}
{pxmsg.i &MSGNUM=8831 &ERRORLEVEL=1 &MSGBUFFER=stline[10]}
{pxmsg.i &MSGNUM=8832 &ERRORLEVEL=1 &MSGBUFFER=stline[11]}
{pxmsg.i &MSGNUM=8833 &ERRORLEVEL=1 &MSGBUFFER=stline[12]}
{pxmsg.i &MSGNUM=8834 &ERRORLEVEL=1 &MSGBUFFER=stline[13]}

*/ /*End of Windows Status Messages */

/* SET UP HELPKEY DEFINITIONS */

/* MFG/PRO STANDARD DEFINITIONS:                                   */
/* F1 - Go             F5 - Delete          F9  - Previous         */
/* F2 - Help           F6 - User Menu       F10 - Next             */
/* F3 - Insert         F7 - Recall          F11 - Cut&Paste Buffer */
/* F4 - End-Error      F8 - Clear           F12 - Cut&Paste        */
/* Scrolling Windows:  F7/8 - Page-Up/Down  F9/10 - Line-Up/Down   */

/*V8-*/
/* Function/Control Key Defines for Character Mode */
/* DISPLAYS FIELD NAME */
on CTRL-F help.
on ESC-TAB help.

/* INSERT-REPLACE MODE */
on F3 insert-mode.          /* Override Progress version 7 default */
on PF3 insert-mode.

/* USER MENU */
on CTRL-P help.
on F6 help.

/* STORE/GET FIELD VALUE */
on CTRL-B help.
on F11 help.

on CTRL-A help.
on F12 help.
/*V8+*/

/*V8!
/* Function/Control Key Defines for Windows */
/* DISPLAYS FIELD NAME */
on CTRL-F help.

/* USER MENU */
on CTRL-P help.
on F6 help.

/* STORE/GET FIELD VALUE */
on CTRL-B help.
on F11 help.

on CTRL-A help.
on F12 help.
*/

/* FIND THE HIGHEST FUNCTION KEY USED TO SET HELP KEYS */
define variable max_fkey as integer initial 12 no-undo.

do for ufd_det transaction:

   for last ufd_det
   fields(ufd_fkey ufd_userid)
   where ufd_userid = global_userid no-lock:
      if ufd_fkey > max_fkey then
         assign max_fkey = ufd_fkey.
   end.

   for last ufd_det
   fields(ufd_fkey ufd_userid)
   where ufd_userid = "" no-lock:
      if ufd_fkey > max_fkey then
         assign max_fkey = ufd_fkey.
   end.

end.

if max_fkey >= 13 then on f13 help.
if max_fkey >= 14 then on f14 help.
if max_fkey >= 15 then on f15 help.
if max_fkey >= 16 then on f16 help.
if max_fkey >= 17 then on f17 help.
if max_fkey >= 18 then on f18 help.
if max_fkey >= 19 then on f19 help.
if max_fkey >= 20 then on f20 help.
if max_fkey >= 21 then on f21 help.
if max_fkey >= 22 then on f22 help.
if max_fkey >= 23 then on f23 help.
if max_fkey >= 24 then on f24 help.
if max_fkey >= 25 then on f25 help.
if max_fkey >= 26 then on f26 help.
if max_fkey >= 27 then on f27 help.
if max_fkey >= 28 then on f28 help.
if max_fkey >= 29 then on f29 help.
if max_fkey >= 30 then on f30 help.
if max_fkey >= 31 then on f31 help.
if max_fkey >= 32 then on f32 help.
if max_fkey >= 33 then on f33 help.
if max_fkey >= 34 then on f34 help.
if max_fkey >= 35 then on f35 help.
if max_fkey >= 36 then on f36 help.
if max_fkey >= 37 then on f37 help.
if max_fkey >= 38 then on f38 help.
if max_fkey >= 39 then on f39 help.

/* Get a unique mfguser for this progress session, this database */
do on error undo, leave:
   run setMfguserSessionId in h_mfinitpl.
end.
if error-status:error then quit.

/* We should still have a share lock on qad_wkfl but no transaction */
{gprun.i ""gpistran.p"" "(input 1, input ' ')"}

/* Set global-menu-substitution, global-do-menu-substitution */
run setGlobalMenuSubstitution in h_mfinitpl
   (input global_userid).

/* Set global variable if global requisition system installed */
run setUsingGRS in h_mfinitpl.

/*V8-*/

unsubscribe to "previousSuccessfulLogin" in h_mfinitpl.

/* Delete the initialization procedure library*/
if valid-handle(h_mfinitpl)
   and h_mfinitpl:type = "PROCEDURE"
   and h_mfinitpl:file-name = "mfinitpl.p" then
   delete PROCEDURE h_mfinitpl.

/*MENU PROCESSING FOR CHARACTER*/
pause 0.

/* CHECK LICENSING */
{gprun.i ""lvdet.p""
   "(input  'mf1a.p',
     output v_secure,
     output v_sid,
     output v_cur,
     output v_max)" }
/*
display
   v_cur
   v_max
with frame welcome.
*/
/* TRAP ERROR & ENDKEY TO CONTINUE WITH LOGIN */
do on error undo, leave on endkey undo, leave:
   /* DISPLAY A MESSAGE SHOWING LAST SUCCESSFUL LOGON DATE */
   /* AND TIME. LAST SUCCESSFULL LOGIN: # # #              */
   {pxmsg.i &MSGNUM=6085
            &MSGARG1=c-last-log-date
            &MSGARG2=c-last-log-time
            &MSGARG3=c-last-log-zone
            &PAUSEAFTER=5}
end.

if not v_secure then quit.

/* Share-lock the cnt_mstr records */
run lv_cnt_lock in lv-handle
   (input v_sid,
    input "MFG/PRO").

/* Exclusive-lock the mon_mstr records */
run lv_mon_lock in lv-handle
   (input  mfguser,
    input  "MFG/PRO",
    output l_locked).

/* API STARTUP PROCESSING */
{gprun.i ""gpapist.p""}

/* CALCULATE AND SET HIGH WATER MARK LEVEL FOR ALL REGISTERED PRODUCTS */
/* FOR EACH LOGIN OF PRODUCT  FOR THE DAY*/
hwm:
do on error undo , leave :

   {gprunp.i "lvgenpl" "p" "setHighWaterMark"
      "(input ""MFG/PRO"" )"  }

   if return-value = {&RECORD-NOT-FOUND}
   then do:
      /* APPLICATION # NOT REGISTERED */
      {pxmsg.i &MSGNUM=2476 &ERRORLEVEL=2 &MSGARG1=""MFG/PRO"" }

   end. /* IF return-value = {&RECORD-NOT-FOUND} */

end. /* DO ON ERROR */

/* RECORD LICENSE USAGE RECORDS (lua_det) FOR EACH  */
/* SESSION WITHIN AUDIT PERIOD */
{gprunp.i "lvgenpl" "p" "createLicenseUsageRecord"
   "(input global_userid,
     input mfguser,
     input ""MFG/PRO"",
     input yes )"}
/* RUN THE MENU DRIVER */
hide frame welcome.
{gprun1.i ""bcmenu.p"" "(output rstatus)"}

/* DELETE LICENSING SESSION/MONITOR RECORDS */
run lv_delete in lv-handle.

/* UPDATE LICENSE USAGE RECORDS (lua_det) FOR LOGOUT DATE AND TIME */
{gprunp.i "lvgenpl" "p" "createLicenseUsageRecord"
   "(input global_userid,
     input mfguser,
     input ""MFG/PRO"",
     input no )"}

/* API SHUTDOWN PROCESSING */
{gprun.i ""gpapish.p""}
/*V8+*/

/*V8!
/*MENU PROCESSING FOR GUI*/

if not qwizard then do:       /* NOT RUNNING QWIZARD */

   /* API Startup Processing */
   {gprun.i ""gpapist.p""}

   guiloop:
   do while true:

      {gprun.i ""lvdet.p""
         "(input 'mf1a.p',
           output v_secure,
           output v_sid,
           output v_cur,
           output v_max)" }

      if v_licType <> {&CONCURRENT-SESSIONS} then
         assign
            your-unum:label in frame signon-frame =
               getTermLabel("ACTIVE_USERS",20)
            tot-unum:label in frame signon-frame =
               getTermLabel("DEFINED_USERS",26).

      display
         string(v_cur) @ your-unum
         string(v_max) @ tot-unum
      with frame signon-frame.

      /* DISPLAY A MESSAGE SHOWING LAST SUCCESSFUL LOGON DATE AND TIME. */
      /* THIS MESSAGE IS PLACED IN THIS LOOP SO THAT IT DISPLAYS ON     */
      /* RE-LOGINS AS WELL AS THE FIRST TIME.                           */
      /* LAST SUCCESSFULL LOGIN: # # # */
      /* TRAP ERROR & ENDKEY TO CONTINUE WITH LOGIN */
      do on error undo, leave on endkey undo, leave:
          {pxmsg.i &MSGNUM=6085
                   &MSGARG1=c-last-log-date
                   &MSGARG2=c-last-log-time
                   &MSGARG3=c-last-log-zone}
      end.

      if not v_secure then quit.

      /* Share-lock the cnt_mstr records */
      run lv_cnt_lock in lv-handle
         (input v_sid,
          input "MFG/PRO").

      /* Share-lock the mon_mstr records */
      run lv_mon_lock in lv-handle
         (input mfguser,
          input "MFG/PRO",
          output l_locked).

      display
         "" @ your-unum
         "" @ tot-unum
      with frame signon-frame.

      pause 0.

      run disable_ui.

      {gprun.i ""gpcursor.p"" "(input 'wait')"}

      /* CALCULATE AND SET HIGH WATER MARK LEVEL FOR ALL REGISTERED PRODUCTS */
      /* FOR EACH LOGIN OF PRODUCT  FOR THE DAY*/
      hwm:
      do on error undo , leave :

         {gprunp.i "lvgenpl" "p" "setHighWaterMark"
            "(input ""MFG/PRO"" )"  }

         if return-value = {&RECORD-NOT-FOUND}
         then do:
            /* APPLICATION # NOT REGISTERED */
            {pxmsg.i &MSGNUM=2476 &ERRORLEVEL=2 &MSGARG1=""MFG/PRO"" }
         end. /* IF return-value = {&RECORD-NOT-FOUND} */

      end. /* DO ON ERROR */

      /* RECORD LICENSE USAGE RECORDS (lua_det) FOR EACH  */
      /* SESSION WITHIN AUDIT PERIOD */
      {gprunp.i "lvgenpl" "p" "createLicenseUsageRecord"
         "(input global_userid,
           input mfguser,
           input ""MFG/PRO"",
           input yes )"}

      run p-menu-driver
         (input local-menu-type).

      run lv_delete in lv-handle.

      /* UPDATE LICENSE USAGE RECORDS (lua_det) FOR LOGOUT DATE AND TIME */
      {gprunp.i "lvgenpl" "p" "createLicenseUsageRecord"
         "(input global_userid,
           input mfguser,
           input ""MFG/PRO"",
           input no )"}

      if global-exiting then leave guiloop.

      /* TRAP ERROR & ENDKEY TO AVOID HITTING PROGRESS EDITOR */
      /* ON THE WAY OUT */
      else do on error undo, leave guiloop
      on endkey undo, leave guiloop:
         run enable_UI.
         wait-for WINDOW-CLOSE of current-window
               or GO of frame signon-frame.
         if last-event:function = "WINDOW-CLOSE" then quit.
         /* GUI DOES NOT RETURN TO MF1.P WHEN RETURNING      */
         /* TO SIGN ON FRAME SO PERSISTENT PROGRAMS REMAIN.  */
         /* TO SEE NEWLY ADDED LABELS WITHOUT EXITING MFGPRO */
         /* WE MUST DELETE GPLABEL'S TEMP TABLE.             */
         dynamic-function('deleteLabelTempTable' in h-label).
      end.

      for first usr_mstr
         fields(usr_userid usr_lang usr_ctry_code usr_variant_code)
         where usr_userid = global_userid
      no-lock:
         assign
            current_user_lang = usr_lang
            c-countryCode     = usr_ctry_code
            c-variantCode     = usr_variant_code.
      end. /* FOR FIRST usr_mstr */

      for first ctry_mstr
         fields(ctry_code1 ctry_ctry_code)
         where ctry_ctry_code = c-countryCode
      no-lock:
      end. /* FOR FIRST ctry_mstr */

      if available ctry_mstr
      then
         userISOCountry = ctry_mstr.ctry_code1.

      assign
         userISOCountry = if userISOCountry    = ""
                             or userISOCountry = ?
                          then
                             'US'
                          else
                             userISOCountry.

      {gprunp.i "gplocale" "p" "setUserLocale"
         "(input current_user_lang,
           input userISOCountry,
           input c-variantCode)"}.

      {gpdelp.i "gplocale" "p"}

   end. /* GUILOOP */

   unsubscribe to "previousSuccessfulLogin" in h_mfinitpl.

   /* Delete the initialization procedure library*/
   if valid-handle(h_mfinitpl)
      and h_mfinitpl:type = "PROCEDURE"
      and h_mfinitpl:file-name = "mfinitpl.p" then
      delete PROCEDURE h_mfinitpl.

   /* API SHUTDOWN PROCESSING */
   {gprun.i ""gpapish.p""}

end. /* NOT QWIZARD */

/* QWizard Specific Logic */
if qwizard then do:

   os-delete "c:\~~qwizard.qad".
   session:multitasking-interval = 40.
   ddeframe:visible = true.

   dde initiate dde-var frame DDEframe application "Authorware"
   topic "MENU" no-error.

   do while true:       /* WAIT FOR "QUIT" */

      assign
         current-window:title       = getTermLabel("MFG/PRO_WITH_QWIZARD",40)
         current-window:visible     = true
         current-window:fgcolor     = 8
         current-window:bgcolor     = 8
         current-window:width       = 27
         current-window:height      = 1
         current-window:resize      = no
         current-window:movable     = no
         current-window:selectable  = no
         current-window:scroll-bars = no.

      dde advise dde-var start item "PROGRAM-ID" no-error.

      do while pgm-name = "":

         process events.

         if DDEframe:dde-error <> 0 or search("c:\~~qwizard.qad") <> ?
         then do:
            dde advise dde-var stop item "PROGRAM-ID" no-error.
            dde terminate dde-var no-error.
            os-delete "c:\~~qwizard.qad".
            dde initiate dde-var frame DDEframe
            application "Authorware" topic "MENU" no-error.
            dde advise dde-var start item "PROGRAM-ID" no-error.
         end.

      end.

      if pgm-name = "quit" then do:
         dde advise dde-var stop item "PROGRAM-ID" no-error.
         dde terminate dde-var no-error.
         pause 2 no-message.
         os-delete "c:\~~qwizard.qad".
         quit.
      end.

      {gprun.i ""gpusrpgm.p""
         "(input-output pgm-name, output pgm-title,
           output passedSecurity, output isProgram)"}

      if passedSecurity then do:
         if isProgram then do:
            {gprun.i 'gpwinrun.p' "(input pgm-name, input pgm-title)"}
         end.
         else do:
            /* UNABLE TO NAV TO MENU SPECIFICATION */
            {pxmsg.i &MSGNUM=7704 &ERRORLEVEL=3}
         end.
      end.

      dde advise dde-var stop item "PROGRAM-ID" no-error.

      assign
         pgm-name = ""
         global-beam-me-up = false.

   end. /* do while true */

   if pgm-name = "quit" then
      dde terminate dde-var no-error.
   quit.

end. /* if qwizard then do */

run p-save-userid.
*/

{&MF1A-P-TAG2}

/* EXIT THE SYSTEM IF RETURN STATUS IS NOT "P" (PROGRESS EDITOR */
if rstatus <> "P" then quit.

PROCEDURE getNewPassword:
/*------------------------------------------------------------------
Purpose:    get new password from user
Exceptions:
Notes:
History:
    Last change:  QAD  10 Sep 2003   11:44 am
------------------------------------------------------------------*/
   define input parameter           p-userid       as character no-undo.
   define input parameter           p-passwd       as character no-undo.
   define input parameter           p-status-code  as character no-undo.

   /* DEFINE HANDLES FOR THE PROGRAMS. */
   {pxphdef.i lib}
   {pxphdef.i setpassword}
   /* END DEFINE HANDLES FOR THE PROGRAMS. */

   define variable i-msg-number      as integer no-undo.
   define buffer usr_mstr            for usr_mstr.

   case p-status-code:
      when ({&EXPIRED-PASSWORD}) then
         /* PASSWORD HAS EXPIRED */
         i-msg-number = 5564.
      when ({&FORCE-PASSWD-CHANGE}) then
         /* CHANGE YOUR PASSWORD IMMEDIATELY */
         i-msg-number = 6082.
      otherwise
         i-msg-number = 0.
   end case.

   if i-msg-number <> 0 then
   do:
      run registerReasonMessage(input i-msg-number,
                                input "",
                                input {&INFORMATION-RESULT}).
      if session:display-type = "TTY" then
         pause.
   end.

   /* NEED TO ASSIGN global_userid HERE BASED ON WHAT USER HAS ENTERED.  */
   /* AUDIT TRAIL IS ENABLED OR DISABLED IS DECIDED BASED ON DOMAIN.     */
   /* AT THIS POINT, DOMAIN TO WHICH USER IS GOING TO LOG IN IS UNCLEAR. */
   /* HENCE, FORCEFULLY ASSIGN audit_on01 = yes                          */
   assign
      global_userid = p-userid
      audit_on01    = yes.

   if audit_on01
   then
      assign
         s_name01  = string(mfguser) + ".01"
         s_name02  = string(mfguser) + ".02"
         s_nameb01 = search(s_name01)
         s_nameb02 = search(s_name02).

   /* AUDIT OLD DATA */
   for first usr_mstr
      where usr_userid = p-userid
   no-lock:

      l_passwd_chg = true.
      {gpaud1.i &uniq_num1 = 01
                &uniq_num2 = 02
                &db_file   = usr_mstr
                &db_field  = usr_userid}
   end. /* FOR FIRST usr_mstr */

   do on error undo, return error return-value:
      /* BE PREPARED TO FIELD AN APP-ERROR-RETURN */
      {pxrun.i &PROC='promptNewPassword'
               &PROGRAM='mgurlib.p'
               &HANDLE=ph_setpassword
               &PARAM="(input p-userid,
                        input encode(p-passwd))"
               &NOAPPERROR=True
               &CATCHERROR=True}
      c-status = return-value.
      delete procedure ph_setpassword no-error.
   end.
   if c-status = {&SUCCESS-RESULT} then
      return {&SUCCESS-RESULT}.
   else
      return error {&APP-ERROR-RESULT}.

end PROCEDURE.

PROCEDURE loginUser:
/*------------------------------------------------------------------
Purpose:    Authenticate user and get new password when necessary.
Exceptions: Errors returned when raised in call to checkLogon:
            &INVALID-USERID
            &INVALID-PASSWORD
            &DEACTIVATED-USERID
Notes:
History:
------------------------------------------------------------------*/
   define input parameter p-userid     as character no-undo.
   define input parameter p-password   as character no-undo.

   define variable c-status as character no-undo.

   c-logon = {&CHECKLOGON-LOGON}.     /* CALLED FROM LOGON PROGRAM */

   do on error undo, return error return-value:

      {pxrun.i &PROC='checkLogon'
               &PROGRAM='mfinitpl.p'
               &HANDLE=h_mfinitpl
               &PARAM="(input p-userid, input p-password, input c-logon)"
               &CATCHERROR=True}

      c-status = return-value.
      case c-status:
         when ({&EXPIRED-PASSWORD}) or
         when ({&FORCE-PASSWD-CHANGE}) then
         do on error undo, return error return-value:
            run getNewPassword(input p-userid, input p-password,
                               input c-status).
            c-status = return-value.
         end.
         when ({&WARNING-RESULT}) then
         do:
            c-ret-message = offerNewPassword(input p-userid).
            if c-ret-message <> "" then
            do on error undo, leave:
               /* Do you wish to change password? */
               {pxmsg.i &MSGNUM=6088
                        &MSGARG1=c-ret-message
                        &CONFIRM=l-ret-value}

               if l-ret-value then
                  run getNewPassword(input p-userid, input p-password,
                                     input "").
               /* WE DON'T CARE ABOUT ERROR RETURNS FROM HERE */
            end.
            c-status = {&SUCCESS-RESULT}.
         end.
      end case.

      return c-status.
   end.    /* END DO ON ERROR */
end PROCEDURE.  /* loginUser */

PROCEDURE previousSuccessfulLogin:
   define input parameter p-logon-date as character no-undo.
   define input parameter p-logon-time as integer   no-undo.
   define input parameter p-logon-zone as character no-undo.

   assign
      c-last-log-date = p-logon-date
      c-last-log-time = string(p-logon-time, "HH:MM:SS")
      c-last-log-zone = p-logon-zone
   .
end PROCEDURE.

FUNCTION offerNewPassword returns character
   (input p-userid as character):
/*------------------------------------------------------------------
Purpose:    puts up dialog box for asking a question
Exceptions:
Notes:
History:
------------------------------------------------------------------*/
   define variable l-ret-value like mfc_logical no-undo.
   define variable i-days-left as integer       no-undo.
   define buffer   usr_mstr  for usr_mstr.

   define variable c-question  as character no-undo .
   define variable c-expire    as character no-undo .
   define variable c-text      as character no-undo .

   /* GET NUMBER OF DAYS LEFT BEFORE PASSWORD EXPIRES */
   for first usr_mstr
      where usr_mstr.usr_userid = p-userid no-lock:
      i-days-left = dynamic-function('passwordDaysLeft' in h_mfinitpl,
                                   buffer usr_mstr).
   end.

   /* FIX IF DAYS ARE A NEGATIVE VALUE */
   if i-days-left < 0 then
      i-days-left = i-days-left * -1.

   /* PASSWORD WILL EXPIRE IN DAYS: # */
   {pxmsg.i &MSGNUM=6083
            &MSGBUFFER=c-expire
            &MSGARG1=i-days-left}
   return c-expire.
end FUNCTION.

PROCEDURE registerReasonMessage:
/*------------------------------------------------------------------
  Purpose: Message handler for mfinitpl.p and other procedures
  Parameters:
  Notes:
  ------------------------------------------------------------------*/

   define input parameter pMessageNumber as integer no-undo.
   define input parameter pMessageDescription as character no-undo.
   define input parameter pMessageSeverity as integer no-undo.

   define variable severity as integer no-undo.

   severity = pMessageSeverity.
   if severity = 3 then
      severity = 4. /*DON'T WANT "PLEASE RE-ENTER"*/

   if pMessageDescription > '' then do:
      {pxmsg.i &MSGTEXT=pMessageDescription &ERRORLEVEL=pMessageSeverity}
   end.
   else do:
      {pxmsg.i &MSGNUM=pMessageNumber &ERRORLEVEL=pMessageSeverity}
   end.

END PROCEDURE.
