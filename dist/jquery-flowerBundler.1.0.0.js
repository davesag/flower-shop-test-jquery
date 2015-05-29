/*!
 * The Cogent Flower Shop Test - v1.0.0 - 2015-05-29
 * https://github.com/davesag/flower-shop-test-jquery
 * Copyright (c) 2015 Dave Sag; Licensed MIT
 */
(function() {
  if (typeof jQuery === "undefined") {
    throw "Expected jQuery to have been loaded before this script.";
  }

}).call(this);

(function() {
  (function($) {
    var Bundle, BundleChooser, Order, Receipt, Result;
    Bundle = (function() {
      function Bundle(size, price) {
        this.size = size;
        this.price = price;
        return;
      }

      return Bundle;

    })();
    Order = (function() {
      function Order(size, code) {
        this.size = size;
        this.code = code;
        return;
      }

      Order.parse = function(request) {
        var order;
        order = request.split(" ");
        return new Order(parseInt(order[0]), order[1]);
      };

      return Order;

    })();
    Result = (function() {
      function Result(count, bundle) {
        this.count = count;
        this.size = bundle.size;
        this.price = bundle.price;
        return;
      }

      Result.prototype.decrementCount = function() {
        this.count--;
      };

      return Result;

    })();
    Receipt = (function() {
      function Receipt(request, results) {
        this.request = request;
        this.results = results;
        this.total = this.computeTotal();
        return;
      }

      Receipt.prototype.computeTotal = function() {
        var item, total, _i, _len, _ref;
        total = 0;
        _ref = this.results;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          item = _ref[_i];
          total += item.price * item.count;
        }
        return total;
      };

      Receipt.prototype.toFormatted = function() {
        var output, result, _fn, _i, _len, _ref;
        output = "" + this.request + " " + (this.toDollars(this.total));
        _ref = this.results;
        _fn = (function(_this) {
          return function() {
            return output += "\n     " + result.count + " x " + result.size + " " + (_this.toDollars(result.price));
          };
        })(this);
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          result = _ref[_i];
          _fn();
        }
        return "<pre>" + output + "</pre>";
      };

      Receipt.prototype.toDollars = function(cents) {
        var dollars;
        dollars = cents / 100.0;
        return "$" + (dollars.toFixed(2));
      };

      return Receipt;

    })();
    BundleChooser = (function() {
      function BundleChooser(catalogue, request) {
        this.order = Order.parse(request);
        this.bundles = catalogue[this.order.code];
        if (this.bundles === void 0) {
          throw new Error("Unknown Flower Code");
        }
        return;
      }

      BundleChooser.prototype.choose = function() {
        return this.chooseBundles(this.order.size, this.bundles.slice());
      };

      BundleChooser.prototype.chooseBundles = function(flowerCount, bundles) {
        this.stash = [];
        try {
          this.gatherBundles(flowerCount, bundles);
          return this.stash;
        } catch (_error) {
          bundles.shift();
          if (bundles.length === 0) {
            throw new Error("Can't make bundles from " + flowerCount + " flowers");
          }
          return this.chooseBundles(flowerCount, bundles);
        }
      };

      BundleChooser.prototype.gatherBundles = function(flowerCount, bundles) {
        this.trimBundles(flowerCount, bundles);
        this.bundle = this.allowedBundles[0];
        this.count = Math.floor(flowerCount / this.bundle.size);
        this.stash.push(new Result(this.count, this.bundle));
        if (flowerCount % this.bundle.size !== 0) {
          this.gatherBundles(this.recount(flowerCount), this.allowedBundles);
        }
      };

      BundleChooser.prototype.trimBundles = function(flowerCount, bundles) {
        this.allowedBundles = bundles.filter(function(bundle) {
          return flowerCount >= bundle.size;
        });
        if (this.allowedBundles.length === 0) {
          throw new Error();
        }
      };

      BundleChooser.prototype.recount = function(flowerCount) {
        var fc;
        fc = flowerCount - this.count * this.bundle.size;
        if (fc < this.allowedBundles[this.allowedBundles.length - 1].size) {
          return this.adjustedCount(flowerCount);
        } else {
          return fc;
        }
      };

      BundleChooser.prototype.adjustedCount = function(flowerCount) {
        var last;
        this.checkRemainders();
        last = this.stash[this.stash.length - 1];
        last.decrementCount();
        this.allowedBundles.shift();
        return flowerCount - last.count * this.bundle.size;
      };

      BundleChooser.prototype.checkRemainders = function() {
        if (this.count === 1 || this.allowedBundles.length === 1) {
          throw new Error();
        }
      };

      return BundleChooser;

    })();
    $.fn.flowerBundler = function(options) {
      var opts;
      opts = $.extend(true, {}, $.fn.flowerBundler.options);
      this.options = typeof options === "object" ? $.extend(true, opts, options) : opts;
      return this.each((function(_this) {
        return function() {
          $(_this).on(_this.options.event, function(evt) {
            var chooser, err, receipt, request, results;
            request = $(evt.target).val();
            try {
              chooser = new BundleChooser(_this.options.catalogue, request);
              results = chooser.choose();
              receipt = new Receipt(request, results);
              return $(_this.options.receiptSelector).html(receipt.toFormatted());
            } catch (_error) {
              err = _error;
              return $(_this.options.receiptSelector).html("<p>" + err + "</p>");
            }
          });
          return _this;
        };
      })(this));
    };
    return $.fn.flowerBundler.options = {
      receiptSelector: "#receipt",
      event: "change",
      catalogue: {
        R12: [new Bundle(10, 1299), new Bundle(5, 699)],
        L09: [new Bundle(9, 2495), new Bundle(6, 1695), new Bundle(3, 995)],
        T58: [new Bundle(9, 1699), new Bundle(5, 995), new Bundle(3, 595)]
      }
    };
  })(jQuery);

}).call(this);
