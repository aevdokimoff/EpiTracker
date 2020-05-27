# EpiTracker – Track and prevent pandemics in time 
![Screenshot](screen.png?raw=true "Title")

## Motivation
Humanity is in crisis due to COVID-19 global outbreak which is already declared as a pandemic. This is high time we need to get the best of our technology to solve parts of this global crisis and **prevent similar crises in future**. One of the most difficult challenges for any government of the affected counties is to flatten the curve of infection. Early detection of already affected patients is the most important part to flatten the curve. When a patient is identified as positive, government is trying to obtain close contacts information of the patient through manual processes like, by asking to the friends and family of the affected and so on. However, this approach has many limitations in terms of information accuracy, information retrieval delay etc. due to mostly,

* Falsified information from F&F
* Hidden information by patient and families to avoid social embarrassment
* Unknown or missing information of the patient
* Delayed information retrieval due to manual processes
* And many more

But what if we provide an alternative source of information, that can be compared with official statistics, and update conclusions?

## That is how we do it
The purpose of this PoC application is to create an interactive heat map with the areas of most active infection – not only COVID-19, but **also other common diseases**. All the user needs to do is select her/his disease type and tap the "add" button. The data will be anonymously saved in the database and will be available to everyone. Thus, states, healthcare and other institutions would have the opportunity to prevent a possible pandemic in time by taking appropriate measures. This approach may help save hundreds of thousands of lives.

### Functionality:
* Show disease spread using heat map
* Add new disease case
* Add new recovery case
* Show disease statistics 
* Show the latest news from the healthcare sector
* COVID-19 detection by lung X-ray using machine learning 

### In progress:
* Back-End part 
* Add other common diseases to statistics 

## Tech Specifications:
* Programming language: Swift
* Alamofire
* Vision
* Swifty
* LFHeatMap
* SPAlert
* PKHUD

## Model
The [DeepBrain](https://github.com/skytells-research/Covid19-AI-Detection) model was trained with more than 16,000 images in high resolution

#### PRECISION RECALL
| Class   |      Precision(%)      |  Recall(%) |
|----------|:-------------:|------:|
| BacterialPneumonia |  94.74 | 85.71 |
| ViralPneumonia |    92.31   |   97.30 |
| Covid19 | 98.57 |    100.00 |
| Normal | 100.00 |    97.22 |

## License
This project is available under the MIT license.
