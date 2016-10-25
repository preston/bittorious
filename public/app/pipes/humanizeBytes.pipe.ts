import {Pipe, PipeTransform} from '@angular/core';

@Pipe({
    name: 'humanizeBytes'
})
export class HumanizeBytesPipe implements PipeTransform {

    transform(value: string, args: string[]) {
        return this.doIt(parseInt(value));
    }

    doIt(n): string {
        if (n < 1024) {
            return n;
        }
        var si = ['KiB', 'MiB', 'GiB', 'TiB', 'PiB', 'HiB'];
        var exp = Math.floor(Math.log(n) / Math.log(1024));
        var result: number = n / Math.pow(1024, exp);
        var readable: string = (result % 1 > (1 / Math.pow(1024, exp - 1))) ? result.toFixed(2) : result.toFixed(0);
        return readable + si[exp - 1];
    }
}
