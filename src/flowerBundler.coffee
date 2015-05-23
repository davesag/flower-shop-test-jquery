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

  class Receipt
    constructor: (@request, @results) ->
      @total = @computeTotal
      return

    computeTotal: ->
      total = 0
      total += item.price * item.count for item in @results
      return total

    toFormatted: ->
      output = "#{@request} #{@toDollars(@total)}"
      for result in @results
        do ->
          output += "\n     #{result.count} x #{result.size} #{@toDollars(result.price)}"
      return output

    toDollars: (cents) ->
      return "$#{cents.toFixed(2)}"

  class BundleChooser
    constructor: (catalogue, request)->
      @order = Order.parse request
      @bundles = catalogue[@order.code]
      return

    choose: ->
      bundles = $.extend true, [], @bundles
      console.debug "Choosing", @order.size, "from", bundles
      return @chooseBundles(@order.size, bundles)

    chooseBundles: (flowerCount, bundles) ->
      console.debug "flowerCount", flowerCount
      console.debug "bundles", bundles
      console.debug "@bundles", @bundles
      @stash = []
      try
        @gatherBundles(flowerCount, bundles)
        return @stash
      catch
        bundles.shift()
        throw new Error("Can't make bundles from #{flowerCount} flowers") if bundles.length is 0
        @chooseBundles(flowerCount, bundles)

    gatherBundles: (flowerCount, bundles) ->
      allowedBundles = @trimBundles(flowerCount, bundles)
      bundle = allowedBundles[0]
      count = flowerCount / bundle.size
      @stash.push new Result(count, bundle)
      @gatherBundles(flowerCount - count * bundle.size, allowedBundles) unless flowerCount % bundle.size is 0
      return

    trimBundles: (flowerCount, bundles) ->
      allowedBundles = bundles.filter (bundle) ->
        return bundle.size > flowerCount
      throw new Error() if allowedBundles.length is 0
      return allowedBundles

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
        chooser = new BundleChooser(@options.catalogue, request)
        results = chooser.choose()
        receipt = new Receipt(request, results)
        $(@options.receiptSelector).append receipt.toFormatted()
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
