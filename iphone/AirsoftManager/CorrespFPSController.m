//
//  CorrespFPSControllerViewController.m
//  AirsoftManager
//
//  Created by Paul Bizouard on 14/04/2013.
//  Copyright (c) 2013 Paul Bizouard. All rights reserved.
//

#import "CorrespFPSController.h"
#import "CorrespFPSWeightController.h"
#import "CorrespFPSUnitController.h"

@interface CorrespFPSController ()

@end

@implementation CorrespFPSController
@synthesize base_weight;
@synthesize base_unit;
@synthesize base_speed;

@synthesize result_weight;
@synthesize result_unit;
@synthesize result_speed;

@synthesize weightSubview, unitSubview;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [base_weight setTitle:@"0.25" forState: UIControlStateNormal];
    [base_unit setTitle:@"FPS" forState: UIControlStateNormal];
    
    [result_weight setTitle:@"0.20" forState: UIControlStateNormal];
    [result_unit setTitle:@"FPS" forState: UIControlStateNormal];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tapRecognizer];
    [self calcResult];
}

-(void)tap:(UITapGestureRecognizer *)gr {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)calcResult {
    float base_joule = 0;
    
    if ([base_unit.titleLabel.text isEqualToString:@"J"])
        base_joule = [base_speed.text floatValue];
    else
    {
        float base_ms = 0;
        if ([base_unit.titleLabel.text isEqualToString:@"FPS"])
            base_ms = [base_speed.text floatValue] * 0.304;
        else
            base_ms = [base_speed.text floatValue];
        base_joule = (0.5 * (([base_weight.titleLabel.text floatValue] / 1000) * (pow(base_ms, 2))));
    }
    
    if ([result_unit.titleLabel.text isEqualToString:@"J"])
        [result_speed setText:[NSString stringWithFormat:@"%.0f", ceil(base_joule)]];
    else
    {
        float result_fps = sqrt((base_joule * 2) / ([result_weight.titleLabel.text floatValue] / 1000)) * 3.2894;
        if ([result_unit.titleLabel.text isEqualToString:@"M/s"])
            [result_speed setText:[NSString stringWithFormat:@"%.0f", ceil(result_fps * 0.304)]];
        else
            [result_speed setText:[NSString stringWithFormat:@"%.0f", ceil(result_fps)]];
    }
}

- (IBAction)loadWeightView:(id)sender {
    UIButton *button = (UIButton *) sender;
    
    weightSubview = [[CorrespFPSWeightController alloc] initWithStyle:UITableViewStyleGrouped];
    weightSubview.selectedRow = button.titleLabel.text;
    weightSubview.parentButtonCaller = button;
    weightSubview.parentView = self;
    
    [self.navigationController pushViewController:weightSubview animated:YES];
}

- (IBAction)loadUnitView:(id)sender {
    UIButton *button = (UIButton *) sender;
    
    unitSubview = [[CorrespFPSUnitController alloc] initWithStyle:UITableViewStyleGrouped];
    unitSubview.selectedRow = button.titleLabel.text;
    unitSubview.parentButtonCaller = button;
    unitSubview.parentView = self;
    
    [self.navigationController pushViewController:unitSubview animated:YES];
}


- (IBAction)changeSpeed:(id)sender {
    [self calcResult];
}
@end
