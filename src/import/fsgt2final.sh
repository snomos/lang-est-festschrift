#!/bin/sh
# NB! run in the import dir where the source files are, i.e. ./fsgt2final.sh
# NB! leia_osad.sh must have generated head_esiosad, the file with good noun first parts of compounds

cat fs_gt.noninfl \
| sed 's/""/\n/g' \
| sed 's/^[^|]*| //g' \
> fs_gt.noninfl.tmp1

cat fs_gt.inflecting \
| sed 's/""/\n/g' \
| sed 's/^[^|]*| //g' \
> fs_gt.inflecting.tmp1

echo 'LEXICON Adjectives\n\n Adjectives_v ;\n Adjectives_ne ;\n PlainAdjectives ;\n' > adjectives.lexc
#echo 'LEXICON Adjectives\n\n @P.Stem.Short@ ShortAdjectives ;  ! max 2 syllables\n Adjectives_v ;  ! no compounds\n Adjectives_ne ;  ! no compounds\n PlainAdjectives ;\n' > adjectives.lexc

# ignore the classification of vabamorf
cat fs_gt.inflecting.tmp1 | grep '+A:' \
| sed 's/WDEVERBAL//' | sed 's/mnocompound//' \
| sed 's/^\(nnolastpart\)\(.*\)$/\2\1/' \
| sed 's/kilo#/kilo?/' \
| sed 's/milli#/milli?/' \
| sed 's/mega#/mega?/' \
| sed 's/\(giga\)#/\1?/' \
| sed 's/\(senti\)#/\1?/' \
| sed 's/\(mikro\)#/\1?/' \
| sed 's/\(detsi\)#/\1?/' \
| sed 's/\(atmo\)#/\1?/' \
| sed 's/#\(m.eetrine\)/?\1/' \
| sed 's/#\(päevane\)/?\1/' \
| sed '/#.*?päevane/s/?/#/' \
| sed 's/\(iga\)?\(päevane\)/\1#\2/' \
| sed 's/\(kahe\)?\(päevane\)/\1#\2/' \
| sed 's/\(mõne\)?\(päevane\)/\1#\2/' \
| sed 's/\(paari\)?\(päevane\)/\1#\2/' \
| sed 's/\(täna\)?\(päevane\)/\1#\2/' \
| sed 's/\(ühe\)?\(päevane\)/\1#\2/' \
> adjectives.tmp1

# short adjectives are special in that they may compound in sg nom

# adjectives ending in v

echo '\nLEXICON Adjectives_v\n' >> adjectives.lexc
cat adjectives.tmp1 \
| grep -v '#' | grep 'v+' \
| sed '/^[^aeiouõäöü]*[aeiouõäöü]*[^aeiouõäöü]*[aeiouõäöü][aeiouõäöü]*[^aeiouõäöü]*+A/s/^\([^:]*+A\):\([^;]*;\)\(.*\)$/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/;.*nnolastpart/s/^\([^:]*+A\):\([^;]*;\)\(.*\)nnolastpart/@R.Part.One@\1:@R.Part.One@\2\3/' \
| sed 's/?/#/g' \
>> adjectives.lexc

# adjectives ending in ne

echo '\nLEXICON Adjectives_ne\n' >> adjectives.lexc
cat adjectives.tmp1 \
| grep -v '#' | grep 'ne+' \
| sed '/;.*nnolastpart/s/^\([^:]*+A\):\([^;]*;\)\(.*\)nnolastpart/@R.Part.One@\1:@R.Part.One@\2\3/' \
| sed 's/?/#/g' \
>> adjectives.lexc

# other adjectives

echo '\nLEXICON PlainAdjectives\n' >> adjectives.lexc

cat adjectives.tmp1 \
| grep '#' \
> adjectives.tmp2

# in compounding, pruunjas and hallikas expect adjective to follow
cat adjectives.tmp1 \
| grep -v '#' | grep '[jk]as+' \
| sed 's/^\([^:]*+A\):\([^;]*;\)\(.*\)$/@P.Der.kas@@P.NomStem.First@\1:@P.Der.kas@@P.NomStem.First@\2\3/' \
| sed '/[ph]aljas+/s/@P.Der.kas@//g' \
>> adjectives.tmp2

cat adjectives.tmp1 \
| grep -v '#' | grep -v 'ne+' | grep -v 'v+' | grep -v '[jk]as+' \
| sed '/^[^aeiouõäöü]*[aeiouõäöü]*[^aeiouõäöü]*[aeiouõäöü][aeiouõäöü]*[^aeiouõäöü]*+A/s/^\([^:]*+A\):\([^;]*;\)\(.*\)$/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^[^aeiouõäöü]*[aeiouõäöü]*[^aeiouõäöü]*[aeiouõäöü]tu+A/s/^\([^:]*+A\):\([^;]*;\)\(.*\)$/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
>> adjectives.tmp2

