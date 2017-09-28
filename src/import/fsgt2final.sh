#!/bin/sh
# NB! run in the import dir where the source files are, i.e. ./fsgt2final.sh

cat fs_gt.noninfl \
| sed 's/""/\n/g' \
| sed 's/^[^|]*| //g' \
> fs_gt.noninfl.tmp1

cat fs_gt.inflecting \
| sed 's/""/\n/g' \
| sed 's/^[^|]*| //g' \
> fs_gt.inflecting.tmp1

echo 'LEXICON Adjectives\n\n @P.Stem.Short@ ShortAdjectives ;  ! max 2 syllables\n Adjectives_v ;  ! no compounds\n Adjectives_ne ;  ! no compounds\n PlainAdjectives ;\n' > adjectives.lexc

# ignore the classification of vabamorf
cat fs_gt.inflecting.tmp1 | grep '+A:' \
| sed 's/WDEVERBAL//' | sed 's/mnocompound//' \
> adjectives.tmp1

# short adjectives
# partly ignore the classification of vabamorf
echo '\nLEXICON ShortAdjectives\n\n @R.Part.One@@P.Part.Bad@ ShortAdjectives_nocompound ; ! bad part of a compound\n ShortAdjectives_norestrictions ;\n' >> adjectives.lexc

echo '\nLEXICON ShortAdjectives_nocompound  ! bad part of a compound\n' >> adjectives.lexc
cat adjectives.tmp1 | grep 'nnolastpart' \
| sed 's/nnolastpart//' \
>> adjectives.lexc

echo '\nLEXICON ShortAdjectives_norestrictions\n' >> adjectives.lexc
cat adjectives.tmp1 | grep -v 'nnolastpart' \
| grep -v '#' | grep -v 'lik+' | grep -v 'ne+' | grep -v 'v+' \
| grep '^[^aeiouõäöü]*[aeiouõäöü]*[^aeiouõäöü]*[aeiouõäöü][aeiouõäöü]*[^aeiouõäöü]*+A' \
>> adjectives.lexc

# adjectives ending in v; no compounds

echo '\nLEXICON Adjectives_v\n' >> adjectives.lexc
cat adjectives.tmp1 | grep -v 'nnolastpart' \
| grep -v '#' | grep 'v+' \
>> adjectives.lexc

# adjectives ending in ne; no compounds

echo '\nLEXICON Adjectives_ne\n' >> adjectives.lexc
cat adjectives.tmp1 | grep -v 'nnolastpart' \
| grep -v '#' | grep 'ne+' \
>> adjectives.lexc

# other adjectives; including compounds

echo '\nLEXICON PlainAdjectives\n' >> adjectives.lexc

cat adjectives.tmp1 | grep -v 'nnolastpart' \
| grep '#' \
> adjectives.tmp2
cat adjectives.tmp1 | grep -v 'nnolastpart' \
| grep -v '#' | grep 'lik+' \
>> adjectives.tmp2
cat adjectives.tmp1 | grep -v 'nnolastpart' \
| grep -v '#' | grep -v 'lik+' | grep -v 'ne+' | grep -v 'v+' \
| grep -v '^[^aeiouõäöü]*[aeiouõäöü]*[^aeiouõäöü]*[aeiouõäöü][aeiouõäöü]*[^aeiouõäöü]*+A' \
>> adjectives.tmp2
cat adjectives.tmp2 | sort -u >> adjectives.lexc

echo '\nLEXICON NoninflectingAdjectives\n' > noninflecting_adjectives.lexc
cat fs_gt.noninfl.tmp1 | grep '+A:' >> noninflecting_adjectives.lexc

echo 'LEXICON ComparativeAdjectives\n' > comparative_adjectives.lexc
cat fs_gt.inflecting.tmp1 | grep '+A+Comp' >> comparative_adjectives.lexc

echo 'LEXICON SuperlativeAdjectives\n' > superlative_adjectives.lexc
cat fs_gt.inflecting.tmp1 | grep '+A+Superl' >> superlative_adjectives.lexc

# find short adverbs:
# grep '^[^aeiouõäöü]*[aeiouõäöü]*[^aeiouõäöü][^aeiouõäöü][aeiouõäöü][aeiouõäöü]*[^aeiouõäöü]*[^aeiouõäöü]i*+[^#=]*$'

echo 'LEXICON Adverbs\n\n CompoundingAdverbs ;\n @P.Part.Bad@ PlainAdverbs ;\n\nLEXICON CompoundingAdverbs\n' > adverbs.lexc
cat fs_gt.noninfl.tmp1 | grep '+Adv' \
| grep '\(^all+\)\|\(^alt+\)\|\(^eel+\)\|\(^ees+\)\|\(^ise+\)\|\(^jae+\)\|\(^oma+\)\|\(^pea+\)\|\(^ula+\)\|\(^õue+\)\|\(^ära+\)\|\(^üle+\)\|\(^....+\)\|\(^umbes+\)\|\(^....[^s]+[^#-]*$\)\|\(^...ks+[^#-]*$\)' \
| grep -v '\(^miks+\)\|\(^näos+\)\|\(^egas+\)\|\(^kuis+\)\|\(^siis+\)\|\(^teps+\)\|\(^aina+\)\|\(^aiva+\)\|\(^eele+\)\|\(^eelt+\)\|\(^ikka+\)\|\(^istu+\)\|\(^jalu+\)\|\(^jaol+\)\|\(^jokk+\)\|\(^juba+\)\|\(^just+\)\|\(^jõle+\)\|\(^jönt+\)\|\(^kaua+\)\|\(^kohe+\)\|\(^kole+\)\|\(^kord+\)\|\(^kuhu+\)\|\(^kuna+\)\|\(^küll+\)\|\(^ligi+\)\|\(^loga+\)\|\(^loha+\)\|\(^losa+\)\|\(^mant+\)\|\(^manu+\)\|\(^nagu+\)\|\(^nõka+\)\|\(^nõus+\)\|\(^nüüd+\)\|\(^olgu+\)\|\(^puha+\)\|\(^põsi+\)\|\(^päta+\)\|\(^seep+\)\|\(^seni+\)\|\(^siva+\)\|\(^sugu+\)\|\(^tuna+\)\|\(^täna+\)\|\(^töhe+\)\|\(^vaid+\)\|\(^vaja+\)\|\(^veel+\)\|\(^vist+\)\|\(^väga+\)\|\(^õige+\)\|\(^õkva+\)\|\(^ähmi+\)\|\(^äkki+\)\|\(^ängi+\)\|\(^äsja+\)\|\(^+ühti\)\|\(^üsna+\)' \
>> adverbs.lexc

