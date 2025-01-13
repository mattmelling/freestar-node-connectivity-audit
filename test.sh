#!/usr/bin/env bash

NODE=$1
LOCAL=596202
ASTERISK="sudo asterisk -rx"

$ASTERISK "rpt fun $LOCAL *3$NODE"
sleep 5
RESULT=$($ASTERISK "rpt nodes $LOCAL" | grep -E "T$NODE[, ]" | wc -l)
sleep 5
$ASTERISK "rpt fun $LOCAL *1$NODE"

echo $NODE,$RESULT


