"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var core_1 = require("@angular/core");
var feeds_service_1 = require("../services/feeds.service");
var FeedsComponent = (function () {
    function FeedsComponent(feedsService, compiler) {
        this.feedsService = feedsService;
        this.compiler = compiler;
        this.feeds = [];
        console.log("FeedsComponent initializing..");
        this.compiler.clearCache();
        this.loadFeeds();
    }
    FeedsComponent.prototype.loadFeeds = function () {
        var _this = this;
        this.feedsService.index().subscribe(function (data) {
            _this.feeds = data; //.entry.map(r => r['resource']);
            console.log("Loaded " + _this.feeds.length + " feeds.");
            if (_this.feeds.length > 0) {
                _this.select(_this.feeds[0].id);
            }
        });
    };
    FeedsComponent.prototype.select = function (id) {
        var _this = this;
        console.log("Selecting feed: " + id);
        var f = this.feedFor(id);
        this.feedsService.get(f).subscribe(function (d) {
            console.log("Fetching: " + d);
            _this.selected = d;
        });
    };
    FeedsComponent.prototype.feedFor = function (id) {
        var obj = null;
        for (var _i = 0, _a = this.feeds; _i < _a.length; _i++) {
            var f = _a[_i];
            if (f.id == id) {
                obj = f;
                break;
            }
        }
        return obj;
    };
    return FeedsComponent;
}());
FeedsComponent = __decorate([
    core_1.Component({
        selector: 'feeds',
        templateUrl: 'app/components/feeds.html'
    }),
    __metadata("design:paramtypes", [feeds_service_1.FeedsService, core_1.Compiler])
], FeedsComponent);
exports.FeedsComponent = FeedsComponent;
//# sourceMappingURL=feeds.component.js.map