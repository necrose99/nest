# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..8} )

inherit distutils-r1

DESCRIPTION="Utility to check AWS resource limits and usage"
HOMEPAGE="https://github.com/vmware/vcd-cli"
SRC_URI="https://github.com/vmware/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="test" # network-sandbox

RDEPEND=">=dev-python/click-7.0[${PYTHON_USEDEP}]
	dev-python/colorama[${PYTHON_USEDEP}]
	dev-python/keyring[${PYTHON_USEDEP}]
	dev-python/pycryptodome[${PYTHON_USEDEP}]
	>=dev-python/pyvcloud-22.0.0[${PYTHON_USEDEP}]
	dev-python/tabulate[${PYTHON_USEDEP}]
	$(python_gen_impl_dep sqlite)"
DEPEND="${RDEPEND}"
BDEPEND="test? ( dev-python/unittest-xml-reporting[${PYTHON_USEDEP}] )"

python_prepare_all() {
	# pbr is unable to detect version
	echo -e "Name: ${PN}\nVersion: ${PV}" > PKG-INFO \
		|| die "echo failed for PKG-INFO"

	# Relax requirements
	sed -i  -e '/pycryptodome/s/3.4.7,<//' \
		-e '/keyring/s/10.6.0, <= //' requirements.txt \
		|| die "sed failed for requirements.txt"

	distutils-r1_python_prepare_all
}

python_install_all() {
	distutils-r1_python_install_all
	# Don't install license
	find "${ED}" -type f -name "open_source_license_VMware_vCloud_Director_CLI_21.0.0_GA.txt" -exec rm -rv {} + \
		|| die "test removing failed"
}
