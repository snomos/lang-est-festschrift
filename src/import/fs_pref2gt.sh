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
>>  pref.lexc

echo 'ainu+Pref:ainu- #;' >> pref.lexc
echo 'esi+Pref:esi- #;' >> pref.lexc
echo 'ees+Pref:ees- #;' >> pref.lexc
echo 'eel+Pref:eel- #;' >> pref.lexc
echo 'ime+Pref:ime- #;' >> pref.lexc

echo 'alg+Pref:alg- #;' >> pref.lexc
echo 'all+Pref:all- #;' >> pref.lexc
echo 'alla+Pref:alla- #;' >> pref.lexc
echo 'anti+Pref:anti- #;' >> pref.lexc
echo 'eht+Pref:eht- #;' >> pref.lexc
echo 'eks+Pref:eks- #;' >> pref.lexc
echo 'emas+Pref:emas- #;' >> pref.lexc
echo 'era+Pref:era- #;' >> pref.lexc
echo 'eri+Pref:eri- #;' >> pref.lexc
echo 'euro+Pref:euro- #;' >> pref.lexc
echo 'finants+Pref:finants- #;' >> pref.lexc
echo 'haju+Pref:haju- #;' >> pref.lexc
echo 'hulgi+Pref:hulgi- #;' >> pref.lexc
echo 'jae+Pref:jae- #;' >> pref.lexc
echo 'isas+Pref:isas- #;' >> pref.lexc
echo 'kesk+Pref:kesk- #;' >> pref.lexc
echo 'külalis+Pref:külalis- #;' >> pref.lexc
echo 'laus+Pref:laus- #;' >> pref.lexc
echo 'lõhke+Pref:lõhke- #;' >> pref.lexc
echo 'meelis+Pref:meelis- #;' >> pref.lexc
echo 'mega+Pref:mega- #;' >> pref.lexc
echo 'mitte+Pref:mitte- #;' >> pref.lexc
echo 'muidu+Pref:muidu- #;' >> pref.lexc
echo 'multi+Pref:multi- #;' >> pref.lexc
echo 'nais+Pref:nais- #;' >> pref.lexc

cat pref.lexc | sort -u >> prefixes.lexc

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
alg all alla anti eel ees eht+adj eks emas enam enama+adj enese+adj enim+adj era eri esi ette+adj? euro
finants haju hulgi hüper isas ise? jae jooksev? järel kesk kõrval käsitsi? külalis laus lõhke meelis mega mitte
muidu multi mõne+adj nais

lisasin prefiksite hulka, nii et nüüd on veel lisamata:
enam enama+adj enese+adj enim+adj ette+adj? ise? jooksev? järel kõrval käsitsi? mõne+adj

verbile liituvad
alles edasi eraldi halvasti juurde järele kaotsi? kaua kaugele kergelt kergesti kindlaks kinni klaariks? kõrgelt kõvaks kõrvuti+adj? külili laiali ligi läbi lähedal

lisasin adv faili, nii et nüüd on veel lisamata:
 lähedal

deverbid
kaeve kandlus

kapitalist ei tuletu kapitalismi alusel

laiatarbe, linnalähi

võiks olla lubatud 1. tüvena -ne -> sus, näit funktsionaalsus
 
 
miks ei tunne  hariduskapitalistide heleda+adj kahvatumust kannatadasaamise jne

miks ei tunne kümnendajärguline nooremlipnik

kas on õige pikemad arvsõnad + adj?




