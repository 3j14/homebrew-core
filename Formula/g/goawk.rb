class Goawk < Formula
  desc "POSIX-compliant AWK interpreter written in Go"
  homepage "https://benhoyt.com/writings/goawk/"
  url "https://github.com/benhoyt/goawk/archive/refs/tags/v1.28.0.tar.gz"
  sha256 "4d50b4f9425d7c1ef77467675d5011ad53d5720607fad5fe2fc8124fac07a49f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "284e2962ac65a9bee27b84fccd3dba043958be4b66c093e679fcdaa2ec1abe83"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "809461d8c50cf9fc9b71a05e69ca05f4027888bf20d611e2fb0a2b1eaaac642c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "809461d8c50cf9fc9b71a05e69ca05f4027888bf20d611e2fb0a2b1eaaac642c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "809461d8c50cf9fc9b71a05e69ca05f4027888bf20d611e2fb0a2b1eaaac642c"
    sha256 cellar: :any_skip_relocation, sonoma:         "f304b0077853f4a99002a0f4e2f7eb6e9c73500f606a1b4a79987fd39158bacd"
    sha256 cellar: :any_skip_relocation, ventura:        "f304b0077853f4a99002a0f4e2f7eb6e9c73500f606a1b4a79987fd39158bacd"
    sha256 cellar: :any_skip_relocation, monterey:       "f304b0077853f4a99002a0f4e2f7eb6e9c73500f606a1b4a79987fd39158bacd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84c5add631fecc6d08aa74e4607a98fc39b1570777763257caa3042eeb027855"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = pipe_output("#{bin}/goawk '{ gsub(/Macro/, \"Home\"); print }' -", "Macrobrew")
    assert_equal "Homebrew", output.strip
  end
end
