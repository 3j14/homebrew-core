class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.3.16.tgz"
  sha256 "afaf38b692a927d0b7567dde5d901cc2113207efd0aa189986fe8effdf8a638f"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7ab474f7814c5f0f57a019d95189f6139bf3acfba01f173eafabbec0b61aa70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7ab474f7814c5f0f57a019d95189f6139bf3acfba01f173eafabbec0b61aa70"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c7ab474f7814c5f0f57a019d95189f6139bf3acfba01f173eafabbec0b61aa70"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b71cc32409d26ba310a24735b5bbd52cd281c2402ba89fab851f70dfff84927"
    sha256 cellar: :any_skip_relocation, ventura:       "7b71cc32409d26ba310a24735b5bbd52cd281c2402ba89fab851f70dfff84927"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7ab474f7814c5f0f57a019d95189f6139bf3acfba01f173eafabbec0b61aa70"
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
