class Apkleaks < Formula
  include Language::Python::Virtualenv

  desc "Scanning APK file for URIs, endpoints & secrets"
  homepage "https://github.com/dwisiswant0/apkleaks"
  url "https://files.pythonhosted.org/packages/1e/e6/203661abe151dbc59096de65d6f0cf392d1aad3acba32f4e9f3f389acad0/apkleaks-2.6.3.tar.gz"
  sha256 "e247b59acf4448f3c2e45449bc7564bc5b7a216ebfb166236baf602d625b1df5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "15d3a77dc564f393dd748b701ebd187b0b71a4d0a38707bcb426938012d977d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "517dfc6f423e2eb7a1c0deba2598bcb907132efe04ca2d71775ffa6ddef65a23"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4cb660dc81eabb317ab1c16e595c05436d0237b7202d08f1dc1f8360902dd34"
    sha256 cellar: :any,                 arm64_monterey: "b1ecd3774113cf9c92c3a03e1394572b83f297ddf0b4070c9d2d7df6a32986e6"
    sha256 cellar: :any_skip_relocation, sonoma:         "9dbf55df4f43d7f6bdeeead47275103103118abb755c5f3e30a7685e1e841253"
    sha256 cellar: :any_skip_relocation, ventura:        "aab0991cebc6c97ac6bd6200a6bc7deafdf56a6f59bdc899acccc624fe664009"
    sha256 cellar: :any,                 monterey:       "ed06ed10e8816eb47099d18a520c238856402f2a9a08672fdc3f645b7f53d5c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee5126a2a63fa15c5aca1a5b10912359fd1d49b736ef3e0510fd89510097b345"
  end

  depends_on "jadx"
  depends_on "python@3.12"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/de/cf/d547feed25b5244fcb9392e288ff9fdc3280b10260362fc45d37a798a6ee/asn1crypto-1.5.1.tar.gz"
    sha256 "13ae38502be632115abf8a24cbe5f4da52e3b5231990aff31123c805306ccb9c"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/e7/6b/20c3a4b24751377aaa6307eb230b66701024012c29dd374999cc92983269/lxml-5.3.0.tar.gz"
    sha256 "4e109ca30d1edec1ac60cdbe341905dc3b8f55b16855e03a54aaf59e51ec8c6f"
  end

  resource "pyaxmlparser" do
    url "https://files.pythonhosted.org/packages/1e/1f/7a7318ad054d66253d2b96e2d9038ea920f17c8a9bd687cdcfa16a655bdf/pyaxmlparser-0.3.31.tar.gz"
    sha256 "fecb858ff1fb456466f8dcdcd814207b4c15edb95f67cfe0a38c7d7cd4a28d4d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    resource "homebrew-test.apk" do
      url "https://raw.githubusercontent.com/facebook/redex/fa32d542d4074dbd485584413d69ea0c9c3cbc98/test/instr/redex-test.apk"
      sha256 "7851cf2a15230ea6ff076639c2273bc4ca4c3d81917d2e13c05edcc4d537cc04"
    end

    testpath.install resource("homebrew-test.apk")
    output = shell_output("#{bin}/apkleaks -f #{testpath}/redex-test.apk")
    assert_match "Decompiling APK...", output
    assert_match "Scanning against 'com.facebook.redex.test.instr'", output

    assert_match version.to_s, shell_output("#{bin}/apkleaks -h 2>&1")
  end
end
