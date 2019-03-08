# NationalDish
NationalDish app enables users to post their country's National Dish to the public feed. The NationalDish app uses Firebase for authentication, database and storage of the app's data.

## Checklist for Firebase setup 

- [x] create Xcode project 
- [x] create firebase project 
- [x] add Xcode bundle id to firebase project 
- [x] drag GoogleService-Info.plist file to Xcode 
- [x] install firebase sdk using cocoapods 
- [x] enable email/password authentication on firebase 
- [x] setup firestore database 
- [x] setup firesbase storage

## NationalDish MVP Checklist 

- [x] create app login screen 
- [x] user can create an account 
- [x] user can sign in to existing account
- [ ] user can sign out of account
- [x] a database user should also be created during the authenticate account creation process
- [ ] create national feed controller 
- [ ] create profile view controller 
- [ ] user can edit profile 
- [ ] user can create a national dish post included adding a photo from camera or photo library 
- [ ] user can edit their national dish post 
- [ ] user can delete national dish post
- [ ] selecting a national dish post shows a detail view of the dish 
- [ ] user can see more options via an action sheet to carry out appropriate actions e.g delete, edit, save image


## Users Collection Database Schema 

<p align="center">
  <img src="https://github.com/alexpaul/NationalDish/blob/master/Images/users-collection.png" width="900" height="600" />
</p>

## Dishes Collection Database Schema 

<p align="center">
  <img src="https://github.com/alexpaul/NationalDish/blob/master/Images/dishes-collection.png" width="900" height="600" />
</p>
  