cat adjectives.tmp2 \
| sed '/;.*nnolastpart/s/^\([^:]*+A\):\([^;]*;\)\(.*\)nnolastpart/@R.Part.One@\1:@R.Part.One@\2\3/' \
| sed '/@kasutu+/s/@P.NomStem.First@//g' \
| sed '/@antu+/s/@P.NomStem.First@//g' \
| sed 's/?/#/g' \
| sort -u >> adjectives.lexc

echo '\nLEXICON NoninflectingAdjectives\n\n CompoundingNoninflectingAdjectives ;\n PlainNoninflectingAdjectives ;\n\nLEXICON CompoundingNoninflectingAdjectives\n' \
> noninflecting_adjectives.lexc
cat fs_gt.noninfl.tmp1 | grep '+A:' > noninflecting_adjectives.tmp1

# NB! grep list1
cat noninflecting_adjectives.tmp1 \
| grep '\(^karva+\)\|\(^võitu+\)\|\(^värvi+\)' \
>> noninflecting_adjectives.lexc

echo '\nLEXICON PlainNoninflectingAdjectives\n' >> noninflecting_adjectives.lexc

# mark good words for compounding 
# by falsely giving them the tag of a shortened form (like vaatamis-),
# although these are uninflected words...
# NB! grep -v list1
cat noninflecting_adjectives.tmp1 \
| grep -v '\(^karva+\)\|\(^võitu+\)\|\(^värvi+\)' \
\
| sed '/^ekstra+/s/^\([^:]*+A\):\([^;]*;\)\(.*\)/@P.Case.Short@\1:@P.Case.Short@\2\3/' \
| sed '/^eri+/s/^\([^:]*+A\):\([^;]*;\)\(.*\)/@P.Case.Short@\1:@P.Case.Short@\2\3/' \
| sed '/^ise+/s/^\([^:]*+A\):\([^;]*;\)\(.*\)/@P.Case.Short@\1:@P.Case.Short@\2\3/' \
| sed '/^mega+/s/^\([^:]*+A\):\([^;]*;\)\(.*\)/@P.Case.Short@\1:@P.Case.Short@\2\3/' \
| sed '/^paaris+/s/^\([^:]*+A\):\([^;]*;\)\(.*\)/@P.Case.Short@\1:@P.Case.Short@\2\3/' \
| sed '/^päris+/s/^\([^:]*+A\):\([^;]*;\)\(.*\)/@P.Case.Short@\1:@P.Case.Short@\2\3/' \
| sed '/^täis+/s/^\([^:]*+A\):\([^;]*;\)\(.*\)/@P.Case.Short@\1:@P.Case.Short@\2\3/' \
| sed '/^väärt+/s/^\([^:]*+A\):\([^;]*;\)\(.*\)/@P.Case.Short@\1:@P.Case.Short@\2\3/' \
> noninflecting_adjectives.tmp2

cat noninflecting_adjectives.tmp2 >> noninflecting_adjectives.lexc

echo 'LEXICON ComparativeAdjectives\n' > comparative_adjectives.lexc
cat fs_gt.inflecting.tmp1 | grep '+A+Comp' > comparative_adjectives.tmp1

# mark good words for compounding in Sg Nom
cat comparative_adjectives.tmp1 \
| sed '/^alam+/s/^\([^:]*+A+Comp\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^enam+/s/^\([^:]*+A+Comp\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^kauem+/s/^\([^:]*+A+Comp\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^lähem+/s/^\([^:]*+A+Comp\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^lühem+/s/^\([^:]*+A+Comp\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^noorem+/s/^\([^:]*+A+Comp\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^parem+/s/^\([^:]*+A+Comp\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^suurem+/s/^\([^:]*+A+Comp\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^vanem+/s/^\([^:]*+A+Comp\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^vähem+/s/^\([^:]*+A+Comp\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^ülem+/s/^\([^:]*+A+Comp\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
> comparative_adjectives.tmp2

cat comparative_adjectives.tmp2 >> comparative_adjectives.lexc

echo 'LEXICON SuperlativeAdjectives\n' > superlative_adjectives.lexc
cat fs_gt.inflecting.tmp1 | grep '+A+Superl' > superlative_adjectives.tmp1

# mark good words for compounding in Sg Nom
cat superlative_adjectives.tmp1 \
| sed '/^enim+/s/^\([^:]*+A+Superl\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^vähim+/s/^\([^:]*+A+Superl\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^ülim+/s/^\([^:]*+A+Superl\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
> superlative_adjectives.tmp2

cat superlative_adjectives.tmp2 >> superlative_adjectives.lexc



