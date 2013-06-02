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

@synthesize playerDetail, name, team, replicaTable;

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
    
    if (self.playerDetail.id != 0)
        [self activeAddReplica];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapRecognizer];
}

-(void)tap:(UITapGestureRecognizer *)gr {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)activeAddReplica {
    [self.addReplica setEnabled:YES];
    [self.addReplica setTitleColor:[UIColor colorWithRed:0.22 green:0.33 blue:0.53 alpha:1.0] forState:UIControlStateNormal];
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


-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    [self.replicaTable selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
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
    
    [self activeAddReplica];
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ShowReplicaDetail1"] || [[segue identifier] isEqualToString:@"ShowReplicaDetail2"])
    {
        ReplicaDetailController *replicaDetail = [segue destinationViewController];
        NSIndexPath *myIndexPath = [self.replicaTable indexPathForCell:sender];
        
        replicaDetail.replicaDetail = [self.playerDetail.replicas objectAtIndex:[myIndexPath row]];
        replicaDetail.playerDetailController = self;
    }
    else if ([[segue identifier] isEqualToString:@"AddReplica"])
    {
        ReplicaDetailController *replicaDetail = [segue destinationViewController];
        replicaDetail.replicaDetail = [[Replica alloc] initWithData:0 id_player:self.playerDetail.id name:nil velocity:0];
        replicaDetail.playerDetailController = self;
    }
    
}

@end
