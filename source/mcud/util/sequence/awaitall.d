module mcud.util.sequence.awaitall;

import mcud.core.event;
import std.format;

template AwaitAll(void function() callback, Events...)
{
	private int _count = 0;

	static foreach (i, Event; Events)
	{
		@event!Event
		mixin(format!`void onEvent_%d()
		{
			decrement();
		}`(i));
	}

	void reset()
	{
		_count = Events.length;
	}

	private void decrement()
	{
		if (_count > 1)
		{
			_count--;
		}
		else if (_count == 1)
		{
			callback();
			_count = 0;
		}
	}
}

unittest
{
	struct SomeEvent {}
	static int callCount = 0;
	alias gate = AwaitAll!(
		{
			callCount++;
		},
		SomeEvent
	);

	assert(callCount == 0, "Should not have been called yet");
	gate.reset();
	fire!(SomeEvent, gate)();
	assert(callCount == 1, "Has not been called");
	fire!(SomeEvent, gate)();
	assert(callCount == 1, "Has been called");
	gate.reset();
	fire!(SomeEvent, gate)();
	assert(callCount == 2, "Has not been called");
}

unittest
{
	struct EventA {}
	struct EventB {}
	static int callCount = 0;
	alias gate = AwaitAll!(
		{
			callCount++;
		},
		EventA, EventB
	);

	assert(callCount == 0, "Should not have been called yet");
	gate.reset();

	fire!(EventA, gate)();
	assert(callCount == 0, "Should not have been called");
	fire!(EventB, gate)();
	assert(callCount == 1, "Should have been called");

	fire!(EventA, gate)();
	assert(callCount == 1, "Should not have been called");
}