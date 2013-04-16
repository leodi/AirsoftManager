//
//  PlayerDetailController.m
//  AirsoftManager
//
//  Created by Paul Bizouard on 15/04/2013.
//  Copyright (c) 2013 Paul Bizouard. All rights reserved.
//

#import "PlayerDetailController.h"

@interface PlayerDetailController ()

@end

@implementation PlayerDetailController

@synthesize playerDetail, name, team, replicaList;

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
    
    self.navigationItem.title = [self.playerDetail name];
    self.name.text = [self.playerDetail name];
    self.team.text = [self.playerDetail team];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark Table view methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.playerDetail.replicas count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *kCellID = @"Replica";
	Replica *replica;
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];

    
    replica = [self.playerDetail.replicas objectAtIndex:indexPath.row];
    cell.textLabel.text = replica.name;
    cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%i fps", replica.velocity];
    
	return cell;
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Replica *replica;
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        replica = [self.playerDetail.replicas objectAtIndex:indexPath.row];
        
        [replica delete];
        
        self.playerDetail.replicas = [[NSMutableArray alloc] initWithArray:[Replica getAllReplicasByPlayerId:self.playerDetail.id]];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


- (IBAction)name:(id)sender {
    [self.navigationItem rightBarButtonItem].enabled = YES;
}

- (IBAction)team:(id)sender {
    [self.navigationItem rightBarButtonItem].enabled = YES;
}

- (IBAction)save:(id)sender {
    [self.view endEditing:YES];
    
    self.playerDetail.name = name.text;
    self.playerDetail.team = team.text;

    [self.playerDetail save];
    
    [self.navigationItem setTitle:[self.playerDetail name]];
    [[self.navigationItem rightBarButtonItem] setEnabled:NO];
    
    [self.playerListController reloadPlayers];
    [self.playerListController.tableView reloadData];
}
@end
