# homebrew-topinfra
A Homebrew tap repository for topinfra-maven-dist


### Install topinfra-maven

```bash
# install topinfra-maven
brew unlink maven
brew install ci-and-cd/topinfra/topinfra-maven

# install io.takari:takari-maven-plugin:0.7.7-SNAPSHOT
cp -r $(brew --prefix topinfra-maven)/repository ~/.m2/
```


### Develop

`brew tap ci-and-cd/topinfra`
This will clone `git@github.com:ci-and-cd/homebrew-topinfra.git` into `/usr/local/Homebrew/Library/Taps/ci-and-cd/homebrew-topinfra`

```bash
cp -r Formula /usr/local/Homebrew/Library/Taps/ci-and-cd/homebrew-topinfra/
HOMEBREW_NO_AUTO_UPDATE=1 brew install --verbose --debug ci-and-cd/topinfra/topinfra-maven
```



To install specific version of a formula, see 
[installing-multiple-versions-of-terraform-with-homebrew](https://blog.gruntwork.io/installing-multiple-versions-of-terraform-with-homebrew-899f6d124ff9)
