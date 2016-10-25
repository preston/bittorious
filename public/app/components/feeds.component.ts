import {Component, Compiler} from '@angular/core';

import {FeedsService} from '../services/feeds.service';

import {Feed} from '../models/feed.model';
import {Torrent} from '../models/torrent.model';

@Component({
    selector: 'feeds',
    templateUrl: 'app/components/feeds.html'
})
export class FeedsComponent {

    selected: Feed;
    feeds: Array<Feed> = [];

    constructor(private feedsService: FeedsService, private compiler: Compiler) {

        console.log("FeedsComponent initializing..");
        this.compiler.clearCache();
        this.loadFeeds();
    }

    loadFeeds() {
        this.feedsService.index().subscribe(data => {
            this.feeds = <Array<Feed>>data; //.entry.map(r => r['resource']);
            console.log("Loaded " + this.feeds.length + " feeds.");
            if (this.feeds.length > 0) {
                this.select(this.feeds[0].id);
            }
        });
    }


    select(id: string) {
        console.log("Selecting feed: " + id);
		let f = this.feedFor(id);
        this.feedsService.get(f).subscribe(d => {
            console.log("Fetching: " + d);
            this.selected = <Feed>d;
        });
    }

    feedFor(id: string): Feed {
        var obj: Feed = null;
        for (let f of this.feeds) {
            if (f.id == id) {
                obj = f;
                break;
            }
        }
        return obj;
    }

}
