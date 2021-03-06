# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"

inherit haskell-cabal

DESCRIPTION="Haskell 98 compatible comonads"
HOMEPAGE="https://github.com/ekmett/comonad"
SRC_URI="https://hackage.haskell.org/package/${P}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="+containers +distributive +test-doctests"

RDEPEND=">=dev-haskell/semigroups-0.16.2:=[profile?]
	>=dev-haskell/tagged-0.7:=[profile?]
	>=dev-haskell/transformers-compat-0.3:=[profile?]
	dev-lang/ghc:=
	distributive? ( dev-haskell/distributive:=[profile?] )"
DEPEND="${RDEPEND}"
BDEPEND="dev-haskell/cabal:=[profile?]
	dev-haskell/cabal-doctest:=[profile?]
	test? ( test-doctests? ( >=dev-haskell/doctest-0.11.1:=[profile?] ) )"

src_configure() {
	haskell-cabal_src_configure \
		"$(cabal_flag containers containers)" \
		"$(cabal_flag distributive distributive)" \
		"$(cabal_flag test-doctests test-doctests)"
}
