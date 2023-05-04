<!--
Name of your final project
-->
# CrFit
![Swift](https://img.shields.io/badge/swift-5.5-brightgreen.svg) ![Xcode 13.2+](https://img.shields.io/badge/xcode-13.2%2B-blue.svg) ![iOS 15.0+](https://img.shields.io/badge/iOS-15.0%2B-blue.svg) ![watchOS 8.0+](https://img.shields.io/badge/watchOS-8.0%2B-blue.svg) ![CareKit 2.1+](https://img.shields.io/badge/CareKit-2.1%2B-red.svg) ![ci](https://github.com/netreconlab/CareKitSample-ParseCareKit/workflows/ci/badge.svg?branch=main)


## Description
<!--
Give a short description on what your project accomplishes and what tools is uses. Basically, what problems does it solve and why it's different from other apps in the app store.
-->
CrFit is an all in one fitness/health tracker, journal, and profile. CrFit allows a user to keep an updated fitness profile. On this fitness profile, the user can track different statistics about their health and fitness. Features include tracking user goals, recording dietary information, workout checklists, and more. CrFit separates itself from competitors by truly being a one stop shop for all fitness need.

CrFit utilizes the CareKit and Research Kit frameworks. All views are UIKit and SwiftUI. The backend is a parse server hosted on heroku.


### Demo Video
<!--
Add the public link to your YouTube or video posted elsewhere.
-->
To learn more about this application, watch the video below:

<a href="http://www.youtube.com/watch?feature=player_embedded&v=mib_YioKAQQ
" target="_blank"><img src="http://img.youtube.com/vi/mib_YioKAQQ/0.jpg" 
alt="Sample demo video" width="240" height="180" border="10" /></a>

### Designed for the following users
<!--
Describe the types of users your app is designed for and who will benefit from your app.
-->
This app is made for anyone interested in recording their fitness journey. From tracking your meals, calories, energy burned, steps, workouts, etc. You can have a profile that keeps track of your entire journey for days to weeks to months to years.
<!--
In addition, you can drop screenshots directly into your README file to add them to your README. Take these from your presentations.
-->
<p float="left">
<img width="250" alt="Screenshot 2023-05-03 at 8 13 28 PM" src="https://user-images.githubusercontent.com/112590210/236078176-8c22f381-638b-4c48-be16-dcc9306c9ad3.png">
<img width="250" alt="Screenshot 2023-05-03 at 8 13 43 PM" src="https://user-images.githubusercontent.com/112590210/236078177-aaefdf8b-53f8-49f3-ac9c-8693a286de01.png">
<img width="250" alt="Screenshot 2023-05-03 at 8 13 57 PM" src="https://user-images.githubusercontent.com/112590210/236078179-c238ee6e-e642-4a43-a0ba-1d4ff22bfc77.png">
<img width="250" alt="Screenshot 2023-05-03 at 8 14 15 PM" src="https://user-images.githubusercontent.com/112590210/236078181-18da1347-6e95-4df1-a33a-3283d03db726.png">
<img width="250" alt="Screenshot 2023-05-03 at 8 15 41 PM" src="https://user-images.githubusercontent.com/112590210/236078183-4030ac8b-68a2-4d64-9917-00744f89d126.png">
<img width="250" alt="Screenshot 2023-05-03 at 8 15 48 PM" src="https://user-images.githubusercontent.com/112590210/236078185-b89763bc-ce57-4639-891b-e7227e4410db.png">
<img width="250" alt="Screenshot 2023-05-03 at 8 16 10 PM" src="https://user-images.githubusercontent.com/112590210/236078186-2eb003ce-9ef3-4113-a0df-995f069254df.png">
<img width="250" alt="Screenshot 2023-05-03 at 8 16 31 PM" src="https://user-images.githubusercontent.com/112590210/236078188-66c646a3-fb93-46e4-bc25-3401ce957ecf.png">
<img width="250" alt="Screenshot 2023-05-03 at 8 16 38 PM" src="https://user-images.githubusercontent.com/112590210/236078189-7ed98620-7eb1-4bf5-a602-d9ce7df51f06.png">
</p>

<!--
List all of the members who developed the project and
link to each members respective GitHub profile
-->
Developed by: 
- [Maximus Liggett](https://github.com/mjli235) - `UNIVERSITY_OF_KENTUCKY`, `COMPUTER_SCIENCE`
- [Corey Baker](https://github.com/cbaker6)

ParseCareKit synchronizes the following entities to Parse tables/classes using [Parse-Swift](https://github.com/parse-community/Parse-Swift):

- [x] OCKTask <-> Task
- [x] OCKHealthKitTask <-> HealthKitTask 
- [x] OCKOutcome <-> Outcome
- [x] OCKRevisionRecord.KnowledgeVector <-> Clock
- [x] OCKPatient <-> Patient
- [x] OCKCarePlan <-> CarePlan
- [x] OCKContact <-> Contact

**Use at your own risk. There is no promise that this is HIPAA compliant and we are not responsible for any mishandling of your data**

<!--
What features were added by you, this should be descriptions of features added from the [Code](https://uk.instructure.com/courses/2030626/assignments/11151475) and [Demo](https://uk.instructure.com/courses/2030626/assignments/11151413) parts of the final. Feel free to add any figures that may help describe a feature. Note that there should be information here about how the OCKTask/OCKHealthTask's and OCKCarePlan's you added pertain to your app.
-->
## Contributions/Features
User Adding Tasks

When in the app, the user navigates to the profile view. In this view, they click on “Add Workout Goal.” Here they are able to customize their task by schedule, instructions, title, and card view. Once the add task button is pressed, the task will appear in the CareKitView.

OCKTasks/HealthKitTasks/OCKCarePlans

There are many different task cards that appear in the care view. All of these OCKTasks are there to collect information about the user and customize their profile/experience. OCKHealthKitTasks are there to help the user record information that their phone collects and match it to their current goals. Tasks are added to one of two different care plans based on the type of input.

Custom Cards

I created custom cards for the purposes of my app. This includes calories consumed which gives a thumbs up or thumbs down based on how close you are to your goal. The other one is quote of the day which saves a motivational quote of the day to the user's care view.

Surveys

There are two surveys in the app. One acts as an end of day check in, in which the user submits their total workout time for the day as well as their goal workout time. In the other survey, the user puts in their current weight, their goal weight, and the amount of weeks until they wish to meet their goal. The survey will calculate the average lbs/week the user must lose/gain.

Insights

I created many different scatter, line, and bar charts for the app. These charts are based on data collected form surveys, OCKTasks, and OCKHealthKitTasks.


## Final Checklist
<!--
This is from the checkist from the final [Code](https://uk.instructure.com/courses/2030626/assignments/11151475). You should mark completed items with an x and leave non-completed items empty
-->
- [X] Signup/Login screen tailored to app
- [X] Signup/Login with email address
- [X] Custom app logo
- [X] Custom styling
- [X] Add at least **5 new OCKTask/OCKHealthKitTasks** to your app
  - [X] Have a minimum of 7 OCKTask/OCKHealthKitTasks in your app
  - [X] 3/7 of OCKTasks should have different OCKSchedules than what's in the original app
- [X] Use at least 5/7 card below in your app
  - [X] InstructionsTaskView - typically used with a OCKTask
  - [X] SimpleTaskView - typically used with a OCKTask
  - [ ] Checklist - typically used with a OCKTask
  - [X] Button Log - typically used with a OCKTask
  - [ ] GridTaskView - typically used with a OCKTask
  - [X] NumericProgressTaskView (SwiftUI) - typically used with a OCKHealthKitTask
  - [X] LabeledValueTaskView (SwiftUI) - typically used with a OCKHealthKitTask
- [X] Add the LinkView (SwiftUI) card to your app
- [X] Replace the current TipView with a class with CustomFeaturedContentView that subclasses OCKFeaturedContentView. This card should have an initializer which takes any link
- [X] Tailor the ResearchKit Onboarding to reflect your application
- [X] Add tailored check-in ResearchKit survey to your app
- [X] Add a new tab called "Insights" to MainTabView
- [X] Replace current ContactView with Searchable contact view
- [X] Change the ProfileView to use a Form view
- [X] Add at least two OCKCarePlan's and tie them to their respective OCKTask's and OCContact's 

## Wishlist features
<!--
Describe at least 3 features you want to add in the future before releasing your app in the app-store
-->
1. The original goal of this app was to eventually give it a social media aspect. The Care View would act as a timeline of a user profile. In the future, I would expand on this idea and allow users to see each other's profiles when they give permission.
2. I would make major updates to the contacts as well in the future. I would piggy back on this idea and allow users to also make "friends" through the contacts tab which would be the permissions for users to view each others' profiles.
3. The last feature I would add is more customizability for the user. I would add many more tasks that focus on all possible fitness needs. This could include tutorials, reccomending workouts, reccomending food, etc.

## Challenges faced while developing
<!--
Describe any challenges you faced with learning Swift, your baseline app, or adding features. You can describe how you overcame them.
-->

The first challenge I had developing the app was learning the codebase. This is my first time working with Swift and while I did find it easy to learn, there was still time to be accustomed to it. This was also one of the larger codebases I have worked with so it took a lot of time to learn how it was all the different parts of the app were interracting with eachother. Another challenge was learning how to use Care Kit. I found Care Kit to be an extremely powerful tool that had many different abilities. The only problem was there is very limited information about CareKit that I could find other than the README. This meant a lot of testing to figure how things in the framework flowed together.

## Setup Your Parse Server

### Heroku
The easiest way to setup your server is using the [one-button-click](https://github.com/netreconlab/parse-hipaa#heroku) deplyment method for [parse-hipaa](https://github.com/netreconlab/parse-hipaa).


## View your data in Parse Dashboard

### Heroku
The easiest way to setup your dashboard is using the [one-button-click](https://github.com/netreconlab/parse-hipaa-dashboard#heroku) deplyment method for [parse-hipaa-dashboard](https://github.com/netreconlab/parse-hipaa-dashboard).
