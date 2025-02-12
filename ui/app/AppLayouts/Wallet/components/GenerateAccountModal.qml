import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Dialogs 1.3
import "../../../../imports"
import "../../../../shared"
import "../../../../shared/status"

ModalPopup {
    id: popup
    //% "Generate an account"
    title: qsTrId("generate-a-new-account")

    property int marginBetweenInputs: 38
    property string passwordValidationError: ""
    property string accountNameValidationError: ""
    property bool loading: false
    property var onAfterAddAccount: function() {}

    function validate() {
        if (passwordInput.text === "") {
            //% "You need to enter a password"
            passwordValidationError = qsTrId("you-need-to-enter-a-password")
        } else if (passwordInput.text.length < 6) {
            //% "Password needs to be 6 characters or more"
            passwordValidationError = qsTrId("password-needs-to-be-6-characters-or-more")
        } else {
            passwordValidationError = ""
        }

        if (accountNameInput.text === "") {
            //% "You need to enter an account name"
            accountNameValidationError = qsTrId("you-need-to-enter-an-account-name")
        } else {
            accountNameValidationError = ""
        }

        return passwordValidationError === "" && accountNameValidationError === ""
    }

    onOpened: {
        passwordValidationError = "";
        accountNameValidationError = "";
        passwordInput.text = "";
        accountNameInput.text = "";
        accountColorInput.selectedColor = Style.current.accountColors[Math.floor(Math.random() * Style.current.accountColors.length)]
        passwordInput.forceActiveFocus(Qt.MouseFocusReason)
    }

    Input {
        id: passwordInput
        //% "Enter your password…"
        placeholderText: qsTrId("enter-your-password…")
        //% "Password"
        label: qsTrId("password")
        textField.echoMode: TextInput.Password
        validationError: popup.passwordValidationError
    }

    Input {
        id: accountNameInput
        anchors.top: passwordInput.bottom
        anchors.topMargin: marginBetweenInputs
        //% "Enter an account name..."
        placeholderText: qsTrId("enter-an-account-name...")
        //% "Account name"
        label: qsTrId("account-name")
        validationError: popup.accountNameValidationError
    }

    StatusWalletColorSelect {
        id: accountColorInput
        selectedColor: Style.current.accountColors[0]
        anchors.top: accountNameInput.bottom
        anchors.topMargin: marginBetweenInputs
        width: parent.width
    }

    footer: StatusButton {
        anchors.top: parent.top
        anchors.right: parent.right
        text: loading ?
        //% "Loading..."
        qsTrId("loading") :
        //% "Add account"
        qsTrId("add-account")

        enabled: !loading && passwordInput.text !== "" && accountNameInput.text !== ""

        MessageDialog {
            id: accountError
            title: "Adding the account failed"
            icon: StandardIcon.Critical
            standardButtons: StandardButton.Ok
        }

        onClicked : {
            // TODO the loaidng doesn't work because the function freezes th eview. Might need to use threads
            loading = true
            if (!validate()) {
                errorSound.play()
                return loading = false
            }

            const result = walletModel.generateNewAccount(passwordInput.text, accountNameInput.text, accountColorInput.selectedColor)
            loading = false
            if (result) {
                let resultJson = JSON.parse(result);
                errorSound.play();
                if (Utils.isInvalidPasswordMessage(resultJson.error)) {
                    //% "Wrong password"
                    popup.passwordValidationError = qsTrId("wrong-password")
                } else {
                    accountError.text = resultJson.error;
                    accountError.open();
                }
                return
            }
            popup.onAfterAddAccount();
            popup.close();
        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorColor:"#ffffff";height:500;width:400}
}
##^##*/
