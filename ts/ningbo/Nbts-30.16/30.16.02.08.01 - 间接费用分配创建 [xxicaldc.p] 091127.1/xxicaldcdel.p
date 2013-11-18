/* SS - 091127.1 By: Bill Jiang */

/* SS - 091127.1 - RNB
É¾³ý¾ÉÊý¾Ý
SS - 091127.1 - RNE */

{mfdeclre.i}

DEFINE INPUT PARAMETER entity AS CHARACTER.
DEFINE INPUT PARAMETER yr AS INTEGER.
DEFINE INPUT PARAMETER per AS INTEGER.

FOR EACH xxicald_det EXCLUSIVE-LOCK
   WHERE xxicald_domain = GLOBAL_domain
   AND xxicald_entity = entity
   AND xxicald_year = yr
   AND xxicald_per = per
   :
   DELETE xxicald_det.
END.

FOR EACH xxical_mstr EXCLUSIVE-LOCK
   WHERE xxical_domain = GLOBAL_domain
   AND xxical_entity = entity
   AND xxical_year = yr
   AND xxical_per = per
   :
   DELETE xxical_mstr.
END.
