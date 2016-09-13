#!/bin/sh

# määra muuttüübid
cat fs_lex | ./fs_lex2tyyp.sed > ajutmp

# määra lemmad
# mitmuselised algvormid
cat ajutmp | ./fs_lex2algvorm.sed > algtmp

# käändsõnade omad
cat algtmp | ./fs_lex2lemma.sed > decltmp42

# pöördsõnade omad
cat decltmp42 | ./fs_lex2verblemma.sed > tmp42

# kirjuta mõnedesse lemmadesse sisse leksikaalse tasandi märgid
# ja paranda erandsõnade vead
cat tmp42 | ./lemma2twol.sed \
| sed '/HAARE/s/tT1/tt/' \
| sed 's/ \*\*\([^$:]*:\)/ \1/' \
| sed 's/:\*\*\([^$:]*\)$/:\1/' \
> tmp42twol

# tegemata: 
# $...$ vahel erandvormide arvessevõtmine 
# kahest osast koosnevad sõnad, millel mõlemad osad käänduvad, nt seitsetuhat ?
# 
# sg tantum, nt iga ?
# sõnaliikide teisendamine
# tegusõnad pooleli
#  

exit

# määra gt jätkuleksikoni nimi

cat fs_lex \
| ./fs_lex2tyyp.sed \
\
> fs_lex_gt_tyypidega

cat fs_lex \
| sed 's/!/ !/' \
| sed 's/^\([^|]*\)|\([^ ]*\) [^!]*!\(.*\)$/\2/' \
> fs_alglemma

cat fs_lex \
| sed 's/!/ !/' \
| sed 's/^[^!]*!\(.*\)$/\1/' \
> fs_vormikood

cat fs_alglemma \
| sed 'y/<?]/´`,/' \
> gt_alglemma

cat gt_alglemma \
| sed 's/[´`,]//g' \
> gt_puhaslemma

paste gt_puhaslemma gt_alglemma -d ":" > gt_lemmad

exit

| sed 's/^\([^|]*\)|\([^ ]*\) [^!]*!\(.*\)$/&@\2!\3/' \

