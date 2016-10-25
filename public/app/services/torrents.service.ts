import {Component, Injectable} from '@angular/core';
import {Http, Headers} from '@angular/http';
import 'rxjs/add/operator/map';
import {Observable} from 'rxjs/Observable';

import {ServerService} from './server.service';
import {FeedsService} from './feeds.service';
import {Torrent} from '../models/torrent.model';
import {Feed} from '../models/feed.model';

@Injectable()
@Component({
})
export class TorrentsService {

    public static path = '/torrents';

    constructor(private serverService: ServerService, private feedsService: FeedsService, private http: Http) {
        console.log("TorrentsService created...");
    }

    index(feed: Feed): Observable<any> {
        var url = this.serverService.getUrl() + FeedsService.path + "/" + feed.id + TorrentsService.path;
		// console.log("ESNUTH");
        return this.http.get(url, this.serverService.options()).map(res => res.json());
    }

    // get(id): Observable<any> {
    //     var url = this.fhirService.getUrl() + this.path + '/' + id;
    //     return this.http.get(url, this.fhirService.options()).map(res => res.json());
    // }

}
