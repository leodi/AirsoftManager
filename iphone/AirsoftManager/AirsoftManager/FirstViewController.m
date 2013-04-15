//
//  FirstViewController.m
//  AirsoftManager
//
//  Created by Paul Bizouard on 13/04/2013.
//  Copyright (c) 2013 Paul Bizouard. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController
@synthesize message;
@synthesize textfield;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)reagir:(id)sender {
    NSString *msg = [[NSString alloc] initWithFormat:@"Ok"];
    message.text = msg;
}


- (IBAction)textChange:(id)sender forEvent:(UIEvent *)event {
    //message.text = textfield.text;
    NSString *msg = [[NSString alloc] initWithFormat:@"Ok222"];
    message.text = msg;
}
@end
