FEATURES/ADDITIONS:

- REBUILD THE TO/IN_DEGREE COMMANDS.
  Addendum: Transpo maps should be able to operate in scale degrees, if the pattern is in_scale
	Addendum: This is gonna be interesting since the scale remap methods no longer label the context with
	          the scale. Maybe they need to resume doing so to support this particular case?

- Events::MIDINotes::Filters::Mutex: should allow certain notes to cancel out certain other notes.
  Addendum: This could be complex, as Events::Filters normally only examine one event at a time. Maybe they need
	          the ability to consider sibling events somehow.

- ... wow, maybe Triggerable and some of the RelativeTime properties actually turn into Events::Time::Filters and Events::Time::Transform traits?
  Addendum: No, Triggerable can't be directly implemented as an Events::Filter because it operates on the entire event set instead of filtering individual events within that set.
	          Maybe it can share a common ancestor with mutable, though.

- Maybe split xform into seperate block functions for different properties (note num, vel, etc) and add ones for time properties?
  Addendum: screw it, xform can be wide open, single property versions can also exist as convenience methods.

- 'Auto-scoping' of t in triggers instead of adding the argument to the proc in the preprocessor

- Move abbreviation into the models/traits, as per sketches/thesaurus_test.rb

- Maybe some time properties become additive?

- Naming conventions: maybe all transform methods should be '!' and all filter methods should be '?' ?

- Maybe this sort of syntax for implicit, 'auto-scoping' block arguments?

    > inst SY 40
      note =
	      t + 2
				8 if t < 8
      vel = 20 + t * 4


BUGFIXES:

- Exceptions don't bubble properly in the MultiLoader.

- Everything in EnhancedLooping should probably be gone over with a fine toothed comb.
