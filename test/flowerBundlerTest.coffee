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
      @elements = $("#qunit-fixture").children(".qunit-container").children("input")
      @receipt = $("#receipt")

  # all jQuery plugins must be chainable.
  test "is chainable", ->
    strictEqual(@elements.flowerBundler(), @elements, "should be chainable")

  asyncTest "changing a Rose Order form field emits the correct receipt", ->
    target = @elements.first()
    target.flowerBundler()
    target.on "change", (evt) =>
      evt.preventDefault()
      ok @receipt.text().indexOf("10 R12") > -1, "Receipt did not contain the order"
      ok @receipt.text().indexOf("$12.99") > -1, "Receipt did not contain the total price"
      ok @receipt.text().indexOf("1 x 10 $12.99") > -1, "Receipt did not contain the correct receipt line"
      start()
    target.trigger "change"
    expect 3

) jQuery
