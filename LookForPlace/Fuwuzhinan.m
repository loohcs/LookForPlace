//
//  Fuwuzhinan.m
//  LookForPlace
//
//  Created by ibokan on 12-1-11.
//  Copyright 2012年 ibokanwisdom. All rights reserved.
//

#import "Fuwuzhinan.h"
#import "ViewController.h"

@implementation Fuwuzhinan

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    UIView *aview=[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view=aview;
    [aview release];
    
    UIScrollView *aScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, -20, 320, 480)];
    [aScrollView setContentSize:CGSizeMake(1600, 0)];
    aScrollView.pagingEnabled=YES;
    [self.view addSubview:aScrollView];
    for (int i=0; i<5; i++) {
        UIImageView *imageview=[[UIImageView alloc] initWithFrame:CGRectMake(320*i,0, 320, 480)];
        if (i==0) {
            [imageview setBackgroundColor:[UIColor whiteColor]];
            [imageview setImage:[UIImage imageNamed:@"fu1.jpg"]];
            
        }else if(i==1)
        {
            [imageview setBackgroundColor:[UIColor whiteColor]];
            [imageview setImage:[UIImage imageNamed:@"fu2.jpg"]];
        }else if(i==2)
        {
            [imageview setBackgroundColor:[UIColor clearColor]];
            [imageview setImage:[UIImage imageNamed:@"fu3.jpg"]];
        }else if(i==3)
        {
            [imageview setBackgroundColor:[UIColor clearColor]];
            [imageview setImage:[UIImage imageNamed:@"fu4.jpg"]];
        }else if(i==4)
        {
            [imageview setBackgroundColor:[UIColor clearColor]];
            [imageview setImage:[UIImage imageNamed:@"fu5.jpg"]];
        }
        [aScrollView addSubview:imageview];
        [imageview release];
    }
    
    UIButton *abutton=[[UIButton alloc] initWithFrame:CGRectMake(1370, 370, 155, 55)];
    [aScrollView addSubview:abutton];
    [abutton addTarget:self action:@selector(removefuwu:) forControlEvents:UIControlEventTouchUpInside];
    
    
     
    [abutton release];
    [aScrollView release];

}
-(void)removefuwu:(id)sender
{
    ViewController *aViewC=[[ViewController alloc] init];
    [self presentModalViewController:aViewC animated:YES];
    [aViewC release];
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
