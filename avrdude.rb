class Avrdude < Formula
  desc "Atmel AVR MCU programmer"
  homepage "https://savannah.nongnu.org/projects/avrdude/"
  head "https://download.savannah.gnu.org/releases/avrdude/"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url "https://download.savannah.gnu.org/releases/avrdude/"
    regex(/href=.*?avrdude[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  head do
    url "https://svn.savannah.nongnu.org/svn/avrdude/trunk/avrdude"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "automake" => :build
  depends_on "libelf"
  depends_on "libftdi0"
  depends_on "libhid"
  depends_on "libusb-compat"
  depends_on "hidapi"

  uses_from_macos "bison"
  uses_from_macos "flex"

  def install
    if build.head?
      system "./bootstrap"
    end
    # Workaround for ancient config files not recognizing aarch64 macos.
    am = Formula["automake"]
    am_share = am.opt_share/"automake-#{am.version.major_minor}"
    %w[config.guess config.sub].each do |fn|
      chmod "u+w", fn
      cp am_share/fn, fn
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "avrdude done.  Thank you.",
      shell_output("#{bin}/avrdude -c jtag2 -p x16a4 2>&1", 1).strip
  end
end
