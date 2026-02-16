import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import qs.Common
import qs.Services
import qs.Widgets
import qs.Modules.Plugins

PluginComponent {
    id: root

    layerNamespacePlugin: "volume-mixer"

    // DMS/Quickshell sessions can have a minimal PATH, especially on NixOS.
    // Using the absolute path avoids "wpctl not found" issues.
    property string wpctlBin: "/run/current-system/sw/bin/wpctl"

    property int defaultSinkId: -1
    property string defaultSinkName: "Default Output"
    property real defaultSinkVolume: -1
    property string defaultSinkStatus: "Loading…"

    ListModel {
        id: streamsModel
    }

    property var pendingVolumes: ({})
    property var pendingInspects: ({})
    property var latestSeenStreams: ({})
    property string statusMessage: "Loading…"

    property var pendingDefaultSinkVolume: null

    function clamp(value, minValue, maxValue) {
        return Math.max(minValue, Math.min(maxValue, value))
    }

    function findStreamIndex(streamId) {
        for (var i = 0; i < streamsModel.count; i++) {
            if (streamsModel.get(i).streamId === streamId) {
                return i
            }
        }
        return -1
    }

    function setStatusFromStreams() {
        if (streamsModel.count === 0)
            statusMessage = statusMessage && statusMessage.length > 0 ? statusMessage : "No active audio streams"
        else
            statusMessage = ""
    }

    function parseStreamsFromWpctlStatus(output) {
        const lines = output.split("\n")

        let inStreams = false
        const streams = []

        for (let i = 0; i < lines.length; i++) {
            const line = lines[i]
            const trimmed = line.trim()

            // Be tolerant: wpctl prints box-drawing prefixes that can vary.
            if (!inStreams && (trimmed === "Streams:" || line.indexOf("Streams:") !== -1)) {
                inStreams = true
                continue
            }

            if (!inStreams)
                continue

            if (trimmed.length === 0)
                continue

            // End of Audio section.
            if (trimmed === "Video" || trimmed === "Settings")
                break

            const idMatch = line.match(/^(\s*)(\d+)\.\s+(.+?)\s*$/)
            if (!idMatch)
                continue

            const indent = idMatch[1].length
            const streamId = parseInt(idMatch[2], 10)
            const name = idMatch[3]

            // Only include top-level stream nodes, not their port lines.
            // On current wpctl output top-level streams are indented ~8 spaces.
            if (indent > 9)
                continue

            // Skip port lines and internal routing entries.
            if (name.indexOf("<") !== -1 || name.indexOf(">") !== -1)
                continue
            if (name.startsWith("output_") || name.startsWith("input_"))
                continue

            streams.push({ streamId, name })
        }

        return streams
    }

    function refreshStreams() {
        statusMessage = "Loading…"
        const proc = statusProcessComponent.createObject(root, {})
        proc.running = true
    }

    function refreshDefaultSink() {
        defaultSinkStatus = "Loading…"
        const p1 = defaultSinkInspectProcessComponent.createObject(root, {})
        p1.running = true
        const p2 = defaultSinkVolumeProcessComponent.createObject(root, {})
        p2.running = true
    }

    function refreshVolumeForStream(streamId) {
        const proc = volumeProcessComponent.createObject(root, { streamId: streamId })
        proc.running = true
    }

    function refreshDetailsForStream(streamId, streamName) {
        const proc = inspectProcessComponent.createObject(root, { streamId: streamId, streamName: streamName || "" })
        proc.running = true
    }

    function scheduleSetVolume(streamId, volume) {
        const clamped = clamp(volume, 0.0, 1.5)
        const hadPending = pendingVolumes.hasOwnProperty(streamId)
        pendingVolumes[streamId] = clamped

        const idx = findStreamIndex(streamId)
        if (idx !== -1)
            streamsModel.setProperty(idx, "volume", clamped)

        // Apply first change immediately to feel snappy, then coalesce further moves.
        if (!hadPending) {
            Quickshell.execDetached([root.wpctlBin, "set-volume", streamId.toString(), clamped.toFixed(3)])
        }

        volumeFlushTimer.restart()
    }

    function scheduleSetDefaultSinkVolume(volume) {
        const clamped = clamp(volume, 0.0, 1.5)
        const hadPending = pendingDefaultSinkVolume !== null
        pendingDefaultSinkVolume = clamped
        defaultSinkVolume = clamped

        // Same snappy behavior for master volume.
        if (!hadPending) {
            Quickshell.execDetached([root.wpctlBin, "set-volume", "@DEFAULT_AUDIO_SINK@", clamped.toFixed(3)])
        }

        defaultSinkFlushTimer.restart()
    }

    function flushPendingVolumes() {
        const keys = Object.keys(pendingVolumes)
        if (keys.length === 0)
            return

        const toFlush = pendingVolumes
        pendingVolumes = ({})

        for (let i = 0; i < keys.length; i++) {
            const streamId = keys[i]
            const volume = clamp(toFlush[streamId], 0.0, 1.5)
            Quickshell.execDetached([root.wpctlBin, "set-volume", streamId.toString(), volume.toFixed(2)])
        }
    }

    Timer {
        id: volumeFlushTimer
        interval: 80
        repeat: false
        running: false
        onTriggered: root.flushPendingVolumes()
    }

    Timer {
        id: defaultSinkFlushTimer
        interval: 80
        repeat: false
        running: false
        onTriggered: {
            if (pendingDefaultSinkVolume === null)
                return
            const volume = clamp(pendingDefaultSinkVolume, 0.0, 1.5)
            pendingDefaultSinkVolume = null
            Quickshell.execDetached([root.wpctlBin, "set-volume", "@DEFAULT_AUDIO_SINK@", volume.toFixed(2)])
        }
    }

    Component {
        id: statusProcessComponent

        Process {
            id: statusProc
            property var lines: ([])

            command: [root.wpctlBin, "status"]

            stdout: SplitParser {
                onRead: line => {
                    // Preserve raw lines; parsing happens on exit.
                    statusProc.lines.push(line)
                }
            }

            stderr: SplitParser {
                onRead: line => {
                    if (line.trim().length > 0)
                        console.warn("volumeMixer: wpctl status stderr:", line)
                }
            }

            onExited: exitCode => {
                if (exitCode !== 0) {
                    root.statusMessage = "Failed to read streams (wpctl exit " + exitCode + ")"
                    ToastService.showError("Volume Mixer", "Failed to read streams")
                    destroy()
                    return
                }

                const output = lines.join("\n")
                const streams = root.parseStreamsFromWpctlStatus(output)

                root.latestSeenStreams = ({})

                root.statusMessage = streams.length === 0 ? "No active audio streams" : ""

                const seen = ({})
                for (let i = 0; i < streams.length; i++) {
                    const streamId = streams[i].streamId
                    seen[streamId] = true
                    root.latestSeenStreams[streamId] = true

                    const idx = root.findStreamIndex(streamId)
                    if (idx === -1) {
                        // Avoid flicker from non-app/capture/ports: only append after inspect validates.
                        if (!root.pendingInspects[streamId]) {
                            root.pendingInspects[streamId] = streams[i].name
                            root.refreshDetailsForStream(streamId, streams[i].name)
                        }
                    } else {
                        streamsModel.setProperty(idx, "streamName", streams[i].name)

                        // Only refresh volume for entries we already validated.
                        // This avoids briefly showing irrelevant sources.
                        if (streamsModel.get(idx).inspected)
                            root.refreshVolumeForStream(streamId)

                        if (!streamsModel.get(idx).inspected)
                            root.refreshDetailsForStream(streamId, streams[i].name)
                    }
                }

                // Remove streams that no longer exist.
                for (let j = streamsModel.count - 1; j >= 0; j--) {
                    const idToCheck = streamsModel.get(j).streamId
                    if (!seen[idToCheck])
                        streamsModel.remove(j)
                }

                // If we saw streams but haven't validated any yet, keep a loading hint.
                if (streams.length > 0 && streamsModel.count === 0)
                    root.statusMessage = "Loading…"

                destroy()
            }
        }
    }

    Component {
        id: inspectProcessComponent

        Process {
            id: inspectProc
            property int streamId: -1
            property string streamName: ""
            property var lines: ([])

            command: [root.wpctlBin, "inspect", streamId.toString()]

            stdout: SplitParser {
                onRead: line => {
                    inspectProc.lines.push(line)
                }
            }

            stderr: SplitParser {
                onRead: line => {
                    if (line.trim().length > 0)
                        console.warn("volumeMixer: wpctl inspect stderr:", line)
                }
            }

            onExited: exitCode => {
                if (root.pendingInspects && root.pendingInspects[streamId])
                    delete root.pendingInspects[streamId]

                var streamIndex = root.findStreamIndex(streamId)

                if (exitCode !== 0) {
                    if (streamIndex !== -1)
                        streamsModel.remove(streamIndex)
                    root.setStatusFromStreams()
                    destroy()
                    return
                }

                const text = lines.join("\n")
                const header = (lines.length > 0 ? lines[0] : "")

                // Filter out ports/other objects (we only want Node streams).
                if (header.indexOf("Interface:Node") === -1) {
                    if (streamIndex !== -1)
                        streamsModel.remove(streamIndex)
                    root.setStatusFromStreams()
                    destroy()
                    return
                }

                let appName = ""
                let iconName = ""
                let mediaClass = ""

                const appNameMatch = text.match(/application\.name\s*=\s*"([^"]+)"/)
                if (appNameMatch)
                    appName = appNameMatch[1]

                const iconMatch = text.match(/application\.icon-name\s*=\s*"([^"]+)"/)
                if (iconMatch)
                    iconName = iconMatch[1]

                const mediaMatch = text.match(/media\.class\s*=\s*"([^"]+)"/)
                if (mediaMatch)
                    mediaClass = mediaMatch[1]

                // Only keep actual playback streams.
                if (mediaClass !== "Stream/Output/Audio") {
                    if (streamIndex !== -1)
                        streamsModel.remove(streamIndex)
                    root.setStatusFromStreams()
                    destroy()
                    return
                }

                // Only show real applications (PipeWire ports/capture streams won't have application.name).
                if (!appName || appName.length === 0) {
                    if (streamIndex !== -1)
                        streamsModel.remove(streamIndex)
                    root.setStatusFromStreams()
                    destroy()
                    return
                }

                // Stream may have disappeared since status was captured.
                if (!root.latestSeenStreams || !root.latestSeenStreams[streamId]) {
                    if (streamIndex !== -1)
                        streamsModel.remove(streamIndex)
                    root.setStatusFromStreams()
                    destroy()
                    return
                }

                if (streamIndex === -1) {
                    streamsModel.append({
                        streamId: streamId,
                        streamName: streamName && streamName.length > 0 ? streamName : appName,
                        appName: appName,
                        iconName: iconName,
                        mediaClass: mediaClass,
                        inspected: true,
                        volume: -1
                    })
                    streamIndex = root.findStreamIndex(streamId)
                } else {
                    streamsModel.setProperty(streamIndex, "appName", appName)
                    streamsModel.setProperty(streamIndex, "iconName", iconName)
                    streamsModel.setProperty(streamIndex, "mediaClass", mediaClass)
                    streamsModel.setProperty(streamIndex, "inspected", true)
                }

                root.refreshVolumeForStream(streamId)
                destroy()
            }
        }
    }

    Component {
        id: volumeProcessComponent

        Process {
            id: volumeProc
            property int streamId: -1
            property string lastLine: ""
            property string lastError: ""

            command: [root.wpctlBin, "get-volume", streamId.toString()]

            stdout: SplitParser {
                onRead: line => {
                    if (line.trim().length > 0)
                        volumeProc.lastLine = line
                }
            }

            stderr: SplitParser {
                onRead: line => {
                    if (line.trim().length > 0)
                        volumeProc.lastError = line
                }
            }

            onExited: exitCode => {
                var streamIndex = root.findStreamIndex(streamId)
                if (streamIndex === -1) {
                    destroy()
                    return
                }

                if (exitCode !== 0 || (lastError && lastError.length > 0)) {
                    // Remove entries that are not real nodes (wpctl prints errors for ports).
                    streamsModel.remove(streamIndex)
                    root.setStatusFromStreams()
                    destroy()
                    return
                }

                const match = lastLine.match(/Volume:\s*([0-9.]+)/)
                if (!match) {
                    // If it can't be parsed, drop it to avoid permanent "Loading" entries.
                    streamsModel.remove(streamIndex)
                    root.setStatusFromStreams()
                    destroy()
                    return
                }

                const volume = parseFloat(match[1])
                streamsModel.setProperty(streamIndex, "volume", volume)

                destroy()
            }
        }
    }

    Component {
        id: defaultSinkInspectProcessComponent

        Process {
            id: sinkInspectProc
            property var lines: ([])

            command: [root.wpctlBin, "inspect", "@DEFAULT_AUDIO_SINK@"]

            stdout: SplitParser {
                onRead: line => sinkInspectProc.lines.push(line)
            }

            onExited: exitCode => {
                if (exitCode !== 0) {
                    root.defaultSinkStatus = "Default output unavailable"
                    destroy()
                    return
                }

                const text = lines.join("\n")
                const descMatch = text.match(/\*\s*node\.description\s*=\s*"([^"]+)"/)
                if (descMatch)
                    root.defaultSinkName = descMatch[1]

                destroy()
            }
        }
    }

    Component {
        id: defaultSinkVolumeProcessComponent

        Process {
            id: sinkVolProc
            property string lastLine: ""

            command: [root.wpctlBin, "get-volume", "@DEFAULT_AUDIO_SINK@"]

            stdout: SplitParser {
                onRead: line => {
                    if (line.trim().length > 0)
                        sinkVolProc.lastLine = line
                }
            }

            onExited: exitCode => {
                if (exitCode !== 0) {
                    root.defaultSinkStatus = "Default output unavailable"
                    destroy()
                    return
                }

                const match = lastLine.match(/Volume:\s*([0-9.]+)/)
                if (match) {
                    root.defaultSinkVolume = parseFloat(match[1])
                    root.defaultSinkStatus = ""
                }
                destroy()
            }
        }
    }

    horizontalBarPill: Component {
        Row {
            spacing: Theme.spacingXS
            DankIcon {
                name: "volume_up"
                size: root.iconSize
                color: Theme.primary
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    verticalBarPill: Component {
        Column {
            spacing: Theme.spacingXS
            DankIcon {
                name: "volume_up"
                size: root.iconSize
                color: Theme.primary
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }

    popoutContent: Component {
        PopoutComponent {
            id: popout
            headerText: "Volume Mixer"
            detailsText: "Adjust app volumes"
            showCloseButton: true

            Component.onCompleted: {
                root.refreshDefaultSink()
                root.refreshStreams()
            }

            Timer {
                interval: 2000
                repeat: true
                running: true
                onTriggered: {
                    root.refreshDefaultSink()
                    root.refreshStreams()
                }
            }

            Item {
                width: parent.width
                // Ensure the body area always has height; some DMS versions may not
                // expose headerHeight/detailsHeight reliably for calculations.
                implicitHeight: 440

                Column {
                    anchors.fill: parent
                    anchors.margins: Theme.spacingS
                    spacing: Theme.spacingS

                    StyledRect {
                        id: masterCard
                        width: parent.width
                        radius: Theme.cornerRadius
                        color: Theme.surfaceContainerHigh
                        implicitHeight: masterColumn.implicitHeight + Theme.spacingS * 2

                        Column {
                            id: masterColumn
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.margins: Theme.spacingS
                            spacing: Theme.spacingS

                            Item {
                                width: 1
                                height: Theme.spacingM
                            }

                            Row {
                                width: parent.width
                                spacing: Theme.spacingS

                                DankIcon {
                                    name: "volume_up"
                                    size: Theme.iconSizeSmall
                                    color: Theme.surfaceVariantText
                                    anchors.verticalCenter: parent.verticalCenter
                                }

                                StyledText {
                                    text: root.defaultSinkName
                                    color: Theme.surfaceText
                                    font.pixelSize: Theme.fontSizeMedium
                                    elide: Text.ElideRight
                                    width: parent.width - Theme.iconSizeSmall - Theme.spacingS
                                }
                            }

                            Row {
                                width: parent.width
                                spacing: Theme.spacingS

                                DankSlider {
                                    id: masterSlider
                                    width: parent.width - masterPercentText.implicitWidth - Theme.spacingS
                                    height: 40

                                    enabled: root.defaultSinkVolume >= 0
                                    wheelEnabled: false
                                    minimum: 0
                                    maximum: 150
                                    value: root.defaultSinkVolume >= 0 ? Math.min(150, Math.round(root.defaultSinkVolume * 100)) : 0
                                    step: 1

                                    showValue: true
                                    unit: "%"
                                    thumbOutlineColor: Theme.surfaceVariant
                                    trackColor: Theme.outlineVariant

                                    onSliderValueChanged: function (newValue) {
                                        root.scheduleSetDefaultSinkVolume(newValue / 100.0)
                                    }
                                }

                                StyledText {
                                    id: masterPercentText
                                    text: root.defaultSinkVolume >= 0 ? (Math.round(root.defaultSinkVolume * 100) + "%") : root.defaultSinkStatus
                                    color: Theme.surfaceVariantText
                                    font.pixelSize: Theme.fontSizeSmall
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }
                        }
                    }

                    Item {
                        width: parent.width
                        height: Theme.spacingM
                    }

                    StyledText {
                        width: parent.width
                        text: "Applications"
                        color: Theme.surfaceVariantText
                        font.pixelSize: Theme.fontSizeSmall
                    }

                    Item {
                        width: parent.width
                        // Fill the remaining space.
                        implicitHeight: Math.max(0, parent.height - masterCard.implicitHeight - (Theme.spacingS * 2) - Theme.spacingM)

                        ListView {
                            visible: streamsModel.count > 0
                            anchors.fill: parent
                            anchors.bottomMargin: Theme.spacingM * 2
                            model: streamsModel
                            spacing: Theme.spacingS
                            clip: true

                            delegate: StyledRect {
                                required property int streamId
                                required property string streamName
                                required property string appName
                                required property string iconName
                                required property real volume

                                width: ListView.view.width
                                radius: Theme.cornerRadius
                                color: Theme.surfaceContainerHigh

                                implicitHeight: contentColumn.implicitHeight + Theme.spacingS * 2

                                Column {
                                    id: contentColumn
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.margins: Theme.spacingS
                                    spacing: Theme.spacingXS

                                    Item {
                                        width: 1
                                        height: Theme.spacingM
                                    }

                                    Row {
                                        width: parent.width
                                        spacing: Theme.spacingS

                                        Item {
                                            width: Theme.iconSizeSmall
                                            height: Theme.iconSizeSmall

                                            Image {
                                                id: appIconImage
                                                anchors.fill: parent
                                                source: iconName && iconName.length > 0 ? ("image://icon/" + iconName) : ""
                                                fillMode: Image.PreserveAspectFit
                                                visible: source !== "" && status === Image.Ready
                                            }

                                            DankIcon {
                                                anchors.centerIn: parent
                                                name: "apps"
                                                size: Theme.iconSizeSmall
                                                color: Theme.surfaceVariantText
                                                visible: !appIconImage.visible
                                            }
                                        }

                                        StyledText {
                                            text: (appName && appName.length > 0) ? appName : streamName
                                            color: Theme.surfaceText
                                            font.pixelSize: Theme.fontSizeMedium
                                            elide: Text.ElideRight
                                            width: parent.width - Theme.iconSizeSmall - Theme.spacingS
                                        }
                                    }

                                    Row {
                                        width: parent.width
                                        spacing: Theme.spacingS

                                        DankSlider {
                                            id: streamSlider
                                            width: parent.width - percentText.implicitWidth - Theme.spacingS
                                            height: 40

                                            enabled: volume >= 0
                                            wheelEnabled: false
                                            minimum: 0
                                            maximum: 150
                                            value: volume >= 0 ? Math.min(150, Math.round(volume * 100)) : 0
                                            step: 1

                                            showValue: true
                                            unit: "%"
                                            thumbOutlineColor: Theme.surfaceVariant
                                            trackColor: Theme.outlineVariant

                                            onSliderValueChanged: function (newValue) {
                                                root.scheduleSetVolume(streamId, newValue / 100.0)
                                            }
                                        }

                                        StyledText {
                                            id: percentText
                                            text: volume >= 0 ? (Math.round(volume * 100) + "%") : "…"
                                            color: Theme.surfaceVariantText
                                            font.pixelSize: Theme.fontSizeSmall
                                            anchors.verticalCenter: parent.verticalCenter
                                        }
                                    }
                                }
                            }
                        }

                        StyledText {
                            anchors.centerIn: parent
                            visible: streamsModel.count === 0
                            text: root.statusMessage
                            color: Theme.surfaceVariantText
                            font.pixelSize: Theme.fontSizeMedium
                        }
                    }
                }
            }
        }
    }

    popoutWidth: 420
    popoutHeight: 640
}
