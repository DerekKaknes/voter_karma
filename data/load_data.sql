#!/bin/bash

psql test -U derekkaknes -c "\copy rawvoter FROM 'sample.tsv';"
