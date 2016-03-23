#!/bin/bash
sudo rmmod hid-apple
sudo modprobe hid-apple
echo 1 | sudo tee /sys/module/hid_apple/parameters/ejectcd_as_delete
echo 2 | sudo tee /sys/module/hid_apple/parameters/fnmode
echo 1 | sudo tee /sys/module/hid_apple/parameters/swap_fn_leftctrl
echo 1 | sudo tee /sys/module/hid_apple/parameters/swap_opt_cmd
