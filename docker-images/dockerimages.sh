#!/bin/bash

docker build --tag="jmeter-base:latest" -f Dockerfile-base .
docker build --tag="jmeter-master:latest" -f Dockerfile-master .
docker build --tag="jmeter-slave:latest" -f Dockerfile-slave .

