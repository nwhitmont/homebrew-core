class Awscli < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  # awscli should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-cli/archive/1.11.180.tar.gz"
  sha256 "fd264eabd8d2a61cc395aa800943e88aa377c19ab241722e2e64387473ecf169"
  head "https://github.com/aws/aws-cli.git", :branch => "develop"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "168d726049366b4cbd1278e0e4a4e0e7e406d555e13e3681a968ca629776c67c" => :high_sierra
    sha256 "89085a16f39f881464052f776895eda734618eb8d8b649c9e9866bae4c6d9796" => :sierra
    sha256 "8028eba1b1001b91a622b0e83fa544d19761cb99113a73c13dbdaf997015918d" => :el_capitan
  end

  # Some AWS APIs require TLS1.2, which system Python doesn't have before High
  # Sierra
  depends_on :python3

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "awscli"
    venv.pip_install_and_link buildpath
    pkgshare.install "awscli/examples"

    rm Dir["#{bin}/{aws.cmd,aws_bash_completer,aws_zsh_completer.sh}"]
    bash_completion.install "bin/aws_bash_completer"
    zsh_completion.install "bin/aws_zsh_completer.sh"
    (zsh_completion/"_aws").write <<~EOS
      #compdef aws
      _aws () {
        local e
        e=$(dirname ${funcsourcetrace[1]%:*})/aws_zsh_completer.sh
        if [[ -f $e ]]; then source $e; fi
      }
    EOS
  end

  def caveats; <<~EOS
    The "examples" directory has been installed to:
      #{HOMEBREW_PREFIX}/share/awscli/examples
    EOS
  end

  test do
    assert_match "topics", shell_output("#{bin}/aws help")
  end
end
