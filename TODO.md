BUGFIXES:

- Exceptions don't bubble properly in the MultiLoader.

- Everything in EnhancedLooping should probably be gone over with a fine toothed comb.

FEATURES/ADDITIONS:

- REBUILD THE TO/IN DEGREE COMMANDS.

- Transpo maps should be able to operate in scale degrees, if the pattern is in_scale

- Events::MIDINotes::Filters::Mutex: should allow certain notes to cancel out certain other notes.

- ... wow, maybe Triggers and some of the RelativeTime properties actually turn into Events::Time::Filters and Events::Time::Transform traits?

- Naming conventions: maybe all transform methods should be '!' and all filter methods should be '?' ?

- Move abbreviation into the models/traits, as per sketches/thesaurus_test.rb

- Maybe split xform into seperate block functions for different properties (note num, vel, etc) and add ones for time properties?
  Addendum: screw it, xform can be wide open, single property versions can also exist as convenience methods.

- 'Auto-scoping' of t in triggers instead of adding the argument to the proc in the preprocessor

- Maybe some time properties become additive?

- Maybe this sort of syntax for implicit, 'auto-scoping' block arguments?

    > inst SY 40
      note =
	      t + 2
				8 if t < 8
      vel = 20 + t * 4
			