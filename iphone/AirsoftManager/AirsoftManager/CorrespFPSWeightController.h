//
//  CorrespFPSWeightController.h
//  AirsoftManager
//
//  Created by Paul Bizouard on 14/04/2013.
//  Copyright (c) 2013 Paul Bizouard. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CorrespFPSController;

@interface CorrespFPSWeightController : UITableViewController

@property (nonatomic, retain) NSArray *dataArray;
@property (nonatomic, retain) NSString *selectedRow;
@property (retain) IBOutlet UIButton *parentButtonCaller;
@property (retain) CorrespFPSController *parentView;
@end
