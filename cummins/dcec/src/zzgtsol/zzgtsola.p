/* zzgtsola.P - UPLOAD INVOICE DATA GENERATE BY GOLD-TAX INTO MFG/PRO       */
/*                                                                         */
/* VERSION:          DATE:2000.04.17  BY:James Zou*ORIGIN SHA*BW0000       */


/*cal order inv total amt*/

/*define input parameter  v_inv_nbr  as character.*/
/*20001024* define output parameter v_mfgamt   as decimal. */
define input parameter  v_so_nbr   as character.
/*20001024*/ define output parameter v_mfgtotamt   like glt_amt.
/*20001024*/ define output parameter v_mfgtaxamt   like glt_amt .
/*20001024*/ define output parameter v_mfgnetamt    like glt_amt.

{zzgtsotot.i}

/*20002024*b*/
  v_mfgtotamt = line_total + tax_amt + disc_amt.
  v_mfgtaxamt = tax_amt.
  v_mfgnetamt = v_mfgtotamt - v_mfgtaxamt.
/*20002024*e*/


