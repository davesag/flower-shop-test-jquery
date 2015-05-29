# flower-bundler-jquery

This is [Dave Sag](http://cv.davesag.com)'s implementation of [Cogent](http://www.cogent.co)'s developer test. Implemented in Coffeescript as a jQuery plugin.

*If you have been asked to do this test I urge you to not to copy my, or anyone else's, work.*

[![Build Status](https://travis-ci.org/davesag/flower-shop-test-jquery.svg?branch=master)](https://travis-ci.org/davesag/flower-shop-test-jquery) [![Code Climate](https://codeclimate.com/github/davesag/flower-shop-test-jquery/badges/gpa.svg)](https://codeclimate.com/github/davesag/flower-shop-test-jquery)

## Declaration

I solemnly declare that I did not copy this code from anyone else, and that it's all my own original  work.

## Approach

I selected `Coffeescript` as the language to write this in, having already [written a version of this in Ruby](http://github.com/davesag/flower-shop-test).

## Design

The flower bundler problem is a derivative of the classic [knapsack problem](http://en.wikipedia.org/wiki/Knapsack_problem), with the constraint that the returned bundles **must** comprise of the number of flowers requested, and you may use multiple copies of a bundle.

I have defined the following classes, all namespaced within a `FlowerBundler` module.

* `Bundle` — holds details of the flower count and price for a bundle of flowers.
* `BundleChooser` — Implements the core bundle selection logic.
* `Order` — a simple customer order that can be created via `Order.parse`
* `Result` — container for the processed result of an order
* `Receipt` — a collection of order results with a copy of the initial customer order string and the total price.  This can be output to formatted text via its `toFormatted` method.

I hard-coded the Catalogue into the plugin but you can override it via an option if you wish.

## Bundle selection logic.

### The problem can be restated as follows:

* Let `b1` … `bn` be bundles of flowers (integers > 0) where `n` is the bundle number.
* And let `x1` … `xn` be numbers of bundles (integers >= 0)
* The customer requests `F` flowers (integer > 0)
* And there is an upper bound `N` (`n` <= `N`)
* so `x1 * b1 + x2 * b2 + … xn * bn = F`
* `b1` … `bn`, `F` and `N` are known
* Reject `F` if no combination of `x1` * `b1` + `x2` * `b2` + … `xn` * `bn` can equal `F`
* and optimise `x1` … `xn` such that `n` is minimised.

### Solution

1. sort `bn` … `b1` from highest to lowest
2. create empty stash
3. reject all `bn` where `bn` > `F` so the bundles are now `bn'` … `b1` and `F` must now be >=  `bn'`
4. if there are no bundles left then retry from the top but without `bn`. (but if there is nothing to retry with then exit with an error.)
5. `count = integer `F` / `bn'`
6. add `count` copies of `bn'` to stash
7. if `F` / `bn'` is an integer then exit with stash
8. `F'` = `F` - `count` * `bn`
9. repeat from 3

# Dependencies

Assuming you have `Node.js` installed.

```bash
npm install
```

## Ensure Grunt is Installed

```bash
npm install -g grunt
npm install -g grunt-cli
```

## To Test

```bash
grunt test
```

## Example

See the `example.html` file in the `examples/` folder.

###To Build

```bash
grunt
```

This will output the final distribution files into the `dist/` folder, prefixed with `jquery` and suffixed with the version number you specify in `package.json`.

Files created are:

* `jquery-flowerBundler.1.0.0.js` - the 'developer' version.
* `jquery-flowerBundler.1.0.0.min.js` The minified version for production use.
* `jquery-flowerBundler.1.0.0.min.map` The `sourcemap` file for debugging using the minified version.

## License

Even though you are not meant to copy this if doing a test; I'm not at all precious about it, and hey, it's not my test, just my stab at it.

The MIT License (MIT)

Copyright (c) 2015 Dave Sag

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

The file in the `brief` folder was supplied by [Cogent](http://www.cogent.co) and so naturally the copyright of that remains with Cogent. It is included here under "fair use" provisions of [section 40 of the Australian Copyright Act 1968](http://www.austlii.edu.au/au/legis/cth/consol_act/ca1968133/s40.html) to give context to the code base.
