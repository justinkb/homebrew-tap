class LibimobiledeviceGlue < Formula
  desc "Library with common code used by the libraries and tools around the libimobiledevice project"
  homepage "https://www.libimobiledevice.org/"
  head "https://github.com/libimobiledevice/libimobiledevice-glue.git"
  license "LGPL-2.1"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libplist"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
