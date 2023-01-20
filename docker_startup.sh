#!/bin/bash
 /etc/init.d/postgresql start && \
source /home/galaxy/galaxy/.venv/bin/activate && \
/home/galaxy/galaxy/.venv/bin/galaxyctl start && \
/etc/init.d/nginx start && \
while true; do sleep 1; done
