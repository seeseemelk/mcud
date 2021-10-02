// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

module mcud.periphs.input;

import mcud.core.result;
import mcud.meta.like;

/**
A general purpose input.
*/
interface GPI
{
	/**
	Tests if the GPI is currently on.
	*/
	Result!bool isOn() nothrow;
}

alias isGPI = isLike!GPI;

//*
auto inverse(alias inp)() nothrow
//if (isGPI!inp)
{
	struct Inverse
	{
		Result!bool isOn() nothrow
		{
			return inp.isOn().map!(value => !value);
		}
	}
	return Inverse();
}
//*/
/*
struct inverse(alias inp)
{
	Result!bool isOn()
	{
		return inp.isOn().map!(value => !value);
	}
}
*/