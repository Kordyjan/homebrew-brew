class Dotty < Formula
  desc "Experimental Scala Compiler"
  homepage "http://dotty.epfl.ch/"
  url "https://github.com/lampepfl/dotty/releases/download/0.6.0-RC1/dotty-0.6.0-RC1.tar.gz"
  sha256 "de1f5e72fb0e0b4c377d6cec93f565eff49769698cd8be01b420705fe8475ca4"
  # mirror "https://www.scala-lang.org/files/archive/scala-2.12.2.tgz"

  bottle :unneeded

  depends_on :java => "1.8"

  def install
    rm_f Dir["bin/*.bat"]
    prefix.install "bin", "lib"
  end

  test do
    # test dotc and dotr:
    file = testpath/"Test.scala"
    file.write <<-EOS.undent
      object Test {
        def main(args: Array[String]) = {
          println(s"${2 + 2}")
        }
      }
    EOS

    shell_output("#{bin}/dotc #{file}")
    out = shell_output("#{bin}/dotr Test").strip

    assert_equal "4", out

    # test dotd:
    Dir.mkdir "#{testpath}/site"
    index_out = testpath/"site"/"index.md"
    index_out.write <<-EOS.undent
    Hello, world!
    =============
    EOS
    shell_output("#{bin}/dotd -siteroot #{testpath}/site -project Hello #{file}")
    index_file = File.open("#{testpath}/site/_site/index.html", "rb").read
    assert index_file.include? '<h1><a href="#hello-world" id="hello-world">Hello, world!</a></h1>'
  end
end
