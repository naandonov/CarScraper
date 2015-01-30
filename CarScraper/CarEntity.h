//
//  CarEntity.h
//  CarScraper
//
//  Created by Nikolay Andonov on 1/30/15.
//  Copyright (c) 2015 Nikolay Andonov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CarEntity : NSManagedObject

@property (nonatomic, retain) NSString * addURL;
@property (nonatomic, retain) NSString * brand;
@property (nonatomic, retain) NSString * distanceTraveled;
@property (nonatomic, retain) NSString * fuelType;
@property (nonatomic, retain) NSString * horsePower;
@property (nonatomic, retain) NSString * price;
@property (nonatomic, retain) NSString * thumbnailURL;
@property (nonatomic, retain) NSString * transmissionType;
@property (nonatomic, retain) NSString * yearOfProduction;
@property (nonatomic, retain) NSNumber * index;

@end
