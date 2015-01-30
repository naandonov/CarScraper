//
//  DownloadManager.h
//  CarScraper
//
//  Created by Nikolay Andonov on 1/24/15.
//  Copyright (c) 2015 Nikolay Andonov. All rights reserved.

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    CarMarketBG,
    CarsBG
} SiteSelector;

@protocol DownloadDelegate <NSObject>

@optional
-(void) downloadDidUpdateWithSize:(NSInteger)downloadCurrentSize andProgres:(NSInteger)percentageProgress;
@required
-(void) downloadDidFinishWithParsedDataArray:(NSArray*)dataAray andSiteSelector:(SiteSelector)selector;

@end


@interface DownloadManager : NSObject

@property (nonatomic,weak) id<DownloadDelegate> delegate;

+ (id)sharedInstance ;

-(void)downloadAddsDataWithConcurencyLevel:(NSInteger)cocurencyLevel andNumberOfAdds:(NSInteger)addsCount andSelector:(SiteSelector)selector;




@end
