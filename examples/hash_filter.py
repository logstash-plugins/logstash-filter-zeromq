#!/usr/bin/env python

# The logstash configuration snippet for this filter is very simple:
#
# filter {
#   zeromq {
#   }
# }

import zmq
import hashlib

ctx = zmq.Context()
socket = ctx.socket(zmq.REP)
socket.bind('tcp://127.0.0.1:2121')

while True:
    event = socket.recv_json()
    event['sha384'] = hashlib.sha384(event['message']).hexdigest()
    socket.send_json(event)
