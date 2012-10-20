/* $Revision:eb21sp12  $ BY: Jordan Lin            DATE: 09/13/12  ECO: *SS-20120913.1*   */

{mfdtitle.i "120913.1"}

DEFINE VAR v_flag like mfc_logical initial no EXTENT 2.
DEFINE VAR v_cmmt LIKE in_user2 .


FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
    in_part    colon 22   LABEL "零件号" pt_desc2 no-label
    in_site    colon 22 LABEL "地点"  si_desc no-label  skip(1)
    v_flag[1]  colon 22 label "过期"
    v_flag[2]  colon 22 label "过量"
    v_cmmt    colon 22 label "说明" format "x(50)"
 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/
setframelabels(frame a:handle) .

view frame a.

mainloop:
REPEAT with frame a:
   prompt-for in_part in_site with frame a
      editing:
         if frame-field = "in_part" then do:
            /* Next/prev thru 'non-service' boms */
/*            {mfnp05.i in_mstr in_part " in_mstr.in_domain = global_domain and input in_part"
                in_part "input in_part"} */
         {mfnp.i in_mstr in_part  " in_domain = global_domain and in_part
         "  in_part in_part in_part}
	    if recno <> ? then do:
	        find first pt_mstr where pt_mstr.pt_domain = global_domain 
		                     and pt_part =  in_part no-lock no-error.
	        find first si_mstr where si_mstr.si_domain = global_domain 
		                     and si_site =  in_site no-lock no-error.
                if substring(in_user2,1,1) = "y" then 
                   v_flag[1] = yes .
		else v_flag[1] = no .

                if substring(in_user2,2,1) = "y" then 
                   v_flag[2] = yes .
		else v_flag[2] = no .

                v_cmmt   = substring(in_user2,3,LENGTH(in_user2) ).
               display in_part in_site v_flag[1] v_flag[2] v_cmmt pt_desc2 si_desc  with frame a.
            end.
	 end. /*  if frame-field = "ps_par" */

         if frame-field = "in_site" then do:
            /* Next/prev thru 'non-service' boms */
            {mfnp05.i in_mstr in_part " in_mstr.in_domain = global_domain and input in_part "
                in_site "input in_site"}

            if recno <> ? then do:
	        find first pt_mstr where pt_mstr.pt_domain = global_domain 
		                     and pt_part =  in_part no-lock no-error.
	        find first si_mstr where si_mstr.si_domain = global_domain 
		                     and si_site =  in_site no-lock no-error.

                if substring(in_user2,1,1) = "y" then 
                   v_flag[1] = yes .
		else v_flag[1] = no .

                if substring(in_user2,2,1) = "y" then 
                   v_flag[2] = yes .
		else v_flag[2] = no .
		v_cmmt   = substring(in_user2,3,LENGTH(in_user2) ).
               display in_part in_site v_flag[1] v_flag[2] v_cmmt pt_desc2 si_desc  with frame a.
            end.
	 end. /*  if frame-field = "ps_par" */

      end. /* editing */
      
      find first in_mstr where in_mstr.in_domain = global_domain 
                         and in_part = input in_part 
			 and in_site = input in_site no-error.

      if not available in_mstr then do:
          message "物料/地点库存数据不存在,请重新输入!" view-as alert-box error.
          undo,retry.
       end.

       find first pt_mstr where pt_mstr.pt_domain = global_domain 
		                     and pt_part =  in_part no-lock no-error.
       find first si_mstr where si_mstr.si_domain = global_domain 
		                     and si_site =  in_site no-lock no-error.

                if substring(in_user2,1,1) = "y" then 
                   v_flag[1] = yes .
		else v_flag[1] = no .

                if substring(in_user2,2,1) = "y" then 
                   v_flag[2] = yes .
		else v_flag[2] = no .

       v_cmmt   = substring(in_user2,3,LENGTH(in_user2) ).
       display in_part in_site v_flag[1] v_flag[2] v_cmmt pt_desc2 si_desc  with frame a.

      update v_flag[1] v_flag[2] v_cmmt with frame a.

      in_user2 = substring(string(v_flag[1]),1,1) + substring(string(v_flag[2]),1,1) + v_cmmt .

end. /* mainloop:  */

























