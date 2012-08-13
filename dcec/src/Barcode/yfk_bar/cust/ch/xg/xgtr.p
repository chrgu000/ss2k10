DEFINE INPUT PARAMETER cimf  AS CHARACTER .
DEFINE INPUT PARAMETER part  AS CHARACTER .
DEFINE INPUT PARAMETER qty   AS CHARACTER .
DEFINE INPUT PARAMETER site1 AS CHARACTER .
DEFINE INPUT PARAMETER loc1 AS CHARACTER .
DEFINE INPUT PARAMETER loc2 AS CHARACTER .

OUTPUT TO VALUE(cimf) APPEND .
PUT UNFORMATTED 
    "@@batchload iclotr04.p" SKIP 
    "~"" part "~"" SKIP
    "~"" qty  "~"" SKIP(1)
    "~"" site1 "~" ~"" loc1 "~"" SKIP
    "~"" site1 "~" ~"" loc2 "~"" SKIP
    "." SKIP
    "." SKIP
    "@@end" SKIP .
OUTPUT CLOSE .

                


