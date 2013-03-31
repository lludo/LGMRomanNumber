LGMRomanNumber
==============

`LGMRomanNumber` is an iOS library to convert arabic numbers to/from roman numbers.

## Description

This library provides a convinient way to convert arabic numbers to roman numbers and vice versa. It also validates that the input values are valid and throws exceptions if not.
All the rules and specific cases are applied when converting to roman numbers, see [Wikipedia](http://en.wikipedia.org/wiki/Roman_numerals) for more details.
Converting arabic values in interval [1, 4000] or roman numbers in interval [I, MMMM];

## Usage

You just have to `#import "LGMRomanNumber.h"` to be able to use it.

``` objective-c
NSString *romanNumber = [LGMRomanNumber romanFromArabic:1986];
// romanNumber value is MCMLXXXVI

NSUInteger arabicNumber = [LGMRomanNumber arabicFromRoman:@"MMXIII"];
// arabicNumber value is 2013
```

## Credits

`LGMRomanNumber` was created by [Ludovic Landry](https://github.com/lludo).

## Creator

[Ludovic Landry](http://github.com/lludo)  
[@ludoviclandry](https://twitter.com/ludoviclandry)

## License

`LGMRomanNumber` is available under the MIT license. See the LICENSE file for more info.
