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

