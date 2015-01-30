//
//  DataManager.m
//  CarScraper
//
//  Created by Nikolay Andonov on 1/24/15.
//  Copyright (c) 2015 Nikolay Andonov. All rights reserved.
//

#import "DataManager.h"
#import "CoreDataManager.h"
#import "DataHTMLExtractor.h"
#import "CarEntity.h"
#import <CoreData/CoreData.h>

NSString* const kCarEntity = @"CarEntity";
NSInteger const AddsLimit = 5000;

@interface DataManager()<DownloadDelegate>

@property(nonatomic, readwrite) NSInteger concurrencyLevel;
@property(nonatomic, readwrite) NSInteger addsLimit;

@end


@implementation DataManager

#pragma mark - Main methods

+ (id)sharedInstance {
    static DataManager *sharedInstance;
    static dispatch_once_t dataManagerOnceToken;
    dispatch_once(&dataManagerOnceToken, ^{
        sharedInstance = [[DataManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //Default values
        _concurrencyLevel = 10;
        _addsLimit = 50;
    }
    return self;
}

-(void)getAndStoreAdsForCarmarketBGWithDownloadDelegate:(id<DataDelegate>)delegate{
    DownloadManager * downloadManager = [DownloadManager sharedInstance];
    downloadManager.delegate = self;
    self.delegate = delegate;
    [downloadManager downloadAddsDataWithConcurencyLevel:self.concurrencyLevel andNumberOfAdds:self.addsLimit andSelector:CarMarketBG];
    
}

-(void)getAndStoreAdsForCarsBGWithDownloadDelegate:(id<DataDelegate>)delegate{
    DownloadManager * downloadManager = [DownloadManager sharedInstance];
    downloadManager.delegate = self;
    self.delegate = delegate;
    [downloadManager downloadAddsDataWithConcurencyLevel:self.concurrencyLevel andNumberOfAdds:self.addsLimit andSelector:CarsBG];
    
}

-(void)deleteAllAds{
    [[CoreDataManager sharedInstance] deleteAllEntities:kCarEntity];
}

-(NSArray*)savedAdsModel{
    
    return [[CoreDataManager sharedInstance] fetchAllEntitiesForName:kCarEntity withSortDescriptor:@[[NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES]] andPredicate:nil];
}


#pragma mark - settings configuration

-(void)setSettingsForLevelOfConcurency:(NSInteger)levelOfConcurency andAddCounts:(NSInteger) addCount{
    self.concurrencyLevel = levelOfConcurency;
    self.addsLimit = addCount<1 || addCount>5000 ? 5000 : addCount+1;
}


#pragma mark - download delegates

-(void)downloadDidUpdateWithSize:(NSInteger)downloadCurrentSize andProgres:(NSInteger)percentageProgress{
    if([self.delegate respondsToSelector:@selector(downloadDidUpdateWithSize:andProgres:)]){
        [self.delegate downloadDidUpdateWithSize:downloadCurrentSize andProgres:percentageProgress];
    }
}

-(void)downloadDidFinishWithParsedDataArray:(NSArray *)dataAray andSiteSelector:(SiteSelector)selector{
    
    if ([self.delegate respondsToSelector:@selector(downloadDidFinish)]) {
        [self.delegate downloadDidFinish];
    }
    
    CoreDataManager * coreDataManager = [CoreDataManager sharedInstance];
    NSInteger addsCurrentCount = [[CoreDataManager sharedInstance] countOfManagedObjectsForEntity:kCarEntity];
    
    for(NSInteger counter = 0; counter<dataAray.count; counter++){
        CarEntity * car = (CarEntity*)[coreDataManager insertedManagedObjectWithEntityName:kCarEntity];
        if(![DataHTMLExtractor populateCarEntity:car withElement:dataAray[counter] andSelector:selector andIndex:addsCurrentCount+counter]){
            NSLog(@"Unable to parse the html element to the object entity!");
        }
    }
    [coreDataManager saveContext];
    
    if ([self.delegate respondsToSelector:@selector(savingDidFinish)]) {
        [self.delegate savingDidFinish];
    }
    
}


@end
