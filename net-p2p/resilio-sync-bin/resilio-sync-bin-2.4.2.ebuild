# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MY_PN="${PN/-bin/}"
BASE_URI="http://linux-packages.resilio.com/${MY_PN}/deb/pool/non-free/r/${MY_PN}/${MY_PN}_${PV}-1_-arch-.deb"

inherit pax-utils systemd unpacker user

NAME="rslsync"
QA_PREBUILT="usr/bin/${NAME}"

DESCRIPTION="Resilient, fast and scalable file synchronization tool"
HOMEPAGE="https://getsync.com/"
SRC_URI="amd64? ( ${BASE_URI/-arch-/amd64} )
	arm? ( ${BASE_URI/-arch-/armhf} )
	x86? ( ${BASE_URI/-arch-/i386} )"
LICENSE="BitTorrent no-source-code"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="pax_kernel systemd"

RESTRICT="mirror"
S="${WORKDIR}"

pkg_setup() {
	enewgroup ${NAME}
	enewuser ${NAME} -1 -1 /var/lib/${MY_PN} ${NAME}
}

src_install() {
	dobin "${S}"/usr/bin/${NAME}
	use pax_kernel && pax-mark m "${ED%/}}"/usr/bin/${NAME}

	doman "${S}"/usr/share/man/man1/${MY_PN}.1.gz

	dodir /var/log/${MY_PN}

	keepdir /etc/${MY_PN} /var/lib/${MY_PN}/ /var/lib/${MY_PN}/.sync
	fperms 0700 /etc/${MY_PN} /var/lib/${MY_PN} /var/lib/${MY_PN}/.sync \
		/var/log/${MY_PN}
	fowners -R ${NAME}:${NAME} /etc/${MY_PN} /var/lib/${MY_PN} \
		/var/log/${MY_PN}

	use systemd || newinitd "${FILESDIR}"/${MY_PN}.initd ${MY_PN}
	use systemd || newconfd "${FILESDIR}"/${MY_PN}.confd ${MY_PN}
	use systemd && systemd_dounit "${S}"/lib/systemd/system/${MY_PN}.service
	use systemd && systemd_douserunit "${S}"/usr/lib/systemd/user/${MY_PN}.service
}

pkg_preinst() {
	# Generate sample config
	"${ED%/}"/usr/bin/${NAME} --dump-sample-config > \
		"${ED%/}"/etc/${MY_PN}/config.json || die "generate config failed"
	fowners ${NAME}:${NAME} /etc/${MY_PN}/config.json
	# Uncomment config directives and change their values
	sed -i \
		-e "/storage_path/s|//| |g" \
		-e "/pid_file/s|//| |g" \
		-e "/storage_path/s|/home/user/.sync|/var/lib/${MY_PN}/.sync|g" \
		-e "/pid_file/s|btsync/btsync|${MY_PN}/${MY_PN}|g" \
		"${ED%/}"/etc/${MY_PN}/config.json || die "sed for pkg_preinst failed"
}

pkg_postinst() {
	elog "You may need to review /etc/${MY_PN}/config.json"
	elog "Defalt metadata path is /var/lib/${MY_PN}/.sync"
	elog "Default web-gui URL is http://localhost:8888/"
	elog ""
	elog "You must be in the ${NAME} group to use Resilio Sync."
}
