- Move abbreviation into the models/traits, as per sketches/thesaurus_test.rb

- Multiple tranposition maps per pattern, applied in sequence

- ^ Maybe transpo maps are actually a type of xform action? Not sure yet.

- Transpo maps should be able to operate in scale degrees, if the pattern is in_scale

- Reimplement both in_scale and to_scale as special cases of transpo map

- Maybe split transform into seperate block functions for different properties (note num, vel, etc) and add ones for time properties.

- 'Auto-scoping' of t in triggers instead of adding the argument to the proc in the preprocessor

- Move method name abbreviation into the models/traits

- Maybe some time properties become additive...

- Maybe this sort of syntax for implicit, 'auto-scoping' block arguments?

    > inst SY 40
      note =
	      t + 2
				8 if t < 8
      vel = 20 + t * 4
			