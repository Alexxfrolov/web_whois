// modules are defined as an array
// [ module function, map of requires ]
//
// map of requires is short require name -> numeric require
//
// anything defined in a previous bundle is accessed via the
// orig method which is the require for previous bundles
parcelRequire = (function (modules, cache, entry, globalName) {
  // Save the require from previous bundle to this closure if any
  var previousRequire = typeof parcelRequire === 'function' && parcelRequire;
  var nodeRequire = typeof require === 'function' && require;

  function newRequire(name, jumped) {
    if (!cache[name]) {
      if (!modules[name]) {
        // if we cannot find the module within our internal map or
        // cache jump to the current global require ie. the last bundle
        // that was added to the page.
        var currentRequire = typeof parcelRequire === 'function' && parcelRequire;
        if (!jumped && currentRequire) {
          return currentRequire(name, true);
        }

        // If there are other bundles on this page the require from the
        // previous one is saved to 'previousRequire'. Repeat this as
        // many times as there are bundles until the module is found or
        // we exhaust the require chain.
        if (previousRequire) {
          return previousRequire(name, true);
        }

        // Try the node require function if it exists.
        if (nodeRequire && typeof name === 'string') {
          return nodeRequire(name);
        }

        var err = new Error('Cannot find module \'' + name + '\'');
        err.code = 'MODULE_NOT_FOUND';
        throw err;
      }

      localRequire.resolve = resolve;
      localRequire.cache = {};

      var module = cache[name] = new newRequire.Module(name);

      modules[name][0].call(module.exports, localRequire, module, module.exports, this);
    }

    return cache[name].exports;

    function localRequire(x) {
      return newRequire(localRequire.resolve(x));
    }

    function resolve(x) {
      return modules[name][1][x] || x;
    }
  }

  function Module(moduleName) {
    this.id = moduleName;
    this.bundle = newRequire;
    this.exports = {};
  }

  newRequire.isParcelRequire = true;
  newRequire.Module = Module;
  newRequire.modules = modules;
  newRequire.cache = cache;
  newRequire.parent = previousRequire;
  newRequire.register = function (id, exports) {
    modules[id] = [function (require, module) {
      module.exports = exports;
    }, {}];
  };

  var error;
  for (var i = 0; i < entry.length; i++) {
    try {
      newRequire(entry[i]);
    } catch (e) {
      // Save first error but execute all entries
      if (!error) {
        error = e;
      }
    }
  }

  if (entry.length) {
    // Expose entry point to Node, AMD or browser globals
    // Based on https://github.com/ForbesLindesay/umd/blob/master/template.js
    var mainExports = newRequire(entry[entry.length - 1]);

    // CommonJS
    if (typeof exports === "object" && typeof module !== "undefined") {
      module.exports = mainExports;

      // RequireJS
    } else if (typeof define === "function" && define.amd) {
      define(function () {
        return mainExports;
      });

      // <script>
    } else if (globalName) {
      this[globalName] = mainExports;
    }
  }

  // Override the current require with this new one
  parcelRequire = newRequire;

  if (error) {
    // throw error from earlier, _after updating parcelRequire_
    throw error;
  }

  return newRequire;
})({
  "kUj2": [function (require, module, exports) {
    function _classCallCheck(instance, Constructor) {
      if (!(instance instanceof Constructor)) {
        throw new TypeError("Cannot call a class as a function");
      }
    }

    module.exports = _classCallCheck;
  }, {}],
  "fgVH": [function (require, module, exports) {
    "use strict"; // class ScrollToElement {
    //   constructor(el, duration) {
    //     this.trigger = el
    //     this.duration = duration
    //     this.menuHeight = $("#js-menu").outerHeight()
    //   }
    //   init() {
    //     const { duration, menuHeight } = this
    //     this.trigger.on("click", function(e) {
    //       e.preventDefault()
    //       const dest = $(this).attr("href")
    //       $("html, body").animate(
    //         {
    //           scrollTop: $(dest).offset().top - menuHeight,
    //         },
    //         duration,
    //       )
    //     })
    //   }
    // }

    var _classCallCheck2 = _interopRequireDefault(require("@babel/runtime/helpers/classCallCheck"));

    function _interopRequireDefault(obj) {
      return obj && obj.__esModule ? obj : {
        default: obj
      };
    }

    var Tabs = function Tabs() {
      var _this = this;

      (0, _classCallCheck2.default)(this, Tabs);

      this.checkSelected = function (tab) {
        return tab.getAttribute("aria-selected") === "true" ? true : false;
      };

      this.changeTab = function (tab) {
        var tabs = _this.tabs;
        tabs.forEach(function (tab) {
          tab.setAttribute("aria-selected", "false");
        });
        tab.setAttribute("aria-selected", "true");
      };

      this.changeTablist = function (tab) {
        var tabpanels = _this.tabpanels;
        tabpanels.forEach(function (tabpanel) {
          tabpanel.style.display = "none";
        });
        var currentTabpanel = document.getElementById(tab.getAttribute("aria-controls"));
        currentTabpanel.style.display = "block";
      };

      this.init = function () {
        var self = _this;
        var tabs = _this.tabs,
          tabpanels = _this.tabpanels;
        tabs.forEach(function (tab) {
          tab.addEventListener("click", function () {
            var isSelected = self.checkSelected(tab);

            if (isSelected) {
              return;
            }

            self.changeTab(tab);
            self.changeTablist(tab);
          });
        });
      };

      this.tabs = Array.from(document.querySelectorAll(".js-tab"));
      this.activeTab = document.querySelector("[aria-selected=true]");
      this.tabpanels = Array.from(document.querySelectorAll("[role=tabpanel]"));
    };

    var Expand = function Expand() {
      var _this = this;

      (0, _classCallCheck2.default)(this, Expand);

      this.init = function () {
        var button = _this.button;
        var target = _this.target;
        var activeCls = _this.activeCls;
        if (!button) {
          return;
        }
        button.addEventListener('click', function () {
          var expanded = target.classList.contains(activeCls);
          if (expanded) {
            target.classList.remove(activeCls);
            return;
          }

          target.classList.add(activeCls);
          button.style.display = 'none'
        })
      };

      this.button = document.getElementById("js-expand");
      this.target = this.button ? document.getElementById(this.button.dataset.target) : null
      this.activeCls = 'expanded'
    };

    window.addEventListener("load", function () {
      var tabs = new Tabs();
      var expand = new Expand();
      tabs.init();
      expand.init();
    });
  }, {
    "@babel/runtime/helpers/classCallCheck": "kUj2"
  }]
}, {}, ["fgVH"], null)
