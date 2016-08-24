import QtQuick 2.3
import QtQuick.Layouts 1.1

Item {
    id: root
    property alias items: sectionRepeater.model
    property var headers
    property int currentSection: 0
    property int currentItem: 0
    onWidthChanged: {
        lower.itemlen = typeof root.items !== "undefined" ? root.width/(root.items.length) : 0;
        upper.itemlen = typeof root.items !== "undefined" ? root.width/(root.items[currentSection].length) : 0;

        var modeltemp = sectionRepeater.model;
        if(typeof modeltemp !== "undefined")
        {
            sectionRepeater.model = 0;
            sectionRepeater.model = modeltemp;
            itemRepeater.model = modeltemp[currentSection];
        }
    }
    onCurrentSectionChanged: {
        upper.itemlen = root.items !== "undefined" ? root.width/(root.items[currentSection].length) : 0;
        itemRepeater.model = sectionRepeater.model[currentSection];
    }

    Rectangle {
        x: 0
        y: 0
        height: parent.height * 0.0
        width: parent.width
        color: Qt.rgba(10/255.0, 20/255.0, 29/255.0, 255/255.0)
        property real itemlen
        id: upper
        Repeater {
            id:itemRepeater

            delegate: Rectangle {
                x: index * upper.itemlen//*0.98 + root.width*0.01
                y: upper.height * 0.25
                width: upper.itemlen//*0.98
                height: upper.height * 0.8
                color: index < root.currentItem ? "black" : index === root.currentItem ? "white" : "#00B1AC"
                border.color: "black"
                border.width: 1.0

                Behavior on x { NumberAnimation { duration: 500 } }
                Behavior on width { NumberAnimation { duration: 500 } }
                Behavior on color { ColorAnimation { duration: 500 } }
            }
        }
    }
    Item {
        id: lower
        property real itemlen
        x: 0
        y: upper.height
        height: parent.height * 0.8
        width: parent.width
        Repeater {
            id:sectionRepeater

            delegate: Rectangle {
                property real theWidth: (1.0 + (index == root.currentSection) - (index == root.currentSection-1 || index == root.currentSection+1) * 0.5 - ((index == root.currentSection) && ((index == sectionRepeater.model.length-1) || (index == 0))) * 0.5 ) * lower.itemlen
                x: (index + ((-(index == root.currentSection && index != 0) + (index == root.currentSection+1)) * 0.5)) * lower.itemlen
                y: 0
                width: theWidth
                height: lower.height
                color: index === root.currentSection ? Qt.rgba(10/255.0, 20/255.0, 29/255.0, 255/255.0) : "#00B1AC"
                border.color: Qt.rgba(10/255.0, 20/255.0, 29/255.0, 255/255.0)
                border.width: index !== root.currentSection
                Text {
                    anchors.fill: parent
                    anchors.leftMargin: parent.width*0.1
                    anchors.rightMargin: parent.width*0.1
                    wrapMode: Text.NoWrap //Text.WrapAtWordBoundaryOrAnywhere
                    fontSizeMode: Text.HorizontalFit
                    text: index == root.currentSection ? root.headers[index] : ""
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    color: "white"
                //    visible: !widthAnim.running
                    Behavior on opacity { ColorAnimation { duration: 500 } }
                }
                //Behavior on x { NumberAnimation { duration: 500 } }
                //Behavior on width { NumberAnimation { id:widthAnim; duration: 500 } }
                Behavior on color { ColorAnimation { duration: 500 } }
            }
        }
    }
}

