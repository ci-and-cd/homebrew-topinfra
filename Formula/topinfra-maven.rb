class TopinfraMaven < Formula
  desc "Java-based project management"
  homepage "https://github.com/ci-and-cd/topinfra-maven/"
  url "https://repo1.maven.org/maven2/top/infra/maven/topinfra-maven-dist/1.0.3/topinfra-maven-dist-1.0.3.zip"
  mirror "https://repo1.maven.org/maven2/top/infra/maven/topinfra-maven-dist/1.0.3/topinfra-maven-dist-1.0.3.zip"
  sha256 "df5d542bfb9dca24003b2f1e8f6db4596f279842d6fda0e0521438944f0990f6"
  # curl -sSL url | sha256sum
  # SHA256 or SHA512 are not supported by maven-install-plugin or nexus maven repository currently.
  # see:
  # https://issues.apache.org/jira/browse/MINSTALL-138
  # https://issues.sonatype.org/browse/MVNCENTRAL-2859
  version "0.0.1-SNAPSHOT"

  bottle :unneeded

  depends_on :java => "1.8"
  depends_on "git"

  conflicts_with "mvnvm", :because => "also installs a 'mvn' executable"
  conflicts_with "maven", :because => "also installs a 'mvn' executable"

  def install
    # Remove windows files
    rm_f Dir["bin/*.cmd"]

    # Fix the permissions on the global settings file.
    chmod 0644, "conf/settings.xml"

    libexec.install Dir["*"]

    # Leave conf file in libexec. The mvn symlink will be resolved and the conf
    # file will be found relative to it
    Pathname.glob("#{libexec}/bin/*") do |file|
      next if file.directory?

      basename = file.basename
      next if basename.to_s == "m2.conf"

      (bin/basename).write_env_script file, Language::Java.overridable_java_home_env
    end
  end

  # def post_install
  #   # work_dir = Pathname.pwd
  #   work_dir = prefix
  #   system "echo", "\"work_dir: [#{work_dir}]\""
  #
  #   # Errno::EPERM: Operation not permitted
  #   # user_local_repo = Pathname.new(Dir.home(ENV["USER"]))/".m2/repository"
  #   # mkdir_p user_local_repo/"io/takari"
  #   # cp_r work_dir.parent/"repository/io/takari", user_local_repo/"io"
  #
  #   # system "find", "#{work_dir}"
  #   work_dir.cd do
  #     system "echo", "\"Run [git clone -b feature/distributionUrl https://github.com/ci-and-cd/takari-maven-plugin.git]\""
  #     system "git", "clone", "-b", "feature/distributionUrl", "https://github.com/ci-and-cd/takari-maven-plugin.git"
  #     (work_dir/"takari-maven-plugin").cd do
  #       # system "echo", "\"Pathname.pwd: [#{Pathname.pwd}]\""
  #       # system "ls", "-lah"
  #
  #       # Files wrote into #{work_dir.parent} were removed at the end of install process.
  #       system "echo", "\"Run [#{libexec}/bin/mvn -e -U -X -Dmaven.repo.local=#{work_dir}/repository install]\""
  #       system "#{libexec}/bin/mvn", "-e", "-U", "-X", "-Dmaven.repo.local=#{work_dir}/repository", "install"
  #     end
  #   end
  #
  #   rm_rf work_dir/"takari-maven-plugin"
  # end

  test do
    (testpath/"pom.xml").write <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <project xmlns="https://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="https://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
        <modelVersion>4.0.0</modelVersion>
        <groupId>org.homebrew</groupId>
        <artifactId>maven-test</artifactId>
        <version>1.0.0-SNAPSHOT</version>
        <properties>
          <maven.compiler.source>1.8</maven.compiler.source>
          <maven.compiler.target>1.8</maven.compiler.target>
          <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        </properties>
      </project>
    EOS
    (testpath/"src/main/java/org/homebrew/MavenTest.java").write <<~EOS
      package org.homebrew;
      public class MavenTest {
        public static void main(String[] args) {
          System.out.println("Testing Maven with Homebrew!");
        }
      }
    EOS
    system "#{bin}/mvn", "compile", "-Duser.home=#{testpath}"
  end
end