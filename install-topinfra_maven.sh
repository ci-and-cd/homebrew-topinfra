
# install topinfra-maven
if ! type -p brew > /dev/null; then /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"; fi
if [[ -n $(brew list | grep '^maven$') ]]; then brew unlink maven; fi
if [[ -n $(brew list | grep '^mvnvm$') ]]; then brew unlink mvnvm; fi
brew update
# `brew install ci-and-cd/topinfra/topinfra-maven` or `brew reinstall ci-and-cd/topinfra/topinfra-maven` to re-install snapshot versions
if [[ -z $(brew list | grep '^topinfra-maven$') ]]; then brew install ci-and-cd/topinfra/topinfra-maven; else brew reinstall ci-and-cd/topinfra/topinfra-maven; fi

# install io.takari:takari-maven-plugin:0.7.7-SNAPSHOT
git clone -b feature/distributionUrl https://github.com/ci-and-cd/takari-maven-plugin.git $(brew --prefix topinfra-maven)/takari-maven-plugin
$(brew --prefix topinfra-maven)/bin/mvn -e -f $(brew --prefix topinfra-maven)/takari-maven-plugin -U -X clean install -Dmaven.repo.local=$(brew --prefix topinfra-maven)/repository
cp -r $(brew --prefix topinfra-maven)/repository/* $($(brew --prefix topinfra-maven)/bin/mvn help:evaluate -Dexpression=settings.localRepository -q -DforceStdout)/
