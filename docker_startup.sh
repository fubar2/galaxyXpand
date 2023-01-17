#!/bin/bash

/etc/init.d/postgresql start
/etc/init.d/nginx start
/home/galaxy/galaxy/.venv/bin/galaxyctl reload
