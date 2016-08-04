# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Tool to manage (PAM) userdb files with crypted passwords"
HOMEPAGE="http://nasauber.de/opensource/${PN}/"
SRC_URI="http://nasauber.de/opensource/${PN}/${PN}-0.1.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/perl[berkdb]
	virtual/perl-DB_File"
RDEPEND="${DEPEND}"

src_install() {
	dobin ${PN}
}