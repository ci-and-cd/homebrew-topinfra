# homebrew-topinfra
A Homebrew tap repository for topinfra-maven-dist


### 1. Install topinfra-maven

`curl -sSL https://github.com/ci-and-cd/homebrew-topinfra/raw/master/install-topinfra_maven.sh | bash -s`

Or install into an existing maven installation (any OS supports this script, you need a GUN sed on Mac OSX)

```bash
# install topinfra-maven
MAVEN_HOME=$(mvn help:evaluate -Dexpression=maven.home -q -DforceStdout);
shaded_jar_url=$(curl -fsSL https://github.com/ci-and-cd/homebrew-topinfra/raw/master/Formula/topinfra-maven.rb | grep -E '\s+url\s+"[^"]+"' | sed -E 's#\s*url "(.+).zip"#\1-shaded.jar#');
curl -fsSL -o ${MAVEN_HOME}/lib/topinfra-maven-dist-shaded.jar ${shaded_jar_url};
curl -fsSL -o ${MAVEN_HOME}/conf/settings.xml https://github.com/ci-and-cd/topinfra-maven/raw/develop/topinfra-maven-dist/src/main/assembly/settings.xml;
```

Or install as a alternative maven distribution (Mac OSX)

```bash
# install topinfra-maven
if ! type -p brew > /dev/null; then /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"; fi;
if [[ -n $(brew list | grep '^maven$') ]]; then brew unlink maven; fi;
if [[ -n $(brew list | grep '^mvnvm$') ]]; then brew unlink mvnvm; fi;
brew update;
# `brew install ci-and-cd/topinfra/topinfra-maven` or `brew reinstall ci-and-cd/topinfra/topinfra-maven` to re-install snapshot versions
if [[ -z $(brew list | grep '^topinfra-maven$') ]]; then brew install ci-and-cd/topinfra/topinfra-maven; else brew reinstall ci-and-cd/topinfra/topinfra-maven; fi;

MAVEN_HOME="$(brew --prefix topinfra-maven)/libexec";
```


### 2. Install io.takari:takari-maven-plugin:0.7.7-SNAPSHOT

Official release version has a bug that -DdistributionUrl not working as expected.

```bash
# install io.takari:takari-maven-plugin:0.7.7-SNAPSHOT
git clone -b feature/distributionUrl https://github.com/ci-and-cd/takari-maven-plugin.git ${MAVEN_HOME}/takari-maven-plugin;
${MAVEN_HOME}/bin/mvn -e -f ${MAVEN_HOME}/takari-maven-plugin -U -X clean install -Dmaven.repo.local=${MAVEN_HOME}/repository;
cp -r ${MAVEN_HOME}/repository/* $(${MAVEN_HOME}/bin/mvn help:evaluate -Dexpression=settings.localRepository -q -DforceStdout)/;
```


### 3. Setup maven wrapper (mvnw, mvnw.cmd) on your maven projects

```bash
#cd ${PROJECT_BASEDIR}
mvn -N io.takari:maven:0.7.7-SNAPSHOT:wrapper -DdistributionUrl=https://repo1.maven.org/maven2/top/infra/maven/topinfra-maven-dist/1.0.3/topinfra-maven-dist-1.0.3.zip
```


### Test this tap

`brew tap ci-and-cd/topinfra`
This will clone `git@github.com:ci-and-cd/homebrew-topinfra.git` into `/usr/local/Homebrew/Library/Taps/ci-and-cd/homebrew-topinfra`

```bash
cp -r Formula /usr/local/Homebrew/Library/Taps/ci-and-cd/homebrew-topinfra/
HOMEBREW_NO_AUTO_UPDATE=1 brew install --verbose --debug ci-and-cd/topinfra/topinfra-maven
```

Restore local tap repository: `git -C /usr/local/Homebrew/Library/Taps/ci-and-cd/homebrew-topinfra checkout -- .`


### References

To install specific version of a formula, see 
[installing-multiple-versions-of-terraform-with-homebrew](https://blog.gruntwork.io/installing-multiple-versions-of-terraform-with-homebrew-899f6d124ff9)
