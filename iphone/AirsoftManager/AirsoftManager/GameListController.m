//
//  GameListController.m
//  AirsoftManager
//
//  Created by Paul Bizouard on 25/04/2013.
//  Copyright (c) 2013 Paul Bizouard. All rights reserved.
//

#import "GameListController.h"

@interface GameListController ()

@end

@implementation GameListController

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
    [self reloadGames];
    
}

-(void)reloadGames {
    self.gamesSection = [self gamesArrayToSection:[[Game sharedGame] getAllGames]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSArray *)gamesArrayToSection:(NSArray *)games {
    //NSMutableArray *list = [[NSMutableArray alloc] init];
    
    NSMutableArray *future = [[NSMutableArray alloc] init];
    NSMutableArray *past = [[NSMutableArray alloc] init];
    
    NSDate *now = [NSDate date];
    NSEnumerator *e = [games objectEnumerator];
    Game *game;
    
    while (game = [e nextObject])
    {
        if ([game.date compare:now] == NSOrderedDescending)
        {
            [future addObject:game];
        }
        else
        {
            [past addObject:game];
        }  
    }
    return ([[NSArray alloc] initWithObjects:future,past, nil]);
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ShowMatchDetail1"] || [[segue identifier] isEqualToString:@"ShowMatchDetail2"])
    {
        NSIndexPath *myIndexPath = [self.gameTable indexPathForCell:sender];
        GameDetailController *gameDetail = [segue destinationViewController];
        
        gameDetail.game = [[self.gamesSection objectAtIndex:[myIndexPath section]] objectAtIndex:[myIndexPath row]];
        gameDetail.gameListController = self;
    }
    else if ([[segue identifier] isEqualToString:@"AddMatch"])
    {
        GameDetailController *gameDetail = [segue destinationViewController];
        //gameDetail.game = [[Game alloc] initWithData:0 id_player:self.playerDetail.id name:nil velocity:0];
        gameDetail.gameListController = self;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.gamesSection count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.gamesSection objectAtIndex:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0)
        return @"Futures";
    else
        return @"Passees";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *kCellID = @"Game";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter  setDateFormat:@"dd/MM/yyyy"];
	Game *game;
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCellID];
    }
    game = [[self.gamesSection objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = game.name;
    cell.detailTextLabel.text = [formatter stringFromDate:game.date];
    
	return cell;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Game *game;
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        game = [[self.gamesSection objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
        [game delete];
        
        [self reloadGames];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end
