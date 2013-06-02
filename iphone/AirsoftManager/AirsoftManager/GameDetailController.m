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
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapRecognizer];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"addPlayerFromGame"])
    {
        PlayerListController *playerListController = [segue destinationViewController];
        playerListController.isFromGames = YES;
    }
}

-(void)tap:(UITapGestureRecognizer *)gr {
    [self.view endEditing:YES];
}

-(void) cancelDate {
    [self.date resignFirstResponder];
}

-(void) changeDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/YYYY"];
    
    [self.saveButton setEnabled:YES];
    [self.date setText:[dateFormatter stringFromDate:self.datePicker.date]];
    [self.date resignFirstResponder];
}

@end
