//
//  JHAttentionGestureViewController.m
//  Jhana
//
//  Created by Jayanth Prathipati on 11/2/15.
//  Copyright © 2015 TouchTap. All rights reserved.
//

#import "JHAttentionGestureViewController.h"
#import "UIColor+BFPaperColors.h"
#import <QuartzCore/QuartzCore.h>

@interface JHAttentionGestureViewController ()
@property (strong, nonatomic) IBOutlet UILabel *textLabel;
@property int attentionValue;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation JHAttentionGestureViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.attentionValue = 2;
    [self.textLabel setText:@"Neutral"];
    [self.view setBackgroundColor:[UIColor paperColorTeal]];
    [[self.nextButton layer] setBorderWidth:1.0f];
    [[self.nextButton layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    //up gesture
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [self.view addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
    [self.view addGestureRecognizer:recognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextButtonClicked:(id)sender {
    
    //write code in here
}

#pragma mark - gesture delegate 

- (void) didSwipe:(UISwipeGestureRecognizer *)recognizer{
    //swipe up
    if([recognizer direction] == UISwipeGestureRecognizerDirectionUp){
        
        if(self.attentionValue < 4) {
            self.attentionValue++;
            NSLog(@"%d", self.attentionValue);
        }
        
    }else{
        //Swipe from left to right
        //Do your functions here
        
        if(self.attentionValue > 0) {
            self.attentionValue--;
            NSLog(@"%d", self.attentionValue);
        }

    }
    
    if (self.attentionValue == 0) {
        
        [UIView animateWithDuration:0.25 animations:^{
            [self.textLabel setText:@"Very Unattentive"];
            self.view.backgroundColor = [UIColor paperColorPurple800];
        }];

    }
    else if (self.attentionValue == 1) {
       
        [UIView animateWithDuration:0.25 animations:^{
             [self.textLabel setText:@"Unattentive"];
            self.view.backgroundColor = [UIColor paperColorIndigo];
        }];
    }
    else if (self.attentionValue == 2 ) {
        
        [UIView animateWithDuration:0.25 animations:^{
            [self.textLabel setText:@"Neutral"];
            self.view.backgroundColor = [UIColor paperColorTeal];
        }];
    }
    else if (self.attentionValue == 3) {
        
        [UIView animateWithDuration:0.25 animations:^{
            [self.textLabel setText:@"Attentive"];
            self.view.backgroundColor = [UIColor paperColorLightGreen];
        }];
    }
    else if (self.attentionValue == 4) {
        
        [UIView animateWithDuration:0.25 animations:^{
            [self.textLabel setText:@"Very Attentive"];
            self.view.backgroundColor = [UIColor paperColorOrange];
        }];
    }

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
