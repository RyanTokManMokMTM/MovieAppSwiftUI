//
//  ImageCropping.swift
//  IOS_DEV
//
//  Created by Jackson on 25/1/2022.
//

import SwiftUI
// Created By ChrisLearns • IMMIX Concepts, LLC.
var UniversalSafeOffsets = UIApplication.shared.windows.first?.safeAreaInsets

struct ImageCropping: View {
    @Binding var imageWidth:CGFloat
    @Binding var imageHeight:CGFloat
    @State var center:CGFloat = 0
    
    @State var activeOffset:CGSize = CGSize(width: 0, height: 0)
    @Binding var finalOffset:CGSize
    
    @State var activeMagnification:CGFloat = 1
    @Binding var finalMagnification:CGFloat
    
    @State var dotSize:CGFloat = 13
    var dotColor = Color.init(white: 1).opacity(0.9)
    var surroundingColor = Color.black.opacity(0.45)
    
    var body: some View {
        ZStack{
        //These are the views for the surrounding rectangles
            Group{
            Rectangle()
//                .foregroundColor(Color.red.opacity(0.3))
                .foregroundColor(surroundingColor)
                .frame(width: ((imageWidth-getDimension(w: imageWidth, h: imageHeight))/2) + activeOffset.width + (getDimension(w: imageWidth, h: imageHeight) * (1 - activeMagnification) / 2), height: imageHeight)
                .offset(x: getSurroundingViewOffsets(horizontal: true, left_or_up: true), y: 0)
            Rectangle()
//                .foregroundColor(Color.blue.opacity(0.3))
                .foregroundColor(surroundingColor)
                
                .frame(width: ((imageWidth-getDimension(w: imageWidth, h: imageHeight))/2) - activeOffset.width + (getDimension(w: imageWidth, h: imageHeight) * (1 - activeMagnification) / 2), height: imageHeight)
                .offset(x: getSurroundingViewOffsets(horizontal: true, left_or_up: false), y: 0)
            Rectangle()
//                .foregroundColor(Color.yellow.opacity(0.3))
                .foregroundColor(surroundingColor)
                .frame(width: getDimension(w: imageWidth, h: imageHeight) * activeMagnification, height: ((imageHeight-getDimension(w: imageWidth, h: imageHeight))/2) + activeOffset.height + (getDimension(w: imageWidth, h: imageHeight) * (1 - activeMagnification) / 2))
                .offset(x: activeOffset.width, y: getSurroundingViewOffsets(horizontal: false, left_or_up: true))
            Rectangle()
//                .foregroundColor(Color.green.opacity(0.3))
                .foregroundColor(surroundingColor)
                .frame(width: getDimension(w: imageWidth, h: imageHeight) * activeMagnification, height: ((imageHeight-getDimension(w: imageWidth, h: imageHeight))/2) - activeOffset.height + (getDimension(w: imageWidth, h: imageHeight) * (1 - activeMagnification) / 2))
                .offset(x: activeOffset.width, y: getSurroundingViewOffsets(horizontal: false, left_or_up: false))
        }
            //This view creates a very translucent rectangle that overlies the picture we'll be uploading
            Rectangle()
                .frame(width: getDimension(w: imageWidth, h: imageHeight)*activeMagnification, height: getDimension(w: imageWidth, h: imageHeight)*activeMagnification)
                .foregroundColor(Color.white.opacity(0.05))
                .offset(x: activeOffset.width, y: activeOffset.height)
                .gesture(
                    DragGesture()
                        .onChanged{drag in
                            //Create an instance of the finalOffset + the change made via dragging - "workingOffset" will be used only for calcuations to determine if our drag should be "finalized"
                            let workingOffset = CGSize(
                                width: finalOffset.width + drag.translation.width,
                                height: finalOffset.height + drag.translation.height
                            )
                            
                            print(workingOffset.width + (getDimension(w: imageWidth, h: imageHeight)/2))
                            
                            //First check if we are within the right and left bounds when translating in the horizontal dimension
                            if workingOffset.width + (finalMagnification * getDimension(w: imageWidth, h: imageHeight)/2) <= imageWidth/2 &&
                                (workingOffset.width - (finalMagnification * getDimension(w: imageWidth, h: imageHeight)/2)) >= -imageWidth/2 {
                                //If we are, then set the activeOffset.width equal to the workingOffset.width
                                self.activeOffset.width = workingOffset.width
                            } else if workingOffset.width + (finalMagnification * getDimension(w: imageWidth, h: imageHeight)/2) > imageWidth/2 {
                                //If we are at the right-most bound then align the right-most edges accordingly
                                self.activeOffset.width = (imageWidth/2) - (finalMagnification * getDimension(w: imageWidth, h: imageHeight)/2)
                            } else {
                                //If we are at the left-most bound then align the left-most edges accordingly
                                self.activeOffset.width = -(imageWidth/2) + (finalMagnification * getDimension(w: imageWidth, h: imageHeight)/2)
                            }
                            
                            //Next check if we are within the upper and lower bounds when translating in the vertical dimension
                            if workingOffset.height + (finalMagnification * getDimension(w: imageWidth, h: imageHeight)/2) <= imageHeight/2 &&
                                ((workingOffset.height) - (finalMagnification * getDimension(w: imageWidth, h: imageHeight)/2)) >= -imageHeight/2 {
                                //If we are, then set the activeOffset.height equal to the workingOffset.height
                                self.activeOffset.height = workingOffset.height
                            }
                            else if workingOffset.height + (finalMagnification * getDimension(w: imageWidth, h: imageHeight)/2) > imageWidth/2 {
                                //If we are at the bottom-most bound then align the bottom-most edges accordingly
                                self.activeOffset.height = (imageHeight/2) - (finalMagnification * getDimension(w: imageWidth, h: imageHeight)/2)
                            } else {
                                //If we are at the top-most bound then align the top-most edges accordingly
                                self.activeOffset.height = -((imageHeight/2) - (finalMagnification * getDimension(w: imageWidth, h: imageHeight)/2))
                            }
                            
                        }
                        .onEnded{drag in
                            //Set the finalOffset equal to activeOffset; the whole point of this is that we use activeOffset to update the view, whereas finalOffset serves as the starting point for any calculations for each iteration of onChanged in a drag gesture
                            self.finalOffset = activeOffset
                        }
                )
            
            //These views create the white grid
            //This view creates the outer square
            Rectangle()
                .stroke(lineWidth: 1)
                .frame(width: getDimension(w: imageWidth, h: imageHeight)*activeMagnification, height: getDimension(w: imageWidth, h: imageHeight)*activeMagnification)
                .foregroundColor(.white)
                .offset(x: activeOffset.width, y: activeOffset.height)
            
            //This view creates a thin rectangle in the center that is 1/3 the outer square's width
            Rectangle()
                .stroke(lineWidth: 1)
                .frame(width: getDimension(w: imageWidth, h: imageHeight)*activeMagnification/3, height: getDimension(w: imageWidth, h: imageHeight)*activeMagnification)
                .foregroundColor(Color.white.opacity(0.6))
                .offset(x: activeOffset.width, y: activeOffset.height)
            
            //This view creates a thin rectangle in the center that is 1/3 the outer square's height
            Rectangle()
                .stroke(lineWidth: 1)
                .frame(width: getDimension(w: imageWidth, h: imageHeight)*activeMagnification, height: getDimension(w: imageWidth, h: imageHeight)*activeMagnification/3)
                .foregroundColor(Color.white.opacity(0.6))
                .offset(x: activeOffset.width, y: activeOffset.height)
            
            
            //UL corner icon
            Image(systemName: "arrow.up.left.and.arrow.down.right")
                .font(.system(size: 12))
                .background(Circle().frame(width: 20, height: 20).foregroundColor(dotColor))
                .frame(width: dotSize, height: dotSize)
                .foregroundColor(.black)
                .offset(x: activeOffset.width - (activeMagnification*getDimension(w: imageWidth, h: imageHeight)/2), y: activeOffset.height - (activeMagnification*getDimension(w: imageWidth, h: imageHeight)/2))
                .padding(25)
                .gesture(
                    DragGesture()
                        .onChanged{drag in
                            //First it calculates the additional magnification this drag is proposing
                            let calcMag = getMagnification(drag.translation)
                            
                            //It then multiplies it against the magnification that was already present in your crop
                            let workingMagnification:CGFloat = finalMagnification * calcMag
                            
                            //**********************************
                            //This set of logic is used for calculations that prevent scaling to cause offset to go outside the actual image
                            //First we check the size of the offsets
                            let workingOffsetSize = (getDimension(w: imageWidth, h: imageHeight) * finalMagnification)-(getDimension(w: imageWidth, h: imageHeight) * activeMagnification)
                            
                            //Then we check the offset of the image barring the current "onChanged" we are currently experiencing by adding the proposed "workingOffsetSize" to the displayed "finalOffset"
                            let workingOffset = CGSize(width: finalOffset.width + workingOffsetSize/2, height: finalOffset.height + workingOffsetSize/2)
                            
                            //From here we calculate half the height of the original image and half the width, so we can use them to calculate if further scaling will extend our cropping view off the bounds of the screen
                            let halfImageHeight = self.imageHeight/2
                            let halfImageWidth = self.imageWidth/2
                            
                            //This variable is equal to half of the view finding square, factoring in the magnification
                            let proposed_halfSquareSize = (getDimension(w: imageWidth, h: imageHeight)*activeMagnification)/2
                            //**********************************
                            
                            //Here we are setting up the upper and lower limits of the magnificatiomn
                            if workingMagnification <= 1 && workingMagnification >= 0.4{
                                //If we fall within the scaling limits, then we will check that scaling would not extend the viewfinder past the bounds of the actual image
                                if proposed_halfSquareSize - workingOffset.height > halfImageHeight || proposed_halfSquareSize - workingOffset.width > halfImageWidth{
                                    print("scaling would extend past image bounds")
                                } else {
                                    activeMagnification = workingMagnification
                                }
                                
                            } else if workingMagnification > 1{
                                activeMagnification = 1
                            } else {
                                activeMagnification = 0.4
                            }
                            
                            
                            //As you magnify, you technically need to modify offset as well, because magnification changes are not symmetric, meaning that you are modifying the magnfiication only be shifting the upper and left edges inwards, thus changing the center of the croppedingview, so the offset needs to move accordingly
                            let offsetSize = (getDimension(w: imageWidth, h: imageHeight) * finalMagnification)-(getDimension(w: imageWidth, h: imageHeight) * activeMagnification)
                            
                            self.activeOffset.width = finalOffset.width + offsetSize/2
                            self.activeOffset.height = finalOffset.height + offsetSize/2
                            print("current yOffset = \(workingOffset.height)")
                            print("half image height = \(halfImageHeight)")
                            print("proposed half-square size = \(proposed_halfSquareSize)")
                        }
                        .onEnded{drag in
                            
                            //At the end you need to set the "final" variables equal to the "active" variables.
                            //The difference between these variables is that active is what is displayed, while final is what is used for calculations.
                            self.finalMagnification = activeMagnification
                            self.finalOffset = activeOffset
                            
                        }
                )
        }
        
    }
    
    
    
