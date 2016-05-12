# Thankios
Acknowlegements Settings.bundle generator for CocoaPods and Carthage.

## Requirements
* Xcode 7.3+
* OSX 10.11+

## Installation
```bash
$ brew tap recruit-lifestyle/apple
$ brew install thankios
```

## Usage
```bash
# Before running thankios, you should get license texts:
$ pod install
$ carthage checkout --no-use-binaries

# On your project root:
$ thankios <destination path>

# Example:
$ thankios ~/SampleProject/SampleProject/Settings.bundle/
```

## Credits
Thankios is owned an maintained by [RECRUIT LIFESTYLE CO., LTD.](http://www.recruit-lifestyle.co.jp/).

**Contributors:**
* [Yuki Nagai](https://github.com/uny)

## License
```
Copyright (c) 2016 RECRUIT LIFESTYLE CO., LTD.
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
