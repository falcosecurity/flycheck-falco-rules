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
