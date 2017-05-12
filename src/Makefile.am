## Process this file with automake to produce Makefile.in
## Copyright: Sámediggi/Divvun/UiT
## Licence: GPL v3+

# always build . last here, and tagsets have to be built after morphology
SUBDIRS = phonology morphology filters phonetics hyphenation orthography syntax transcriptions tagsets .

####### Automake targets: ########

# Define target variables first, before assigning to them:
GT_ANALYSERS=
GT_GENERATORS=

#### Local modifications in *fst processing: ####
####
#### Copy the fallback targets, and rename them to the desired targets. Then:
#### Replace the 'cp' command (Xerox) / Prepend the hfst-invert command (Hfst -
#### remember to move the $<) with whatever you need to complete
#### the processing to get the final target transducer.
#### Remember to add the dependencies as well.
#### Also make sure that HFST and Xerox processing are the same.
####
#### If you add new transducers to be built, you need to add them to the
#### relevant variable, e.g.:
####
#### if CAN_HFST
#### GT_GENERATORS+=generator-oahpa-gt-norm.hfst
#### endif
####
#### NB!!!! The HFST targets should get a hyphen after 'analyser'/'generator'
#### respectively, to make the local targets minimally different from and
#### slightly more specific than the fallback targets. This is to avoid warnings
#### about duplicate targets. That is, the local targets should looke like:
####
#### analyser-%.hfst: analyser-%.tmp.hfst
#### generator-%.hfst: generator-%.tmp.hfst

##################################################################
#### BEGIN: Add local processing instructions BELOW this line ####
##################################################################

########################################################
#### Add language-specific transducer targets here: ####

#### Xerox transducers:
if CAN_XFST
GT_ANALYSERS+=
GT_GENERATORS+=
endif # CAN_XFST

#### HFST transducers
if CAN_HFST
GT_ANALYSERS+=
GT_GENERATORS+=
endif # CAN_HFST

#### FOMA transducers
if CAN_FOMA
GT_ANALYSERS+=
GT_GENERATORS+=
endif # CAN_FOMA

#################################################
#### Add language-specific build rules here: ####

EST_EXTRA_PRE_FILTERS=filters/remove-sg-forms.est filters/remove-pl-forms.est filters/remove-sg-nom-forms.est filters/remove-non-gi-forms.est filters/disallow-derivations.est # filters/remove-usage-tags.est
EST_EXTRA_POST_FILTERS=filters/compound-filter.est filters/modify-derivations.est 
EST_WORDPAIR_FILTERS=filters/wordpair-filter.est

# paired words are words whose both parts inflect, e.g. emb-kumb, kihin-kahin
# paired words: initial part
# HFST:
pair_initial.tmp1.hfst: morphology/pair_initial.tmp.hfst \
					 phonology/$(GTLANG)-phon.compose.hfst
	$(AM_V_INTRSCT)\
		  $(HFST_DETERMINIZE) $(MORE_VERBOSITY) $(HFST_FLAGS) $<\
		| $(HFST_MINIMIZE) $(MORE_VERBOSITY) $(HFST_FLAGS) \
		| $(HFST_COMPOSE_INTERSECT) $(COMPOSE_INTERSECT_FLAG) \
			$(MORE_VERBOSITY) $(HFST_FLAGS) \
			-2 phonology/$(GTLANG)-phon.compose.hfst \
		| $(HFST_MINIMIZE) $(MORE_VERBOSITY) $(HFST_FLAGS) \
		-o $@

# paired words: final part
# HFST:
pair_final.tmp1.hfst: morphology/pair_final.tmp.hfst \
					 phonology/$(GTLANG)-phon.compose.hfst
	$(AM_V_INTRSCT)\
		  $(HFST_DETERMINIZE) $(MORE_VERBOSITY) $(HFST_FLAGS) $<\
		| $(HFST_MINIMIZE) $(MORE_VERBOSITY) $(HFST_FLAGS) \
		| $(HFST_COMPOSE_INTERSECT) $(COMPOSE_INTERSECT_FLAG) \
			$(MORE_VERBOSITY) $(HFST_FLAGS) \
			-2 phonology/$(GTLANG)-phon.compose.hfst \
		| $(HFST_MINIMIZE) $(MORE_VERBOSITY) $(HFST_FLAGS) \
		-o $@ 