# find short adverbs:
# grep '^[^aeiouõäöü]*[aeiouõäöü]*[^aeiouõäöü][^aeiouõäöü][aeiouõäöü][aeiouõäöü]*[^aeiouõäöü]*[^aeiouõäöü]i*+[^#=]*$'

# lisaks (1), lisaks (2)
cat fs_gt.noninfl.tmp1 | grep '+Adv' \
| grep '\(^järel+\)\|\(^kõrval+\)\|\(^otse+\)\|\(^piki+\)\|\(^püsti+\)\|\(^ratsa+\)\|\(^taga+\)\|\(^topelt+\)\|\(^vastas+\)\|\(^vastu+\)\|\(^üle+\)' \
> tmpadv.0

cat fs_gt.noninfl.tmp1 | grep '+Adv' \
| grep -v '\(^järel+\)\|\(^kõrval+\)\|\(^otse+\)\|\(^piki+\)\|\(^püsti+\)\|\(^ratsa+\)\|\(^taga+\)\|\(^topelt+\)\|\(^vastas+\)\|\(^vastu+\)\|\(^üle+\)' \
> tmpadv.alg

cat tmpadv.alg \
| grep '\(^all+\)\|\(^alt+\)\|\(^eel+\)\|\(^ees+\)\|\(^ise+\)\|\(^jae+\)\|\(^oma+\)\|\(^pea+\)\|\(^ula+\)\|\(^õue+\)\|\(^ära+\)\|\(^üle+\)\|\(^....+\)\|\(^umbes+\)\|\(^....[^s]+[^#-]*$\)\|\(^...ks+[^#-]*$\)' \
| grep -v '\(^miks+\)\|\(^näos+\)\|\(^egas+\)\|\(^kuis+\)\|\(^siis+\)\|\(^teps+\)\|\(^aina+\)\|\(^aiva+\)\|\(^eele+\)\|\(^eelt+\)\|\(^ikka+\)\|\(^istu+\)\|\(^jalu+\)\|\(^jaol+\)\|\(^jokk+\)\|\(^juba+\)\|\(^just+\)\|\(^jõle+\)\|\(^jönt+\)\|\(^kohe+\)\|\(^kole+\)\|\(^kord+\)\|\(^kuhu+\)\|\(^kuna+\)\|\(^küll+\)\|\(^loga+\)\|\(^loha+\)\|\(^losa+\)\|\(^mant+\)\|\(^manu+\)\|\(^nagu+\)\|\(^nõka+\)\|\(^nõus+\)\|\(^nüüd+\)\|\(^olgu+\)\|\(^puha+\)\|\(^põsi+\)\|\(^päta+\)\|\(^seep+\)\|\(^seni+\)\|\(^siva+\)\|\(^sugu+\)\|\(^tuna+\)\|\(^täna+\)\|\(^töhe+\)\|\(^vaid+\)\|\(^vaja+\)\|\(^veel+\)\|\(^vist+\)\|\(^väga+\)\|\(^õige+\)\|\(^õkva+\)\|\(^ähmi+\)\|\(^äkki+\)\|\(^ängi+\)\|\(^äsja+\)\|\(^+ühti\)\|\(^üsna+\)' \
> tmpadv.1

# lisaks (3)
cat tmpadv.alg \
| grep '\(^alasti+\)\|\(^alles+\)\|\(^edasi+\)\|\(^eemale+\)\|\(^eemalt+\)\|\(^eraldi+\)\|\(^halvasti+\)\|\(^juurde+\)\|\(^järele+\)\|\(^kaotsi+\)\|\(^kaugele+\)\|\(^kaugelt+\)\|\(^kergelt+\)\|\(^kergesti+\)\|\(^kindlaks+\)\|\(^klaariks+\)\|\(^käsitsi+\)\|\(^kõrgelt+\)\|\(^kõrval+\)\|\(^kõrvalt+\)\|\(^kõvaks+\)\|\(^kõrvuti+\)\|\(^külili+\)\|\(^laiali+\)\|\(^raskesti+\)\|\(^seni+\)\|\(^sisse+\)\|\(^tagant+\)\|\(^tagasi+\)\|\(^viimati+\)\|\(^võistu+\)\|\(^vääriti+\)\|\(^äsja+\)' \
>> tmpadv.1

