import QtQuick 2.15

Item {
    id:content
    anchors.fill: parent

    property alias dialogs: _dialogs

    Dialogs{
        id:_dialogs

    }

}
