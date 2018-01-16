# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

BASE_URI="https://download-cdn.resilio.com/stable/linux-@arch@/${PN}_@arch@.tar.gz"

inherit pax-utils readme.gentoo-r1 systemd tmpfiles user

NAME="rslsync"
QA_PREBUILT="usr/bin/${NAME}"

DESCRIPTION="Resilient, fast and scalable file synchronization tool"
HOMEPAGE="https://getsync.com/"
SRC_URI="amd64? ( ${BASE_URI//@arch@/x64} )
	x86? ( ${BASE_URI//@arch@/i386} )"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS=""
IUSE="pax_kernel"
RESTRICT="mirror"

S="${WORKDIR}"

DOC_CONTENTS="You may need to review /etc/${PN}/config.json\n
Defalt metadata path is /var/lib/${PN}/.sync\n
Default web-gui URL is http://localhost:8888/\n\n
You must be in the ${NAME} group to use Resilio Sync."

pkg_setup() {
	enewgroup ${NAME}
	enewuser ${NAME} -1 -1 /var/lib/${PN} ${NAME}
}

src_install() {
	dobin ${NAME}
	use pax_kernel && pax-mark m "${ED%/}"/usr/bin/${NAME}

	dodir /var/log/${PN}
	keepdir /etc/${PN} /var/lib/${PN}/ /var/lib/${PN}/.sync
	fperms 0700 /etc/${PN} /var/lib/${PN} /var/lib/${PN}/.sync /var/log/${PN}
	fowners -R ${NAME}:${NAME} /etc/${PN} /var/lib/${PN} /var/log/${PN}

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service
	systemd_newuserunit "${FILESDIR}"/${PN}-user.service ${PN}.service
	newtmpfiles "${FILESDIR}"/resilio-sync.tmpfile resilio-sync.conf

	readme.gentoo_create_doc

	# Generate sample config
	"${ED%/}"/usr/bin/${NAME} --dump-sample-config > \
		"${ED%/}"/etc/${PN}/config.json || die "generate config failed"
	fowners ${NAME}:${NAME} /etc/${PN}/config.json
	# Uncomment config directives and change their values
	sed -i \
		-e "/storage_path/s|//| |g" \
		-e "/pid_file/s|//| |g" \
		-e "/storage_path/s|/home/user/.sync|/var/lib/${PN}/.sync|g" \
		-e "/pid_file/s|resilio/resilio|${PN}/${PN}|g" \
		"${ED%/}"/etc/${PN}/config.json || die "sed failed for config.json"
}

pkg_postinst() {
	tmpfiles_process resilio-sync.conf
	readme.gentoo_print_elog
}