# NB! see loend olgu sama, mis lisaks (2)
cat tmpadv.alg \
| grep '\(^miks+\)\|\(^näos+\)\|\(^egas+\)\|\(^kuis+\)\|\(^siis+\)\|\(^teps+\)\|\(^aina+\)\|\(^aiva+\)\|\(^eele+\)\|\(^eelt+\)\|\(^ikka+\)\|\(^istu+\)\|\(^jalu+\)\|\(^jaol+\)\|\(^jokk+\)\|\(^juba+\)\|\(^just+\)\|\(^jõle+\)\|\(^jönt+\)\|\(^kohe+\)\|\(^kole+\)\|\(^kord+\)\|\(^kuhu+\)\|\(^kuna+\)\|\(^küll+\)\|\(^loga+\)\|\(^loha+\)\|\(^losa+\)\|\(^mant+\)\|\(^manu+\)\|\(^nagu+\)\|\(^nõka+\)\|\(^nõus+\)\|\(^nüüd+\)\|\(^olgu+\)\|\(^puha+\)\|\(^põsi+\)\|\(^päta+\)\|\(^seep+\)\|\(^seni+\)\|\(^siva+\)\|\(^sugu+\)\|\(^tuna+\)\|\(^täna+\)\|\(^töhe+\)\|\(^vaid+\)\|\(^vaja+\)\|\(^veel+\)\|\(^vist+\)\|\(^väga+\)\|\(^õige+\)\|\(^õkva+\)\|\(^ähmi+\)\|\(^äkki+\)\|\(^ängi+\)\|\(^äsja+\)\|\(^+ühti\)\|\(^üsna+\)' \
> tmpadv.2

#> adverbs.tmp2
# NB! see loend olgu sama, mis lisaks (1)
cat tmpadv.alg \
| grep -v '\(^all+\)\|\(^alt+\)\|\(^eel+\)\|\(^ees+\)\|\(^ise+\)\|\(^jae+\)\|\(^oma+\)\|\(^pea+\)\|\(^ula+\)\|\(^õue+\)\|\(^ära+\)\|\(^üle+\)\|\(^....+\)\|\(^umbes+\)\|\(^....[^s]+[^#-]*$\)\|\(^...ks+[^#-]*$\)' \
>> tmpadv.2
#>> adverbs.tmp2

# NB! see loend olgu sama, mis lisaks (3)
cat tmpadv.2 | grep -v '\(^alasti+\)\|\(^alles+\)\|\(^edasi+\)\|\(^eemale+\)\|\(^eemalt+\)\|\(^eraldi+\)\|\(^halvasti+\)\|\(^juurde+\)\|\(^järele+\)\|\(^kaotsi+\)\|\(^kaugele+\)\|\(^kaugelt+\)\|\(^kergelt+\)\|\(^kergesti+\)\|\(^kindlaks+\)\|\(^klaariks+\)\|\(^käsitsi+\)\|\(^kõrgelt+\)\|\(^kõrval+\)\|\(^kõrvalt+\)\|\(^kõvaks+\)\|\(^kõrvuti+\)\|\(^külili+\)\|\(^laiali+\)\|\(^raskesti+\)\|\(^seni+\)\|\(^sisse+\)\|\(^tagant+\)\|\(^tagasi+\)\|\(^viimati+\)\|\(^võistu+\)\|\(^vääriti+\)\|\(^äsja+\)' \
> tmpadv.3

#>> adverbs.lexc

echo 'LEXICON Adverbs\n\n CompoundingAdverbs ;\n @P.Part.Bad@ PlainAdverbs ;\n\n' > adverbs.lexc
echo 'LEXICON CompoundingAdverbs\n\n @P.Stem.topelt@ NounCompoundingAdverbs ;\n VerbCompoundingAdverbs ;\n\n' >> adverbs.lexc

echo 'LEXICON NounCompoundingAdverbs\n' >> adverbs.lexc
cat tmpadv.0 >> adverbs.lexc

echo '\nLEXICON VerbCompoundingAdverbs\n' >> adverbs.lexc
cat tmpadv.1 \
| sed '/^vähe+/s/^\([^:]*\):\([^;]*;\)\(.*\)/@P.Stem.vähe@\1:@P.Stem.vähe@\2\3/' \
| sed '/^puht+/s/^\([^:]*\):\([^;]*;\)\(.*\)/@P.Stem.vähe@\1:@P.Stem.vähe@\2\3/' \
| sort -u \
>> adverbs.lexc

echo '\nLEXICON PlainAdverbs\n' >> adverbs.lexc

cat tmpadv.3 | sort -u >> adverbs.lexc
#cat adverbs.tmp2 | sort -u >> adverbs.lexc

echo 'LEXICON Adpositions\n' > adpositions.lexc
cat fs_gt.noninfl.tmp1 | grep '+Adp' >> adpositions.lexc

echo 'LEXICON Conjunctions\n' > conjunctions.lexc
cat fs_gt.noninfl.tmp1 | grep '+C[CS]' >> conjunctions.lexc

# add compounding-related flag diacritics to individual words

