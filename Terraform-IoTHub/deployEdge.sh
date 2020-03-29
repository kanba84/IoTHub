#!/bin/bash

az iot edge deployment create -d deploymentGroup01 -n IoTHub-Test0329 --content manifest01.json \
--target-condition "tags.groupId='deviceGroup01'" --pri 1

az iot edge deployment create -d deploymentGroup02 -n IoTHub-Test0329 --content manifest02.json \
--target-condition "tags.groupId='deviceGroup02'" --pri 2