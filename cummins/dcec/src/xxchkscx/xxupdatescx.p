

define variable part like scx_part.
define variable fm   like scx_shipfrom.
define variable si   like scx_shipto.
define variable tp   as   integer.
define variable sp   as   character.

input from /home/mfg/a.csv.
repeat:
	import delimiter "," part fm si tp sp.
	find first scx_ref no-lock where scx_domain = "dcec"
			   and scx_part = part and scx_shipfrom = fm
			   and scx_shipto = si
			   and scx_type = tp no-error.
	 if available scx_ref then do:
	 FIND FIRST pod_det EXCLUSIVE-LOCK WHERE pod_domain = "dcec" and pod_nbr = scx_po
     AND pod_line = scx_line NO-ERROR.
     IF AVAILABLE POD_DET THEN DO:
     	  DISPLAY POD_NBR POD_LINE POD_PART POD_QTY_ORD POD__CHR01.
     END.
	 end.
end.
input close.