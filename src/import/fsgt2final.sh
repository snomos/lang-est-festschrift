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
> adjectives.tmp1

# short adjectives are special in that they may compound in sg nom

# adjectives ending in v

echo '\nLEXICON Adjectives_v\n' >> adjectives.lexc
cat adjectives.tmp1 \
| grep -v '#' | grep 'v+' \
| sed '/^[^aeiouõäöü]*[aeiouõäöü]*[^aeiouõäöü]*[aeiouõäöü][aeiouõäöü]*[^aeiouõäöü]*+A/s/^\([^:]*+A\):\([^;]*;\)\(.*\)$/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/;.*nnolastpart/s/^\([^:]*+A\):\([^;]*;\)\(.*\)nnolastpart/@R.Part.One@\1:@R.Part.One@\2\3/' \
>> adjectives.lexc

# adjectives ending in ne

echo '\nLEXICON Adjectives_ne\n' >> adjectives.lexc
cat adjectives.tmp1 \
| grep -v '#' | grep 'ne+' \
| sed '/;.*nnolastpart/s/^\([^:]*+A\):\([^;]*;\)\(.*\)nnolastpart/@R.Part.One@\1:@R.Part.One@\2\3/' \
>> adjectives.lexc

# other adjectives

echo '\nLEXICON PlainAdjectives\n' >> adjectives.lexc

cat adjectives.tmp1 \
| grep '#' \
> adjectives.tmp2
cat adjectives.tmp1 \
| grep -v '#' | grep -v 'ne+' | grep -v 'v+' \
| sed '/^[^aeiouõäöü]*[aeiouõäöü]*[^aeiouõäöü]*[aeiouõäöü][aeiouõäöü]*[^aeiouõäöü]*+A/s/^\([^:]*+A\):\([^;]*;\)\(.*\)$/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^[^aeiouõäöü]*[aeiouõäöü]*[^aeiouõäöü]*[aeiouõäöü]tu+A/s/^\([^:]*+A\):\([^;]*;\)\(.*\)$/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
>> adjectives.tmp2
cat adjectives.tmp2 \
| sed '/;.*nnolastpart/s/^\([^:]*+A\):\([^;]*;\)\(.*\)nnolastpart/@R.Part.One@\1:@R.Part.One@\2\3/' \
| sort -u >> adjectives.lexc

echo '\nLEXICON NoninflectingAdjectives\n' > noninflecting_adjectives.lexc
cat fs_gt.noninfl.tmp1 | grep '+A:' >> noninflecting_adjectives.lexc

echo 'LEXICON ComparativeAdjectives\n' > comparative_adjectives.lexc
cat fs_gt.inflecting.tmp1 | grep '+A+Comp' >> comparative_adjectives.lexc

echo 'LEXICON SuperlativeAdjectives\n' > superlative_adjectives.lexc
cat fs_gt.inflecting.tmp1 | grep '+A+Superl' >> superlative_adjectives.lexc

# find short adverbs:
# grep '^[^aeiouõäöü]*[aeiouõäöü]*[^aeiouõäöü][^aeiouõäöü][aeiouõäöü][aeiouõäöü]*[^aeiouõäöü]*[^aeiouõäöü]i*+[^#=]*$'

