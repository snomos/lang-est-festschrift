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
GT_ANALYSERS+=analyser-gt-desc.xfst \
			  analyser-gt-norm.xfst \
			  analyser-disamb-gt-desc.xfst
GT_GENERATORS+=generator-gt-desc.xfst \
			   generator-gt-norm.xfst
endif # CAN_XFST

#### HFST transducers
if CAN_HFST
GT_ANALYSERS+=analyser-gt-desc.hfst \
			  analyser-gt-norm.hfst \
			  analyser-disamb-gt-desc.hfst
GT_GENERATORS+=generator-gt-desc.hfst \
			   generator-gt-norm.hfst
endif # CAN_HFST

#### FOMA transducers
if CAN_FOMA
GT_ANALYSERS+=
GT_GENERATORS+=
endif # CAN_FOMA

#################################################
#### Add language-specific build rules here: ####

EST_EXTRA_PRE_FILTERS=filters/remove-sg-forms.est filters/remove-pl-forms.est filters/remove-sg-nom-forms.est filters/remove-non-gi-forms.est filters/block-derivations.est # filters/remove-usage-tags.est
EST_EXTRA_POST_FILTERS=filters/modify-derivations.est # filters/downcase-derived_proper-strings.est
EST_WORDPAIR_FILTERS=filters/reorder-tags.est filters/wordpair-filter.est
EST_NUMERAL_FILTERS=filters/reorder-tags.est filters/numeral-filter.est
#EST_COMPOUND_PRE_FILTERS=filters/block-compounds.est
#EST_COMPOUND_POST_FILTERS=filters/compound-filter.est

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

# XEROX
pair_initial.tmp1.xfst: morphology/pair_initial.tmp.xfst \
			 phonology/$(GTLANG)-phon.compose.xfst
	$(AM_V_LEXC)$(PRINTF) \
		"read-source morphology/pair_initial.tmp.xfst\nread-rules phonology/$(GTLANG)-phon.compose.xfst\ncompose-result\nsave-result $@\nquit\n" \
		| $(LEXC) $(VERBOSITY)

# compound numerals where both parts inflect, e.g. viis#sada, viie#saja
# compound numerals: initial part
# HFST:
num_initial.tmp1.hfst: morphology/num_initial.tmp.hfst \
					 phonology/$(GTLANG)-phon.compose.hfst
	$(AM_V_INTRSCT)\
		  $(HFST_DETERMINIZE) $(MORE_VERBOSITY) $(HFST_FLAGS) $<\
		| $(HFST_MINIMIZE) $(MORE_VERBOSITY) $(HFST_FLAGS) \
		| $(HFST_COMPOSE_INTERSECT) $(COMPOSE_INTERSECT_FLAG) \
			$(MORE_VERBOSITY) $(HFST_FLAGS) \
			-2 phonology/$(GTLANG)-phon.compose.hfst \
		| $(HFST_MINIMIZE) $(MORE_VERBOSITY) $(HFST_FLAGS) \
		-o $@

# XEROX
num_initial.tmp1.xfst: morphology/num_initial.tmp.xfst \
			 phonology/$(GTLANG)-phon.compose.xfst
	$(AM_V_LEXC)$(PRINTF) \
		"read-source morphology/num_initial.tmp.xfst\nread-rules phonology/$(GTLANG)-phon.compose.xfst\ncompose-result\nsave-result $@\nquit\n" \
		| $(LEXC) $(VERBOSITY)


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

# XEROX
pair_final.tmp1.xfst: morphology/pair_final.tmp.xfst \
			 phonology/$(GTLANG)-phon.compose.xfst
	$(AM_V_LEXC)$(PRINTF) \
		"read-source morphology/pair_final.tmp.xfst\nread-rules phonology/$(GTLANG)-phon.compose.xfst\ncompose-result\nsave-result $@\nquit\n" \
		| $(LEXC) $(VERBOSITY)

