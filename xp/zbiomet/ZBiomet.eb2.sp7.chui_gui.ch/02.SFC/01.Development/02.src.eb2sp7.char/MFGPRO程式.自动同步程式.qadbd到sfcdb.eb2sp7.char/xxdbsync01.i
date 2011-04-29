        output to value(v_file) .
            export {1} .
        output close .

        input from value(v_file) .
            create {2} .
            import {2} .
        input close .

        release {2} .