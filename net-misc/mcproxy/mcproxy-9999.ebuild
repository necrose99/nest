# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 qmake-utils

DESCRIPTION="IGMP/MLD Proxy daemon"
HOMEPAGE="https://mcproxy.realmv6.org/ https://github.com/mcproxy/mcproxy"
SRC_URI=""
EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="dev-qt/qtcore:5"

src_prepare() {
	default

	# Modify install path
	sed -i "/target.path/s|/usr/local|${ED%/}/usr|" ${PN}/${PN}.pro \
		|| die "sed failed to modify install path for ${PN}.pro"
}

src_configure() {
	cd ${PN} || die "failed to change directory to ${PN}"
	eqmake5 CONFIG+=$(usev debug) ${PN}.pro
}

src_compile() {
	cd ${PN} || die "failed to change directory to ${PN}"
	emake
}

src_install() {
	einstalldocs

	cd ${PN} || die "failed to change directory to ${PN}"
	emake DESTDIR="${D}" install
}