# compound numerals: final part
# HFST:
num_final.tmp1.hfst: morphology/num_final.tmp.hfst \
					 phonology/$(GTLANG)-phon.compose.hfst
	$(AM_V_INTRSCT)\
		  $(HFST_DETERMINIZE) $(MORE_VERBOSITY) $(HFST_FLAGS) $<\
		| $(HFST_MINIMIZE) $(MORE_VERBOSITY) $(HFST_FLAGS) \
		| $(HFST_COMPOSE_INTERSECT) $(COMPOSE_INTERSECT_FLAG) \
			$(MORE_VERBOSITY) $(HFST_FLAGS) \
			-2 phonology/$(GTLANG)-phon.compose.hfst \
		| $(HFST_MINIMIZE) $(MORE_VERBOSITY) $(HFST_FLAGS) \
		-o $@ 

# XEROX
num_final.tmp1.xfst: morphology/num_final.tmp.xfst \
			 phonology/$(GTLANG)-phon.compose.xfst
	$(AM_V_LEXC)$(PRINTF) \
		"read-source morphology/num_final.tmp.xfst\nread-rules phonology/$(GTLANG)-phon.compose.xfst\ncompose-result\nsave-result $@\nquit\n" \
		| $(LEXC) $(VERBOSITY)

# FOMA
# not implemented...

# HFST: generator 
# Xerox & FOMA: analyser
# (with a language-specific tag reordering script applied)
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

num_initial.tmp.%: num_initial.tmp1.% \
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
# Xerox & FOMA: analyser
# (with a language-specific tag reordering script applied)
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

num_final.tmp.%: num_final.tmp1.% \
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
# Xerox & FOMA: analyser
#

redundant_wordpairs.%: pair_final.tmp.% pair_initial.tmp.%
	$(AM_V_XFST_TOOL)$(PRINTF) "read regex [ [~[?* \"+Foc/gi\" ?*] .o. @\"pair_initial.tmp.$*\"] (\"-\") @\"pair_final.tmp.$*\"] .o. ~[?* » ?*] ; \nsave stack $@\nquit\n" | $(XFST_TOOL)

redundant_numerals.%: num_final.tmp.% num_initial.tmp.%
	$(AM_V_XFST_TOOL)$(PRINTF) "read regex [ [~[?* \"+Foc/gi\" ?*] .o. @\"num_initial.tmp.$*\"] @\"num_final.tmp.$*\"] .o. ~[?* » ?*] ; \nsave stack $@\nquit\n" | $(XFST_TOOL)

# We need to add processing of language-specific tags in the generator for paired words:
# HFST:
generator-wordpairs-raw.simple.hfst: redundant_wordpairs.hfst \
					$(EST_WORDPAIR_FILTERS:%=%.hfst)
	$(AM_V_XFST)$(PRINTF) "set flag-is-epsilon ON\n\
			read regex                         \
			$(EST_WORDPAIR_FILTERS:%=@\"%.hfst\" .o.)    \
			@\"$<\"                                       \
			;\n\
		 save stack $@\n\
		 quit\n" | $(XFST_TOOL)

generator-numerals-raw.simple.hfst: redundant_numerals.hfst \
					$(EST_NUMERAL_FILTERS:%=%.hfst)
	$(AM_V_XFST)$(PRINTF) "set flag-is-epsilon ON\n\
			read regex                         \
			$(EST_NUMERAL_FILTERS:%=@\"%.hfst\" .o.)    \
			@\"$<\"                                       \
			;\n\
		 save stack $@\n\
		 quit\n" | $(XFST_TOOL)

# XEROX:
analyser-wordpairs-raw.simple.xfst: redundant_wordpairs.xfst \
					$(EST_WORDPAIR_FILTERS:%=%.xfst)
	$(AM_V_XFST)$(PRINTF) "set flag-is-epsilon ON\n\
			read regex                         \
			$(EST_WORDPAIR_FILTERS:%=@\"%.xfst\" .o.)    \
			@\"$<\"                                       \
			;\n\
		 save stack $@\n\
		 quit\n" | $(XFST) $(VERBOSITY)

analyser-numerals-raw.simple.xfst: redundant_numerals.xfst \
					$(EST_NUMERAL_FILTERS:%=%.xfst)
	$(AM_V_XFST)$(PRINTF) "set flag-is-epsilon ON\n\
			read regex                         \
			$(EST_NUMERAL_FILTERS:%=@\"%.xfst\" .o.)    \
			@\"$<\"                                       \
			;\n\
		 save stack $@\n\
		 quit\n" | $(XFST) $(VERBOSITY)

