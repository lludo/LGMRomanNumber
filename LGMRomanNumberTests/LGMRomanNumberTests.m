//
//  LGMRomanNumberTests.m
//  LGMRomanNumberTests
//
//  Created by Ludovic Landry on 3/30/13.
//  Copyright (c) 2013 Little Green Mens. All rights reserved.
//

#import "LGMRomanNumberTests.h"
#import "LGMRomanNumber.h"

@implementation LGMRomanNumberTests

- (void)setUp {
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown {
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testRomanFromDecimal {
    STAssertTrue([[LGMRomanNumber romanFromDecimal:1u] isEqualToString:@"I"], @"Convertion for 1 does not work!");
    STAssertTrue([[LGMRomanNumber romanFromDecimal:5u] isEqualToString:@"V"], @"Convertion for 5 does not work!");
    STAssertTrue([[LGMRomanNumber romanFromDecimal:10u] isEqualToString:@"X"], @"Convertion for 10 does not work!");
    STAssertTrue([[LGMRomanNumber romanFromDecimal:50u] isEqualToString:@"L"], @"Convertion for 50 does not work!");
    STAssertTrue([[LGMRomanNumber romanFromDecimal:100u] isEqualToString:@"C"], @"Convertion for 100 does not work!");
    STAssertTrue([[LGMRomanNumber romanFromDecimal:500u] isEqualToString:@"D"], @"Convertion for 500 does not work!");
    STAssertTrue([[LGMRomanNumber romanFromDecimal:1000u] isEqualToString:@"M"], @"Convertion for 1000 does not work!");
}

- (void)testDecimalFromRoman {
    STAssertEquals([LGMRomanNumber decimalFromRoman:@"I"], 1u, @"Convertion for I does not work!");
    STAssertEquals([LGMRomanNumber decimalFromRoman:@"V"], 5u, @"Convertion for V does not work!");
    STAssertEquals([LGMRomanNumber decimalFromRoman:@"X"], 10u, @"Convertion for X does not work!");
    STAssertEquals([LGMRomanNumber decimalFromRoman:@"L"], 50u, @"Convertion for L does not work!");
    STAssertEquals([LGMRomanNumber decimalFromRoman:@"C"], 100u, @"Convertion for C does not work!");
    STAssertEquals([LGMRomanNumber decimalFromRoman:@"D"], 500u, @"Convertion for D does not work!");
    STAssertEquals([LGMRomanNumber decimalFromRoman:@"M"], 1000u, @"Convertion for M does not work!");
}

- (void)testReflexiveConversion {
    NSString *romanNumber = nil;
    NSUInteger numberFromRoman = 0;
    for (NSUInteger number = 1u; number <= 4000u; number++) {
        romanNumber = [LGMRomanNumber romanFromDecimal:number];
        numberFromRoman = [LGMRomanNumber decimalFromRoman:romanNumber];
        STAssertEquals(numberFromRoman, number, [NSString stringWithFormat:@"Convertion for %u does not work! (%u -> %@ -> %u)", number, number, romanNumber, numberFromRoman]);
        if (numberFromRoman != number) {
            break;
        }
    }
}

@end
