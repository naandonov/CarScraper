//
//  CoreDataManager.h
//  CarScraper
//
//  Created by Nikolay Andonov on 1/28/15.
//  Copyright (c) 2015 Nikolay Andonov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataManager : NSObject

+(id)sharedInstance;
-(NSManagedObjectContext*)insertedManagedObjectWithEntityName:(NSString*)entityName;
-(NSArray*)fetchAllEntitiesForName:(NSString*)entityName withSortDescriptor:(NSArray*)sortDescriptors andPredicate:(NSPredicate*)predicate;
-(NSInteger)countOfManagedObjectsForEntity:(NSString*)entity;
-(void)deleteAllEntities:(NSString *)nameEntity;
-(void)saveContext;
@end
