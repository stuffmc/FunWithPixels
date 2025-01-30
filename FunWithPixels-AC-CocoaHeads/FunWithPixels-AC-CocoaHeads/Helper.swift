//
//  Helper.swift
//  FunWithPixels-AC-CocoaHeads
//
//  Created for Cocoaheads AC on 27.01.25
//  by Werner Lonsing

import Foundation
import CoreImage
import UIKit
import UniformTypeIdentifiers // for file-types, here png


class Helper {
    
    var allImages:[UIImage] = []
    var allImageNames:[String] = []
    var intermediate = CIImage()
    
    private var selectedIndex = 0// needed to retrieve the original orientation and scale, if needed
    // Get a CIContext
    static let context = CIContext(options:
                                    [.workingColorSpace: CGColorSpaceCreateDeviceRGB(),
                                     .outputColorSpace: CGColorSpaceCreateDeviceRGB()])

    init()
    {// collects aall images availbale in the bundle
        let fm = FileManager.default
        let bundle = Bundle.main
        let path = bundle.resourcePath!
        
        
        print(path)
        if(fm.fileExists(atPath: path))
        {
            
            do {
                let items = try fm.contentsOfDirectory(atPath: path)
                let extensions = ["JPG","JPEG", "PNG"]
                var photos:[String] = []
                extensions.forEach()
                {
                    let suffix1 = ".\($0)"
                    let ph1 = items.filter {$0.hasSuffix(suffix1)}
                    photos.append(contentsOf: ph1)
                    
                    let suffix2 = ".\($0.lowercased())"
                    let ph2 = items.filter {$0.hasSuffix(suffix2)}
                    photos.append(contentsOf: ph2)
                }
                
                for name in photos {
                    if let image = UIImage(named: name)
                    {// AppIcon causes trouble
                        if(name.contains("AppIcon") == false)
                        {
                            allImages.append(image)
                            allImageNames.append(name)
                            print("Found \(name)")
                        }
                        else
                        {
                            print("not valid: \(name)")
                        }
                    }
                    else
                    {
                        print("invalid: \(name)")
                    }
                }
            } catch {
                // failed to read directory – bad permissions, perhaps?
            }
            // during development run once to get all filter printed
            //            ciFilters()
        }
    }
    
    // injects the intermediate image into the filter chain and returns the UiImage
    func filterIntermediateWith(exposure: Float, contrast: Float, highlights: Float, shadows: Float, saturation: Float, temperature: Float, tint: Float) -> UIImage
    {
        let uiImage = filterWith(intermediate, exposure: exposure, contrast: contrast, highlights: highlights, shadows: shadows, saturation: saturation, temperature: temperature, tint: tint)
        return uiImage
    }
    
// function to render the filter chain from a CCiamge and returns the UIImage, mostly for the intermediate image
    private func filterWith(_ image: CIImage, exposure: Float, contrast: Float, highlights: Float, shadows: Float, saturation: Float, temperature: Float, tint: Float) -> UIImage
    {
        let returnImage = ciImageFromFilterWith (image, exposure: exposure, contrast: contrast, highlights: highlights, shadows: shadows, saturation: saturation, temperature: temperature, tint: tint)
                
        return uiImageFrom(ciImage: returnImage)
    }

    // main function to apply all slider values into the filter chain, passes the CIImage thruough and returns the UIImage

    private func ciImageFromFilterWith(_ image: CIImage, exposure: Float, contrast: Float, highlights: Float, shadows: Float, saturation: Float, temperature: Float, tint: Float) -> CIImage
{
    let workerImage = image
//    var workerImage = image
    /*CocoaHeads*/
        return workerImage
    }
    // resets all values set here into a neutral position.
    func reset()
    {
        /*CocoaHeads*/
    }

    // the intermediate image is the result of some costly operations like the adjust filters or the
    // mean filters, hence it is stored globally as 'var intermediate = CIImage()'
    // In addition, as this function is used only on the UI, it is a good idea to scale
    // the image down beforehand. A filter to scale is needed as well. No return!
    func intermediateImage(forIndex: Int, adjust: Bool, channels: Float, passes: Float) {

        selectedIndex = forIndex
        let originalImage = CIImage(image: allImages[selectedIndex])

        intermediate = originalImage!
        /*CocoaHeads*/
    }

