# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..8} )
EGIT_REPO_URI="https://github.com/FactoryBoy/${PN}.git"

inherit distutils-r1 git-r3

DESCRIPTION="A fixtures replacement tool"
HOMEPAGE="https://github.com/FactoryBoy/factory_boy"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/faker[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"
BDEPEND="test? ( $(python_gen_impl_dep sqlite)
		dev-python/django[${PYTHON_USEDEP}]
		dev-python/mongoengine[${PYTHON_USEDEP}]
		dev-python/pillow[jpeg,${PYTHON_USEDEP}]
		dev-python/sqlalchemy[${PYTHON_USEDEP}] )"

# Disable tests which require ruinning mongod
PATCHES=( "${FILESDIR}/${PN}"-2.11.1-test.patch )

distutils_enable_tests unittest

python_prepare_all() {
	# Fix symbolic link QA
	rm ChangeLog || die "remove failed"
	cp docs/changelog.rst ChangeLog || die "copy failed"

	distutils-r1_python_prepare_all
}
