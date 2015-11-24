- Move abbreviation into the models/traits, as per sketches/thesaurus_test.rb

- Transpo maps should be able to operate in scale degrees, if the pattern is in_scale

- Regroup itemse in Events::MIDINotes::Filters into
  - Events::MIDINotes::Filters: anything that accepts/rejects notes. make a base trait with a method 'filter' for these to special-case from.
	- Events::MIDINotes::Transform: anything that modifies notes.

- 1. split up stuff in scale into 
     - set_scale / sscale: marks the scale on the context so that it can be omitted in calls to the following:
     - in_scale  / in_degrees: becomes a special case of 'filter'.
		 - to_scale  / to_degrees: becomes a special case of 'remap'

- Maybe split transform into seperate block functions for different properties (note num, vel, etc) and add ones for time properties.

- 'Auto-scoping' of t in triggers instead of adding the argument to the proc in the preprocessor

- Maybe some time properties become additive?

- Maybe this sort of syntax for implicit, 'auto-scoping' block arguments?

    > inst SY 40
      note =
	      t + 2
				8 if t < 8
      vel = 20 + t * 4
			