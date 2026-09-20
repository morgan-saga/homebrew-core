class Mirthsync < Formula
  desc "Version control for Mirth Connect and Open Integration Engine config"
  homepage "https://saga-it.com/products/mirthsync"
  url "https://github.com/SagaHealthcareIT/mirthsync/releases/download/3.7.0/mirthsync-3.7.0.tar.gz"
  sha256 "d962b21576d479166185b92c1d88540bd493ba2ab39c0b3b7908d8271dbbc98f"
  license "EPL-1.0"

  depends_on "openjdk"

  def install
    # The upstream bin/mirthsync.sh is deliberately not used: it locates its jar
    # with `readlink -f`, which BSD readlink does not support, falling back to
    # greadlink from coreutils. Under `set -euo pipefail` that aborts on a stock
    # macOS. write_jar_script generates a wrapper that invokes the jar directly.
    libexec.install "lib/mirthsync-#{version}-standalone.jar"
    bin.write_jar_script libexec/"mirthsync-#{version}-standalone.jar", "mirthsync"
  end

  test do
    # --help exits 1: it reports the missing required --target, then prints usage.
    output = shell_output("#{bin}/mirthsync --help 2>&1", 1)
    assert_match "Usage: mirthsync", output
  end
end
