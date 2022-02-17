codeunit 50100 "Ext. Workflow Webhook Mgmt"
{
    procedure GetCanRequestAndCanCancelJournalBatch(ItemJournalBatch: Record "Item Journal Batch"; var CanRequestBatchApproval: Boolean; var CanCancelBatchApproval: Boolean; var CanRequestLineApprovals: Boolean)
    var
        ItemJournalLine: Record "Gen. Journal Line";
        WorkflowWebhookEntry: Record "Workflow Webhook Entry";
        WorkflowWebhookManagement: Codeunit "Workflow Webhook Management";
    begin
        // Helper method to check the General Journal Batch and all its lines for ability to request/cancel approval.
        // Journal pages' ribbon buttons only let users request approval for the batch or its individual lines, but not both.

        WorkflowWebhookManagement.GetCanRequestAndCanCancel(ItemJournalBatch.RecordId, CanRequestBatchApproval, CanCancelBatchApproval);

        ItemJournalLine.SetRange("Journal Template Name", ItemJournalBatch."Journal Template Name");
        ItemJournalLine.SetRange("Journal Batch Name", ItemJournalBatch.Name);
        if ItemJournalLine.IsEmpty() then begin
            CanRequestLineApprovals := true;
            exit;
        end;

        WorkflowWebhookEntry.SetRange(Response, WorkflowWebhookEntry.Response::Pending);
        if WorkflowWebhookEntry.FindSet() then
            repeat
                if ItemJournalLine.Get(WorkflowWebhookEntry."Record ID") then
                    if (ItemJournalLine."Journal Batch Name" = ItemJournalBatch.Name) and (ItemJournalLine."Journal Template Name" = ItemJournalBatch."Journal Template Name") then begin
                        CanRequestLineApprovals := false;
                        exit;
                    end;
            until WorkflowWebhookEntry.Next() = 0;

        CanRequestLineApprovals := true;
    end;

    //Warehouse Physical Inventory Journal
    procedure GetCanRequestAndCanCancelWarehouseJournalBatch(WarehouseJournalBatch: Record "Warehouse Journal Batch"; var CanRequestBatchApproval: Boolean; var CanCancelBatchApproval: Boolean; var CanRequestLineApprovals: Boolean)
    var
        WarehouseJournalLine: Record "Warehouse Journal Line";
        WorkflowWebhookEntry: Record "Workflow Webhook Entry";
        WorkflowWebhookManagement: Codeunit "Workflow Webhook Management";
    begin
        // Helper method to check the General Journal Batch and all its lines for ability to request/cancel approval.
        // Journal pages' ribbon buttons only let users request approval for the batch or its individual lines, but not both.

        WorkflowWebhookManagement.GetCanRequestAndCanCancel(WarehouseJournalBatch.RecordId, CanRequestBatchApproval, CanCancelBatchApproval);

        WarehouseJournalLine.SetRange("Journal Template Name", WarehouseJournalBatch."Journal Template Name");
        WarehouseJournalLine.SetRange("Journal Batch Name", WarehouseJournalBatch.Name);
        if WarehouseJournalLine.IsEmpty() then begin
            CanRequestLineApprovals := true;
            exit;
        end;

        WorkflowWebhookEntry.SetRange(Response, WorkflowWebhookEntry.Response::Pending);
        if WorkflowWebhookEntry.FindSet() then
            repeat
                if WarehouseJournalLine.Get(WorkflowWebhookEntry."Record ID") then
                    if (WarehouseJournalLine."Journal Batch Name" = WarehouseJournalBatch.Name) and (WarehouseJournalLine."Journal Template Name" = WarehouseJournalBatch."Journal Template Name") then begin
                        CanRequestLineApprovals := false;
                        exit;
                    end;
            until WorkflowWebhookEntry.Next() = 0;

        CanRequestLineApprovals := true;
    end;
}