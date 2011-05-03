/* SS - 090906.1 By: Bill Jiang */

/* SS - 090906.1 - RNB
[090906.1]

  </table>

[090906.1]

SS - 090906.1 - RNE */

{mfdeclre.i}

DEFINE VARIABLE indent AS INTEGER INITIAL 2.
DEFINE VARIABLE indent1 AS CHARACTER.

indent1 = FILL(' ',indent).

PUT UNFORMATTED indent1 + "</table>" SKIP.

