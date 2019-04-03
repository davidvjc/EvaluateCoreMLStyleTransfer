# EvaluateCoreMLStyleTransfer
Evaluate and save the output of a style transfer model on a Mac using CoreML

This repository lets you:
* Create a CoreML Style transfer model from a set of style images
* Use that model on your Mac to stylize images
* Save the stylized images in the same format and resolution as input image

## Requirements
* Python 3.6.5
* Turi Create (latest)
* Xcode (latest)
* Mac Computer

## Installation
Use the command line to install requirements 
TBD

## styletransfer.py
Creates a style transfer CoreML Model from one or more style images
Uses Turi Create. 

**To run:** 
1. Add your images to the folders
2. Edit the file and/or folder names accordingly (in the code)
3. Edit the model output names (in the code)
```
python styletransfer.py
```

## convertToCoreMLOnly.py
Converts an existing Turi Create Model into a CoreML Model

**To run:**
Edit the input and output model names (in the code)
```
python convertToCoreMLOnly.py
```

## EvaluateCoreML.xcodeproj
Uses the above create CoreML Model and provides a simple User Interface to load images and stylize them. 
Can take one or an entire folder of images. 

**To run:** 
1. On your Mac, open the Xcode project and hit Run 
2. *Style Index* controls which of a multitude of styles to use, if you only added one style image during model creation, enter 0
3. *Number of Styles* tells the program how many total styles you added during model creation (min. 1)
4. Select *Open Finder Folder* to open the output folder after completion
5. Press *Run* to start
6. *Open Path* opens the Finder folder of the output images in case you forgot to check the box

The program will output stylized image files into your local "Documents" folder.

*The output image resolution is defined by the resolution of input images*

**To stylize a single image**
Drag the image file into your Xcode project into the "EvaluateCoreML" Folder. 
Then change the below code (Line 103) to the name of your file:
```
var image = NSImage(imageLiteralResourceName: "portrait3.jpg")
```

**To stylize a folder of images**
Open the Xcode project and run the program
Check the "Multiple Images" box
Paste the system link to the folder containing your images into "Folder File Path URL"
*Note: To get the URL Path, in a Finder window go "View" > "Show Path Bar" then go to your images folder, right click onto the folder in the Path Bar at the bottom and select "Copy ___ as Pathname"*

## To Do
- [ ] Update Documentation and Readme
- [ ] Add Folder Path input for single image as well
- [ ] Clean-up Code
- [ ] Show image preview while they are being evaluated
- [ ] Examples
