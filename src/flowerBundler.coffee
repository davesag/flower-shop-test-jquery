###
  The flowerBundler plugin is applied to one or more form elements that
  ought to contain valid flower order codes.
  When a change event is fired the plugin computes the correct
  combination of flower bundles and injects a receipt text
  into a div with id = 'receipt'

  You can provide the following options
  * `event` the event which triggers the calculation
  * `receiptSelector` the selector for the receipt text to be injected into
###

(($) ->
  class Bundle
    constructor: (@size, @price) ->
      return

  class Order
    constructor: (@size, @code) ->
      return

    @parse: (request) ->
      order = request.split " "
      return new Order(parseInt(order[0]), order[1])

  class Result
    constructor: (@count, bundle) ->
      @size = bundle.size
      @price = bundle.price
      return

    decrementCount: ->
      @count--
      return

  class Receipt
    constructor: (@request, @results) ->
      @total = @computeTotal()
      return

    computeTotal: ->
      total = 0
      total += item.price * item.count for item in @results
      return total

    toFormatted: ->
      output = "#{@request} #{@toDollars(@total)}"
      for result in @results
        do =>
          output += "\n     #{result.count} x #{result.size} #{@toDollars(result.price)}"
      return "<pre>#{output}</pre>"

    toDollars: (cents) ->
      dollars = cents / 100.0
      return "$#{(dollars).toFixed(2)}"

  class BundleChooser
    constructor: (catalogue, request)->
      @order = Order.parse request
      @bundles = catalogue[@order.code]
      throw new Error("Unknown Flower Code") if @bundles is undefined
      return

    choose: ->
      return @chooseBundles(@order.size, @bundles.slice())

    chooseBundles: (flowerCount, bundles) ->
      @stash = []
      try
        @gatherBundles(flowerCount, bundles)
        return @stash
      catch
        bundles.shift()
        throw new Error("Can't make bundles from #{flowerCount} flowers") if bundles.length is 0
        @chooseBundles(flowerCount, bundles)

    gatherBundles: (flowerCount, bundles) ->
      @trimBundles(flowerCount, bundles)
      @bundle = @allowedBundles[0]
      @count = Math.floor(flowerCount / @bundle.size)
      @stash.push new Result(@count, @bundle)
      @gatherBundles(@recount(flowerCount), @allowedBundles) unless flowerCount % @bundle.size is 0
      return

    trimBundles: (flowerCount, bundles) ->
      @allowedBundles = bundles.filter (bundle) ->
        return flowerCount >= bundle.size
      throw new Error() if @allowedBundles.length is 0
      return

    recount: (flowerCount) ->
      fc = flowerCount - @count * @bundle.size
      return if fc < @allowedBundles[@allowedBundles.length - 1].size
        @adjustedCount(flowerCount)
      else
        fc

    adjustedCount: (flowerCount) ->
      @checkRemainders()
      last = @stash[@stash.length - 1]
      last.decrementCount()
      @allowedBundles.shift()
      return flowerCount - last.count * @bundle.size
    
    checkRemainders: ->
      throw new Error() if @count is 1 or @allowedBundles.length is 1
      return

  # Main jQuery Collection method.
  $.fn.flowerBundler = (options) ->
    opts = $.extend true, {}, $.fn.flowerBundler.options
    @options = if typeof options is "object"
      $.extend(true, opts, options)
    else
      opts
    @each =>
      $(@).on @options.event, (evt) =>
        request = $(evt.target).val()
        try
          chooser = new BundleChooser(@options.catalogue, request)
          results = chooser.choose()
          receipt = new Receipt(request, results)
          $(@options.receiptSelector).html receipt.toFormatted()
        catch err
          $(@options.receiptSelector).html "<p>#{err}</p>"
      return @ # because it's chainable.

  # defaults
  $.fn.flowerBundler.options =
    receiptSelector: "#receipt"
    event: "change"
    catalogue:
      R12: [
        new Bundle(10,1299)
        new Bundle(5, 699)
      ]
      L09: [
        new Bundle(9,2495)
        new Bundle(6,1695)
        new Bundle(3, 995)
      ]
      T58: [
        new Bundle(9,1699)
        new Bundle(5, 995)
        new Bundle(3, 595)
      ]

) jQuery
