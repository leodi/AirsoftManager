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
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        
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

    if (self.game == nil)
        self.game = [Game alloc];
    else
    {
        [self.addPlayerButton setEnabled:YES];
        [self.addPlayerButton setAlpha:1];
    }
    self.date.text = [dateFormatter stringFromDate:[self.game date]];
    self.name.text = [self.game name];
    
    if ([self.game.name length] != 0)
        self.navigationItem.title = [self.game name];
    else
        self.navigationItem.title = @"-";
    
    
    [self reloadPlayers];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapRecognizer];
}

-(void)viewDidAppear:(BOOL)animated {
    [self reloadPlayers];
    [self.playerTable reloadData];
    [self.gameListController.gameTable deselectRowAtIndexPath:[self.gameListController.gameTable indexPathForSelectedRow] animated:YES];
}

-(void)reloadPlayers {
    NSArray *players = [self.game getAllPlayers];
    self.nbPlayers.text = [NSString stringWithFormat:@"%d Joueur%s", [players count], ([players count] > 1 ? "s" : "")];
    self.playersSection = [Player playersArrayToSection:players];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"addPlayerFromGame"])
    {
        PlayerListController *playerListController = [segue destinationViewController];
        playerListController.isFromGames = YES;
        playerListController.parentGameDetailController = self;
    }
    else if ([[segue identifier] isEqualToString:@"showPlayerFromGame1"] || [[segue identifier] isEqualToString:@"showPlayerFromGame2"])
    {
        NSIndexPath *myIndexPath;
        PlayerDetailController *playerDetail = [segue destinationViewController];
        
        myIndexPath = [self.playerTable indexPathForCell:sender];
        playerDetail.playerDetail = [[self.playersSection objectAtIndex:myIndexPath.section] objectAtIndex:myIndexPath.row];
        playerDetail.isFromGames = YES;
        playerDetail.gameDetailController = self;
    }
}

-(void)tap:(UITapGestureRecognizer *)gr {
    [self.view endEditing:YES];
}

-(void) cancelDate {
    [self.date resignFirstResponder];
}

- (IBAction)saveGame:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    
    [self.addPlayerButton setEnabled:YES];
    [self.addPlayerButton setAlpha:1];
    
    self.game.name = self.name.text;
    self.game.date = [dateFormatter dateFromString:self.date.text];
    [self.game save];
    
    [self.navigationItem setTitle:[self.game name]];
    
    [self.saveButton setEnabled:NO];
    [self.gameListController reloadGames];
    [self.gameListController.gameTable reloadData];
}

- (IBAction)nameEdited:(id)sender {
    [self.saveButton setEnabled:YES];
}

-(void)addPlayer:(Player *)player {
    [self.game addPlayer:player];
    [self reloadPlayers];
}

-(void)removePlayer:(Player *)player {
    [self.game removePlayer:player];
    [self reloadPlayers];
}

-(void) changeDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    
    [self.saveButton setEnabled:YES];
    [self.date setText:[dateFormatter stringFromDate:self.datePicker.date]];
    [self.date resignFirstResponder];
}

-(void)setChronyStateFor:(Player *)player state:(BOOL)state {
    [self.game setChronyStateFor:player state:state];
}

-(void)setPaymentStateFor:(Player *)player state:(BOOL)state {
    [self.game setPaymentStateFor:player state:state];
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
	static NSString *kCellID = @"GamePlayer";
	Player *player;
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCellID];
    }
    
    player = [[self.playersSection objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
    cell.textLabel.text = player.name;
    cell.detailTextLabel.text = player.team;

    if (player.chrony && player.payment)
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    else
        [cell setAccessoryType:UITableViewCellAccessoryNone];
	return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Player *player = [[self.playersSection objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
        
        if ([[self.playersSection objectAtIndex:indexPath.section] count] == 1)
            [indexes addIndex: indexPath.section];
        
        [self removePlayer:player];
        [self reloadPlayers];
        
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView deleteSections:indexes withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
    }
}

@end
