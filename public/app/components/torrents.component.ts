import {Component, Input} from '@angular/core';
import {ServerService} from '../services/server.service';
// import {PatientService} from '../services/patient.service';
import {Torrent} from '../models/torrent.model';

@Component({
    selector: 'torrents',
    templateUrl: 'app/components/torrents'
})
export class TorrentsComponent {

    selected: Torrent;
    activities: Array<Torrent>;
    @Input() torrent: Torrent;

    constructor(private serverService: ServerService) {
        console.log("ActivityService created...");
    }

}