# HFST: generator
pair_initial.tmp.%: pair_initial.tmp1.% \
					filters/reorder-tags.$(GTLANG).% \
					filters/reorder-semantic-tags.%       \
					filters/reorder-subpos-tags.%         \
					filters/remove-mwe-tags.%
	$(AM_V_XFST_TOOL)$(PRINTF) "read regex \
			 	@\"filters/reorder-tags.$(GTLANG).$*\"\
			.o. @\"filters/reorder-subpos-tags.$*\"   \
			.o. @\"filters/reorder-semantic-tags.$*\" \
			.o. @\"filters/remove-mwe-tags.$*\"       \
			.o. @\"$<\" \
			;\n\
		 save stack $@\n\
		 quit\n" | $(XFST_TOOL)

# HFST: generator
pair_final.tmp.%: pair_final.tmp1.% \
					filters/reorder-tags.$(GTLANG).% \
					filters/reorder-semantic-tags.%       \
					filters/reorder-subpos-tags.%         \
					filters/remove-mwe-tags.%
	$(AM_V_XFST_TOOL)$(PRINTF) "read regex \
			 	@\"filters/reorder-tags.$(GTLANG).$*\"\
			.o. @\"filters/reorder-subpos-tags.$*\"   \
			.o. @\"filters/reorder-semantic-tags.$*\" \
			.o. @\"filters/remove-mwe-tags.$*\"       \
			.o. @\"$<\" \
			;\n\
		 save stack $@\n\
		 quit\n" | $(XFST_TOOL)

# put parts together
redundant_wordpairs.%: pair_final.tmp.% pair_initial.tmp.%
	$(AM_V_XFST_TOOL)$(PRINTF) 'read regex @\"pair_final.tmp.$*\" .o. ~$$[»] ; \n\
		regex [{#-}:{-}] ; \n\
		concatenate net\n\
		read regex ~$$[\"+Foc/gi\"] .o. @\"pair_initial.tmp.$*\" .o. ~$$[»] ; \n\
		concatenate net\n\
		save stack $@\n\
		quit\n' | $(XFST_TOOL)

# We need to add processing of language-specific tags in the generator for paired words:
# HFST:
generator-wordpairs-raw.aaa.hfst: redundant_wordpairs.hfst $(EST_WORDPAIR_FILTERS:%=%.hfst)
	$(AM_V_RGX2FST)$(PRINTF) "\
			$(EST_WORDPAIR_FILTERS:%=@\"%.hfst\" .o.)    \
			@\"$<\"                                       \
			;" \
		| $(HFST_REGEXP2FST) $(VERBOSITY) $(HFST_FLAGS) -S --xerox-composition=ON \
		> $@

# We need to add processing of language-specific tags in the analyser:
# HFST:

# Xerox:
analyser-raw-gt-%.xfst: analyser-raw-gt-%.tmp.xfst $(EST_EXTRA_PRE_FILTERS:%=%.xfst) $(EST_EXTRA_POST_FILTERS:%=%.xfst)
	$(AM_V_XFST)$(PRINTF) "read regex                         \
			$(EST_EXTRA_PRE_FILTERS:%=@\"%.xfst\" .o.)    \
			@\"$<\"                                       \
			$(EST_EXTRA_POST_FILTERS:%=.o. @\"%.xfst\")   \
			;\n\
		 save stack $@\n\
		 quit\n" | $(XFST) $(VERBOSITY)

# We need to add processing of language-specific tags in the generator:
# HFST:
generator-raw-gt-%.aaa.hfst: generator-raw-gt-%.tmp.hfst $(EST_EXTRA_PRE_FILTERS:%=%.hfst) $(EST_EXTRA_POST_FILTERS:%=%.hfst)
	$(AM_V_RGX2FST)$(PRINTF) "\
			$(EST_EXTRA_PRE_FILTERS:%=@\"%.hfst\" .o.)    \
			@\"$<\"                                       \
			$(EST_EXTRA_POST_FILTERS:%=.o. @\"%.hfst\")   \
			;" \
		| $(HFST_REGEXP2FST) $(VERBOSITY) $(HFST_FLAGS) -S --xerox-composition=ON \
		> $@

# include paired words in the raw generator
# HFST:
generator-raw-gt-%.hfst: generator-raw-gt-%.aaa.hfst \
					generator-wordpairs-raw.aaa.hfst 
	hfst-union -1 $< -2 generator-wordpairs-raw.aaa.hfst -o $@

# ... also the raw analyser
# HFST:
analyser-raw-gt-%.hfst: generator-raw-gt-%.hfst
		$(HFST_INVERT) $(VERBOSITY) $(HFST_FLAGS) < $< > $@

##################################################################
#### END: Add local processing instructions ABOVE this line ######
##################################################################

include $(top_srcdir)/am-shared/src-dir-include.am
