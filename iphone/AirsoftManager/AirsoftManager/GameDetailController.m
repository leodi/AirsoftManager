//
//  GameDetailController.m
//  AirsoftManager
//
//  Created by Paul Bizouard on 01/06/2013.
//  Copyright (c) 2013 Paul Bizouard. All rights reserved.
//

#import "GameDetailController.h"

@implementation GameDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/YYYY"];
        
    self.datePicker = [[UIDatePicker alloc] init];
    [self.datePicker addTarget:self action:nil forControlEvents:UIControlEventValueChanged];
    [self.datePicker setDatePickerMode:UIDatePickerModeDate];
    if ([self.game.name length] != 0)
        [self.datePicker setDate:[self.game date]];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(changeDate)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelDate)];
    [toolbar setItems:[NSArray arrayWithObjects:doneButton,cancelButton,nil]];
    
    self.dateToolbar = toolbar;
    
    self.date.inputView = self.datePicker;
    self.date.inputAccessoryView = self.dateToolbar;

    if ([self.game.name length] != 0)
        self.date.text = [dateFormatter stringFromDate:[self.game date]];
    
    if ([self.game.name length] != 0)
    {
        self.name.text = [self.game name];
        self.navigationItem.title = [self.game name];
        
        [self.saveButton setEnabled:YES];
    }
    else
        self.navigationItem.title = @"-";
    
    [self reloadPlayers];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapRecognizer];
}

-(void)reloadPlayers {
    self.playersSection = [Player playersArrayToSection:[self.game getAllPlayers]];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"addPlayerFromGame"])
    {
        PlayerListController *playerListController = [segue destinationViewController];
        playerListController.isFromGames = YES;
        playerListController.parentGameDetailController = self;
    }
}

-(void)tap:(UITapGestureRecognizer *)gr {
    [self.view endEditing:YES];
}

-(void) cancelDate {
    [self.date resignFirstResponder];
}

-(void)addPlayer:(Player *)player {
    [self.game addPlayer:player];
    [self reloadPlayers];
    [self.playerTable reloadData];
}

-(void)removePlayer:(Player *)player {
    //[self.game addPlayer:player];
}

-(void) changeDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/YYYY"];
    
    [self.saveButton setEnabled:YES];
    [self.date setText:[dateFormatter stringFromDate:self.datePicker.date]];
    [self.date resignFirstResponder];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.playersSection count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.playersSection objectAtIndex:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[[self.playersSection objectAtIndex:section] objectAtIndex:0] team];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *kCellID = @"Player";
	Player *player;
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCellID];
    }
    
    player = [[self.playersSection objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
    cell.textLabel.text = player.name;
    cell.detailTextLabel.text = player.team;
    
	return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Player *player;
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        player = [[self.playersSection objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
        [self removePlayer:player];
        [self reloadPlayers];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

@end
