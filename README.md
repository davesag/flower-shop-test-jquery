# flower-bundler-jquery

Another version of the flowershop test but as a jQuery plugin

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

###To Build

```bash
grunt
```

This will output the final distribution files into the `dist/` folder, prefixed with `jquery` and suffixed with the version number you specify in `package.json`.

Files created are:

* `jquery-flowerBundler.1.0.0.js` - the 'developer' version.
* `jquery-flowerBundler.1.0.0.min.js` The minified version for production use.
* `jquery-flowerBundler.1.0.0.min.map` The `sourcemap` file for debugging using the minified version.
