//
//  MoreFuwuzhinan.m
//  LookForPlace
//
//  Created by ibokan on 12-1-11.
//  Copyright 2012年 ibokanwisdom. All rights reserved.
//

#import "MoreFuwuzhinan.h"


@implementation MoreFuwuzhinan

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
{ UIView *aview=[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view=aview;
    [aview release];
    
    UIScrollView *aScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, -20, 320, 480)];
    //[aScrollView setBackgroundColor:[UIColor blueColor]];
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
    //[abutton setTitle:@"进入" forState:UIControlStateNormal];
    //[abutton setBackgroundColor:[UIColor redColor]];
    [aScrollView addSubview:abutton];
    [abutton addTarget:self action:@selector(removefuwu:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //    [UIView beginAnimations:@"zfAnimations" context:nil];
    //    [aView setFrame:CGRectMake(0, 0, 320, 480)];
    //    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    //    [UIView setAnimationDuration:3.0];
    //    [UIView commitAnimations];
    
    [abutton release];
    [aScrollView release];
    
}
-(void)removefuwu:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];   
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
