import QtQuick 2.3
import QtQuick.Controls 1.2
import ".."
import "../../BasicControls"
import "../../BasicLayouts"
import "../../Controls"
import "../../Layouts"
import "../../ObjControls"
import "../../Singletons"

// Change Level
EventCommandBase {
    id: root

    Group_TargetActor {
        id: targetActorGroup
    }

    Group_Operation {
        id: operationGroup
    }

    Group_Operand {
        id: operandGroup
        maximumValue: MaxLevel.maximun - 1 // [OneMaker MV] - Change to use MaxLevel's value
    }

    CheckBox {
        id: checkBox
        text: Constants.showLevelUpText
        hint: Constants.showLevelUpHint
        enabled: operationGroup.operationType === 0
    }

    onLoad: {
        if (eventData) {
            var params = eventData[0].parameters;
            targetActorGroup.setup(params[0], params[1]);
            operationGroup.setup(params[2]);
            operandGroup.setup(params[3], params[4]);
            checkBox.checked = params[5];
        }
    }

    onSave: {
        if (!eventData) {
            makeSimpleEventData();
        }
        var params = eventData[0].parameters;
        params[0] = targetActorGroup.operandType;
        params[1] = targetActorGroup.operandValue;
        params[2] = operationGroup.operationType;
        params[3] = operandGroup.operandType;
        params[4] = operandGroup.operandValue;
        params[5] = checkBox.checked;
    }
}
