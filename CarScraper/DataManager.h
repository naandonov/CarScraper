//
//  DataManager.h
//  CarScraper
//
//  Created by Nikolay Andonov on 1/24/15.
//  Copyright (c) 2015 Nikolay Andonov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadManager.h"

@protocol DataDelegate <NSObject>
@optional
-(void) downloadDidUpdateWithSize:(NSInteger)downloadCurrentSize andProgres:(NSInteger)percentageProgress;
@required
-(void) downloadDidFinish;
-(void) savingDidFinish;
@end


@interface DataManager : NSObject

@property(nonatomic, readonly) NSInteger concurrencyLevel;
@property(nonatomic, readonly) NSInteger addsLimit;
@property(nonatomic, weak) id<DataDelegate> delegate;

+(id)sharedInstance;
-(void)getAndStoreAdsForCarmarketBGWithDownloadDelegate:(id<DataDelegate>)delegate;
-(void)getAndStoreAdsForCarsBGWithDownloadDelegate:(id<DataDelegate>) delegate;
-(void)setSettingsForLevelOfConcurency:(NSInteger)levelOfConcurency andAddCounts:(NSInteger) addCount;
-(void)deleteAllAds;
-(NSArray*)savedAdsModel;

@end

