# TrackIT - Expense Made Easy
TrackIT - Expense Made Easy is a cutting-edge, intuitive smartphone software designed to simplify the process of tracking and managing personal finances. Developed with SwiftUI for iOS devices and using Firebase and Swift, TrackIT allows users to add, categorize, and view their spending effortlessly. The app includes features such as visualizing spending with a pie chart, accessing financial news and YouTube videos, and finding nearby banks on a map. TrackIT’s smooth and user-friendly interface makes managing personal finances easier for individuals.

<img width="766" alt="Screenshot 2024-06-22 at 1 04 24 PM" src="https://github.com/dikshitapatel/Track-it/assets/51240335/fa469e76-b0a0-459f-9bec-8b60cecfe120">


## Features

### Authorization
- **Register User**: Register new users on the app by storing their information in Firebase to log in.
- **Login**: Match user information with details retrieved from Firebase to allow access to the app.

### User Profile
- Add user profile details upon successful registration.
- Upload profile photos from the gallery.
- Edit user profile details in the profile section.

### Expense Logging
- Track daily expenses in a ListView.
- Search expense logs by name.
- Filter expenses by a diverse range of categories.
- Sort expenses by amount or date in ascending or descending order.

### Adding/Editing/Deleting Expense
- Log expenses quickly and efficiently with predefined categories.
- Use DatePicker to specify the time and date of expenses.
- Edit individual expenses on tap and delete expenses on swipe.

### Locate Us Using MapKit
- Built-in map feature displaying nearby banks and ATMs.
- Use MKMapView to show a map interface and handle user location updates.
- Manage authorization status and present alerts if location access is denied.

### Expense Statistics
- Track total expenses with a pie chart view.
- Visualize expenses with an animated pie chart.
- Display spending by specific categories.

### Real-Time Financial News
- Access financial news using Financial Modeling Prep API.
- Read blog posts highlighting the importance of staying updated with financial news.

### Budgeting Videos
- Integrate YouTube API to access a diverse range of budgeting videos.
- Watch videos directly within the app.

## Technical Features

- **Authentication**: Firebase
- **Storage**: Firestore
- **Financial Blogs**: Financial Modeling Prep API
- **YouTube Finance Videos**: YouTube API
- **Date Picker**: Calendar/Report Capture
- **Find Us**: MapKit
- **Navigation Between Pages**: TabView, SplitView, NavigationView
- **Expense Analysis**: Pie chart

## Additional Features

### Firebase
- Seamless integration with Firestore and Storage.
- Robust security protocols for user data protection.
- Real-time database functionality with Firestore.
- Secure storage of user-generated content with Firebase Storage.
- Straightforward implementation process for authentication flows.

## Local Setup

### 1. Set up Firebase Project:
- **Create a Firebase Project**: Visit the Firebase Console and initiate a new project.
- **Register Your App**: Follow the prompts to register your iOS app with the Firebase project.
- **Download Config File**: Obtain the `GoogleService.Info.plist` file and position it in the app directory of your Xcode project.
- **Configure Functionality**: Configure authentication, Firestore, and storage functionality in test mode.

### 2. Custom Info.plist:
- **Copy Path**: Copy the path from `Info.plist` in the attributes inspector.
- **Paste Path**: Paste the path here: `Project -> Targets -> Build Settings -> Info.plist File`.
- **Set Generate Info.plist File to No**.
- **Remove Info.plist from Copy Bundle Resources**: Go to `Project -> Targets -> Build Phases -> Copy Bundle Resources` and remove `Info.plist`.

With these changes, the application will be ready to use.
