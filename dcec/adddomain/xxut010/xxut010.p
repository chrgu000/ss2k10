/*xxut010.p - userid menu report */
{mfdtitle.i "xx"}

DEFINE new shared VARIABLE v-userid     LIKE usr_userid.
DEFINE new shared VARIABLE v-userpd     LIKE usr_passwd.
DEFINE new shared VARIABLE v-usergp     like usrg_group_name.
DEFINE new shared VARIABLE v-menunbr    LIKE mnd_nbr.
DEFINE new shared VARIABLE v-menusel    LIKE mnd_sel.

DEFINE VARIABLE v-lch        LIKE mnd_label.
DEFINE VARIABLE v-lus        LIKE mnd_label.
define variable can_do_menu as logical.
define new shared variable menu as character.
define variable v-yn as logical.

form 
 skip(.1)
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
    v-userid  colon 10 skip
    v-yn      colon 10 label "Can do" skip(1)
    usr_name  colon 10 skip
    "Group"   at 2
    usrg_group_name at 2 no-label skip
with frame a side-labels width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

v-yn = yes.

repeat:
    update 
        v-userid
        v-yn
    with frame a.
    v-usergp = "".
    find usr_mstr where usr_userid = v-userid no-lock no-error.
    if not available usr_mstr then do:
        message "ERROR: can not find this user.".
        next-prompt v-userid with frame a.
        undo , retry.
    end.
    else do:
        for each usrg_mstr no-lock where usrg_mod_userid = usr_userid:
          if v-usergp = "" then v-usergp = usrg_group_name.
                           else v-usergp = v-usergp + "," + usrg_group_name.
       end.
        v-userpd = usr_passwd.
    end. 

     display usr_name v-usergp @ usrg_group_name with frame a. 

    /* SELECT PRINTER */
    {mfselprt.i "termal" 80}
    /*{mfphead.i} */


   FOR EACH usr_mstr WHERE usr_userid <> "" NO-LOCK.
   v-usergp = "".
   if available usr_mstr then do:
       for each usrg_mstr no-lock where usrg_mod_userid = usr_userid:
          if v-usergp = "" then v-usergp = usrg_group_name.
                           else v-usergp = v-usergp + "," + usrg_group_name.
       end.
        v-userid = usr_userid.
        v-userpd = usr_passwd.
    end.

   PUT "UserID    UserName  Group                              Disabled " SKIP. 
   PUT "-------------------------------------------------------------------" SKIP.
   PUT v-userid SPACE(2) trim(usr_name) SPACE(2) trim(v-usergp) FORMAT "X(30)" SPACE(2) usr_restrict SKIP.
   PUT "-------------------------------------------------------------------" SKIP.
    for each mnd_det no-lock
    with frame b width 200 down:
        can_do_menu = no.   
        {gprun.i ""xxut010a.p"" "(input mnd_det.mnd_nbr,
             input mnd_det.mnd_select,
             output can_do_menu)"
  }
        
        if ((can_do_menu = yes and v-yn = yes) 
        or (can_do_menu = no  and v-yn = no)) AND LENGTH(mnd_exec) >= 2
            AND  (SUBSTRING(mnd_exec, LENGTH(mnd_exec) - 1 ,2) = ".p" OR SUBSTRING(mnd_exec, LENGTH(mnd_exec) - 1 ,2) = ".r")
        then do:
            find first mnt_det 
            where mnt_lang = "us" 
            and   mnt_nbr = mnd_nbr 
            and   mnt_select = mnd_select
            no-lock no-error.
            if available mnt_det then v-lus = mnt_label.
                                 else v-lus = "".
            find first mnt_det 
            where mnt_lang = "ch" 
            and   mnt_nbr = mnd_nbr 
            and   mnt_select = mnd_select
            no-lock no-error.
            if available mnt_det then v-lch = mnt_label.
                                 else v-lch = "".
            DISP  mnd_nbr + "." + string(mnd_select) @ mnd_nbr SPACE(2) v-lus space(2) v-lch.
        end.
    end.
  END. /*fm268*/


    /* REPORT TRAILER */
    /*{mfrtrail.i} */

end. /*repeat*/
