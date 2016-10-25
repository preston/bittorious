import {Directive, ElementRef, Renderer, Input} from '@angular/core';

@Directive({
	selector: '[highlight]'
})
export class HighlightDirective {

	@Input('highlightText') text: string = '';

	constructor(private el: ElementRef, private renderer: Renderer) {
		console.log("Highlighting!");
		this.el.nativeElement.textContent = 'foo';
	}

}
