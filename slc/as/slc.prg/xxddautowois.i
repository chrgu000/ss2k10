/* Creation: eB21SP3 Chui Last Modified: 20080107 By: Davild Xu *ss-20071228.1*/
/* �������CIMLOAD wowois.p
{1} = ����ID
{2} = �������
{3} = �ص�
{4} = ��λ
{5} = ����
{6} = �ο�
{7} = ����
""" """  ����̶�ֵ���ֵҪ����3������
*/

/* define variable global_user_lang_dir as char format "x(40)" init "/app/mfgpro/eb2/". */
&if Defined(usection) = 0 &then 
define variable usection as char format "x(16)". 
&global-define usection ""
&endif
usection = "WOIS" + string(today,"999999")  + string(time,"HH:MM:SS") + trim({4}) + trim({5}) .

output to value( trim(usection) + ".i") .
	
	put unformatted " - " + {1}  + " - - - N "at 1 skip .
	put unformatted {7} +  " " + {8} at 1 skip .
	put unformatted {2} + " N N " + {3} + " " + {4} + " " + {5} + " " + {6} at 1 skip .
	put unformatted "." at 1 skip .
	put unformatted "Y" at 1 skip .
	put unformatted "Y" at 1 skip .
	put unformatted "." at 1 skip .

output close.

input from value ( usection + ".i") .
output to  value ( usection + ".o") .
        {gprun.i ""wowois.p""}
input close.
output close.


