EAPI=7
inherit go-module udev

EGO_SUM=(
	"github.com/caarlos0/spin v1.1.0 h1:EjsfGbZJejib25BPnDqf7iL2z9RUna7refvUf+AN9UE="
	"github.com/caarlos0/spin v1.1.0/go.mod h1:HOC4pUvfhjXR2yDt+sEY9dRc2m4CCaK5z5oQYAbzXSA="
	"github.com/google/gousb v1.1.0 h1:s/970WE1z968MC+dtWbuxDHCcx9kwANQo6UcZtfTfx0="
	"github.com/google/gousb v2.1.0+incompatible h1:ApzMDjF3FeO219QwWybJxYfFhXQzPLOEy0o+w9k5DNI="
	"github.com/google/gousb v2.1.0+incompatible/go.mod h1:Tl4HdAs1ThE3gECkNwz+1MWicX6FXddhJEw7L8jRDiI="
	"github.com/logrusorgru/aurora v2.0.3+incompatible h1:tOpm7WcpBTn4fjmVfgpQq0EfczGlG91VSDkswnjF5A8="
	"github.com/logrusorgru/aurora v2.0.3+incompatible/go.mod h1:7rIyQOR62GCctdiQpZ/zOJlFyk6y+94wXzv6RNZgaR4="
	"github.com/marcinbor85/gohex v0.0.0-20200531163658-baab2527a9a2 h1:n7R8fUwWZUB2XtyzBNsYNNm9/XgOBj6pvLi7GLMCHtM="
	"github.com/marcinbor85/gohex v0.0.0-20200531163658-baab2527a9a2/go.mod h1:Pb6XcsXyropB9LNHhnqaknG/vEwYztLkQzVCHv8sQ3M="
	"github.com/mattn/go-runewidth v0.0.9 h1:Lm995f3rfxdpd6TSmuVCHVb/QhupuXlYr8sCI/QdE+0="
	"github.com/mattn/go-runewidth v0.0.9/go.mod h1:H031xJmbD/WCDINGzjvQ9THkh0rPKHF+m2gUSrubnMI="
	"golang.org/x/sys v0.0.0-20200923182605-d9f96fdee20d h1:L/IKR6COd7ubZrs2oTnTi73IhgqJ71c9s80WsQnh0Es="
	"golang.org/x/sys v0.0.0-20200923182605-d9f96fdee20d/go.mod h1:h1NjWce9XRLGQEsW7wpKNCjG9DtNlClVuFLEZdDNbEs="
	"gopkg.in/cheggaaa/pb.v1 v1.0.28 h1:n1tBJnnK2r7g9OW2btFH91V92STTUevLXYFb8gy9EMk="
	"gopkg.in/cheggaaa/pb.v1 v1.0.28/go.mod h1:V/YB90LKu/1FcN3WVnfiiE5oMCibMjukxqG/qStrOgw="
)

DESCRIPTION="Application to flash firmware for ZSA keyboard"
HOMEPAGE="https://www.zsa.io/"
S="${WORKDIR}/${P}-linux"
go-module_set_globals
SRC_URI="https://github.com/zsa/${PN}/archive/refs/tags/${PV}-linux.tar.gz -> ${P}-linux.tar.gz
		${EGO_SUM_SRC_URI}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE=""

DEPEND="dev-libs/libusb acct-group/plugdev"
BDEPEND=">=dev-lang/go-1.15"

src_compile() {
	go build ${S} || die "compile failed"
}

src_install() {
	dobin wally-cli
	echo '# Teensy rules for the Ergodox EZ' >> 50-wally.rules
	echo 'ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", ENV{ID_MM_DEVICE_IGNORE}="1"' >> 50-wally.rules
	echo 'ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789A]?", ENV{MTP_NO_PROBE}="1"' >> 50-wally.rules
	echo 'SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789ABCD]?", MODE:="0666"' >> 50-wally.rules
	echo 'KERNEL=="ttyACM*", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", MODE:="0666"' >> 50-wally.rules
	echo '# STM32 rules for the Moonlander and Planck EZ' >> 50-wally.rules
	echo 'SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", \' >> 50-wally.rules
	echo '    MODE:="0666", \' >> 50-wally.rules
	echo '    SYMLINK+="stm32_dfu"' >> 50-wally.rules
	udev_dorules 50-wally.rules
	udev_reload
}
