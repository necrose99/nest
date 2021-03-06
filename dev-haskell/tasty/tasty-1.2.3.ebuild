# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CABAL_FEATURES="lib profile haddock hoogle hscolour"

inherit haskell-cabal

DESCRIPTION="Modern and extensible testing framework"
HOMEPAGE="https://github.com/feuerbach/tasty"
SRC_URI="https://hackage.haskell.org/package/${P}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-haskell/ansi-terminal-0.9:=[profile?]
	>=dev-haskell/async-2.0:=[profile?]
	>=dev-haskell/clock-0.4.4.0:=[profile?]
	>=dev-haskell/mtl-2.1.3.1:=[profile?]
	>=dev-haskell/optparse-applicative-0.14:=[profile?]
	>=dev-haskell/stm-2.3:=[profile?]
	>=dev-haskell/tagged-0.5:=[profile?]
	>=dev-haskell/unbounded-delays-0.1:=[profile?]
	dev-haskell/wcwidth:=[profile?]
	dev-lang/ghc:="
DEPEND="${RDEPEND}"
BDEPEND="dev-haskell/cabal:=[profile?]"

src_configure() {
	haskell-cabal_src_configure --flag=clock
}
