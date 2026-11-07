/*
    SPDX-FileCopyrightText: 2026 dgudim <dgudim@gmail.com>

    SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick
import org.kde.kirigami as Kirigami

Rectangle {
    id: root
    color: "#000000"

    property int stage

    onStageChanged: {
        if (stage == 2) {
            introAnimation.running = true;
        } else if (stage == 5) {
            introAnimation.target = busyIndicator;
            introAnimation.from = 1;
            introAnimation.to = 0;
            introAnimation.running = true;
        }
    }

    Item {
        id: content
        anchors.fill: parent
        opacity: 0

        AnimatedImage {
            id: logo
            readonly property real size: 367

            anchors.centerIn: parent

            asynchronous: true
            source: "images/splash.webp"
            paused: false
            width: size
            height: size
            fillMode: Image.PreserveAspectFit
            smooth: false
        }

        // TODO: port to PlasmaComponents3.BusyIndicator
        Image {
            id: busyIndicator
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: footer.top
            anchors.bottomMargin: Kirigami.Units.gridUnit
            asynchronous: true
            source: "images/busywidget.svgz"
            sourceSize.height: Kirigami.Units.gridUnit * 2
            sourceSize.width: Kirigami.Units.gridUnit * 2
            RotationAnimator on rotation {
                id: rotationAnimator
                from: 0
                to: 360
                // Not using a standard duration value because we don't want the
                // animation to spin faster or slower based on the user's animation
                // scaling preferences; it doesn't make sense in this context
                duration: 2000
                loops: Animation.Infinite
                // Don't want it to animate at all if the user has disabled animations
                running: Kirigami.Units.longDuration > 1
            }
        }

        Row {
            id: footer
            spacing: Kirigami.Units.largeSpacing
            anchors {
                bottom: parent.bottom
                horizontalCenter: parent.horizontalCenter
                margins: Kirigami.Units.gridUnit
            }
            Text {
                color: "#e0e8f1"
                anchors.verticalCenter: parent.verticalCenter
                text: "Everyone's Konnected"
                Accessible.name: text
                Accessible.role: Accessible.StaticText
                textFormat: Text.PlainText
            }
            Image {
                asynchronous: true
                source: "images/kde.svgz"
                sourceSize.height: Kirigami.Units.gridUnit * 2
                sourceSize.width: Kirigami.Units.gridUnit * 2
            }
        }
    }

    OpacityAnimator {
        id: introAnimation
        running: false
        target: content
        from: 0
        to: 1
        duration: Kirigami.Units.veryLongDuration * 2
        easing.type: Easing.InOutQuad
    }
}
