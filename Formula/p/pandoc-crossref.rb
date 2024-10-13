class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://github.com/lierdakil/pandoc-crossref/archive/refs/tags/v0.3.18.0a.tar.gz"
  version "0.3.18.0a"
  sha256 "77b5150c50c5a8c0f5716b1fc830b253c9c2e494d8774345e983a1365ac4cb08"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23c15c469f8982bf62c75c83bb316aef2c6718034a9d7cdd2b83d9aa3c37c592"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8cbf8824e3c9a5f22ed372e879bc870f3433d6f74e24d9366421e9af7884a608"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4ae1757403b784ff56ac36e5d02b45bded11b33d85e68fcd422ea56a59fb1875"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef3f299c20e7fe444526fcae57486c76a65ccec0cff797501bd00808611a2365"
    sha256 cellar: :any_skip_relocation, ventura:       "a6b2c63b04ce95741dddf503d7d66cef42cb348f95baf1d4ad495fc3c938ae61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7696fc0f392d8c6d727f508a2d1904997cc3c5c410247605e16661347dd850f7"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pandoc"

  uses_from_macos "unzip" => :build
  uses_from_macos "zlib"

  def install
    rm("cabal.project.freeze")

    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath/"hello.md").write <<~EOS
      Demo for pandoc-crossref.
      See equation @eq:eqn1 for cross-referencing.
      Display equations are labelled and numbered

      $$ P_i(x) = \\sum_i a_i x^i $$ {#eq:eqn1}
    EOS
    output = shell_output("#{Formula["pandoc"].bin}/pandoc -F #{bin}/pandoc-crossref -o out.html hello.md 2>&1")
    assert_match "∑", (testpath/"out.html").read
    refute_match "WARNING: pandoc-crossref was compiled", output
  end
end
