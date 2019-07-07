
# install topinfra-maven
function install_topinfra_maven_on_darwin() {
    if ! type -p brew > /dev/null; then /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"; fi;
    if [[ -n $(brew list | grep '^maven$') ]]; then brew unlink maven; fi;
    if [[ -n $(brew list | grep '^mvnvm$') ]]; then brew unlink mvnvm; fi;
    brew update;
    # `brew install ci-and-cd/topinfra/topinfra-maven` or `brew reinstall ci-and-cd/topinfra/topinfra-maven` to re-install snapshot versions
    if [[ -z $(brew list | grep '^topinfra-maven$') ]]; then brew install ci-and-cd/topinfra/topinfra-maven; else brew reinstall ci-and-cd/topinfra/topinfra-maven; fi;

    MAVEN_HOME="$(brew --prefix topinfra-maven)/libexec";
}

# install topinfra-maven
function install_topinfra_maven_into_existing_maven() {
    MAVEN_HOME=$(mvn help:evaluate -Dexpression=maven.home -q -DforceStdout);
    #shaded_jar_url="https://oss.sonatype.org/content/repositories/snapshots/top/infra/maven/topinfra-maven-dist/0.0.1-SNAPSHOT/topinfra-maven-dist-0.0.1-20190707.162430-19-shaded.jar";
    shaded_jar_url=$(curl -fsSL https://github.com/ci-and-cd/homebrew-topinfra/raw/master/Formula/topinfra-maven.rb | grep -E '\s+url\s+"[^"]+"' | sed -E 's#\s*url "(.+).zip"#\1-shaded.jar#');
    curl -fsSL -o ${MAVEN_HOME}/lib/topinfra-maven-dist-shaded.jar ${shaded_jar_url};
    curl -fsSL -o ${MAVEN_HOME}/conf/settings.xml https://github.com/ci-and-cd/topinfra-maven/raw/develop/topinfra-maven-dist/src/main/assembly/settings.xml;
}

# install io.takari:takari-maven-plugin:0.7.7-SNAPSHOT
function install_takari_maven_plugin() {
    if [[ -z "${MAVEN_HOME}" ]]; then MAVEN_HOME=$(mvn help:evaluate -Dexpression=maven.home -q -DforceStdout); fi;
    git clone -b feature/distributionUrl https://github.com/ci-and-cd/takari-maven-plugin.git ${MAVEN_HOME}/takari-maven-plugin;
    ${MAVEN_HOME}/bin/mvn -e -f ${MAVEN_HOME}/takari-maven-plugin -U -X clean install -Dmaven.repo.local=${MAVEN_HOME}/repository;
    cp -r ${MAVEN_HOME}/repository/* $(${MAVEN_HOME}/bin/mvn help:evaluate -Dexpression=settings.localRepository -q -DforceStdout)/;
}


if type -p mvn > /dev/null; then
    install_topinfra_maven_into_existing_maven;
    install_takari_maven_plugin;
elif [[ "$(uname -s)" == "Darwin" ]]; then
    install_topinfra_maven_on_darwin;
    install_takari_maven_plugin;
else
    echo "Aan not install automatically on you system (no maven installation found and not Mac OSX).";
fi
