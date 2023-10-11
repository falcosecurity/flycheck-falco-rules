# SPDX-License-Identifier: Apache-2.0
#
# Copyright (C) 2023 The Falco Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with
# the License. You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.
#

EMACS = emacs
EMACSFLAGS =
CASK = cask
PKGDIR := $(shell EMACS=$(EMACS) $(CASK) package-directory)

EL_SRCS = flycheck-falco-rules.el
EL_OBJS = $(EL_SRCS:.el=.elc)
PACKAGE = flycheck-falco-rules-$(VERSION).tar

EMACSBATCH = $(EMACS) -Q --batch $(EMACSFLAGS)

.PHONY: compile dist \
	test \
	clean clean-elc clean-dist clean-deps \
	deps

compile : $(EL_OBJS)

dist :
	$(CASK) package

test : $(EL_OBJS)
	$(CASK) exec $(EMACSBATCH) -l flycheck-falco-rules.elc \
		-l test/flycheck-falco-rules-test.el -f ert-run-tests-batch-and-exit

deps : $(PKGDIR)

clean : clean-elc clean-dist clean-deps

clean-elc :
	rm -rf $(EL_OBJS)

clean-dist :
	rm -rf dist/

clean-deps :
	rm -rf $(PKGDIR)

%.elc : %.el $(PKGDIR)
	$(CASK) exec $(EMACSBATCH) -f batch-byte-compile $<

$(PKGDIR) : Cask
	$(CASK) install
	touch $(PKGDIR)
