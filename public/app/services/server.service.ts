import {Component, Injectable} from '@angular/core';
import {Headers, RequestOptions} from '@angular/http';

@Injectable()
export class ServerService {

	// private root = 'http://localhost:3000';
	private root = '';

	getUrl(): string {
		return this.root;
	}

	search(text: string): Object[] {
		return [];
	}

	options(): RequestOptions {
		let headers = new Headers({ 'Accept': 'application/json' });
		return new RequestOptions({ headers: headers });
	}

}
