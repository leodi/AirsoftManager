//
//  CorrespFPSControllerViewController.h
//  AirsoftManager
//
//  Created by Paul Bizouard on 14/04/2013.
//  Copyright (c) 2013 Paul Bizouard. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CorrespFPSWeightController;
@class CorrespFPSUnitController;

@interface CorrespFPSController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *view;

@property (nonatomic, retain) IBOutlet UIButton *base_weight;
@property (nonatomic, retain) IBOutlet UIButton *base_unit;
@property (weak, nonatomic) IBOutlet UITextField *base_speed;

@property (weak, nonatomic) IBOutlet UIButton *result_weight;
@property (weak, nonatomic) IBOutlet UIButton *result_unit;
@property (weak, nonatomic) IBOutlet UILabel *result_speed;

@property (nonatomic, retain) IBOutlet CorrespFPSWeightController *weightSubview;
@property (nonatomic, retain) IBOutlet CorrespFPSUnitController *unitSubview;

- (void)calcResult;

- (IBAction)loadWeightView:(id)sender;
- (IBAction)loadUnitView:(id)sender;

- (IBAction)changeSpeed:(id)sender;


@end
