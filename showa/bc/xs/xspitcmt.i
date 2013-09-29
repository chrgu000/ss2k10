/* $REVISION  $EB2SP4   $BY: Cosesa Yang DATE 09/22/13  ECO SS-20130922.1 */

/* Create MFG/PRO Execte File Path  START */
/* Create MFG/PRO Execte File Path   END  */

/* Create Section Variable START */
define variable usection as char format "x(17)".
/* Create Section Variable END */
define stream bf.
define stream bf1.
define stream bf2.

usection = "pitcmt1." + trim(string(tag_nbr)).
output stream bf to value( trim(usection) + ".bpi") .
put stream bf unformat trim(string(tag_nbr)) skip.
put stream bf unformat trim(vqty) " -" skip.
put stream bf unformat '- ' global_userid ' ' trim(string(today,"99/99/99")) ' "ÌõÂë²Ëµ¥(48-xspitcmt.p)"' skip.
put stream bf "." skip.
output stream bf close.
input from value ( usection + ".bpi") .
output to value ( usection + ".bpo") .
batchrun = yes.
        {gprun.i ""pitcmt1.p""}
batchrun = no.
input close.
output close.

os-delete value ( usection + ".bpi").
os-delete value ( usection + ".bpo").