codeunit 50111 "Ext. Workflow Event Handling"
{
    Permissions = tabledata 454 = rm;

    VAR
        WorkflowManagement: Codeunit "Workflow Management";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        ItemJournalBatchSendForApprovalEventDescTxt: TextConst ENU = 'Approval of a Physical Inv Journal batch is requested.';
        ItemJournalBatchApprovalRequestCancelEventDescTxt: TextConst ENU = 'An approval request for a Physical Inv Journal batch is canceled.';
        ItemJournalLineSendForApprovalEventDescTxt: TextConst ENU = 'Approval of a Physical Inv Journal is requested.';
        ItemJournalLineApprovalRequestCancelEventDescTxt: TextConst ENU = 'An approval request for a Physical Inv Journal is canceled.';
        ItemJournalApproveText: TextConst ENU = 'Approval Request For Physical Inv Journal is Approved';
        ItemJournalRejectText: TextConst ENU = 'Approval Request For Physical Inv Journal is Rejected';
        ItemJournalApproveIJLText: TextConst ENU = 'Approval Request For Physical Inv Journal Line is Approved';
        ItemJournalRejectIJLText: TextConst ENU = 'Approval Request For Physical Inv Journal Line is Rejected';
        SendForPendAppItemJnlText: TextConst ENU = 'Physical Inv Journal Status changed to Pending approval';
        CancelItemJnlText: TextConst ENU = 'Physical Inv Journal Approval Rquest is Canceled';
        ReleaseItemJnlText: TextConst ENU = 'Physical Inv Journal Release Journal';
        ReOpenItemJnlText: TextConst ENU = 'Physical Inv Journal Reopen Journal';

        //Warehouse Physical Inventory journal
        WarehouseJournalBatchSendForApprovalEventDescTxt: TextConst ENU = 'Approval of a Warehouse Physical Inv Journal batch is requested.';
        WarehouseJournalBatchApprovalRequestCancelEventDescTxt: TextConst ENU = 'An approval request for a Warehouse Physical Inv Journal batch is canceled.';
        WarehouseJournalLineSendForApprovalEventDescTxt: TextConst ENU = 'Approval of a Warehouse Physical Inv Journal is requested.';
        WarehouseJournalLineApprovalRequestCancelEventDescTxt: TextConst ENU = 'An approval request for a Warehouse Physical Inv Journal is canceled.';
        WarehouseJournalApproveText: TextConst ENU = 'Approval Request For Warehouse Physical Inv Journal is Approved';
        WarehouseJournalRejectText: TextConst ENU = 'Approval Request For Warehouse Physical Inv Journal is Rejected';
        WarehouseJournalApproveIJLText: TextConst ENU = 'Approval Request For Warehouse Physical Inv Journal Line is Approved';
        WarehouseJournalRejectIJLText: TextConst ENU = 'Approval Request For Warehouse Physical Inv Journal Line is Rejected';
        SendForPendAppWarehouseJnlText: TextConst ENU = 'Warehouse Physical Inv Journal Status changed to Pending approval';
        CancelWarehouseJnlText: TextConst ENU = 'Warehouse Physical Inv Journal Approval Rquest is Canceled';
        ReOpenWarehouseJnlText: TextConst ENU = 'Warehouse Physical Inv Journal Reopen Journal';

    PROCEDURE RunWorkflowOnSendItemJournalBatchForApprovalCode(): Code[128];
    BEGIN
        EXIT(UPPERCASE('RunWorkflowOnSendItemJournalBatchForApproval'));
    END;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Extend Approvals Mgmt.", 'OnSendItemlJournalBatchForApproval', '', FALSE, FALSE)]
    PROCEDURE RunWorkflowOnSendItemJournalBatchForApproval(var ItemJournalBatch: Record "Item Journal Batch")
    BEGIN
        WorkflowManagement.HandleEvent(RunWorkflowOnSendItemJournalBatchForApprovalCode(), ItemJournalBatch);
    END;


    PROCEDURE RunWorkflowOnCancelItemJournalBatchApprovalRequestCode(): Code[128];
    BEGIN
        EXIT(UPPERCASE('RunWorkflowOnCancelItemJournalBatchApprovalRequest'));
    END;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Extend Approvals Mgmt.", 'OnCancelItemJournalBatchApprovalRequest', '', FALSE, FALSE)]
    PROCEDURE RunWorkflowOnCancelItemJournalBatchApprovalRequest(var ItemJournalBatch: Record "Item Journal Batch")
    BEGIN
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelItemJournalBatchApprovalRequestCode(), ItemJournalBatch);
    END;


    PROCEDURE RunWorkflowOnSendItemJournalLineForApprovalCode(): Code[128];
    BEGIN
        EXIT(UPPERCASE('RunWorkflowOnSendItemJournalLineForApproval'));
    END;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Extend Approvals Mgmt.", 'OnSendItemlJournalLineForApproval', '', FALSE, FALSE)]
    PROCEDURE RunWorkflowOnSendItemJournalLineForApproval(var ItemJournalLine: Record "Item Journal Line")
    BEGIN
        WorkflowManagement.HandleEvent(RunWorkflowOnSendItemJournalLineForApprovalCode(), ItemJournalLine);
    END;


    PROCEDURE RunWorkflowOnCancelItemJournalLineApprovalRequestCode(): Code[128];
    BEGIN
        EXIT(UPPERCASE('RunWorkflowOnCancelItemJournalLineApprovalRequest'));
    END;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Extend Approvals Mgmt.", 'OnCancelItemJournalLineApprovalRequest', '', FALSE, FALSE)]
    PROCEDURE RunWorkflowOnCancelItemJournalLineApprovalRequest(var ItemJournalLine: Record "Item Journal Line")
    BEGIN
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelItemJournalLineApprovalRequestCode(), ItemJournalLine);
    END;

    //Approve
    PROCEDURE RunWorkflowOnApproveItemJnlBatchCode(): Code[128]
    BEGIN
        EXIT(UpperCase('RunWorkflowOnApproveItemJnlBatch'))
    END;

    PROCEDURE RunWorkflowOnApproveItemJnlLineCode(): Code[128]
    BEGIN
        EXIT(UpperCase('RunWorkflowOnApproveItemJnlLine'))
    END;

    PROCEDURE RunWorkflowOnRejectItemJnlBatchCode(): Code[128]
    BEGIN
        EXIT(UpperCase('RunWorkflowOnRejectItemJnlBatch'))
    END;

    PROCEDURE RunWorkflowOnRejectItemJnlLineCode(): Code[128]
    BEGIN
        EXIT(UpperCase('RunWorkflowOnRejectItemJnlLine'))
    END;

    PROCEDURE SetStatusToPendingApprovalCodeItemJnl(): Code[128]
    BEGIN
        EXIT(UpperCase('SetStatusToPendingApprovalItemJnl'));
    END;

    PROCEDURE ReopenItemJnlCode(): Code[128]
    BEGIN
        EXIT(UpperCase('ReopenItemJnl'));
    END;

    //Warehouse Physical Inventory Journal Workflow
    PROCEDURE RunWorkflowOnSendWarehouseJournalBatchForApprovalCode(): Code[128];
    BEGIN
        EXIT(UPPERCASE('RunWorkflowOnSendWarehouseJournalBatchForApproval'));
    END;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Extend Approvals Mgmt.", 'OnSendwarehouseJournalBatchForApproval', '', FALSE, FALSE)]
    PROCEDURE RunWorkflowOnSendWarehouseJournalBatchForApproval(var WarehouseJournalBatch: Record "Warehouse Journal Batch")
    BEGIN
        WorkflowManagement.HandleEvent(RunWorkflowOnSendWarehouseJournalBatchForApprovalCode(), WarehouseJournalBatch);
    END;


    PROCEDURE RunWorkflowOnCancelWarehouseJournalBatchApprovalRequestCode(): Code[128];
    BEGIN
        EXIT(UPPERCASE('RunWorkflowOnCancelWarehouseJournalBatchApprovalRequest'));
    END;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Extend Approvals Mgmt.", 'OnCancelWarehouseJournalBatchApprovalRequest', '', FALSE, FALSE)]
    PROCEDURE RunWorkflowOnCancelWarehouseJournalBatchApprovalRequest(var WarehouseJournalBatch: Record "Warehouse Journal Batch")
    BEGIN
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelWarehouseJournalBatchApprovalRequestCode(), WarehouseJournalBatch);
    END;


    PROCEDURE RunWorkflowOnSendWarehouseJournalLineForApprovalCode(): Code[128];
    BEGIN
        EXIT(UPPERCASE('RunWorkflowOnSendWarehouseJournalLineForApproval'));
    END;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Extend Approvals Mgmt.", 'OnSendWarehouseJournalLineForApproval', '', FALSE, FALSE)]
    PROCEDURE RunWorkflowOnSendWarehouseJournalLineForApproval(var WarehouseJournalLine: Record "Warehouse Journal Line")
    BEGIN
        WorkflowManagement.HandleEvent(RunWorkflowOnSendWarehouseJournalLineForApprovalCode(), WarehouseJournalLine);
    END;


    PROCEDURE RunWorkflowOnCancelWarehouseJournalLineApprovalRequestCode(): Code[128];
    BEGIN
        EXIT(UPPERCASE('RunWorkflowOnCancelWarehouseJournalLineApprovalRequest'));
    END;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Extend Approvals Mgmt.", 'OnCancelWarehouseJournalLineApprovalRequest', '', FALSE, FALSE)]
    PROCEDURE RunWorkflowOnCancelWarehouseJournalLineApprovalRequest(var WarehouseJournalLine: Record "Warehouse Journal Line")
    BEGIN
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelWarehouseJournalLineApprovalRequestCode(), WarehouseJournalLine);
    END;

    //Approve
    PROCEDURE RunWorkflowOnApproveWarehouseJnlBatchCode(): Code[128]
    BEGIN
        EXIT(UpperCase('RunWorkflowOnApproveWarehouseJnlBatch'))
    END;

    PROCEDURE RunWorkflowOnApproveWarehouseJnlLineCode(): Code[128]
    BEGIN
        EXIT(UpperCase('RunWorkflowOnApproveWarehouseJnlLine'))
    END;

    PROCEDURE RunWorkflowOnRejectWarehouseJnlBatchCode(): Code[128]
    BEGIN
        EXIT(UpperCase('RunWorkflowOnRejectWarehouseJnlBatch'))
    END;

    PROCEDURE RunWorkflowOnRejectWarehouseJnlLineCode(): Code[128]
    BEGIN
        EXIT(UpperCase('RunWorkflowOnRejectWarehouseJnlLine'))
    END;

    PROCEDURE SetStatusToPendingApprovalCodeWarehouseJnl(): Code[128]
    BEGIN
        EXIT(UpperCase('SetStatusToPendingApprovalWarehouseJnl'));
    END;

    PROCEDURE ReopenWarehouseJnlCode(): Code[128]
    BEGIN
        EXIT(UpperCase('ReopenWarehouseJnl'));
    END;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnApproveApprovalRequest', '', true, true)]
    PROCEDURE RunWorkflowOnApproveItemJnlBatch(var ApprovalEntry: Record "Approval Entry")
    var
        ItemJournalBatch: Record "Item Journal Batch";
        ItemJournalLine: Record "Item Journal Line";
        ItemJournalLine2: Record "Item Journal Line";
        ApprovalEntry2: Record "Approval Entry";
        RecRef: RecordRef;
        ApprovalEntry3: Record "Approval Entry";
        _ApprovalEntry: Record "Approval Entry";
    BEGIN

        ApprovalEntry3.RESET;
        ApprovalEntry3.SETRANGE("Workflow Step Instance ID", ApprovalEntry."Workflow Step Instance ID");
        ApprovalEntry3.SetRange(Status, ApprovalEntry3.Status::Open);
        IF NOT ApprovalEntry3.FINDFIRST THEN BEGIN
            ApprovalEntry2.RESET;
            ApprovalEntry2.SETCURRENTKEY("Record ID to Approve", "Workflow Step Instance ID", "Sequence No.");
            ApprovalEntry2.SetRange("Workflow Step Instance ID", ApprovalEntry."Workflow Step Instance ID");
            ApprovalEntry2.SetRange(Status, ApprovalEntry2.Status::Created);
            IF ApprovalEntry2.FindFirst() THEN BEGIN
                _ApprovalEntry.RESET;
                _ApprovalEntry.SETRANGE("Workflow Step Instance ID", ApprovalEntry."Workflow Step Instance ID");
                _ApprovalEntry.SetRange("Sequence No.", ApprovalEntry2."Sequence No.");
                IF _ApprovalEntry.FindFirst() THEN
                    RepEAT
                        _ApprovalEntry.Status := _ApprovalEntry.Status::Open;
                        _ApprovalEntry.Modify(true);
                    UNTIL _ApprovalEntry.NEXT = 0;

            END;
        END;

        ApprovalEntry2.Reset;
        ApprovalEntry2.SetRange("Table ID", ApprovalEntry."Table ID");
        ApprovalEntry2.SetRange("Document No.", ApprovalEntry."Document No.");
        ApprovalEntry2.SetFilter(Status, '%1|%2', ApprovalEntry2.Status::Open, ApprovalEntry2.Status::Created);
        IF NOT ApprovalEntry2.FINDFIRST THEN BEGIN
            IF ApprovalEntry."Table ID" = DATABASE::"Item Journal Batch" THEN BEGIN
                RecRef.Get(ApprovalEntry."Record ID to Approve");
                RecRef.SetTable(ItemJournalBatch);
                ItemJournalLine.RESET;
                ItemJournalLine.SETRANGE("Journal Template Name", ItemJournalBatch."Journal Template Name");
                ItemJournalLine.SETRANGE("Journal Batch Name", ItemJournalBatch.Name);
                IF ItemJournalLine.FINDFIRST THEN
                    REPEAT
                        ItemJournalLine.Status := ItemJournalLine.Status::Approved;
                        ItemJournalLine.Modify();
                    UNTIL ItemJournalLine.NEXT = 0;
            END
            ELSE
                IF ApprovalEntry."Table ID" = DATABASE::"Item Journal Line" THEN BEGIN
                    RecRef.Get(ApprovalEntry."Record ID to Approve");
                    RecRef.SetTable(ItemJournalLine2);
                    ItemJournalLine.RESET;
                    ItemJournalLine.SETRANGE("Journal Template Name", ItemJournalLine2."Journal Template Name");
                    ItemJournalLine.SETRANGE("Journal Batch Name", ItemJournalLine2."Journal Batch Name");
                    ItemJournalLine.SETRANGE("Document No.", ItemJournalLine2."Document No.");
                    IF ItemJournalLine.FINDFIRST THEN
                        REPEAT
                            ItemJournalLine.Status := ItemJournalLine.Status::Approved;
                            ItemJournalLine.Modify();
                        UNTIL ItemJournalLine.NEXT = 0;
                END;
            WorkflowManagement.HandleEventOnKnownWorkflowInstance(RunWorkflowOnApproveItemJnlBatchCode(), ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");
        END;

    END;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnRejectApprovalRequest', '', true, true)]
    PROCEDURE RunWorkflowOnRejectItemJnlBatch(var ApprovalEntry: Record "Approval Entry")
    VAR
        ItemJournalBatch: Record "Item Journal Batch";
        ItemJournalLine: Record "Item Journal Line";
        ItemJournalLine2: Record "Item Journal Line";
        ApprovalEntry2: Record "Approval Entry";
        RecRef: RecordRef;
    BEGIN

        IF ApprovalEntry."Table ID" = DATABASE::"Item Journal Batch" THEN BEGIN
            RecRef.Get(ApprovalEntry."Record ID to Approve");
            RecRef.SetTable(ItemJournalBatch);
            ItemJournalLine.RESET;
            ItemJournalLine.SETRANGE("Journal Template Name", ItemJournalBatch."Journal Template Name");
            ItemJournalLine.SETRANGE("Journal Batch Name", ItemJournalBatch.Name);
            IF ItemJournalLine.FINDFIRST THEN
                REPEAT
                    ItemJournalLine.Status := ItemJournalLine.Status::Open;
                    ItemJournalLine.Modify();
                UNTIL ItemJournalLine.NEXT = 0;
        END
        ELSE
            IF ApprovalEntry."Table ID" = DATABASE::"Item Journal Line" THEN BEGIN
                RecRef.Get(ApprovalEntry."Record ID to Approve");
                RecRef.SetTable(ItemJournalLine2);
                ItemJournalLine.RESET;
                ItemJournalLine.SETRANGE("Journal Template Name", ItemJournalLine2."Journal Template Name");
                ItemJournalLine.SETRANGE("Journal Batch Name", ItemJournalLine2."Journal Batch Name");
                ItemJournalLine.SETRANGE("Document No.", ItemJournalLine2."Document No.");
                IF ItemJournalLine.FINDFIRST THEN
                    REPEAT
                        ItemJournalLine.Status := ItemJournalLine.Status::Open;
                        ItemJournalLine.Modify();
                    UNTIL ItemJournalLine.NEXT = 0;
            END;
        WorkflowManagement.HandleEventOnKnownWorkflowInstance(RunWorkflowOnRejectItemJnlBatchCode(), ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");
    END;

    PROCEDURE SetStatusToPendingApprovalItemJnl(VAR Variant: Variant)
    VAR
        RecRef: RecordRef;
        ItemJournalBatch: Record "Item Journal Batch";
        ItemJournalLine: Record "Item Journal Line";
        ItemJournalLine2: Record "Item Journal Line";
        ApprovalEntry2: Record "Approval Entry";
        RecGUID: Guid;
    BEGIN
        RecRef.GETTABLE(Variant);
        CASE RecRef.NUMBER OF
            DATABASE::"Item Journal Batch":
                BEGIN
                    RecRef.SETTABLE(ItemJournalBatch);
                    ItemJournalLine.RESET;
                    ItemJournalLine.SETRANGE("Journal Template Name", ItemJournalBatch."Journal Template Name");
                    ItemJournalLine.SETRANGE("Journal Batch Name", ItemJournalBatch.Name);
                    IF ItemJournalLine.FINDFIRST THEN BEGIN
                        REPEAT
                            ItemJournalLine.Status := ItemJournalLine.Status::"Pending For Approval";
                            ItemJournalLine.Modify();
                        UNTIL ItemJournalLine.NEXT = 0;
                    END;
                END;
            DATABASE::"Item Journal Line":
                BEGIN
                    RecRef.SetTable(ItemJournalLine2);
                    ItemJournalLine.RESET;
                    ItemJournalLine.SETRANGE("Journal Template Name", ItemJournalLine2."Journal Template Name");
                    ItemJournalLine.SETRANGE("Journal Batch Name", ItemJournalLine2."Journal Batch Name");
                    ItemJournalLine.SETRANGE("Document No.", ItemJournalLine2."Document No.");
                    IF ItemJournalLine.FINDFIRST THEN
                        REPEAT
                            ItemJournalLine.Status := ItemJournalLine.Status::"Pending For Approval";
                            ItemJournalLine.Modify();
                        UNTIL ItemJournalLine.NEXT = 0;
                END;
        END;
    END;

    PROCEDURE ReopenItemJnl(VAR Variant: Variant)
    VAR
        RecRef: RecordRef;
        ItemJournalBatch: Record "Item Journal Batch";
        ItemJournalLine: Record "Item Journal Line";
        ItemJournalLine2: Record "Item Journal Line";
        ApprovalEntry2: Record "Approval Entry";
    BEGIN
        RecRef.GETTABLE(Variant);
        CASE RecRef.NUMBER OF
            DATABASE::"Item Journal Batch":
                BEGIN
                    RecRef.SETTABLE(ItemJournalBatch);
                    ItemJournalLine.RESET;
                    ItemJournalLine.SETRANGE("Journal Template Name", ItemJournalBatch."Journal Template Name");
                    ItemJournalLine.SETRANGE("Journal Batch Name", ItemJournalBatch.Name);
                    IF ItemJournalLine.FINDFIRST THEN
                        REPEAT
                            ItemJournalLine.Status := ItemJournalLine.Status::Open;
                            ItemJournalLine.Modify();
                        UNTIL ItemJournalLine.NEXT = 0;
                END;
            DATABASE::"Item Journal Line":
                BEGIN
                    RecRef.SetTable(ItemJournalLine2);
                    ItemJournalLine.RESET;
                    ItemJournalLine.SETRANGE("Journal Template Name", ItemJournalLine2."Journal Template Name");
                    ItemJournalLine.SETRANGE("Journal Batch Name", ItemJournalLine2."Journal Batch Name");
                    ItemJournalLine.SETRANGE("Document No.", ItemJournalLine2."Document No.");
                    IF ItemJournalLine.FINDFIRST THEN
                        REPEAT
                            ItemJournalLine.Status := ItemJournalLine.Status::Open;
                            ItemJournalLine.Modify();
                        UNTIL ItemJournalLine.NEXT = 0;
                END;
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnPopulateApprovalEntryArgument', '', true, true)]
    PROCEDURE OnPopulateApprovalEntryArgument(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance")
    VAR
        ItemJournalBatch: Record "Item Journal Batch";
        ItemJournalLine: Record "Item Journal Line";
    BEGIN
        CASE RecRef.NUMBER OF
            DATABASE::"Item Journal Batch":
                BEGIN
                    RecRef.SETTABLE(ItemJournalBatch);
                    ApprovalEntryArgument."Table ID" := RecRef.Number;
                    ApprovalEntryArgument."Document No." := ItemJournalBatch.Name;
                END;
            DATABASE::"Item Journal Line":
                BEGIN
                    RecRef.SetTable(ItemJournalLine);
                    ApprovalEntryArgument."Table ID" := RecRef.Number;
                    ApprovalEntryArgument."Document No." := ItemJournalLine."Document No.";
                END;
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    PROCEDURE OnAddWorkflowEventsToLibrary()
    BEGIN
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendItemJournalBatchForApprovalCode(), Database::"Item Journal Batch", ItemJournalBatchSendForApprovalEventDescTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelItemJournalBatchApprovalRequestCode(), Database::"Item Journal Batch", ItemJournalBatchApprovalRequestCancelEventDescTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendItemJournalLineForApprovalCode(), Database::"Item Journal Line", ItemJournalLineSendForApprovalEventDescTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelItemJournalLineApprovalRequestCode(), Database::"Item Journal Line", ItemJournalLineApprovalRequestCancelEventDescTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnRejectItemJnlBatchCode(), Database::"Item Journal Batch", ItemJournalRejectText, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnApproveItemJnlBatchCode(), Database::"Item Journal Batch", ItemJournalApproveText, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnRejectItemJnlLineCode(), Database::"Item Journal Line", ItemJournalRejectIJLText, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnApproveItemJnlLineCode(), Database::"Item Journal Line", ItemJournalApproveIJLText, 0, FALSE);
        //Warehouse Physical Inventory Journal
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendWarehouseJournalBatchForApprovalCode(), Database::"Warehouse Journal Batch", WarehouseJournalBatchSendForApprovalEventDescTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelWarehouseJournalBatchApprovalRequestCode(), Database::"Warehouse Journal Batch", WarehouseJournalBatchApprovalRequestCancelEventDescTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendWarehouseJournalLineForApprovalCode(), Database::"Warehouse Journal Line", WarehouseJournalLineSendForApprovalEventDescTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelWarehouseJournalLineApprovalRequestCode(), Database::"Warehouse Journal Line", WarehouseJournalLineApprovalRequestCancelEventDescTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnRejectWarehouseJnlBatchCode(), Database::"Warehouse Journal Batch", WarehouseJournalRejectText, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnApproveWarehouseJnlBatchCode(), Database::"Warehouse Journal Batch", WarehouseJournalApproveText, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnRejectWarehouseJnlLineCode(), Database::"Warehouse Journal Line", WarehouseJournalRejectIJLText, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnApproveWarehouseJnlLineCode(), Database::"Warehouse Journal Line", WarehouseJournalApproveIJLText, 0, FALSE);
    END;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', true, true)]
    PROCEDURE OnAddWorkflowResponsesToLibrary()
    BEGIN
        WorkflowResponseHandling.AddResponseToLibrary(SetStatusToPendingApprovalCodeItemJnl(), 0, SendForPendAppItemJnlText, 'GROUP 0');
        WorkflowResponseHandling.AddResponseToLibrary(ReopenItemJnlCode(), 0, ReOpenItemJnlText, 'GROUP 0');
    END;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsePredecessorsToLibrary', '', true, true)]
    PROCEDURE OnAddWorkflowResponsePredecessorsToLibrary(ResponseFunctionName: Code[128])
    BEGIN
        CASE ResponseFunctionName OF
            WorkFlowResponseHandling.SendApprovalRequestForApprovalCode:
                WorkFlowResponseHandling.AddResponsePredecessor(WorkFlowResponseHandling.SendApprovalRequestForApprovalCode, RunWorkflowOnApproveItemJnlBatchCode());
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnExecuteWorkflowResponse', '', false, false)]
    PROCEDURE OnExecuteWorkflowResponsePhyInvJnl(var ResponseExecuted: Boolean; Variant: Variant; xVariant: Variant; ResponseWorkflowStepInstance: Record "Workflow Step Instance")
    VAR
        WorkflowResponse: Record "Workflow Response";
    BEGIN
        IF WorkflowResponse.GET(ResponseWorkflowStepInstance."Function Name") THEN;
        CASE WorkflowResponse."Function Name" OF
            SetStatusToPendingApprovalCodeItemJnl():
                BEGIN
                    SetStatusToPendingApprovalItemJnl(Variant);
                    ResponseExecuted := TRUE;
                END;
            ReopenItemJnlCode():
                BEGIN
                    ReopenItemJnl(Variant);
                    ResponseExecuted := TRUE;
                END;
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnOpenDocument', '', true, true)]
    PROCEDURE OnOpenDocument(RecRef: RecordRef; var Handled: Boolean)
    VAR
        ItemJournalBatch: Record "Item Journal Batch";
        ItemJournalLine: Record "Item Journal Line";
        ItemJournalLine2: Record "Item Journal Line";
        ApprovalEntry2: Record "Approval Entry";
    BEGIN
        CASE RecRef.NUMBER OF
            DATABASE::"Item Journal Batch":
                BEGIN
                    RecRef.SETTABLE(ItemJournalBatch);
                    ItemJournalLine.RESET;
                    ItemJournalLine.SETRANGE("Journal Template Name", ItemJournalBatch."Journal Template Name");
                    ItemJournalLine.SETRANGE("Journal Batch Name", ItemJournalBatch.Name);
                    IF ItemJournalLine.FINDFIRST THEN
                        REPEAT
                            ItemJournalLine.Status := ItemJournalLine.Status::Open;
                            ItemJournalLine.Modify();
                            Handled := TRUE;
                        UNTIL ItemJournalLine.NEXT = 0;
                END;
        END;
    END;

    //Warehouse Physical Inventory Journal Workflow
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnApproveApprovalRequest', '', true, true)]
    PROCEDURE RunWorkflowOnApproveWarehouseJnlBatch(var ApprovalEntry: Record "Approval Entry")
    var
        WarehouseJournalBatch: Record "Warehouse Journal Batch";
        WarehouseJournalLine: Record "Warehouse Journal Line";
        WarehouseJournalLine2: Record "Warehouse Journal Line";
        ApprovalEntry2: Record "Approval Entry";
        RecRef: RecordRef;
        ApprovalEntry3: Record "Approval Entry";
        _ApprovalEntry: Record "Approval Entry";
    BEGIN

        ApprovalEntry3.RESET;
        ApprovalEntry3.SETRANGE("Workflow Step Instance ID", ApprovalEntry."Workflow Step Instance ID");
        ApprovalEntry3.SetRange(Status, ApprovalEntry3.Status::Open);
        IF NOT ApprovalEntry3.FINDFIRST THEN BEGIN
            ApprovalEntry2.RESET;
            ApprovalEntry2.SETCURRENTKEY("Record ID to Approve", "Workflow Step Instance ID", "Sequence No.");
            ApprovalEntry2.SetRange("Workflow Step Instance ID", ApprovalEntry."Workflow Step Instance ID");
            ApprovalEntry2.SetRange(Status, ApprovalEntry2.Status::Created);
            IF ApprovalEntry2.FindFirst() THEN BEGIN
                _ApprovalEntry.RESET;
                _ApprovalEntry.SETRANGE("Workflow Step Instance ID", ApprovalEntry."Workflow Step Instance ID");
                _ApprovalEntry.SetRange("Sequence No.", ApprovalEntry2."Sequence No.");
                IF _ApprovalEntry.FindFirst() THEN
                    RepEAT
                        _ApprovalEntry.Status := _ApprovalEntry.Status::Open;
                        _ApprovalEntry.Modify(true);
                    UNTIL _ApprovalEntry.NEXT = 0;

            END;
        END;

        ApprovalEntry2.Reset;
        ApprovalEntry2.SetRange("Table ID", ApprovalEntry."Table ID");
        ApprovalEntry2.SetRange("Document No.", ApprovalEntry."Document No.");
        ApprovalEntry2.SetFilter(Status, '%1|%2', ApprovalEntry2.Status::Open, ApprovalEntry2.Status::Created);
        IF NOT ApprovalEntry2.FINDFIRST THEN BEGIN
            IF ApprovalEntry."Table ID" = DATABASE::"Warehouse Journal Batch" THEN BEGIN
                RecRef.Get(ApprovalEntry."Record ID to Approve");
                RecRef.SetTable(WarehouseJournalBatch);
                WarehouseJournalLine.RESET;
                WarehouseJournalLine.SETRANGE("Journal Template Name", WarehouseJournalBatch."Journal Template Name");
                WarehouseJournalLine.SETRANGE("Journal Batch Name", WarehouseJournalBatch.Name);
                IF WarehouseJournalLine.FINDFIRST THEN
                    REPEAT
                        WarehouseJournalLine.Status := WarehouseJournalLine.Status::Approved;
                        WarehouseJournalLine.Modify();
                    UNTIL WarehouseJournalLine.NEXT = 0;
            END
            ELSE
                IF ApprovalEntry."Table ID" = DATABASE::"Warehouse Journal Line" THEN BEGIN
                    RecRef.Get(ApprovalEntry."Record ID to Approve");
                    RecRef.SetTable(WarehouseJournalLine2);
                    WarehouseJournalLine.RESET;
                    WarehouseJournalLine.SETRANGE("Journal Template Name", WarehouseJournalLine2."Journal Template Name");
                    WarehouseJournalLine.SETRANGE("Journal Batch Name", WarehouseJournalLine2."Journal Batch Name");
                    WarehouseJournalLine.SETRANGE("Whse. Document No.", WarehouseJournalLine2."Whse. Document No.");
                    IF WarehouseJournalLine.FINDFIRST THEN
                        REPEAT
                            WarehouseJournalLine.Status := WarehouseJournalLine.Status::Approved;
                            WarehouseJournalLine.Modify();
                        UNTIL WarehouseJournalLine.NEXT = 0;
                END;
            WorkflowManagement.HandleEventOnKnownWorkflowInstance(RunWorkflowOnApproveWarehouseJnlBatchCode(), ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnRejectApprovalRequest', '', true, true)]
    PROCEDURE RunWorkflowOnRejectWarehouseJnlBatch(var ApprovalEntry: Record "Approval Entry")
    VAR
        WarehouseJournalBatch: Record "Warehouse Journal Batch";
        WarehouseJournalLine: Record "Warehouse Journal Line";
        WarehouseJournalLine2: Record "Warehouse Journal Line";
        ApprovalEntry2: Record "Approval Entry";
        RecRef: RecordRef;
    BEGIN

        IF ApprovalEntry."Table ID" = DATABASE::"Warehouse Journal Batch" THEN BEGIN
            RecRef.Get(ApprovalEntry."Record ID to Approve");
            RecRef.SetTable(WarehouseJournalBatch);
            WarehouseJournalLine.RESET;
            WarehouseJournalLine.SETRANGE("Journal Template Name", WarehouseJournalBatch."Journal Template Name");
            WarehouseJournalLine.SETRANGE("Journal Batch Name", WarehouseJournalBatch.Name);
            IF WarehouseJournalLine.FINDFIRST THEN
                REPEAT
                    WarehouseJournalLine.Status := WarehouseJournalLine.Status::Open;
                    WarehouseJournalLine.Modify();
                UNTIL WarehouseJournalLine.NEXT = 0;
        END
        ELSE
            IF ApprovalEntry."Table ID" = DATABASE::"Warehouse Journal Line" THEN BEGIN
                RecRef.Get(ApprovalEntry."Record ID to Approve");
                RecRef.SetTable(WarehouseJournalLine2);
                WarehouseJournalLine.RESET;
                WarehouseJournalLine.SETRANGE("Journal Template Name", WarehouseJournalLine2."Journal Template Name");
                WarehouseJournalLine.SETRANGE("Journal Batch Name", WarehouseJournalLine2."Journal Batch Name");
                WarehouseJournalLine.SETRANGE("Whse. Document No.", WarehouseJournalLine2."Whse. Document No.");
                IF WarehouseJournalLine.FINDFIRST THEN
                    REPEAT
                        WarehouseJournalLine.Status := WarehouseJournalLine.Status::Open;
                        WarehouseJournalLine.Modify();
                    UNTIL WarehouseJournalLine.NEXT = 0;
            END;
        WorkflowManagement.HandleEventOnKnownWorkflowInstance(RunWorkflowOnRejectWarehouseJnlBatchCode(), ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");
    END;

    PROCEDURE SetStatusToPendingApprovalWarehouseJnl(VAR Variant: Variant)
    VAR
        RecRef: RecordRef;
        WarehouseJournalBatch: Record "Warehouse Journal Batch";
        WarehouseJournalLine: Record "Warehouse Journal Line";
        WarehouseJournalLine2: Record "Warehouse Journal Line";
        ApprovalEntry2: Record "Approval Entry";
        RecGUID: Guid;
    BEGIN
        RecRef.GETTABLE(Variant);
        CASE RecRef.NUMBER OF
            DATABASE::"Warehouse Journal Batch":
                BEGIN
                    RecRef.SETTABLE(WarehouseJournalBatch);
                    WarehouseJournalLine.RESET;
                    WarehouseJournalLine.SETRANGE("Journal Template Name", WarehouseJournalBatch."Journal Template Name");
                    WarehouseJournalLine.SETRANGE("Journal Batch Name", WarehouseJournalBatch.Name);
                    IF WarehouseJournalLine.FINDFIRST THEN BEGIN
                        REPEAT
                            WarehouseJournalLine.Status := WarehouseJournalLine.Status::"Pending For Approval";
                            WarehouseJournalLine.Modify();
                        UNTIL WarehouseJournalLine.NEXT = 0;
                    END;
                END;
            DATABASE::"Warehouse Journal Line":
                BEGIN
                    RecRef.SetTable(WarehouseJournalLine2);
                    WarehouseJournalLine.RESET;
                    WarehouseJournalLine.SETRANGE("Journal Template Name", WarehouseJournalLine2."Journal Template Name");
                    WarehouseJournalLine.SETRANGE("Journal Batch Name", WarehouseJournalLine2."Journal Batch Name");
                    WarehouseJournalLine.SETRANGE("Whse. Document No.", WarehouseJournalLine2."Whse. Document No.");
                    IF WarehouseJournalLine.FINDFIRST THEN
                        REPEAT
                            WarehouseJournalLine.Status := WarehouseJournalLine.Status::"Pending For Approval";
                            WarehouseJournalLine.Modify();
                        UNTIL WarehouseJournalLine.NEXT = 0;
                END;
        END;
    END;

    PROCEDURE ReopenWarehouseJnl(VAR Variant: Variant)
    VAR
        RecRef: RecordRef;
        WarehouseJournalBatch: Record "Warehouse Journal Batch";
        WarehouseJournalLine: Record "Warehouse Journal Line";
        WarehouseJournalLine2: Record "Warehouse Journal Line";
        ApprovalEntry2: Record "Approval Entry";
    BEGIN
        RecRef.GETTABLE(Variant);
        CASE RecRef.NUMBER OF
            DATABASE::"Warehouse Journal Batch":
                BEGIN
                    RecRef.SETTABLE(WarehouseJournalBatch);
                    WarehouseJournalLine.RESET;
                    WarehouseJournalLine.SETRANGE("Journal Template Name", WarehouseJournalBatch."Journal Template Name");
                    WarehouseJournalLine.SETRANGE("Journal Batch Name", WarehouseJournalBatch.Name);
                    IF WarehouseJournalLine.FINDFIRST THEN
                        REPEAT
                            WarehouseJournalLine.Status := WarehouseJournalLine.Status::Open;
                            WarehouseJournalLine.Modify();
                        UNTIL WarehouseJournalLine.NEXT = 0;
                END;
            DATABASE::"Warehouse Journal Line":
                BEGIN
                    RecRef.SetTable(WarehouseJournalLine2);
                    WarehouseJournalLine.RESET;
                    WarehouseJournalLine.SETRANGE("Journal Template Name", WarehouseJournalLine2."Journal Template Name");
                    WarehouseJournalLine.SETRANGE("Journal Batch Name", WarehouseJournalLine2."Journal Batch Name");
                    WarehouseJournalLine.SETRANGE("Whse. Document No.", WarehouseJournalLine2."Whse. Document No.");
                    IF WarehouseJournalLine.FINDFIRST THEN
                        REPEAT
                            WarehouseJournalLine.Status := WarehouseJournalLine.Status::Open;
                            WarehouseJournalLine.Modify();
                        UNTIL WarehouseJournalLine.NEXT = 0;
                END;
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnPopulateApprovalEntryArgument', '', true, true)]
    PROCEDURE OnPopulateWarehouseApprovalEntryArgument(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance")
    VAR
        WarehouseJournalBatch: Record "Warehouse Journal Batch";
        WarehouseJournalLine: Record "Warehouse Journal Line";
    BEGIN
        CASE RecRef.NUMBER OF
            DATABASE::"Warehouse Journal Batch":
                BEGIN
                    RecRef.SETTABLE(WarehouseJournalBatch);
                    ApprovalEntryArgument."Table ID" := RecRef.Number;
                    ApprovalEntryArgument."Document No." := WarehouseJournalBatch.Name;
                END;
            DATABASE::"Warehouse Journal Line":
                BEGIN
                    RecRef.SetTable(WarehouseJournalLine);
                    ApprovalEntryArgument."Table ID" := RecRef.Number;
                    ApprovalEntryArgument."Document No." := WarehouseJournalLine."Whse. Document No.";
                END;
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', true, true)]
    PROCEDURE WarehouseOnAddWorkflowResponsesToLibrary()
    BEGIN
        WorkflowResponseHandling.AddResponseToLibrary(SetStatusToPendingApprovalCodeWarehouseJnl(), 0, SendForPendAppWarehouseJnlText, 'GROUP 0');
        WorkflowResponseHandling.AddResponseToLibrary(ReopenWarehouseJnlCode(), 0, ReOpenWarehouseJnlText, 'GROUP 0');
    END;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsePredecessorsToLibrary', '', true, true)]
    PROCEDURE WarehouseOnAddWorkflowResponsePredecessorsToLibrary(ResponseFunctionName: Code[128])
    BEGIN
        CASE ResponseFunctionName OF
            WorkFlowResponseHandling.SendApprovalRequestForApprovalCode:
                WorkFlowResponseHandling.AddResponsePredecessor(WorkFlowResponseHandling.SendApprovalRequestForApprovalCode, RunWorkflowOnApproveWarehouseJnlBatchCode());
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnExecuteWorkflowResponse', '', false, false)]
    PROCEDURE OnExecuteWorkflowResponseWarehousePhyInvJnl(var ResponseExecuted: Boolean; Variant: Variant; xVariant: Variant; ResponseWorkflowStepInstance: Record "Workflow Step Instance")
    VAR
        WorkflowResponse: Record "Workflow Response";
    BEGIN
        IF WorkflowResponse.GET(ResponseWorkflowStepInstance."Function Name") THEN;
        CASE WorkflowResponse."Function Name" OF
            SetStatusToPendingApprovalCodeWarehouseJnl():
                BEGIN
                    SetStatusToPendingApprovalWarehouseJnl(Variant);
                    ResponseExecuted := TRUE;
                END;
            ReopenWarehouseJnlCode():
                BEGIN
                    ReopenWarehouseJnl(Variant);
                    ResponseExecuted := TRUE;
                END;
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnOpenDocument', '', true, true)]
    PROCEDURE WarehouseOnOpenDocument(RecRef: RecordRef; var Handled: Boolean)
    VAR
        WarehouseJournalBatch: Record "Warehouse Journal Batch";
        WarehouseJournalLine: Record "Warehouse Journal Line";
        WarehouseJournalLine2: Record "Warehouse Journal Line";
        ApprovalEntry2: Record "Approval Entry";
    BEGIN
        CASE RecRef.NUMBER OF
            DATABASE::"Warehouse Journal Batch":
                BEGIN
                    RecRef.SETTABLE(WarehouseJournalBatch);
                    WarehouseJournalLine.RESET;
                    WarehouseJournalLine.SETRANGE("Journal Template Name", WarehouseJournalBatch."Journal Template Name");
                    WarehouseJournalLine.SETRANGE("Journal Batch Name", WarehouseJournalBatch.Name);
                    WarehouseJournalLine.SetRange("Location Code", WarehouseJournalBatch."Location Code");
                    IF WarehouseJournalLine.FINDFIRST THEN
                        REPEAT
                            WarehouseJournalLine.Status := WarehouseJournalLine.Status::Open;
                            WarehouseJournalLine.Modify();
                            Handled := TRUE;
                        UNTIL WarehouseJournalLine.NEXT = 0;
                END;
        END;
    END;

}
