//
//  AppDelegate.m
//  LFSSegmentedBarControllerExample
//
//  Created by David Cortés Fulla on 7/5/15.
//  Copyright (c) 2015 Lafosca. All rights reserved.
//

#import "AppDelegate.h"
#import <LFSSegmentedBarController/LFSSegmentedBarController.h>

#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    LFSSegmentedBarController *tabBarController = [[LFSSegmentedBarController alloc] init];
    
    [tabBarController.segmentedControl setHighlightLineHeight:3.0f];
    [tabBarController.segmentedControl setTextColor:[UIColor colorWithWhite:0.0f alpha:0.9f]];
    [tabBarController.segmentedControl setSelectedTextColor:[UIColor colorWithWhite:0.0f alpha:0.9f]];
    [tabBarController.segmentedControl setShowFullWithLine:NO];
    
    FirstViewController *firstViewController = [[FirstViewController alloc] initWithNibName:NSStringFromClass([FirstViewController class]) bundle:nil];
    LFSSegmentedBarItem *firstBarItem = [[LFSSegmentedBarItem alloc] initWithTitle:NSLocalizedString(@"Tab 1", nil)];
    [firstBarItem setTintColor:[UIColor redColor]];
    [firstViewController setSegmentedBarItem:firstBarItem];
    
    SecondViewController *secondViewController = [[SecondViewController alloc] initWithNibName:NSStringFromClass([SecondViewController class]) bundle:nil];
    LFSSegmentedBarItem *secondBarItem = [[LFSSegmentedBarItem alloc] initWithTitle:NSLocalizedString(@"Tab 2", nil)];
    [secondBarItem setTintColor:[UIColor greenColor]];
    [secondViewController setSegmentedBarItem:secondBarItem];
    
    ThirdViewController *thirdViewController = [[ThirdViewController alloc] initWithNibName:NSStringFromClass([ThirdViewController class]) bundle:nil];
    LFSSegmentedBarItem *thirdBarItem = [[LFSSegmentedBarItem alloc] initWithTitle:NSLocalizedString(@"Tab 3", nil)];
    [thirdBarItem setTintColor:[UIColor yellowColor]];
    [thirdViewController setSegmentedBarItem:thirdBarItem];
    
    [tabBarController setViewControllers:@[firstViewController, secondViewController, thirdViewController]];
    [tabBarController setSelectedIndex:1 animated:NO];
    
    [self.window setRootViewController:tabBarController];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
