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
var http_1 = require("@angular/http");
require("rxjs/add/operator/map");
var server_service_1 = require("./server.service");
var feeds_service_1 = require("./feeds.service");
var TorrentsService = (function () {
    function TorrentsService(serverService, feedsService, http) {
        this.serverService = serverService;
        this.feedsService = feedsService;
        this.http = http;
        console.log("TorrentsService created...");
    }
    TorrentsService.prototype.index = function (feed) {
        var url = this.serverService.getUrl() + feeds_service_1.FeedsService.path + "/" + feed.id + TorrentsService.path;
        // console.log("ESNUTH");
        return this.http.get(url, this.serverService.options()).map(function (res) { return res.json(); });
    };
    return TorrentsService;
}());
TorrentsService.path = '/torrents';
TorrentsService = __decorate([
    core_1.Injectable(),
    core_1.Component({}),
    __metadata("design:paramtypes", [server_service_1.ServerService, feeds_service_1.FeedsService, http_1.Http])
], TorrentsService);
exports.TorrentsService = TorrentsService;
//# sourceMappingURL=torrents.service.js.map