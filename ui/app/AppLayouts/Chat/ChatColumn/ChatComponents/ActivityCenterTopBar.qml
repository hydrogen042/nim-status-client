import QtQuick 2.13
import QtQuick.Controls 2.13
import "../../../../../imports"
import "../../../../../shared"
import "../../../../../shared/status"
import ".."
import "../../../Profile/LeftTab/constants.js" as ProfileConstants

Item {
    width: parent.width
    height: 64

    Row {
        id: filterButtons
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: Style.current.padding
        height: allBtn.height
        spacing: Style.current.padding

       StatusButton {
           id: allBtn
           text: qsTr("All")
           type: "secondary"
           size: "small"
           highlighted: activityCenter.currentFilter === ActivityCenter.Filter.All
           onClicked: activityCenter.currentFilter = ActivityCenter.Filter.All
       }

       StatusButton {
           id: mentionsBtn
           text: qsTr("Mentions")
           type: "secondary"
           size: "small"
           highlighted: activityCenter.currentFilter === ActivityCenter.Filter.Mentions
           onClicked: activityCenter.currentFilter = ActivityCenter.Filter.Mentions
       }

       StatusButton {
           id: repliesbtn
           text: qsTr("Replies")
           type: "secondary"
           size: "small"
           highlighted: activityCenter.currentFilter === ActivityCenter.Filter.Replies
           onClicked: activityCenter.currentFilter = ActivityCenter.Filter.Replies
       }

       StatusButton {
           id: contactRequestsBtn
           text: qsTr("Contact requests")
           type: "secondary"
           size: "small"
           highlighted: activityCenter.currentFilter === ActivityCenter.Filter.ContactRequests
           onClicked: activityCenter.currentFilter = ActivityCenter.Filter.ContactRequests
       }
    }

    Row {
        id: otherButtons
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: Style.current.padding
        height: markAllReadBtn.height
        spacing: Style.current.padding

       StatusIconButton {
           id: markAllReadBtn
           icon.name: "double-check"
           iconColor: Style.current.primary
           icon.width: 24
           icon.height: 24
           width: 32
           height: 32
           onClicked: console.log('TODO mark all as read')

           StatusToolTip {
             visible: markAllReadBtn.hovered
             text: qsTr("Mark all as Read")
           }
       }

       StatusContextMenuButton {
           id: moreActionsBtn
           onClicked: moreActionsMenu.open()

           PopupMenu {
               id: moreActionsMenu
               x: moreActionsBtn.width - moreActionsMenu.width
               y: moreActionsBtn.height + 4

               Action {
                   icon.source: "../../../../img/eye-barred.svg"
                   icon.width: 16
                   icon.height: 16
                   text: qsTr("Hide read notifications")
                   onTriggered: console.log('TODO Change settings')
               }
               Action {
                   icon.source: "../../../../img/bell.svg"
                   icon.width: 16
                   icon.height: 16
                   text: qsTr("Notification settings")
                   onTriggered: {
                       activityCenter.close()
                       appMain.changeAppSection(Constants.profile)
                       profileLayoutContainer.changeProfileSection(ProfileConstants.NOTIFICATIONS)
                   }
               }
           }
       }
    }
}
