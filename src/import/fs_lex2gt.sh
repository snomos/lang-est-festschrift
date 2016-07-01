#!/bin/sh

# määra muuttüübid
cat fs_lex | ./fs_lex2tyyp.sed > ajutmp

# määra lemmad
cat ajutmp | ./fs_lex2lemma.sed > tmp26

# kirjuta mõnedesse lemmadesse sisse leksikaalse tasandi märgid
cat tmp26 | ./lemma2twol.sed > tmp26twol

# tegemata: apostroofi märgi teisendamine
# sõnaliikide teisendamine
# tegusõnad kogu täiega
# vigu on veel ka, nt puhas:puhta (peaks olema :puhT2a vist) 

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

