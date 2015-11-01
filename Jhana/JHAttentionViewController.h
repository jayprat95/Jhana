//
//  JHAttentionViewController.h
//  Jhana
//
//  Created by Steven Chung on 10/28/15.
//  Copyright © 2015 TouchTap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHLocationViewController.h"

@interface JHAttentionViewController : UIViewController
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet UISlider *attentionSlider;
@property (strong, nonatomic) IBOutlet UILabel *attentionLabel;

@property (strong, nonatomic) NSArray *attentionValues;

- (IBAction)cancelButtonClicked:(id)sender;
@end