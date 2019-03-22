# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_{4..7}} )

inherit distutils-r1

DESCRIPTION="Parameterized testing with any Python test framework"
HOMEPAGE="https://github.com/wolever/parameterized"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}]
		virtual/python-unittest-mock[${PYTHON_USEDEP}] )"

python_prepare_all() {
	# Replace character in test
	sed -i 's/ö/o/g' \
		parameterized/test.py || die "sed failed for test.py"

	distutils-r1_python_prepare_all
}

python_test() {
	nosetests -v || die "tests failed with ${EPYTHON}"
}

python_install_all() {
	distutils-r1_python_install_all
	find "${D}" -name '*test.*' -delete || die "test removing failed"
}