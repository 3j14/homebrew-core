class Kconf < Formula
  desc "CLI for managing multiple kubeconfigs"
  homepage "https://github.com/particledecay/kconf"
  url "https://github.com/particledecay/kconf/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "e7fe6750c719caf227890a31e2fd5446972ec3e1e5492180d0a387fe1c3394c0"
  license "MIT"
  head "https://github.com/particledecay/kconf.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/particledecay/kconf/build.Version=#{version}
      -X github.com/particledecay/kconf/build.Commit=Homebrew
      -X github.com/particledecay/kconf/build.Date=#{time.iso8601}"
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kconf", "completion")
  end

  test do
    assert_match version.to_s, shell_output(bin/"kconf version")

    output = shell_output(bin/"kconf namespace homebrew 2>&1", 1)
    expected = "you must first set a current context before setting a preferred namespace"
    assert_match expected, output
  end
end
