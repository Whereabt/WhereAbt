//
//  ProfileViewController.m
//  Whereabout 2
//
//  Created by Nicolas Isaza GitHub on 1/20/15.
//  Copyright (c) 2015 Nicolas Isaza. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileController.h"
#import "WelcomeViewController.h"
#import "KeychainItemWrapper.h"
#import <Security/Security.h>

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.

    NSString *nameString = [WelcomeViewController sharedController].userName;
    NSArray *firstLastName = [nameString componentsSeparatedByString:@"_"];
    
    self.NameLabel.text = firstLastName[0];
    self.LastNameLabel.text = firstLastName[1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)LogoutButtonPressed:(id)sender {
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"Login" accessGroup:nil];
   
    //set nil for the refresh token, user will have to log back in
    [WelcomeViewController sharedController].refreshToken = @"";
    
    [keychain setObject:[WelcomeViewController sharedController].refreshToken forKey:(__bridge id)kSecValueData];
}

#pragma mark CollectionView Datasource and Delegate MEthods
/*
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
}
*/
 
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
