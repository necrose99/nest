# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6..8} )
EGIT_REPO_URI="https://github.com/PyMySQL/${PN}.git"

inherit distutils-r1 eutils git-r3

DESCRIPTION="Pure-Python MySQL Driver"
HOMEPAGE="https://github.com/PyMySQL/PyMySQL"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="test"

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

pkg_postinst() {
	optfeature "sha256_password or caching_sha2_password" dev-python/cryptography
}