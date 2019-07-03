# homebrew-topinfra
A Homebrew tap repository for topinfra-maven-dist


### Install topinfra-maven

`curl -sSL https://github.com/ci-and-cd/homebrew-topinfra/raw/master/install-topinfra_maven.sh | bash -s`

Or

```bash
# install topinfra-maven
if ! type -p brew > /dev/null; then /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"; fi
if [[ -n $(brew list | grep '^maven$') ]]; then brew unlink maven; fi
if [[ -n $(brew list | grep '^mvnvm$') ]]; then brew unlink mvnvm; fi
# `brew install ci-and-cd/topinfra/topinfra-maven` or `brew reinstall ci-and-cd/topinfra/topinfra-maven` to re-install snapshot versions
if [[ -z $(brew list | grep '^topinfra-maven$') ]]; then brew install ci-and-cd/topinfra/topinfra-maven; else brew reinstall ci-and-cd/topinfra/topinfra-maven; fi

# install io.takari:takari-maven-plugin:0.7.7-SNAPSHOT
git clone -b feature/distributionUrl https://github.com/ci-and-cd/takari-maven-plugin.git $(brew --prefix topinfra-maven)/takari-maven-plugin
$(brew --prefix topinfra-maven)/bin/mvn -e -f $(brew --prefix topinfra-maven)/takari-maven-plugin -U -X clean install -Dmaven.repo.local=$(brew --prefix topinfra-maven)/repository
cp -r $(brew --prefix topinfra-maven)/repository/* $($(brew --prefix topinfra-maven)/bin/mvn help:evaluate -Dexpression=settings.localRepository -q -DforceStdout)/
```


### Develop

`brew tap ci-and-cd/topinfra`
This will clone `git@github.com:ci-and-cd/homebrew-topinfra.git` into `/usr/local/Homebrew/Library/Taps/ci-and-cd/homebrew-topinfra`

```bash
cp -r Formula /usr/local/Homebrew/Library/Taps/ci-and-cd/homebrew-topinfra/
HOMEBREW_NO_AUTO_UPDATE=1 brew install --verbose --debug ci-and-cd/topinfra/topinfra-maven
```

Restore local tap repository: `git -C /usr/local/Homebrew/Library/Taps/ci-and-cd/homebrew-topinfra checkout -- .`


To install specific version of a formula, see 
[installing-multiple-versions-of-terraform-with-homebrew](https://blog.gruntwork.io/installing-multiple-versions-of-terraform-with-homebrew-899f6d124ff9)
