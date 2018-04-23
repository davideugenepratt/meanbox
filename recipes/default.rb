#
# Cookbook:: meanbox
# Recipe:: default
#
# Copyright:: 2017, DavidEugenePratt, All Rights Reserved.

include_recipe('::node')
include_recipe('::mongodb')
include_recipe('::express')
include_recipe('::angular')