# kirjuta iga kirje taha see inf, mis fs_lex-sist tuleb
# ja eering-lõpulised
# ... ja palju PINGE tüüpi sõnu polegi deverbaalideks märgitud...
# (ja siin all olevad lisandused pole kõik, mis võimalik...)
cat fs_gt.inflecting.tmp1 | grep '+N:' \
| sed 's/^\(WDEVERBAL\)\(.*\)$/\2\1/' \
| sed 's/^\(mnocompound\)\(.*\)$/\2\1/' \
| sed 's/^\(nnolastpart\)\(.*\)$/\2\1/' \
| sed '/WDEVERBAL/!s/ing+N[^#]*VIRSIK.*$/&WDEVERBAL/' \
| sed '/^veering+/s/WDEVERBAL//' \
| sed '/brauning+/s/WDEVERBAL//' \
| sed '/curling+N/s/WDEVERBAL//' \
| sed '/doping+N/s/WDEVERBAL//' \
| sed '/dumping+N/s/WDEVERBAL//' \
| sed '/elling+N/s/WDEVERBAL//' \
| sed '/etsing+N/s/WDEVERBAL//' \
| sed '/faktooring+N/s/WDEVERBAL//' \
| sed '/holding+N/s/WDEVERBAL//' \
| sed '/kamming+N/s/WDEVERBAL//' \
| sed '/kämping+N/s/WDEVERBAL//' \
| sed '/lasing+N/s/WDEVERBAL//' \
| sed '/miiting+N/s/WDEVERBAL//' \
| sed '/puding+N/s/WDEVERBAL//' \
| sed '/pööning+N/s/WDEVERBAL//' \
| sed '/reeling+N/s/WDEVERBAL//' \
| sed '/reiting+N/s/WDEVERBAL//' \
| sed '/seltsing+N/s/WDEVERBAL//' \
| sed '/smoking+N/s/WDEVERBAL//' \
| sed '/sobing+N/s/WDEVERBAL//' \
| sed '/soling+N/s/WDEVERBAL//' \
| sed '/spinning+N/s/WDEVERBAL//' \
| sed '/tafting+N/s/WDEVERBAL//' \
| sed '/telling+N/s/WDEVERBAL//' \
| sed '/täring+N/s/WDEVERBAL//' \
| sed '/valing+N/s/WDEVERBAL//' \
| sed '/^ehitis+/s/$/WDEVERBAL/' \
| sed '/^anne+/s/$/WDEVERBAL/' \
| sed '/^haare+/s/$/WDEVERBAL/' \
| sed '/^heide+/s/$/WDEVERBAL/' \
| sed '/^hindlus+/s/$/WDEVERBAL/' \
| sed '/^hoie+/s/$/WDEVERBAL/' \
| sed '/^hoole+/s/$/WDEVERBAL/' \
| sed '/^huige+/s/$/WDEVERBAL/' \
| sed '/^hõige+/s/$/WDEVERBAL/' \
| sed '/^hõise+/s/$/WDEVERBAL/' \
| sed '/^joode+/s/$/WDEVERBAL/' \
| sed '/^kaabe+/s/$/WDEVERBAL/' \
| sed '/^kaeve+/s/$/WDEVERBAL/' \
| sed '/^kaitse+/s/$/WDEVERBAL/' \
| sed '/^kanne+/s/$/WDEVERBAL/' \
| sed '/^karje+/s/$/WDEVERBAL/' \
| sed '/^kilge+/s/$/WDEVERBAL/' \
| sed '/^korje+/s/$/WDEVERBAL/' \
| sed '/^liide+/s/$/WDEVERBAL/' \
| sed '/^loome+/s/$/WDEVERBAL/' \
| sed '/^luure+/s/$/WDEVERBAL/' \
| sed '/^lõikus+/s/$/WDEVERBAL/' \
| sed '/^lüke+/s/$/WDEVERBAL/' \
| sed '/^maks+.*KOON/s/$/WDEVERBAL/' \
| sed '/^makse+/s/$/WDEVERBAL/' \
| sed '/^muie+/s/$/WDEVERBAL/' \
| sed '/^möire+/s/$/WDEVERBAL/' \
| sed '/^ost+.*KOON/s/$/WDEVERBAL/' \
| sed '/^pilge+/s/$/WDEVERBAL/' \
| sed '/^piste+/s/$/WDEVERBAL/' \
| sed '/^pooge+/s/$/WDEVERBAL/' \
| sed '/^purse+/s/$/WDEVERBAL/' \
| sed '/^puude+/s/$/WDEVERBAL/' \
| sed '/^pööre+/s/$/WDEVERBAL/' \
| sed '/^raie+/s/$/WDEVERBAL/' \
| sed '/^surve+/s/$/WDEVERBAL/' \
| sed '/^torge+/s/$/WDEVERBAL/' \
| sed '/^viibe+/s/$/WDEVERBAL/' \
| sed '/^viide+/s/$/WDEVERBAL/' \
| sed '/^võnge+/s/$/WDEVERBAL/' \
| sed '/^võte+/s/$/WDEVERBAL/' \
| sed '/^esi+/s/$/mnocompound/' \
| sed '/^deism+/s/$/mnocompound/' \
| sed '/^marss+/s/$/WDEVERBAL/' \
| sed '/^müük+/s/$/WDEVERBAL/' \
| sed '/^sööst+/s/$/WDEVERBAL/' \
| sed '/^vool+/s/$/WDEVERBAL/' \
| sed '/^õpe+/s/$/WDEVERBAL/' \
| sed '/^tulija+/s/$/WDEVERBAL/' \
| sed '/^panija+/s/$/WDEVERBAL/' \
| sed '/^tegija+/s/$/WDEVERBAL/' \
| sed '/^nägija+/s/$/WDEVERBAL/' \
| LC_COLLATE=C sort > fs_gt.inflecting.tmp1.srt

