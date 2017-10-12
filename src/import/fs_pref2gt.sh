#!/bin/sh
# convert Filosoft's prefix file to GT

echo 'LEXICON Prefixes\n' > prefixes.lexc

cat pref.pok \
| sed 's/^.*@//' \
| sed 's/,H.*$//' \
| sed 's/<//g' \
| sed 's/\]//g' \
| sed 's/?//g' \
| paste - pref.pok \
| tr '\t' '\n' \
| hfst-lookup ../analyser-gt-desc.hfstol \
| sed '/^6000/s/,.*$/_/' \
| tr -d '\n' \
| sed 's/_/\n/g' \
| grep '+?' \
| sed 's/^\([^\t]*\)\t.*@\(.*\)$/\1+Pref:\2- #;/' \
| ./diacritics.sed \
>>  prefixes.lexc

cp prefixes.lexc ../morphology/stems

exit

cat pref.pok \
| sed 's/^.*@//' \
| sed 's/,H.*$//' \
| sed 's/<//g' \
| sed 's/\]//g' \
| sed 's/?//g' \
| hfst-lookup ../analyser-gt-desc.hfstol \
| grep '?' | tr '\t' '_' | grep -v '^de_' | grep -v '^re_' \
| sed 's/_.*$//' \
| sed 's/^.*$/&+Pref:&- #;/' \ 
> prefixes.lexc


| sed 's/^6000.*@/@/' | sed '/@/s/,.*$/_/' \

------
eriti liituvad 
alg all alla anti eba eel ees eht+adj eks emas enam enama+adj enese+adj enim+adj era eri esi ette+adj? euro
finants haju hulgi hüper isas ise? jae jooksev? järel kesk kõrval käsitsi? külalis laus lõhke meelis mega mitte
muidu multi mõne+adj nais


verbile liituvad
alles edasi eraldi halvasti juurde järele kaotsi? kaua kaugele kergelt kergesti kindlaks kinni klaariks? kõrgelt kõvaks kõrvuti+adj? külili laiali ligi läbi lähedal

deverbid
kaeve kandlus

kapitalist ei tuletu kapitalismi alusel

laiatarbe, linnalähi

võiks olla lubatud 1. tüvena -ne -> sus, näit funktsionaalsus
 
 
miks ei tunne halvamaineline ? hariduskapitalistide heleda+adj imedissidentlik järsuveereline kahvatumust kannatadasaamise karedalehelise karmikäeline kindlakujuline laialehine jne
miks ei tunne kirikukorralduslik kultuurikorralduslik, ehkki tunneb kultuurikorraldus ja korralduslik; sama lugu mõtteklubilik

miks ei tunne külaliskokk kümnendajärguline nooremlipnik

kas on õige pikemad arvsõnad + adj?




