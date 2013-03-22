define variable expUser as character initial
			 "排除用户列表".
define variable inti as integer.
define variable intj as integer.
define variable uid like usr_userid.
define variable upwd like usr_passwd.
define variable ucanrun like mnd_canrun.
define variable ugpn like usrg_group_name.
define variable ugpd like usrg_group_desc.
define variable ugid like usrg_mstr.oid_usrg_mstr.
define variable udom like usrgd_domain.
define variable usid like usrgd_userid.
input from upwd.txt.
inti = 0.
repeat:
	 import delimiter ";" uid upwd.
	 inti = inti + 1.
	 if index(expUser,uid) = 0 then do:
		  find first usr_mstr exclusive-lock where usr_userid = uid no-error.
		  if not available usr_mstr then do:
		  	 create usr_mstr.
		  	 assign usr_userid = uid.
		  end.
		  assign usr_lang = "CH"
		  			 usr_ctry_code = "PRC"
		  			 usr_access_loc = "PRIMARY"
		  			 usr_timezone = "GMT+8"
		  			 usr_force_change = no
		  			 usr_passwd = upwd
		  			 usr_active_reason = "QAD_DEF"
		  			 usr_last_date = today + 100.
	 end.
end.
input close.
output to value("./log.txt") append.
put unformat "Total " + trim(string(inti)) + " users passwd restored." skip.
output close.

assign uid = ""
       inti = 0
       intj = 0
       upwd = "".

input from ucanr.txt.
repeat:
  import delimiter "," uid intj ucanrun.
  find first mnd_det exclusive-lock where mnd_nbr = uid and mnd_select = intj no-error.
  if available mnd_det then do:
     assign inti = inti + 1.
     assign mnd_canrun = ucanrun.
  end.
end.
input close.

output to value("./log.txt") append.
put unformat "Total " + trim(string(inti)) + " Menu access information restored." skip.
output close.
