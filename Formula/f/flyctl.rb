class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.2.5",
      revision: "7bfd726f32a599e849a70d5c0dc4e508da78e55f"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  # Upstream tags versions like `v0.1.92` and `v2023.9.8` but, as of writing,
  # they only create releases for the former and those are the versions we use
  # in this formula. We could omit the date-based versions using a regex but
  # this uses the `GithubLatest` strategy, as the upstream repository also
  # contains over a thousand tags (and growing).
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "934da188ab4ed523bc4230bc2fa5ea4b1dfe6e00f2394e0989d16f0ede15bea5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "934da188ab4ed523bc4230bc2fa5ea4b1dfe6e00f2394e0989d16f0ede15bea5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "934da188ab4ed523bc4230bc2fa5ea4b1dfe6e00f2394e0989d16f0ede15bea5"
    sha256 cellar: :any_skip_relocation, sonoma:         "b4b6acd6e314e3c6fcd78ce8aaeb57c68c84532cd8e10d6a853f6e20eadb7e71"
    sha256 cellar: :any_skip_relocation, ventura:        "b4b6acd6e314e3c6fcd78ce8aaeb57c68c84532cd8e10d6a853f6e20eadb7e71"
    sha256 cellar: :any_skip_relocation, monterey:       "b4b6acd6e314e3c6fcd78ce8aaeb57c68c84532cd8e10d6a853f6e20eadb7e71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57101ba7e53314042a0106f86f38f6ba991b184bbb7fd88e051bca3dd2000755"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/superfly/flyctl/internal/buildinfo.buildDate=#{time.iso8601}
      -X github.com/superfly/flyctl/internal/buildinfo.buildVersion=#{version}
      -X github.com/superfly/flyctl/internal/buildinfo.commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "production"

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin/"flyctl", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