    //This function gets the offset for the surrounding views that obscure what has not been selected in the crop
    func getSurroundingViewOffsets(horizontal:Bool, left_or_up:Bool) -> CGFloat {
        let initialOffset:CGFloat = horizontal ? imageWidth : imageHeight
        let negVal:CGFloat = left_or_up ? -1 : 1
        let compensator = horizontal ? activeOffset.width : activeOffset.height
        
        return (((negVal * initialOffset) - (negVal * (initialOffset - getDimension(w: imageWidth, h: imageHeight))/2))/2) + (compensator/2) + (-negVal * (getDimension(w: imageWidth, h: imageHeight) * (1 - activeMagnification) / 4))
    }
    
    //This function determines the intended magnification you were going for. It does so by measuring the distance you dragged in both dimensions and comparing it against the longest edge of the image. The larger ratio is determined to be the magnification that you intended.
    func getMagnification(_ dragTranslation:CGSize) -> CGFloat {
        print(dragTranslation.width)
        if (getDimension(w: imageWidth, h: imageHeight) - dragTranslation.width)/getDimension(w: imageWidth, h: imageHeight) < (getDimension(w: imageWidth, h: imageHeight) - dragTranslation.height)/getDimension(w: imageWidth, h: imageHeight) {
            return (getDimension(w: imageWidth, h: imageHeight) - dragTranslation.width)/getDimension(w: imageWidth, h: imageHeight)
        } else {
            return (getDimension(w: imageWidth, h: imageHeight) - dragTranslation.height)/getDimension(w: imageWidth, h: imageHeight)
        }
    }
    
}

//compare with 2 value
func getDimension(w:CGFloat,h:CGFloat) -> CGFloat{
    return h > w ? w : h
}