# ja lisa siia märge nende lühikeste nimisõnade kohta, mis ei osale liitsõnades
LC_COLLATE=C join -t+ -a 1 -a 2 -o 1.1 2.1 2.2 head_esiosad fs_gt.inflecting.tmp1.srt | grep -v '++' | sed '/^[^+].*+N/s/$/heaesi/' \
| sed '/^[k]*ost+/s/heaesi//' \
| sed '/^õpe+/s/heaesi//' \
| sed '/^anne+/s/heaesi//' \
| sed 's/^[^+]*+//' > fs_gt.inflecting.tmp1.tagged
#----

echo 'LEXICON Nouns\n\n DeverbalNouns ;\n PlainNouns ;\n' > nouns.lexc

echo '\nLEXICON DeverbalNouns\n' >> nouns.lexc
cat fs_gt.inflecting.tmp1.tagged | grep '+N:' \
| grep 'WDEVERBAL' | sed 's/WDEVERBAL//' \
| sed '/;.*heaesi/s/^\([^:]*+N\):\([^;]*;\)\(.*\)heaesi/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
>> nouns.lexc

#echo '\nLEXICON PlainNouns\n\n @R.Part.One@@P.Part.Bad@ PlainNouns_nocompound ;\n @R.Part.One@ PlainNouns_nolastpart ;\n @P.Len.3@ PlainNouns_three ;\n @P.Len.4@ PlainNouns_four ;\n PlainNouns_fiveplus ;\n' >> nouns.lexc

echo '\nLEXICON PlainNouns\n\n' >> nouns.lexc

