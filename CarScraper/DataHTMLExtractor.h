//
//  DataHTMLExtractor.h
//  CarScraper
//
//  Created by Nikolay Andonov on 1/24/15.
//  Copyright (c) 2015 Nikolay Andonov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataManager.h"
#import "TFHpple.h"
#import "CarEntity.h"

@interface DataHTMLExtractor : NSObject

+(NSArray*)addsForData:(NSData*)data andSelector:(SiteSelector)selector;
+(BOOL)populateCarEntity:(CarEntity*) carEntity withElement:(TFHppleElement*)element andSelector:(SiteSelector)selector andIndex:(NSInteger)index;

@end
