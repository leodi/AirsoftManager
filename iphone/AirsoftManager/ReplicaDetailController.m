//
//  ReplicaDetailController.m
//  AirsoftManager
//
//  Created by Paul Bizouard on 16/04/2013.
//  Copyright (c) 2013 Paul Bizouard. All rights reserved.
//

#import "ReplicaDetailController.h"

@interface ReplicaDetailController ()

@end

@implementation ReplicaDetailController

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
    
    self.navigationItem.title = [self.replicaDetail name];
    self.playerLabel.text = [self.playerDetailController.playerDetail name];
    self.replicaText.text = [self.replicaDetail name];
    self.velocityText.text = [[NSString alloc] initWithFormat:@"%d", [self.replicaDetail velocity]];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapRecognizer];
}

-(void) viewWillDisappear:(BOOL)animated {
    [self.playerDetailController.replicaTable deselectRowAtIndexPath:[self.playerDetailController.replicaTable indexPathForSelectedRow] animated:YES];
}

-(void)tap:(UITapGestureRecognizer *)gr {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)name:(id)sender {
    [self.navigationItem rightBarButtonItem].enabled = YES;
}

- (IBAction)velocity:(id)sender {
    [self.navigationItem rightBarButtonItem].enabled = YES;
}

- (IBAction)save:(id)sender {
    [self.view endEditing:YES];
    
    self.replicaDetail.name = self.replicaText .text;
    self.replicaDetail.velocity = [self.velocityText.text intValue];
    
    [self.replicaDetail save];
    
    [self.navigationItem setTitle:[self.replicaDetail name]];
    [[self.navigationItem rightBarButtonItem] setEnabled:NO];
    
    [self.playerDetailController.playerDetail getReplicas];
    [self.playerDetailController.replicaTable reloadData];
    
    [self.playerDetailController.replicaTable deselectRowAtIndexPath:[self.playerDetailController.replicaTable indexPathForSelectedRow] animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
