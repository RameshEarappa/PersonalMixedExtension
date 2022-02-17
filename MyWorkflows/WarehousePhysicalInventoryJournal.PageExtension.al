pageextension 50110 "Warehouse PhyInvJnl Ext" extends "Whse. Phys. Invt. Journal"
{
    actions
    {
        addafter("F&unctions")
        {
            group("Request Approval")
            {
                Visible = false;
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
                        begin
                            ExtendApprovalsMgmt.TrySendWarehouseJournalBatchApprovalRequest(Rec);
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
                            ExtendApprovalsMgmt.TryCancelWarehouseJournalBatchApprovalRequest(Rec);
                            SetControlAppearance;
                            SetControlAppearanceFromBatch;
                        end;
                    }
                }
            }
        }
        modify("&Register")
        {
            Visible = SetRegisterandRegisterPrint;
            TRIGGER OnBeforeAction()
            VAR
                WarehouseJnlLine: Record "Warehouse Journal Line";
                WorkflowManagement: Codeunit "Workflow Management";
                WorkflowEventHandling: Codeunit "Ext. Workflow Event Handling";
                WarehouseJnlBatch: Record "Warehouse Journal Batch";
            BEGIN
                IF
                WorkflowManagement.CanExecuteWorkflow(WarehouseJnlBatch,
                WorkflowEventHandling.RunWorkflowOnSendWarehouseJournalBatchForApprovalCode) then begin
                    WarehouseJnlLine.RESET;
                    WarehouseJnlLine.SETRANGE("Journal Template Name", Rec."Journal Template Name");
                    WarehouseJnlLine.SETRANGE("Journal Batch Name", Rec."Journal Batch Name");
                    WarehouseJnlLine.SETFILTER(Status, '%1|%2', WarehouseJnlLine.Status::Open, WarehouseJnlLine.Status::"Pending For Approval");
                    IF WarehouseJnlLine.FindFirst() THEN
                        ERROR('Status should be Approved to Register the Warehouse Physical Inventory Journal');
                END;
            END;
        }
        modify("Register and &Print")
        {
            Visible = SetRegisterandRegisterPrint;
        }
    }
    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        Clear(UserSetupG);
        if UserSetupG.Get(UserId) then
            if UserSetupG."POST Whse Phy Inv Jnl_LT" then
                SetRegisterandRegisterPrint := true
            else
                SetRegisterandRegisterPrint := false;
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
        UserSetupG: Record "User Setup";
        SetRegisterandRegisterPrint: Boolean;

    local procedure SetControlAppearanceFromBatch()
    var
        WarehouseJournalBatch: Record "Warehouse Journal Batch";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        ExtendApprovalsMgmt: Codeunit "Extend Approvals Mgmt.";
        CanRequestFlowApprovalForAllLines: Boolean;
        PIWrkFlowWebhook: Codeunit "Ext. Workflow Webhook Mgmt";
    begin
        if not WarehouseJournalBatch.Get(Rec."Journal Template Name", Rec."Journal Batch Name", Rec."Location Code") then
            exit;

        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(WarehouseJournalBatch.RecordId);
        OpenApprovalEntriesOnJnlBatchExist := ApprovalsMgmt.HasOpenApprovalEntries(WarehouseJournalBatch.RecordId);

        OpenApprovalEntriesOnBatchOrAnyJnlLineExist :=
          OpenApprovalEntriesOnJnlBatchExist or
          ExtendApprovalsMgmt.HasAnyOpenWarehouseJournalLineApprovalEntries(Rec."Journal Template Name", Rec."Journal Batch Name");

        CanCancelApprovalForJnlBatch := ApprovalsMgmt.CanCancelApprovalForRecord(WarehouseJournalBatch.RecordId);

        PIWrkFlowWebhook.GetCanRequestAndCanCancelWarehouseJournalBatch(
          WarehouseJournalBatch, CanRequestFlowApprovalForBatch, CanCancelFlowApprovalForBatch, CanRequestFlowApprovalForAllLines);
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

}