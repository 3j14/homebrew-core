class Rage < Formula
  desc "Simple, modern, secure file encryption"
  homepage "https://str4d.xyz/rage"
  url "https://github.com/str4d/rage/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "34c39c28f8032c144a43aea96e58159fe69526f5ff91cb813083530adcaa6ea4"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/str4d/rage.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "./rage")

    src_dir = "target/release/completions"
    bash_completion.install "#{src_dir}/rage.bash" => "rage"
    fish_completion.install "#{src_dir}/rage.fish"
    zsh_completion.install "#{src_dir}/_rage"
    bash_completion.install "#{src_dir}/rage-keygen.bash" => "rage-keygen"
    fish_completion.install "#{src_dir}/rage-keygen.fish"
    zsh_completion.install "#{src_dir}/_rage-keygen"

    man.install Dir["target/release/manpages/*"]
  end

  test do
    # Test key generation
    system "#{bin}/rage-keygen", "-o", "#{testpath}/output.txt"
    assert_predicate testpath/"output.txt", :exist?

    # Test encryption
    (testpath/"test.txt").write("Hello World!\n")
    system "#{bin}/rage", "-r", "age1y8m84r6pwd4da5d45zzk03rlgv2xr7fn9px80suw3psrahul44ashl0usm",
      "-o", "#{testpath}/test.txt.age", "#{testpath}/test.txt"
    assert_predicate testpath/"test.txt.age", :exist?
    assert File.read(testpath/"test.txt.age").start_with?("age-encryption.org")

    # Test decryption
    (testpath/"test.key").write("AGE-SECRET-KEY-1TRYTV7PQS5XPUYSTAQZCD7DQCWC7Q77YJD7UVFJRMW4J82Q6930QS70MRX\n")
    assert_equal "Hello World!", shell_output("#{bin}/rage -d -i #{testpath}/test.key #{testpath}/test.txt.age").strip
  end
end
