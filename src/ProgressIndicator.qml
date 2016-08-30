import QtQuick 2.3
import QtQuick.Layouts 1.1

Item {
    id: root
    property alias sections: sectionRepeater.model
    property var sectionHeaders
    property int currentSection: 0
    property int currentItem: 0
    property var slides
    property int currentSlide

    property real radius: 7
    property bool showText: true
    property color colorPrevious: "darkGrey"
    property color colorCurrent: "black"
    property color colorNext: "grey"
    onCurrentSlideChanged: {
        var slide = slides[currentSlide];
        for (var index = 0; index < sections.length; ++index) {
            var ind = sections[index].indexOf( slide );
            if(ind !== -1) {
                currentSection = index;
                currentItem = ind;
                break;
            }
        }
    }

    Flow {
        Repeater {
            id: sectionRepeater
            Flow {
                id: slideFlow
                property bool isActive: index === currentSection
                property int sectionIndex: index
                Column {
                    Flow {
                        Repeater {
                            id: sliderRepeater
                            model: sectionRepeater.model[slideFlow.sectionIndex]
                            Rectangle {
                                width: root.radius*2
                                height: width
                                radius: root.radius
                                color: sliderRepeater.model[index] === root.slides[currentSlide]
                                            ? root.colorCurrent
                                            : slideFlow.sectionIndex < currentSection
                                                ? root.colorPrevious
                                                : slideFlow.sectionIndex > currentSection
                                                    ? root.colorNext
                                                    : index < currentItem
                                                        ? root.colorPrevious : root.colorNext
                            }
                        }
                    }
                    Text {
                        visible: root.showText
                        text: sectionHeaders[index]
                    }
                }
                Item {
                    width: root.radius
                    height: width
                }
            }
        }
    }
}


