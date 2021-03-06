# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

DESCRIPTION="Git commit message linter"
HOMEPAGE="https://github.com/jorisroovers/gitlint"
SRC_URI="https://github.com/jorisroovers/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="test" #failures

RDEPEND=">=dev-python/arrow-0.14.2[${PYTHON_USEDEP}]
	>=dev-python/click-7.0[${PYTHON_USEDEP}]
	dev-python/sh[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

python_prepare_all() {
	# Relax requirements
	sed -i  -e '/arrow/s/==/>=/' \
		-e '/Click/s/==/>=/' \
		-e '/sh/s/==/>=/' setup.py || die "sed failed for setup.py"

	distutils-r1_python_prepare_all
}

python_test() {
	"${PYTHON}" -m unittest discover -v || die "tests failed with ${EPYTHON}"
}

python_install_all() {
	distutils-r1_python_install_all
	find "${ED}" -type d -name "tests" -exec rm -rv {} + || die "tests removing failed"
	find "${ED}" -type d -name "qa" -exec rm -rv {} + || die "integration tests removing failed"
}
