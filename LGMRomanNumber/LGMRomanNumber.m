//
//  LGMRomanNumber.m
//  LGMRomanNumber
//
//  Created by Ludovic Landry on 3/30/13.
//  Copyright (c) 2013 Little Green Mens. All rights reserved.
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

+ (NSString *)romanFromDecimal:(NSUInteger)decimal {
    
    if (decimal <= 0u) {
        [NSException raise:@"Invalid decimal value" format:@"*** -[LGMRomanNumber romanFromDecimal:]: decimal value %d should be greater than 0", decimal];
    }
    
    if (decimal > 4000u) {
        [NSException raise:@"Invalid decimal value" format:@"*** -[LGMRomanNumber romanFromDecimal:]: decimal value %d should be smaller or equals to 4000", decimal];
    }
    
    NSMutableArray *result = [NSMutableArray array];
    for (NSUInteger index = 0u; index < [self.romanNumeralNumbers count]; index++) {
        NSUInteger romanNumeralInteger = [[self.romanNumeralNumbers objectAtIndex:index] integerValue];
        
        while (decimal >= romanNumeralInteger) {
            NSString *romanNumeralValue = [self.romanNumeralValues objectAtIndex:index];
            [result addObject:romanNumeralValue];
            decimal -= romanNumeralInteger;
        }
    }
    
    return [result componentsJoinedByString:@""];
}

+ (NSUInteger)decimalFromRoman:(NSString *)roman {
    
    if ([roman length] < 1) {
        [NSException raise:@"Invalid roman number" format:@"*** -[LGMRomanNumber decimalFromRoman:]: roman number %@ needs at least one charater", roman];
    }
    
    NSPredicate *romanPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES 'M{0,4}(CM|CD|D?C{0,3})(XC|XL|L?X{0,3})(IX|IV|V?I{0,3})'"];
    if (![romanPredicate evaluateWithObject:roman]) {
        [NSException raise:@"Invalid roman number" format:@"*** -[LGMRomanNumber decimalFromRoman:]: roman number %@ has an invalid format", roman];
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
