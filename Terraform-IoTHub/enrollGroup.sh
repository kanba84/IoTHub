#!/bin/bash
#az iot dps enrollment-group create --dps-name DPS-Test0329 -g rg-IoTHub --enrollment-id deviceGroup01 --ca-name rootca-test --tags '{"groupId":"deviceGroup01"}'

az iot dps enrollment-group create --dps-name DPS-Test0329 -g rg-IoTHub --enrollment-id deviceGroup02 --ca-name rootca-test --tags '{"groupId":"deviceGroup02"}'