# LFSSegmentedBarController

## Description

LFSSegmentedBarController is a fully customizable tab bar for iOS inspired on Android tab bar. It works with tap gesture on the tabs and scrolling between the tabs.

![](https://s3.amazonaws.com/f.cl.ly/items/3W2W290u0Y1i3o470n2S/LFSSegmentedBarController.gif)

## Usage

LFSSegmentedBarController is inspired on the UITabBarController of native iOS SDK. You can see an example of usage of this controller just below:

    LFSSegmentedBarController *tabBarController = [[LFSSegmentedBarController alloc] init];
    
    // We setup all the view controller that will be inside our tab bar controller
    FirstViewController *firstViewController = [[FirstViewController alloc] initWithNibName:NSStringFromClass([FirstViewController class]) bundle:nil];
    LFSSegmentedBarItem *firstBarItem = [[LFSSegmentedBarItem alloc] initWithTitle:NSLocalizedString(@"Tab 1", nil)];
    [firstViewController setSegmentedBarItem:firstBarItem];
    
    SecondViewController *secondViewController = [[SecondViewController alloc] initWithNibName:NSStringFromClass([SecondViewController class]) bundle:nil];
    LFSSegmentedBarItem *secondBarItem = [[LFSSegmentedBarItem alloc] initWithTitle:NSLocalizedString(@"Tab 2", nil)];
    [secondViewController setSegmentedBarItem:secondBarItem];
    
    ThirdViewController *thirdViewController = [[ThirdViewController alloc] initWithNibName:NSStringFromClass([ThirdViewController class]) bundle:nil];
    LFSSegmentedBarItem *thirdBarItem = [[LFSSegmentedBarItem alloc] initWithTitle:NSLocalizedString(@"Tab 3", nil)];
    [thirdViewController setSegmentedBarItem:thirdBarItem];
    
    // Setting the view controller will configure all the tab bar properties    
    [tabBarController setViewControllers:@[firstViewController, secondViewController, thirdViewController]];
    
    [self.window setRootViewController:tabBarController];
    
## Customizations

This is an example of the fields that are customizable in LFSSegmentedBarController: 

	LFSSegmentedBarController *tabBarController = [[LFSSegmentedBarController alloc] init];

	
    // Font customizations
    [tabBarController setFont:[UIFont systemFontOfSize:17.0]];
    [tabBarController setSelectedFont:[UIFont boldSystemFontOfSize:17.0]];
    
    // Line colors and heights
    [tabBarController.segmentedControl setHighlightLineHeight:3.0f];
    [tabBarController.segmentedControl setLineTintColor:[UIColor whiteColor]];
    [tabBarController.segmentedControl setSelectedSectionLineTintColor:[UIColor colorWithRed:0.15f green:0.67f blue:0.86f alpha:1]];
    
    // Text colors
    [tabBarController.segmentedControl setTextColor:[UIColor colorWithWhite:0.0f alpha:0.9f]];
    [tabBarController.segmentedControl setSelectedTextColor:[UIColor colorWithWhite:0.0f alpha:0.9f]];
    
    // Showing or not showing separator line
    [tabBarController.segmentedControl setShowFullWithLine:NO];
    

## TODO

- Support for landscape mode (by now only works on portrait mode)
