/* ==========================================================
 * bootstrap-twipsy.js v1.4.0
 * http://twitter.github.com/bootstrap/javascript.html#twipsy
 * Adapted from the original jQuery.tipsy by Jason Frame
 * ==========================================================
 * Copyright 2011 Twitter, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ========================================================== */


!function( $ ) {

  "use strict"

 /* CSS TRANSITION SUPPORT (https://gist.github.com/373874)
  * ======================================================= */

  var transitionEnd

  $(document).ready(function () {

    $.support.transition = (function () {
      var thisBody = document.body || document.documentElement
        , thisStyle = thisBody.style
        , support = thisStyle.transition !== undefined || thisStyle.WebkitTransition !== undefined || thisStyle.MozTransition !== undefined || thisStyle.MsTransition !== undefined || thisStyle.OTransition !== undefined
      return support
    })()

    // set CSS transition event type
    if ( $.support.transition ) {
      transitionEnd = "TransitionEnd"
      if ( $.browser.webkit ) {
      	transitionEnd = "webkitTransitionEnd"
      } else if ( $.browser.mozilla ) {
      	transitionEnd = "transitionend"
      } else if ( $.browser.opera ) {
      	transitionEnd = "oTransitionEnd"
      }
    }

  })


 /* TWIPSY PUBLIC CLASS DEFINITION
  * ============================== */

  var Twipsy = function ( element, options ) {
    this.$element = $(element)
    this.options = options
    this.enabled = true
    this.fixTitle()
  }

  Twipsy.prototype = {

    show: function() {
      var pos
        , actualWidth
        , actualHeight
        , placement
        , $tip
        , tp

      if (this.hasContent() && this.enabled) {
        $tip = this.tip()
        this.setContent()

        if (this.options.animate) {
          $tip.addClass('fade')
        }

        $tip
          .remove()
          .css({ top: 0, left: 0, display: 'block' })
          .prependTo(document.body)

        pos = $.extend({}, this.$element.offset(), {
          width: this.$element[0].offsetWidth
        , height: this.$element[0].offsetHeight
        })

        actualWidth = $tip[0].offsetWidth
        actualHeight = $tip[0].offsetHeight

        placement = maybeCall(this.options.placement, this, [ $tip[0], this.$element[0] ])

        switch (placement) {
          case 'below':
            tp = {top: pos.top + pos.height + this.options.offset, left: pos.left + pos.width / 2 - actualWidth / 2}
            break
          case 'above':
            tp = {top: pos.top - actualHeight - this.options.offset, left: pos.left + pos.width / 2 - actualWidth / 2}
            break
          case 'left':
            tp = {top: pos.top + pos.height / 2 - actualHeight / 2, left: pos.left - actualWidth - this.options.offset}
            break
          case 'right':
            tp = {top: pos.top + pos.height / 2 - actualHeight / 2, left: pos.left + pos.width + this.options.offset}
            break
        }

        $tip
          .css(tp)
          .addClass(placement)
          .addClass('in')
      }
    }

  , setContent: function () {
      var $tip = this.tip()
      $tip.find('.twipsy-inner')[this.options.html ? 'html' : 'text'](this.getTitle())
      $tip[0].className = 'twipsy'
    }

  , hide: function() {
      var that = this
        , $tip = this.tip()

      $tip.removeClass('in')

      function removeElement () {
        $tip.remove()
      }

      $.support.transition && this.$tip.hasClass('fade') ?
        $tip.bind(transitionEnd, removeElement) :
        removeElement()
    }

  , fixTitle: function() {
      var $e = this.$element
      if ($e.attr('title') || typeof($e.attr('data-original-title')) != 'string') {
        $e.attr('data-original-title', $e.attr('title') || '').removeAttr('title')
      }
    }

  , hasContent: function () {
      return this.getTitle()
    }

  , getTitle: function() {
      var title
        , $e = this.$element
        , o = this.options

        this.fixTitle()

        if (typeof o.title == 'string') {
          title = $e.attr(o.title == 'title' ? 'data-original-title' : o.title)
        } else if (typeof o.title == 'function') {
          title = o.title.call($e[0])
        }

        title = ('' + title).replace(/(^\s*|\s*$)/, "")

        return title || o.fallback
    }

  , tip: function() {
      return this.$tip = this.$tip || $('<div class="twipsy" />').html(this.options.template)
    }

  , validate: function() {
      if (!this.$element[0].parentNode) {
        this.hide()
        this.$element = null
        this.options = null
      }
    }

  , enable: function() {
      this.enabled = true
    }

  , disable: function() {
      this.enabled = false
    }

  , toggleEnabled: function() {
      this.enabled = !this.enabled
    }

  , toggle: function () {
      this[this.tip().hasClass('in') ? 'hide' : 'show']()
    }

  }


 /* TWIPSY PRIVATE METHODS
  * ====================== */

   function maybeCall ( thing, ctx, args ) {
     return typeof thing == 'function' ? thing.apply(ctx, args) : thing
   }

 /* TWIPSY PLUGIN DEFINITION
  * ======================== */

  $.fn.twipsy = function (options) {
    $.fn.twipsy.initWith.call(this, options, Twipsy, 'twipsy')
    return this
  }

  $.fn.twipsy.initWith = function (options, Constructor, name) {
    var twipsy
      , binder
      , eventIn
      , eventOut

    if (options === true) {
      return this.data(name)
    } else if (typeof options == 'string') {
      twipsy = this.data(name)
      if (twipsy) {
        twipsy[options]()
      }
      return this
    }

    options = $.extend({}, $.fn[name].defaults, options)

    function get(ele) {
      var twipsy = $.data(ele, name)

      if (!twipsy) {
        twipsy = new Constructor(ele, $.fn.twipsy.elementOptions(ele, options))
        $.data(ele, name, twipsy)
      }

      return twipsy
    }

    function enter() {
      var twipsy = get(this)
      twipsy.hoverState = 'in'

      if (options.delayIn == 0) {
        twipsy.show()
      } else {
        twipsy.fixTitle()
        setTimeout(function() {
          if (twipsy.hoverState == 'in') {
            twipsy.show()
          }
        }, options.delayIn)
      }
    }

    function leave() {
      var twipsy = get(this)
      twipsy.hoverState = 'out'
      if (options.delayOut == 0) {
        twipsy.hide()
      } else {
        setTimeout(function() {
          if (twipsy.hoverState == 'out') {
            twipsy.hide()
          }
        }, options.delayOut)
      }
    }

    if (!options.live) {
      this.each(function() {
        get(this)
      })
    }

    if (options.trigger != 'manual') {
      binder   = options.live ? 'live' : 'bind'
      eventIn  = options.trigger == 'hover' ? 'mouseenter' : 'focus'
      eventOut = options.trigger == 'hover' ? 'mouseleave' : 'blur'
      this[binder](eventIn, enter)[binder](eventOut, leave)
    }

    return this
  }

  $.fn.twipsy.Twipsy = Twipsy

  $.fn.twipsy.defaults = {
    animate: true
  , delayIn: 0
  , delayOut: 0
  , fallback: ''
  , placement: 'above'
  , html: false
  , live: false
  , offset: 0
  , title: 'title'
  , trigger: 'hover'
  , template: '<div class="twipsy-arrow"></div><div class="twipsy-inner"></div>'
  }

  $.fn.twipsy.rejectAttrOptions = [ 'title' ]

  $.fn.twipsy.elementOptions = function(ele, options) {
    var data = $(ele).data()
      , rejects = $.fn.twipsy.rejectAttrOptions
      , i = rejects.length

    while (i--) {
      delete data[rejects[i]]
    }

    return $.extend({}, options, data)
  }

}( window.jQuery || window.ender );



