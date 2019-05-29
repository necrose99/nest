# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN/-bin/}"
BASE_URI="https://update.code.visualstudio.com/${PV}/linux-_arch_/stable"

inherit desktop multilib-build pax-utils xdg-utils

DESCRIPTION="Editor for building and debugging modern web and cloud applications"
HOMEPAGE="http://code.visualstudio.com"
SRC_URI="x86? ( ${BASE_URI/_arch_/ia32} -> ${P}-x86.tar.gz )
	amd64? ( ${BASE_URI/_arch_/x64} -> ${P}-amd64.tar.gz )"

LICENSE="MIT"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="gnome-keyring qt5 pax_kernel"
RESTRICT="bindist mirror"

RDEPEND="app-accessibility/at-spi2-atk:2[${MULTILIB_USEDEP}]
	dev-libs/atk:0[${MULTILIB_USEDEP}]
	dev-libs/expat:0[${MULTILIB_USEDEP}]
	dev-libs/glib:2[${MULTILIB_USEDEP}]
	dev-libs/nspr:0[${MULTILIB_USEDEP}]
	dev-libs/nss:0[${MULTILIB_USEDEP}]
	media-libs/alsa-lib:0[${MULTILIB_USEDEP}]
	media-libs/fontconfig:1.0[${MULTILIB_USEDEP}]
	net-print/cups:0[${MULTILIB_USEDEP}]
	sys-apps/dbus:0[${MULTILIB_USEDEP}]
	x11-libs/cairo:0[${MULTILIB_USEDEP}]
	x11-libs/gdk-pixbuf:2[${MULTILIB_USEDEP}]
	x11-libs/gtk+:3[${MULTILIB_USEDEP}]
	x11-libs/libX11:0[${MULTILIB_USEDEP}]
	x11-libs/libxcb:0/1.12[${MULTILIB_USEDEP}]
	x11-libs/libXcomposite:0[${MULTILIB_USEDEP}]
	x11-libs/libXcursor:0[${MULTILIB_USEDEP}]
	x11-libs/libXdamage:0[${MULTILIB_USEDEP}]
	x11-libs/libXext:0[${MULTILIB_USEDEP}]
	x11-libs/libXfixes:0[${MULTILIB_USEDEP}]
	x11-libs/libXi:0[${MULTILIB_USEDEP}]
	x11-libs/libxkbfile:0[${MULTILIB_USEDEP}]
	x11-libs/libXrandr:0[${MULTILIB_USEDEP}]
	x11-libs/libXrender:0[${MULTILIB_USEDEP}]
	x11-libs/libXScrnSaver:0[${MULTILIB_USEDEP}]
	x11-libs/libXtst:0[${MULTILIB_USEDEP}]
	x11-libs/pango:0[${MULTILIB_USEDEP}]
	gnome-keyring? ( app-crypt/libsecret:0[${MULTILIB_USEDEP}] )
	qt5? ( dev-libs/libdbusmenu-qt )"

QA_PREBUILT="opt/visual-studio-code/resources/app/node_modules.asar.unpacked/vscode-ripgrep/bin/rg
	opt/visual-studio-code/code
	opt/visual-studio-code/libnode.so
	opt/visual-studio-code/libffmpeg.so"

pkg_setup() {
	S="${WORKDIR}/VSCode-linux-$(usex amd64 x64 ia32)"
}

src_install() {
	newicon resources/app/resources/linux/code.png visual-studio-code.png
	newicon -s 512 resources/app/resources/linux/code.png visual-studio-code.png
	domenu "${FILESDIR}"/{code,code-url-handler}.desktop

	insinto /opt/visual-studio-code
	doins -r .
	fperms +x /opt/visual-studio-code/{code,bin/code,libnode.so} \
		/opt/visual-studio-code/resources/app/node_modules.asar.unpacked/vscode-ripgrep/bin/rg \
		/opt/visual-studio-code/resources/app/extensions/git/dist/askpass.sh
	dodir /opt/bin
	dosym ../visual-studio-code/bin/code opt/bin/code

	insinto /usr/share/appdata
	doins "${FILESDIR}"/code.appdata.xml

	use pax_kernel && pax-mark -m "${ED}"/opt/visual-studio-code/code
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}