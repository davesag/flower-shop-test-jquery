(($) ->
  ###
    ======== A Handy Little QUnit Reference ========
    http://api.qunitjs.com/

    Test methods:
      module(name, {[setup][ ,teardown]})
      test(name, callback)
      expect(numberOfAssertions)
      stop(increment)
      start(decrement)
    Test assertions:
      ok(value, [message])
      equal(actual, expected, [message])
      notEqual(actual, expected, [message])
      deepEqual(actual, expected, [message])
      notDeepEqual(actual, expected, [message])
      strictEqual(actual, expected, [message])
      notStrictEqual(actual, expected, [message])
      throws(block, [expected], [message])
  ###

  QUnit.skipTest = ->
    QUnit.test "#{arguments[0]} (SKIPPED)", ->
      QUnit.expect 0 # dont expect any tests
      $li = $("##{QUnit.config.current.id}")
      QUnit.done ->
        $li.css "background", "#FFFF99"
  skipTest = QUnit.skipTest

  module "simple tests",

    setup: ->
      @receipt = $("#receipt")
      @receipt.empty()

  asyncTest "changing a Rose Order form field emits the correct receipt", ->
    target = $("#rose10")
    target.flowerBundler()
    target.on "change", (evt) =>
      evt.preventDefault()
      ok @receipt.text().indexOf("10 R12") > -1, "Receipt did not contain the order"
      ok @receipt.text().indexOf("$12.99") > -1, "Receipt did not contain the total price"
      ok @receipt.text().indexOf("1 x 10 $12.99") > -1, "Receipt did not contain the correct receipt line"
      start()
    target.trigger "change"
    expect 3

  asyncTest "changing a Lily Order form field emits the correct receipt", ->
    target = $("#lily15")
    target.flowerBundler()
    target.on "change", (evt) =>
      evt.preventDefault()
      ok @receipt.text().indexOf("15 L09") > -1, "Receipt did not contain the order"
      ok @receipt.text().indexOf("$41.90") > -1, "Receipt did not contain the total price"
      ok @receipt.text().indexOf("1 x 9 $24.95") > -1, "Receipt did not contain the first correct receipt line"
      ok @receipt.text().indexOf("1 x 6 $16.95") > -1, "Receipt did not contain the second correct receipt line"
      start()
    target.trigger "change"
    expect 4

  asyncTest "changing a Tulip Order form field emits the correct receipt", ->
    target = $("#tulip13")
    target.flowerBundler()
    target.on "change", (evt) =>
      evt.preventDefault()
      ok @receipt.text().indexOf("13 T58") > -1, "Receipt did not contain the order"
      ok @receipt.text().indexOf("$25.85") > -1, "Receipt did not contain the total price"
      ok @receipt.text().indexOf("2 x 5 $9.95") > -1, "Receipt did not contain the first correct receipt line"
      ok @receipt.text().indexOf("1 x 3 $5.95") > -1, "Receipt did not contain the second correct receipt line"
      start()
    target.trigger "change"
    expect 4

  asyncTest "changing a Tulip Order form field emits the correct receipt", ->
    target = $("#tulip16")
    target.flowerBundler()
    target.on "change", (evt) =>
      evt.preventDefault()
      ok @receipt.text().indexOf("16 T58") > -1, "Receipt did not contain the order"
      ok @receipt.text().indexOf("$31.80") > -1, "Receipt did not contain the total price"
      ok @receipt.text().indexOf("2 x 5 $9.95") > -1, "Receipt did not contain the first correct receipt line"
      ok @receipt.text().indexOf("2 x 3 $5.95") > -1, "Receipt did not contain the second correct receipt line"
      start()
    target.trigger "change"
    expect 4

) jQuery