    private func filterMean(image: CIImage, channels: Float, passes: Float) -> CIImage
    { return image}

    
    // helper function to create a UIImage from a CIImage using the global CIContext
    // Helper.context
    // Maybe better with: (... inContext: CIContext? = nil)
    // and
    // let context = inContext == nil ? CIContext() : inContext!
    // But still there are allImages etc..., no need right now

    private func uiImageFrom(ciImage:CIImage) -> UIImage
    {
        // Create a UIImage from the CGImage
        guard let cgImage = Helper.context.createCGImage(ciImage, from: ciImage.extent)
        else {
            let ret = UIImage.from(color: UIColor.red)
            return ret
        }
        let originalImage = allImages[selectedIndex]// retrieve the original image and its values
        let scale =  originalImage.scale// they are not preserved
        let orientation =  originalImage.imageOrientation

        let uiImage = UIImage(cgImage: cgImage, scale: scale, orientation: orientation)
        return uiImage
    }
    // function to get the name out of the secondary allImageNames Array, mirroring allImages
    // otherwise some construction with tuples maybe appropriate, but here it is just overkill
    func imageName(index:Int) -> String
    {
        let filename = allImageNames[index]
        return (filename as NSString).deletingPathExtension
    }

    func saveResults(adjust: Bool, channels: Float, passes: Float, exposure: Float, contrast: Float, highlights: Float, shadows: Float, saturation: Float, temperature: Float, tint: Float)
    {
        var inputImage = CIImage(image: allImages[selectedIndex])!
        let name = imageName(index: selectedIndex)

        /*CocoaHeads*/
        // mean image and adjust filters, but not scaling, mostly the same as in intermediate
        let meanImage = inputImage

        let ciImage = ciImageFromFilterWith(meanImage, exposure: exposure, contrast: contrast, highlights: highlights, shadows: shadows, saturation: saturation, temperature: temperature, tint: tint)
        
        var path = ciImage.saveJPEG(name, quality: 0.3, inContext: Helper.context)
        print(path ?? "no luck saving TIFF")
         path = ciImage.savePNG(name, inContext: Helper.context)
        print(path ?? "no luck saving TIFF")
         path = ciImage.saveTIFF(name, inContext: Helper.context)
        print(path ?? "no luck saving TIFF")
 

        // UIImage style
        //        let uiImage = filterWith(meanImage, exposure: exposure, contrast: contrast, highlights: highlights, shadows: shadows, saturation: saturation, temperature: temperature, tint: tint)
        //        uiImage.saveAsPNG(name)


        print("\n\(name)\n")
        if(path != nil)
        {
            print (path!)

            print("exposure: \(exposure)")
            print("contrast: \(contrast)")
            print("saturation: \(saturation)")
            print("temperature: \(temperature)")
            print("tint: \(tint)")
            print("highlights: \(highlights)")
            print("shadows: \(shadows)")
            /*CocoaHeads*/
            // after printing, some cleanup is necessary

        }
    }
}



