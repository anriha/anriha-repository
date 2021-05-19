# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
inherit cmake distutils-r1

DESCRIPTION="ONNX"
HOMEPAGE="https://developer.nvidia.com/tensorrt"
SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/v${PV}.tar.gz"

LICENSE="NVIDIA-cuDNN"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux"
IUSE=""
REQUIRED_USE=""

DEPEND="dev-cpp/benchmark dev-python/pybind11 dev-python/pytest-runner"
RDEPEND="${DEPEND}"

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_ONNX_PYTHON=ON
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_install() {
	sed -e "s/lib\/libonnxifi.so/lib64\/libonnxifi.so/g" -i "${BUILD_DIR}/cmake_install.cmake"
	sed -e "s/\/lib\"/\/lib64\"/g" -i "${BUILD_DIR}/cmake_install.cmake"
	cmake_src_install
	do_install()
	{
		cd ${S}
		esetup.py install
		python_optimize
	}
	python_foreach_impl do_install
}
