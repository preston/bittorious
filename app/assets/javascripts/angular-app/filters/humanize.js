angular.module('humanizeFilters', [])
    .filter('humanizeBytes', function() {
        return function(number) {
            if(number < 1024) {
                return number;
            }
            var si = ['KiB', 'MiB', 'GiB', 'TiB', 'PiB', 'HiB'];
            var exp = Math.floor(Math.log(number) / Math.log(1024));
            var result = number / Math.pow(1024, exp);
            result = (result % 1 > (1 / Math.pow(1024, exp - 1))) ? result.toFixed(2) : result.toFixed(0);
            return result + si[exp - 1];
        };
});

