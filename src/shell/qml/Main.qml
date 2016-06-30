/****************************************************************************
**
** Copyright (C) 2016 by Sandro S. Andrade <sandroandrade@kde.org>
**
** This program is free software; you can redistribute it and/or
** modify it under the terms of the GNU General Public License as
** published by the Free Software Foundation; either version 2 of
** the License or (at your option) version 3 or any later version
** accepted by the membership of KDE e.V. (or its successor approved
** by the membership of KDE e.V.), which shall act as a proxy 
** defined in Section 14 of version 3 of the license.
**
** This program is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with this program.  If not, see <http://www.gnu.org/licenses/>.
**
****************************************************************************/

import QtQuick 2.4

import "pianoview"
import "midiplayer"

Item {
    id: mainItem

    property int menuBarWidth: 280

    function userMessageChanged(message) {
        pianoView.visible = (message != "the rhythm" && message != "exercise")
        rhythmAnswerView.visible = (message == "the rhythm")
    }
    function exerciseViewStateChanged() {
        if (exerciseView.state == "waitingForAnswer")
            rhythmAnswerView.resetAnswers()
    }

    MinuetMenu {
        id: minuetMenu

        width: menuBarWidth; height: parent.height - midiPlayer.height
        anchors { left: parent.left; top: parent.top }
    }
    MidiPlayer {
        id: midiPlayer
        
        width: menuBarWidth
    }
    Image {
        id: background

        width: parent.width - menuBarWidth; height: parent.height
        anchors.right: parent.right
        source: "images/minuet-background.png"
        fillMode: Image.Tile
        clip: true

        PianoView {
            id: pianoView

            anchors { bottom: parent.bottom; bottomMargin: 5; horizontalCenter: parent.horizontalCenter }
            visible: false
        }
        RhythmAnswerView {
            id: rhythmAnswerView
            
            anchors { bottom: parent.bottom; bottomMargin: 14; horizontalCenter: parent.horizontalCenter }
            visible: false
            exerciseView: exerciseView
        }
        ExerciseView {
            id: exerciseView
            
            width: background.width; height: minuetMenu.height + 20
            anchors { top: background.top; horizontalCenter: background.horizontalCenter }
        }
    }
    Binding {
        target: core.soundBackend
        property: "pitch"
        value: midiPlayer.pitch
    }
    Binding {
        target: core.soundBackend
        property: "volume"
        value: midiPlayer.volume
    }
    Binding {
        target: core.soundBackend
        property: "tempo"
        value: midiPlayer.tempo
    }
    Binding {
        target: midiPlayer
        property: "playbackLabel"
        value: core.soundBackend.playbackLabel
    }
    Binding {
        target: midiPlayer
        property: "sequencerState"
        value: core.soundBackend.state
    }
    Connections {
        target: midiPlayer
        onPlayActivated: core.soundBackend.play()
        onPauseActivated: core.soundBackend.pause()
        onStopActivated: core.soundBackend.stop()
    }
//    Connections {
//        target: sequencer
//        onNoteOn: pianoView.noteOn(chan, pitch, vel)
//        onNoteOff: pianoView.noteOff(chan, pitch, vel)
//        onAllNotesOff: pianoView.allNotesOff()
//    }
    Connections {
        target: minuetMenu
        onItemChanged: exerciseView.itemChanged(model)
        onBreadcrumbPressed: exerciseView.clearExerciseGrid()
        onUserMessageChanged: exerciseView.changeUserMessage(message)
    }
    Connections {
        target: minuetMenu
        onItemChanged: rhythmAnswerView.resetAnswers(model)
        onBreadcrumbPressed: rhythmAnswerView.resetAnswers()
        onUserMessageChanged: mainItem.userMessageChanged(message)
    }
    Connections {
        target: exerciseView
        onAnswerHoverEnter: pianoView.noteMark(chan, pitch, vel, color)
        onAnswerHoverExit: pianoView.noteUnmark(chan, pitch, vel)
        onAnswerClicked: rhythmAnswerView.answerClicked(answerImageSource, color)
        onStateChanged: mainItem.exerciseViewStateChanged()
        onShowCorrectAnswer: rhythmAnswerView.showCorrectAnswer(chosenExercises, chosenColors)
        onChosenExercisesChanged: rhythmAnswerView.fillCorrectAnswerGrid()
    }
    Connections {
        target: rhythmAnswerView
        onAnswerCompleted: exerciseView.checkAnswers(answers)
    }
}
