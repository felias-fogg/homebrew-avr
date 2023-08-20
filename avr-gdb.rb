class AvrGdb < Formula
  desc "GDB lets you to see what is going on inside a program while it executes"
  homepage "https://www.gnu.org/software/gdb/"

  url "https://ftp.gnu.org/gnu/gdb/gdb-12.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-12.1.tar.xz"
  sha256 "0e1793bf8f2b54d53f46dea84ccfd446f48f81b297b28c4f7fc017b818d69fed"

  # bottle do
  #  root_url "https://github.com/osx-cross/homebrew-avr/releases/download/avr-gdb-10.1"
  #  sha256 catalina: "f922c47325dca55abf04a7af4000595793727d3e0ce495b452f672e5ac2e8aa0"
  # end

  depends_on "avr-binutils"

  uses_from_macos "expat"
  uses_from_macos "ncurses"

  def install
    args = %W[
      --target=avr
      --prefix=#{prefix}

      --disable-debug
      --disable-dependency-tracking

      --disable-binutils

      --disable-nls
      --disable-libssp
      --disable-install-libbfd
      --disable-install-libiberty

    ]

    mkdir "build" do
      inreplace "../bfd/elf-bfd.h", "#define _LIBELF_H_ 1", "#define _LIBELF_H_ 1\n#include <string.h>"
      system "../configure", *args
      system "make"

      # Don't install bfd or opcodes, as they are provided by binutils
      system "make", "install-gdb"
    end
  end

  def caveats
    <<~EOS
      gdb requires special privileges to access Mach ports.
      You will need to codesign the binary. For instructions, see:

        https://sourceware.org/gdb/wiki/BuildingOnDarwin

      On 10.12 (Sierra) or later with SIP, you need to run this:

        echo "set startup-with-shell off" >> ~/.gdbinit
    EOS
  end
end
