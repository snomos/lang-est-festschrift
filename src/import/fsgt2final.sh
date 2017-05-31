#!/bin/sh

echo 'LEXICON Adjectives\n' > adjectives.lexc
echo 'LEXICON NoninflectingAdjectives\n' > noninflecting_adjectives.lexc
echo 'LEXICON ComparativeAdjectives\n' > comparative_adjectives.lexc
echo 'LEXICON SuperlativeAdjectives\n' > superlative_adjectives.lexc
echo 'LEXICON Adverbs\n' > adverbs.lexc
echo 'LEXICON Adpositions\n' > adpositions.lexc
echo 'LEXICON Conjunctions\n' > conjunctions.lexc
echo 'LEXICON Nouns\n' > nouns.lexc
echo 'LEXICON ProperNouns\n' > propernouns.lexc
echo 'LEXICON Numerals\n' > numerals.lexc
echo 'LEXICON Pronouns\n' > pronouns.lexc
echo 'LEXICON Verbs\n' > verbs.lexc
echo 'LEXICON NoninflectingVerbs\n' > noninflecting_verbs.lexc
echo 'LEXICON Interjections\n' > interjections.lexc
echo 'LEXICON GenitiveAttributes\n' > genitive_attributes.lexc

cat fs_gt.noninfl \
| sed 's/""/\n/g' \
| sed 's/^[^|]*| //g' \
> fs_gt.noninfl.tmp1

cat fs_gt.noninfl.tmp1 | grep '+A:' >> noninflecting_adjectives.lexc
cat fs_gt.noninfl.tmp1 | grep '+Adv' >> adverbs.lexc
cat fs_gt.noninfl.tmp1 | grep '+C[CS]' >> conjunctions.lexc
cat fs_gt.noninfl.tmp1 | grep '+Pron' >> pronouns.lexc
cat fs_gt.noninfl.tmp1 | grep '+Interj' >> interjections.lexc
cat fs_gt.noninfl.tmp1 | grep '+Adp' >> adpositions.lexc
cat fs_gt.noninfl.tmp1 | grep '+N+Sg+Gen' >> genitive_attributes.lexc
cat fs_gt.noninfl.tmp1 | grep '+V:' >> noninflecting_verbs.lexc


cat fs_gt.inflecting \
| sed 's/""/\n/g' \
| sed 's/^[^|]*| //g' \
> fs_gt.inflecting.tmp1

cat fs_gt.inflecting.tmp1 | grep '+A:' >> adjectives.lexc
cat fs_gt.inflecting.tmp1 | grep '+A+Comp' >> comparative_adjectives.lexc
cat fs_gt.inflecting.tmp1 | grep '+A+Superl' >> superlative_adjectives.lexc
cat fs_gt.inflecting.tmp1 | grep '+N:' >> nouns.lexc
cat fs_gt.inflecting.tmp1 | grep '+N+Prop' >> propernouns.lexc
cat fs_gt.inflecting.tmp1 | grep '+Num' \
| grep -v '#p.aar ' \
>> numerals.lexc

cat fs_gt.inflecting.tmp1 | grep '+Pron' >> pronouns.lexc
cat fs_gt.inflecting.tmp1 | grep '+V:' >> verbs.lexc

cat pronouns_exceptions.handmade >> pronouns.lexc
cat ara.handmade >> noninflecting_verbs.lexc

echo 'poolteist+Num+Card:p´ool POOLTEIST ;' >> numerals.lexc
