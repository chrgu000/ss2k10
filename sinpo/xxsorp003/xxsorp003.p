/* mgrnrp.p - REASON CODE REFERENCE REPORT                              */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* xxsorp003.p - null detail so report                                        */
/*V8:ConvertMode=FullGUIReport                                                */
/* $Revision: 120703.1 $ BY: zy DATE: 07/03/12                                */
/*-Revision end---------------------------------------------------------------*/

{mfdtitle.i "120703.1"}

define variable nbr like so_nbr.
define variable nbr1 like so_nbr.
define variable usr like usr_userid.
define variable usr1 like usr_userid.
define variable usrname like usr_name format "x(8)".
/*K1D1* /* DISPLAY TITLE */
 * {mfdtitle.i "2+ "} */

form
   nbr           colon 25
   nbr1          label {t001.i}
	 usr					 colon 25 
	 usr1          label {t001.i} skip(1)
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

 {wbrp01.i}

repeat:

   if nbr1 = hi_char then nbr1 = "".
   if usr1 = hi_char then usr1 = "".

 if c-application-mode <> 'web' then
   update nbr nbr1 usr usr1 with frame a.

 {wbrp06.i &command = update &fields = " nbr nbr1 usr usr1 "
          &frm = "a"}

 if (c-application-mode <> 'web') or
 (c-application-mode = 'web' and
 (c-web-request begins 'data')) then do:

   if nbr1 = "" then nbr1 = hi_char.
   if usr1 = "" then usr1 = hi_char.

 end.

   /* SELECT PRINTER */
   {mfselprt.i "printer" 80}
   {mfphead2.i}

   for each so_mstr no-lock
    where so_domain = global_domain and
          so_nbr >= nbr and (so_nbr <= nbr1 or nbr1 = "") and
    			so_userid >= usr and (so_userid <= usr1 or usr1 = "")
     with frame b width 80 no-attr-space:
                /* SET EXTERNAL LABELS */
                setFrameLabels(frame b:handle).
                {mfrpchk.i}     
 				if not can-find(first sod_det no-lock where sod_domain = so_domain and
 														  sod_nbr = so_nbr) then do:
 					 assign usrname = "".
 					 find first usr_mstr no-lock where usr_userid = so_userid no-error.
 					 if available usr_mstr then do:
 					 		assign usrname = usr_name.
 					 end.
 			  	 display so_nbr so_cust so_due_date so_userid usrname so_curr so_conf.
 			  end.

   end.
   {mftrl080.i}
end.

 {wbrp04.i &frame-spec = a}
