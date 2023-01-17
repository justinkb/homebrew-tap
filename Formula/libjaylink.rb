class Libjaylink < Formula
  desc "Library to access SEGGER J-Link and compatible devices"
  homepage "https://gitlab.zapb.de/libjaylink/libjaylink.git"
  url "https://gitlab.zapb.de/libjaylink/libjaylink/-/archive/0.3.1/libjaylink-0.3.1.tar.gz"
  sha256 "a2d98c1aa13dcf41c6c681767a43cdefc42b6f71af9362937555051007514cd9"
  license "GPL-2.0-or-later"
  head "https://gitlab.zapb.de/libjaylink/libjaylink.git", branch: "master"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"

  def install
    system "./autogen.sh"
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"
  end
end
