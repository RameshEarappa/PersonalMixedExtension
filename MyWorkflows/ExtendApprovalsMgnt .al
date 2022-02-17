codeunit 50110 "Extend Approvals Mgmt."
{
    VAR
        NoWorkflowEnabled: TextConst ENU = 'No approval workflow for this record type is enabled.';
        WorkflowManagement: Codeunit "Workflow Management";
        WorkflowEventHandling: Codeunit "Ext. Workflow Event Handling";
        PendingJournalBatchApprovalExistsErr: TextConst ENU = 'An approval request already exists.';
        NoApprovalsSentMsg: TextConst ENU = 'No approval requests have been sent, either because they are already sent or because related workflows do not support the journal line.';
        PendingApprovalForSelectedLinesMsg: TextConst ENU = 'Approval requests have been sent.';
        PendingApprovalForSomeSelectedLinesMsg: TextConst ENU = 'Approval requests have been sent.\\Requests for some journal lines were not sent, either because they are already sent or because related workflows do not support the journal line.';
        ApprovalReqCanceledForSelectedLinesMsg: TextConst ENU = 'The approval request for the selected record has been canceled.';

    [IntegrationEvent(FALSE, FALSE)]
    PROCEDURE OnSendItemlJournalBatchForApproval(var ItemJournalBatch: Record "Item Journal Batch")
    BEGIN

    END;

    [IntegrationEvent(FALSE, FALSE)]
    PROCEDURE OnCancelItemJournalBatchApprovalRequest(var ItemJournalBatch: Record "Item Journal Batch")
    BEGIN

    END;

    [IntegrationEvent(FALSE, FALSE)]
    PROCEDURE OnSendItemlJournalLineForApproval(var ItemJournalLine: Record "Item Journal Line")
    BEGIN

    END;

    [IntegrationEvent(FALSE, FALSE)]
    PROCEDURE OnCancelItemJournalLineApprovalRequest(var ItemJournalLine: Record "Item Journal Line")
    BEGIN

    END;

    // Start Warehouse Physical Inventory Workflow
    [IntegrationEvent(FALSE, FALSE)]
    PROCEDURE OnSendWarehouseJournalBatchForApproval(var WarehouseJournalBatch: Record "Warehouse Journal Batch")
    BEGIN

    END;

    [IntegrationEvent(FALSE, FALSE)]
    PROCEDURE OnCancelWarehouseJournalBatchApprovalRequest(var WarehouseJournalBatch: Record "Warehouse Journal Batch")
    BEGIN

    END;

    [IntegrationEvent(FALSE, FALSE)]
    PROCEDURE OnSendWarehouseJournalLineForApproval(var WarehouseJournalLine: Record "Warehouse Journal Line")
    BEGIN

    END;

    [IntegrationEvent(FALSE, FALSE)]
    PROCEDURE OnCancelWarehouseJournalLineApprovalRequest(var WarehouseJournalLine: Record "Warehouse Journal Line")
    BEGIN

    END;
    // End Warehouse Physical Inventory Workflow
    PROCEDURE CheckItemJournalBatchApprovalsWorkflowEnabled(var ItemJournalBatch: Record "Item Journal Batch"): Boolean
    BEGIN
        IF NOT
           WorkflowManagement.CanExecuteWorkflow(ItemJournalBatch,
             WorkflowEventHandling.RunWorkflowOnSendItemJournalBatchForApprovalCode)
        THEN
            ERROR(NoWorkflowEnabled);

        EXIT(TRUE);
    END;

    PROCEDURE CheckItemJournalLineApprovalsWorkflowEnabled(var ItemJournalLine: Record "Item Journal Line"): Boolean
    BEGIN
        IF NOT
           WorkflowManagement.CanExecuteWorkflow(ItemJournalLine,
             WorkflowEventHandling.RunWorkflowOnSendItemJournalLineForApprovalCode)
        THEN
            ERROR(NoWorkflowEnabled);

        EXIT(TRUE);
    END;

    PROCEDURE GetItemJournalBatch(var ItemJournalBatch: Record "Item Journal Batch"; var ItemJournalLine: Record "Item Journal Line")
    BEGIN
        IF NOT ItemJournalBatch.GET(ItemJournalLine."Journal Template Name", ItemJournalLine."Journal Batch Name") THEN
            ItemJournalBatch.GET(ItemJournalLine.GETFILTER("Journal Template Name"), ItemJournalLine.GETFILTER("Journal Batch Name"));
    END;

    PROCEDURE HasOpenApprovalEntries(RecordID: RecordID): Boolean
    VAR
        ApprovalEntry: Record "Approval Entry";
    BEGIN
        ApprovalEntry.SETRANGE("Table ID", RecordID.TABLENO);
        ApprovalEntry.SETRANGE("Record ID to Approve", RecordID);
        ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Open);
        ApprovalEntry.SETRANGE("Related to Change", FALSE);
        EXIT(NOT ApprovalEntry.ISEMPTY);
    END;

    PROCEDURE HasAnyOpenJournalLineApprovalEntries(JournalTemplateName: Code[20]; JournalBatchName: Code[20]): Boolean
    VAR
        ApprovalEntry: Record "Approval Entry";
        ItemJnlLine: Record "Item Journal Line";
        ItemJnlLineRecRef: RecordRef;
        ItemJnlLineRecordID: RecordId;
    BEGIN
        ApprovalEntry.SETRANGE("Table ID", DATABASE::"Item Journal Line");
        ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Open);
        ApprovalEntry.SETRANGE("Related to Change", FALSE);
        IF ApprovalEntry.ISEMPTY THEN
            EXIT(FALSE);

        ItemJnlLine.SETRANGE("Journal Template Name", JournalTemplateName);
        ItemJnlLine.SETRANGE("Journal Batch Name", JournalBatchName);
        IF ItemJnlLine.ISEMPTY THEN
            EXIT(FALSE);

        IF ItemJnlLine.COUNT < ApprovalEntry.COUNT THEN BEGIN
            ItemJnlLine.FINDSET;
            REPEAT
                IF HasOpenApprovalEntries(ItemJnlLine.RECORDID) THEN
                    EXIT(TRUE);
            UNTIL ItemJnlLine.NEXT = 0;
        END ELSE BEGIN
            ApprovalEntry.FINDSET;
            REPEAT
                ItemJnlLineRecordID := ApprovalEntry."Record ID to Approve";
                ItemJnlLineRecRef := ItemJnlLineRecordID.GETRECORD;
                ItemJnlLineRecRef.SETTABLE(ItemJnlLine);
                IF (ItemJnlLine."Journal Template Name" = JournalTemplateName) AND
                   (ItemJnlLine."Journal Batch Name" = JournalBatchName)
                THEN
                    EXIT(TRUE);
            UNTIL ApprovalEntry.NEXT = 0;
        END;

        EXIT(FALSE)
    END;

    PROCEDURE HasOpenOrPendingApprovalEntries(RecordID: RecordID): Boolean
    VAR
        ApprovalEntry: Record "Approval Entry";
    BEGIN
        ApprovalEntry.SETRANGE("Table ID", RecordID.TABLENO);
        ApprovalEntry.SETRANGE("Record ID to Approve", RecordID);
        ApprovalEntry.SETFILTER(Status, '%1|%2', ApprovalEntry.Status::Open, ApprovalEntry.Status::Created);
        ApprovalEntry.SETRANGE("Related to Change", FALSE);
        EXIT(NOT ApprovalEntry.ISEMPTY);
    END;


    PROCEDURE TrySendJournalBatchApprovalRequest(VAR ItemJnlLine: Record "Item Journal Line")
    var
        ItemJnlBatch: Record "Item Journal Batch";
    BEGIN
        GetItemJournalBatch(ItemJnlBatch, ItemJnlLine);
        CheckItemJournalBatchApprovalsWorkflowEnabled(ItemJnlBatch);
        IF HasOpenApprovalEntries(ItemJnlBatch.RecordId) OR
           HasAnyOpenJournalLineApprovalEntries(ItemJnlBatch."Journal Template Name", ItemJnlBatch.Name)
           THEN
            ERROR(PendingJournalBatchApprovalExistsErr);

        OnSendItemlJournalBatchForApproval(ItemJnlBatch);

    END;

    PROCEDURE TrySendJournalLineApprovalRequests(VAR ItemJnlLine: Record "Item Journal Line")
    var
        ItemJnlBatch: Record "Item Journal Batch";
        LinesSent: Integer;
    BEGIN
        IF ItemJnlLine.COUNT = 1 THEN
            CheckItemJournalLineApprovalsWorkflowEnabled(ItemJnlLine);
        REPEAT
            IF WorkflowManagement.CanExecuteWorkflow(ItemJnlLine,
         WorkflowEventHandling.RunWorkflowOnSendItemJournalLineForApprovalCode) AND
       NOT HasOpenApprovalEntries(ItemJnlLine.RECORDID)
    THEN BEGIN
                OnSendItemlJournalLineForApproval(ItemJnlLine);
                LinesSent += 1;
            END;
        UNTIL ItemJnlLine.NEXT = 0;
        CASE LinesSent OF
            0:
                MESSAGE(NoApprovalsSentMsg);
            ItemJnlLine.COUNT:
                MESSAGE(PendingApprovalForSelectedLinesMsg);
            ELSE
                MESSAGE(PendingApprovalForSomeSelectedLinesMsg);
        END;
    END;

    PROCEDURE TryCancelJournalBatchApprovalRequest(VAR ItemJnlLine: Record "Item Journal Line")
    VAR
        ItemJnlBatch: Record "Item Journal Batch";
        WorkflowWebhookManagement: Codeunit "Workflow Webhook Management";
    BEGIN
        GetItemJournalBatch(ItemJnlBatch, ItemJnlLine);
        OnCancelItemJournalBatchApprovalRequest(ItemJnlBatch);
        WorkflowWebhookManagement.FindAndCancel(ItemJnlBatch.RecordId);
    END;

    PROCEDURE TryCancelJournalLineApprovalRequests(VAR ItemJnlLine: Record "Item Journal Line")
    VAR
        WorkflowWebhookManagement: Codeunit "Workflow Webhook Management";
    BEGIN
        REPEAT
            IF HasOpenApprovalEntries(ItemJnlLine.RECORDID) THEN
                OnCancelItemJournalLineApprovalRequest(ItemJnlLine);
            WorkflowWebhookManagement.FindAndCancel(ItemJnlLine.RECORDID);
        UNTIL ItemJnlLine.NEXT = 0;
        MESSAGE(ApprovalReqCanceledForSelectedLinesMsg);
    END;

    PROCEDURE ApproveItemJournalLineRequest(var ItemJnlLine: Record "Item Journal Line")
    VAR
        ItemJnlBatch: Record "Item Journal Batch";
        ApprovalEntry: Record "Approval Entry";
    BEGIN
        GetItemJournalBatch(ItemJnlBatch, ItemJnlLine);
        ApproveRecordApprovalRequest(ItemJnlBatch.RECORDID);
        CLEAR(ApprovalEntry);
        IF FindOpenApprovalEntryForCurrUser(ApprovalEntry, ItemJnlLine.RECORDID) THEN
            ApproveRecordApprovalRequest(ItemJnlLine.RECORDID);
    END;

    PROCEDURE RejectItemJournalLineRequest(ItemJnlLine: Record "Item Journal Line")
    VAR
        ItemJnlBatch: Record "Item Journal Batch";
        ApprovalEntry: Record "Approval Entry";
    BEGIN
        GetItemJournalBatch(ItemJnlBatch, ItemJnlLine);
        IF FindOpenApprovalEntryForCurrUser(ApprovalEntry, ItemJnlBatch.RECORDID) THEN
            RejectRecordApprovalRequest(ItemJnlBatch.RECORDID);
        CLEAR(ApprovalEntry);
        IF FindOpenApprovalEntryForCurrUser(ApprovalEntry, ItemJnlLine.RECORDID) THEN
            RejectRecordApprovalRequest(ItemJnlLine.RECORDID);
    END;

    PROCEDURE FindOpenApprovalEntryForCurrUser(VAR ApprovalEntry: Record "Approval Entry"; RecordID: RecordID): Boolean
    BEGIN
        ApprovalEntry.SETRANGE("Table ID", RecordID.TABLENO);
        ApprovalEntry.SETRANGE("Record ID to Approve", RecordID);
        ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Open);
        ApprovalEntry.SETRANGE("Approver ID", USERID);
        ApprovalEntry.SETRANGE("Related to Change", FALSE);

        EXIT(ApprovalEntry.FINDFIRST);
    END;

    PROCEDURE ApproveRecordApprovalRequest(RecordID: RecordID)
    VAR
        ApprovalEntry: Record "Approval Entry";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    BEGIN
        IF NOT FindOpenApprovalEntryForCurrUser(ApprovalEntry, RecordID) THEN
            ERROR('There is no Approval Request to Approve');

        ApprovalEntry.SETRECFILTER;
        ApprovalsMgmt.ApproveApprovalRequests(ApprovalEntry);
    END;

    PROCEDURE RejectRecordApprovalRequest(RecordID: RecordID)
    VAR
        ApprovalEntry: Record "Approval Entry";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    BEGIN
        IF NOT FindOpenApprovalEntryForCurrUser(ApprovalEntry, RecordID) THEN
            ERROR('There is no Approval Request to Reject');

        ApprovalEntry.SETRECFILTER;
        ApprovalsMgmt.RejectApprovalRequests(ApprovalEntry);
    END;

    // Start Warehouse Physical Inventory Workflow
    PROCEDURE CheckWarehouseJournalBatchApprovalsWorkflowEnabled(var WarehouseJournalBatch: Record "Warehouse Journal Batch"): Boolean
    BEGIN
        IF NOT
           WorkflowManagement.CanExecuteWorkflow(WarehouseJournalBatch,
             WorkflowEventHandling.RunWorkflowOnSendWarehouseJournalBatchForApprovalCode)
        THEN
            ERROR(NoWorkflowEnabled);

        EXIT(TRUE);
    END;

    PROCEDURE CheckWarehouseJournalLineApprovalsWorkflowEnabled(var WarehouseJournalLine: Record "Warehouse Journal Line"): Boolean
    BEGIN
        IF NOT
           WorkflowManagement.CanExecuteWorkflow(WarehouseJournalLine,
             WorkflowEventHandling.RunWorkflowOnSendItemJournalLineForApprovalCode)
        THEN
            ERROR(NoWorkflowEnabled);

        EXIT(TRUE);
    END;

    PROCEDURE GetWarehouseJournalBatch(var WarehouseJournalBatch: Record "Warehouse Journal Batch"; var WarehouseJournalLine: Record "Warehouse Journal Line")
    BEGIN
        IF NOT WarehouseJournalBatch.GET(WarehouseJournalLine."Journal Template Name", WarehouseJournalLine."Journal Batch Name", WarehouseJournalLine."Location Code") THEN
            WarehouseJournalBatch.GET(WarehouseJournalLine.GETFILTER("Journal Template Name"), WarehouseJournalLine.GETFILTER("Journal Batch Name"), WarehouseJournalLine.GETFILTER("Location Code"));
    END;

    // PROCEDURE HasOpenApprovalEntries(RecordID: RecordID): Boolean
    // VAR
    //     ApprovalEntry: Record "Approval Entry";
    // BEGIN
    //     ApprovalEntry.SETRANGE("Table ID", RecordID.TABLENO);
    //     ApprovalEntry.SETRANGE("Record ID to Approve", RecordID);
    //     ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Open);
    //     ApprovalEntry.SETRANGE("Related to Change", FALSE);
    //     EXIT(NOT ApprovalEntry.ISEMPTY);
    // END;

    PROCEDURE HasAnyOpenWarehouseJournalLineApprovalEntries(JournalTemplateName: Code[20]; JournalBatchName: Code[20]): Boolean
    VAR
        ApprovalEntry: Record "Approval Entry";
        WarehouseJnlLine: Record "Warehouse Journal Line";
        WarehouseJnlLineRecRef: RecordRef;
        WarehouseJnlLineRecordID: RecordId;
    BEGIN
        ApprovalEntry.SETRANGE("Table ID", DATABASE::"Warehouse Journal Line");
        ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Open);
        ApprovalEntry.SETRANGE("Related to Change", FALSE);
        IF ApprovalEntry.ISEMPTY THEN
            EXIT(FALSE);

        WarehouseJnlLine.SETRANGE("Journal Template Name", JournalTemplateName);
        WarehouseJnlLine.SETRANGE("Journal Batch Name", JournalBatchName);
        IF WarehouseJnlLine.ISEMPTY THEN
            EXIT(FALSE);

        IF WarehouseJnlLine.COUNT < ApprovalEntry.COUNT THEN BEGIN
            WarehouseJnlLine.FINDSET;
            REPEAT
                IF HasOpenApprovalEntries(WarehouseJnlLine.RECORDID) THEN
                    EXIT(TRUE);
            UNTIL WarehouseJnlLine.NEXT = 0;
        END ELSE BEGIN
            ApprovalEntry.FINDSET;
            REPEAT
                WarehouseJnlLineRecordID := ApprovalEntry."Record ID to Approve";
                WarehouseJnlLineRecRef := WarehouseJnlLineRecordID.GETRECORD;
                WarehouseJnlLineRecRef.SETTABLE(WarehouseJnlLine);
                IF (WarehouseJnlLine."Journal Template Name" = JournalTemplateName) AND
                   (WarehouseJnlLine."Journal Batch Name" = JournalBatchName)
                THEN
                    EXIT(TRUE);
            UNTIL ApprovalEntry.NEXT = 0;
        END;

        EXIT(FALSE)
    END;

    // PROCEDURE HasOpenOrPendingApprovalEntries(RecordID: RecordID): Boolean
    // VAR
    //     ApprovalEntry: Record "Approval Entry";
    // BEGIN
    //     ApprovalEntry.SETRANGE("Table ID", RecordID.TABLENO);
    //     ApprovalEntry.SETRANGE("Record ID to Approve", RecordID);
    //     ApprovalEntry.SETFILTER(Status, '%1|%2', ApprovalEntry.Status::Open, ApprovalEntry.Status::Created);
    //     ApprovalEntry.SETRANGE("Related to Change", FALSE);
    //     EXIT(NOT ApprovalEntry.ISEMPTY);
    // END;


    PROCEDURE TrySendWarehouseJournalBatchApprovalRequest(VAR WarehouseJnlLine: Record "Warehouse Journal Line")
    var
        WarehouseJnlbatch: Record "Warehouse Journal Batch";
    BEGIN
        GetWarehouseJournalBatch(WarehouseJnlbatch, WarehouseJnlLine);
        CheckWarehouseJournalBatchApprovalsWorkflowEnabled(WarehouseJnlbatch);
        IF HasOpenApprovalEntries(WarehouseJnlbatch.RecordId) OR
           HasAnyOpenWarehouseJournalLineApprovalEntries(WarehouseJnlbatch."Journal Template Name", WarehouseJnlbatch.Name)
           THEN
            ERROR(PendingJournalBatchApprovalExistsErr);

        OnSendWarehouseJournalBatchForApproval(WarehouseJnlbatch);

    END;

    PROCEDURE TrySendWarehouseJournalLineApprovalRequests(VAR WarehouseJnlLine: Record "Warehouse Journal Line")
    var
        WarehouseJnlBatch: Record "Warehouse Journal Batch";
        LinesSent: Integer;
    BEGIN
        IF WarehouseJnlLine.COUNT = 1 THEN
            CheckWarehouseJournalLineApprovalsWorkflowEnabled(WarehouseJnlLine);
        REPEAT
            IF WorkflowManagement.CanExecuteWorkflow(WarehouseJnlLine,
         WorkflowEventHandling.RunWorkflowOnSendItemJournalLineForApprovalCode) AND
       NOT HasOpenApprovalEntries(WarehouseJnlLine.RECORDID)
    THEN BEGIN
                OnSendWarehouseJournalLineForApproval(WarehouseJnlLine);
                LinesSent += 1;
            END;
        UNTIL WarehouseJnlLine.NEXT = 0;
        CASE LinesSent OF
            0:
                MESSAGE(NoApprovalsSentMsg);
            WarehouseJnlLine.COUNT:
                MESSAGE(PendingApprovalForSelectedLinesMsg);
            ELSE
                MESSAGE(PendingApprovalForSomeSelectedLinesMsg);
        END;
    END;

    PROCEDURE TryCancelWarehouseJournalBatchApprovalRequest(VAR WarehouseJnlLine: Record "Warehouse Journal Line")
    VAR
        WarehouseJnlBatch: Record "Warehouse Journal Batch";
        WorkflowWebhookManagement: Codeunit "Workflow Webhook Management";
    BEGIN
        GetWarehouseJournalBatch(WarehouseJnlBatch, WarehouseJnlLine);
        OnCancelWarehouseJournalBatchApprovalRequest(WarehouseJnlBatch);
        WorkflowWebhookManagement.FindAndCancel(WarehouseJnlBatch.RecordId);
    END;

    PROCEDURE TryCancelWarehouseJournalLineApprovalRequests(VAR WarehouseJnlLine: Record "Warehouse Journal Line")
    VAR
        WorkflowWebhookManagement: Codeunit "Workflow Webhook Management";
    BEGIN
        REPEAT
            IF HasOpenApprovalEntries(WarehouseJnlLine.RECORDID) THEN
                OnCancelWarehouseJournalLineApprovalRequest(WarehouseJnlLine);
            WorkflowWebhookManagement.FindAndCancel(WarehouseJnlLine.RECORDID);
        UNTIL WarehouseJnlLine.NEXT = 0;
        MESSAGE(ApprovalReqCanceledForSelectedLinesMsg);
    END;

    PROCEDURE ApproveWarehouseJournalLineRequest(var WarehouseJnlLine: Record "Warehouse Journal Line")
    VAR
        WarehouseJnlBatch: Record "Warehouse Journal Batch";
        ApprovalEntry: Record "Approval Entry";
    BEGIN
        GetWarehouseJournalBatch(WarehouseJnlBatch, WarehouseJnlLine);
        ApproveRecordApprovalRequest(WarehouseJnlBatch.RECORDID);
        CLEAR(ApprovalEntry);
        IF FindOpenApprovalEntryForCurrUser(ApprovalEntry, WarehouseJnlLine.RECORDID) THEN
            ApproveRecordApprovalRequest(WarehouseJnlLine.RECORDID);
    END;

    PROCEDURE RejectWarehouseJournalLineRequest(WarehouseJnlLine: Record "Warehouse Journal Line")
    VAR
        WarehouseJnlBatch: Record "Warehouse Journal Batch";
        ApprovalEntry: Record "Approval Entry";
    BEGIN
        GetWarehouseJournalBatch(WarehouseJnlBatch, WarehouseJnlLine);
        IF FindOpenApprovalEntryForCurrUser(ApprovalEntry, WarehouseJnlBatch.RECORDID) THEN
            RejectRecordApprovalRequest(WarehouseJnlBatch.RECORDID);
        CLEAR(ApprovalEntry);
        IF FindOpenApprovalEntryForCurrUser(ApprovalEntry, WarehouseJnlLine.RECORDID) THEN
            RejectRecordApprovalRequest(WarehouseJnlLine.RECORDID);
    END;

    // PROCEDURE FindOpenApprovalEntryForCurrUser(VAR ApprovalEntry: Record "Approval Entry"; RecordID: RecordID): Boolean
    // BEGIN
    //     ApprovalEntry.SETRANGE("Table ID", RecordID.TABLENO);
    //     ApprovalEntry.SETRANGE("Record ID to Approve", RecordID);
    //     ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Open);
    //     ApprovalEntry.SETRANGE("Approver ID", USERID);
    //     ApprovalEntry.SETRANGE("Related to Change", FALSE);

    //     EXIT(ApprovalEntry.FINDFIRST);
    // END;

    // PROCEDURE ApproveRecordApprovalRequest(RecordID: RecordID)
    // VAR
    //     ApprovalEntry: Record "Approval Entry";
    //     ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    // BEGIN
    //     IF NOT FindOpenApprovalEntryForCurrUser(ApprovalEntry, RecordID) THEN
    //         ERROR('There is no Approval Request to Approve');

    //     ApprovalEntry.SETRECFILTER;
    //     ApprovalsMgmt.ApproveApprovalRequests(ApprovalEntry);
    // END;

    // PROCEDURE RejectRecordApprovalRequest(RecordID: RecordID)
    // VAR
    //     ApprovalEntry: Record "Approval Entry";
    //     ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    // BEGIN
    //     IF NOT FindOpenApprovalEntryForCurrUser(ApprovalEntry, RecordID) THEN
    //         ERROR('There is no Approval Request to Reject');

    //     ApprovalEntry.SETRECFILTER;
    //     ApprovalsMgmt.RejectApprovalRequests(ApprovalEntry);
    // END;

    // End Warehouse Physical Inventory Workflow
}