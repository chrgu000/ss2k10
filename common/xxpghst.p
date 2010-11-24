define input parameter ioutfile as character.

define variable pgmlevel as integer .
define variable vproc    as character.

pgmlevel = 3.
REPEAT WHILE (PROGRAM-NAME(pgmlevel) <> ?)
		AND INDEX(PROGRAM-NAME(pgmlevel), "gpwinrun") = 0:
  vproc = vproc + string(pgmlevel - 2, "99") + ":" 
        + program-name(pgmlevel) + "; ".
  pgmlevel = pgmlevel + 1.
END.
output to value(ioutfile).
  put unformat vproc skip.
output close.
