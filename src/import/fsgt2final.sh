#!/bin/sh

echo 'LEXICON Adjectives\n' > adjectives.lexc
echo 'LEXICON NoninfectingAdjectives\n' > noninfecting_adjectives.lexc
echo 'LEXICON ComparativeAdjectives\n' > comparative_adjectives.lexc
echo 'LEXICON SuperlativeAdjectives\n' > superlative_adjectives.lexc
echo 'LEXICON Adverbs\n' > adverbs.lexc
echo 'LEXICON Adpositions\n' > adpositions.lexc
echo 'LEXICON Conjunctions\n' > conjunctions.lexc
echo 'LEXICON Nouns\n' > nouns.lexc
echo 'LEXICON ProperNames\n' > proper_names.lexc
echo 'LEXICON Numerals\n' > numerals.lexc
echo 'LEXICON Pronouns\n' > pronouns.lexc
echo 'LEXICON Verbs\n' > verbs.lexc
echo 'LEXICON NoninfectingVerbs\n' > noninfecting_verbs.lexc
echo 'LEXICON Interjections\n' > interjections.lexc
echo 'LEXICON GenitiveAttributes\n' > genitive_attributes.lexc

cat fs_gt.noninfl \
| sed 's/""/\n/g' \
| sed 's/^[^|]*| //g' \
> fs_gt.noninfl.tmp1

cat fs_gt.noninfl.tmp1 | grep '+A:' >> noninfecting_adjectives.lexc
cat fs_gt.noninfl.tmp1 | grep '+Adv' >> adverbs.lexc
cat fs_gt.noninfl.tmp1 | grep '+C[CS]' >> conjunctions.lexc
cat fs_gt.noninfl.tmp1 | grep '+Pron' >> pronouns.lexc
cat fs_gt.noninfl.tmp1 | grep '+Interj' >> interjections.lexc
cat fs_gt.noninfl.tmp1 | grep '+Adp' >> adpositions.lexc
cat fs_gt.noninfl.tmp1 | grep '+N+Sg+Gen' >> genitive_attributes.lexc
cat fs_gt.noninfl.tmp1 | grep '+V:' >> noninfecting_verbs.lexc


cat fs_gt.inflecting \
| sed 's/""/\n/g' \
| sed 's/^[^|]*| //g' \
> fs_gt.inflecting.tmp1

cat fs_gt.inflecting.tmp1 | grep '+A:' >> adjectives.lexc
cat fs_gt.inflecting.tmp1 | grep '+A+Comp' >> comparative_adjectives.lexc
cat fs_gt.inflecting.tmp1 | grep '+A+Superl' >> superlative_adjectives.lexc
cat fs_gt.inflecting.tmp1 | grep '+N:' >> nouns.lexc
cat fs_gt.inflecting.tmp1 | grep '+N+Prop' >> proper_names.lexc
cat fs_gt.inflecting.tmp1 | grep '+Num' >> numerals.lexc
cat fs_gt.inflecting.tmp1 | grep '+Pron' >> pronouns.lexc
cat fs_gt.inflecting.tmp1 | grep '+V:' >> verbs.lexc

cat pronouns_exceptions.handmade >> pronouns.lexc
