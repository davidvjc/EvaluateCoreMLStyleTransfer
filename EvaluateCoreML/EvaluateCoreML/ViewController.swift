//
//  ViewController.swift
//  EvaluateCoreML
//
//  Created by David Cihelna on 4/2/19.
//  Copyright © 2019 David Cihelna. All rights reserved.
//

import CoreML
import Cocoa
import AppKit

class ViewController: NSViewController {
    
    var latestURL: URL?
    var globalLastImage: String?
    var showFinder: Bool = false
    var stylizeMultipleImages: Bool = false
    
    // UI Input
    @IBOutlet weak var StyleIndexUI: NSTextField!
    @IBOutlet weak var NumberOfStylesUI: NSTextField!
    
    @IBOutlet weak var OpenFinderUI: NSButton!
    @IBOutlet weak var MultipleImagesUI: NSButton!

    @IBOutlet weak var DebugLogUI: NSTextField!
    
    @IBOutlet weak var PreviewImageUI: NSImageView!
    
    @IBOutlet weak var MultiImageFolderPath: NSTextField!
    
    // Checkbox tests
    @IBAction func CheckIfFinderOpen(_ sender: NSButton) {
        switch sender.state {
        case .on:
            showFinder = true
        case .off:
            showFinder = false
        case .mixed:
            print("error")
        default: break
        }
    }
    
    @IBAction func CheckIfMultipleImages(_ sender: NSButton) {
        switch sender.state {
        case .on:
            stylizeMultipleImages = true
        case .off:
            stylizeMultipleImages = false
        case .mixed:
            print("error")
        default: break
        }
    }
    
    // Button: RUN
    @IBAction func Run(_ sender: Any) {
        DebugLogUI.stringValue = "\n $$$$$$$$ LET's GET STARTED $$$$$$$$"

        if stylizeMultipleImages{
            setupMany()
            
        } else {
            setup()
        }
    }
    
    // The Model
    let model = MyModel()
    
    // set input size of the model
    var modelInputSize: CGSize?
    
    let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
    

    
    var styleArray: MLMultiArray?
    
