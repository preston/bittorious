import {Component} from '@angular/core';

@Component({
    selector: 'dashboard',
    templateUrl: '/dashboard_component.html'
})
export class DashboardComponent {

    constructor() {
        console.log("DashboardComponent has been initialized.");
    }

}
