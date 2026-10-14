// Equivalence driver for the original Objective-C LGMRomanNumber (compiled unmodified).
// Reads "A <decimal>" or "R <hex of UTF-8>" lines, prints one result line per input.
// Exceptions print as "EXC <name>"; the reason text is masked (runtime-formatted, uses %d on NSUInteger).
#import <Foundation/Foundation.h>
#import "LGMRomanNumber.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(void) {
    char *line = NULL; size_t cap = 0; ssize_t n;
    // One pool for the whole run: on Linux the library is built without ARC (the GCC runtime has none),
    // so its two lazily created static arrays stay alive only while this pool does.
    @autoreleasepool {
    while ((n = getline(&line, &cap, stdin)) > 0) {
        {
            if (line[n - 1] == '\n') line[--n] = 0;
            @try {
                if (line[0] == 'A') {
                    NSUInteger v = (NSUInteger)strtoull(line + 2, NULL, 10);
                    printf("%s\n", [[LGMRomanNumber romanFromArabic:v] UTF8String]);
                } else {
                    size_t len = (size_t)(n - 2) / 2;
                    unsigned char *buf = malloc(len + 1);
                    for (size_t i = 0; i < len; i++) { unsigned int b; sscanf(line + 2 + 2 * i, "%2x", &b); buf[i] = (unsigned char)b; }
                    NSString *s = [[NSString alloc] initWithBytes:buf length:len encoding:NSUTF8StringEncoding];
                    free(buf);
                    printf("%lu\n", (unsigned long)[LGMRomanNumber arabicFromRoman:s]);
                }
            } @catch (NSException *e) {
                printf("EXC %s\n", [[e name] UTF8String]);
            }
            fflush(stdout);
        }
    }
    }
    free(line);
    return 0;
}