# lisaks (1), lisaks (2)
cat fs_gt.noninfl.tmp1 | grep '+Adv' \
| grep '\(^all+\)\|\(^alt+\)\|\(^eel+\)\|\(^ees+\)\|\(^ise+\)\|\(^jae+\)\|\(^oma+\)\|\(^pea+\)\|\(^ula+\)\|\(^õue+\)\|\(^ära+\)\|\(^üle+\)\|\(^....+\)\|\(^umbes+\)\|\(^....[^s]+[^#-]*$\)\|\(^...ks+[^#-]*$\)' \
| grep -v '\(^miks+\)\|\(^näos+\)\|\(^egas+\)\|\(^kuis+\)\|\(^siis+\)\|\(^teps+\)\|\(^aina+\)\|\(^aiva+\)\|\(^eele+\)\|\(^eelt+\)\|\(^ikka+\)\|\(^istu+\)\|\(^jalu+\)\|\(^jaol+\)\|\(^jokk+\)\|\(^juba+\)\|\(^just+\)\|\(^jõle+\)\|\(^jönt+\)\|\(^kohe+\)\|\(^kole+\)\|\(^kord+\)\|\(^kuhu+\)\|\(^kuna+\)\|\(^küll+\)\|\(^loga+\)\|\(^loha+\)\|\(^losa+\)\|\(^mant+\)\|\(^manu+\)\|\(^nagu+\)\|\(^nõka+\)\|\(^nõus+\)\|\(^nüüd+\)\|\(^olgu+\)\|\(^puha+\)\|\(^põsi+\)\|\(^päta+\)\|\(^seep+\)\|\(^seni+\)\|\(^siva+\)\|\(^sugu+\)\|\(^tuna+\)\|\(^täna+\)\|\(^töhe+\)\|\(^vaid+\)\|\(^vaja+\)\|\(^veel+\)\|\(^vist+\)\|\(^väga+\)\|\(^õige+\)\|\(^õkva+\)\|\(^ähmi+\)\|\(^äkki+\)\|\(^ängi+\)\|\(^äsja+\)\|\(^+ühti\)\|\(^üsna+\)' \
> tmpadv.1

# lisaks (3)
cat fs_gt.noninfl.tmp1 | grep '+Adv' \
| grep '\(^alles+\)\|\(^edasi+\)\|\(^eraldi+\)\|\(^halvasti+\)\|\(^juurde+\)\|\(^järele+\)\|\(^kaotsi+\)\|\(^kaugele+\)\|\(^kaugelt+\)\|\(^kergelt+\)\|\(^kergesti+\)\|\(^kindlaks+\)\|\(^klaariks+\)\|\(^käsitsi+\)\|\(^kõrgelt+\)\|\(^kõrval+\)\|\(^kõrvalt+\)\|\(^kõvaks+\)\|\(^kõrvuti+\)\|\(^külili+\)\|\(^laiali+\)' \
>> tmpadv.1

# NB! see loend olgu sama, mis lisaks (2)
cat fs_gt.noninfl.tmp1 | grep '+Adv' \
| grep '\(^miks+\)\|\(^näos+\)\|\(^egas+\)\|\(^kuis+\)\|\(^siis+\)\|\(^teps+\)\|\(^aina+\)\|\(^aiva+\)\|\(^eele+\)\|\(^eelt+\)\|\(^ikka+\)\|\(^istu+\)\|\(^jalu+\)\|\(^jaol+\)\|\(^jokk+\)\|\(^juba+\)\|\(^just+\)\|\(^jõle+\)\|\(^jönt+\)\|\(^kohe+\)\|\(^kole+\)\|\(^kord+\)\|\(^kuhu+\)\|\(^kuna+\)\|\(^küll+\)\|\(^loga+\)\|\(^loha+\)\|\(^losa+\)\|\(^mant+\)\|\(^manu+\)\|\(^nagu+\)\|\(^nõka+\)\|\(^nõus+\)\|\(^nüüd+\)\|\(^olgu+\)\|\(^puha+\)\|\(^põsi+\)\|\(^päta+\)\|\(^seep+\)\|\(^seni+\)\|\(^siva+\)\|\(^sugu+\)\|\(^tuna+\)\|\(^täna+\)\|\(^töhe+\)\|\(^vaid+\)\|\(^vaja+\)\|\(^veel+\)\|\(^vist+\)\|\(^väga+\)\|\(^õige+\)\|\(^õkva+\)\|\(^ähmi+\)\|\(^äkki+\)\|\(^ängi+\)\|\(^äsja+\)\|\(^+ühti\)\|\(^üsna+\)' \
> tmpadv.2

