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
var core_1 = require('@angular/core');
var HumanizeBytesPipe = (function () {
    function HumanizeBytesPipe() {
    }
    HumanizeBytesPipe.prototype.transform = function (value, args) {
        return this.doIt(parseInt(value));
    };
    HumanizeBytesPipe.prototype.doIt = function (n) {
        if (n < 1024) {
            return n;
        }
        var si = ['KiB', 'MiB', 'GiB', 'TiB', 'PiB', 'HiB'];
        var exp = Math.floor(Math.log(n) / Math.log(1024));
        var result = n / Math.pow(1024, exp);
        var readable = (result % 1 > (1 / Math.pow(1024, exp - 1))) ? result.toFixed(2) : result.toFixed(0);
        return readable + si[exp - 1];
    };
    HumanizeBytesPipe = __decorate([
        core_1.Pipe({
            name: 'humanizeBytes'
        }), 
        __metadata('design:paramtypes', [])
    ], HumanizeBytesPipe);
    return HumanizeBytesPipe;
}());
exports.HumanizeBytesPipe = HumanizeBytesPipe;
//# sourceMappingURL=humanizeBytes.pipe.js.map