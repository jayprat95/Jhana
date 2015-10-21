//
//  TPTabBarController.m
//  TardyPost
//
//  Created by Jayanth Prathipati on 6/12/15.
//  Copyright (c) 2015 TouchTap Studios. All rights reserved.
//

#import "TPTabBarController.h"
#import <BFPaperButton.h>
#import <Canvas.h>
#import "UIColor+BFPaperColors.h"

@interface TPTabBarController ()

@end

@implementation TPTabBarController

@synthesize plusController;
@synthesize centerButton;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addCenterButtonWithImage:[UIImage imageNamed:@"hood.png"] highlightImage:[UIImage imageNamed:@"hood-selected.png"] target:self action:@selector(buttonPressed:)];
    [[UITabBar appearance] setTintColor:[UIColor paperColorRed]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// Create a custom UIButton and add it to the center of our tab bar
- (void)addCenterButtonWithImage:(UIImage *)buttonImage highlightImage:(UIImage *)highlightImage target:(id)target action:(SEL)action
{
    BFPaperButton *circle1 = [[BFPaperButton alloc] initWithFrame:CGRectMake(20, 468, 86, 86) raised:YES];
    [circle1 setBackgroundColor:[UIColor paperColorRed]];
    [circle1 setImage:[UIImage imageNamed:@"Up-50.png" ] forState:UIControlStateNormal];
    [circle1 setImage:[UIImage imageNamed:@"Up-50.png" ] forState:UIControlStateSelected];

    [circle1 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    circle1.cornerRadius = circle1.frame.size.width / 2;
    circle1.rippleFromTapLocation = NO;
    
    circle1.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height;
    if (heightDifference < 0) {
        circle1.center = self.tabBar.center;
    } else {
        CGPoint center = self.tabBar.center;
        center.y = center.y - heightDifference/2.0;
        circle1.center = center;
    }
    
    [self.view addSubview:circle1];
    
}



- (void)buttonPressed:(id)sender
{ 
    
}


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{

}

- (BOOL)tabBarHidden {
    return self.centerButton.hidden && self.tabBar.hidden;
}

- (void)setTabBarHidden:(BOOL)tabBarHidden
{
    self.centerButton.hidden = tabBarHidden;
    self.tabBar.hidden = tabBarHidden;
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
