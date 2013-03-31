//
//  LGMRomanNumber.h
//  LGMRomanNumber
//
//  Created by Ludovic Landry on 3/30/13.
//  Copyright (c) 2013 Little Green Mens. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Manages convertions from/to roman numbers.
 */
@interface LGMRomanNumber : NSObject

/**
 * Convert a decimal number to roman.
 */
+ (NSString *)romanFromDecimal:(NSUInteger)decimal;

/**
 * Convert a roman number to decimal.
 */
+ (NSUInteger)decimalFromRoman:(NSString *)roman;

@end
