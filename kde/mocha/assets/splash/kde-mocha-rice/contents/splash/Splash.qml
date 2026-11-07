/*
    Tela de inicialização do kde-mocha-rice.
    Wallpaper desfocado ao fundo, lua que acende, saudação conforme a hora
    e uma barra de progresso na cor de destaque que acompanha o carregamento.
    SPDX-License-Identifier: GPL-3.0-or-later
*/
import QtQuick

Rectangle {
    id: root
    color: "#11111b"

    property int stage: 0
    readonly property color destaque: "#cba6f7"
    readonly property color destaque2: "#f5c2e7"
    readonly property color texto: "#cdd6f4"
    readonly property color subtexto: "#7f849c"

    function saudacao() {
        var h = new Date().getHours();
        if (h < 5) return "Boa madrugada";
        if (h < 12) return "Bom dia";
        if (h < 18) return "Boa tarde";
        return "Boa noite";
    }

    onStageChanged: {
        if (stage == 1) entrada.start();
        if (stage >= 6) saida.start();
    }
    Component.onCompleted: entrada.start()

    // ---------------------------------------------------------------- fundo
    Image {
        id: fundo
        anchors.fill: parent
        source: "images/fundo.jpg"
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        opacity: 0
        scale: 1.08
        smooth: true
    }
    Rectangle {   // escurece e esfria o fundo para o texto respirar
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#cc11111b" }
            GradientStop { position: 0.6; color: "#9911111b" }
            GradientStop { position: 1.0; color: "#e611111b" }
        }
    }

    // ---------------------------------------------------------------- centro
    Item {
        id: centro
        anchors.centerIn: parent
        width: 420
        height: 300
        opacity: 0

        // brilho atrás da lua
        Rectangle {
            id: halo
            width: 190; height: 190; radius: width / 2
            anchors.horizontalCenter: parent.horizontalCenter
            y: 0
            color: root.destaque
            opacity: 0.10
            SequentialAnimation on opacity {
                loops: Animation.Infinite
                NumberAnimation { to: 0.22; duration: 1600; easing.type: Easing.InOutSine }
                NumberAnimation { to: 0.08; duration: 1600; easing.type: Easing.InOutSine }
            }
            SequentialAnimation on scale {
                loops: Animation.Infinite
                NumberAnimation { to: 1.12; duration: 1600; easing.type: Easing.InOutSine }
                NumberAnimation { to: 0.95; duration: 1600; easing.type: Easing.InOutSine }
            }
        }

        Image {
            id: lua
            source: "images/lua.svg"
            sourceSize.width: 120
            sourceSize.height: 120
            anchors.centerIn: halo
            smooth: true
            RotationAnimator on rotation {
                from: -8; to: 8; duration: 3200
                loops: Animation.Infinite
                easing.type: Easing.InOutSine
                running: true
            }
        }

        Text {
            id: ola
            anchors.horizontalCenter: parent.horizontalCenter
            y: halo.y + halo.height + 22
            text: root.saudacao()
            color: root.texto
            font.family: "Inter"
            font.pixelSize: 30
            font.weight: Font.DemiBold
            font.letterSpacing: 0.5
        }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: ola.bottom
            anchors.topMargin: 6
            text: "preparando seu espaço…"
            color: root.subtexto
            font.family: "Inter"
            font.pixelSize: 15
        }

        // barra de progresso
        Rectangle {
            id: trilho
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            width: 220; height: 4; radius: 2
            color: "#313244"
            Rectangle {
                id: barra
                height: parent.height; radius: 2
                width: parent.width * Math.min(root.stage, 6) / 6
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0.0; color: root.destaque }
                    GradientStop { position: 1.0; color: root.destaque2 }
                }
                Behavior on width { NumberAnimation { duration: 600; easing.type: Easing.OutCubic } }
            }
        }
    }

    // ---------------------------------------------------------------- animações
    ParallelAnimation {
        id: entrada
        NumberAnimation { target: fundo; property: "opacity"; to: 1; duration: 900; easing.type: Easing.OutCubic }
        NumberAnimation { target: fundo; property: "scale"; to: 1.0; duration: 2600; easing.type: Easing.OutCubic }
        SequentialAnimation {
            PauseAnimation { duration: 250 }
            ParallelAnimation {
                NumberAnimation { target: centro; property: "opacity"; to: 1; duration: 700; easing.type: Easing.OutCubic }
                NumberAnimation { target: centro; property: "anchors.verticalCenterOffset"; from: 24; to: 0; duration: 800; easing.type: Easing.OutBack }
            }
        }
    }
    ParallelAnimation {
        id: saida
        NumberAnimation { target: centro; property: "opacity"; to: 0; duration: 350 }
        NumberAnimation { target: centro; property: "scale"; to: 0.94; duration: 350 }
    }
}
