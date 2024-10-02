class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.3.15.tgz"
  sha256 "59e051cf041d7959550923be2eb9df6153423b02e6e7e1b8f3f51be0d05e5721"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4047048a45c576d8df80345b097fe904eab5ab467a6e87ab3c8bb4bb4640497"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4047048a45c576d8df80345b097fe904eab5ab467a6e87ab3c8bb4bb4640497"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e4047048a45c576d8df80345b097fe904eab5ab467a6e87ab3c8bb4bb4640497"
    sha256 cellar: :any_skip_relocation, sonoma:        "de806e612b654469f6860138dbeb265341ba27b944d6e603a57022ca16ada4df"
    sha256 cellar: :any_skip_relocation, ventura:       "de806e612b654469f6860138dbeb265341ba27b944d6e603a57022ca16ada4df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4047048a45c576d8df80345b097fe904eab5ab467a6e87ab3c8bb4bb4640497"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end
