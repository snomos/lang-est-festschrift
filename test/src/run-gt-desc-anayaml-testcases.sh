#!/bin/bash

# This is a shell script that will call the actual test runner with the
# specified transducer. This determines also the set of yaml test files looped
# over by the test runner.

###### User variables - adjust as needed: #######
# Specify the invariable part of the transducer name:
transducer=gt-desc

# Specify whether the test runner should test only generation, analysis or both:
# gen = generation test
# ana = analysis test
# full / both / "" (ie nothing) = test both directions
halftest=ana

# Specify the name of the subdir where the yaml files are, use '.' if it is the
# same dir as this script:
yaml_file_subdir=gt-desc-yamls

####### Include helper script from GTCORE: ########
giella_core=/home/hkaalep/giellatekno/core
source ${giella_core}/scripts/include-scripts/yaml-runner-include.sh