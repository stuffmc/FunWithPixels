//
//  ContentView.swift
//  FunWithPixels-AC-CocoaHeads
//
//  Created for Cocoaheads AC on 27.01.25
//  by Werner Lonsing

import SwiftUI

struct ContentView: View {
    
    @State private var adjust: Bool = false
    
    @State private var exp: Float = 0 //exposure
    @State private var cont: Float = 1 //contrast
    @State private var sat: Float = 1 //saturation
    @State private var high: Float = 1 //highlights
    @State private var shdw: Float = 0 //shadow
    @State private var temp: Float = 0 //temperature
    @State private var tint: Float = 0 //tint
    @State private var meanChannels: Float = 0 //color channels for mean
    @State private var meanPasses: Float = 0.0 //passes for mean
    @State private var selIndex = 0
    @State private var helper = Helper()
    
    var body: some View {
        
        let tintColor = Color(uiColor: #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1))
        let foreGroundColor = Color(uiColor: #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1))
        
        var theImage = helper.allImages[selIndex]
        let theWidth: CGFloat = 160
        
        VStack(alignment: .center, spacing: 0)
        {
            Text("Fun with Pixels")
                .font(.custom("Chalkduster", size: 24))
                .bold()
                .background(LinearGradient(gradient: Gradient(colors: [.white, tintColor, .white]), startPoint: .top, endPoint: .bottom))
                .foregroundColor(foreGroundColor)
            
            
            HStack{
                VStack(alignment: .trailing, spacing:0)
                {
                    VStack(alignment: .center, spacing:0)
                    {
                        ScrollViewReader { proxy in
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack(spacing: 0) {
                                    ForEach(helper.allImages, id: \.self) { image in
                                        Image(uiImage:image)
                                            .resizable()
                                            .scaledToFit()
                                            .onTapGesture {
                                                selIndex = helper.allImages.firstIndex(of: image) ?? 0
                                                theImage = image
                                                newIntermediate()
                                                //                             print("tapped: \(selIndex)")
                                            }
                                        
                                            .frame(width: theWidth)
                                            .clipShape(RoundedRectangle(cornerRadius: 4.0))
                                            .padding(.horizontal, 1)
                                            .containerRelativeFrame(.horizontal)
                                            .scrollTransition(.animated, axis: .horizontal) { content, phase in
                                                content
                                                    .opacity(phase.isIdentity ? 1.0 : 0.6)
                                                    .scaleEffect(phase.isIdentity ? 1.0 : 0.6)
                                            }
                                    }
                                }
                            }
                            .scrollTargetBehavior(.paging)
                            .onChange(of: theImage) { _, newImage in
                                // Scroll to selected image when it changes
                                proxy.scrollTo(newImage, anchor: .center)
                            }
                        Text("\(helper.imageName(index:selIndex))")
                            .font(.custom("Chalkduster", size: 12))
                            .bold()
                            .background(LinearGradient(gradient: Gradient(colors: [.white, tintColor, .white]), startPoint: .top, endPoint: .bottom))
                            .foregroundColor(foreGroundColor)
                    }
                        Spacer()

                    }

                    .padding()
                    .frame(width: theWidth)

                    
                    HStack(spacing:0){
                    Button {
                        selIndex = 0 < selIndex ? selIndex - 1 : helper.allImages.count - 1
                newIntermediate()
                    } label: {
                        Text("<")
                            .bold()
                            .font(.system(size: 14))
                            .foregroundColor(foreGroundColor)
//                            .trailing

                    }
                    .tint(tintColor)
                    .padding(5)
                    .buttonStyle(.borderedProminent)
                        Spacer()

                        Button {
                            selIndex = selIndex < helper.allImages.count - 1 ? selIndex + 1 : 0
                    newIntermediate()
                        } label: {
                            Text(">")
                                .bold()
                                .font(.system(size: 14))
                                .foregroundColor(foreGroundColor)

                        }
                        .tint(tintColor)
                        .padding(5)
                        .buttonStyle(.borderedProminent)
                    }
                    .tint(tintColor)
                    .frame(width: theWidth)
                    Spacer()

     HStack(alignment: .top){
        Toggle("🪄", isOn: $adjust)
             .onChange(of: adjust) {oldValue, newValue in
         newIntermediate()
             }
             .toggleStyle(.button)//checkbox button switch
             .font(.system(size: 18))
             .tint(tintColor)
             .background(tintColor.opacity(0.4))
             .contentShape(Rectangle())
             .buttonStyle(.borderedProminent)
             .clipShape(Capsule())
             .padding(1)
       Spacer()
         Button {
             resetAllValues()
         } label: {
             Text("↻")
                 .bold()
                 .padding(1)
                 .foregroundColor(foreGroundColor)
         }
         .contentShape(Rectangle())
         .buttonStyle(.borderedProminent)
         .tint(tintColor)
         Spacer()

         Button {
             saveImageInThreeFormats()
         } label: {
             Text("💾")
                 .font(.system(size: 16))
                 .padding(1)
         }
         .contentShape(Rectangle())
         .buttonStyle(.borderedProminent)
         .tint(tintColor)
       
     }
     .frame(width:theWidth)
 }
.frame(width:theWidth)
               ZStack {
                   let theSize: CGFloat = 180
                     
                    HStack{
                        Slider(value: $meanChannels, in: 0...20, step: 1.0)
                            .onChange(of: meanChannels) { oldValue, newValue in
                                newIntermediate()}
                            .tint(tintColor)
                            .frame(width: theSize, height: 50)
                            .offset(x:20,y:-70)
                        Text("\(meanChannels, specifier: "%1.0f")")
                            .tint(foreGroundColor)
                            .fixedSize()
                            .font(.title3)
                            .offset(x:-70,y:theSize + 10)
                            .foregroundStyle(foreGroundColor)
                            .rotationEffect(Angle(degrees: 90))
                    }
                   
                   HStack{
                       Slider(value: $meanPasses, in: 0...20, step: 1)
                           .onChange(of: meanPasses) { oldValue, newValue in
                               newIntermediate()}
                           .tint(tintColor)
                           .frame(width: theSize, height: 50)
                           .offset(x:20,y:-30)
                       
                       Text("\(meanPasses, specifier: "%1.0f")")
                           .tint(foreGroundColor)
                           .fixedSize()
                           .font(.title3)
                           .offset(x:-30,y:theSize + 10)
                           .foregroundStyle(foreGroundColor)
                           .rotationEffect(Angle(degrees: 90))
                   }
        
                   HStack{
                       let theOffset:CGFloat = 20
                       Slider(value: $high, in: 0...1)
                           .tint(tintColor)
                           .frame(width: theSize, height: 50)
                           .offset(x:40,y: theOffset)
                       
                       Text("🔆")
                           .tint(foreGroundColor)
                           .fixedSize()
                           .font(.title3)
                           .offset(x:theOffset,y:theSize + 10)
                           .foregroundStyle(foreGroundColor)
                           .rotationEffect(Angle(degrees: 90))
                   }
                   HStack{
                       let theOffset:CGFloat = 60
                       Slider(value: $shdw, in: 0...1)
                           .tint(tintColor)
                           .frame(width: theSize, height: 50)
                           .offset(x:40,y: theOffset)
                       
                       Text("🗣️")
                           .tint(foreGroundColor)
                           .fixedSize()
                           .font(.title3)
                           .offset(x: theOffset,y:theSize + 10)
                           .foregroundStyle(foreGroundColor)
                           .rotationEffect(Angle(degrees: 90))
                   }

                 }
                .rotationEffect(Angle(degrees: -90))
                .frame(width: 180, height: 50)
            }
            
            VStack(alignment: .center,
                   spacing: 10)
            {Slider( value: $exp, in: -1...1)
                {
                    Text("Exposure")
                } minimumValueLabel: {
                    Text("exposure")
                } maximumValueLabel: {
                    Text(exp.formatted(.number.rounded(increment: 0.1)))
                }
                .tint(tintColor)
                .foregroundStyle(foreGroundColor)

                Slider( value: $cont, in: 0.25...4)
                {
                    Text("Contrast")
                } minimumValueLabel: {
                    Text("contrast")
                } maximumValueLabel: {
                    Text(cont.formatted(.number.rounded(increment: 0.1)))
                }
                .tint(tintColor)
                .foregroundStyle(foreGroundColor)

                Slider( value: $sat, in: 0...2)
                {
                    Text("Saturation")
                } minimumValueLabel: {
                    Text("saturation")
                } maximumValueLabel: {
                    Text(sat.formatted(.number.rounded(increment: 0.1)))
                }
                .tint(tintColor)
                .foregroundStyle(foreGroundColor)

                Slider( value: $temp, in: -1...1)
                {
                    Text("Temperature")
                } minimumValueLabel: {
                    Text("temp")
                } maximumValueLabel: {
                    Text(temp.formatted(.number.rounded(increment: 0.1)))
                }
                .tint(tintColor)
                .foregroundStyle(foreGroundColor)

                Slider( value: $tint, in: -1...1)
                {
                    Text("Tint")
                } minimumValueLabel: {
                    Text("tint")
                } maximumValueLabel: {
                    Text(tint.formatted(.number.rounded(increment: 0.1)))
                }
                .tint(tintColor)
                .foregroundStyle(foreGroundColor)

                let sliderImage = newSliderImager()

                HStack{
                    Image(uiImage: sliderImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 280, height: 180)
                        .offset(x:0,y:0)
                        .onAppear(){
                            newIntermediate()
                            print("onAppear") // only called during appear.
                            theImage = helper.allImages.first! // Default to the first image
                        }
                }
                .onAppear(){
                    print("onAppear") // only called during appear.
                    theImage = helper.allImages.first! // Default to the first image
                }
            }
            .containerRelativeFrame(.horizontal)
            { width, axis in
                return width * 0.95
            }
            
            
            Spacer()
        }
    }
    func resetAllValues()
    {
        exp = 0 //exposure
        cont = 1 //contrast
        sat = 1 //saturation
        high = 1 //highlights
        shdw = 0 //shadow
        temp = 0 //temperature
        tint = 0 //tint
        meanChannels = 0//
        meanPasses = 0//
        adjust = false
        helper.reset()
    }
    
    
    func newSliderImager() -> UIImage
    {
        let img = helper.filterIntermediateWith(exposure: exp, contrast: cont, highlights: high, shadows: shdw, saturation: sat, temperature: temp, tint: tint)
        return img
    }

    func newIntermediate()
    {
        helper.intermediateImage(forIndex: selIndex, adjust: adjust, channels: meanChannels, passes: meanPasses)
    }
    
    func saveImageInThreeFormats()
    {
        helper.saveResults(adjust: adjust, channels: meanChannels, passes: meanPasses, exposure: exp, contrast: cont, highlights: high, shadows: shdw, saturation: sat, temperature: temp, tint: tint)
    }
}
    
    
    //https://forums.developer.apple.com/forums/thread/126949


#Preview {
    ContentView()
}