    // Setup for One Image
    func setup(){
        
        print("[SETUP ONE]")
        
        // Define the style number and the max number of styles
        let numStyles  = Int(NumberOfStylesUI.stringValue)! // Define the number of style in Model
        let styleIndex = Int(StyleIndexUI.stringValue)! // Choose your desired Style
        
        styleArray = try? MLMultiArray(shape: [numStyles] as [NSNumber], dataType: MLMultiArrayDataType.double)
        
        for i in 0...((styleArray?.count)!-1) {
            styleArray?[i] = 0.0
        }
        styleArray?[styleIndex] = 1.0
        
        print("using style \(styleIndex) of \(numStyles)")
        DebugLogUI.stringValue += "\n STARTING using style \(styleIndex) of \(numStyles)"
        
        //v1
        // Get an image from xcode references, turn it inot CIIimage
        var image = NSImage(imageLiteralResourceName: "portrait3.jpg")
        let imageData = image.tiffRepresentation!
        let ciImage = CIImage(data: imageData)
        print("Input Image Name: ", image.name()!)
        print("Input Image size: ", image.size)
        DebugLogUI.stringValue += "\n Input Image Name: \(image.name()!)"
        DebugLogUI.stringValue += "\n Input Image size: \(image.size)"

        // GET THE SIZE FROM THE IMAGE
        modelInputSize = CGSize(width: image.size.width, height: image.size.height)

        // create a cvpixel buffer
        var pixelBuffer: CVPixelBuffer?
        CVPixelBufferCreate(kCFAllocatorDefault, Int(modelInputSize!.width), Int(modelInputSize!.height), kCVPixelFormatType_32BGRA, attrs, &pixelBuffer)
        
        // put bytes into pixelBuffer
        let context = CIContext()
        context.render(ciImage!, to: pixelBuffer!)
        
        run(pixelBuffer: pixelBuffer!, name: image.name()!)
    }
    
    
    // Setup for many images
    func setupMany(){
        print("[SETUP MANY]")
        
        // THINGS TO CHANGE:
        let numStyles  = Int(NumberOfStylesUI.stringValue)! // Define the number of style in Model
        let styleIndex = Int(StyleIndexUI.stringValue)! // Choose your desired Style
        
        styleArray = try? MLMultiArray(shape: [numStyles] as [NSNumber], dataType: MLMultiArrayDataType.double)
        
        for i in 0...((styleArray?.count)!-1) {
            styleArray?[i] = 0.0
        }
        styleArray?[styleIndex] = 1.0
        
        print("using style \(styleIndex) of \(numStyles)")
        DebugLogUI.stringValue += "STARTING using style \(styleIndex) of \(numStyles)"
        
        // For every image, do this and wait until run is done before continuing
        let fileManager = FileManager.default
        
        do {
            // grab the path defined in the app UI and get a reference to that system folder
            let resourceKeys : [URLResourceKey] = [.creationDateKey, .isDirectoryKey]
//            let documentsURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let enumerator = FileManager.default.enumerator(at: URL(fileURLWithPath: MultiImageFolderPath!.stringValue),
                                                            includingPropertiesForKeys: resourceKeys,
                                                            options: [.skipsHiddenFiles], errorHandler: { (url, error) -> Bool in
                                                                print("directoryEnumerator error at \(url): ", error)
                                                                return true
            })!
            
            // Go through every file
            for case let fileURL as URL in enumerator {
                let resourceValues = try fileURL.resourceValues(forKeys: Set(resourceKeys))
                print("-------")
                print("File Path ", fileURL.path)
                
                //v1
                // Grab the image from the file path, one after another, and turn it into an NSImage -> CIImage
                var image = NSImage(byReferencing: fileURL)
                let imageData = image.tiffRepresentation!
                let ciImage = CIImage(data: imageData)
                print("Input Image Name: ", fileURL.lastPathComponent)
                print("Input Image size: ", image.size)
                DebugLogUI.stringValue += "\n Input Image Name: \(fileURL.lastPathComponent)"
                DebugLogUI.stringValue += "\n Input Image size: \(image.size)"
                
                // GET THE SIZE FROM THE IMAGE
                modelInputSize = CGSize(width: image.size.width, height: image.size.height)
                
                var pixelBuffer: CVPixelBuffer?
                CVPixelBufferCreate(kCFAllocatorDefault, Int(modelInputSize!.width), Int(modelInputSize!.height), kCVPixelFormatType_32BGRA, attrs, &pixelBuffer)
                
                // put bytes into pixelBuffer
                let context = CIContext()
                context.render(ciImage!, to: pixelBuffer!)
                
                // Get rid of the ".jpg" in the name of the file
                let imageName = fileURL.lastPathComponent.dropLast(4)
                DispatchQueue.main.async {
                    self.run(pixelBuffer: pixelBuffer!, name: String(imageName))
                }
            }
        } catch {
            print("ERROR ", error)
        }
        
    }
    
    // Stylize Image
    func run(pixelBuffer: CVPixelBuffer, name: String){
        
        // predict image and return a CIImage
        let output = try? model.prediction(image: pixelBuffer, index: styleArray!)
        let predImage = CIImage(cvPixelBuffer: (output?.stylizedImage)!)
        
        // Turn that into an NSImage
        let rep = NSCIImageRep(ciImage: predImage)
        let nsImage = NSImage(size: rep.size)
        nsImage.addRepresentation(rep)
        
        // Preview The Image on screen
        DispatchQueue.main.async {
            self.PreviewImageUI.image = nsImage
            self.PreviewImageUI.setNeedsDisplay()
        }
        
        // Save the image as a file in document directory
        let fileManager = FileManager.default
        do {
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
            let fileURL = documentDirectory.appendingPathComponent(name + "_stylized_v" + StyleIndexUI.stringValue + ".png")
            nsImage.saveAsPNG(url: fileURL)
            print("OUTPUT saved at ", fileURL)
            DebugLogUI.stringValue += "\n $$$$$$$$$$$"
            latestURL = fileURL
            
            // If you are rendering one image and you want to show the finder when completed, open the finder location
            if !stylizeMultipleImages && showFinder {
                openURLInFinder(name: name)
            }
            
            globalLastImage = name
            
        } catch {
            print("ERROR: ", error)
            DebugLogUI.stringValue += "\n ERROR \(error)"
            
        }
        
    }

    
    // Manually show folder with button
    @IBAction func openFilePath(_ sender: Any) {
        openURLInFinder(name: (globalLastImage!)) // globalLastImage is the last file stylized' path
    }
    
    // Open the URL in Finder
    func openURLInFinder(name: String){
        print("[OPEN] latestURL \(latestURL!) for name \(name)")
        
        if stylizeMultipleImages {
            NSWorkspace.shared.open(URL(fileURLWithPath: "/Users/davidcihelna/Documents/"))
        } else {
            if latestURL != nil {
                if let index = latestURL!.absoluteString.range(of: name)?.lowerBound {
                    let substring = latestURL!.absoluteString[..<index]                 // "ora"
                    let string = String(substring)
                    NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: string)
                }
            }
        }

    }
    
}

extension NSImage {
    @discardableResult
    func saveAsPNG(url: URL) -> Bool {
        guard let tiffData = self.tiffRepresentation else {
            print("failed to get tiffRepresentation. url: \(url)")
            return false
        }
        let imageRep = NSBitmapImageRep(data: tiffData)
        guard let imageData = imageRep?.representation(using: .png, properties: [:]) else {
            print("failed to get PNG representation. url: \(url)")
            return false
        }
        do {
            try imageData.write(to: url)
            return true
        } catch {
            print("failed to write to disk. url: \(url)")
            return false
        }
    }
}