# We need to add processing of language-specific tags in the analyser:
# XEROX:
analyser-raw-gt-desc.simple.xfst: analyser-raw-gt-desc.tmp.xfst \
				analyser-numerals-raw.simple.xfst \
				$(EST_EXTRA_PRE_FILTERS:%=%.xfst) \
				$(EST_EXTRA_POST_FILTERS:%=%.xfst) \
				filters/downcase-derived_proper-strings.est.xfst
	$(AM_V_XFST)$(PRINTF) "set flag-is-epsilon ON\n\
			read regex                         \
			$(EST_EXTRA_PRE_FILTERS:%=@\"%.xfst\" .o.)    \
			[ @\"$<\" | @\"analyser-numerals-raw.simple.xfst\" ]  \
			$(EST_EXTRA_POST_FILTERS:%=.o. @\"%.xfst\")   \
			;\n\
			define fst \n\
			set flag-is-epsilon OFF\n\
			read regex fst \
			.o. @\"filters/downcase-derived_proper-strings.est.xfst\"       \
			;\n\
		 save stack $@\n\
		 quit\n" | $(XFST) $(VERBOSITY)

# We need to add processing of language-specific tags in the generator:
# HFST:
generator-raw-gt-desc.simple.hfst: generator-raw-gt-desc.tmp.hfst \
				generator-numerals-raw.simple.hfst \
				$(EST_EXTRA_PRE_FILTERS:%=%.hfst) \
				$(EST_EXTRA_POST_FILTERS:%=%.hfst) \
				filters/downcase-derived_proper-strings.est.hfst
	$(AM_V_XFST)$(PRINTF) "set flag-is-epsilon ON\n\
			read regex                         \
			$(EST_EXTRA_PRE_FILTERS:%=@\"%.hfst\" .o.)    \
			[ @\"$<\" | @\"generator-numerals-raw.simple.hfst\" ] \
			$(EST_EXTRA_POST_FILTERS:%=.o. @\"%.hfst\")   \
			;\n\
			define fst \n\
			set flag-is-epsilon OFF\n\
			read regex fst \
			.o. @\"filters/downcase-derived_proper-strings.est.hfst\"       \
			;\n\
		 save stack $@\n\
		 quit\n" | $(XFST_TOOL)


# HFST:
# compound words: 
# the first part cannot be a form with a focus particle, so filter it out
# the first part may end with a hyphen (ajaloolis-)
generator-raw-gt-desc.comp.hfst: generator-raw-gt-desc.simple.hfst \
				filters/evaluate-flags.est.hfst
	$(AM_V_XFST)$(PRINTF) "read regex \
			[                                                                    \
			  [                                                                  \
			    [                                                                \
			      ~[?* \"+Foc/gi\" ?*] .o. @\"$<\" .o. [ \"-\" (->) 0 || _ .#. ] \
			    ] \"#\"                                                          \
			  ]*                                                                 \
			 @\"$<\"                                                             \
			] @\"filters/evaluate-flags.est.hfst\"                               \
			;\n\
		save stack $@\n\
		quit\n" | $(XFST_TOOL)

# XFST:
# compound words: 
# the first part cannot be a form with a focus particle, so filter it out
# the first part may end with a hyphen (ajaloolis-)
analyser-raw-gt-desc.comp.xfst: analyser-raw-gt-desc.simple.xfst \
				filters/evaluate-flags.est.xfst
	$(AM_V_XFST)$(PRINTF) "read regex \
			[                                                                    \
			  [                                                                  \
			    [                                                                \
			      ~[?* \"+Foc/gi\" ?*] .o. @\"$<\" .o. [ \"-\" (->) 0 || _ .#. ] \
			    ] \"#\"                                                          \
			  ]*                                                                 \
			 @\"$<\"                                                             \
			] @\"filters/evaluate-flags.est.xfst\"                               \
			;\n\
		save stack $@\n\
		quit\n" | $(XFST) $(VERBOSITY)

# the vocabulary, i.e. words that might be combined with - / or otherwise
# include paired words and compounds in the raw generator
# HFST:
generator-raw-gt-desc.vocabulary.hfst: generator-raw-gt-desc.comp.hfst \
					generator-wordpairs-raw.simple.hfst 
	$(AM_V_XFST)$(PRINTF) "read regex @\"$<\" ; \nread regex @\"generator-wordpairs-raw.simple.hfst\" ; \nunion net\nsave stack $@\nquit\n" | $(XFST_TOOL)

