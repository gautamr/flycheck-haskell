EMACS = emacs
EMACSFLAGS =
GHC = ghc
GHCFLAGS = -Wall -Werror -O1
CASK = cask
PKGDIR := $(shell EMACS=$(EMACS) $(CASK) package-directory)

# Export the used EMACS to recipe environments
export EMACS

EL_SRCS = flycheck-haskell.el
EL_OBJS = $(EL_SRCS:.el=.elc)
HS_SRCS = get-cabal-configuration.hs
HS_OBJS = $(HS_SRCS:.hs=)
HELPER_SRCS = helpers/get-source-directories.hs
PACKAGE = flycheck-haskell-$(VERSION).tar

.PHONY: compile dist \
	clean clean-elc clean-dist clean-deps \
	deps

# Build targets
compile : $(EL_OBJS) $(HS_OBJS)

dist :
	$(CASK) package

# Support targets
deps : $(PKGDIR)

# Cleanup targets
clean : clean-elc clean-dist clean-deps

clean-elc :
	rm -rf $(EL_OBJS)

clean-dist :
	rm -rf $(DISTDIR)

clean-deps :
	rm -rf $(PKGDIR)

# File targets
%.elc : %.el $(PKGDIR)
	$(CASK) exec $(EMACS) -Q --batch $(EMACSFLAGS) -f batch-byte-compile $<

%: %.hs
	$(GHC) $(GHCFLAGS) -o $@ $<

$(PKGDIR) : Cask
	$(CASK) install
	touch $(PKGDIR)
