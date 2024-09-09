class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade/archive/refs/tags/0.11.24.tar.gz"
  sha256 "a553a05eb0cec4cb11892bdd5163dc79d5fd053dff7a95160e652662259cbaf7"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b075820debfc014da1b1334afa4fcd90e6d4b7c6237381d22aa873c828275b5f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b075820debfc014da1b1334afa4fcd90e6d4b7c6237381d22aa873c828275b5f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b075820debfc014da1b1334afa4fcd90e6d4b7c6237381d22aa873c828275b5f"
    sha256 cellar: :any_skip_relocation, sonoma:         "3e9462dc4d596507a89031b804b61df707722fee12e1ea54aa61481a7a777404"
    sha256 cellar: :any_skip_relocation, ventura:        "3e9462dc4d596507a89031b804b61df707722fee12e1ea54aa61481a7a777404"
    sha256 cellar: :any_skip_relocation, monterey:       "3e9462dc4d596507a89031b804b61df707722fee12e1ea54aa61481a7a777404"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8645fc5b5ba58246619694815f265c247864f2d1c11d67ac2fe6947f464e61bd"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/alexellis/arkade/pkg.Version=#{version}
      -X github.com/alexellis/arkade/pkg.GitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

    bin.install_symlink "arkade" => "ark"

    generate_completions_from_executable(bin/"arkade", "completion")
    # make zsh completion also work for `ark` symlink
    inreplace zsh_completion/"_arkade", "#compdef arkade", "#compdef arkade ark=arkade"
  end

  test do
    assert_match "Version: #{version}", shell_output(bin/"arkade version")
    assert_match "Info for app: openfaas", shell_output(bin/"arkade info openfaas")
  end
end
