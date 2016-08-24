import QtQuick 2.0
import ".."

SteppingSlide {
//    property list<Image> images

//    contentWidth: width*0.9-imgColumn.width
//    Column {
//        id:imgColumn
//        anchors.right: parent.right
//        height: parent.height
//        spacing: parent.height*0.02
//        Column {
//            Repeater
//            Image {
//                id: img1
//                height: imgColumn.height*0.45
//                opacity: slideIntroduction.currentBullet > 0 || slideIntroduction.currentStep >= 1 && slideIntroduction.currentBullet == 0
//                source: "qrc:/images/twodatapoints-nottrivial.svg"
//                fillMode: Image.PreserveAspectFit

//                Behavior on opacity {
//                    NumberAnimation { duration: 500 }
//                }
//            }
//            Text {
//                width: img1.width
//                opacity: img1.opacity
//                text: "zweidimensionale Wertemenge"
//                color: "white"
//                horizontalAlignment: Text.AlignHCenter
//            }
//        }

//        Column {
//            Image {
//                id: img2
//                height: img1.height
//                opacity: slideIntroduction.currentStep == 1 && slideIntroduction.currentBullet === slideIntroduction.content.length-1
//                source: "qrc:/images/twodatapoints-asheatmap.svg"
//                fillMode: img1.fillMode

//                Behavior on opacity {
//                    NumberAnimation { duration: 500 }
//                }
//            }
//            Text {
//                width: img2.width
//                opacity: img2.opacity
//                text: "Heatmap"
//                color: "white"
//                horizontalAlignment: Text.AlignHCenter
//            }
//        }
//    }

//    function advanceStep() {
//        switch(slideIntroduction.currentBullet) {
//        case 0:
//            return slideIntroduction.currentStep < 1;
//        case slideIntroduction.content.length-1:
//            return slideIntroduction.currentStep < 1;
//        default:
//            return false;
//        }
//    }
}
