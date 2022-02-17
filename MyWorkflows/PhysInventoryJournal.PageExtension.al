pageextension 50107 PhysInventoryJnl_Ext extends "Phys. Inventory Journal"
{
    actions
    {
        addafter("F&unctions")
        {
            group("Request Approval")
            {
                Caption = 'Request Approval';
                group(SendApprovalRequest)
                {
                    Caption = 'Send Approval Request';
                    Image = SendApprovalRequest;
                    action(SendApprovalRequestJournalBatch)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Journal Batch';
                        Enabled = NOT OpenApprovalEntriesOnBatchOrAnyJnlLineExist AND CanRequestFlowApprovalForBatchAndAllLines;
                        Image = SendApprovalRequest;
                        ToolTip = 'Send all journal lines for approval, also those that you may not see because of filters.';
                        trigger OnAction()
                        var
                            ExtendApprovalsMgmt: Codeunit "Extend Approvals Mgmt.";
                            ItemJnlLine: Record "Item Journal Line";
                        begin
                            GetCurrentlySelectedLines(ItemJnlLine);
                            ExtendApprovalsMgmt.TrySendJournalBatchApprovalRequest(ItemJnlLine);
                            SetControlAppearanceFromBatch;
                            SetControlAppearance;
                        end;
                    }
                }
                group(CancelApprovalRequest)
                {
                    Caption = 'Cancel Approval Request';
                    Image = Cancel;
                    action(CancelApprovalRequestJournalBatch)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Journal Batch';
                        Enabled = CanCancelApprovalForJnlBatch OR CanCancelFlowApprovalForBatch;
                        Image = CancelApprovalRequest;
                        ToolTip = 'Cancel sending all journal lines for approval, also those that you may not see because of filters.';

                        trigger OnAction()
                        var
                            ExtendApprovalsMgmt: Codeunit "Extend Approvals Mgmt.";
                        begin
                            ExtendApprovalsMgmt.TryCancelJournalBatchApprovalRequest(Rec);
                            SetControlAppearance;
                            SetControlAppearanceFromBatch;
                        end;
                    }
                }
            }
        }
        modify("P&ost")
        {
            TRIGGER OnBeforeAction()
            VAR
                ItemJnlLine: Record "Item Journal Line";
                WorkflowManagement: Codeunit "Workflow Management";
                WorkflowEventHandling: Codeunit "Ext. Workflow Event Handling";
                ItemJournalBatch: Record "Item Journal Batch";
            BEGIN
                IF
                WorkflowManagement.CanExecuteWorkflow(ItemJournalBatch,
                WorkflowEventHandling.RunWorkflowOnSendItemJournalBatchForApprovalCode) then begin
                    ItemJnlLine.RESET;
                    ItemJnlLine.SETRANGE("Journal Template Name", Rec."Journal Template Name");
                    ItemJnlLine.SETRANGE("Journal Batch Name", Rec."Journal Batch Name");
                    ItemJnlLine.SETFILTER(Status, '%1|%2', ItemJnlLine.Status::Open, ItemJnlLine.Status::"Pending For Approval");
                    IF ItemJnlLine.FindFirst() THEN
                        ERROR('Status should be Approved to Post the Physical Inventory Journal');
                end;
            END;
        }
    }
    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        CurrentJnlBatchName := Rec."Journal Batch Name";
        SetControlAppearance;
        SetControlAppearanceFromBatch;
    end;

    trigger OnAfterGetCurrRecord()
    var
        myInt: Integer;
    begin
        SetControlAppearance;
        SetControlAppearanceFromBatch;
    end;

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        CurrentJnlBatchName := Rec."Journal Batch Name";
        SetControlAppearance;
        SetControlAppearanceFromBatch;
    end;


    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesOnJnlBatchExist: Boolean;
        OpenApprovalEntriesOnJnlLineExist: Boolean;
        OpenApprovalEntriesOnBatchOrCurrJnlLineExist: Boolean;
        OpenApprovalEntriesOnBatchOrAnyJnlLineExist: Boolean;
        CanRequestFlowApprovalForBatch: Boolean;
        CanRequestFlowApprovalForBatchAndAllLines: Boolean;
        CanRequestFlowApprovalForBatchAndCurrentLine: Boolean;
        CanCancelFlowApprovalForBatch: Boolean;
        CanCancelFlowApprovalForLine: Boolean;
        ShowWorkflowStatusOnBatch: Boolean;
        ShowWorkflowStatusOnLine: Boolean;
        CanCancelApprovalForJnlBatch: Boolean;
        CanCancelApprovalForJnlLine: Boolean;
        CurrentJnlBatchName: Code[10];

    local procedure SetControlAppearanceFromBatch()
    var
        ItemJournalBatch: Record "Item Journal Batch";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        ExtendApprovalsMgmt: Codeunit "Extend Approvals Mgmt.";
        PIWrkFlowWebhook: Codeunit "Ext. Workflow Webhook Mgmt";
        CanRequestFlowApprovalForAllLines: Boolean;
    begin
        if not ItemJournalBatch.Get(Rec."Journal Template Name", Rec."Journal Batch Name") then
            exit;

        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(ItemJournalBatch.RecordId);
        OpenApprovalEntriesOnJnlBatchExist := ApprovalsMgmt.HasOpenApprovalEntries(ItemJournalBatch.RecordId);

        OpenApprovalEntriesOnBatchOrAnyJnlLineExist :=
          OpenApprovalEntriesOnJnlBatchExist or
          ExtendApprovalsMgmt.HasAnyOpenJournalLineApprovalEntries(Rec."Journal Template Name", Rec."Journal Batch Name");

        CanCancelApprovalForJnlBatch := ApprovalsMgmt.CanCancelApprovalForRecord(ItemJournalBatch.RecordId);

        PIWrkFlowWebhook.GetCanRequestAndCanCancelJournalBatch(
          ItemJournalBatch, CanRequestFlowApprovalForBatch, CanCancelFlowApprovalForBatch, CanRequestFlowApprovalForAllLines);
        CanRequestFlowApprovalForBatchAndAllLines := CanRequestFlowApprovalForBatch and CanRequestFlowApprovalForAllLines;
    end;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        WorkflowWebhookManagement: Codeunit "Workflow Webhook Management";
        CanRequestFlowApprovalForLine: Boolean;
    begin
        OpenApprovalEntriesExistForCurrUser :=
          OpenApprovalEntriesExistForCurrUser or
          ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);

        OpenApprovalEntriesOnJnlLineExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
        OpenApprovalEntriesOnBatchOrCurrJnlLineExist := OpenApprovalEntriesOnJnlBatchExist or OpenApprovalEntriesOnJnlLineExist;

        CanCancelApprovalForJnlLine := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RecordId);

        WorkflowWebhookManagement.GetCanRequestAndCanCancel(Rec.RecordId, CanRequestFlowApprovalForLine, CanCancelFlowApprovalForLine);
        CanRequestFlowApprovalForBatchAndCurrentLine := CanRequestFlowApprovalForBatch and CanRequestFlowApprovalForLine;
    end;

    local procedure GetCurrentlySelectedLines(var ItemJnlLine: Record "Item Journal Line"): Boolean
    begin
        ItemJnlLine.CopyFilters(Rec);
        exit(ItemJnlLine.FindSet);
    end;
}