//
//  DataHTMLExtractor.m
//  CarScraper
//
//  Created by Nikolay Andonov on 1/24/15.
//  Copyright (c) 2015 Nikolay Andonov. All rights reserved.
//

#import "DataHTMLExtractor.h"
#import "TFHpple.h"
#import "CarEntity.h"
#import "NSString+Encoding.h"

@implementation DataHTMLExtractor


+(NSArray*)addsForData:(NSData*)data andSelector:(SiteSelector)selector{

    
     TFHpple *tutorialsParser = [TFHpple hppleWithHTMLData:data];
    
    switch (selector) {
        case CarMarketBG:{
            
            NSString * xpathQueryString = @"//div[@class='cmOffersListItem new']/a | //div[@class='cmOffersListItem vip']/a | //div[@class='cmOffersListItem']/a";
            NSArray *nodesArray = [tutorialsParser searchWithXPathQuery:xpathQueryString];
            
            return nodesArray;
            
            break;
        }
        
        case CarsBG:{
            
            //class
            NSString * xpathQueryString = @"//tr[@class='even '] | //tr[@class='odd '] | tr[@class='even last'] | tr[@class='odd last']";
            NSArray *nodesArray = [tutorialsParser searchWithXPathQuery:xpathQueryString];
            
            return nodesArray;
            
            break;
        }
            
        default:
            break;
    }
    
    return @[];
}


+(BOOL)populateCarEntity:(CarEntity*) carEntity withElement:(TFHppleElement*)element andSelector:(SiteSelector)selector andIndex:(NSInteger)index{
    
    carEntity.index = @(index);
    
    switch (selector) {
        case CarMarketBG:{
            
            carEntity.brand = [[[element searchWithXPathQuery:@"//span[@class='cmOffersListName']"] firstObject] content];
            carEntity.fuelType = [[[[element searchWithXPathQuery:[NSString stringWithFormat:@"//span[@class='cmOffersListMoreInfoRow']/span[contains(.,'%@')]/../strong",[@"Тип двигател" encodedUnicode]]] firstObject] content] encodedUnicode];
            carEntity.horsePower = [[[[element searchWithXPathQuery:[NSString stringWithFormat:@"//span[@class='cmOffersListMoreInfoRow']/span[contains(.,'%@')]/../strong",[@"Мощност" encodedUnicode]]] firstObject] content] encodedUnicode];
            carEntity.transmissionType = [[[[element searchWithXPathQuery:[NSString stringWithFormat:@"//span[@class='cmOffersListMoreInfoRow']/span[contains(.,'%@')]/../strong",[@"Скоростна кутия" encodedUnicode]]] firstObject] content] encodedUnicode];
            carEntity.distanceTraveled = [[[[element searchWithXPathQuery:[NSString stringWithFormat:@"//span[@class='cmOffersListMoreInfoRow']/span[contains(.,'%@')]/../strong",[@"Пробег" encodedUnicode]]] firstObject] content] encodedUnicode];
            carEntity.price = [[[[element searchWithXPathQuery:@"//strong[@itemprop='price']"] firstObject] content] encodedUnicode];
            carEntity.thumbnailURL = [[[element searchWithXPathQuery:@"//input[@name='offer_compare_img']/@value"] firstObject] content];
            carEntity.addURL = [[[element searchWithXPathQuery:@"//a[@class='cmOffersListLink']/@href"] firstObject] content];
            
            NSString * developmentDate = [[[element searchWithXPathQuery:@"//span[@class='cmOffersListYear']"] firstObject] content];
            developmentDate = [developmentDate stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSInteger dateLength = developmentDate.length;
            NSString *month=[developmentDate substringWithRange:NSMakeRange(0, dateLength-7)];
            NSString *year=[developmentDate substringWithRange:NSMakeRange(dateLength-7, 6)];
            carEntity.yearOfProduction = [[NSString stringWithFormat:@"%@ %@",month,year] encodedUnicode];
            
            break;
        }
            
        case CarsBG:{
            
            NSArray * firstInfo = [element searchWithXPathQuery:@"//td/text()[2]"] ;
            NSString * fuelAndDistance = [[[[firstInfo objectAtIndex:0] content] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] encodedUnicode];
            NSString * automaticTransmission = [@" автоматик," encodedUnicode];
            NSString * transmission;
            if(![fuelAndDistance rangeOfString:automaticTransmission].location == NSNotFound){
                transmission = [@"Автоматична" encodedUnicode];
                fuelAndDistance = [fuelAndDistance stringByReplacingOccurrencesOfString:automaticTransmission withString:@""];
            }
            else{
                transmission = [@"Ръчна" encodedUnicode];
            }
            
            NSString * fuelType = [[fuelAndDistance componentsSeparatedByString:@","] firstObject];
            fuelType = [fuelType substringWithRange:NSMakeRange(0, fuelType.length)];
            NSString * distanceTraveled = [[fuelAndDistance stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@,",fuelType
                                                                                                  ] withString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString * currency = [[[[firstInfo objectAtIndex:1] content] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] encodedUnicode];
            NSString * price = [[[[element searchWithXPathQuery:@"//span[@class='ver20black']/strong"] firstObject] content] encodedUnicode];
            NSString * fullPrice = [NSString stringWithFormat:@"%@ %@",price,currency];
            
            NSString * thumbnailURL = [[[element searchWithXPathQuery:@"//@src"] firstObject] content];
            
            if([thumbnailURL rangeOfString:@"http"].location == NSNotFound){
                thumbnailURL = @"http://www.carlotfinance.com/assets/img/car_placeholder.jpg";
            }
            
            carEntity.brand = [[[element searchWithXPathQuery:@"//span[@class='ver15black']/b"] firstObject] content];
            carEntity.fuelType = fuelType;
            carEntity.transmissionType = transmission;
            carEntity.distanceTraveled = distanceTraveled;
            carEntity.price = fullPrice;
            carEntity.thumbnailURL = thumbnailURL;
            carEntity.addURL = [NSString stringWithFormat:@"http://www.cars.bg/%@",[[[element searchWithXPathQuery:@"//@href"] firstObject] content]];
            carEntity.yearOfProduction = [[[[element searchWithXPathQuery:@"//span[@class='year']"] firstObject] content]encodedUnicode];
            
            break;
        }
            
        default:
            break;
    }
    
    
    
    return YES;
}


@end
