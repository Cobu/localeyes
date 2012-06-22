function Shared() {

  this.clock = null;
  this.server = null;
  this.view = null;

  this.setUp = function (html,data) {
    this.clock = sinon.useFakeTimers();
    if (html) loadFixtures(html)
    this.view = window.consumer_events_view = new App.View.ConsumerEventsView().render()
    if (data) this.view.reset(data);
  }

  this.setUpServer = function () {
    this.server = sinon.fakeServer.create();
  }

  this.restoreClock = function () {
    this.clock.restore();
  }

  this.tick = function (ms) {
    this.clock.tick(ms);
  }
}