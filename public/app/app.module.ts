import {ModuleWithProviders, enableProdMode} from '@angular/core';
import {Routes, RouterModule} from '@angular/router';

import {FeedsComponent} from './components/feeds.component';
import {DashboardComponent} from './components/dashboard.component';

import {ServerService} from './services/server.service';
import {FeedsService} from './services/feeds.service';
import {TorrentsService} from './services/torrents.service';

import {MomentModule} from 'angular2-moment';

enableProdMode();


import { NgModule }      from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { FormsModule } from '@angular/forms';
import { HttpModule } from '@angular/http';

// const appRoutes: Routes = [
//     { path: '', component: HomeComponent },
//     { path: 'api', component: ApiComponent }
// ]
// const appRoutingProviders: any[] = [];
// const routing: ModuleWithProviders = RouterModule.forRoot(appRoutes);


@NgModule({
    imports: [
        BrowserModule,
        // routing,
        FormsModule,
        HttpModule,
		MomentModule
    ],       // module dependencies
    declarations: [
		DashboardComponent,
		FeedsComponent
    ],   // components and directives
    providers: [
        // appRoutingProviders,
        ServerService,
		FeedsService,
		TorrentsService
    ],                    // services
    bootstrap: [DashboardComponent]     // root component
})
export class AppModule {
}
