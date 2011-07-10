#!/bin/sh
cd `dirname $0`
erl -pa $PWD/ebin $PWD/deps/*/ebin -boot start_sasl -s reloader -s dial_a_stranger -noshell -detached -eval 'error_logger:logfile({open, "priv/log/all"}).'
