#!/bin/bash


# clone model-training repo
git clone git@github.com:remla24-team-1/model-training.git ../model-training

docker-compose build 
docker-compose up

