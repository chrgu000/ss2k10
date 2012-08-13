{mfdeclre.i}
{gplabel.i}

DEFINE INPUT PARAMETER prgm AS CHAR.
DEFINE INPUT PARAMETER bfid AS INTEGER.
DEFINE NEW SHARED VARIABLE cimcase AS CHAR. /*used to identify the cim program*/

 ASSIGN cimcase = prgm.

 CASE prgm:
     WHEN 'poporc.p' THEN
          {bcrun.i ""bcmgwrfl01.p"" "(input bfid)"}

    WHEN 'iclotr02.p' THEN
          {bcrun.i ""bcmgwrfl02.p"" "(input bfid)"}

    WHEN 'iclotr0201.p' THEN
          {bcrun.i ""bcmgwrfl0201.p"" "(input bfid)"}

    WHEN 'icunis.p' THEN
          {bcrun.i ""bcmgwrfl03.p"" "(input bfid)"}

    WHEN 'icunrc.p' THEN
          {bcrun.i ""bcmgwrfl04.p"" "(input bfid)"}

     WHEN "rcshmt.p" THEN
            {bcrun.i ""bcmgwrfl05.p"" "(input bfid)"}

     WHEN "iclotr04.p" THEN
            {bcrun.i ""bcmgwrfl06.p"" "(input bfid)"}

    WHEN "rebkfl.p" THEN
            {bcrun.i ""bcmgwrfl10.p"" "(INPUT bfid)"}

    WHEN "sosois.p" THEN 
            {bcrun.i ""bcmgwrfl11.p"" "(input bfid)"}

    WHEN "wowoisrc.p" THEN
            {bcrun.i ""bcmgwrfl12.p"" "(input bfid)"}

    WHEN "wowomt.p"  THEN
            {bcrun.i ""bcmgwrfl13.p"" "(input bfid)"}

   WHEN "sfoptr01.p" THEN
            {bcrun.i ""bcmgwrfl14.p"" "(input bfid)"}

END CASE.

   
