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
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;

@end

@implementation JHAttentionGestureViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Attention";
    self.attentionValue = 2;
    [self.textLabel setText:@"Neutral"];
    [self.view setBackgroundColor:[UIColor paperColorTeal]];
    [[self.nextButton layer] setBorderWidth:1.0f];
    [[self.nextButton layer] setBorderColor:[UIColor whiteColor].CGColor];
    
    [self.pageControl setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
    
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
    [self performSegueWithIdentifier:@"attentionSegue" sender:self];
}

- (IBAction)cancelButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - gesture delegate 

- (void) didSwipe:(UISwipeGestureRecognizer *)recognizer{
    //swipe up
    if([recognizer direction] == UISwipeGestureRecognizerDirectionUp){
        
        if(self.attentionValue < 4) {
            self.attentionValue++;
            self.pageControl.currentPage++;
        }
        
    }else{
        //Swipe from left to right
        //Do your functions here
        
        if(self.attentionValue > 0) {
            self.attentionValue--;
            self.pageControl.currentPage--;
        }

    }
    
    if (self.attentionValue == 0) {
        
        [UIView animateWithDuration:0.25 animations:^{
            [self.textLabel setText:@"Very Unfocused"];
            self.view.backgroundColor = [UIColor paperColorPurple800];
        }];

    }
    else if (self.attentionValue == 1) {
       
        [UIView animateWithDuration:0.25 animations:^{
             [self.textLabel setText:@"Unfocused"];
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
            [self.textLabel setText:@"Focused"];
            self.view.backgroundColor = [UIColor paperColorLightGreen];
        }];
    }
    else if (self.attentionValue == 4) {
        
        [UIView animateWithDuration:0.25 animations:^{
            [self.textLabel setText:@"Very Focused"];
            self.view.backgroundColor = [UIColor paperColorOrange];
        }];
    }

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"attentionSegue"]) {
        JHLocationViewController *locationViewController = (JHLocationViewController *)segue.destinationViewController;
        self.applicationData[@"attention"] = [NSNumber numberWithInt:self.attentionValue];
        locationViewController.applicationData = self.applicationData;
    }
}

@end
