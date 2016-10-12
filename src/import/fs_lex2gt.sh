#!/bin/sh
# convert the Filosoft lexicon to a nearly-final Giellatekno format
# usage:
#   ./fs_lex2gt.sh
# result:
#    fs_gt.noninfl fs_gt.inflecting fs_lex.unhandled

# i.e. determine continuation lexicon names for inflecting words,
# lexical sides and surface stems for all words,
# POS tags for all words;
#
# keep the date when the word was included in the Filosoft lexicon,
# and if a word belonged to several POS, keep them in the same line

# määra muuttüübid
cat fs_lex | ./fs_lex2tyyp.sed > ajutmp

# määra lemmad
# mitmuselised algvormid
cat ajutmp | ./fs_lex2algvorm.sed \
| sed '/n<eed.MA/s/HOIDMA@SAATMA/HOIDMA/' \
> algtmp

# käändsõnade omad
cat algtmp | ./fs_lex2lemma.sed \
| sed '/ÕIGEVORM$/s/ \([^: ]*\):\([^ ]*\) \([^ ]*ÕIGEVORM\)/ \3 \1:\2/' \
> decltmp1

# pöördsõnade omad
cat decltmp1 | ./fs_lex2verblemma.sed \
| sed '/n<eed.MA/s/n<eedma:n<eeD1 n<eedma:n<eeD1/n<eedma:n<eeD1/' \
> tmp1

# kirjuta mõnedesse lemmadesse sisse leksikaalse tasandi märgid
# ja paranda erandsõnade vead
cat tmp1 | ./lemma2twol.sed \
| sed '/HAARE/s/tT1/tt/' \
| sed 's/ \*\*\([^$:]*:\)/ \1/' \
| sed 's/:\*\*\([^$:]*\)$/:\1/' \
> tmp1twol

# tegemata: 
# $...$ vahel erandvormide arvessevõtmine 
# kahest osast koosnevad sõnad, millel mõlemad osad käänduvad, nt seitsetuhat ?
# 
# sg tantum, nt iga ?
# sõnaliikide teisendamine
#  

# esialgne info tagasi sisse
# 
# create a file that contains everything from Filosoft lexicon 
# and most of what will be in final Giellatekno lexicon
# (it may be useful in future amendments)

paste fs_lex tmp1twol \
| sed 's/\t/""/' | sed 's/|.*""/| /' \
| sed 's/!\\D\\!&&!\\K\\!/!\\DK\\!/' \
| sed 's/!\\K\\!&&!\\D\\!/!\\DK\\!/' \
> fs_lex.gt1

# tsemnW on muuks vajalik info, mitte sõnaliik
# GI võiks sobida jätkuleksikoniks ainult +Adv puhul, aga ka seal mitte igale sõnale...
# oleks vaja vaadata muid sõnu, et otsustada ?

# create the nearly final lexicons
cat fs_lex.gt1 \
| grep '^[^@]* !\\[^\\]*\\!$' \
\
| sed 's/[tsemnW]\\/\\/g' \
| sed 's/[tsemnW]\([ABCDEFGHIJKLMNOPQRSTUVWXYZ]\)\\/\1\\/g' \
| sed 's/[tsemnW]\\/\\/g' \
| sed 's/^\([^!]*!\\\)\([ABCDEFGHIJKLMNOPQRSTUVWXYZ]\)\([ABCDEFGHIJKLMNOPQRSTUVWXYZ]\)\(\\!\)$/\1\2\4""\1\3\4/' \
| ./sliik2gt.sed \
| sed 's/| \([^ ]*\) !\\\(+[^\\]*\)\\!/| \1\2:\1 #;/g' \
| sed 's/\( ...[^ :]*+Adv[^ ]*\) #;/\1 GI ;/' \
| sed 's/\( ...[^ :]*+A:[^ ]*\) #;/\1 GI ;/' \
| sed '/+Interj/s/ GI ;/ #;/g' \
| sed '/+C[SC]/s/ GI ;/ #;/g' \
| ./diacritics.sed \
| sort -k 2 \
> fs_gt.noninfl

cat fs_lex.gt1 \
| grep -v '^[^@]* !\\[^\\]*\\!$' \
| grep '@.*:' \
\
| sed 's/[tsemnW]\\/\\/g' \
| sed 's/[tsemnW]\([ABCDEFGHIJKLMNOPQRSTUVWXYZ]\)\\/\1\\/g' \
| sed 's/[tsemnW]\\/\\/g' \
| sed 's/^\([^!]*!\\\)\([ABCDEFGHIJKLMNOPQRSTUVWXYZ]\)\([ABCDEFGHIJKLMNOPQRSTUVWXYZ]\)\(\\.*\)$/\1\2\4""\1\3\4/' \
| sed 's/$/""/' \
\
| sed '/ÕIGEVORM/s/ \([^ ]*\)\[DÕIGEVORM [^ :]*:/ \1d:/g' \
| sed '/ÕIGEVORM *$/s/ \([^:]*\):\([^ ]*\) \([^ ]*\)\[DÕIGEVORM *$/ \1d:\2/g' \
\
| ./sliik2gt.sed \
| sed 's/| \([^!"]* !\\\)\(+[^\\]*\)\(\\[^@]*@\)\([^ ]*\) \([^:]*\):\([^"]*\)""/| \1\2\3 \5\2:\6 \4 ;""/g' \
| sed 's/""$//' \
| ./diacritics2.sed \
> fs_gt.pre-inflecting

cat fs_gt.pre-inflecting \
| sed 's/| \([^@]*\)@ /| /g' \
| sort -k 2 \
> fs_gt.inflecting

cat fs_lex.gt1 \
| grep -v '^[^@]* !\\[^\\]*\\!$' \
| grep -v '@.*:' \
> fs_lex.unhandled

exit