echo '\nLEXICON PlainAdverbs\n' >> adverbs.lexc
cat fs_gt.noninfl.tmp1 | grep '+Adv' \
| grep '\(^miks+\)\|\(^näos+\)\|\(^egas+\)\|\(^kuis+\)\|\(^siis+\)\|\(^teps+\)\|\(^aina+\)\|\(^aiva+\)\|\(^eele+\)\|\(^eelt+\)\|\(^ikka+\)\|\(^istu+\)\|\(^jalu+\)\|\(^jaol+\)\|\(^jokk+\)\|\(^juba+\)\|\(^just+\)\|\(^jõle+\)\|\(^jönt+\)\|\(^kaua+\)\|\(^kohe+\)\|\(^kole+\)\|\(^kord+\)\|\(^kuhu+\)\|\(^kuna+\)\|\(^küll+\)\|\(^ligi+\)\|\(^loga+\)\|\(^loha+\)\|\(^losa+\)\|\(^mant+\)\|\(^manu+\)\|\(^nagu+\)\|\(^nõka+\)\|\(^nõus+\)\|\(^nüüd+\)\|\(^olgu+\)\|\(^puha+\)\|\(^põsi+\)\|\(^päta+\)\|\(^seep+\)\|\(^seni+\)\|\(^siva+\)\|\(^sugu+\)\|\(^tuna+\)\|\(^täna+\)\|\(^töhe+\)\|\(^vaid+\)\|\(^vaja+\)\|\(^veel+\)\|\(^vist+\)\|\(^väga+\)\|\(^õige+\)\|\(^õkva+\)\|\(^ähmi+\)\|\(^äkki+\)\|\(^ängi+\)\|\(^äsja+\)\|\(^+ühti\)\|\(^üsna+\)' \
> adverbs.tmp2
cat fs_gt.noninfl.tmp1 | grep '+Adv' \
| grep -v '\(^all+\)\|\(^alt+\)\|\(^eel+\)\|\(^ees+\)\|\(^ise+\)\|\(^jae+\)\|\(^oma+\)\|\(^pea+\)\|\(^ula+\)\|\(^õue+\)\|\(^ära+\)\|\(^üle+\)\|\(^....+\)\|\(^umbes+\)\|\(^....[^s]+[^#-]*$\)\|\(^...ks+[^#-]*$\)' \
>> adverbs.tmp2
cat adverbs.tmp2 | sort -u >> adverbs.lexc

echo 'LEXICON Adpositions\n' > adpositions.lexc
cat fs_gt.noninfl.tmp1 | grep '+Adp' >> adpositions.lexc

echo 'LEXICON Conjunctions\n' > conjunctions.lexc
cat fs_gt.noninfl.tmp1 | grep '+C[CS]' >> conjunctions.lexc

echo 'LEXICON Nouns\n\n DeverbalNouns ;\n PlainNouns ;\n' > nouns.lexc

echo '\nLEXICON DeverbalNouns\n' >> nouns.lexc
cat fs_gt.inflecting.tmp1 | grep '+N:' \
| grep 'WDEVERBAL' | sed 's/WDEVERBAL//' \
>> nouns.lexc

echo '\nLEXICON PlainNouns\n\n @R.Part.One@@P.Part.Bad@ PlainNouns_nocompound ;\n @R.Part.One@ PlainNouns_nolastpart ;\n PlainNouns_norestrictions ;\n' >> nouns.lexc

echo '\nLEXICON PlainNouns_nocompound\n' >> nouns.lexc
cat fs_gt.inflecting.tmp1 | grep '+N:' \
| grep -v 'WDEVERBAL' \
| grep 'mnocompound' \
| sed 's/mnocompound//' \
>> nouns.lexc

echo '\nLEXICON PlainNouns_nolastpart\n' >> nouns.lexc
cat fs_gt.inflecting.tmp1 | grep '+N:' \
| grep -v 'WDEVERBAL' \
| grep 'nnolastpart' \
| sed 's/nnolastpart//' \
>> nouns.lexc

echo '\nLEXICON PlainNouns_norestrictions\n' >> nouns.lexc
cat fs_gt.inflecting.tmp1 | grep '+N:' \
| grep -v 'WDEVERBAL' \
| grep -v 'mnocompound' \
| grep -v 'nnolastpart' \
>> nouns.lexc

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



