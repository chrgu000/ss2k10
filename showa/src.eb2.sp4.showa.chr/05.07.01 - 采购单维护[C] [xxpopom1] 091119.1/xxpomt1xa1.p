/* SS - 090907.1 By: Neil Gao */
/* SS 090907.1 - B */
/*
���ӵ���scm����
*/
/* SS 090907.1 - E */

{mfdeclre.i}
{gplabel.i}

define input parameter iptf1 like po_nbr.
define output parameter optf1 as logical.
define var ifdy as logical.
define var scmfilename as char format "x(40)".

find first po_mstr where po_nbr = iptf1 no-lock no-error.
if avail po_mstr then do:

/*����bill��ʽ�ж��Ƿ���*/
	{gprun.i ""xxsccomGetSyncOption.p"" "(input po_vend, output ifdy)"}

	if ifdy then do:
		/*����bill��ʽ*/
		{gprun.i ""xxsccomCreateSendCommandData_PO.p"" "(input po_nbr,
		                               input po_nbr,
		                               input po_vend,
		                               input po_vend,
		                               input po_buyer,
		                               input po_buyer,
		                               input 'xxscposi.p',
		                               input-output scmfilename)"}
	  if scmfilename <> "" then do:
	  	optf1 = yes.
	  	/*д��ͬ������*/
	  	if optf1 then {gprun.i ""xxpomt1xa2.p"" "(input scmfilename,input po_nbr)"}.
	  end.
	  
	  
	end.
end.
