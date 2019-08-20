# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_PN="github.com/99designs/${PN}"

inherit bash-completion-r1 golang-build golang-vcs-snapshot

DESCRIPTION="A vault for securely storing and accessing AWS credentials"
HOMEPAGE="https://github.com/99designs/aws-vault"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bash-completion zsh-completion"

DEPEND="dev-go/go-crypto:=
	dev-go/go-sys:="
RDEPEND="${DEPEND}
	bash-completion? ( app-shells/bash-completion )
	zsh-completion? ( app-shells/zsh-completions )"

DOCS=( src/"${EGO_PN}"/README.md src/"${EGO_PN}"/USAGE.md )

src_prepare() {
	default

	# Remove bundled libs to use provided by portage
	rm -rf src/"${EGO_PN}"/vendor/golang.org/x/{crypto,sys} \
		|| die "failed to remove crypto or sys"
}

src_test() {
	GOPATH="${S}:/usr/lib/go-gentoo" go test -v -work -x ./... \
		|| die "tests failed"
}

src_install() {
	einstalldocs
	dobin aws-vault

	use bash-completion && dobashcomp src/"${EGO_PN}"/completions/bash/aws-vault
	if use zsh-completion ; then
		insinto /usr/share/zsh/site-functions
		doins src/"${EGO_PN}"/completions/zsh/_aws-vault
	fi
}
