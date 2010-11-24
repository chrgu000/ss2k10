/* Creation: eB21SP3 Chui Last Modified: 20071214 By: Davild Xu *ss-20071214.1*/
/* DISPLAY TITLE */
{mfdeclre.i}
pause 0 .
DEFINE output parameter barcode_userid as char  .
find first mon_mstr where mon_userid = global_userid and mon_sid = mfguser no-error.
if avail mon_mstr then assign barcode_userid = mon_user1 .

