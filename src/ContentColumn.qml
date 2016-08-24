import QtQuick 2.0

Column {
    id: contentId

    property alias content: contentRepeater.model
    property var textFormat: Text.RichText
    Repeater {
        id: contentRepeater
        Row {
            id: row

            function decideIndentLevel(s) { return s.charAt(0) == " " ? 1 + decideIndentLevel(s.substring(1)) : 0 }
            property int indentLevel: decideIndentLevel(contentRepeater.model[index])
            property int nextIndentLevel: index < contentRepeater.model.length - 1 ? decideIndentLevel(contentRepeater.model[index+1]) : 0
            property real indentFactor: (10 - row.indentLevel * 2) / 10;

            height: text.height + (nextIndentLevel == 0 ? 1 : 0.3) * slide.baseFontSize * slide.bulletSpacing
            x: slide.baseFontSize * indentLevel
            visible: true//(!slide.parent.allowDelay || !delayPoints) || index <= _pointCounter

            Rectangle {
                id: dot
                y: baseFontSize * row.indentFactor / 2
                width: baseFontSize / 4
                height: baseFontSize / 4
                color: slide.textColor
                radius: width / 2
                smooth: true
                opacity: text.text.length == 0 ? 0 : 1
            }

            Rectangle {
                id: space
                width: dot.width * 2
                height: 1
                color: "#00ffffff"
            }

            Text {
                id: text
                width: contentId.width - parent.x - dot.width - space.width
                font.pixelSize: baseFontSize * row.indentFactor
                text: contentRepeater.model[index].substring(indentLevel)
                textFormat: contentId.textFormat
                wrapMode: Text.WordWrap
                color: slide.textColor
                horizontalAlignment: Text.AlignLeft
                font.family: slide.fontFamily
            }
        }
    }
}
