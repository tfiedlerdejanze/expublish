# Version levels

Version level increases follow [semantic versioning](https://semver.org/) conventions.

The `Expublish.Semver` type is defined as:

```
@type level() :: :major | :minor | :patch | :rc | :beta | :alpha | :stable

```

### Major releases reset minor and patch levels

```bash
# current version: "0.1.4"

expublish.major => "1.0.0"
```

### Minor releases reset patch level

```bash
# current version: "0.1.4"

expublish.minor => "0.2.0"
```

### First pre-release patches the current version by default

```bash
# current version: "0.0.0"

expublish.alpha  => "0.0.1-alpha"
expublish.beta   => "0.0.1-beta"
expublish.rc     => "0.0.1-rc"
```

Note that using a higher pre-release level _does not_ increase the version number.

### Pre-releases can be declared stable

```bash
# current version: "1.0.1-rc"

expublish.stable => "1.0.1"
```

Note that `expublish.stable` only drops the pre-release suffix but  _does not_ increase the version number.

### An already stable version can not be redeclared stable

```bash
# current version: "1.0.1"

expublish.stable => Error: can not release already stable version "1.0.1"
```

### Pre-release levels can not be applied backwards

```bash
# current version: "1.0.0-rc"

expublish.alpha  => Error: current version rc > alpha
expublish.beta   => Error: current version rc > beta
expublish.rc     => "1.0.1-rc"
```

### Patch and current pre-release levels can be used interchangeably

```bash
# current version: "0.1.4-beta"

expublish.patch => "0.1.5-beta"
expublish.beta  => "0.1.6-beta"
expublish.patch => "0.1.7-beta"
expublish.rc    => "0.1.7-rc"
expublish.patch => "0.1.8-rc"
```

### Pre-releases can increase by different version levels

```bash
# current version: "0.0.0"

expublish.alpha           => "0.0.1-alpha"
expublish.beta --as-minor => "0.1.0-beta"
expublish.rc --as-major   => "1.0.0-rc"
```

### Pre-release levels can be skipped

```bash
# current version: "1.0.1-alpha"

expublish.rc => "1.0.1-rc"
```
