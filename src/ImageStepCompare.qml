/****************************************************************************
**
** Author: Daniel Bulla
** Contact: d.bulla@fh-aachen.de
**
****************************************************************************/

import QtQuick 2.4

Item {
    id: root
    property int step: -1
    property var sources: []
    property var alignments: []
    property bool masked: false
    onStepChanged: {
        priv.frontImage = imageRepeater.itemAt(step)
    }

    function reset() {
        for (var index = 0; index < imageRepeater.model.length; ++index) {
            var img = imageRepeater.itemAt(index);
            if(img === priv.frontImage) {
                img.y = 0
                img.height = root.height
                img.z = 1
            } else {
                img.y = root.height/imageRepeater.model.length*index
                img.height = root.height/imageRepeater.model.length
                img.z = 0
            }
        }
    }

    Item {
        id: priv
        property var oldFrontImage
        property var frontImage
        onFrontImageChanged: {
            updateFrontImage()
        }
        function updateFrontImage() {
            if( oldFrontImage ) {
                oldFrontImage.fadeOut.start()
            }
            if( frontImage ) {
                frontImage.fadeIn.start()
            }
            oldFrontImage = frontImage
        }

    }
    Repeater {
        anchors.fill: parent
        id: imageRepeater
        model: sources
        Image {
            id: img
            source: imageRepeater.model[index]
            verticalAlignment: root.alignments[index] ? root.alignments[index] : Image.AlignVCenter
            width: parent.width
            height: root.height/imageRepeater.model.length
            y: root.height/imageRepeater.model.length*index
            fillMode: Image.PreserveAspectCrop
            smooth: true
            mipmap: false

            property var fadeOut: ParallelAnimation {
                NumberAnimation {
                    target: img
                    property: "height"
                    duration: 500
                    easing.type: Easing.InOutQuad
                    from: root.height
                    to: root.height/imageRepeater.model.length
                    alwaysRunToEnd: true
                }
                NumberAnimation {
                    target: img
                    property: "y"
                    duration: 500
                    easing.type: Easing.InOutQuad
                    from: 0
                    to: root.height/imageRepeater.model.length*index
                    alwaysRunToEnd: true
                }
                NumberAnimation {
                    target: img
                    property: "z"
                    duration: 500
                    easing.type: Easing.InOutQuad
                    from: 1
                    to: 0
                    alwaysRunToEnd: true
                }
            }
            property var fadeIn: SequentialAnimation {
                onStopped: root.reset()
                NumberAnimation {
                    duration: 500
                    alwaysRunToEnd: true
                }
                ParallelAnimation {
                    NumberAnimation {
                        target: img
                        property: "height"
                        duration: 500
                        easing.type: Easing.InOutQuad
                        from: root.height/imageRepeater.model.length
                        to: root.height
                        alwaysRunToEnd: true
                    }
                    NumberAnimation {
                        target: img
                        property: "y"
                        duration: 500
                        easing.type: Easing.InOutQuad
                        from: root.height/imageRepeater.model.length*index
                        to: 0
                        alwaysRunToEnd: true
                    }
                    NumberAnimation {
                        target: img
                        property: "z"
                        duration: 500
                        easing.type: Easing.InOutQuad
                        from: 0
                        to: 1
                        alwaysRunToEnd: true
                    }
                }
            }
        }
    }
}
