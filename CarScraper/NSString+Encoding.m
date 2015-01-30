//
//  NSString+Encoding.m
//  CarScraper
//
//  Created by Nikolay Andonov on 1/29/15.
//  Copyright (c) 2015 Nikolay Andonov. All rights reserved.
//

#import "NSString+Encoding.h"

@implementation NSString (Encoding)

-(NSString*)encodedUnicode{
    
    NSString *input = self;
    NSString *convertedString = [input mutableCopy];
    
    CFStringRef transform = CFSTR("Any-Hex/Java");
    CFStringTransform((__bridge CFMutableStringRef)convertedString, NULL, transform, YES);
    return convertedString;
}

@end