@import 'mixins';
@import 'shared';

.ui-autocomplete-loading {
  background: white url(<%= asset_path 'ui-anim_basic_16x16.gif' %>) right center no-repeat;
}

a.ui-corner-all {
  font-size:12px !important;
  font-family:Arial;
}

.facebook_login {
  width:150px;
  height:23px;
  background: url(<%= asset_path 'facebook_signin.png' %>) 0 0;
}

.facebook_register { display:none; margin-top:10px }

iframe.fb_ltr {
  width:430px !important;
  opacity:1;
}

.settings, .location, .event_types {
  @extend .settings_div;
  width: 30%;
}

.sort_div {
  @extend .settings_div;
}

.legend  {
  position:absolute;
  top: -29px;
  left: -90px;
  width: 300px;
  font-size:12px;
  display: none;

  div { display: inline-block; }

  .type {
    margin: 0 10px;
    color: black;
    .event_type, .special_type, .announcement_type {
      width: 15px;
      height: 15px;
      border: 1px solid black;
    }
  }
}

#wrapper.home {
  background: url(<%= asset_path 'downtown_new_paltz.jpg' %>) no-repeat 50% 80% fixed;
  width: 100%;
  height:100%;
  position: absolute;
  top:0;
  left:0;


  #logo {
    opacity:0.88;
    margin: 40px auto;
    width:550px;
    height:130px;
    background-color: white;
    border: 1px solid #666666;
    @include rounded(20px);

    img.logo {
      margin: 10px 15px;
      width:500px;
      height:110px;
    }
  }

  #content {
    a { color: white; }
    opacity:0.88;
    position:relative;
    margin: 40px auto;
    width:450px;
    height:300px;
    color:white;
    font-size:12px;
    text-align:center;
    background-color: black;
    border: 1px solid #666666;
    @include rounded(10px);

    .top_blurb {
      font-size:17px;
      margin-top:15px
    }

    .search {
      .text {
        font-size:110%;
        text-align:center;
      }
      margin-top: 12px;
      input {
        background-color: white;
        height: 24px;
        width:340px;
      }
    }

    .no_college_found {
      margin-top: 12px;
      display:none;

      .text, .notice {
        margin:4px auto;
        width:330px;
      }
      #notify_email {
        width:180px;
        line-height:17px;
      }
      #notify_me {
        margin-left:6px;
        line-height:15px;
        @include rounded(10px);
      }
    }

    .college_found {
      display:none;
      margin: 14px auto;
      height: 30px;
      .text {
        color:white;
        margin: 10px;
      }
      a.button { padding: 3px 10px; }
      .link {
        vertical-align:top;
        display: inline-block;
        margin: 0 10px !important;
      }
    }

    .business_users {
      font-size:125%;
      margin-top: 45%;
    }
  }

}




