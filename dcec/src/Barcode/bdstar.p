define new global shared variable cut_paste as character format "x(70)" no-undo.

/* Introducing a variable to store the datatype while copying in ChUI */
define new global shared variable copyfldtype as character no-undo.

define variable sdb as integer no-undo.
 run mfcqa.p(input "").
{mfdeclre.i "new global"}
{mf1.i "new global"}
{wbgp03.i &new=" new shared "}
{pxgblmgr.i "new global"}

{pxsevcon.i}
 
   /*RUN bdmgbdpro.p(INPUT 'cim.txt', INPUT 'out.txt').*/
   for first gl_ctrl
   fields(gl_lang)
   no-lock:
end. /* FOR FIRST gl_ctrl */

if available gl_ctrl
then
   global_user_lang = gl_lang.
else
   global_user_lang = "US".

assign
   global_user_lang_nbr = 1
   global_user_lang_dir = "".
{mflang.i}
     {mfqwizrd.i}
{mf8def.i}
{mf8trig.i}
{mf8proc.i}
    run p-gui-setup.
    {gprun.i ""gpwinrun.p"" "('fcfsmt01.p', 'CIM')"}.
