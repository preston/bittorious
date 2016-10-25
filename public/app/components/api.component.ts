import {Component} from '@angular/core';

import {HealthCreekService} from '../services/healthcreek.service';
import {SearchService} from '../services/search.service';

@Component({
    selector: 'api',
    templateUrl: 'app/components/api.html'
})
export class ApiComponent {

    constructor(private healthCreekService: HealthCreekService) {
        console.log("ApiComponent has been initialized.");
    }

    stringify(obj: any): string {
        return JSON.stringify(obj, null, "\t").trim();
    }

}
