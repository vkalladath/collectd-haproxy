#!/bin/bash
pep8 --max-line-length=120 haproxy.py
if [ "$?" -ne 0 ]; then
    exit 1;
fi
py.test test_haproxy.py
