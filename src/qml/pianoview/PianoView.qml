import QtQuick 2.5

Rectangle {
    property int keyWidth: 20
    property int keyHeight: 3.4*keyWidth

    function noteOn(chan, pitch, vel) {
        if (vel > 0)
            highlightKey(pitch, "#778692")
        else
            noteOff(chan, pitch, vel)
    }
    function noteOff(chan, pitch, vel) {
        highlightKey(pitch, ([1,3,6,8,10].indexOf(pitch % 12) > -1) ? "black":"white")
    }
    function noteHighlight(chan, pitch, vel, color) {
        highlightKey(pitch, color)
    }
    function allNotesOff() {
        for (var index = 21; index <= 108; ++index)
            noteOff(0, index, 0)
    }
    function highlightKey(pitch, color) {
        if (pitch < 24) {
            keyboard.children[pitch-21].color = color
            return
        }
        if (pitch == 108) {
            whiteKeyC.color = color
            return
        }
        var note = (pitch - 24) % 12
        var octave = (pitch - 24 - note) / 12
        keyboard.children[3+octave].children[note].color = color
    }

    width: 3*keyWidth+7*(7*keyWidth) + 20; height: keyHeight + 30
    radius: 5
    color: "#141414"

    Item {
        id: keyboard
        anchors { horizontalCenter: parent.horizontalCenter; bottom: parent.bottom; bottomMargin: 5 }

        width: 3*keyWidth+7*(7*keyWidth); height: keyHeight

        WhiteKey { id: whiteKeyA }
        BlackKey { anchor: whiteKeyA }
        WhiteKey { id: whiteKeyB; anchor: whiteKeyA }
        Octave { id: octave1; initialAnchor: whiteKeyB }
        Octave { id: octave2; initialAnchor: octave1 }
        Octave { id: octave3; initialAnchor: octave2 }
        Octave { id: octave4; initialAnchor: octave3 }
        Octave { id: octave5; initialAnchor: octave4 }
        Octave { id: octave6; initialAnchor: octave5 }
        Octave { id: octave7; initialAnchor: octave6 }
        WhiteKey { id: whiteKeyC; anchor: octave7 }
        
        Rectangle {
            width: 3*keyWidth+7*(7*keyWidth); height: 2
            anchors { left: whiteKeyA.left; bottom: whiteKeyA.top }
            color: "#A40E09"
        }
    }
}