# add flags for limiting compounding
cat fs_gt.inflecting.tmp1.tagged | grep '+N:' \
| grep -v 'WDEVERBAL' \
| sed 's/:de#/:de?/' \
| sed 's/:in#/:in?/' \
| sed 's/:re#/:re?/' \
| sed 's/:di#/:di?/' \
| sed 's/:bi#/:bi?/' \
| sed 's/:ir#/:ir?/' \
| sed 's/:an#/:an?/' \
| sed 's/:ko#/:ko?/' \
| sed 's/:im#/:im?/' \
| sed 's/:en#/:en?/' \
| sed 's/:eba#/:eba?/' \
| sed 's/:dis#/:dis?/' \
| sed 's/:bio#/:bio?/' \
| sed 's/:des#/:des?/' \
| sed 's/:geo#/:geo?/' \
| sed 's/:sub#/:sub?/' \
| sed 's/:dia#/:dia?/' \
| sed 's/:epi#/:epi?/' \
| sed 's/:iso#/:iso?/' \
| sed 's/:ego#/:ego?/' \
| sed 's/:pop#/:pop?/' \
| sed 's/:zoo#/:zoo?/' \
| sed 's/:kom#/:kom?/' \
| sed 's/:tri#/:tri?/' \
| sed 's/:pan#/:pan?/' \
| sed 's/:polü#/:polü?/' \
| sed 's/:an,ti#/:an,ti?/' \
| sed 's/:tele#/:tele?/' \
| sed '/;.*heaesi/s/^\([^:]*+N\):\([^;]*;\)\(.*\)heaesi/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^[^@]....*+[^#]* TAUD/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/ism+.*TAUD/s/@P.NomStem.First@//g' \
| sed '/@...[žš]+.*TAUD/s/@P.NomStem.First@//g' \
| sed '/^[^@]...*[iu]s+N:[^#]* OLULINE/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^[^@]...*s+N:[^#]* SUULINE/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^[^@]...*us+N:.*#.* SUULINE/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^[^@]...*[iu]s+N:.*#.* OLULINE/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^[^@]...*s+N:[^#]* KATKINE/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^[^@]...*s+N:[^#]* SOOLANE/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^[^@]....*+[^#]* REDEL/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^[^@]....*+[^#]* VIRSIK/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^[^@]....*+[^#]* ÄMBLIK/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^käsi+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^tõsi+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^mesi+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^vesi+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^säär+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^huul+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
\
| sed '/^emand+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^isand+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^kamar+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^kamin+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^kardin+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^keerits+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^kodar+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^kuhil+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^kägar+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^kõrvits+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^lagrits+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^latern+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^mügar+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^näpits+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^orav+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^pasun+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^ranits+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^rosin+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^räbal+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^rätsep+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^unelm+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^vasar+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^värnits+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^ädal+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
\
| sed '/^pritse+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^pude+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^pune+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^sade+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^helmes+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^helves+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^kirves+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^kääbas+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^kännas+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^küngas+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^laegas+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^lammas+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^pilbas+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^puhmas+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^roobas+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^turvas+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^tüügas+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^varras+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^varvas+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^baarium+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^deuteerium+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^gallium+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^germaanium+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^heelium+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^iriidium+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^kaadmium+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^kambium+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^nukleon+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^oopium+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^plutoonium+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^poloonium+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^raadium+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^strontsium+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^toorium+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^triitium+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^tseesium+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^vanaadium+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^händikäp+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^kabinet+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^siksak+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^kogumik+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^killustik+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
\
| sed -f nomstem_first_koon.sed \
| sed -f nomstem_first_piim.sed \
| sed -f nomstem_first_eit.sed \
\
| sed '/;.*mnocompound/s/^\([^:]*+N\):\([^;]*;\)\(.*\)mnocompound/@R.Part.One@@P.Part.Bad@\1:@R.Part.One@@P.Part.Bad@\2\3/' | sed '/^vana+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.Bad.Nonfinal@\1:@P.Bad.Nonfinal@\2\3/' \
| sed '/^alam+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.Bad.Nonfinal@\1:@P.Bad.Nonfinal@\2\3/' \
| sed '/@alam+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.Bad.Nonfinal@\1:@P.Bad.Nonfinal@\2\3/' \
| sed '/^ülem+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.Bad.Nonfinal@\1:@P.Bad.Nonfinal@\2\3/' \
| sed '/@ülem+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.Bad.Nonfinal@\1:@P.Bad.Nonfinal@\2\3/' \
| sed '/^pee+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.Bad.Nonfinal@\1:@P.Bad.Nonfinal@\2\3/' \
| sed '/^aar+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.Bad.Nonfinal@\1:@P.Bad.Nonfinal@\2\3/' \
| sed '/^boi+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.Bad.Nonfinal@\1:@P.Bad.Nonfinal@\2\3/' \
\
| sed '/;.*nnolastpart/s/^\([^:]*+N\):\([^;]*;\)\(.*\)nnolastpart/@R.Part.One@\1:@R.Part.One@\2\3/' \
| sed 's/@R.Part.One@@R.Part.One@/@R.Part.One@/g' \
\
| sed '/-/s/@P.NomStem.First@//g' \
\
| sed -f no_nomstem_first.sed \
\
| sed '/^iga+/s/^\([^:]*\):\(.*\)$/@D.Case.Nom@\1:@D.Case.Nom@\2/' \
| sed '/^au+/s/^\([^:]*\):\(.*\)$/@D.Case.Nom@\1:@D.Case.Nom@\2/' \
| sed '/@lust+/s/^\([^:]*\):\(.*\)$/@D.Case.Nom@\1:@D.Case.Nom@\2/' \
\
| sed -f bad_after_nom3.sed \
| sed 's/?/#/' \
>> nouns.lexc

# grep 'Nom#...+' korpustest-8-alakriips.hjk.hfst.14dets | sed 's/^.*Nom#\(...\)+.*$/\1/' | sort | uniq -c | sed 's/ \([^ ][^ ][^ ]\)$/ sed \/^\1+\/s\/^\\([^:]*\\):\\(.*\\)$\/@D.Case.Nom@\\1:@D.Case.Nom@\\2\//' | sed 's/^.* \/^/\/^/' 
# grep -v '\^töö+' | grep -v '\^ala+'
#> ~/svn-giellatekno/main/experiment-langs/est/src/import/bad_after_nom3.sed
# ... and filter by hand



#echo '\nLEXICON PlainNouns_fiveplus\n' >> nouns.lexc
#cat fs_gt.inflecting.tmp1 | grep '+N:' \
#| grep -v 'WDEVERBAL' \
#| grep -v 'mnocompound' \
#| grep -v 'nnolastpart' \
#| grep -v '^[^+][^+][^+]+' \
#| grep -v '^[^+][^+][^+][^+]+' \
#>> nouns.lexc

