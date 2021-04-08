# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
inherit cmake cuda git-r3 distutils-r1 python-r1

DESCRIPTION="Apache MXNET package"
HOMEPAGE="https://mxnet.apache.org/"
EGIT_REPO_URI="https://github.com/apache/${PN}.git"
EGIT_COMMIT="${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"
IUSE="cuda"

DEPEND="cuda? ( dev-util/nvidia-cuda-toolkit dev-libs/cudnn )
		virtual/blas
		media-gfx/graphviz
		dev-python/lit
		media-libs/opencv"
RDEPEND="${DEPEND}"
BDEPEND=""

src_prepare() {
	use cuda && cuda_src_prepare
	sed -e "s/libopenblas.a/openblas/g" -i cmake/Modules/FindOpenBLAS.cmake
	sed -e '/dll_path = \[curr_path.*/a \ \ \ \ dll_path.append(\"/usr/lib64/\")' -i python/mxnet/libinfo.py
	filter-flags '-fuse-linker-plugin'
	filter-flags '-flto=*'
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DMXNET_CUDA_ARCH=${TF_CUDA_COMPUTE_CAPABILITIES}
		-DCUDNN_INCLUDE="/opt/cuda/include/"
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_install() {
	cmake_src_install
	cd python
	python_setup
	distutils-r1_python_install
}

