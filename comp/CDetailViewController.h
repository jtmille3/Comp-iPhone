//
//  CDetailViewController.h
//  comp
//
//  Created by Jeff Miller on 4/20/13.
//  Copyright (c) 2013 Jeff Miller. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
