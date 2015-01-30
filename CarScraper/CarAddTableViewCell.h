//
//  CarAddTableViewCell.h
//  CarScraper
//
//  Created by Nikolay Andonov on 1/30/15.
//  Copyright (c) 2015 Nikolay Andonov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarAddTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *brandLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearOfProductionLabel;
@property (weak, nonatomic) IBOutlet UILabel *engineTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *transmissionLabel;
@property (weak, nonatomic) IBOutlet UILabel *powerLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceTraveledLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *carImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


@end
