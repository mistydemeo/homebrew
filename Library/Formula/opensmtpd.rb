require 'formula'

class Opensmtpd < Formula
  homepage 'http://www.opensmtpd.org'
  url 'https://www.opensmtpd.org/archives/opensmtpd-5.4.2p1.tar.gz'
  sha256 '4ffaf48d3d044ef8be1bd80c8972c87ba830a21bb330b85a59f6a70da5fbd9a2'
  version '5.4.2p1'

  depends_on :autoconf
  depends_on :automake
  depends_on :libtool
  # build fails with the system bison
  depends_on 'bison' => :build
  depends_on 'pkg-config' => :build
  depends_on 'libevent'

  def patches
    # OS X doesn't define MSG_NOSIGNAL
    # Reported upstream: http://article.gmane.org/gmane.mail.opensmtpd.general/533
    "https://gist.github.com/rheoli/530ca21dd31da0c9670e/raw/5a673e94a61012a2544826465008a889eea26681/res_send_async.c.patch"
  end

  def install
    # README.md specifies this as necessary
    ENV.append_to_cflags "-DBIND_8_COMPAT=1"

    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-libevent-dir=#{Formula.factory('libevent').opt_prefix}"
    system "make install"
  end
end
