# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_REPO_URI="https://github.com/LubosD/${PN}.git"

inherit cmake git-r3 xdg

DESCRIPTION="Softphone for voice over IP and IM communication using SIP"
HOMEPAGE="https://github.com/LubosD/twinkle"
SRC_URI=""

LICENSE="GPL-2"
KEYWORDS=""
SLOT="0"
IUSE="alsa g729 gsm ilbc speex zrtp"

RDEPEND="dev-cpp/commoncpp2
	dev-libs/ccrtp
	dev-libs/libxml2:2
	dev-libs/ucommon
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtquickcontrols2:5
	dev-qt/qtwidgets:5
	media-libs/libsndfile
	sys-libs/readline:=
	g729? ( media-libs/bcg729 )
	gsm? ( media-sound/gsm )
	ilbc? ( dev-libs/ilbc-rfc3951 )
	speex? ( media-libs/speex
		media-libs/speexdsp )
	zrtp? ( dev-libs/zrtpcpp )"
DEPEND="${RDEPEND}"
BDEPEND="dev-qt/linguist-tools:5
	sys-devel/bison
	sys-devel/flex"

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DWITH_ALSA="$(usex alsa)"
		-DWITH_G729="$(usex g729)"
		-DWITH_GSM="$(usex gsm)"
		-DWITH_ILBC="$(usex ilbc)"
		-DWITH_SPEEX="$(usex speex)"
		-DWITH_ZRTP="$(usex zrtp)"
	)
	cmake_src_configure
}
