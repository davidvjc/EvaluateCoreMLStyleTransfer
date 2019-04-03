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
1. On your Mac, open the XCode project and hit Run 
2. The program will output stylized image files in your Documents folder.
3. The output image resolution is defined by the resolution of input images
4. For a single image, place the image in the XCode folder and add the name to "Setup()"
5. For an image folder, run the program and add a folder system path into the Path box and select "Multiple Images"

## To Do
- [ ] Update Documentation and Readme
- [ ] Add Folder Path input for single image as well
- [ ] Clean-up Code
- [ ] Show image preview while they are being evaluated
- [ ] Examples
