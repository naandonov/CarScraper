//
//  DownloadManager.m
//  CarScraper
//
//  Created by Nikolay Andonov on 1/24/15.
//  Copyright (c) 2015 Nikolay Andonov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadManager.h"
#import "DataHTMLExtractor.h"
#import "CoreDataManager.h"


@interface DownloadManager()

@property NSMutableArray * parsedDataArray;
@property (nonatomic) SiteSelector currentSelector;

@end


@implementation DownloadManager

+ (id)sharedInstance {
    static DownloadManager *sharedInstance;
    
    static dispatch_once_t dataManagerOnceToken;
    dispatch_once(&dataManagerOnceToken, ^{
        sharedInstance = [[DownloadManager alloc] init];
    });
    
    return sharedInstance;
}

-(instancetype)init{
    
    self = [super init];
    if (self) {
        
    }
    return self;
}



-(void)downloadAddsDataWithConcurencyLevel:(NSInteger)cocurencyLevel andNumberOfAdds:(NSInteger)addsCount andSelector:(SiteSelector)selector{
    
    self.currentSelector = selector;
    self.parsedDataArray = [NSMutableArray array];
    __weak typeof(self) weakSelf = self;
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = cocurencyLevel;
    
    NSBlockOperation *completionOperation = [NSBlockOperation blockOperationWithBlock:^{
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [weakSelf dataDownloadCompleted];
        }];
    }];
    
    for(NSInteger counter = 1;counter<addsCount; counter ++)
    {
        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
            NSString *stringURL = selector == CarMarketBG ? [weakSelf carMarketURLforAddNumber:counter] : [weakSelf carsBGURLforAddNumber:counter];
            NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:stringURL]];
            if(!data){
                return;
            }
            else{
                
                
                NSArray * carXMLElementsArray = [DataHTMLExtractor addsForData:data andSelector:selector];
                 NSInteger progress = 100 * (( (CGFloat)weakSelf.parsedDataArray.count/carXMLElementsArray.count)  / addsCount);
                
                [weakSelf.parsedDataArray addObjectsFromArray:carXMLElementsArray];
                
                if([weakSelf.delegate respondsToSelector:@selector(downloadDidUpdateWithSize:andProgres:)]){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.delegate downloadDidUpdateWithSize:data.length andProgres:progress];
                    });
                }
            }
            
        }];
        [completionOperation addDependency:operation];
    }
    
    [queue addOperations:completionOperation.dependencies waitUntilFinished:NO];
    [queue addOperation:completionOperation];
    
}


-(void)dataDownloadCompleted{
    if([self.delegate respondsToSelector:@selector(downloadDidFinishWithParsedDataArray:andSiteSelector:)]){
    [self.delegate downloadDidFinishWithParsedDataArray:self.parsedDataArray andSiteSelector:self.currentSelector];
    }
}


#pragma mark - Utilities

-(NSString*)carMarketURLforAddNumber:(NSInteger)addNumber{
    return [NSString stringWithFormat:@"http://www.carmarket.bg/obiavi/%ld?sort=1",(long)addNumber];
}

-(NSString*)carsBGURLforAddNumber:(NSInteger)addNumber{
    
    return [NSString stringWithFormat:@"http://www.cars.bg/?go=cars&search=1&advanced=&fromhomeu=1&CityId=0&currencyId=1&yearTo=&autotype=1&stateId=1&offerFrom4=1&offerFrom1=1&offerFrom2=1&offerFrom3=1&categoryId=0&doorId=0&brandId=0&modelId=0&fuelId=0&gearId=0&yearFrom=&priceFrom=&priceTo=&man_priceFrom=&man_priceTo=&regionId=0&conditionId=1&filterOrderBy=1&page=%ld&cref=64760",(long)addNumber];
}


@end
