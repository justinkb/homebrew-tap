class Libjaylink < Formula
  desc "Library to access SEGGER J-Link and compatible devices"
  homepage "https://gitlab.zapb.de/libjaylink/libjaylink.git"
  url "https://gitlab.zapb.de/libjaylink/libjaylink/-/archive/0.2.0/libjaylink-0.2.0.tar.gz"
  sha256 "ac10d03088a2f28ebfc0411f9e617433936220dc183050f2e429694dcadc4f2a"
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
