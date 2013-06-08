//
//  PlayerListController.m
//  AirsoftManager
//
//  Created by Paul Bizouard on 14/04/2013.
//  Copyright (c) 2013 Paul Bizouard. All rights reserved.
//

#import "PlayerListController.h"
#import "Player.h"

@interface PlayerListController ()

@end

@implementation PlayerListController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Joueurs";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //self.searchDisplayController.searchResultsDelegate = self;
    [self reloadPlayers];
    
    
    if (self.isFromGames)
    {
        self.toolbar = [[UIToolbar alloc] init];
        [self.toolbar sizeToFit];
        [self.toolbar setBarStyle:UIBarStyleBlack];
        [self.toolbar setAlpha:0];
        
        CGFloat toolbarHeight = self.toolbar.frame.size.height;
        CGRect viewBounds = self.parentViewController.view.bounds;
        CGFloat rootViewHeight = CGRectGetHeight(viewBounds);
        CGFloat rootViewWidth = CGRectGetWidth(viewBounds);
        
        CGRect rectArea = CGRectMake(0, rootViewHeight - toolbarHeight, rootViewWidth, toolbarHeight);
        [self.toolbar setFrame:rectArea];
        [self.navigationController.view addSubview:self.toolbar];
        
        UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Valider la liste" style:UIBarButtonItemStyleDone target:self action:@selector(validateCheckedPlayers)];
        [self.toolbar setItems:@[button]];
        
        self.checkedResult = [[NSMutableDictionary alloc] init];
        [self.seachBar setHidden:YES];
    }

}

-(void)viewDidAppear:(BOOL)animated {
    [self reloadPlayers];
    [self.tableView reloadData];
}

-(void)viewDidDisappear:(BOOL)animated {
    [self.toolbar removeFromSuperview];
}

-(void)reloadPlayers {
    if (self.isFromGames)
        self.players = [[NSArray alloc] initWithArray:[[Player sharedPlayer] getAllPlayersWitchIsNotInGame:self.parentGameDetailController.game]];
    else
        self.players = [[NSArray alloc] initWithArray:[[Player sharedPlayer] getAllPlayers]];
    self.playersSection = [Player playersArrayToSection:self.players];
}

-(void)validateCheckedPlayers {
    NSString *key;
    
    for (key in [self.checkedResult allKeys])
        [self.parentGameDetailController addPlayer:[self.checkedResult objectForKey:key]];
    
    [self.parentGameDetailController.playerTable reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope {
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"(SELF.name contains[cd] %@) OR (SELF.team contains[cd] %@)", searchText, searchText];
    self.searchResults = [self.players filteredArrayUsingPredicate:resultPredicate];
 }


 -(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
     [self
        filterContentForSearchText:searchString
        scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
               objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
     return (YES);
 }

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if (self.isFromGames == YES && [identifier isEqualToString:@"ShowPlayerDetail1"])
    {
        return NO;
    }
    return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ShowPlayerDetail1"] || [[segue identifier] isEqualToString:@"ShowPlayerDetail2"])
    {
        NSIndexPath *myIndexPath;
        PlayerDetailController *playerDetail = [segue destinationViewController];
        
        if (sender == self.searchDisplayController.searchResultsTableView)
        {
            myIndexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            playerDetail.playerDetail = [self.searchResults objectAtIndex:[myIndexPath row]];
        }
        else
        {
            myIndexPath = [self.tableView indexPathForCell:sender];
            playerDetail.playerDetail = [[self.playersSection objectAtIndex:myIndexPath.section] objectAtIndex:myIndexPath.row];
        }
        
        playerDetail.playerListController = self;
    }
    else if ([[segue identifier] isEqualToString:@"AddPlayer"])
    {
        PlayerDetailController *playerDetail = [segue destinationViewController];
        
        playerDetail.playerDetail = [Player alloc];
        playerDetail.playerListController = self;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
        return 1;
    else
        return [self.playersSection count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count;
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
        count = [self.searchResults count];
    else
        count = [[self.playersSection objectAtIndex:section] count];
    
    return (count);
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView)
        return nil;
    else
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
    if (tableView == self.searchDisplayController.searchResultsTableView)
        player = [self.searchResults objectAtIndex:indexPath.row];
    else
        player = [[self.playersSection objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

    if (self.isFromGames == YES)
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    
    cell.textLabel.text = player.name;
    cell.detailTextLabel.text = player.team;
    
	return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isFromGames == YES || tableView == self.searchDisplayController.searchResultsTableView)
        return NO;
    else
        return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Player *player = [[self.playersSection objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
    
    if ([[self.playersSection objectAtIndex:indexPath.section] count] == 1)
        [indexes addIndex: indexPath.section];
    
    [player delete];
    
    [self reloadPlayers];
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else
    {
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView deleteSections:indexes withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
    }
}


#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        [self performSegueWithIdentifier:@"ShowPlayerDetail1" sender:tableView];
    }
    else if (self.isFromGames == YES)
    {
        [self.toolbar setAlpha:1];
        
        Player *player = [[self.playersSection objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        NSString *key = [[NSString alloc] initWithFormat:@"%d", [player id]];
        
        if ([cell accessoryType] == UITableViewCellAccessoryNone)
        {
            [self.checkedResult setObject:player forKey:key];
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
        else
        {
            [self.checkedResult removeObjectForKey:key];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
        
        //[self.parentGameDetailController addPlayer:[[self.playersSection objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
        //[self.parentGameDetailController.playerTable reloadData];
        //[self.navigationController popViewControllerAnimated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CGFloat ret;
    
    if (tableView == self.searchDisplayController.searchResultsTableView || !self.isFromGames || section != [self.playersSection count] - 1)
        ret = 10.0f;
    else
        ret = 60.0f;
    
    return (ret);
}

@end