extension UIImage {
    static func from(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        return UIGraphicsImageRenderer(size: size, format: format).image { context in
            color.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
    }
    // UI-style saving
    func saveAsPNG(_ name:String){
        
        let writeDirURL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let pngURL = writeDirURL!.appendingPathComponent(name, conformingTo: UTType.png)

        if let data = self.pngData() {
            do {
                try? data.write(to: pngURL)
            }
        }
    }
}

extension CIImage {
    // all in one place to keep the destination in one place
    private func defaultDestinationURL() -> URL?
    {
        let destinationURL = try? FileManager.default.url(for:.picturesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        return destinationURL
    }

    @objc func saveJPEG(_ name:String, inDirectoryURL:URL? = nil, quality:CGFloat = 1.0, inContext: CIContext? = nil) -> String? {
        
        var destinationURL = inDirectoryURL
        
        if destinationURL == nil {
            destinationURL = defaultDestinationURL()
        }
        
        if var destinationURL = destinationURL {
            
//             = destinationURL.appendingPathComponent(name)
            destinationURL = destinationURL.appendingPathComponent(name, conformingTo: UTType.jpeg)
            
            if let colorSpace = CGColorSpace(name: CGColorSpace.sRGB) {
                
                do {
                    let context = inContext == nil ? CIContext() : inContext!

                    try context.writeJPEGRepresentation(of: self, to: destinationURL, colorSpace: colorSpace, options: [kCGImageDestinationLossyCompressionQuality as CIImageRepresentationOption : quality])
                    
                    return destinationURL.path
                    
                } catch {
                    return nil
                }
            }
        }
        return nil
    }
    
    @objc func savePNG(_ name:String, inDirectoryURL:URL? = nil, inContext: CIContext? = nil) -> String? {
        
        var destinationURL = inDirectoryURL
        
        if destinationURL == nil {
            destinationURL = defaultDestinationURL()
        }
        
        if var destinationURL = destinationURL {
            
//            destinationURL = destinationURL.appendingPathComponent(name)
            destinationURL = destinationURL.appendingPathComponent(name, conformingTo: UTType.png)

            if let colorSpace = CGColorSpace(name: CGColorSpace.sRGB) {
                
                do {

                    let context = inContext == nil ? CIContext() : inContext!
                    let format = CIFormat.RGBA8
                          
                      try context.writePNGRepresentation(of: self, to: destinationURL, format: format, colorSpace: colorSpace)
                           
                    return destinationURL.path
                    
                } catch {
                    return nil
                }
            }
        }
        return nil
    }
    
    @objc func saveTIFF(_ name:String, inDirectoryURL:URL? = nil, inContext: CIContext? = nil) -> String? {
        
        var destinationURL = inDirectoryURL
        
        if destinationURL == nil {
            destinationURL = defaultDestinationURL()
        }
        
        if var destinationURL = destinationURL {
            
            destinationURL = destinationURL.appendingPathComponent(name, conformingTo: UTType.tiff)

            if let colorSpace = CGColorSpace(name: CGColorSpace.sRGB) {
                
                do {
                    let context = inContext == nil ? CIContext() : inContext!
                    let format = CIFormat.RGBA8
                          
                    try context.writeTIFFRepresentation(of: self, to: destinationURL, format: format, colorSpace: colorSpace)
                           
                    return destinationURL.path
                    
                } catch {
                    return nil
                }
            }
        }
        return nil
    }
    // function to print all filters in their categories with their attibutes
    // note that filters usually are collected in multiple categories related to the filter
    func ciFilters()
    {
        let names = CIFilter.filterNames(inCategories: [])
        let builtInNames = CIFilter.filterNames(inCategories: ["CICategoryBuiltIn"])
        if(names == builtInNames)
        {
            print("all filters are built in!")
        }
        

        var results:Set<String> = Set()
          let filters = CIFilter.filterNames(inCategory: nil)

          for category in filters {
              let attributes = CIFilter(name: category)?.attributes
//              let t = type(of: attributes)
//              print("'\(String(describing: attributes))' of type '\(t)'")
              let array = attributes!["CIAttributeFilterCategories"]
              
//              let t1 = type(of: array)
//              print("'\(String(describing: array))' of type '\(t1)'")
          
              results.formUnion(array as! Array<String> as Array)


            }
        let cats:[String] = results.sorted(by: <)
        print("----------------- all categories --------------------------\n")
        print("\n")
        print(cats)
        print("-----------------------------------------------------------\n")
        print("---------------- all filter names -------------------------\n")
        print (names)
        print("\n")

        print("------------- all filters' attributes ---------------------\n")

        results.forEach() {
            
            let str = String($0)
            let filtersInCategory = CIFilter.filterNames(inCategory: str)
            print("--- ** \(str) ** \(filtersInCategory.count) ** -------------------------\n")
            for aFilterName in filtersInCategory
            {// the filters have to instantiated in order access the attributes.
                // printing (filtersInCategory) yields almost the same result, but almost not readable
                print("\n\(aFilterName)\n")
                let filter = CIFilter.init(name: aFilterName)
                print(filter?.attributes ?? "")
                print("-----------------------------------------------------------")
            }
            }
        
    }
}
