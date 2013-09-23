#!/bin/sh
perl -pe 's#xmlns(\:\w+)?="\S*"##g' $*
