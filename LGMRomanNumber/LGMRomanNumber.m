//
//  LGMRomanNumber.m
//  LGMRomanNumber
//
//  Copyright (c) 2013 Ludovic Landry
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "LGMRomanNumber.h"

@interface LGMRomanNumber ()

+ (NSArray *)romanNumeralNumbers;
+ (NSArray *)romanNumeralValues;

@end

@implementation LGMRomanNumber

static NSArray *_romanNumeralNumbers;
static NSArray *_romanNumeralValues;

+ (NSArray *)romanNumeralNumbers {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _romanNumeralNumbers = @[@(1000u), @(900u), @(500u), @(400u), @(100u), @(90u), @(50u), @(40u), @(10u), @(9u), @(5u), @(4u), @(1u)];
    });
    return _romanNumeralNumbers;
}

+ (NSArray *)romanNumeralValues {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _romanNumeralValues = @[@"M", @"CM", @"D", @"CD", @"C", @"XC", @"L", @"XL", @"X", @"IX", @"V", @"IV", @"I"];
    });
    return _romanNumeralValues;
}

+ (NSString *)romanFromArabic:(NSUInteger)arabic {
    
    if (arabic <= 0u) {
        [NSException raise:@"Invalid decimal value" format:@"*** -[LGMRomanNumber romanFromArabic:]: arabic value %d should be greater than 0", arabic];
    }
    
    if (arabic > 4000u) {
        [NSException raise:@"Invalid decimal value" format:@"*** -[LGMRomanNumber romanFromArabic:]: arabic value %d should be smaller or equals to 4000", arabic];
    }
    
    NSMutableArray *result = [NSMutableArray array];
    for (NSUInteger index = 0u; index < [self.romanNumeralNumbers count]; index++) {
        NSUInteger romanNumeralInteger = [[self.romanNumeralNumbers objectAtIndex:index] integerValue];
        
        while (arabic >= romanNumeralInteger) {
            NSString *romanNumeralValue = [self.romanNumeralValues objectAtIndex:index];
            [result addObject:romanNumeralValue];
            arabic -= romanNumeralInteger;
        }
    }
    
    return [result componentsJoinedByString:@""];
}

+ (NSUInteger)arabicFromRoman:(NSString *)roman {
    
    if ([roman length] < 1) {
        [NSException raise:@"Invalid roman number" format:@"*** -[LGMRomanNumber arabicFromRoman:]: roman number %@ needs at least one charater", roman];
    }
    
    NSPredicate *romanPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES 'M{0,4}(CM|CD|D?C{0,3})(XC|XL|L?X{0,3})(IX|IV|V?I{0,3})'"];
    if (![romanPredicate evaluateWithObject:roman]) {
        [NSException raise:@"Invalid roman number" format:@"*** -[LGMRomanNumber arabicFromRoman:]: roman number %@ has an invalid format", roman];
    }
    
    NSUInteger previous = [[self.romanNumeralNumbers objectAtIndex:0u] unsignedIntegerValue];
    
    NSUInteger decimalNumberSum = 0u;
	for (NSUInteger index = 0u; index < [roman length]; index++) {
        NSString *romanNumeralValue = [roman substringWithRange:NSMakeRange(index, 1u)];
        
        NSUInteger romanNumeralIndex = [self.romanNumeralValues indexOfObject:romanNumeralValue];
        if (romanNumeralIndex == NSNotFound) {
            break;
        }
        
        NSUInteger romanNumeralNumber = [[self.romanNumeralNumbers objectAtIndex:romanNumeralIndex] unsignedIntegerValue];
        decimalNumberSum += romanNumeralNumber;
        if (previous < romanNumeralNumber) {
            decimalNumberSum -= 2 * previous;
        }
        previous = romanNumeralNumber;
    }
    
    return decimalNumberSum;
}

@end
