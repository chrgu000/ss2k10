/* SS - 091127.1 By: Bill Jiang */

/* SS - 091127.1 - RNB
∑÷≈‰±»¿˝
SS - 091127.1 - RNE */

{mfdeclre.i}

DEFINE INPUT PARAMETER entity AS CHARACTER.
DEFINE INPUT PARAMETER yr AS INTEGER.
DEFINE INPUT PARAMETER per AS INTEGER.

FOR EACH xxicar_det EXCLUSIVE-LOCK
   WHERE xxicar_domain = GLOBAL_domain
   AND xxicar_entity = entity
   AND xxicar_year = yr
   AND xxicar_per = per
   :
   ASSIGN
      xxicar_usage = xxicar_bp * xxicar_mp1 * xxicar_mp2 * xxicar_mp3 / xxicar_dp1 / xxicar_dp2 / xxicar_dp3
      xxicar_usage_tot = xxicar_qty * xxicar_usage
      .
END.
