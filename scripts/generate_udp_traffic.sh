#!/bin/bash

HOST=
TIME=$1

iperf3 -c $HOST -t $TIME -u