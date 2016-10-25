import {Directive, ElementRef, Renderer} from '@angular/core';

@Directive({
	selector: '[autoGrow]',
	host: {
		'(focus)': 'onFocus()',
		'(blur)': 'onBlur()'
	}
})
export class AutoGrowDirective {

	constructor(private el: ElementRef, private renderer: Renderer) {
	}

	onFocus() {
		// console.log('focus!');
		this.renderer.setElementStyle(this.el.nativeElement, 'width', '200px');
	}
	 onBlur() {
		//  console.log('blur');
		 this.renderer.setElementStyle(this.el.nativeElement, 'width', '120px');
	 }
}