#content.consumer_events {
  @extend .body_size;
  margin: 30px auto;
}

.event_list_header {
  @include text_inset;
  width:96%;
  min-width: 400px;
  text-align: left;
  color: white;
  background-color: black;
  border: 1px solid #666666;
  height: 30px;
  padding: 3px 0px 5px 15px;
  border-top-right-radius: 8px;
  -moz-border-radius-topright: 8px;
  -webkit-border-top-right-radius: 8px;
  border-top-left-radius: 8px;
  -moz-border-radius-topleft: 8px;
  -webkit-border-top-left-radius: 8px;

  .title {
    display: inline-block;
    width: 30%;
    font-size: 140%;
    line-height: 35px;
  }

  .wrapper_links {
    vertical-align: top;
    display: inline-block;
    width: 60%;
    margin: 0;
    padding: 0;
    .link_div {
      text-align: right;
    }
    .sort_div {
      text-align: right;
      width: 80%;
    }
  }

}

#event_list_container {
  margin: 0 5% 0 0;
  width: 46%;
  min-width: 400px;
  height: 490px;
  vertical-align: top;
  display: inline-block;
}

#event_list_inner {
  width: 100%;

  #event_list {
    width: 100%;
	  height: 470px;
	  overflow: auto;
    position: relative;
  }
}

.event_bar {
  border: 1px solid #666666;
  display:inline-block;
}

.day_header {
  width:99%;
  height: 22px;
  font-size: 120%;
  @extend .event_bar;
  background-color: #cccccc;
  text-align: center;
  vertical-align: middle;
  padding: 6px 0px 3px 0px;
}

ul, li {
  list-style-type: none;
}

.event_type_bar {
  position: absolute;
  top: 0;
  left: 0;
  bottom: 0;
  width: 3%;
  border-right: 1px solid #666666;
}

.hover {
  background-color: rgba(255, 245, 225, 0.43);
  cursor: hand;
 }

.event {
  position: relative;
  @extend .event_bar;
  width:99%;

  .wrapper {
    position:relative;
    display: inline-block;
    width: 98%;

    .info_bar {
      width: 100%;
      margin: 4px 0px 4px 18px;

      .business_img {
        text-align: center;
        width: 5%;
        display: inline-block;
        img { width:27px; height:30px }
      }

      .info {
        margin-top: 3px;
        margin-bottom: 3px;
        width: 69%;
        display:inline-block;
        .business_name_wrapper {
          .business_name {
            display: inline-block;
            width: 78%;
          }
          .start_hour {
            display: inline;
            width: 23%;
          }
          .am_pm { display: inline; font-size: 80% }
        }
        .title {
          font-weight: bold;
        }
      }

      .images {
        width:22%;
        display: inline-block;
        font-size: 9px;
        text-align: center;
        vertical-align: top;
        margin-top: 4px;

        .vote, .fave {
          display: inline-block;
          width: 22px;
          vertical-align: top;
          margin-right: 2%;
          img {
            width: 26px;
            height: 26px;
            cursor: pointer;
            margin-right: 10px;
          }
        }
        .fave { margin-right: 6%; }
      }
    }

    .description {
      width: 99%;
      display: none;
      margin: 6px 0px 7px 23px;
    }

  }

}

.full { width:90% !important; }


#map_canvas_container {
  width: 48%;
  display: inline-block;
  position: relative;

  .filter {
    position: absolute;
    top: 0px;
    left: 0px;
    width:150px;
    z-index: 1000;
    border: 1px solid gray;
    background-color: #ccc;
    padding: 5px 12px 9px 5px;
    display: none;

    div { display:inline-block; }

    .group {
      width: 100%;
      font-size: 115%;
      margin: 3px;

      .img {
        vertical-align: top;
        img { width:30px; height:30px; }
      }

      .item {
        text-align: left;
        line-height: 30px;
        margin: 2px 0px;
        padding-left: 6px;
        width: 51%;
      }
    }
  }

  .search {
    position:absolute;
    top: -30px;
    left: -30px;
    z-index: 1000;
    width: 420px;
    display:none;

    input {
      background-color: white;
      height: 24px;
      width:340px;
    }
  }

  #map_canvas {
    width: 100%;
    height: 500px;
    border: 1px solid #666666;
  }
}

.business {
  padding: 10px 0px 0px 5%;
  border-right: 1px solid #666666;
  border-left: 1px solid #666666;
  width: 94%;

  .info {
    width:48%;
    vertical-align:top;
    display:inline-block;
  }

  .hours {
    width:44%;
    padding-left:25px;
    display:inline-block;

    .bold { font-weight: bold }
    .line {
      .day_name {
        display:inline-block;
        width:20px;
      }
      .from_to {
        display:inline-block;
      }
    }
  }

  .close {
    position:absolute;
    top: 2px;
    right: 8px;
    cursor:pointer;
  }
}

