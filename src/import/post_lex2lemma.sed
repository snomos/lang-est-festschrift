#!/bin/sed -f

/VARS/s/$/%{stemill%}/
/k<ir.DE@VARS/s/%{stemill%}//
/[ _-][k]*<õr.DE@VARS/s/%{stemill%}/&%{rare%}/
/k<üün.DE@VARS/s/%{stemill%}/&%{rare%}/
/k<aan.DE@VARS/s/%{stemill%}//
/n<ii.DE@VARS/s/%{stemill%}//
/p<ar.DE@VARS/s/%{stemill%}//
/t<õr.DE@VARS/s/%{stemill%}/&%{rare%}/
/v<ar.DE@VARS/s/%{stemill%}/&%{rare%}/
/v<oo.DE@VARS/s/%{stemill%}//

/KEEL/s/$/%{stemill%}/
/h<iir.DE@KEEL/s/%{stemill%}//
/k<iir.DE@KEEL/s/%{stemill%}/&%{rare%}/
/l<een.DE@KEEL/s/%{stemill%}/&%{rare%}/
/j<uur.DE@KEEL/s/%{stemill%}//
/n<ool.DE@KEEL/s/%{stemill%}/&%{rare%}/
/s<aar.DE@KEEL/s/%{stemill%}/&/
/\-\-@KEEL/s/%{stemill%}//

/[ _]h<aarde .*@PINGE/s/$/%{stemill%}/
/[ _]h<oolde .*@PINGE/s/$/%{stemill%}/
/[ _]k<ütte .*@PINGE/s/$/%{stemill%}/
/[ _]p<alge .*@PINGE/s/$/%{stemill%}/
/[ _]r<iide .*@PINGE/s/$/%{stemill%}/
/[ _]r<ooste .*@PINGE/s/$/%{stemill%}/
/[ _]t<oime .*@PINGE/s/$/%{stemill%}/
/[ _]t<äkke .*@PINGE/s/$/%{stemill%}/
/[ _]r<akke .*@PINGE/s/$/%{stemill%}%{rare%}/

