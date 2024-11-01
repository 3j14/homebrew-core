class Noir < Formula
  desc "Attack surface detector that identifies endpoints by static analysis"
  homepage "https://github.com/owasp-noir/noir"
  url "https://github.com/owasp-noir/noir/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "cbe5b90996b3878c6127424e086387858cdcd2037170dbe060bae834811de755"
  license "MIT"

  bottle do
    sha256 arm64_sequoia: "82a5441f2cf17eee51adada0b31fdb6ef0e8be9a88a6dcf6b4777b6a108a472b"
    sha256 arm64_sonoma:  "1707c1726f42c3f140cb2219124fc2b84057471ae6b63ae2ad004b2afc20a833"
    sha256 arm64_ventura: "12e5b3785f03297720bc51821a3e5d29a2b792bbc83eeb5247b8c41adfeba94c"
    sha256 sonoma:        "ef2f021de9becc60f2c82c366f7196d8158cf63622ce7477f53aeda23ab819f6"
    sha256 ventura:       "abebb321c9372c55049c3be46e31ff329aba0e97c1a58996b3549b40525fea6b"
    sha256 x86_64_linux:  "7d39875447a40d3e021c021a97cae689412329b50bd5ff6cc811adc779f87db6"
  end

  depends_on "bdw-gc"
  depends_on "crystal"
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "pcre2"

  uses_from_macos "zlib"

  def install
    system "shards", "install"
    system "shards", "build", "--release", "--no-debug"
    bin.install "bin/noir"

    generate_completions_from_executable(bin/"noir", shell_parameter_format: "--generate-completion=",
                                                     shells:                 [:bash, :zsh, :fish])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/noir --version")

    system "git", "clone", "https://github.com/owasp-noir/noir.git"
    output = shell_output("#{bin}/noir -b noir 2>&1")
    assert_match "Generating Report.", output
  end
end
