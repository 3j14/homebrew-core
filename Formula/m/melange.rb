class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://github.com/chainguard-dev/melange/archive/refs/tags/v0.8.4.tar.gz"
  sha256 "763fea9270b22b3944a9148ba9161bd4900b8f725798bb5438b03d822da9be77"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3e0164e997f688c5d27c20b54fa2375f8cda3ae2db05322712599b0c52fd334d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a487451c3a965bf95124cbf72d6091986c1b929a9d27e315f17ddaaaccb6e03d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57281d093395cbd359eef17f42df19a3ceabbb90357c81348c3f24bd41899f9f"
    sha256 cellar: :any_skip_relocation, sonoma:         "df5a6a7968eef17298fd0ec0c4f580a412005533f8745cce8245c8faca4dd73b"
    sha256 cellar: :any_skip_relocation, ventura:        "c25379c253b1478579b6a0c9dd9fd2f4e385dc00997c312e2f92c671a22f946a"
    sha256 cellar: :any_skip_relocation, monterey:       "3963eb4fb8b1165ba3677f5e1d28cc8a56c09f1cd89bbf5c898e9b196dac041c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f603a679bf4c2fbb98f696121332f916e4a3f0c7249209a963d2784d821e27b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.io/release-utils/version.gitVersion=#{version}
      -X sigs.k8s.io/release-utils/version.gitCommit=brew
      -X sigs.k8s.io/release-utils/version.gitTreeState=clean
      -X sigs.k8s.io/release-utils/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"melange", "completion")
  end

  test do
    (testpath/"test.yml").write <<~EOS
      package:
        name: hello
        version: 2.12
        epoch: 0
        description: "the GNU hello world program"
        copyright:
          - paths:
            - "*"
            attestation: |
              Copyright 1992, 1995, 1996, 1997, 1998, 1999, 2000, 2001, 2002, 2005,
              2006, 2007, 2008, 2010, 2011, 2013, 2014, 2022 Free Software Foundation,
              Inc.
            license: GPL-3.0-or-later
        dependencies:
          runtime:

      environment:
        contents:
          repositories:
            - https://dl-cdn.alpinelinux.org/alpine/edge/main
          packages:
            - alpine-baselayout-data
            - busybox
            - build-base
            - scanelf
            - ssl_client
            - ca-certificates-bundle

      pipeline:
        - uses: fetch
          with:
            uri: https://ftp.gnu.org/gnu/hello/hello-${{package.version}}.tar.gz
            expected-sha256: cf04af86dc085268c5f4470fbae49b18afbc221b78096aab842d934a76bad0ab
        - uses: autoconf/configure
        - uses: autoconf/make
        - uses: autoconf/make-install
        - uses: strip
    EOS

    assert_equal "hello-2.12-r0", shell_output("#{bin}/melange package-version #{testpath}/test.yml")

    system bin/"melange", "keygen"
    assert_predicate testpath/"melange.rsa", :exist?

    assert_match version.to_s, shell_output(bin/"melange version 2>&1")
  end
end
