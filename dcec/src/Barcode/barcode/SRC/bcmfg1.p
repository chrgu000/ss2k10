{mfdeclre.i}
    
define variable current_user_lang like global_user_lang no-undo.
define shared variable h_mfinitpl as handle no-undo.
DEFINE  SHARED VARIABLE usr AS CHARACTER .
DEFINE SHARED VARIABLE pwd AS CHARACTER.
     
define variable previous_userid as character.
define variable userISOCountry  as character no-undo.
define variable c-countryCode   as character no-undo.
define variable c-variantCode   as character no-undo.
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
         or (previous_userid <> global_userid)         
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
    input pwd).

/*SET GLOBAL HIGH-LOW VALUES*/
run setGlobalHighLowValues in h_mfinitpl.

/*SAVE VALUE OF "TERMINAL"*/
if can-find (_field where _field-name = "_frozen") then do:
   {gprun.i ""gpsavtrm.p""}
end.
 
/*V8+*/

/*WARN IF GL_RND_MTHD BLANK*/
for first gl_ctrl
   fields(gl_rnd_mthd)
   where gl_rnd_mthd = ''
no-lock:
   /*BASE ROUND METHOD IS BLANK - SETUP IN 36.1*/
   {pxmsg.i &MSGNUM=2247 &ERRORLEVEL=2}
   pause.
end.

/* SET BASE CURRENCY AND ENTITY */
run setBaseCurrencyEntity in h_mfinitpl.
/*V8+*/
run setMfguserSessionId in h_mfinitpl. 

RUN bc_mf_main.p.
  
