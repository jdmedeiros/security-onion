#!/bin/bash -x
if [ "$1" = "run" ]; then
  echo ${userid}:${userpw} | sudo chpasswd
fi