echo 'lapselaps+N: LAPSELAPS ;' >> nouns.lexc
echo 'lapselapselaps+N: LAPSELAPSELAPS ;' >> nouns.lexc

echo 'LEXICON ProperNouns\n' > propernouns.lexc
cat fs_gt.inflecting.tmp1 | grep '+N+Prop' | sed 's/nnolastpart//' >> propernouns.lexc

echo 'LEXICON CardinalNumerals\n' > cardinalnumerals.lexc
cat fs_gt.inflecting.tmp1 | grep '+Num+Card' \
| grep -v '#p.aar ' \
>> cardinalnumerals.lexc
echo 'poolteist+Num+Card:p´ool POOLTEIST ;' >> cardinalnumerals.lexc

echo 'LEXICON OrdinalNumerals\n' > ordinalnumerals.lexc
cat fs_gt.inflecting.tmp1 | grep '+Num+Ord' >> ordinalnumerals.lexc

echo 'LEXICON Pronouns\n\n @P.Part.Bad@ PlainPronouns ;\n CompoundingPronouns ;\n\nLEXICON PlainPronouns\n' > pronouns.lexc
cat fs_gt.noninfl.tmp1 | grep '+Pron' >> pronouns.lexc

# exclude list(1) words
cat fs_gt.inflecting.tmp1 | grep '+Pron' \
| sed 's/nnolastpart//' \
| grep -v '\(^iga+\)\|\(^mitu+\)\|\(^mõlema+\)\|\(^mõni+\)\|\(^sama+\)\|\(^palju+\)' \
>> pronouns.lexc

# insert LEXICON CompoundingPronouns
cat pronouns_exceptions.handmade \
| sed '/ise+/s/^\([^:]*\):\([^;]*;\)\(.*\)/@P.Stem.ise@\1:@P.Stem.ise@\2\3/' \
>> pronouns.lexc

# include list(1) words
cat fs_gt.inflecting.tmp1 | grep '+Pron' \
| sed 's/nnolastpart//' \
| grep '\(^iga+\)\|\(^mitu+\)\|\(^mõlema+\)\|\(^mõni+\)\|\(^sama+\)\|\(^palju+\)' \
>> pronouns.lexc

echo 'LEXICON NoninflectingVerbs\n' > noninflecting_verbs.lexc
cat fs_gt.noninfl.tmp1 | grep '+V:' >> noninflecting_verbs.lexc
cat ara.handmade >> noninflecting_verbs.lexc

echo 'LEXICON Interjections\n' > interjections.lexc
cat fs_gt.noninfl.tmp1 | grep '+Interj' >> interjections.lexc

echo 'LEXICON GenitiveAttributes\n' > genitive_attributes.lexc
cat fs_gt.noninfl.tmp1 | grep '+N+Sg+Gen' >> genitive_attributes.lexc

echo 'LEXICON Verbs\n\neel+Pref#:eel# SimpleVerbs ;\neel+Pref#:eel# EerVerbs ;\neelis+Pref#:eelis# SimpleVerbs ;\neelis+Pref#:eelis# EerVerbs ;\nkaug+Pref#:kaug# SimpleVerbs ;\nkaug+Pref#:kaug# EerVerbs ;\nkiir+Pref#:kiir# SimpleVerbs ;\nkiir+Pref#:kiir# EerVerbs ;\nsund+Pref#:sund# SimpleVerbs ;\nsund+Pref#:sund# EerVerbs ;\ntaas+Pref#:taas# SimpleVerbs ;\ntaas+Pref#:taas# EerVerbs ;\nvaeg+Pref#:vaeg# SimpleVerbs ;\nvaeg+Pref#:vaeg# EerVerbs ;\nühis+Pref#:ühis# SimpleVerbs ;\nühis+Pref#:ühis# EerVerbs ;\nde+Pref#:de# EerVerbs ;\nre+Pref#:re# EerVerbs ;\nSimpleVerbs ;\nEerVerbs ;\n' > verbs.lexc
echo '\nLEXICON SimpleVerbs\n' >> verbs.lexc
cat fs_gt.inflecting.tmp1 | grep '+V:' | grep -v '...eer[iu]ma+' \
| sed 's/nnolastpart//' \
| sed '/võidma+V/s/^\([^:]*\):\([^;]*;\)\(.*\)/@R.Part.One@@P.Part.Bad@\1:@R.Part.One@@P.Part.Bad@\2\3/' \
>> verbs.lexc

echo '\nLEXICON EerVerbs\n' >> verbs.lexc
cat fs_gt.inflecting.tmp1 | grep '+V:' | grep '...eer[iu]ma+' \
| sed 's/nnolastpart//' >> verbs.lexc

# NB! this relies on the dir structure being the same as in Giellatekno
cp *.lexc ../morphology/stems



