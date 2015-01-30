//
//  MenuTableViewController.m
//  CarScraper
//
//  Created by Nikolay Andonov on 1/30/15.
//  Copyright (c) 2015 Nikolay Andonov. All rights reserved.
//

#import "MenuTableViewController.h"
#import "DataManager.h"
#import "CarAddsTableViewController.h"

NSString * const kCarAdsStoryBoardIdentifier = @"CarAddsTableViewControllerID";

@interface MenuTableViewController () <DataDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedController;
@property (weak, nonatomic) IBOutlet UITableViewCell *limitSelectField;
@property (weak, nonatomic) IBOutlet UITextField *addLimitTextField;
@property (weak, nonatomic) IBOutlet UITextField *concurencyTextField;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (strong,nonatomic) DataManager * dataManger;

@end

@implementation MenuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.limitSelectField.contentView.alpha = 0.3;
    self.limitSelectField.userInteractionEnabled=NO;
    self.dataManger = [DataManager sharedInstance];

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)limitSwitch:(id)sender {
    UISwitch * switchControll = (UISwitch*)sender;
    
    if(switchControll.isOn){
        self.limitSelectField.contentView.alpha = 1;
        self.limitSelectField.userInteractionEnabled=YES;
    }
    else{
        self.addLimitTextField.text = @"";
        self.limitSelectField.contentView.alpha = 0.3;
        self.limitSelectField.userInteractionEnabled=NO;
    }
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if(indexPath.row == 2 && indexPath.section == 0){
        [self.addLimitTextField becomeFirstResponder];
    }
    else if (indexPath.row == 3 && indexPath.section==0){
        [self.concurencyTextField becomeFirstResponder];
    }
    
    
}

- (IBAction)startScraping:(id)sender {
    
    [self.addLimitTextField resignFirstResponder];
    [self.concurencyTextField resignFirstResponder];
    
    [self.dataManger setSettingsForLevelOfConcurency:[self.concurencyTextField.text integerValue] andAddCounts:[self.addLimitTextField.text integerValue]];
    if(self.segmentedController.selectedSegmentIndex==0){
        [self.dataManger getAndStoreAdsForCarmarketBGWithDownloadDelegate:self];
    }
    else{
        [self.dataManger getAndStoreAdsForCarsBGWithDownloadDelegate:self];
    }
    
    
}

- (IBAction)showCurrentAdds:(id)sender {
    [self openSavedAds];

}

- (IBAction)deleteAllAdds:(id)sender {
    [self.dataManger deleteAllAds];
}


-(void)openSavedAds{
   NSArray*model = [self.dataManger savedAdsModel];
    CarAddsTableViewController * carAddsTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:kCarAdsStoryBoardIdentifier];
    carAddsTableViewController.carsModel = model;
    [self.navigationController pushViewController:carAddsTableViewController animated:YES];
}

#pragma mark - Data delegates

-(void)downloadDidFinish{
     self.progressView.progress = 1.0;
}

-(void)downloadDidUpdateWithSize:(NSInteger)downloadCurrentSize andProgres:(NSInteger)percentageProgress{

    self.progressView.progress = percentageProgress  / 100.0;
    self.tableView.userInteractionEnabled = NO;
    
}

-(void)savingDidFinish{
    self.progressView.progress = 0.0;
    self.tableView.userInteractionEnabled = YES;
    [self openSavedAds];
}
@end
