class Capnp < Formula
  desc "Data interchange format and capability-based RPC system"
  homepage "https://capnproto.org/"
  url "https://capnproto.org/capnproto-c++-0.6.0.tar.gz"
  sha256 "e50911191afc44d6ab03b8e0452cf8c00fd0edfcd34b39f169cea6a53b0bf73e"

  bottle do
    cellar :any_skip_relocation
    sha256 "1c017adc3ee4e0f1af501a3228d1069995750561ac0459c3430aa90c178a77fc" => :sierra
    sha256 "821b56780106b139788ecdcad979dd8f5af734e6aae776ffc6476943ab6ab542" => :el_capitan
    sha256 "35edb1dacc06cf7c784b37b8625f0cea35a190ecb6fe6e5d913b40eb34c3fa5f" => :yosemite
  end

  needs :cxx11
  depends_on "cmake" => :build

  def install
    ENV.cxx11
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    file = testpath/"test.capnp"
    text = "\"Is a happy little duck\""

    file.write Utils.popen_read("#{bin}/capnp id").chomp + ";\n"
    file.append_lines "const dave :Text = #{text};"
    assert_match text, shell_output("#{bin}/capnp eval #{file} dave")
  end
end
