# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
inherit cmake cuda git-r3 distutils-r1

DESCRIPTION="Apache MXNET package"
HOMEPAGE="https://mxnet.apache.org/"
EGIT_REPO_URI="https://github.com/apache/${PN}.git"
EGIT_BRANCH="v1.8.x"

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
	sed -e '/if(USE_MKLDNN)/i list(APPEND mxnet_LINKER_LIBS dnnl)' -i CMakeLists.txt
	git checkout 78e31d6 src/operator/tensor/elemwise_binary_broadcast_op_basic.cc
	rm -r 3rdparty/openmp
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DMXNET_CUDA_ARCH=${TF_CUDA_COMPUTE_CAPABILITIES}
		-DCUDNN_INCLUDE="/opt/cuda/include/"
		-DOPENMP_LIBDIR_SUFFIX=64
		-DUSE_MKLDNN=0
		-DMXNET_USE_MKLDNN=1
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_install() {
	cmake_src_install
	do_install()
	{
		esetup.py install
		python_optimize
	}
	cd ${S}/python
	python_foreach_impl do_install
}

