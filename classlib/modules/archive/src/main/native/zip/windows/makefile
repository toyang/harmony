# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#
# Makefile for module 'zip'
#

HY_BIN=$(HY_TARGET)\build\classlib\archive\native\zip\# trailing slash
!include <$(HY_TARGET)\hdk\build\make\defines.mak>

LIBBASE=hyzip
LIBNAME=$(LIBPATH)$(LIBBASE).lib
BUILDFILES = $(HY_BIN)zcpool.obj $(HY_BIN)zipalloc.obj \
	$(HY_BIN)zipcache.obj $(HY_BIN)zipsup.obj \
        $(LIBPATH)hypool$(HY_LINKLIB_SUFFIX)
ZLIB_DIST = $(HY_TARGET)\depends\native\zlib_dist\# trailing slash
HYCFLAGS = $(HYCFLAGS) /I$(ZLIB_DIST)

!include <$(HY_HDK)\build\make\rules.mak>
