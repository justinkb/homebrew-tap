class Pacman < Formula
  desc "A library-based package manager with dependency support"
  homepage "https://www.archlinux.org/pacman/"
  url "https://sources.archlinux.org/other/pacman/pacman-5.2.2.tar.gz"
  sha256 "bb201a9f2fb53c28d011f661d50028efce6eef2c1d2a36728bdd0130189349a0"
  license "GPL-2.0"

  depends_on "pkg-config" => :build
  depends_on "bash"
  depends_on "curl"
  depends_on "gawk"
  depends_on "gettext"
  depends_on "gpgme"
  depends_on "libarchive"
  depends_on "openssl@1.1"

  uses_from_macos "perl"

  patch :DATA

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", "#{Formula["libarchive"].opt_lib}/pkgconfig"
    ENV.prepend_path "PKG_CONFIG_PATH", "#{Formula["openssl@1.1"].opt_lib}/pkgconfig"
    ENV.prepend_path "PKG_CONFIG_PATH", "#{Formula["curl"].opt_lib}/pkgconfig"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{HOMEBREW_PREFIX}/etc",
                          "--localstatedir=#{HOMEBREW_PREFIX}/var",
                          "--with-scriptlet-shell=#{HOMEBREW_PREFIX}/bin/bash",
                          "--with-crypto=openssl",
                          "--with-gpgme",
                          "--with-libcurl",
                          "--disable-doc"

    system "make", "install"
  end
end

__END__
From 8995ebd466014d04a3184e992fbc04da85621093 Mon Sep 17 00:00:00 2001
From: Paul Mulders <justinkb@gmail.com>
Date: Sat, 30 Jan 2021 08:50:35 +0100
Subject: [PATCH] fix build on macos

---
 lib/libalpm/dload.c     | 3 +++
 lib/libalpm/util.c      | 7 +++++++
 src/pacman/conf.c       | 3 +++
 src/pacman/sighandler.c | 3 +++
 4 files changed, 16 insertions(+)

diff --git a/lib/libalpm/dload.c b/lib/libalpm/dload.c
index 561b60e9..895bf69c 100644
--- a/lib/libalpm/dload.c
+++ b/lib/libalpm/dload.c
@@ -23,6 +23,9 @@
 #include <errno.h>
 #include <string.h>
 #include <unistd.h>
+#ifdef __APPLE__
+#include <signal.h> /* sigaction */
+#endif
 #include <sys/socket.h> /* setsockopt, SO_KEEPALIVE */
 #include <sys/time.h>
 #include <sys/types.h>
diff --git a/lib/libalpm/util.c b/lib/libalpm/util.c
index 00a6acb9..3716ee51 100644
--- a/lib/libalpm/util.c
+++ b/lib/libalpm/util.c
@@ -29,6 +29,9 @@
 #include <time.h>
 #include <errno.h>
 #include <limits.h>
+#ifdef __APPLE__
+#include <signal.h> /* sigaction */
+#endif
 #include <sys/wait.h>
 #include <sys/socket.h>
 #include <fnmatch.h>
@@ -556,7 +559,11 @@ static void _alpm_reset_signals(void)
 	int *i, signals[] = {
 		SIGABRT, SIGALRM, SIGBUS, SIGCHLD, SIGCONT, SIGFPE, SIGHUP, SIGILL,
 		SIGINT, SIGKILL, SIGPIPE, SIGQUIT, SIGSEGV, SIGSTOP, SIGTERM, SIGTSTP,
+#ifdef __APPLE__
+		SIGTTIN, SIGTTOU, SIGUSR1, SIGUSR2, SIGPROF, SIGSYS, SIGTRAP,
+#else
 		SIGTTIN, SIGTTOU, SIGUSR1, SIGUSR2, SIGPOLL, SIGPROF, SIGSYS, SIGTRAP,
+#endif
 		SIGURG, SIGVTALRM, SIGXCPU, SIGXFSZ,
 		0
 	};
diff --git a/src/pacman/conf.c b/src/pacman/conf.c
index f964283d..fdd42b35 100644
--- a/src/pacman/conf.c
+++ b/src/pacman/conf.c
@@ -26,6 +26,9 @@
 #include <stdlib.h>
 #include <stdio.h>
 #include <string.h> /* strdup */
+#ifdef __APPLE__
+#include <signal.h> /* sigaction */
+#endif
 #include <sys/stat.h>
 #include <sys/types.h>
 #include <sys/utsname.h> /* uname */
diff --git a/src/pacman/sighandler.c b/src/pacman/sighandler.c
index 46e6481f..38b70e46 100644
--- a/src/pacman/sighandler.c
+++ b/src/pacman/sighandler.c
@@ -19,6 +19,9 @@
 
 #include <errno.h>
 #include <signal.h>
+#ifdef __APPLE__
+#include <signal.h> /* sigaction */
+#endif
 #include <unistd.h>
 
 #include <alpm.h>
-- 
2.30.0