#> adverbs.tmp2
# NB! see loend olgu sama, mis lisaks (1)
cat fs_gt.noninfl.tmp1 | grep '+Adv' \
| grep -v '\(^all+\)\|\(^alt+\)\|\(^eel+\)\|\(^ees+\)\|\(^ise+\)\|\(^jae+\)\|\(^oma+\)\|\(^pea+\)\|\(^ula+\)\|\(^õue+\)\|\(^ära+\)\|\(^üle+\)\|\(^....+\)\|\(^umbes+\)\|\(^....[^s]+[^#-]*$\)\|\(^...ks+[^#-]*$\)' \
>> tmpadv.2
#>> adverbs.tmp2

# NB! see loend olgu sama, mis lisaks (3)
cat tmpadv.2 | grep -v '\(^alles+\)\|\(^edasi+\)\|\(^eraldi+\)\|\(^halvasti+\)\|\(^juurde+\)\|\(^järele+\)\|\(^kaotsi+\)\|\(^kaugele+\)\|\(^kaugelt+\)\|\(^kergelt+\)\|\(^kergesti+\)\|\(^kindlaks+\)\|\(^klaariks+\)\|\(^käsitsi+\)\|\(^kõrgelt+\)\|\(^kõrval+\)\|\(^kõrvalt+\)\|\(^kõvaks+\)\|\(^kõrvuti+\)\|\(^külili+\)\|\(^laiali+\)' \
> tmpadv.3

#>> adverbs.lexc

echo 'LEXICON Adverbs\n\n CompoundingAdverbs ;\n @P.Part.Bad@ PlainAdverbs ;\n\nLEXICON CompoundingAdverbs\n' > adverbs.lexc
cat tmpadv.1 | sort -u >> adverbs.lexc

echo '\nLEXICON PlainAdverbs\n' >> adverbs.lexc

cat tmpadv.3 | sort -u >> adverbs.lexc
#cat adverbs.tmp2 | sort -u >> adverbs.lexc

echo 'LEXICON Adpositions\n' > adpositions.lexc
cat fs_gt.noninfl.tmp1 | grep '+Adp' >> adpositions.lexc

echo 'LEXICON Conjunctions\n' > conjunctions.lexc
cat fs_gt.noninfl.tmp1 | grep '+C[CS]' >> conjunctions.lexc

# add compounding-related flag diacritics to individual words

# kirjuta iga kirje taha see inf, mis fs_lex-sist tuleb
# ... ja palju PINGE tüüpi sõnu polegi deverbaalideks märgitud...
# (ja siin all olevad lisandused pole kõik, mis võimalik...)
cat fs_gt.inflecting.tmp1 | grep '+N:' \
| sed 's/^\(WDEVERBAL\)\(.*\)$/\2\1/' \
| sed 's/^\(mnocompound\)\(.*\)$/\2\1/' \
| sed 's/^\(nnolastpart\)\(.*\)$/\2\1/' \
| sed '/^haare+/s/$/WDEVERBAL/' \
| sed '/^heide+/s/$/WDEVERBAL/' \
| sed '/^hoie+/s/$/WDEVERBAL/' \
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
| sed '/^loome+/s/$/WDEVERBAL/' \
| sed '/^luure+/s/$/WDEVERBAL/' \
| sed '/^lüke+/s/$/WDEVERBAL/' \
| sed '/^muie+/s/$/WDEVERBAL/' \
| sed '/^möire+/s/$/WDEVERBAL/' \
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
| LC_COLLATE=C sort > fs_gt.inflecting.tmp1.srt

