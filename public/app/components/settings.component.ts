import {Component, Input} from '@angular/core';
import {FhirService} from '../services/fhir.service';
import {ObservationService} from '../services/observation.service';
import {Observation} from '../models/observation.model';
import {Patient} from '../models/patient.model';

@Component({
	selector: 'settings',
	templateUrl: 'app/components/settings'
})
export class ObservationsComponent {

	selected: Observation;
	observations: Array<Observation> = [];
	@Input() patient: Patient;

	constructor(private fhirService: FhirService, private observationService: ObservationService) {
		console.log("ObservationsComponent created...");
	}

	ngOnChanges() {
		if (this.patient) {
			this.observationService.index(this.patient).subscribe(data => {
				if(data.entry) {
					this.observations = <Array<Observation>>data.entry.map(r => r['resource']);
					console.log("Loaded " + this.observations.length + " observations.");
				} else {
					this.observations = new Array<Observation>();
					console.log("No observations for patient.");
				}
			});
		}
	}

}
