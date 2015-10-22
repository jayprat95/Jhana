//
//  TPTabBarController.h
//  TardyPost
//
//  Created by Jayanth Prathipati on 6/12/15.
//  Copyright (c) 2015 TouchTap Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPTabBarController : UITabBarController
@property(nonatomic, weak) IBOutlet UIViewController *plusController;
@property(nonatomic, weak) IBOutlet UIButton *centerButton;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property(nonatomic, assign) BOOL tabBarHidden;

-(void)addCenterButtonWithImage:(UIImage *)buttonImage highlightImage:(UIImage *)highlightImage target:(id)target action:(SEL)action;

@end
