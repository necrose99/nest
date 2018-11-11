# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_{4..6}} )

inherit distutils-r1

DESCRIPTION="Simple immutable types for python"
HOMEPAGE="https://github.com/tomchristie/itypes"
SRC_URI="https://github.com/tomchristie/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
DEPEND="test? ( dev-python/flake8[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}] )"

python_test() {
	./runtests || die "test failed"
}