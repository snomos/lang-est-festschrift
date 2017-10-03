#!/usr/bin/env perl -w

use utf8;

while (<>) {
#    chomp;
    s/\+Prs\+Ind/+Ind+Prs/g;
    s/\+Prs\+Cond/+Cond+Prs/g;
    s/\+Prs\+Imprt/+Imprt+Prs/g;
    s/\+Prt\+Ind/+Ind+Prt/g;
    s/\+Prt\+Cond/+Cond+Prt/g;
    s/\+Prt\+Imprt/+Imprt+Prt/g;

    print ;
}
