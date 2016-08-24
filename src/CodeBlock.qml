import QtQuick 2.0

Rectangle {
    id: codeBlock

    property string codeFontFamily: "Courier New"
    property string code
    property string title
    property real codeFontSize: Math.max(parent.height*0.03, 1.0)
    property string textColor: "white"

    Rectangle {
        anchors.right: parent.right
        anchors.top: parent.top
        height: titleText.implicitHeight
        width: titleText.implicitWidth + parent.width*0.01
        border.color: Qt.rgba(0, 177, 172)
        border.width: parent.border.width;
        antialiasing: true
        radius: parent.radius;
        color: "black"
        Text {
            x: parent.width*0.01
            id: titleText
            text: title
            font.pixelSize: codeBlock.codeFontSize
            color: textColor
            horizontalAlignment: Text.AlignHCenter
        }
    }

    radius: height / 100;
    gradient: Gradient {
        GradientStop { position: 0; color: Qt.rgba(0.0, 0.0, 0.0, 1.0); }
        GradientStop { position: 1; color: Qt.rgba(0.2, 0.2, 0.2, 1.0); }
    }
    border.color: Qt.rgba(0, 177, 172)
    border.width: height / 250;
    antialiasing: true

    onCodeChanged: {
        listModel.clear();
        var codeLines = codeBlock.code.split("\n");
        for (var i=0; i<codeLines.length; ++i) {
            listModel.append({
                                line: i,
                                code: codeLines[i]
                             });
        }
    }

    ListModel {
        id: listModel
    }

    onVisibleChanged: {
        listView.focus = codeBlock.visible;
        listView.currentIndex = -1;
    }

    ListView {
        id: listView;

        anchors.fill: parent;
        anchors.margins: codeBlock.radius / 2
        clip: true

        model: listModel;
        focus: true;

        MouseArea {
            anchors.fill: parent
            onClicked: {
                listView.focus = true;
                listView.currentIndex = listView.indexAt(mouse.x, mouse.y + listView.contentY);
            }
        }

        delegate: Item {
            id: itemDelegate

            height: lineLabel.height
            width: parent.width

            Rectangle {
                id: lineLabelBackground
                width: lineLabel.height * 3;
                height: lineLabel.height;
                color: codeBlock.textColor;
                opacity: 0.1;
            }

            Text {
                id: lineLabel
                anchors.right: lineLabelBackground.right;
                text: (line+1) + ":"
                color: codeBlock.textColor;
                font.family: codeBlock.codeFontFamily
                font.pixelSize: codeBlock.codeFontSize
                font.bold: itemDelegate.ListView.isCurrentItem;
                opacity: itemDelegate.ListView.isCurrentItem ? 1 : 0.9;

            }

            Rectangle {
                id: lineContentBackground
                anchors.fill: lineContent;
                anchors.leftMargin: -height / 2;
                color: codeBlock.textColor
                opacity: 0.2
                visible: itemDelegate.ListView.isCurrentItem;
            }

            Text {
                id: lineContent
                anchors.left: lineLabelBackground.right
                anchors.leftMargin: lineContent.height;
                anchors.right: parent.right;
                color: textColor;
                text: code;
                font.family: codeBlock.codeFontFamily
                font.pixelSize: codeBlock.codeFontSize
                font.bold: itemDelegate.ListView.isCurrentItem;
                opacity: itemDelegate.ListView.isCurrentItem ? 1 : 0.9;
            }
        }
    }



}
