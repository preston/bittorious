import {Component, Input} from '@angular/core';
import {FhirService} from '../services/fhir.service';
import {ConditionService} from '../services/condition.service';
import {Condition} from '../models/condition.model';
import {Patient} from '../models/patient.model';

@Component({
    selector: 'conditions',
    templateUrl: 'app/components/conditions.html'
})
export class ConditionsComponent {

    selected: Condition;
    conditions: Array<Condition> = [];
    @Input() patient: Patient;

    constructor(private fhirService: FhirService, private conditionService: ConditionService) {
        console.log("ConditionsService created...");
    }

    ngOnChanges() {
        if (this.patient) {
            this.conditionService.index(this.patient).subscribe(data => {
				if(data.entry) {
                	this.conditions = <Array<Condition>>data.entry.map(r => r['resource']);
                	console.log("Loaded " + this.conditions.length + " conditions.");
				} else {
					this.conditions = new Array<Condition>();
					console.log("No conditions for patient.");
				}
            });
        }
    }

}
