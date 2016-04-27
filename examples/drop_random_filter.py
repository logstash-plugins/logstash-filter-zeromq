#! /usr/bin/env python

# This filter drops old messages at random, perhaps you want a statistical sample
# The configuration snippet for this filter:
# filter {
#   zeromq {
#     sentinel => "$$KILL$$"
#     field => "timestamp"
#   }
# }

import zmq
import random
from datetime import datetime, timedelta
import dateutil.parser
import pytz

SENTINEL = "$$KILL$$"
threshold = timedelta(seconds=30)
c = zmq.Context()
socket = c.socket(zmq.REP)

while True:
    timestamp = socket.recv_string()
    event_time = dateutil.parser.parse(timestamp)
    old = pytz.UTC.localize(datetime.now()) - event_time > threshold
    # drop 10% of messages
    if old && random.random() < 0.1:
        socket.send_string(SENTINEL)
    else:
        socket.send_string(event_time)
