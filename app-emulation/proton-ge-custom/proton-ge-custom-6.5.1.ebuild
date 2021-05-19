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
	dodir ${compatdir}
	into ${compatdir}
	insinto ${compatdir}
	doins -r Proton-${VERSION}
}
