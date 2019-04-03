# EvaluateCoreMLStyleTransfer
Evaluate and save the output of a style transfer model on a Mac using CoreML

## styletransfer.py
Creates a style transfer CoreML Model from one or more style images

## convertToCoreMLOnly.py
Converts an existing Turi Create Model into a CoreML Model

## EvaluateCoreML.xcodeproj
Uses the above create CoreML Model and provides a simple User Interface to load images and stylize them. 
Can take one or an entire folder of images. 
To run: On your Mac, open the XCode project and hit Run 
The program will output stylized image files in your Documents folder.
The output image resolution is defined by the resolution of input images
For a single image, place the image in the XCode folder and add the name to "Setup()"
For an image folder, run the program and add a folder system path into the Path box and select "Multiple Images"