# ja lisa siia märge nende lühikeste nimisõnade kohta, mis ei osale liitsõnades
LC_COLLATE=C join -t+ -a 1 -a 2 -o 1.1 2.1 2.2 head_esiosad fs_gt.inflecting.tmp1.srt | grep -v '++' | sed '/^[^+].*+N/s/$/heaesi/' | sed 's/^[^+]*+//' > fs_gt.inflecting.tmp1.tagged
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
| sed '/;.*heaesi/s/^\([^:]*+N\):\([^;]*;\)\(.*\)heaesi/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^[^@].....*+[^#]* TAUD/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/ism+.*TAUD/s/@P.NomStem.First@//g' \
| sed '/^[^@]...*us+.* OLULINE/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^[^@]...*us+.* SUULINE/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^[^@]....*+[^#]* REDEL/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^[^@]....*+[^#]* VIRSIK/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^[^@]....*+[^#]* ÄMBLIK/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^käsi+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^tõsi+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/^vesi+/s/^\([^:]*+N\):\([^;]*;\)\(.*\)/@P.NomStem.First@\1:@P.NomStem.First@\2\3/' \
| sed '/;.*mnocompound/s/^\([^:]*+N\):\([^;]*;\)\(.*\)mnocompound/@R.Part.One@@P.Part.Bad@\1:@R.Part.One@@P.Part.Bad@\2\3/' \
| sed '/;.*nnolastpart/s/^\([^:]*+N\):\([^;]*;\)\(.*\)nnolastpart/@R.Part.One@\1:@R.Part.One@\2\3/' \
| sed 's/@R.Part.One@@R.Part.One@/@R.Part.One@/g' \
\
| sed '/-/s/@P.NomStem.First@//g' \
| sed '/@akt+N/s/@P.NomStem.First@//g' \
| sed '/@and+N/s/@P.NomStem.First@//g' \
| sed '/@aut+N/s/@P.NomStem.First@//g' \
| sed '/@ebe+N/s/@P.NomStem.First@//g' \
| sed '/@käi+N/s/@P.NomStem.First@//g' \
| sed '/@net+N/s/@P.NomStem.First@//g' \
| sed '/@ost+N/s/@P.NomStem.First@//g' \
| sed '/@sai+N/s/@P.NomStem.First@//g' \
| sed '/@urb+N/s/@P.NomStem.First@//g' \
| sed '/@äss+N/s/@P.NomStem.First@//g' \
| sed '/@äär+N/s/@P.NomStem.First@//g' \
| sed '/@õpe+N/s/@P.NomStem.First@//g' \
| sed '/@õpp+N/s/@P.NomStem.First@//g' \
| sed '/@aare+N/s/@P.NomStem.First@//g' \
| sed '/@agar+N/s/@P.NomStem.First@//g' \
| sed '/@alef+N/s/@P.NomStem.First@//g' \
| sed '/@anne+N/s/@P.NomStem.First@//g' \
| sed '/@aser+N/s/@P.NomStem.First@//g' \
| sed '/@enne+N/s/@P.NomStem.First@//g' \
| sed '/@isur+N/s/@P.NomStem.First@//g' \
| sed '/@jaan+N/s/@P.NomStem.First@//g' \
| sed '/@kalm+N/s/@P.NomStem.First@//g' \
| sed '/@karm+N/s/@P.NomStem.First@//g' \
| sed '/@kate+N/s/@P.NomStem.First@//g' \
| sed '/@kibe+N/s/@P.NomStem.First@//g' \
| sed '/@kirs+N/s/@P.NomStem.First@//g' \
| sed '/@koos+N/s/@P.NomStem.First@//g' \
| sed '/@kost+N/s/@P.NomStem.First@//g' \
| sed '/@kuri+N/s/@P.NomStem.First@//g' \
| sed '/@kuts+N/s/@P.NomStem.First@//g' \
| sed '/@kõik+N/s/@P.NomStem.First@//g' \
| sed '/@külm+N/s/@P.NomStem.First@//g' \
| sed '/@lase+N/s/@P.NomStem.First@//g' \
| sed '/@libe+N/s/@P.NomStem.First@//g' \
| sed '/@lits+N/s/@P.NomStem.First@//g' \
| sed '/@lään+N/s/@P.NomStem.First@//g' \
| sed '/@mart+N/s/@P.NomStem.First@//g' \
| sed '/@meil+N/s/@P.NomStem.First@//g' \
| sed '/@mõte+N/s/@P.NomStem.First@//g' \
| sed '/@olem+N/s/@P.NomStem.First@//g' \
| sed '/@paks+N/s/@P.NomStem.First@//g' \
| sed '/@pask+N/s/@P.NomStem.First@//g' \
| sed '/@peet+N/s/@P.NomStem.First@//g' \
| sed '/@pide+N/s/@P.NomStem.First@//g' \
| sed '/@pime+N/s/@P.NomStem.First@//g' \
| sed '/@rake+N/s/@P.NomStem.First@//g' \
| sed '/@saad+N/s/@P.NomStem.First@//g' \
| sed '/@sade+N/s/@P.NomStem.First@//g' \
| sed '/@sarn+N/s/@P.NomStem.First@//g' \
| sed '/@siss+N/s/@P.NomStem.First@//g' \
| sed '/@summ+N/s/@P.NomStem.First@//g' \
| sed '/@süüd+N/s/@P.NomStem.First@//g' \
| sed '/@taar+N/s/@P.NomStem.First@//g' \
| sed '/@tead+N/s/@P.NomStem.First@//g' \
| sed '/@ujum+N/s/@P.NomStem.First@//g' \
| sed '/@vald+N/s/@P.NomStem.First@//g' \
| sed '/@varr+N/s/@P.NomStem.First@//g' \
| sed '/@žanr+N/s/@P.NomStem.First@//g' \
| sed '/@soend+N/s/@P.NomStem.First@//g' \
\
| sed '/^iga+/s/^\([^:]*\):\(.*\)$/@D.Case.Nom@\1:@D.Case.Nom@\2/' \
| sed '/^au+/s/^\([^:]*\):\(.*\)$/@D.Case.Nom@\1:@D.Case.Nom@\2/' \
| sed '/@lust+/s/^\([^:]*\):\(.*\)$/@D.Case.Nom@\1:@D.Case.Nom@\2/' \
\
| sed -f bad_after_nom3.sed \
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
cat fs_gt.inflecting.tmp1 | grep '+Pron' | sed 's/nnolastpart//' >> pronouns.lexc
cat pronouns_exceptions.handmade >> pronouns.lexc

