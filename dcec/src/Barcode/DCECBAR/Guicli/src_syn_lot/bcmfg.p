
{mfdeclre.i}

{cxcustom.i "MF1A.P"}

{&MF1A-P-TAG1}
{mf1.i}
{pxsevcon.i}


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

define variable i as integer no-undo.
define variable token1 as character no-undo.
define variable current_user_lang like global_user_lang no-undo.

define variable passwd as character label "Password" format "x(16)"
   case-sensitive no-undo.
define variable num_tries as integer no-undo.

define variable temp_vers as character no-undo format "x(78)".
define variable o_passwd like passwd no-undo.

define shared variable h_mfinitpl as handle no-undo.
define shared variable password_required as logical initial yes no-undo.

define  variable expdays like usrc_expire_days no-undo.
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
define variable c-mfgmgmt           as character format "x(78)" no-undo.
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
define variable l_enforce_os_userid as logical initial no no-undo.

/* SET MESSAGE HANDLER TO RUN PROCEDURE REGISTERREASONMESSAGE */
run setMessageHandlerHandle in h_mfinitpl(input this-procedure).

{gprunpdf.i "gpurxr" "p"}
{gprunpdf.i "lvgenpl" "p"}

     
define variable previous_userid as character.
{mfqwizrd.i}
{mf8def.i}
{mf8trig.i}
{mf8proc.i}
    run p-gui-setup.
         /* End of Qwizard Specific Logic */
/*{gprun.i ""gpwinrun.p"" "('fcfsmt01.p', 'CIM')"}.*/
run p-update-user-lang-dir in tools-hdl
   (input global_user_lang_dir).
/*RUN bdmgbdpro.p(INPUT 'c:\prsh.cim',INPUT 'c:\out.txt').*/
/*V8+*/

/*SEARCH FOR VERSION INFORMATION*/
/* Call gpgetver.p to get Version Information */
/*{gprun.i ""gpgetver.p""
   "(input '1', output temp_vers)"}*/

/*V8+*/

/*INVOKE THE LICENSING SESSION RECORD LOCK/UNLOCK UTILITY*/
DELETE PROCEDURE lv-handle no-error.
/*{gprun.i ""lvlock.p"" "persistent set lv-handle"}*/

/*CREATE DEFAULT ROUND METHOD RECORDS*/
run createRoundMthdRecords in h_mfinitpl.

/* Get the License Type */
/*{gprunp.i "lvgenpl" "p" "getLicenseType"
   "(input 'MFG/PRO',
     input  no,
     output v_licType,
     output v_licDesc)"}*/

/*V8+*/

/* Create intrastat control file record */
run createIntrastatControlFile in h_mfinitpl.

/*SET GLOBAL_SEC_OPT */
global_sec_opt = "B".

/*GET EXPIRATION DAYS, GLOBAL_TIMEOUT_MIN*/
for first usrc_ctrl
   fields(usrc_expire_days usrc_timeout_min usrc__qad02)
no-lock:
   expdays = usrc_expire_days.
   global_timeout_min = usrc_timeout_min.
   if usrc__qad02 = "yes" then
      l_enforce_os_userid = yes.
   else
      l_enforce_os_userid = no.
end.
/*V8+*/

/* SET GLOBAL_USER_NAME, GLOBAL_USER_GROUPS, */
/* GLOBAL_SITE_LIST, GLOBAL_PASSWD           */
run setGlobalUserFields in h_mfinitpl
   (input global_userid,
    input passwd).

     
assign
   previous_userid = global_userid.


RUN bcmflogin.p.


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



/*{bcwin.i} */

/*WAIT-FOR CLOSE OF THIS-PROCEDURE.*/

   
   

