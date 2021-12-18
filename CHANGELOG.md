# Changelog

<!-- %% CHANGELOG_ENTRIES %% -->

## 2.7.2 - 2021-12-18

- Switch github actions to erlef/setup-beam
- Never add untracked files with --allow-untracked
- Fail mix task with appropriate exit code


## 2.7.1 - 2021-03-10

Fix dry-run commit log output


## 2.7.0 - 2021-03-07

Loosen Elixir version constraint to 1.8


## 2.6.1 - 2021-03-05

Fix typos in documentation


## 2.6.0 - 2021-03-04

- ISO 8601 formatted changelog entry date
- Add excoveralls
- Fix typos in documentation


## 2.5.5 - 2021-03-02

Cleanup module docs


## 2.5.4 - 2021-03-01

- Rename version_file.ex to more appropriate project.ex
- More Documentation
- License file


## 2.5.3 - 2021-03-01

Important note on push/publish failure


## 2.5.2 - 2021-03-01

Improve installation docs


## 2.5.1 - 2021-02-28

Verify separate version file before writing to it


## 2.5.0 - 2021-02-28

- Support updating project version in module attribute
- Support --version-file option considered when updating project version
- Update Documentation


## 2.4.5 - 2021-02-28

Clarify push and publishing task behavior in docs


## 2.4.4 - 2021-02-28

- Do not patch higher pre-release level while on pre-release
- Add missing match in option validation
- Mark dependencies as optional


## 2.4.3 - 2021-02-27

Fix typo in readme


## 2.4.2 - 2021-02-27

Update hex.pm links and create docs folder


## 2.4.1 - 2021-02-27

Cleanup Expublish.Semver


## 2.4.0 - 2021-02-27

- Add support for pre-release levels: alpha, beta and rc
- Restructured Documentation


## 2.3.4 - 2021-02-25

Add typespecs and dialyzer check


## 2.3.3 - 2021-02-25

- Reformat print help
- Improved documentation


## 2.3.2 - 2021-02-24

Add more documentation


## 2.3.1 - 2021-02-24

Improve invalid option log


## 2.3.0 - 2021-02-24

- Run static code analysis in github action
- Print test output in mix shell
- Add credo


## 2.2.4 - 2021-02-24

- Unify system calls
- Consistent logging


## 2.2.3 - 2021-02-23

Make task fail on invalid options


## 2.2.2 - 2021-02-23

Refactor mix task options


## 2.2.1 - 2021-02-23

fix Mix.env check before Tests.run


## 2.2.0 - 2021-02-23

- add --commit-prefix option
- add --tag-prefix option
- setup tests for all modules


## 2.1.2 - 2021-02-22

- cleanup project validation
- improve task logging


## 2.1.1 - 2021-02-22

add missing --allow-untracked line in print help


## 2.1.0 - 2021-02-22

- Add --allow-untracked
- Documentation amends


## 2.0.0 - 2021-02-21

Rename mix task to `mix expublish`


## 1.1.1 - 2021-02-21

Configure github actions


## 1.1.0 - 2021-02-21

Command line options


## 1.0.0 - 2021-02-20

Initial release


