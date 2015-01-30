//
//  CarAddsTableViewController.m
//  CarScraper
//
//  Created by Nikolay Andonov on 1/30/15.
//  Copyright (c) 2015 Nikolay Andonov. All rights reserved.
//

#import "CarAddsTableViewController.h"
#import "CarAddTableViewCell.h"
#import "CarEntity.h"

static NSString *const kCellIdentifier = @"CellIdentifier";

@interface CarAddsTableViewController ()

@end

@implementation CarAddsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = @"Автомобили";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.carsModel.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CarAddTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    CarEntity * carEntity = self.carsModel[indexPath.row];
    cell.imageView.image= nil;
    cell.brandLabel.text = carEntity.brand;
    cell.yearOfProductionLabel.text = carEntity.yearOfProduction;
    cell.transmissionLabel.text = carEntity.transmissionType;
    cell.distanceTraveledLabel.text = carEntity.distanceTraveled;
    cell.powerLabel.text = carEntity.horsePower;
    cell.engineTypeLabel.text = carEntity.fuelType;
    cell.priceLabel.text = carEntity.price;
    
    if(!cell.activityIndicator.isAnimating){
        [cell.activityIndicator startAnimating];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData * imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:carEntity.thumbnailURL]];
        UIImage * image = [UIImage imageWithData:imageData];
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.carImageView.image =image;
           
        });
    });
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CarEntity * carEntity = self.carsModel[indexPath.row];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:carEntity.addURL]];
    
}

@end
