# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake cuda

DESCRIPTION="NVIDIA Accelerated Deep Learning on GPU library"
HOMEPAGE="https://developer.nvidia.com/tensorrt"
SRC_URI="${PN}-7.2.3.4.tar.gz
		 https://github.com/NVIDIA/${PN}/archive/refs/tags/21.04.tar.gz -> ${PN}-${PV}.tar.gz
		 https://github.com/protocolbuffers/protobuf/releases/download/v3.15.8/protobuf-all-3.15.8.tar.gz
		 https://github.com/onnx/onnx-tensorrt/archive/refs/tags/21.03.tar.gz"

LICENSE="NVIDIA-cuDNN"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux"
IUSE=""
REQUIRED_USE=""

DEPEND="|| ( =dev-util/nvidia-cuda-toolkit-11.2* =dev-util/nvidia-cuda-toolkit-11.1* )"
RDEPEND="${DEPEND}"
# CMAKE_REMOVE_MODULES_LIST="FindProtobuf"


src_prepare() {
	cuda_src_prepare
	S="${WORKDIR}/TensorRT-${PV}/"
	rm -r "${S}/parsers/onnx"
	rm -r "${S}/third_party/protobuf"
	mv "${WORKDIR}/onnx-tensorrt-21.03" "${S}/parsers/onnx"
	mv "${WORKDIR}/protobuf-3.15.8" "${S}/third_party/protobuf"
	# sed -e "s/NOT\ TARGET\ onnx_proto/TARGET\ onnx_proto/g" -i "${S}/parsers/onnx/CMakeLists.txt"
	# sed -e "s/NOT\ TARGET\ protobuf/TARGET\ protobuf/g" -i "${S}/parsers/onnx/CMakeLists.txt"
	# sed -e "/caffe/d" -i "${S}/parsers/CMakeLists.txt"
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DTRT_LIB_DIR="${WORKDIR}/TensorRT-7.2.3.4/lib"
		-DTENSORRT_ROOT="${S}"
		-DTENSORRT_BUILD="${BUILD_DIR}"
		-DGPU_ARCHS="${TF_CUDA_COMPUTE_CAPABILITIES}"
		-DBUILD_PLUGINS=ON
		-DBUILD_PARSERS=ON
		-DBUILD_SAMPLES=OFF
		-DBUILD_ONNXIFI=OFF
		-DCUBLASLT_LIB="/opt/cuda/lib64/"
		-DCUBLAS_LIB="/opt/cuda/lib64/"
		-DCUDART_LIB="/opt/cuda/lib64/"
		-DCUDNN_LIB="/opt/cuda/lib64/"
	)

	cmake_src_configure

}

src_install() {
	die
	local pkgdir="${PN}-${PV}"
	exeinto "${EROOT}/bin/"
}

