# archlinux-me176c
Additional Arch Linux (AUR) packages for use with the ASUS MeMO Pad 7 (ME176C(X)).

## Usage
These packages are documented in the
[ASUS MeMO Pad 7 (ME176C(X)) article on the ArchWiki](https://wiki.archlinux.org/index.php/ASUS_MeMO_Pad_7_(ME176C(X))).

Additionally to the [ME176C Unofficial User Repository](https://wiki.archlinux.org/index.php/Unofficial_user_repositories#me176c),
all binary packages, including all older versions, are also available as
[Releases](https://github.com/me176c-dev/archlinux-me176c) for manual download.

## Building
Each subdirectory contains a standard Arch Linux package for use with `makepkg`.

`archiso` contains the patch file on top of the `releng` [archiso profile](https://wiki.archlinux.org/index.php/Archiso).
Make sure you have [archiso](https://www.archlinux.org/packages/extra/any/archiso/) installed, then run `checkout.sh`
in `archiso`. The archiso build files are then in `releng/` and it can be built normally using `./build.sh -v`.
Regenerate the patch using `git diff --cached > ../releng.patch`

## License
Unless otherwise noted, the scripts and build files in this repository are licensed under the
[MIT License](https://opensource.org/licenses/MIT):

    SPDX-License-Identifier: MIT
    Copyright (C) 2017 lambdadroid

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.
