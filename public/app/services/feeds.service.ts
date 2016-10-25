import {Component, Injectable} from '@angular/core';
import {Http, Headers} from '@angular/http';
import 'rxjs/add/operator/map';
import {Observable} from 'rxjs/Observable';

import {ServerService} from './server.service';
import {Feed} from '../models/feed.model';

@Injectable()
@Component({
})
export class FeedsService {

    public static path = '/feeds';
    private patients;

    constructor(private serverService: ServerService, private http: Http) {
        console.log("FeedsService created.");
    }

    index(): Observable<any> {
        var url = this.serverService.getUrl() + FeedsService.path;
        // this.http.get
        return this.http.get(url, this.serverService.options()).map(res => res.json());
    }

    get(feed: Feed): Observable<any> {
        var url = this.serverService.getUrl() + FeedsService.path + '/' + feed.id;
        return this.http.get(url, this.serverService.options()).map(res => res.json());
    }

}