# XEROX:
analyser-raw-gt-desc.vocabulary.xfst: analyser-raw-gt-desc.comp.xfst \
					analyser-wordpairs-raw.simple.xfst 					
	$(AM_V_XFST)$(PRINTF) "read regex @\"$<\" ; \nread regex @\"analyser-wordpairs-raw.simple.xfst\" ; \nunion net\nsave stack $@\nquit\n" | $(XFST) $(VERBOSITY)

# make the raw ones
# HFST:
generator-raw-gt-desc.hfst: generator-raw-gt-desc.vocabulary.hfst 
		cp $< $@

# ... also the raw analyser
analyser-raw-gt-%.hfst: generator-raw-gt-%.hfst
		$(HFST_INVERT) $(VERBOSITY) $(HFST_FLAGS) < $< > $@

# XEROX:
analyser-raw-gt-desc.xfst: analyser-raw-gt-desc.vocabulary.xfst 
		cp $< $@


# final transducers that allow concatenating by - and / and
# include punctuation 
# the generator and analyser differ in uppercasing, hence the need to build them separately

# HFST:
# note the invert net for analyser
analyser-gt-%.hfst: analyser-gt-%.tmp.hfst \
					filters/initialise-flags.est.hfst \
					morphology/punctuation.tmp.hfst
	$(AM_V_XFST)$(PRINTF) "read regex \
			[                                                               \
			 [ @\"$<\" .o. [ \"-\" -> 0 || _ .#. ] ]                        \
			 [ \"-\" | \"/\"] @\"filters/initialise-flags.est.hfst\"  \
			]*                                                              \
			@\"$<\" (\"-\")                                                 \
			;\n\
		read regex @\"morphology/punctuation.tmp.hfst\"                         \
			;\n\
		union net\n\
		invert net\n\
		save stack $@\n\
		quit\n" | $(XFST_TOOL)

generator-gt-%.hfst: generator-gt-%.tmp.hfst \
					filters/initialise-flags.est.hfst \
					morphology/punctuation.tmp.hfst
	$(AM_V_XFST)$(PRINTF) "read regex \
			[                                                               \
			 [ @\"$<\" .o. [ \"-\" -> 0 || _ .#. ] ]                        \
			 [ \"-\" | \"/\"] @\"filters/initialise-flags.est.hfst\"  \
			]*                                                              \
			@\"$<\" (\"-\")                                                 \
			;\n\
		read regex @\"morphology/punctuation.tmp.hfst\"                         \
			;\n\
		union net\n\
		save stack $@\n\
		quit\n" | $(XFST_TOOL)

# XEROX:
# note the invert net for generator
analyser-gt-%.xfst: analyser-gt-%.tmp.xfst \
					filters/initialise-flags.est.xfst \
					morphology/punctuation.tmp.xfst
	$(AM_V_XFST)$(PRINTF) "read regex \
			[                                                               \
			 [ @\"$<\" .o. [ \"-\" -> 0 || _ .#. ] ]                        \
			 [ \"-\" | \"/\"] @\"filters/initialise-flags.est.xfst\"  \
			]*                                                              \
			@\"$<\" (\"-\")                                                 \
			;\n\
		read regex @\"morphology/punctuation.tmp.xfst\"                         \
			;\n\
		union net\n\
		save stack $@\n\
		quit\n" | $(XFST) $(VERBOSITY)

generator-gt-%.xfst: generator-gt-%.tmp.xfst \
					filters/initialise-flags.est.xfst \
					morphology/punctuation.tmp.xfst
	$(AM_V_XFST)$(PRINTF) "read regex \
			[                                                               \
			 [ @\"$<\" .o. [ \"-\" -> 0 || _ .#. ] ]                        \
			 [ \"-\" | \"/\"] @\"filters/initialise-flags.est.xfst\"  \
			]*                                                              \
			@\"$<\" (\"-\")                                                 \
			;\n\
		read regex @\"morphology/punctuation.tmp.xfst\"                         \
			;\n\
		union net\n\
		invert net\n\
		save stack $@\n\
		quit\n" | $(XFST) $(VERBOSITY)

##################################################################
#### END: Add local processing instructions ABOVE this line ######
##################################################################

include $(top_srcdir)/am-shared/src-dir-include.am
