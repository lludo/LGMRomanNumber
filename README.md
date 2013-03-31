LGMRomanNumber
==============

`LGMRomanNumber` is an iOS library to convert decimal numbers to/from roman numbers.

## Usage

You just have to `#import "LGMRomanNumber.h"` to be able to use it.

``` objective-c
NSString *romanNumber = [LGMRomanNumber romanFromDecimal:1986];
// romanNumber value is MCMLXXXVI

NSUInteger decimalNumber = [LGMRomanNumber decimalFromRoman:@"MMXIII"];
// decimalNumber value is 2013
```

Converting decimal values in interval [1, 4000] or roman numbers [I, MMMM];

## Credits

`LGMRomanNumber` was created by [Ludovic Landry](https://github.com/lludo).

## Creator

[Ludovic Landry](http://github.com/lludo)  
[@ludoviclandry](https://twitter.com/ludoviclandry)

## License

`LGMRomanNumber` is available under the MIT license. See the LICENSE file for more info.
