# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Proton Glourious Eggroll"
HOMEPAGE="https://github.com/GloriousEggroll/proton-ge-custom"

MAJOR=$(ver_cut 1)
MINOR=$(ver_cut 2)
GE_VERSION=$(ver_cut 3)
VERSION=${MAJOR}.${MINOR}-GE-${GE_VERSION}
SRC_URI="https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${VERSION}/Proton-${VERSION}.tar.gz"
LICENSE="Apache-2.0"
SLOT="${MAJOR}.${MINOR}"
KEYWORDS="amd64"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}"


src_install()
{
	default
	local compatdir=/usr/share/steam/compatibilitytools.d/

	insinto ${compatdir}
	doins -r Proton-${VERSION}

	exeinto ${compatdir}/Proton-${VERSION}/
	doexe Proton-${VERSION}/proton
	exeinto ${compatdir}/Proton-${VERSION}/dist/bin/
	doexe Proton-${VERSION}/files/bin/wine
	doexe Proton-${VERSION}/files/bin/wine64
	doexe Proton-${VERSION}/files/bin/wine64-preloader
	doexe Proton-${VERSION}/files/bin/wine-preloader
	doexe Proton-${VERSION}/files/bin/wineserver
	doexe Proton-${VERSION}/files/bin/cabextract
	doexe Proton-${VERSION}/files/bin/msidb
	# doexe Proton-${VERSION}/files/bin/msiexec
	# fperms 0755 ${compatdir}/Proton-${VERSION}/proton
	# fperms 0755 ${compatdir}/Proton-${VERSION}/dist/bin/wine
}
