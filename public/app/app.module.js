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
var feeds_component_1 = require("./components/feeds.component");
var dashboard_component_1 = require("./components/dashboard.component");
var server_service_1 = require("./services/server.service");
var feeds_service_1 = require("./services/feeds.service");
var torrents_service_1 = require("./services/torrents.service");
var angular2_moment_1 = require("angular2-moment");
core_1.enableProdMode();
var core_2 = require("@angular/core");
var platform_browser_1 = require("@angular/platform-browser");
var forms_1 = require("@angular/forms");
var http_1 = require("@angular/http");
// const appRoutes: Routes = [
//     { path: '', component: HomeComponent },
//     { path: 'api', component: ApiComponent }
// ]
// const appRoutingProviders: any[] = [];
// const routing: ModuleWithProviders = RouterModule.forRoot(appRoutes);
var AppModule = (function () {
    function AppModule() {
    }
    return AppModule;
}());
AppModule = __decorate([
    core_2.NgModule({
        imports: [
            platform_browser_1.BrowserModule,
            // routing,
            forms_1.FormsModule,
            http_1.HttpModule,
            angular2_moment_1.MomentModule
        ],
        declarations: [
            dashboard_component_1.DashboardComponent,
            feeds_component_1.FeedsComponent
        ],
        providers: [
            // appRoutingProviders,
            server_service_1.ServerService,
            feeds_service_1.FeedsService,
            torrents_service_1.TorrentsService
        ],
        bootstrap: [dashboard_component_1.DashboardComponent] // root component
    }),
    __metadata("design:paramtypes", [])
], AppModule);
exports.AppModule = AppModule;
//# sourceMappingURL=app.module.js.map