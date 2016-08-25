/****************************************************************************
**
** Author: Daniel Bulla
** Contact: d.bulla@fh-aachen.de
**
****************************************************************************/

import Qt.labs.presentation 1.0
import QtQuick 2.0
import QtQuick.Controls 1.4

Presentation
{
    id: presentation

    width: 1280
    height: 720

    SlideCounter {}
    Clock {}
    ProgressIndicator {
        id: progInd
        width: presentation.width * 0.2
        height: presentation.height * 0.04
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: presentation.width*0.01
        opacity: presentation.currentSlide > 1 && presentation.currentSlide !== presentation.slides.length-1
        sections: presentation.sections
        sectionHeaders: presentation.sectionHeaders
        slides: presentation.slides
        currentSlide: presentation.currentSlide

    }
    property var sections: [
        [ slideTitle, slideContent ],
        [ slideComp1 ],
        [ slide2, slide3 ],
        [ slideEnd ],
    ]

    property var sectionHeaders: [
        "Intro",
        "Components",
        "Part 2",
        "End",
    ]

    Slide {
        id: slideTitle
        title: "Title"
    }

    Slide {
        id: slideContent
        title: "Content"
    }

    Slide {
        TabView {
            id: tabView

            anchors.fill: parent
            anchors.margins: UI.margin
            tabPosition: UI.tabPosition

            Tab {
                title: "Buttons"
                ButtonPage {
                    enabled: enabler.checked
                }
            }
            Tab {
                title: "Progress"
                ProgressPage {
                    enabled: enabler.checked
                }
            }
            Tab {
                title: "Input"
                InputPage {
                    enabled: enabler.checked
                }
            }
        }
    }

    Slide {
        id: slideComp1
        delayPoints: true
        showAllPoints: true
        title: "ImageStepCompare"
        ImageStepCompare {
            id: imgCol
            width: parent.width*0.4
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: parent.height*0.01
            anchors.topMargin: -parent.height*0.06
            sources: [ "/home/dbulla/develop/upns_presentation/images/surfel_circle2.png",
                       "/home/dbulla/develop/upns_presentation/images/surfel_ellipse2.png",
                       "/home/dbulla/develop/upns_presentation/images/surfel_raycast2.png"]
            // zoom out after every step by setting "step" to -1
            step: slideComp1.currentStep%2 ? (slideComp1.currentStep-1)/2 : -1
        }
        function advanceStep() {
            return currentStep < imgCol.sources.length*2;
        }
    }
    Slide {
        id: slide2
        title: "Slide 2"
    }
    Slide {
        id: slide3
        title: "Slide 3"
    }
    Slide {
        id: slideEnd
        centeredText: "Thanks for your attention"
    }
}