echo 'LEXICON NoninflectingVerbs\n' > noninflecting_verbs.lexc
cat fs_gt.noninfl.tmp1 | grep '+V:' >> noninflecting_verbs.lexc
cat ara.handmade >> noninflecting_verbs.lexc

echo 'LEXICON Interjections\n' > interjections.lexc
cat fs_gt.noninfl.tmp1 | grep '+Interj' >> interjections.lexc

echo 'LEXICON GenitiveAttributes\n' > genitive_attributes.lexc
cat fs_gt.noninfl.tmp1 | grep '+N+Sg+Gen' >> genitive_attributes.lexc

echo 'LEXICON Verbs\n\ntaas+Pref#:taas# SimpleVerbs ;\ntaas+Pref#:taas# EerVerbs ;\nde+Pref#:de# EerVerbs ;\nre+Pref#:re# EerVerbs ;\nSimpleVerbs ;\nEerVerbs ;\n' > verbs.lexc
echo '\nLEXICON SimpleVerbs\n' >> verbs.lexc
cat fs_gt.inflecting.tmp1 | grep '+V:' | grep -v '...eer[iu]ma+' \
| sed 's/nnolastpart//' >> verbs.lexc
echo '\nLEXICON EerVerbs\n' >> verbs.lexc
cat fs_gt.inflecting.tmp1 | grep '+V:' | grep '...eer[iu]ma+' \
| sed 's/nnolastpart//' >> verbs.lexc

# NB! this relies on the dir structure being the same as in Giellatekno
cp *.lexc ../morphology/stems



