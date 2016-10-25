import {Component, Injectable} from '@angular/core';

import {Http} from '@angular/http';
import 'rxjs/add/operator/map';
import {Observable} from 'rxjs/Observable';

import {HealthCreekService} from './healthcreek.service';

@Injectable()
@Component({
})
export class ClientService {

	path = '/clients';

	constructor(private healthCreekService: HealthCreekService, private http: Http) {

	}

	public index(): Observable<Client> {
		var url = this.healthCreekService.getUrl() + this.path;
		var result = <Observable<Client>>this.http.get(url).map(res => res.json());
		return result;
	}

}
