define temp-table xbop
       fields xbop_comp like ps_comp
       fields xbop_op   like ps_op
       fields xbop_iss_pol like pt_iss_pol
       fields xbop_phantom like pt_phantom
       index xbop_comp xbop_op xbop_comp.