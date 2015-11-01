//
//  JHAloneViewController.h
//  Jhana
//
//  Created by Steven Chung on 10/31/15.
//  Copyright © 2015 TouchTap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHAttentionViewController.h"

@interface JHAloneViewController : UIViewController <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UISegmentedControl *aloneSegmentedControl;
@property (strong, nonatomic) IBOutlet UILabel *personLabel;
@property (strong, nonatomic) IBOutlet UITextField *personTextField;
@property (strong, nonatomic) IBOutlet UIButton *submitButton;
@property (strong, nonatomic) NSMutableDictionary *applicationData;
@end
