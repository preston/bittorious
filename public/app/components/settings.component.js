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
var fhir_service_1 = require("../services/fhir.service");
var observation_service_1 = require("../services/observation.service");
var patient_model_1 = require("../models/patient.model");
var ObservationsComponent = (function () {
    function ObservationsComponent(fhirService, observationService) {
        this.fhirService = fhirService;
        this.observationService = observationService;
        this.observations = [];
        console.log("ObservationsComponent created...");
    }
    ObservationsComponent.prototype.ngOnChanges = function () {
        var _this = this;
        if (this.patient) {
            this.observationService.index(this.patient).subscribe(function (data) {
                if (data.entry) {
                    _this.observations = data.entry.map(function (r) { return r['resource']; });
                    console.log("Loaded " + _this.observations.length + " observations.");
                }
                else {
                    _this.observations = new Array();
                    console.log("No observations for patient.");
                }
            });
        }
    };
    return ObservationsComponent;
}());
__decorate([
    core_1.Input(),
    __metadata("design:type", typeof (_a = typeof patient_model_1.Patient !== "undefined" && patient_model_1.Patient) === "function" && _a || Object)
], ObservationsComponent.prototype, "patient", void 0);
ObservationsComponent = __decorate([
    core_1.Component({
        selector: 'settings',
        templateUrl: 'app/components/settings'
    }),
    __metadata("design:paramtypes", [typeof (_b = typeof fhir_service_1.FhirService !== "undefined" && fhir_service_1.FhirService) === "function" && _b || Object, typeof (_c = typeof observation_service_1.ObservationService !== "undefined" && observation_service_1.ObservationService) === "function" && _c || Object])
], ObservationsComponent);
exports.ObservationsComponent = ObservationsComponent;
var _a, _b, _c;
//# sourceMappingURL=settings.component.js.map